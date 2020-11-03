Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FFA2A4FA3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgKCTFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgKCTFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:12 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46452074B;
        Tue,  3 Nov 2020 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604430311;
        bh=FcUM5b5zIIcbNgSiyZrMSCtOG1CxHKvZpGQJoyIJf2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6P/R/ASD6vLJQ3ct2QW51s1KD4lzM81aydDN53dHoRkNQoUwL4sYLyIsWxJsgHSW
         wTvkl6RXHOG6YlOmf8Z5R3YBlZ7IsWfdhuo1rxDbDhrvlHQFjaim+NPzSWmijE0jR0
         DEpGwnxWW6KJawvko8qi55at5hyOmUoqHsqb1s7k=
Date:   Tue, 3 Nov 2020 11:05:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: ethernet: mscc: fix missing brace warning for
 old compilers
Message-ID: <20201103110509.6bb18273@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103025519.1916-1-shipujin.t@gmail.com>
References: <20201103025519.1916-1-shipujin.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 10:55:19 +0800 Pujin Shi wrote:
> For older versions of gcc, the array = {0}; will cause warnings:

Please include the version of gcc which generates this warning here.

> drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
> drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces around initializer [-Wmissing-braces]
>     struct ocelot_vcap_u16 etype = {0};
>            ^
> drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initialization for 'etype.value') [-Wmissing-braces]
> 
> 1 warnings generated
> 
> Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
> Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
> index d8c778ee6f1b..b5167570521c 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
>  					     dport);
>  		} else {
>  			/* IPv4 "other" frame */
> -			struct ocelot_vcap_u16 etype = {0};
> +			struct ocelot_vcap_u16 etype = {{0}};

I believe Vladimir asked to use a memset instead;

			struct ocelot_vcap_u16 etype;

			memset(&etype, 0, sizeof(etype));
>  			/* Overloaded field */
>  			etype.value[0] = proto.value[0];

