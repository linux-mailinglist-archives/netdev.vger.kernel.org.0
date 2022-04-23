Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A229C50C5EF
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 03:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiDWBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 21:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 21:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A71D51A8;
        Fri, 22 Apr 2022 18:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A8F60FF7;
        Sat, 23 Apr 2022 01:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2231BC385A0;
        Sat, 23 Apr 2022 01:08:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Yy/eAe26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650676088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6AW/tHyGYH7buMqMi2HrCUPQKHLBIz8Z8Mq8CEPo14E=;
        b=Yy/eAe26VKr7OGfH2Y6VmzQOHrBaFcJLcZFxCIwoM5GuWBkc2pVHJvNsZCnWn7qW3IE260
        elg/9Ox4JG1Pse8sMQB6nuBzab/le2Ft81PiwE6ZwKadRJyrJbbMWUX6Sn6qMScxZY19r8
        ci2DLY0hWVYObTdHGli6SRfrLCitsj4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ff5900aa (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 23 Apr 2022 01:08:08 +0000 (UTC)
Date:   Sat, 23 Apr 2022 03:08:04 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     =?utf-8?Q?Charles-Fran=C3=A7ois?= Natali <cf.natali@gmail.com>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] WireGuard: restrict packet handling to non-isolated CPUs.
Message-ID: <YmNRdLy1U2N9JN2n@zx2c4.com>
References: <20220405212129.2270-1-cf.natali@gmail.com>
 <YmHwjdfZJJ2DeLTK@zx2c4.com>
 <CAH_1eM2ECPKLcHAKQ-RNf4Zj5hrgT-aJ9pjTKfChf9fnZp5Vkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH_1eM2ECPKLcHAKQ-RNf4Zj5hrgT-aJ9pjTKfChf9fnZp5Vkw@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Charles,

On Fri, Apr 22, 2022 at 11:23:01PM +0100, Charles-François Natali wrote:
> > Regarding your patch, is there a way to make that a bit more succinct,
> > without introducing all of those helper functions? It seems awfully
> > verbose for something that seems like a matter of replacing the online
> > mask with the housekeeping mask.
> 
> Indeed, I wasn't really happy about that.
> The reason I've written those helper functions is that the housekeeping mask
> includes possible CPUs (cpu_possible_mask), so unfortunately it's not just a
> matter of e.g. replacing cpu_online_mask with
> housekeeping_cpumask(HK_FLAG_DOMAIN), we have to perform an AND
> whenever we compute the weight, find the next CPU in the mask etc.
> 
> And I'd rather have the operations and mask in a single location instead of
> scattered throughout the code, to make it easier to understand and maintain.
> 
> Happy to change to something more inline though, or open to suggestions.

Probably more inlined, yea. A simpler version of your patch would
probably be something like this, right?

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 583adb37ee1e..b3117cdd647d 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -112,6 +112,8 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 		cpu = cpumask_first(cpu_online_mask);
 		for (i = 0; i < cpu_index; ++i)
 			cpu = cpumask_next(cpu, cpu_online_mask);
+		while (!housekeeping_test_cpu(cpu, HK_???))
+			cpu = cpumask_next(cpu, cpu_online_mask);
 		*stored_cpu = cpu;
 	}
 	return cpu;
@@ -128,7 +130,7 @@ static inline int wg_cpumask_next_online(int *next)
 {
 	int cpu = *next;

-	while (unlikely(!cpumask_test_cpu(cpu, cpu_online_mask)))
+	while (unlikely(!cpumask_test_cpu(cpu, cpu_online_mask) && !housekeeping_test_cpu(cpu, HK_???)))
 		cpu = cpumask_next(cpu, cpu_online_mask) % nr_cpumask_bits;
 	*next = cpumask_next(cpu, cpu_online_mask) % nr_cpumask_bits;
 	return cpu;

However, from looking at kernel/sched/isolation.c a bit, I noticed that
indeed you're right that most of these functions (save one) are based on
cpu_possible_mask rather than cpu_online_mask. This is frustrating
because the code makes smart use of static branches to remain quick, but
ANDing housekeeping_cpumask() with cpu_online_mask would, in the fast
path, wind up ANDing cpu_online_mask with cpu_possible_mask, which is
silly and pointless. That makes me suspect that maybe the best approach
would be adding a relevant helper to kernel/sched/isolation.c, so that
the helper can then do the `if (static_branch_unlikely(&housekeeping_overridden))`
stuff internally.

Or maybe you'll do some measurements and decide that just [ab]using
housekeeping_test_cpu() like above is actually optimal? Not really sure
myself.

Anyway, I'll keep an eye out for your joint wireguard/padata series. Be
sure to CC the people who wrote the isolation & housekeeping code, as
they likely have opinions about this stuff (and certainly know more than
me about it).

Jason
