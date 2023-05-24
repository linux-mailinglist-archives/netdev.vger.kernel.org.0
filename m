Return-Path: <netdev+bounces-4944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80ACF70F4DC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4688E1C20B9E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8BB1773D;
	Wed, 24 May 2023 11:13:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E62117733
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:13:08 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78FCC5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:13:06 -0700 (PDT)
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684926785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8rc08iEvRCkOiMx5BKr3Z/aUYBNVca4If2gHsEcdcQ=;
	b=o5gpCeFgllGYUy+OcxFhZUJJWFyv2zO/PxJBzTO/PnlB+EmOkpt7o2qvyMZdEU5biPQBZL
	fFe9/t+uYb/KAp1Tnlsq+qAAGnh9oq4HTtcNgXqUkCZVwrMIxq8Dz1tgaekRIRZBwpd9V+
	m4eFldaO+jXhtPzLYSipipsEYvcqeLNfwF5WScM617W9oYzwcZJTuztwn9EB4EelPSu89q
	rtgRJguaslzcOxStSt93pdJQ4gFlxHUcKKbQG46joLEbXzuXwraLCGyD/+c6FvpXw/ZuIn
	HNh7crJHi4TNqvl8IXgYqUhS+cUW1GChMVaOxd6QkfsfefZpH9JKHo9uzNb0IA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684926785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8rc08iEvRCkOiMx5BKr3Z/aUYBNVca4If2gHsEcdcQ=;
	b=fHoqn0F0279OZto1+G1TqDuZgjpjczfamjrK/3isFLiUhlPHPKb783vfQAgWO8SXypQH1g
	NcVkEpfIyUTDswDA==
To: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 2/2] intel/igb: Add a hint for threaded NAPI.
Date: Wed, 24 May 2023 13:12:59 +0200
Message-Id: <20230524111259.1323415-3-bigeasy@linutronix.de>
In-Reply-To: <20230524111259.1323415-1-bigeasy@linutronix.de>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This works only with MSIX in this version. The +1 to v_idx is because
the first vector is used for a generic interrupt (igb_msix_other) and
the NAPI interrupts/ vectors follow after that one.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index 58872a4c25401..e7e662bf965ab 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1214,6 +1214,8 @@ static int igb_alloc_q_vector(struct igb_adapter *ada=
pter,
=20
 	/* initialize NAPI */
 	netif_napi_add(adapter->netdev, &q_vector->napi, igb_poll);
+	netif_napi_add_hints(&q_vector->napi, q_vector->name,
+			     adapter->msix_entries[v_idx + 1].vector);
=20
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] =3D q_vector;
--=20
2.40.1


