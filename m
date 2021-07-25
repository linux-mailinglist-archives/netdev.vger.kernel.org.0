Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666723D4F34
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhGYRCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhGYRCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:02:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E7C061760;
        Sun, 25 Jul 2021 10:42:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g15so8227874wrd.3;
        Sun, 25 Jul 2021 10:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tVrnpxoDkaN0jrzq6nieYy+rY5JvXq2p46DbX0cd5Uw=;
        b=AuF6gtqT897ETw4TKleI0C7pWPjtifsW7Xa2Y/eA2fWGNQ0a/If3dNrg0CMZmOXdOY
         x8rZMSPGsM4p6R3gRydFDprn5lExT3fGq+oNwZefhuQVOCT5LctIUxL4VC9W6jqZWAIG
         KxZFqB39WwVq8uDQ1emrU7vf+B/yZVU4n/vUXRwZpDKR6IyQi5EO8TqRoW76pVoUIBn8
         OPcUNe4qANMZAUmmhCWHmUMZA049yGqer2O8E5XbFLMCrkmSB+3Sbdk0L8R2tkCQQKSr
         7DFXb18hEZvXpZhwujLufo/8VfHIFocQ+HQzIlP+jYU8oXVTOE/xHJmDkWF/k0/0FvNG
         qx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tVrnpxoDkaN0jrzq6nieYy+rY5JvXq2p46DbX0cd5Uw=;
        b=CeHh3O1cK7Jpz3x9iYb6tkhlIj5ojAfWnOOu4CrB+MBhGnL1rgOeNR6spWXJgZ8dGD
         aC6DnExL8hOOCGcXW1prZipoIUhH0dwBp9N+ZkD2kW4n7nImPCHa59Ic5gcabmVRmDzc
         FaYwxv+mcqdgJb6VdXX23oRMd0V4+mHXHUjgc8LLBSKXa0VeMFZV+hRDl9Nt0Khzit1A
         Iv0lOu49vpV8gl6TA6ycdhSqtyi7TGFzygij3MkdhfsYc4ET8opMk/HS+yoo5fB2rkna
         eLBWAXvGI6W6HYzQcH6auSdaBXTAW2HIxNZ+RAvKvNh+REJ0Op5HFX7s2SUly7AVoNhp
         a2kw==
X-Gm-Message-State: AOAM532gNEcEz7S2KRkVIldt4fAAUrYBKBrpm95Z7AfTTb/Kl/z9aU4+
        /mUUlqFyNpFlHmesVdDVdXFdC/eFiX9TeQ==
X-Google-Smtp-Source: ABdhPJxV1Kbkh3xC3qtUse1tablZt+XIlSAIyyQTxUM8y09YrarbG8wOrWTsF6fuivVoQZTp+aMuaw==
X-Received: by 2002:a05:6000:1001:: with SMTP id a1mr15648653wrx.121.1627234977708;
        Sun, 25 Jul 2021 10:42:57 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x15sm1074246wrs.57.2021.07.25.10.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 10:42:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv2 net 2/2] sctp: send pmtu probe only if packet loss in Search Complete state
Date:   Sun, 25 Jul 2021 13:42:51 -0400
Message-Id: <bdfa36e82da000b725c490e8ae62194302fd85ef.1627234857.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1627234857.git.lucien.xin@gmail.com>
References: <cover.1627234857.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to introduce last_rtx_chunks into sctp_transport to detect
if there's any packet retransmission/loss happened by checking against
asoc's rtx_data_chunks in sctp_transport_pl_send().

If there is, namely, transport->last_rtx_chunks != asoc->rtx_data_chunks,
the pmtu probe will be sent out. Otherwise, increment the pl.raise_count
and return when it's in Search Complete state.

With this patch, if in Search Complete state, which is a long period, it
doesn't need to keep probing the current pmtu unless there's data packet
loss. This will save quite some traffic.

v1->v2:
  - add the missing Fixes tag.

Fixes: 0dac127c0557 ("sctp: do black hole detection in search complete state")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 net/sctp/transport.c       | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f3d414ed208e..651bba654d77 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -984,6 +984,7 @@ struct sctp_transport {
 	} cacc;
 
 	struct {
+		__u32 last_rtx_chunks;
 		__u16 pmtu;
 		__u16 probe_size;
 		__u16 probe_high;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 23e7bd3e3bd4..a3d3ca6dd63d 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -263,6 +263,7 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 	if (t->pl.probe_count < SCTP_MAX_PROBES)
 		goto out;
 
+	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
@@ -298,8 +299,10 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 
 out:
 	if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count < 30 &&
-	    !t->pl.probe_count)
+	    !t->pl.probe_count && t->pl.last_rtx_chunks == t->asoc->rtx_data_chunks) {
 		t->pl.raise_count++;
+		return false;
+	}
 
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
@@ -313,6 +316,7 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
 	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
 		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, t->pl.probe_high);
 
+	t->pl.last_rtx_chunks = t->asoc->rtx_data_chunks;
 	t->pl.pmtu = t->pl.probe_size;
 	t->pl.probe_count = 0;
 	if (t->pl.state == SCTP_PL_BASE) {
-- 
2.27.0

