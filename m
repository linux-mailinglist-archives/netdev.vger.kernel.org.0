Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB91928906A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390272AbgJIR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:59:02 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F8C0613D2;
        Fri,  9 Oct 2020 10:59:02 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so10984916ion.3;
        Fri, 09 Oct 2020 10:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WgUEv94zOjtzKObiIbf/jfp6XQO9pVOU6Rs2H1v8aK4=;
        b=IKzvlnn2OW6RDaIvrPhRRJrmV1RQPo64NTaWSg+y+kanlYxA8wmG8TUR40ZoPGAfJe
         kZB8rJGckpIKFn2j81wmCTcFoTH9KC+7uOXMDKrILMur/lRftoa9jTGZsSddmBnkGvDA
         ATfO7eLJzFm51ot5/LPKtLSV4qwgZi1I8LGfMAym3A7m4A2xU7/mN2RDCAzbildef4IO
         WHlCvZ6c0cckNKB1ayTPwey8j163d+V9rnF5n4xZ3MTf2XhWTa78bAptQp2S5n05AP+A
         +w9BiSDekzCjI2SzdmsRJpNsjmc+0zvwLQ4gIfOMfLow/t0rO0ZegLihmfpgs2sZIfbX
         O43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WgUEv94zOjtzKObiIbf/jfp6XQO9pVOU6Rs2H1v8aK4=;
        b=grAfwcL+a2n0sliuGwOcklXdu1X07I8kKO+4ZE0qkrZ1QMnyl3jDcgmvilwuvZeNO7
         ZFOr61/nL+QhcKW1MjtARogygtCgsbeD7tZ/5IToZ/WRXMENK1ttI+5KHqqZwlbcYS0v
         kFHDFUaAKUM/uEsACnm7CQ65RhOyYkReblAgy1tIDpzs6dXldU0SB5incHB1GJtCMhLu
         YXBQ5tL6ixO8v+L5rVI8ow+YBiXEkQ7+Q1WHXK4ZRxzrI8Py8Bd2b1skOwFc6cQwIqx0
         zktB7Hxt0v1OL1pv/SFwtOm1FWm0KRvLwwgy7I27N2O6/HomP0ALh5ksxCFOE0f+ZCxQ
         jbBw==
X-Gm-Message-State: AOAM532xd7kLblT+ATyXo1LpSjlqalUhNBvjlaNvfW42lKCnBVH8qPRB
        VKQDqsGmQrWSn+mQzO+O68E=
X-Google-Smtp-Source: ABdhPJzzvc1L3b8wXVR6ejrPChvXTz2fXMWDCP0nKgKErvkgwIXoWkx493jOuGDLGzUcrZ1A7PByuw==
X-Received: by 2002:a6b:dc0f:: with SMTP id s15mr10085914ioc.180.1602266341590;
        Fri, 09 Oct 2020 10:59:01 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x13sm3825384iox.31.2020.10.09.10.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:59:00 -0700 (PDT)
Subject: [bpf-next PATCH v2 5/6] bpf,
 sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:58:50 -0700
Message-ID: <160226632994.4390.2648269619617632786.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling skb_orphan() is unnecessary in the strp rcv handler because the skb
is from a skb_clone() in __strp_recv. So it never has a destructor or a
sk assigned. Plus its confusing to read because it might hint to the reader
that the skb could have an sk assigned which is not true. Even if we did
have an sk assigned it would be cleaner to simply wait for the upcoming
kfree_skb().

Additionally, move the comment about strparser clone up so its closer to
the logic it is describing and add to it so that it is more complete.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9804ef0354a2..b017c6104cdc 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -686,15 +686,16 @@ static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 {
 	int ret;
 
+	/* strparser clones the skb before handing it to a upper layer,
+	 * meaning we have the same data, but sk is NULL. We do want an
+	 * sk pointer though when we run the BPF program. So we set it
+	 * here and then NULL it to ensure we don't trigger a BUG_ON()
+	 * in skb/sk operations later if kfree_skb is called with a
+	 * valid skb->sk pointer and no destructor assigned.
+	 */
 	skb->sk = psock->sk;
 	bpf_compute_data_end_sk_skb(skb);
 	ret = bpf_prog_run_pin_on_cpu(prog, skb);
-	/* strparser clones the skb before handing it to a upper layer,
-	 * meaning skb_orphan has been called. We NULL sk on the way out
-	 * to ensure we don't trigger a BUG_ON() in skb/sk operations
-	 * later and because we are not charging the memory of this skb
-	 * to any socket yet.
-	 */
 	skb->sk = NULL;
 	return ret;
 }
@@ -824,7 +825,6 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb_orphan(skb);
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));

