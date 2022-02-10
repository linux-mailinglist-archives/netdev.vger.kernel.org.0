Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194334B10FA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbiBJOxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:53:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiBJOw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:52:59 -0500
X-Greylist: delayed 13827 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 06:53:00 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4330B96;
        Thu, 10 Feb 2022 06:53:00 -0800 (PST)
Received: from [IPV6:2003:e9:d718:7a06:664f:fc39:1c1a:aa99] (p200300e9d7187a06664ffc391c1aaa99.dip0.t-ipconnect.de [IPv6:2003:e9:d718:7a06:664f:fc39:1c1a:aa99])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DFCB2C0434;
        Thu, 10 Feb 2022 15:52:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1644504777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=woAICiXlaRHnaCbGqhU6WRh9hSqXCnJr+zBk1afWk5Y=;
        b=Hj0VrcmolVGinTGiSegVceNcP89MPRiSuGcgJ5yxtnyqnrHPObplvfrGM718gMf5lYOKKx
        S2nZSaJYCKah6Bs/curcJRfTMtFdeshd+qAzvjDDDBCVau42oYemk2EAM1mdQs/c4JXvpz
        42tQ+r/lvhUh9S89whYnTh85O+ts5zOJuCxPAUqT05Vg+LYNgqNG3BgmxxECWpGEvMbM9E
        KFkWjmPna2Hf6XwRU+2J+eCGNzqSJYx4ZQ4XmUGu5MjOX5CbPWEiCZQPt6KeHGWrhIdgX2
        VCuEu7vbhHNzJ50kFVDlJEJYSOTgqjwpEXlahq8+gOwbLr/myjGf4BSCcT7YJg==
Message-ID: <75c6cf8c-c7cc-4a5e-1b54-519bf51a7540@datenfreihafen.org>
Date:   Thu, 10 Feb 2022 15:52:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH wpan-next v3 0/4] ieee802154: Improve durations handling
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 01.02.22 19:06, Miquel Raynal wrote:
> These patches try to enhance the support of the various delays by adding
> into the core the necessary logic to derive the actual symbol duration
> (and then the lifs/sifs durations) depending on the protocol used. The
> symbol duration type is also updated to fit smaller numbers.
> 
> Having the symbol durations properly set is a mandatory step in order to
> use the scanning feature that will soon be introduced.
> 
> Changes since v2:
> * Added the ca8210 driver fix.
> * Fully dropped my rework of the way channels are advertised by device
>    drivers. Adapted instead the main existing helper to derive durations
>    based on the page/channel couple.
> 
> Miquel Raynal (4):
>    net: ieee802154: ca8210: Fix lifs/sifs periods
>    net: mac802154: Convert the symbol duration into nanoseconds
>    net: mac802154: Set durations automatically
>    net: ieee802154: Drop duration settings when the core does it already
> 
>   drivers/net/ieee802154/at86rf230.c | 33 ------------------
>   drivers/net/ieee802154/atusb.c     | 33 ------------------
>   drivers/net/ieee802154/ca8210.c    |  3 --
>   drivers/net/ieee802154/mcr20a.c    |  5 ---
>   include/net/cfg802154.h            |  6 ++--
>   net/mac802154/cfg.c                |  1 +
>   net/mac802154/main.c               | 54 +++++++++++++++++++++++++++---
>   7 files changed, 55 insertions(+), 80 deletions(-)
> 


This patchset has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
