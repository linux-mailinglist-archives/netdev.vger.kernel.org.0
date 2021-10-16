Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB61D430146
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbhJPIvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243872AbhJPIvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:51:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665D1C061767;
        Sat, 16 Oct 2021 01:49:23 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634374161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U23NvPBjy6Hz+FIRjnLMIc98LqFQDEb8QgF4aAwbanA=;
        b=S75VKMQCCa7/eIHouK8VukL+ChqSA8OhzXRHd8wOOzfvOJXdaSlpsnZvWODePFHBPc+Wwi
        0S4otrx5zpbX0+Lr5RHKMTd7hHpPFK8UKU/0S9CBy0wfcSC2MOEDjkx8tprSExZyA2bzo9
        p02xiMtEePsUoDLiUEW/VsDE+wkQqOuB1+1lW4beqW2Iv2CSkDDxHrmdKKtM+m9InKX6IG
        rjr/71pkSAs+bLUtm2+d1EZLUllBiMs8tZfidiql42BkYePjGmKiJdnZB9WOvyfUwSM0Co
        w82OyhQnUNIC6kSBRJ755OvWgap12o9XAZ0BGzAoqJJB3mtlyiQpJAfiidFyIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634374161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U23NvPBjy6Hz+FIRjnLMIc98LqFQDEb8QgF4aAwbanA=;
        b=LRfipEi1ReB7cxsSU1O7JaVOja5T3HKPUvQBFV9jS0k6H+QEdkfr5G7riLB62cK3pyh/EW
        cpX+Ke4a0CPpbLBQ==
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
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 5/9] u64_stats: Introduce u64_stats_set()
Date:   Sat, 16 Oct 2021 10:49:06 +0200
Message-Id: <20211016084910.4029084-6-bigeasy@linutronix.de>
In-Reply-To: <20211016084910.4029084-1-bigeasy@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

Allow to directly set a u64_stats_t value which is used to provide an init
function which sets it directly to zero intead of memset() the value.

Add u64_stats_set() to the u64_stats API.

[bigeasy: commit message. ]

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/u64_stats_sync.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index e81856c0ba134..e8ec116c916bf 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -83,6 +83,11 @@ static inline u64 u64_stats_read(const u64_stats_t *p)
 	return local64_read(&p->v);
 }
=20
+static inline void u64_stats_set(u64_stats_t *p, u64 val)
+{
+	local64_set(&p->v, val);
+}
+
 static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 {
 	local64_add(val, &p->v);
@@ -104,6 +109,11 @@ static inline u64 u64_stats_read(const u64_stats_t *p)
 	return p->v;
 }
=20
+static inline void u64_stats_set(u64_stats_t *p, u64 val)
+{
+	p->v =3D val;
+}
+
 static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 {
 	p->v +=3D val;
--=20
2.33.0

