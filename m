Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EBF307FD4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhA1UrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1UrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34EF564DDE;
        Thu, 28 Jan 2021 20:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611866784;
        bh=e3jWeoD821+HSdLor/WVp0v4TBVU+dT3fGr+QupoSaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WMSgjr5ZLJ9w3UHT1wWsa69RI4yZAM11obtrY9T/QRPOn6sfB5eLItFql4Y2ARVzJ
         XCV+zbWAu9J46CbJM7EBfvFfSOkfjClD8ZatrrIxJ4BUDpvD/pJD4y0QGdTTeHCdFt
         RjkxJqSbPex8tReZdnNdnwb8Sqe1hefyyYWLA4HbynZhjcacSevwpY2+/8hABwZIkv
         2KfDiRDwliAV/xvFX0sMAD9aXXWLAq7OOGlmKCSMVSisBAST94bRi8CKzeJsi5+wlH
         HL91GPKZ6HvGWF0rLbAGHAiXS7GJzQBlueIIqFYnm72AiT9DVoM9uWbnZbgNT/jAF7
         w4WnyjJZ14czQ==
Date:   Thu, 28 Jan 2021 12:46:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     liaichun <liaichun@huawei.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH net v2]bonding: fix send_peer_notif data truncation
Message-ID: <20210128124623.732154f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <eda05faf1e994f1faddb5b07007f0b93@huawei.com>
References: <eda05faf1e994f1faddb5b07007f0b93@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please make sure you CC the author of the original code.

On Wed, 27 Jan 2021 03:57:22 +0000 liaichun wrote:
> send_peer_notif is u8, the value of this parameter is obtained from
>  u8*int, it's easy to be truncated. And in practice, more than u8(256)
>   characters are used.

Did you find this through code inspection of is it really a problem?
What's your miimon setting?

> Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
> Signed-off-by: Aichun Li <liaichun@huawei.com>
> ---
>  include/net/bonding.h | 2 +-
>  drivers/net/bonding/bond_main.c | 4 ++--
>  2 file changed, 3 insertion(+), 3 deletion(-)
> 
> diff --git a/include/net/bonding.h b/include/net/bonding.h index 0960d9af7b8e..65394566d556 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -215,7 +215,7 @@ struct bonding {
>  	 */
>  	spinlock_t mode_lock;
>  	spinlock_t stats_lock;
> -	u8	 send_peer_notif;
> +	u32	 send_peer_notif;
>  	u8       igmp_retrans;
>  #ifdef CONFIG_PROC_FS
>  	struct   proc_dir_entry *proc_entry;
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c index b7db57e6c96a..336460538135 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -880,8 +880,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
>  
>  			if (netif_running(bond->dev)) {
>  				bond->send_peer_notif =
> -					bond->params.num_peer_notif *
> -					max(1, bond->params.peer_notif_delay);
> +					(u32)(bond->params.num_peer_notif *

Why do you add the cast?

> +					max(1, bond->params.peer_notif_delay));
>  				should_notify_peers =
>  					bond_should_notify_peers(bond);
>  			}
> --
> 2.19.1
> 

