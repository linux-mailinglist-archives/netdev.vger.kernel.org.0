Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3F137BCD
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgAKGNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:13:19 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39199 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:13:19 -0500
Received: by mail-il1-f193.google.com with SMTP id x5so3601210ila.6;
        Fri, 10 Jan 2020 22:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lvrCk0VuIjfhEPX8yFOFrXJYpOrWuYs2nDi2vn6KESg=;
        b=gwWMnaOiuxoBgcxKLKEAvtJvEuHFW0XrPAC644+641ShN2zLRMP8PJXzTeukjVTEGU
         uEDontKhlAjjazj9SBLlRIKltL2q/RmRY+O+XrMvC8OAim08ohYTY8Ng7E1Bf2IuoVWK
         KTKZnM3fqREv+u2tMfc2mXSs70fBTYy7mVjPHagAHv+1N4FdXPlaKhLWB6CNRkz0X2Ez
         e3HKxXX7lAmMRn5EilR5q5KYxs/4Mb3UOGRWZte6uldk4r6gWUYkpMk2uOPLcdQjv0X1
         llsV63KHTwBtHt3ywD19K8k9VwWndQzCDd/NlxWzLCK/4EH7cJHmp6TQYNO4QL2I1v2c
         6D4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lvrCk0VuIjfhEPX8yFOFrXJYpOrWuYs2nDi2vn6KESg=;
        b=bWDuz70nUzO4WHJKtaNQU3A5Hp2t5EmpxEfrJidUwQyX8PUTyxPuoSdR7MH2lt6hqS
         V/lactcLsTH92CqfpXrx6X7Z+UrxOGvpI297qRI/gVKlSieX5zBY8zJqHVzVlL5VsQ72
         vy4XDnUetuENUa6nsyEQyaLw89UKG2gHSEyRuYxmlTOUnk+J+l8yRvOVgxdOkrg0oDgR
         4tuHUVsnIcBnmrPUvAFXZJ2EM4CmtWCBtf4sOMfDl2soHc/fHaJOJZk7UZvfIwrseHRa
         HbhHNgsXBH+QLhUhHMt1NqhSUxs4zIF/S5/go6gmFmMps6k9naxC7o/XbzIq85cTcps1
         IY8w==
X-Gm-Message-State: APjAAAVLXUfQw6JnxcxxHjn26mxlr/16dIoEn48cbC1Y+sDfkQBmAePR
        zEqiOgvozs5fe3naPX6eBRxVSa8z
X-Google-Smtp-Source: APXvYqza7092BKt+ErtNSj3GsSktvVnFMX2TA9WRN8B7LKkXEtzMtVNMe0+h1VKHyZ63R99z+egQ9A==
X-Received: by 2002:a92:af8e:: with SMTP id v14mr5828924ill.150.1578723198895;
        Fri, 10 Jan 2020 22:13:18 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:13:18 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 6/8] bpf: sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
Date:   Sat, 11 Jan 2020 06:12:04 +0000
Message-Id: <20200111061206.8028-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to build a plaintext buffer using push helper that is larger
than the allocated encrypt buffer. When this record is pushed to crypto
layers this can result in a NULL pointer dereference because the crypto
API expects the encrypt buffer is large enough to fit the plaintext
buffer. Kernel splat below.

To resolve catch the cases this can happen and split the buffer into two
records to send individually. Unfortunately, there is still one case to
handle where the split creates a zero sized buffer. In this case we merge
the buffers and unmark the split. This happens when apply is zero and user
pushed data beyond encrypt buffer. This fixes the original case as well
because the split allocated an encrypt buffer larger than the plaintext
buffer and the merge simply moves the pointers around so we now have
a reference to the new (larger) encrypt buffer.

Perhaps its not ideal but it seems the best solution for a fixes branch
and avoids handling these two cases, (a) apply that needs split and (b)
non apply case. The are edge cases anyways so optimizing them seems not
necessary unless someone wants later in next branches.

[  306.719107] BUG: kernel NULL pointer dereference, address: 0000000000000008
[...]
[  306.747260] RIP: 0010:scatterwalk_copychunks+0x12f/0x1b0
[...]
[  306.770350] Call Trace:
[  306.770956]  scatterwalk_map_and_copy+0x6c/0x80
[  306.772026]  gcm_enc_copy_hash+0x4b/0x50
[  306.772925]  gcm_hash_crypt_remain_continue+0xef/0x110
[  306.774138]  gcm_hash_crypt_continue+0xa1/0xb0
[  306.775103]  ? gcm_hash_crypt_continue+0xa1/0xb0
[  306.776103]  gcm_hash_assoc_remain_continue+0x94/0xa0
[  306.777170]  gcm_hash_assoc_continue+0x9d/0xb0
[  306.778239]  gcm_hash_init_continue+0x8f/0xa0
[  306.779121]  gcm_hash+0x73/0x80
[  306.779762]  gcm_encrypt_continue+0x6d/0x80
[  306.780582]  crypto_gcm_encrypt+0xcb/0xe0
[  306.781474]  crypto_aead_encrypt+0x1f/0x30
[  306.782353]  tls_push_record+0x3b9/0xb20 [tls]
[  306.783314]  ? sk_psock_msg_verdict+0x199/0x300
[  306.784287]  bpf_exec_tx_verdict+0x3f2/0x680 [tls]
[  306.785357]  tls_sw_sendmsg+0x4a3/0x6a0 [tls]

test_sockmap test signature to trigger bug,

[TEST]: (1, 1, 1, sendmsg, pass,redir,start 1,end 2,pop (1,2),ktls,):

Cc: stable@vger.kernel.org
Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c6803a82b769..31f6bbbc8992 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -682,12 +682,32 @@ static int tls_push_record(struct sock *sk, int flags,
 
 	split_point = msg_pl->apply_bytes;
 	split = split_point && split_point < msg_pl->sg.size;
+	if (unlikely((!split &&
+		      msg_pl->sg.size +
+		      prot->overhead_size > msg_en->sg.size) ||
+		     (split &&
+		      split_point +
+		      prot->overhead_size > msg_en->sg.size))) {
+		split = true;
+		split_point = msg_en->sg.size;
+	}
 	if (split) {
 		rc = tls_split_open_record(sk, rec, &tmp, msg_pl, msg_en,
 					   split_point, prot->overhead_size,
 					   &orig_end);
 		if (rc < 0)
 			return rc;
+		/* This can happen if above tls_split_open_record allocates
+		 * a single large encryption buffer instead of two smaller
+		 * ones. In this case adjust pointers and continue without
+		 * split.
+		 */
+		if (!msg_pl->sg.size) {
+			tls_merge_open_record(sk, rec, tmp, orig_end);
+			msg_pl = &rec->msg_plaintext;
+			msg_en = &rec->msg_encrypted;
+			split = false;
+		}
 		sk_msg_trim(sk, msg_en, msg_pl->sg.size +
 			    prot->overhead_size);
 	}
-- 
2.17.1

