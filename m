Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6D6D095C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjC3PVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjC3PVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:21:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7391710;
        Thu, 30 Mar 2023 08:20:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c18so18370309ple.11;
        Thu, 30 Mar 2023 08:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680189622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9BJN6KvGFEdtYQeDXwsGBPAtMtBePoD/1g7P1KUhX/c=;
        b=qwC2UA0fLhzbMLvZBRgkV30OtZGXFjlTkuzK/W+vR+5lm131gMRwGpPNk/pG9wrmr2
         S+wT7xyopxuNbEeKsxfMNqCeiwljp5x9fcGCbyfeXO4chfb/PeOWkVOpGGvazgM6xpzS
         yAAoK8QtRoifTLzahzcxMiT81TlXlWRWJp4EHi7NSMHIg6HqdHXl8306ttYi45RQcUFW
         blzrKfmbL87anADROIWA4C/HWYuiewFzkOXhKw9I8tJ4KgEbhPQkf99Je487GyzV9nIU
         VMZPpWhdIQOLSnccmtuj1xwM70E2Wi8BLHMzYdko3+dtV93kxpDtfrrqdoDke5qYoCG6
         J2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680189622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BJN6KvGFEdtYQeDXwsGBPAtMtBePoD/1g7P1KUhX/c=;
        b=AOYfmIVvvLc/R/s4sm8QBFt6rfBZp6qRBU4uCvEcXpQxdl7v0UPi9CT1vFZuErNx2B
         afCb+bAo0ePVEgwFXM71VEvOxLkwtDijuvEdRCVRlJ6elXfucONXZ5jqB90mBRR6Y4Kq
         kY1S40kEbTXzHsmLG8PNpCz3YJBYu2Up8p6YotpBreiwhK28KBc02xWbHrE6krk+b4a6
         zYOqeVngV942E+bJgLtt4GXwjEJnQ1HyKsgJlQow5c2NKgyM5MfQ52mSoGmbRD5c++MU
         +2Zp3SdKeYOdVU3W5fz24udAN/RUsV90KSW37B3O1K0eEf8t+R2pF4jSkaIwv7UZJpAq
         tR3Q==
X-Gm-Message-State: AAQBX9fxYsy8LCBEv3MYmKbS0mEGEXf9oDMQh6M+Ioggd/LHp4IlOs8x
        Tka4SEQSle+lIdb+EXUTA0U=
X-Google-Smtp-Source: AKy350br4StkSNKgNvDcGnehHHFVF5xuH1kYdhsE8iAgh6EQrMOwWFYjG1iBg+rAcggIp3+OVxMBmg==
X-Received: by 2002:a17:902:e2d3:b0:199:1b8a:42a8 with SMTP id l19-20020a170902e2d300b001991b8a42a8mr19616659plc.6.1680189622380;
        Thu, 30 Mar 2023 08:20:22 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id c19-20020a170902b69300b001a279237e73sm2806213pls.152.2023.03.30.08.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:20:22 -0700 (PDT)
Date:   Thu, 30 Mar 2023 18:20:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: rzn1-a5psw: disable learning for
 standalone ports
Message-ID: <20230330152008.ji5mrwbpzklylpck@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330083408.63136-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:34:08AM +0200, Clément Léger wrote:
> When port are in standalone mode, they should have learning disabled to
> avoid adding new entries in the MAC lookup table which might be used by
> other bridge ports to forward packets. While adding that, also make sure
> learning is enabled for CPU port.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Usually I prefer this kind of change to be treated as a bug and
backported to older trees, because we see reports of setups which don't
work due to it. For example, see commit 15f7cfae912e ("net: dsa:
microchip: make learning configurable and keep it off while standalone")
which has a Fixes: tag.
