Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185EA615254
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiKATcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKATc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:32:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A0512A83;
        Tue,  1 Nov 2022 12:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667331147; x=1698867147;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s+EqHyjaeXVSMyI36GDC5bYTToXoWUTH+2Gxwj5l6jA=;
  b=QbkGsIo/dzqitljQvuLBde2Ir+di/VTgsfXxU9RNLEzIIUtvqZV6DYrZ
   Kj5Lm7abhVyU8i9KTk4Xh9/xCCGLtzUGAK7sA/DOaKKDW/MCYEHC3Z3sO
   fMykL2mjhSJEEGLBudqrQ4r1O8bDCAve7H1jKqx/8qW2QdNkcLDPWEoDN
   Q8SNifXidUcfohYEQKNiCXc8pTloZDitIiuLw3lIddTHu4fQEtgMHHU0q
   Io5Ka+OArTuhtObPYjB83s4exlioZsdTGC1W+RrtesMJPnph2edj35M32
   OL62av+pUjLThWylWeJdvzOmG2cdZcmEYL1fM+F+UdIeVfgHJHggQHuEV
   A==;
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="184892260"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 12:32:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 12:32:17 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 12:32:14 -0700
Message-ID: <e78cd61cdac6c1abb27b16908c241fd4f8310af9.camel@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Tue, 1 Nov 2022 20:32:13 +0100
In-Reply-To: <20221101084925.7d8b7641@kernel.org>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
         <20221028144540.3344995-3-steen.hegelund@microchip.com>
         <20221031103747.uk76tudphqdo6uto@wse-c0155>
         <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
         <20221031184128.1143d51e@kernel.org>
         <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
         <20221101084925.7d8b7641@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

Thanks for the comments.

On Tue, 2022-11-01 at 08:49 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 1 Nov 2022 08:31:16 +0100 Steen Hegelund wrote:
> > > Previous series in this context means previous revision or something
> > > that was already merged?
> > 
> > Casper refers to this series (the first of the VCAP related series) that was merged on Oct 24th:
> > 
> > https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
> 
> Alright, looks like this is only in net-next so no risk of breaking
> existing users.

Yes, this is a new feature.

> 
> That said you should reject filters you can't support with an extack
> message set. Also see below.

That should also be the case.  

I just checked that using an unsupported key, action or chain will result in an extack error
message.

> 
> > > > tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
> > > 
> > > How are you using chains?
> > 
> > The chain ids are referring to the VCAP instances and their lookups.  There are some more
> > details
> > about this in the series I referred to above.
> > 
> > The short version is that this allows you to select where in the frame processing flow your rule
> > will be inserted (using ingress or egress and the chain id).
> > 
> > > I thought you need to offload FLOW_ACTION_GOTO to get to a chain,
> > > and I get no hits on this driver.
> > 
> > I have not yet added the goto action, but one use of that is to chain a filter from one VCAP
> > instance/lookup to another.
> > 
> > The goto action will be added in a soon-to-come series.  I just wanted to avoid a series getting
> > too
> > large, but on the other hand each of them should provide functionality that you can use in
> > practice.
> 
> The behavior of the offload must be the same as the SW implementation.
> It sounds like in your case it very much isn't, as adding rules to
> a magic chain in SW, without the goto will result in the rules being
> unused.

I will add the goto support to my implementation so that it will be consistent with the SW
implementation, adding a check to ensure that there is a goto action when HW offloading.

BR
Steen






