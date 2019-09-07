Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0EAC4C3
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 07:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394410AbfIGFaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 01:30:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34432 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbfIGFaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 01:30:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so8564546wrn.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 22:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=58RVaXeoboEIXt5GYSoeQPQsnm9j+sWV+ds+yjKX9b8=;
        b=ppvxpbsXkrfV8HV867kL2H8pN4Hg+MX5Lb7IAfZDJwvkEpU7AvXZjkRJwg8DlequSk
         qT3Iw5PZo47EGXA9qdn4xwfjZEnpma0YuiRA5rp43wa+oVYDQRG8yOj/s0GC0ysl8y82
         k+R70Uu1w9vsL+TtOu9ryQtoeXEepUj4S+/jPUzOhcpTsC2hF4MFwlzMUqFvfE9KciEA
         87lObT93iCFTki2s36xndAOhaC8ZQ/L+RJYcBcN4jlRD3kShfhnCBFUd9yK8tZWZrl1T
         2BS0dXxoM+WKQw/XA7yqTU4bIqai3mdyw0IyuqO33N+UlogIBtvzzcTi3LQvLpBjU56S
         NkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=58RVaXeoboEIXt5GYSoeQPQsnm9j+sWV+ds+yjKX9b8=;
        b=VfyAerLvLQAJzVcR0ifT58KV+UsDt0E86rdwG7hFvXNs5SczQYaAbDx8GFO5JTpLX9
         1B3bA0Exha/zNM+uwLQAPX1lxJqGFTOwC8x9ZNo6z43iBvow9YPBCn3TyCrurHG2Nn80
         H51A9D522nd7rG1xvCgidi7Kra/qH8TJSQBWkf4yiiyqTJD/diwW4QCdYO7t05l/Hq3O
         2i3/t9dEfTzFEaFa/+NHj8Ym+L+t2GNRdl2n0qPbk+i/7+36Y11zuVLXzMmMZr3OlvAE
         lI5Ha9rb5KUJ5Ten6G09a3tew+1KgXcFNoM0rYzmybWeh+39SANajJ1quKw3dqgcJR1C
         hH/g==
X-Gm-Message-State: APjAAAXKYoMjYAEQ/XMa5KBX+q6ZwfZmuux4pvjQTsPf8TYzakHVAepF
        9OClbPNp8imR/3iwbr7POJ/RHw==
X-Google-Smtp-Source: APXvYqxvM0hknMOzboe+SYCIo9NTMons0mgF3/QPuy2XxZskjFmLI+CwMUL6dNrJfXrhO9apxNFniA==
X-Received: by 2002:adf:9043:: with SMTP id h61mr9732119wrh.247.1567834221788;
        Fri, 06 Sep 2019 22:30:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n4sm2446939wmd.45.2019.09.06.22.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:30:21 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 2/4] net/tls: use RCU for the adder to the offload record list
Date:   Fri,  6 Sep 2019 22:29:58 -0700
Message-Id: <20190907053000.23869-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907053000.23869-1-jakub.kicinski@netronome.com>
References: <20190907053000.23869-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All modifications to TLS record list happen under the socket
lock. Since records form an ordered queue readers are only
concerned about elements being removed, additions can happen
concurrently.

Use RCU primitives to ensure the correct access types
(READ_ONCE/WRITE_ONCE).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 285c9f9e94e4..b11355e00514 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -280,9 +280,7 @@ static int tls_push_record(struct sock *sk,
 
 	tls_append_frag(record, &dummy_tag_frag, prot->tag_size);
 	record->end_seq = tp->write_seq + record->len;
-	spin_lock_irq(&offload_ctx->lock);
-	list_add_tail(&record->list, &offload_ctx->records_list);
-	spin_unlock_irq(&offload_ctx->lock);
+	list_add_tail_rcu(&record->list, &offload_ctx->records_list);
 	offload_ctx->open_record = NULL;
 
 	if (test_bit(TLS_TX_SYNC_SCHED, &ctx->flags))
@@ -535,12 +533,16 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 		/* if retransmit_hint is irrelevant start
 		 * from the beggining of the list
 		 */
-		info = list_first_entry(&context->records_list,
-					struct tls_record_info, list);
+		info = list_first_entry_or_null(&context->records_list,
+						struct tls_record_info, list);
+		if (!info)
+			return NULL;
 		record_sn = context->unacked_record_sn;
 	}
 
-	list_for_each_entry_from(info, &context->records_list, list) {
+	/* We just need the _rcu for the READ_ONCE() */
+	rcu_read_lock();
+	list_for_each_entry_from_rcu(info, &context->records_list, list) {
 		if (before(seq, info->end_seq)) {
 			if (!context->retransmit_hint ||
 			    after(info->end_seq,
@@ -549,12 +551,15 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 				context->retransmit_hint = info;
 			}
 			*p_record_sn = record_sn;
-			return info;
+			goto exit_rcu_unlock;
 		}
 		record_sn++;
 	}
+	info = NULL;
 
-	return NULL;
+exit_rcu_unlock:
+	rcu_read_unlock();
+	return info;
 }
 EXPORT_SYMBOL(tls_get_record);
 
-- 
2.21.0

