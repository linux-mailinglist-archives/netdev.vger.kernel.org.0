Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFD10B74E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfK0UR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:17:59 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39901 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfK0UR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:17:59 -0500
Received: by mail-lj1-f193.google.com with SMTP id e10so16708648ljj.6
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbWpNKA4JOWw6FrvYdqB6BZTvtmb1o6ort0yRv/Qq4Q=;
        b=UnA0gXVfyTcKYFwxJwqKsTV3qScX0ucvkMHrjK3D+EL7GjuWy81nhihnVn4SZ1L1f/
         FDtIsCTrsZPm+WcflGRNPc+55zsB3pFQuvfLlC6Ct3rSGOPGlz1gbw5+MMql30r7liXg
         xZIL4HLrNpa8JYTKpoZEv5JwBXs/yB9B8BTUx0MJYGqToHT3xwz5xMTaknR04nXpA9kK
         28mVOgnuj+XpZ7Mpv3cjA8oX/1845wgtcqQMRlIe3pBD0LdA7hIGDLq18ZA97BO8wnPV
         DBSFpR0N6S+QQ5vpvjDAP4cRn+4PhMXTfDNt9F8WqQy0Z5q1/e6tk6v/WvgDQ/+v2WRJ
         9NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbWpNKA4JOWw6FrvYdqB6BZTvtmb1o6ort0yRv/Qq4Q=;
        b=A+Ji5HNG8CPXIjWDB5twkV7Z/xxgb2JatX3HhDEP6sfNp5N4RqRiStmlU2V/qaiauE
         nCNUJYN0EGyYt35KLPEeQ1v5mlrFGWZhWQTGwduT9ySoJ0ITmqeiwSMXq+UFVK7JpHRI
         7Ty2AB6RCB8Fh5OIc5ux3SLt/qrnBA5/ysA0JZ1b/zUx9iaVsGPjrzznu8ue7QSfAEW5
         Ibs8EVD9j5uIKtd86yTw9yc+AAX/CS1qXOBDPcYiUyzcR+aTwaR+IHW+4POBkfDkzNii
         GB+Ckk9Mf0vGWXhWTXrz0wL/3ArVOxWd1qkYbPi9capvHGqYFqRNp26hqTQGVbJ2b3nO
         zaDA==
X-Gm-Message-State: APjAAAVmY5/th8m/FJQ5vNolAN2t5NhPi9nAHPTPsUw1FIkuiFSIuVzi
        ZpoA2kPwLteGem3ba7voSUtjQQ==
X-Google-Smtp-Source: APXvYqz78/35Mrl0a888RrdK4S97M2/D9O9RwIXYz4ZLMfeimur3GqkKO9UZP855FGvy0sOh1f4QsA==
X-Received: by 2002:a2e:9886:: with SMTP id b6mr18930607ljj.47.1574885876760;
        Wed, 27 Nov 2019 12:17:56 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.17.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:17:56 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 1/8] net/tls: take into account that bpf_exec_tx_verdict() may free the record
Date:   Wed, 27 Nov 2019 12:16:39 -0800
Message-Id: <20191127201646.25455-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_exec_tx_verdict() may free the record if tls_push_record()
fails, or if the entire record got consumed by BPF. Re-check
ctx->open_rec before touching the data.

Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_sw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index da9f9ce51e7b..70e3c0c1af50 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -984,7 +984,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 					num_async++;
 				else if (ret == -ENOMEM)
 					goto wait_for_memory;
-				else if (ret == -ENOSPC)
+				else if (ctx->open_rec && ret == -ENOSPC)
 					goto rollback_iter;
 				else if (ret != -EAGAIN)
 					goto send_end;
@@ -1053,11 +1053,12 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
 trim_sgl:
-			tls_trim_both_msgs(sk, orig_size);
+			if (ctx->open_rec)
+				tls_trim_both_msgs(sk, orig_size);
 			goto send_end;
 		}
 
-		if (msg_en->sg.size < required_size)
+		if (ctx->open_rec && msg_en->sg.size < required_size)
 			goto alloc_encrypted;
 	}
 
@@ -1190,11 +1191,13 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 wait_for_memory:
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret) {
-			tls_trim_both_msgs(sk, msg_pl->sg.size);
+			if (ctx->open_rec)
+				tls_trim_both_msgs(sk, msg_pl->sg.size);
 			goto sendpage_end;
 		}
 
-		goto alloc_payload;
+		if (ctx->open_rec)
+			goto alloc_payload;
 	}
 
 	if (num_async) {
-- 
2.23.0

