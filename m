Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3453366106
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhDTUgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233724AbhDTUgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 16:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8325F613C8;
        Tue, 20 Apr 2021 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618950930;
        bh=eyKJXnO+WpD211dWVwb4xs0IRz+L057QB1SfEEUdwSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IAQvgUip0JWBKnA+TfYagv+ve8zjA3NZyOh6ASqea+WesOiz9bfxMUOphrpVIRZMZ
         PQX/USBw0Lrh3XSH9Z+f3Vk9F7Rj3Ea1851T55cKooVNOX0humZC1oMCUrfKsGBVgo
         rHp4ihk1hExTWs79pJYsgGi8HTcd9uXvrkAinG/7W5Joqzp8A2qTZwXDKkxgFHxf5c
         mAO5aA+2/AQg6jecRxes5hBWRTQY+2Kb36c7Ed5IRxogFcXIUG6yYbabnwFceCRzwv
         JceiFpRMWjppCHaUcY4u7cm3me4EOEN8LJRY9xb+CaB8wp9ke2nEqbnivY+ha2LVwd
         PAW8mnHHV2m7Q==
Date:   Tue, 20 Apr 2021 13:35:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     dlinkin@nvidia.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com
Subject: Re: [PATCH net-next 00/18] devlink: rate objects API
Message-ID: <20210420133529.4904f08b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1618918434-25520-1-git-send-email-dlinkin@nvidia.com>
References: <1618918434-25520-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 14:33:36 +0300 dlinkin@nvidia.com wrote:
> From: Dmytro Linkin <dlinkin@nvidia.com>
> 
> Currently kernel provides a way to change tx rate of single VF in
> switchdev mode via tc-police action. When lots of VFs are configured
> management of theirs rates becomes non-trivial task and some grouping
> mechanism is required. Implementing such grouping in tc-police will bring
> flow related limitations and unwanted complications, like:
> - flows requires net device to be placed on

Meaning they are only usable in "switchdev mode"?

> - effect of limiting depends on the position of tc-police action in the
>   pipeline

Could you expand? tc-police is usually expected to be first.

> - etc.

Please expand.

> According to that devlink is the most appropriate place.
> 
> This series introduces devlink API for managing tx rate of single devlink
> port or of a group by invoking callbacks (see below) of corresponding
> driver. Also devlink port or a group can be added to the parent group,
> where driver responsible to handle rates of a group elements. To achieve
> all of that new rate object is added. It can be one of the two types:
> - leaf - represents a single devlink port; created/destroyed by the
>   driver and bound to the devlink port. As example, some driver may
>   create leaf rate object for every devlink port associated with VF.
>   Since leaf have 1to1 mapping to it's devlink port, in user space it is
>   referred as pci/<bus_addr>/<port_index>;
> - node - represents a group of rate objects; created/deleted by request
>   from the userspace; initially empty (no rate objects added). In
>   userspace it is referred as pci/<bus_addr>/<node_name>, where node name
>   can be any, except decimal number, to avoid collisions with leafs.
> 
> devlink_ops extended with following callbacks:
> - rate_{leaf|node}_tx_{share|max}_set
> - rate_node_{new|del}
> - rate_{leaf|node}_parent_set

Tx is incorrect. You're setting an admission rate limiter on the port.

> KAPI provides:
> - creation/destruction of the leaf rate object associated with devlink
>   port
> - storing/retrieving driver specific data in rate object
> 
> UAPI provides:
> - dumping all or single rate objects
> - setting tx_{share|max} of rate object of any type
> - creating/deleting node rate object
> - setting/unsetting parent of any rate object

> Add devlink rate object support for netdevsim driver.
> To support devlink rate objects implement VF ports and eswitch mode
> selector for netdevsim driver.
> 
> Issues/open questions:
> - Does user need DEVLINK_CMD_RATE_DEL_ALL_CHILD command to clean all
>   children of particular parent node? For example:
>   $ devlink port func rate flush netdevsim/netdevsim10/group

Is this an RFC? There is no real user in this set.
