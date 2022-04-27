Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6C051193D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiD0NCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiD0NCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:02:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A114D608
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651064374; x=1682600374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=trRcB7e13nn/V9aAVpZFfuTb/Uc4c5QYKuFXLG2fELo=;
  b=notPxeUb4gOvb+UQCKlS6uClAcizUY/B7cnoO0lgPoRNpDrW9VriMgkB
   s/Ql+igQWhoHPUg9BYTF9trU+ly2I5Qe6KpeOPwHy2I9mz/HeMQG9oLjq
   t4TelNDM4e1Z+diPzs/+YdDUEzl7PzxfNj6sLYgziL17VJVJymoQruuot
   GjieYkemrLV4yYbXn+8AMRCnLbGukHk24vHwVy+IV0sNJpvXQbII5Z1AK
   ycNQ2VSo6O9iIlPU+XrCmEoqNKhjoNwJ73Lcd8mvirYWXToE+rifG/Dm8
   gIyI9kHYIPgLFJbmHxXqJnF9GMgcychGGSdhHlE36/93rVuc9SxyX2P5S
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="352353987"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="352353987"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 05:59:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="876458941"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 27 Apr 2022 05:59:31 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23RCxUFw025505;
        Wed, 27 Apr 2022 13:59:30 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
Date:   Wed, 27 Apr 2022 14:56:58 +0200
Message-Id: <20220427125658.3127816-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <zajec5@gmail.com>
Date: Wed, 27 Apr 2022 14:04:54 +0200

> Hi,

Hej,

> 
> I noticed years ago that kernel changes touching code - that I don't use
> at all - can affect network performance for me.
> 
> I work with home routers based on Broadcom Northstar platform. Those
> are SoCs with not-so-powerful 2 x ARM Cortex-A9 CPU cores. Main task of
> those devices is NAT masquerade and that is what I test with iperf
> running on two x86 machines.
> 
> ***
> 
> Example of such unused code change:
> ce5013ff3bec ("mtd: spi-nor: Add support for XM25QH64A and XM25QH128A").
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce5013ff3bec05cf2a8a05c75fcd520d9914d92b
> It lowered my NAT speed from 381 Mb/s to 367 Mb/s (-3,5%).
> 
> I first reported that issue it in the e-mail thread:
> ARM router NAT performance affected by random/unrelated commits
> https://lkml.org/lkml/2019/5/21/349
> https://www.spinics.net/lists/linux-block/msg40624.html
> 
> Back then it was commit 5b0890a97204 ("flow_dissector: Parse batman-adv
> unicast headers")
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9316a9ed6895c4ad2f0cde171d486f80c55d8283
> that increased my NAT speed from 741 Mb/s to 773 Mb/s (+4,3%).
> 
> ***
> 
> It appears Northstar CPUs have little cache size and so any change in
> location of kernel symbols can affect NAT performance. That explains why
> changing unrelated code affects anything & it has been partially proven
> aligning some of cache-v7.S code.
> 
> My question is: is there a way to find out & force an optimal symbols
> locations?

Take a look at CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B[0]. I've been
fighting with the same issue on some Realtek MIPS boards: random
code changes in random kernel core parts were affecting NAT /
network performance. This option resolved this I'd say, for the cost
of slightly increased vmlinux size (almost no change in vmlinuz
size).
The only thing is that it was recently restricted to a set of
architectures and MIPS and ARM32 are not included now lol. So it's
either a matter of expanding the list (since it was restricted only
because `-falign-functions=` is not supported on some architectures)
or you can just do:

make KCFLAGS=-falign-functions=64 # replace 64 with your I-cache size

The actual alignment is something to play with, I stopped on the
cacheline size, 32 in my case.
Also, this does not provide any guarantees that you won't suffer
from random data cacheline changes. There were some initiatives to
introduce debug alignment of data as well, but since function are
often bigger than 32, while variables are usually much smaller, it
was increasing the vmlinux size by a ton (imagine each u32 variable
occupying 32-64 bytes instead of 4). But the chance of catching this
is much lower than to suffer from I-cache function misplacement.

> 
> Adding .align 5 to the cache-v7.S is a partial success. I'd like to find
> out what other functions are worth optimizing (aligning) and force that
> (I guess  __attribute__((aligned(32))) could be used).
> 
> I can't really draw any conclusions from comparing System.map before and
> after above commits as they relocate thousands of symbols in one go.
> 
> Optimizing is pretty important for me for two reasons:
> 1. I want to reach maximum possible NAT masquerade performance
> 2. I need stable performance across random commits to detect regressions

[0] https://elixir.bootlin.com/linux/v5.18-rc4/K/ident/CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B

Thanks,
Al
