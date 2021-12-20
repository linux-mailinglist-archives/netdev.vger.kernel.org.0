Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8964C47B21C
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 18:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbhLTRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 12:30:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50892 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhLTRaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 12:30:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF030B81038
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 17:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8837EC36AEA
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 17:30:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fcKAqCWR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640021401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQ5wki9NSFz2DpBh2GvNG6IMNVTU0HsTQD0ndUheZLc=;
        b=fcKAqCWR+EZEp2aSy2BlFVynvDj2MtqASw80dJ79gCG7AP+VIFIyqaOzPJm9y7OV/7c+KN
        LPFhSjV3yjjOw25MZsHrVKRskJnvs00wqdr87PSQpr9g1qlxQ4JTMe60lXFjVRs90Hmpz8
        SVrxyGghDGO7G9SMFOcewUcpE2fQlXI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5e9d6903 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 20 Dec 2021 17:30:01 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id d10so31040948ybe.3
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 09:30:01 -0800 (PST)
X-Gm-Message-State: AOAM533pka0ydd1szi3F+kF7NOyk+FpBoOFNmnmq8KLzmd22bHRUxRgi
        5osHA6ViOFdvJXbTP20rlGZQxBrvNKsJN4Ty4lg=
X-Google-Smtp-Source: ABdhPJzkyeDZgRyEC0yCam6TO1TdvDfCfRTZaVXXylNELqtxND9fGfN9jT+4DKjrODQxBLeqsgczMKTluKvP0vLdR/8=
X-Received: by 2002:a25:2450:: with SMTP id k77mr24173867ybk.121.1640021400175;
 Mon, 20 Dec 2021 09:30:00 -0800 (PST)
MIME-Version: 1.0
References: <20211208173205.zajfvg6zvi4g5kln@linutronix.de>
In-Reply-To: <20211208173205.zajfvg6zvi4g5kln@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 18:29:49 +0100
X-Gmail-Original-Message-ID: <CAHmME9rzEjKg41eq5jBtsLXF+vZSEnvdomZJ-rTzx8Q=ac1ayg@mail.gmail.com>
Message-ID: <CAHmME9rzEjKg41eq5jBtsLXF+vZSEnvdomZJ-rTzx8Q=ac1ayg@mail.gmail.com>
Subject: Re: [RFC] wiregard RX packet processing.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

Seems like you've identified two things, the use of need_resched, and
potentially surrounding napi_schedule in local_bh_{disable,enable}.

Regarding need_resched, I pulled that out of other code that seemed to
have the "same requirements", as vaguely conceived. It indeed might
not be right. The intent is to have that worker running at maximum
throughput for extended periods of time, but not preventing other
threads from running elsewhere, so that, e.g., a user's machine
doesn't have a jenky mouse when downloading a file.

What are the effects of unconditionally calling cond_resched() without
checking for if (need_resched())? Sounds like you're saying none at
all?

Regarding napi_schedule, I actually wasn't aware that it's requirement
to _only_ ever run from softirq was a strict one. When I switched to
using napi_schedule in this way, throughput really jumped up
significantly. Part of this indeed is from the batching, so that the
napi callback can then handle more packets in one go later. But I
assumed it was something inside of NAPI that was batching and
scheduling it, rather than a mistake on my part to call this from a wq
and not from a softirq.

What, then, are the effects of surrounding that in
local_bh_{disable,enable} as you've done in the patch? You mentioned
one aspect is that it will "invoke wg_packet_rx_poll() where you see
only one skb." It sounds like that'd be bad for performance, though,
given that the design of napi is really geared toward batching.

Jason
