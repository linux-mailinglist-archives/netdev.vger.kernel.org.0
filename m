Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0043DEFFA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhHCORh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:17:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56924 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhHCORX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:17:23 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5i4Y2RCfAfFAxzEFzPqszjZ0rjjpiENVurGeGvivvM=;
        b=cecwzRhJuZj+i7Bqg16Fn8Aiwv+37sFwYAvLc6Co9yXkLNb538lhpx23UnXb5HHPw2jZuf
        muMdsSlXEAeqqzwCqzFogxTMWql+3LdYMzpkG57AMTiDKwemxv8dmPCL/WAk1OZ+v6ER1/
        0KnKExN+BST1br/u4GDWrfjZ+Re9SH5GkmwHaYt6IiN9sxuadjBx2N901c4WtRHZKGMeRn
        CxCpG1k7wY8sGGk4m+fMSO1u9hyPS1fTGbyVPYaeZ8tDOnqiJxXSl3XLG+K+ev3iEgLi68
        Uyi6vkbSSNi0wajGwZUB+1/OWIxZvSROFgMg3Oh3DpvJNrmlxOpuKqlYsPmAFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5i4Y2RCfAfFAxzEFzPqszjZ0rjjpiENVurGeGvivvM=;
        b=QmlxMsyeQZiVf8j7NqyG4xufJd51umRLAIJMaja7CrPrO96hG22maRpKxUudtEcy5Mkr4e
        P8305N3XN+nNBTCw==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 23/38] net: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:16:06 +0200
Message-Id: <20210803141621.780504-24-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8f1a47ad6781a..5ea4d0b34c8c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5876,7 +5876,7 @@ static void flush_all_backlogs(void)
 	 */
 	ASSERT_RTNL();
=20
-	get_online_cpus();
+	cpus_read_lock();
=20
 	cpumask_clear(&flush_cpus);
 	for_each_online_cpu(cpu) {
@@ -5894,7 +5894,7 @@ static void flush_all_backlogs(void)
 	for_each_cpu(cpu, &flush_cpus)
 		flush_work(per_cpu_ptr(&flush_works, cpu));
=20
-	put_online_cpus();
+	cpus_read_unlock();
 }
=20
 /* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
--=20
2.32.0

