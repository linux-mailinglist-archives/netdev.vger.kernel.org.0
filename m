Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49A134EB0
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgAHVPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:15:47 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46839 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgAHVPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:15:47 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so4752809ioi.13;
        Wed, 08 Jan 2020 13:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lOwmNDsUqawmAxi5AY455Ys+4HDKfXRmzw/uVvdXh6M=;
        b=WT3mQuxPkAm1oI83RjHOyJetl2OaXhkGLv31qd2n0UqlfvLevvpW6GDMX4/e9tEh6Y
         yA8e7cH+2JNPOjD9eyyHzpdsnUOyj/zIvJzCbOu2ZVddhuzc+LHRfEDTei4ockM8FT69
         nyOEoZdcXTE0dMbh5x7GEU6Q+NMUQSbbsJnOrmsTI1itu4A34102kCK6jH+B44s0VpMu
         wAC7Mc7QgKn/YBADOTMsuANc8QH0rEx0tWdPLgtAWqaxklnO1OqpQXPke5pzsBNAtsnn
         j+lrT3RblOijjon+LaIOkZ9f6h+p576ckPRNQfrHX12iF/v84hblPdiD4kU5Fgzs28Vz
         vBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lOwmNDsUqawmAxi5AY455Ys+4HDKfXRmzw/uVvdXh6M=;
        b=MtCmJ1jFxSfzaeutbmtBydpeBgCkNW1u7PZXMXhLsc3Z4UL72yjSb+x7vA3WfZm8t1
         nPpKiwFVNkReoZOQD7Ohox4EP1fZy+FZSoVFiY3vxxxJptSVcdZzqSOauvsAPVFpe4wP
         X1uDaQI+NR+eItiKPwObJeKwH12IJpigHI04cTxzBuwHb08xJAJG8otgtzUkM7xE0dEW
         QE7vyIcmy16SXt1MPdhP/xvkQShsZ7MOjU8X/2eQ98Yw2Yt+5kg1Ytq7ETyVt3j7XOsQ
         nUG22ooCd22sb8QLOfVyVNBUFvWh3vuJO4HCH+Tzl6hhohXjl2TMeTbnotbIdWb1diRU
         GkqA==
X-Gm-Message-State: APjAAAV1bGwPZI+6yuQaEFEATvQ8KphwpPNnSFeMxBLCtW9vkMadr6H2
        BD+HkoVmQdzMMNJ7uW/NQo+OhEos
X-Google-Smtp-Source: APXvYqzYSdu9sDVy0i9fBTEDCh7yiixLNca+RD8qMN8/paHS2EDbKvE4aNyo8L+bZUvGYj9GXZ3wjQ==
X-Received: by 2002:a02:b385:: with SMTP id p5mr5859804jan.43.1578518146687;
        Wed, 08 Jan 2020 13:15:46 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h85sm1304852ili.22.2020.01.08.13.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:15:46 -0800 (PST)
Subject: [bpf PATCH 6/9] bpf: sockmap/tls,
 tls_sw can create a plaintext buf > encrypt buf
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:15:34 +0000
Message-ID: <157851813461.1732.9406594355094857662.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to build a plaintext buffer using push helper that is larger
than the allocated encrypt buffer. When this record is pushed to crypto
layers this can result in a NULL pointer dereference because the crypto
API expects the encrypt buffer is large enough to fit the plaintext
buffer.

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

Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c |   20 ++++++++++++++++++++
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

