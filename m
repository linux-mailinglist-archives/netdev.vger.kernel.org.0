Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF12F5872
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhANC17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhANC16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 21:27:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AF7B235FA;
        Thu, 14 Jan 2021 02:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610591237;
        bh=9aPLMQ4TAtrEeG1rxut2Ir8PeCXrxvNYRF4299rf+bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LXtokPdQN+7abJ43w4XhUEOeb/9JpE0ysXXkcdGC4ZfFMFhC7any+KkjnuKiBajyb
         2GfnnRsZeRH+iwE/PoZhNkBLPo9VSWNL3tZTokv1KwIs27dRmZQt6eIDjhuzXEK7wj
         XYTzqarg8UrZIf8P+vXlDhz2V5S1USr4De4ZMtQrM41AfOHvzB0kTQrKlWHXrrXJ19
         70OeYnlJX2le18UIMEGnitKpTS5eVo7BwoP4msu7MIyfpV90JWoo+8/IiZnO1JGpsn
         Z1MLykq5AtwFy1mYe+L7ZzB6J4gdZpz/+Wxl1+rfPdlQeohah88Pw7+6Avg5Qs/8x9
         ZVWAAVxfXx5FA==
Date:   Wed, 13 Jan 2021 18:27:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 13:12:12 +0100 Jiri Pirko wrote:
> This patchset introduces support for modular switch systems.
> NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
> to accomodate line cards. Available line cards include:
> 16X 100GbE (QSFP28)
> 8X 200GbE (QSFP56)
> 4X 400GbE (QSFP-DD)
> 
> Similar to split cabels, it is essencial for the correctness of
> configuration and funcionality to treat the line card entities
> in the same way, no matter the line card is inserted or not.
> Meaning, the netdevice of a line card port cannot just disappear
> when line card is removed. Also, system admin needs to be able
> to apply configuration on netdevices belonging to line card port
> even before the linecard gets inserted.

I don't understand why that would be. Please provide reasoning, 
e.g. what the FW/HW limitation is.

> To resolve this, a concept of "provisioning" is introduced.
> The user may "provision" certain slot with a line card type.
> Driver then creates all instances (devlink ports, netdevices, etc)
> related to this line card type. The carrier of netdevices stays down.
> Once the line card is inserted and activated, the carrier of the
> related netdevices goes up.

Dunno what "line card" means for Mellovidia but I don't think 
the analogy of port splitting works. To my knowledge traditional
line cards often carry processors w/ full MACs etc. so I'd say 
plugging in a line card is much more like plugging in a new NIC.

There is no way to tell a breakout cable from normal one, so the
system has no chance to magically configure itself. Besides SFP
is just plugging a cable, not a module of the system.. 
