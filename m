Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99C81C92C1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgEGO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgEGO6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:58:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B54C05BD43;
        Thu,  7 May 2020 07:58:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14AF415C7D92E;
        Thu,  7 May 2020 07:58:07 -0700 (PDT)
Date:   Thu, 07 May 2020 07:58:04 -0700 (PDT)
Message-Id: <20200507.075804.1424387208635118.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        eric.dumazet@gmail.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] virtio_net: fix lockdep warning on 32 bit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507072525.355222-1-mst@redhat.com>
References: <20200507072525.355222-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 07:58:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 7 May 2020 03:25:56 -0400

> When we fill up a receive VQ, try_fill_recv currently tries to count
> kicks using a 64 bit stats counter. Turns out, on a 32 bit kernel that
> uses a seqcount. sequence counts are "lock" constructs where you need to
> make sure that writers are serialized.
> 
> In turn, this means that we mustn't run two try_fill_recv concurrently.
> Which of course we don't. We do run try_fill_recv sometimes from a
> softirq napi context, and sometimes from a fully preemptible context,
> but the later always runs with napi disabled.
> 
> However, when it comes to the seqcount, lockdep is trying to enforce the
> rule that the same lock isn't accessed from preemptible and softirq
> context - it doesn't know about napi being enabled/disabled. This causes
> a false-positive warning:
> 
> WARNING: inconsistent lock state
> ...
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> 
> As a work around, shut down the warning by switching
> to u64_stats_update_begin_irqsave - that works by disabling
> interrupts on 32 bit only, is a NOP on 64 bit.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable, thanks Michael.
