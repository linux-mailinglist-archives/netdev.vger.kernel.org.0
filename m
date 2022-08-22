Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1E59C297
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiHVPWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbiHVPWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:22:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3720559E;
        Mon, 22 Aug 2022 08:17:03 -0700 (PDT)
Date:   Mon, 22 Aug 2022 17:17:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661181421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfH8hUad6jWP6uiuYu/KbAXG3ccK+U6weU/GmP4xtvg=;
        b=Ff5yfR8MKTqcA30lf5KIppWnEDZQIQl1GO1BmXcKUZ8q8BRDfH1rxN9iFR+hwq7nPTzive
        IMt2rnJViM4Z9NQHC9KHzaK4fY+jXlfTZbNn9VeQPztcMck6rf45mQLa4nnKMWu12klJbB
        i4Lg1W6vVc22WS8YYTg0xnss0z74YEnoDIRVfYkwE/8T9K/ab893uxdZnPvZRqx4m05ziP
        GZ1ocKgs8cPNvq6Q+nqWo81HuLMO65AfUqfs0ZGDjVCUhZF1o5L/hGEs9I628TW1FiUfgE
        V8JdYMAhTuI3yq5msiNKy79SDZcY5nzLMzGpG5qCeE4gWU4gUyisVepY3WUpMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661181421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfH8hUad6jWP6uiuYu/KbAXG3ccK+U6weU/GmP4xtvg=;
        b=nFY5KRFXlHoYF7rgNaRSsazzVQh8iWRdwSwo57sPBdxa48GPQ3HogGSdPGn/f6zRYNN3u8
        YT6eVuSh1ybACCDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <YwOd7Ex7W21WzQ8N@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
 <20220817162703.728679-10-bigeasy@linutronix.de>
 <20220817112745.4efd8217@kernel.org>
 <Yv5aSquR9S2KxUr2@linutronix.de>
 <20220818090200.4c6889f2@kernel.org>
 <Yv5v1E6mfpcxjnLV@linutronix.de>
 <20220818104505.010ff950@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220818104505.010ff950@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-18 10:45:05 [-0700], Jakub Kicinski wrote:
> BTW, I have a hazy memory of people saying they switched to the _irq()
> version because it reduced the number of retries significantly under
> traffic. Dunno how practical that is but would you be willing to scan
> the git history to double check that's not some of the motivation?

I didn't find any changes like -u64_stats_fetch_begin()
+u64_stats_fetch_begin_irq() for perf reasons. Thinking about it:

- On 32bit UP u64_stats_fetch_begin() disables only preemption during
  stats read up, so the number of retries must be 0 because no seqcount
  is used.

- On 32bit UP u64_stats_fetch_begin_irq() disables interrupt during stats
  read out so the number of retries must be 0 because no seqcount is
  used.

- On 32bit SMP u64_stats_fetch_begin()/ u64_stats_fetch_begin_irq()
  keep preemption/ interrupts as-is, uses seqcount and so retries might
  be observed.

Based on that I don't see how a switch to _irq() makes a change in an
SMP build while on UP you shouldn't see a retry at all.

Using u64_stats_fetch_begin() is most likely wrong in networking because
the stats are updated while packets are received which is either in IRQ
or in BH (except maybe for the SPI/I2C ethernet driver). The _bh()
version was replaced with _irq() for netpoll reasons.
u64_stats_fetch_begin() does not disable any of those two (IRQ, BH) on
32bit-UP and does not use a seqcount so it is possible that an update
happens during the read out of stats. Let me look=E2=80=A6
	drivers/net/ethernet/cortina/gemini.c
reads in net_device_ops::ndo_get_stats64(), updates in NAPI.

	drivers/net/ethernet/huawei/hinic/hinic_rx.c
reads in net_device_ops::ndo_get_stats64() and
ethtool_ops::get_ethtool_stats(), updates in NAPI. Good.

So I guess these want be fixed properly instead of silently via the
series?

Sebastian
