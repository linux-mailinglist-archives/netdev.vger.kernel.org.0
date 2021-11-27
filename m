Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3808460032
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 17:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbhK0Qhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 11:37:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43566 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhK0Qfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 11:35:37 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638030741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20++19QWPyUsjpenZUCm7ez/h0n8l7tkfH+uxMaAehY=;
        b=TxX5dvPWWKkN3kLUaxqMndux9D9F9bZpayusCWfAhIpUiY5N9Dtgu/Mvgxgob9K/Jdw9M/
        j8cmFYkVxZOm0lPpB94PQUVehY8y5bO5Yhmla8XHfRZcU1SKvOvXe/dIWjvoLiSML2WcZc
        zCClaxNyWT8eNi5x7rybE7Ev8Kzyn5CfFKlRp77eD4SqwxyrVWcr1B++nC/emc486g9kJ5
        IkzPIH9vrm3Bd7MH46i7quxdodv+nKAolbkPcaJQFFDjObLclAY1xMeTV58aPbthJYstNn
        iJaLDIdT64TWdZujjWFMWrD16pJmGzPp2p+4bs+OI1DDuUioxiWihZdaLti42A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638030741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20++19QWPyUsjpenZUCm7ez/h0n8l7tkfH+uxMaAehY=;
        b=qKLObmWTCjAqXBx0OJtFzrbtHgOW8nJfEtWJ+oWYDbiMNGxTkvADvuu94n8otp/1COmLLM
        FA0stFQkzPsC/4DQ==
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH doc 1/2] Documentation/locking/locktypes: Update migrate_disable() bits.
Date:   Sat, 27 Nov 2021 17:31:59 +0100
Message-Id: <20211127163200.10466-2-bigeasy@linutronix.de>
In-Reply-To: <20211127163200.10466-1-bigeasy@linutronix.de>
References: <20211127163200.10466-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial implementation of migrate_disable() for mainline was a
wrapper around preempt_disable(). RT kernels substituted this with
a real migrate disable implementation.

Later on mainline gained true migrate disable support, but the
documentation was not updated.

Update the documentation, remove the claims about migrate_disable()
mapping to preempt_disable() on non-PREEMPT_RT kernels.

Fixes: 74d862b682f51 ("sched: Make migrate_disable/enable() independent of =
RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/locking/locktypes.rst | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/locking/locktypes.rst b/Documentation/locking/lo=
cktypes.rst
index ddada4a537493..4fd7b70fcde19 100644
--- a/Documentation/locking/locktypes.rst
+++ b/Documentation/locking/locktypes.rst
@@ -439,11 +439,9 @@ not allow to acquire p->lock because get_cpu_ptr() imp=
licitly disables
   spin_lock(&p->lock);
   p->count +=3D this_cpu_read(var2);
=20
-On a non-PREEMPT_RT kernel migrate_disable() maps to preempt_disable()
-which makes the above code fully equivalent. On a PREEMPT_RT kernel
 migrate_disable() ensures that the task is pinned on the current CPU which
 in turn guarantees that the per-CPU access to var1 and var2 are staying on
-the same CPU.
+the same CPU while the task remains preemptible.
=20
 The migrate_disable() substitution is not valid for the following
 scenario::
@@ -456,9 +454,8 @@ The migrate_disable() substitution is not valid for the=
 following
     p =3D this_cpu_ptr(&var1);
     p->val =3D func2();
=20
-While correct on a non-PREEMPT_RT kernel, this breaks on PREEMPT_RT because
-here migrate_disable() does not protect against reentrancy from a
-preempting task. A correct substitution for this case is::
+This breaks because migrate_disable() does not protect against reentrancy =
from
+a preempting task. A correct substitution for this case is::
=20
   func()
   {
--=20
2.34.0

