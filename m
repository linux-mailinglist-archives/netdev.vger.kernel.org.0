Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969F55797C5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiGSKhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiGSKhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:37:45 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF3201B6;
        Tue, 19 Jul 2022 03:37:44 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y4so18983225edc.4;
        Tue, 19 Jul 2022 03:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P5Lup3IwuAgdbs+YWwD6h52ky2fkf3Y/Vt2tw/TKWng=;
        b=PyTrKjmUuJw+cEkSlyVr6l93dRC/1YV/gXxnzXZ+iwzPGkTYC2km6Q2LJNtF5POTkK
         vtf9iTwhdcyxE9/azJFfs1eeHFskNsc0fLZaaE/gsSZtmXac1b9x67rXlCWRcoOrdh3o
         he2kGp/V8ruWvA7VPmYhKHa6rIWM/ZBFnGv/t7PFYje7YA1XS2vbNPDONg0FLjLUw1O2
         dj2/MkxDuZe3blVjTwHaY4EI42Vtvckw9gaN9r57lLyEbR5FXw/doRLkFIs+qUXGhYGC
         2TiJLzDJ23u6yuIXnY3k37CkWmL97Q62xD/9KEOjZACVBnTuXzypXK0aHTWZte3zFhKg
         RelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P5Lup3IwuAgdbs+YWwD6h52ky2fkf3Y/Vt2tw/TKWng=;
        b=Jpm1qH92seY+htH5pK5TILqnqo6ooYBGkkOY7UrYPf6fASEhOikrXUGcJxguIFb1pa
         tKtWCpv5vi3azxz6jUj++U+nqAbDFwHUaOawcbC0a2QnRa2or58bE7JN8czesVrmWm+7
         N0fhITAPNNrjD0MQjWPRyNazyEfXV6uoUat/hvtEbOjorHwRZ/wgi4220oe15DFoSqWd
         eFkBBGz7SkYlpKaqqeVkC1xfCvyKqmoQFwdLGDc/HSYEYDGejOhRXGNFmz1vFf5Rk/pt
         gFIA+/zRNT2+n1M2nDTwqRL4edlvS0uzT2oXMkI8qOQbxPyuLHYpxhboO2slym9ARA5S
         eQig==
X-Gm-Message-State: AJIora9ZPn7/Ynz9Bx0KlAMTq252GI+1k4jaEHBXCaHp5CFNQEu7x6Bq
        5VJFHt+9lAtWViU8Blj3f9Y=
X-Google-Smtp-Source: AGRyM1sA3vGOVS4cP7/S1aeuB9I+J62DE+fUgxiQpZo/CvJs/bZxT8Qd+NEkqJWGJQmFX9gcKZXtTw==
X-Received: by 2002:a05:6402:d05:b0:435:b2a6:94eb with SMTP id eb5-20020a0564020d0500b00435b2a694ebmr42253989edb.87.1658227063270;
        Tue, 19 Jul 2022 03:37:43 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id i23-20020a056402055700b0043a2338ca10sm10124638edx.92.2022.07.19.03.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:37:42 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:37:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next 02/10] net: dsa: microchip: add common
 gigabit set and get function
Message-ID: <20220719103740.pk4cqzcfwu2byc5h@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-3-arun.ramadoss@microchip.com>
 <20220712160308.13253-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712160308.13253-3-arun.ramadoss@microchip.com>
 <20220712160308.13253-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:33:00PM +0530, Arun Ramadoss wrote:
> This patch add helper function for setting and getting the gigabit
> enable for the ksz series switch. KSZ8795 switch has different register
> address compared to all other ksz switches. KSZ8795 series uses the Port
> 5 Interface control 6 Bit 6 for configuring the 1Gbps or 100/10Mbps
> speed selection. All other switches uses the xMII control 1 0xN301
> register Bit6 for gigabit.
> Further, for KSZ8795 & KSZ9893 switches if bit 1 then 1Gbps is chosen
> and if bit 0 then 100/10Mbps is chosen. It is other way around for
> other switches bit 0 is for 1Gbps. So, this patch implements the common
> function for configuring the gigabit set and get capability.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
