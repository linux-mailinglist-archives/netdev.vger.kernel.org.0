Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ABC654834
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiLVWM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiLVWMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:12:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C1421E28;
        Thu, 22 Dec 2022 14:12:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE293B81F73;
        Thu, 22 Dec 2022 22:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F6CC433D2;
        Thu, 22 Dec 2022 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671747167;
        bh=pl0+Mxn05zTD00+BMsF+I76rO5jQsWPLZD2igIpiXXY=;
        h=From:To:Cc:Subject:Date:From;
        b=AlERWfGTWbwBdZauWN/RZxkJ09l5bGY9HtIUVqPDrw+3F53m9RF/DOPbjmi70am2L
         mdSo873ZtV6pEm437aB34PnVrPe2SErTLaka7r5NwJXFpgZjqt7r1mwCx8RN52OLgX
         pqSrpdOaXoDARbdGJmAIVbuYRJ1D4Na622QKZdtm6rljYlPEgyLaBlI5QT7IcBDIfC
         8uSOczkAE66NVvbloC40SJ2lU2RFtOl3vAUtsNkxwtwBXDdHnRmppvasF2bOAy2Rwy
         WIs/K9beEjqU3cUOiEleIJZERkSE5SD32JohVJIuqgY+0M8JYg1v7Bg+f9BfJaoM0B
         Kx32eokqazY0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     peterz@infradead.org, tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/3] softirq: uncontroversial change
Date:   Thu, 22 Dec 2022 14:12:41 -0800
Message-Id: <20221222221244.1290833-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Catching up on LWN I run across the article about softirq
changes, and then I noticed fresh patches in Peter's tree.
So probably wise for me to throw these out there.

My (can I say Meta's?) problem is the opposite to what the RT
sensitive people complain about. In the current scheme once
ksoftirqd is woken no network processing happens until it runs.

When networking gets overloaded - that's probably fair, the problem
is that we confuse latency tweaks with overload protection. We have
a needs_resched() in the loop condition (which is a latency tweak)
Most often we defer to ksoftirqd because we're trying to be nice
and let user space respond quickly, not because there is an
overload. But the user space may not be nice, and sit on the CPU
for 10ms+. Also the sirq's "work allowance" is 2ms, which is
uncomfortably close to the timer tick, but that's another story.

We have a sirq latency tracker in our prod kernel which catches
8ms+ stalls of net Tx (packets queued to the NIC but there is
no NAPI cleanup within 8ms) and with these patches applied
on 5.19 fully loaded web machine sees a drop in stalls from
1.8 stalls/sec to 0.16/sec. I also see a 50% drop in outgoing
TCP retransmissions and ~10% drop in non-TLP incoming ones.
This is not a network-heavy workload so most of the rtx are
due to scheduling artifacts.

The network latency in a datacenter is somewhere around neat
1000x lower than scheduling granularity (around 10us).

These patches (patch 2 is "the meat") change what we recognize
as overload. Instead of just checking if "ksoftirqd is woken"
it also caps how long we consider ourselves to be in overload,
a time limit which is different based on whether we yield due
to real resource exhaustion vs just hitting that needs_resched().

I hope the core concept is not entirely idiotic. It'd be great
if we could get this in or fold an equivalent concept into ongoing
work from others, because due to various "scheduler improvements"
every time we upgrade the production kernel this problem is getting
worse :(

Jakub Kicinski (3):
  softirq: rename ksoftirqd_running() -> ksoftirqd_should_handle()
  softirq: avoid spurious stalls due to need_resched()
  softirq: don't yield if only expedited handlers are pending

 kernel/softirq.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

-- 
2.38.1

