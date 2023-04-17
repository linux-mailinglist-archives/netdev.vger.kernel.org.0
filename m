Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F986E44E1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjDQKOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjDQKO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:14:29 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB17690;
        Mon, 17 Apr 2023 03:13:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dx24so18631754ejb.11;
        Mon, 17 Apr 2023 03:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681726332; x=1684318332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SfLtmsjn+24Jwv+y0uMTpgAcgZGonR8dQYvfUTmESeI=;
        b=AB2AHp53fooDJFP65B3EGwEfjtnxhcT3SBZK4tA+Oyi9fmrGYL/gi+u+16yINFKJme
         +gdQ6rkARK8d3As/QzTZObvI+R/UwIjguAzbrEuPZuVih56VWrz3iKDXGmc9wylwobT0
         5fni+Ai90yZTxYfm9iTpocYa11RqthmyyhVb91ATJ1P1YuH3niq6aMN07EkjEFSFrHte
         Qrpr24QwwAtw+8VIvEzo+AxbPGEUqg1FsnBLX5VxAaKL+kKgleq1fO/VFSHt6I/hJOb1
         yP4z9F2SIliJYER9FI817gje7wDtO/MyZyXIbsem4FTxRlbh0/SELQYFc2C2WUNgU6on
         tySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681726332; x=1684318332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfLtmsjn+24Jwv+y0uMTpgAcgZGonR8dQYvfUTmESeI=;
        b=UjExTMAcEt2aDAzJ8ULK/H102fZutvO8MdLEaif2RKClsfHTJFOi1trR9XQvAQ9TvP
         PXOB3+UrFolQF9M5vf+HR8taNzBPZa/0LL4Y9KBBCO2bMvvGsfF/+AF91jRPkGcqPxtL
         GCr8uJPddWOldgyeHq5l5oGIgBavBCdnpl9IyyC5HKvsVolR1TxLWgUj49pDHJY+n6nE
         wQZC/aOdGPshgPc6pgmV0kvv0WDfTeu9wsnjvj41NSi/B+UNIARLVH4pLRDwC6j8+dla
         lvuJ3w3SPe7QdkLAgOu/XXvioNljpJbNiVE75GUm4xpAaj0/nSq7EJUB8owHnJl8V0Rx
         J0Gw==
X-Gm-Message-State: AAQBX9cPUcxYR9sZE/Dgi2jIxdlgovgqHxsI/XPb3y4evf0R8/u5t+eg
        jz7LQOGpCebOXRVTCtOIXuE=
X-Google-Smtp-Source: AKy350bNDPOTgu/bK+fIwYt0hZJQTCtIapFZd95PX++lE2617xdy8wO4a8bezvWykCCVpk0tXbIQxQ==
X-Received: by 2002:a17:906:4708:b0:94f:764e:e311 with SMTP id y8-20020a170906470800b0094f764ee311mr2413993ejq.16.1681726331690;
        Mon, 17 Apr 2023 03:12:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f10-20020a1709064dca00b0094f2dca017fsm3038853ejw.50.2023.04.17.03.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 03:12:11 -0700 (PDT)
Date:   Mon, 17 Apr 2023 13:12:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230417101209.m5fhc7njeeomljkf@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230416165658.fuo7vwer7m7ulkg2@skbuf>
 <20230417045710.GB20350@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417045710.GB20350@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 06:57:10AM +0200, Oleksij Rempel wrote:
> > On Tue, Apr 11, 2023 at 07:24:55PM +0200, Oleksij Rempel wrote:
> > > The ACL also implements a count function, generating an interrupt
> > > instead of a forwarding action. It can be used as a watchdog timer or an
> > > event counter.
> > 
> > Is the interrupt handled here? I didn't see cls_flower_stats().
> 
> No, it is not implemented in this patch. It is generic description of things
> ACL should be able to do. Is it confusing? Should I remove it?

No, it's confusing that the ACL statistics are not reported even though
it's mentioned that it's possible...

> > Have you considered the "skbedit priority" action as opposed to hw_tc?
> 
> I had already thought of that, but since bridging is offloaded in the HW
> no skbs are involved, i thought it will be confusing. Since tc-flower seems to
> already support hw_tc remapping, I decided to use it. I hope it will not harm,
> to use it for now as mandatory option and make it optional later if other
> actions are added, including skbedit.

Well, skbedit is offloadable, so in that sense, its behavior is defined
even when no skbs are involved. OTOH, skbedit also has a software data
path (sets skb->priority), as opposed to hw_tc, which last time I checked,
did not.
