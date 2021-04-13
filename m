Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3D35E791
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348195AbhDMUWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhDMUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B895D61206;
        Tue, 13 Apr 2021 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618345304;
        bh=ypN6+Bk+fK37/Im4MRXYVfnTqwY/KPQqucTpMzf3x2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tm2UvP30Nh460NOD5QdrqV0kneGTKZJgYHN8avdwkJbgJJZkkgANAwLVvy3+4OaGa
         mPnEvjt/sM6J7L9FKjWgkUJObXzQ84rIWoK5UfFtCbuoZGFnCdBQEabhh0qMUyTab4
         9zxrVc1R97GnAu8a2wv/ZUfPsZplDn3jWz9T9RUgmppaA/KuXHJnRwamMtHVpDeTko
         mpOBuWZZ//MORAmh5Psp86lUVQwpDfQmwXHSqhZH23tWlAclC7Zj5ouW6+pS0fs0a+
         vxQdjgVsuqQ4Ro7A3ZHifq+ACMageZW4WtM4oluQjfQ286LSrXxVse4S6bQsiaExZ+
         bM4JJayi3efnA==
Date:   Tue, 13 Apr 2021 13:21:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 01/16] net/mlx5: E-Switch, let user to enable disable
 metadata
Message-ID: <20210413132142.0e2d1752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413193006.21650-2-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
        <20210413193006.21650-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 12:29:51 -0700 Saeed Mahameed wrote:
> Currently each packet inserted in eswitch is tagged with a internal
> metadata to indicate source vport. Metadata tagging is not always
> needed. Metadata insertion is needed for multi-port RoCE, failover
> between representors and stacked devices. In many other cases,
> metadata enablement is not needed.
> 
> Metadata insertion slows down the packet processing rate.

Can you share example numbers?

> Hence, allow user to disable metadata using driver specific devlink
> parameter.
> 
> Example to show and disable metadata before changing eswitch mode:
> $ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
> pci/0000:06:00.0:
>   name esw_port_metadata type driver-specific
>     values:
>       cmode runtime value true
> 
> $ devlink dev param set pci/0000:06:00.0 \
> 	  name esw_port_metadata value false cmode runtime
> 
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

Is this something that only gets enabled when device is put into
switchdev mode? That needs to be clarified in the documentation IMO 
to give peace of mind to all users who don't enable switchdev.
