Return-Path: <netdev+bounces-3143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2EC705C50
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7AFC1C20C58
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C283A17CB;
	Wed, 17 May 2023 01:22:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389617C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:22:10 +0000 (UTC)
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FF9E43;
	Tue, 16 May 2023 18:22:06 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-7577ef2fa31so530558985a.0;
        Tue, 16 May 2023 18:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684286525; x=1686878525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nWDOYoEOENaCuKkbv0XCsl1s2LHOOoRO/TQzW6p4pII=;
        b=bKiLXjn9Gryij1sauP+d3e7M5sMQDT8qWNR3ZX2KFN5Es3D4gy3FddvNeQqTrnBqe6
         KUUEci+Cj9Z/XSvcIkCF0J6dimA3ASTw2SXLZU5wO1tNoT1cFRuTcMTjYGJLVNVyCPt1
         T2OhHepL3lf93Uvs9KXKIkRq/6hiuDYIjeCkEINU1+dgSCQrpBsbEA1FWxNehYiTvqx1
         iYBdJFSDLQ4ur9VoYSSDcKiEOBRi4zKiUXaauvpMa8sUbahA5PDQEuV4ce4xOCXCjWvb
         YYCVqyRY0kJiWVSoBZAzjNvpCEIONIa5Rn15UAwAzr1lFw7Q2RnRlPgV/zJzSEpvkJmz
         7CIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684286525; x=1686878525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWDOYoEOENaCuKkbv0XCsl1s2LHOOoRO/TQzW6p4pII=;
        b=T/5MdiurpuCS/rc8mAmpJTG328QSUuKKU2tg/JJKeK1pcxTymxNk5S81D5jVv5ca6C
         DDehaoGjJsRRyWOd6Ikgz8iU9BRGfgEG5CuPxwlyCzocEySF5j6pKA/c82fl8aNYYm1e
         eIHYlixPYfklab2KbPcAANZHA9qoEcTB6h1uLl7683cIlqkPfouJqkaiUV95RxBvYkLX
         mEsC3Om9b2Ql2h5ZqBHubcQQUaz8d0mjUaiYgMEDNq3OD3TGrsluvmFgup6UD/F4kS5V
         BIfIIDLSCfXUEIrRP1xAy6hKfEku/p2jSRqtnzuJTWAFwSjcYTVBHF+24PZM+Unj1G7B
         v6qA==
X-Gm-Message-State: AC+VfDzNTvDPYYgRzBQS2yoFZsgWeB9pa3UUPRZmn/nYLKyK8q6PYeKI
	VQ6MO+QcieFyECHcX/fBFuukSXtUMV0=
X-Google-Smtp-Source: ACHHUZ5ZGERzwbymNH/F44jE4fHA9/ocojZX7IaTBN11IV+GgicN+7xNCY1iNwScbut+igrEgGQrlQ==
X-Received: by 2002:a05:622a:a:b0:3f3:90a8:6902 with SMTP id x10-20020a05622a000a00b003f390a86902mr1322919qtw.14.1684286524702;
        Tue, 16 May 2023 18:22:04 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e16-20020a05620a12d000b0074fafbea974sm277287qkl.2.2023.05.16.18.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 18:22:04 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix an issue that plpmtu can never go to complete state
Date: Tue, 16 May 2023 21:22:02 -0400
Message-Id: <e72cc6c6ac5699659bb550fe04ec215ba393dd48.1684286522.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When doing plpmtu probe, the probe size is growing every time when it
receives the ACK during the Search state until the probe fails. When
the failure occurs, pl.probe_high is set and it goes to the Complete
state.

However, if the link pmtu is huge, like 65535 in loopback_dev, the probe
eventually keeps using SCTP_MAX_PLPMTU as the probe size and never fails.
Because of that, pl.probe_high can not be set, and the plpmtu probe can
never go to the Complete state.

Fix it by setting pl.probe_high to SCTP_MAX_PLPMTU when the probe size
grows to SCTP_MAX_PLPMTU in sctp_transport_pl_recv(). Also, increase
the probe size only when the next is less than SCTP_MAX_PLPMTU.

Fixes: b87641aff9e7 ("sctp: do state transition when a probe succeeds on HB ACK recv path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 2f66a2006517..b0ccfaa4c1d1 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -324,9 +324,11 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 		t->pl.probe_size += SCTP_PL_BIG_STEP;
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
 		if (!t->pl.probe_high) {
-			t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
-					       SCTP_MAX_PLPMTU);
-			return false;
+			if (t->pl.probe_size + SCTP_PL_BIG_STEP < SCTP_MAX_PLPMTU) {
+				t->pl.probe_size += SCTP_PL_BIG_STEP;
+				return false;
+			}
+			t->pl.probe_high = SCTP_MAX_PLPMTU;
 		}
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
@@ -341,7 +343,8 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 	} else if (t->pl.state == SCTP_PL_COMPLETE) {
 		/* Raise probe_size again after 30 * interval in Search Complete */
 		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-		t->pl.probe_size += SCTP_PL_MIN_STEP;
+		if (t->pl.probe_size + SCTP_PL_MIN_STEP < SCTP_MAX_PLPMTU)
+			t->pl.probe_size += SCTP_PL_MIN_STEP;
 	}
 
 	return t->pl.state == SCTP_PL_COMPLETE;
-- 
2.39.1


