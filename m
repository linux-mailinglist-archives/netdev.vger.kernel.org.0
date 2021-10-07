Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89A84259F8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243425AbhJGRxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:53:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38506 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243383AbhJGRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:53:06 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633629068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOMWDoD1SdKXS/QHNB7RZQwaZoX8OvnSfKd24MnYn+M=;
        b=yvBf6Q7eADeluCZtE/HRvDGSw/D2mFcxgO+4Sop7TD3hgln+vwAH6MqSpNH0bn4rXnWqqf
        AMkCEHmLD4Gg92M4XhYp/fOXKBvN0WZSMAKWjQdHnvuK7597SeNcHHOStyuA0guGUK+KNx
        FX6OFGEe+3tKpmC2WwY2+RiTRM3Kv+BTh22MzrfIzhJzVSthJEGN/vuprfIT8hJ5IkQs0d
        6+1gYr+FKbb/c4R7P5RpPzQ1S9U/eYZyHE8Jo7DOdzs2bb9CX9IxZcxose6lNaHJdmbk68
        4AghMhGxnMu5h9MY9QS3SvQOAd31+qE29FL3atFkngsJJ+8WYc7Gya9OAOC31g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633629068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOMWDoD1SdKXS/QHNB7RZQwaZoX8OvnSfKd24MnYn+M=;
        b=wpv8QHlzD47W0dYjeeqtVgqC4LzJNnwZeSECdcq79P/f9Ww0d+ACtN0m68dBOc1OXeB3J2
        fwWdzxJXcUpxlZBg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/4] gen_stats: Add instead Set the value in __gnet_stats_copy_basic().
Date:   Thu,  7 Oct 2021 19:49:58 +0200
Message-Id: <20211007175000.2334713-3-bigeasy@linutronix.de>
In-Reply-To: <20211007175000.2334713-1-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since day one __gnet_stats_copy_basic() always assigned the value to the
bstats argument overwriting the previous value.

Based on review there are five users of that function as of today:
- est_fetch_counters(), ___gnet_stats_copy_basic()
  memsets() bstats to zero, single invocation.

- mq_dump(), mqprio_dump(), mqprio_dump_class_stats()
  memsets() bstats to zero, multiple invocation but does not use the
  function due to !qdisc_is_percpu_stats().

It will probably simplify in percpu stats case if the value would be
added and not just stored.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/gen_stats.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index e491b083b3485..e12e544a7ab0f 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -143,6 +143,8 @@ __gnet_stats_copy_basic(const seqcount_t *running,
 			struct gnet_stats_basic_packed *b)
 {
 	unsigned int seq;
+	__u64 bytes =3D 0;
+	__u64 packets =3D 0;
=20
 	if (cpu) {
 		__gnet_stats_copy_basic_cpu(bstats, cpu);
@@ -151,9 +153,12 @@ __gnet_stats_copy_basic(const seqcount_t *running,
 	do {
 		if (running)
 			seq =3D read_seqcount_begin(running);
-		bstats->bytes =3D b->bytes;
-		bstats->packets =3D b->packets;
+		bytes =3D b->bytes;
+		packets =3D b->packets;
 	} while (running && read_seqcount_retry(running, seq));
+
+	bstats->bytes +=3D bytes;
+	bstats->packets +=3D packets;
 }
 EXPORT_SYMBOL(__gnet_stats_copy_basic);
=20
--=20
2.33.0

