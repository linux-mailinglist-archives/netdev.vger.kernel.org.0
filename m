Return-Path: <netdev+bounces-998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D17276FBCB1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A82B52811E7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB52639B;
	Tue,  9 May 2023 01:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A764B383
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:51:03 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37473AD23;
	Mon,  8 May 2023 18:50:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1aaebed5bd6so37148685ad.1;
        Mon, 08 May 2023 18:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683597045; x=1686189045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMTTy8Xq3DQysjr0Apwc28XqtPWPIN/Qk2iVDooviS4=;
        b=DcJ7t//ro7U/ttHMBFC9attG41EeH8VZtSXuwOroBYbJWhoKZNI4AV1KG5CeHOcRmO
         ECsAMMzBkOBp29bRrORU2z666uQHw0dYQm+6fgQkpamYB4oKMGKokl0W8OZrujBS6ltA
         oJkH2HEjJ/yL50TyNebQGtX6iXTrrOCoja74sdoYXYeZ36wllotLKdhFh6JwLGfRZJvZ
         XXy8Sfcu2kvmbNC4oHLLSbLaM40HpkKcN8u4d+BFupNEL5GNVORMOj1sRkjxxbEovwk8
         ySdD1vMNYGpJZXuXyMdszB62AKUBeDypRwSg7TaF1EN00A3P4fDhAvnQrY8Rhzixh4Cu
         sONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683597045; x=1686189045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMTTy8Xq3DQysjr0Apwc28XqtPWPIN/Qk2iVDooviS4=;
        b=LaUZsJrc4COiF5Ik6UCdJxCoWH9zTIxpGsFFxLX2L0CUa+YmbF8q0h21j2cdmSq1OM
         w0yrgcuTJ4S1joDnKAgiQlE6pgljP11IAVWtMzAKi6BK3nacigyNh3KwMjflQHG7vfIs
         mDa64VRw8eax3LXJ30ZM14WHQ5EsIQbr1ZkBjcGVGip6fa9Rdv63MT0NHGynV4NzHibA
         AMbdAggVLKRtoTbT016EeX4Cdo+hs2XhdjlVuXhXvWAGtNYnzFmq04OYywGLSz77qqO2
         NHZ1CDWqOkFyG3l+8gbb1hyJag0lJKQzmDXGjzuEHvvzUx7AyMtYNa9vLWF3tQ9yWCgP
         1tbw==
X-Gm-Message-State: AC+VfDwma+Hk9fYb5w4pEsQYz+/ZoXPTUPBG2FEhYIWvsAeuCoOjOLyS
	srRtQZC7Ny7EDuyqWiVNHO4=
X-Google-Smtp-Source: ACHHUZ4bv7//zjoXAVozZ9A4o/qCIb2Vg+jgfHItIU4zO6YD64j7Wt4dENV1GblH0pUluA5l6Rlrhw==
X-Received: by 2002:a17:902:ef96:b0:1aa:ce4d:c77d with SMTP id iz22-20020a170902ef9600b001aace4dc77dmr11830781plb.24.1683597045176;
        Mon, 08 May 2023 18:50:45 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id i12-20020a17090332cc00b001ac5896e96esm139330plr.207.2023.05.08.18.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 18:50:44 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 05/13] wifi: ath10/11/12k: Use alloc_ordered_workqueue() to create ordered workqueues
Date: Mon,  8 May 2023 15:50:24 -1000
Message-Id: <20230509015032.3768622-6-tj@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509015032.3768622-1-tj@kernel.org>
References: <20230509015032.3768622-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/ath/ath10k/qmi.c | 3 +--
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +--
 drivers/net/wireless/ath/ath12k/qmi.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 038c5903c0dc..52c1a3de8da6 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1082,8 +1082,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
 	if (ret)
 		goto err;
 
-	qmi->event_wq = alloc_workqueue("ath10k_qmi_driver_event",
-					WQ_UNBOUND, 1);
+	qmi->event_wq = alloc_ordered_workqueue("ath10k_qmi_driver_event", 0);
 	if (!qmi->event_wq) {
 		ath10k_err(ar, "failed to allocate workqueue\n");
 		ret = -EFAULT;
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index ab923e24b0a9..26b252e62909 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3256,8 +3256,7 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 		return ret;
 	}
 
-	ab->qmi.event_wq = alloc_workqueue("ath11k_qmi_driver_event",
-					   WQ_UNBOUND, 1);
+	ab->qmi.event_wq = alloc_ordered_workqueue("ath11k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath11k_err(ab, "failed to allocate workqueue\n");
 		return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 03ba245fbee9..0a7892b1a8f8 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3056,8 +3056,7 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 		return ret;
 	}
 
-	ab->qmi.event_wq = alloc_workqueue("ath12k_qmi_driver_event",
-					   WQ_UNBOUND, 1);
+	ab->qmi.event_wq = alloc_ordered_workqueue("ath12k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath12k_err(ab, "failed to allocate workqueue\n");
 		return -EFAULT;
-- 
2.40.1


