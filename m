Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCC137BCB
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgAKGNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:13:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37027 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:13:09 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so4420158ioc.4;
        Fri, 10 Jan 2020 22:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5w0X58zzRAug36IcN1KmduMBJ6zMEtZzvHiQMzXnCpg=;
        b=hsBchSmKRoAw4UPYizmTfISJzJiNC6jtdteBwdp4kTCOcq+4g1b1dZqmc5P60JSgDw
         z4aO3Cmr4zwNpZD6anR060iw7qn/jRZ4WDzg6J6wV7XnZJ+niXdGQClX9RhB4f2BKrw/
         hQ06yhD5lSjsUPITQVoPHig6UA00hD7xRiGcq8jWnhY3Cl0x9nfW3And/Vb31taFsKhL
         iI3PQAITJRJPMjTTp6euCB6TN9H5WAcP/0hk1GjSKyf3n5rgNbjTf7lM5DUwTddaJFDA
         gMWqSCa6UvuUAkDE9CI8CXer3wyslTihvUzsYnCztkWIDC3yI3wVBmHMYPKDWo1BGm91
         5zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5w0X58zzRAug36IcN1KmduMBJ6zMEtZzvHiQMzXnCpg=;
        b=COPjJuoFLRtDqlW4e6tXwdLAMnX23NQJoYBOvcNAZkGE3bd/HQAoaHuKBVwqgr0p99
         KlFweYTXBRoXj27GWEgOYjGjL7kwA3FgxSY6XWVFqpBjvMwkZb5/Nc8VqBIOorP0S1hZ
         uZuzFSmhKd354YAshZ2V/QaZ18wACtW4xF1++xhzeA+ZVjGedOY6chD+sinI6Wpxomt7
         932LKX9jIgKE1bYbjziNYs5rarMnTzCsvOJTgNVl44CWzFKNyeB5GZvZlpQXOcWs5vrh
         N0L4eSTIovH4NoWcLgmQGo+pvOsNrW2lmvRMtL5S5Non8k1E1MF/5fQb/xL58Sta4hr0
         ru+w==
X-Gm-Message-State: APjAAAVcvnGj2jnHVTk0VuE8JzxcZwKY+TIEH6zOwRaKwwSCYd//OOe/
        MQCAD3MZ8QHG7YnpHIE8K8AFptoN
X-Google-Smtp-Source: APXvYqxZiLbBlCPj7OZJa1QEIDjT/1FKUd6t528dtBR4DJcMJD617RKf3z8vWNC3UDcOxrvqAiR1gw==
X-Received: by 2002:a02:3ece:: with SMTP id s197mr6135546jas.30.1578723189152;
        Fri, 10 Jan 2020 22:13:09 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:13:08 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 5/8] bpf: sockmap/tls, msg_push_data may leave end mark in place
Date:   Sat, 11 Jan 2020 06:12:03 +0000
Message-Id: <20200111061206.8028-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leaving an incorrect end mark in place when passing to crypto
layer will cause crypto layer to stop processing data before
all data is encrypted. To fix clear the end mark on push
data instead of expecting users of the helper to clear the
mark value after the fact.

This happens when we push data into the middle of a skmsg and
have room for it so we don't do a set of copies that already
clear the end flag.

Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
Cc: stable@vger.kernel.org
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index ffa2278020d7..538f6a735a19 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2415,6 +2415,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);
+		sg_unmark_end(&rsge);
 		sk_msg_iter_next(msg, end);
 	}
 
-- 
2.17.1

