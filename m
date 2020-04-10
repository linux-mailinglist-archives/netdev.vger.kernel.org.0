Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3017C1A499C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDJSAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 14:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDJSAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 14:00:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC5020801;
        Fri, 10 Apr 2020 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586541605;
        bh=OV3s/AztZP+IT4uH+J3ss3b78T0FeHDSg+nJCzxx+YI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gAX2c1hq0YiTkPp72FcV+DWmU0PkEVxD4zzqkE1DGLFMTQED2bx0aK57OvWSWjnjn
         8uPXr9ovIPNXQCX9G+LkRk/CIR0NXtEDIgbQhy3QYfsmX3GMKYNm9Beui0D4IsUnqt
         C2LcQtEhV0sF25ZGuXf5dGdcddUR/Sb9LLMUUgM4=
Date:   Fri, 10 Apr 2020 11:00:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Cc:     netdev@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        tomonori.sakita@sord.co.jp
Subject: Re: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
Message-ID: <20200410110004.04a095ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200410.121616.105939195660818175.atsushi.nemoto@sord.co.jp>
References: <20200410.121616.105939195660818175.atsushi.nemoto@sord.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Apr 2020 12:16:16 +0900 (JST) Atsushi Nemoto wrote:
> KSZ9131 will not work with some switches due to workaround for KSZ9031
> introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
> ("net/phy: micrel: Add workaround for bad autoneg").
> Use genphy_read_status instead of dedicated ksz9031_read_status.

That commit older than support for KSZ9131 itself, right?
If so we should blame this one:

Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial driver")

Yuiko, does this change look good to you?

> Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
> ---
>  drivers/net/phy/micrel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 05d20343b816..3a4d83fa52dc 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1204,7 +1204,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.driver_data	= &ksz9021_type,
>  	.probe		= kszphy_probe,
>  	.config_init	= ksz9131_config_init,
> -	.read_status	= ksz9031_read_status,
> +	.read_status	= genphy_read_status,
>  	.ack_interrupt	= kszphy_ack_interrupt,
>  	.config_intr	= kszphy_config_intr,
>  	.get_sset_count = kszphy_get_sset_count,

