Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BCC43013B
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243865AbhJPIvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55038 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239880AbhJPIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:28 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7smp0oX2VGB4V5/laKQC/fv1i0zxC4vnqf2wih5SEw8=;
        b=I4R7gkEj91P/TGtgBV1eFl80abrZtRjmuYShsoGJvJ/apCc0d/D5tWCD7XNvK6Oue+cwNm
        tKIXLS+MnlkHaI7d0dMSQDrse37S+LL/pCVGKR6IZ3RIrIpNgJYulWVog04WY5POjTRPrh
        kqB7/5JPL0L/GP64fMOjZyLOyUqLWzDsuNN3Ie+2KhqfLz5VjE+fOKcHDx7DgeID7XqKfs
        nb6d68WLkacmTHVhUAxXFK5kD/fol8v8RgMnSqLm7LbjBxrj0ts3TWmyZ39WR52zj/dPFQ
        aycGIWsypsTjTRfvheKu5pKLdBz3aXx+xAjwy/dyoO+QkRw51loUuKzUj6jRzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7smp0oX2VGB4V5/laKQC/fv1i0zxC4vnqf2wih5SEw8=;
        b=oX/66PQo/YahxnHwATi2uUuXl+/oWnIHPHl67CT4AxXe8FSkSbERCl1/avilkvcNxn8Rxs
        /OiuBn4/YjMYYZBw==
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next 0/9] Try to simplify the gnet_stats and remove qdisc->running sequence counter.
Date:   Sat, 16 Oct 2021 10:49:01 +0200
Message-Id: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first few patches is a follow up to
    https://lore.kernel.org/all/20211007175000.2334713-1-bigeasy@linutronix=
.de/

The remaining patches (#5+) remove the seqcount_t (Qdisc::running) from
the Qdisc. The statistics (Qdisc::bstats and Qdisc::cpu_bstats) use
u64_stats_t and the "running state" is now represented by a bit in
Qdisc::state.

By removing the seqcount_t from Qdisc and decoupling the bstats
statistics from the seqcount_t it is possible to query the statistics
even if the Qdisc is running instead of waiting until it is idle again.

The try-lock like usage of the seqcount_t in qdisc_run_begin() is
problematic on PREEMPT_RT. Inside the qdisc_run_begin/end() qdisc->running
sequence counter write sections, at sch_direct_xmit(), the seqcount write
serialization lock is released then re-acquired. This is fine for !RT, beca=
use
the writer is in a BH disabled region and there is a no in-IRQ reader. For =
RT
though, BH sections are preemptible. The earlier introduced seqcount_LOCKNA=
ME_t
mechanism, which for RT the reader acquires then relesaes the write
serailization lock to avoid infinite spinning if it preempts a seqcount wri=
te
section, cannot work: the qdisc->running write serialization lock is already
intermittingly released inside the seqcount write section.

Sebastian


