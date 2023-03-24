Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE99A6C7EBD
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjCXN03 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Mar 2023 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCXN0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:26:18 -0400
X-Greylist: delayed 822 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Mar 2023 06:26:15 PDT
Received: from mail-out.aladdin-rd.ru (mail-out.aladdin-rd.ru [91.199.251.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C06512BD7;
        Fri, 24 Mar 2023 06:26:15 -0700 (PDT)
From:   Daniil Dulov <D.Dulov@aladdin.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-patches@linuxtesting.org" <lvc-patches@linuxtesting.org>
Subject: RE: [PATCH] media: dib7000p: Fix potential division by zero
Thread-Topic: [PATCH] media: dib7000p: Fix potential division by zero
Thread-Index: AQHZXlJCahOtyHS28k6Qw/NYufpjpK8JtkWAgAAy2hA=
Date:   Fri, 24 Mar 2023 13:26:13 +0000
Message-ID: <2953a53dd08247ca8b762cc9d3782c81@aladdin.ru>
References: <20230324131209.651475-1-d.dulov@aladdin.ru>
 <20230324131445.g42kvq5wzj2z3qil@skbuf>
In-Reply-To: <20230324131445.g42kvq5wzj2z3qil@skbuf>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.20.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,
Sorry, I used a script with a wrong module, my fault.

-----Original Message-----
From: Vladimir Oltean [mailto:olteanv@gmail.com] 
Sent: Friday, March 24, 2023 4:15 PM
To: Daniil Dulov <D.Dulov@aladdin.ru>
Cc: Andrew Lunn <andrew@lunn.ch>; Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.com>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kurt Kanzenbach <kurt@linutronix.de>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; lvc-patches@linuxtesting.org
Subject: Re: [PATCH] media: dib7000p: Fix potential division by zero

Hi Daniil,

On Fri, Mar 24, 2023 at 06:12:09AM -0700, Daniil Dulov wrote:
> Variable loopdiv can be assigned 0, then it is used as a denominator, 
> without checking it for 0.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 713d54a8bd81 ("[media] DiB7090: add support for the dib7090 
> based")
> Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
> ---
>  drivers/media/dvb-frontends/dib7000p.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/dib7000p.c 
> b/drivers/media/dvb-frontends/dib7000p.c
> index 55bee50aa871..bea5717907e7 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c
> @@ -497,7 +497,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
>  	prediv = reg_1856 & 0x3f;
>  	loopdiv = (reg_1856 >> 6) & 0x3f;
>  
> -	if ((bw != NULL) && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
> +	if (loopdiv && (bw != NULL) && (bw->pll_prediv != prediv || 
> +bw->pll_ratio != loopdiv)) {
>  		dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)\n", prediv, bw->pll_prediv, loopdiv, bw->pll_ratio);
>  		reg_1856 &= 0xf000;
>  		reg_1857 = dib7000p_read_word(state, 1857);
> --
> 2.25.1
> 

Did you send this patch to the correct recipients and mailing lists?

$ ./scripts/get_maintainer.pl drivers/media/dvb-frontends/dib7000p.c
Mauro Carvalho Chehab <mchehab@kernel.org> (maintainer:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
linux-kernel@vger.kernel.org (open list)
