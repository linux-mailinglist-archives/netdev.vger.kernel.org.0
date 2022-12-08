Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651716465BC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLHAOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLHAOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975297E409
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F0BB61D04
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB86C433C1;
        Thu,  8 Dec 2022 00:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670458458;
        bh=DCEGKLNfem1gqKLQWfU/YDoO5j0GMLKqQCcSZ2b8A/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqouEWBC6q/wzBDOTSkjENRBdq1rKIg8pJP9CNahvH2sgiLAUZiHnJILFJOxKCAqt
         +7s1T44xS3hKywqStYjA7SX3O1pAlS05m6SHSIh4H5+qUTmz2z/QMBFuyyBkZm4ifn
         X3navjhruZ6xDZW6nTnKRho2XHryuECxrWZdITR35zgdGFwOO9u8fuaMO3vKVdamia
         j3YoAdBUv7GJF4WCHKy+qUtAHuwVxXguWO4meGlljqZ4srR/pUHb19alvjDXenLRX4
         9g3KokwVrnITc6lkILhyHXUHtEesVSh4x+GbSHe8M+CKSWneb1c0uRnOAFi78BOelE
         MyxCykBm2fhBg==
Date:   Wed, 7 Dec 2022 16:14:16 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
Message-ID: <Y5EsWNfVQrl8Nb71@x130>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207233954.3619276-3-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 01:39, Vladimir Oltean wrote:
>In applications where the switch ports must perform 802.1X based
>authentication and are therefore locked, ATU violation interrupts are
>quite to be expected as part of normal operation. The problem is that
>they currently spam the kernel log, even if rate limited.
>

+1 

>Create a series of trace points, all derived from the same event class,
>which log these violations to the kernel's trace buffer, which is both
>much faster and much easier to ignore than printing to a serial console.
>
>I've deliberately stopped reporting the portvec, since in my experience
>it contains redundant information with the spid (port) field: portvec ==
>1 << spid.
>
>New usage model:
>
>$ trace-cmd list | grep mv88e6xxx
>mv88e6xxx
>mv88e6xxx:mv88e6xxx_atu_full_violation
>mv88e6xxx:mv88e6xxx_atu_miss_violation
>mv88e6xxx:mv88e6xxx_atu_member_violation
>mv88e6xxx:mv88e6xxx_atu_age_out_violation
>$ trace-cmd record -e mv88e6xxx sleep 10
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/dsa/mv88e6xxx/Makefile      |  4 ++
> drivers/net/dsa/mv88e6xxx/global1_atu.c | 21 ++++----
> drivers/net/dsa/mv88e6xxx/trace.c       |  6 +++
> drivers/net/dsa/mv88e6xxx/trace.h       | 68 +++++++++++++++++++++++++
> 4 files changed, 87 insertions(+), 12 deletions(-)
> create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
> create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h
>
>diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
>index c8eca2b6f959..49bf358b9c4f 100644
>--- a/drivers/net/dsa/mv88e6xxx/Makefile
>+++ b/drivers/net/dsa/mv88e6xxx/Makefile
>@@ -15,3 +15,7 @@ mv88e6xxx-objs += port_hidden.o
> mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
> mv88e6xxx-objs += serdes.o
> mv88e6xxx-objs += smi.o
>+mv88e6xxx-objs += trace.o
>+
>+# for tracing framework to find trace.h
>+CFLAGS_trace.o := -I$(src)
>diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>index a9e2ff7d0e52..6ba65b723b42 100644
>--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
>+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>@@ -12,6 +12,7 @@
>
> #include "chip.h"
> #include "global1.h"
>+#include "trace.h"
>
> /* Offset 0x01: ATU FID Register */
>
>@@ -429,29 +430,25 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
> 	spid = entry.state;
>
> 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
>-		dev_err_ratelimited(chip->dev,
>-				    "ATU age out violation for %pM fid %u\n",
>-				    entry.mac, fid);
>+		trace_mv88e6xxx_atu_age_out_violation(chip->dev, spid,
>+						      entry.mac, fid);

no stats here? tracepoints are disabled by default and this event will go
unnoticed, users usually monitor light weight indicators such as stats, then
turn on tracepoints to see what's actually happening.. 

> 	}
>

