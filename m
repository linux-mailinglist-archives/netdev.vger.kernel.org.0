Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2E1C4261
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgEDRV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729667AbgEDRV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:21:58 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E22C061A0E;
        Mon,  4 May 2020 10:21:58 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f3so13168348ioj.1;
        Mon, 04 May 2020 10:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s/H9+2DJZoBNBbRFmfHv1JX5iVHZU3xc8Givz1NWCPU=;
        b=E5kN3Aouuzz6ulHi3FVwopK+DauXrise2ohFdQ0u2lAZrS2V0jjNG5YMww57si50th
         B5Oe8/joWpPj0IMG6DyCWCYkVIwM56+unzIGTkG0cZEKehyGcyGdYBfPygSeoS4Sq+ZY
         icazg9J+y9GeXtVDtHRHmarxlHMQg5OsfYR1XvhB7NKog4ngVBys/JZ6hU1i6/wBVcPD
         rb6DQm5uimRVjL9z4sGniBqnv1if0J7p/PfwGBJNkLJNd9hc0qGecxf98gp19T4jSMd8
         2UjwDB7mpFCg6D7wI9JD8y5Jg4ubFonnOspiiEO0ZjMkG5xCGDgeAg1oq7caM2dTgHbW
         ryyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s/H9+2DJZoBNBbRFmfHv1JX5iVHZU3xc8Givz1NWCPU=;
        b=gVYqfj3PcnHaOc++KeS37ykZ4XcBV4Mt9ZQdQaLanj4tK6VroivG3+6wT+kmNmibht
         6e8Fls8WSPkDfg86pwyGJSx1o9iZ/LkZ4zKfqq+CXR+iuyUGBc9/mXL+y/DazYziYBXJ
         oNYbCsKkdNVsKlwATbL28hfuWqghAhPs7GNCK4WzPcZFtFCz0l8N2oXkV5630HWoVLtS
         N/bJ8o0VdboQFASkB6mRcdm3s6AEY4kdY4G1+YionHtM80CvnTaSOm4ZSQ5xukXGE+Ye
         nkO0nrTYBwn2IzYoiF0r+TWI1HoMaZupHksq1qDHaKDJPMJOiTYFh+Ua/RCcMc1LfEv4
         Qk5A==
X-Gm-Message-State: AGi0PuZfPtlzT6nUszR7CmqeSCN0hrgaLkAVYV242uXu2EBlquXxzLf9
        y30Gr5B13kV37UhOusg7XrE=
X-Google-Smtp-Source: APiQypJii9n8J23C89FtzeKbngzeIo8Z029y5Ew0NBgQnqG+cIsZq1Pfk9HD37KoyWi6SS+Cyh1DYQ==
X-Received: by 2002:a02:cd01:: with SMTP id g1mr16640069jaq.131.1588612917731;
        Mon, 04 May 2020 10:21:57 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v17sm5450699ill.5.2020.05.04.10.21.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 10:21:56 -0700 (PDT)
Subject: [PATCH 2/2] bpf: sockmap,
 bpf_tcp_ingress needs to subtract bytes from sg.size
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Mon, 04 May 2020 10:21:44 -0700
Message-ID: <158861290407.14306.5327773422227552482.stgit@john-Precision-5820-Tower>
In-Reply-To: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf_tcp_ingress we used apply_bytes to subtract bytes from sg.size
which is used to track total bytes in a message. But this is not
correct because apply_bytes is itself modified in the main loop doing
the mem_charge.

Then at the end of this we have sg.size incorrectly set and out of
sync with actual sk values. Then we can get a splat if we try to
cork the data later and again try to redirect the msg to ingress. To
fix instead of trying to track msg.size do the easy thing and include
it as part of the sk_msg_xfer logic so that when the msg is moved the
sg.size is always correct.

To reproduce the below users will need ingress + cork and hit an
error path that will then try to 'free' the skmsg.

[  173.699981] BUG: KASAN: null-ptr-deref in sk_msg_free_elem+0xdd/0x120
[  173.699987] Read of size 8 at addr 0000000000000008 by task test_sockmap/5317

[  173.700000] CPU: 2 PID: 5317 Comm: test_sockmap Tainted: G          I       5.7.0-rc1+ #43
[  173.700005] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[  173.700009] Call Trace:
[  173.700021]  dump_stack+0x8e/0xcb
[  173.700029]  ? sk_msg_free_elem+0xdd/0x120
[  173.700034]  ? sk_msg_free_elem+0xdd/0x120
[  173.700042]  __kasan_report+0x102/0x15f
[  173.700052]  ? sk_msg_free_elem+0xdd/0x120
[  173.700060]  kasan_report+0x32/0x50
[  173.700070]  sk_msg_free_elem+0xdd/0x120
[  173.700080]  __sk_msg_free+0x87/0x150
[  173.700094]  tcp_bpf_send_verdict+0x179/0x4f0
[  173.700109]  tcp_bpf_sendpage+0x3ce/0x5d0

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    1 +
 net/ipv4/tcp_bpf.c    |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8a709f6..ad31c9f 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -187,6 +187,7 @@ static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
 	dst->sg.data[which] = src->sg.data[which];
 	dst->sg.data[which].length  = size;
 	dst->sg.size		   += size;
+	src->sg.size		   -= size;
 	src->sg.data[which].length -= size;
 	src->sg.data[which].offset += size;
 }
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ff96466..629aaa9a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -125,7 +125,6 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 
 	if (!ret) {
 		msg->sg.start = i;
-		msg->sg.size -= apply_bytes;
 		sk_psock_queue_msg(psock, tmp);
 		sk_psock_data_ready(sk, psock);
 	} else {

