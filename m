Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A0F513DB8
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiD1Vji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbiD1Vjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:39:36 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1648A94E9;
        Thu, 28 Apr 2022 14:36:19 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 23SLZbNQ941712;
        Thu, 28 Apr 2022 23:35:37 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 23SLZbNQ941712
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1651181737;
        bh=c1Pq3Jrgk+h775d2mAMia6SzW7+2STUMPAoo0kTjPYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+CTC1trGgnkjgtjydLf8XgjcR/GB6t3uAR0vnUKIpS/zneCSa+RHsTLTDKmmRwEX
         sasm5Blc6LPZMiUVIMz3NoinsJZdPb2oZm9Y0nv3jzv24AEx6x6T8s9Phfancvpi+H
         JSp7zsEOLlDH25qpg7xSwS9WhAvAUVbK29oAbtw0=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 23SLZabm941711;
        Thu, 28 Apr 2022 23:35:36 +0200
Date:   Thu, 28 Apr 2022 23:35:36 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <YmsIqDPjvZKbbKov@electric-eye.fr.zoreil.com>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
 <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
 <Ymh3si+MTg5i0Bnl@electric-eye.fr.zoreil.com>
 <ff2077684c4c45fca929a8f61447242b@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff2077684c4c45fca929a8f61447242b@sphcmbx02.sunplus.com.tw>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wells Lu eh
3i(0 <wells.lu@sunplus.com> :
[...]
> I will add disable_irq() and enable_irq() for spl2sw_rx_poll() and spl2sw_tx_poll() as shown below:
> 
> spl2sw_rx_poll():
> 
> 	wmb();	/* make sure settings are effective. */
> 	disable_irq(comm->irq);
> 	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> 	mask &= ~MAC_INT_RX;
> 	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> 	enable_irq(comm->irq);
> 
> spl2sw_tx_poll():
> 
> 	wmb();			/* make sure settings are effective. */
> 	disable_irq(comm->irq);
> 	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> 	mask &= ~MAC_INT_TX;
> 	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> 	enable_irq(comm->irq);
> 
> 
> Is the modification ok?

disable_irq prevents future irq processing but it does not help against irq
code currently running on a different cpu.

You may use plain spin_{lock / unlock} in IRQ context and
spin_{loq_irqsave / irq_restore} in NAPI context.

-- 
Ueimor
