Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A85A288175
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgJIEpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgJIEpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:45:17 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14F1C0613D2;
        Thu,  8 Oct 2020 21:45:17 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n6so8793145ioc.12;
        Thu, 08 Oct 2020 21:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OKQN38whfOCZJQQ7SBZl1Rsoo0C1oj1GmNd56G4D9v0=;
        b=M0aknxh6Cv2qYdroLmGO2cGPUgfbrHLiUjHEgjvma+MW7F2tweZpyfQKe0zisJg94Z
         thWokAqgGhekQ2/Y0jEF7uLet8htJWJOoPDV+r49CjYTmZtopG+CD8PFmJC3EKI0H5zF
         Rml+3y9UNFJ/BISWFsytLDM1cNuGj+Ttu/nLOfiUWF4tPg+AVxarNfPU1fO7bs7e6KF5
         SnLQjb8oGQGkfISoPag+bqpnEtQfj6RRG30woIY41t4hEBTleUaACmogpdRdpmQwiYuO
         PV3SID49gAF6XvZTEOGYUzMKMCNZ2VX3Wa88sYPZQy8dnhBiofeJBBh5UTPYbZ3fKWHz
         9NDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OKQN38whfOCZJQQ7SBZl1Rsoo0C1oj1GmNd56G4D9v0=;
        b=EkZihpKjdVoSTlk81Ph8oqMyTblyqGvsSAml3+vWlVUOucTuVC/5VHeEtUdr9mhQMq
         137J/2MfnmX/hTvnSTNqgdrFgWP9eiBAM4uG8wcvJtglJNvIbHonqk24fBP2unW8W74q
         M4dZK4Ws5GDMGSYWQFrUIVp5UgjwTGxR9jVTzrA5hqWBtdgySBlSfKdXwpFNArRMrTw1
         pUoAx7MsIi+3arp74d67pgc/suU2Tw04aXZw41V9w/f2cB7fx9nErfExboTlb5isIPIx
         4+mkzcOQ9xjhCXjp/d/m82DcA8H8WCVisvEPbtLgVQGrOlcBwuf1YWZWyE0tZH/fMlzq
         YYCg==
X-Gm-Message-State: AOAM530ATBkjZRlamvRnE5LC6PxC5DPU+aCvnwxCU0QQdO68BN8vjHXq
        q7fnXw928YWZw7Th+gmQsmqX+B1bBELaJQ==
X-Google-Smtp-Source: ABdhPJzmFgxZsRfy4le4vZmJ554UBvN5RmCpfuBKoE8t8zmpgMj2B94jc2nctLsFm+b/zFfktnqgpA==
X-Received: by 2002:a6b:8dcf:: with SMTP id p198mr8359886iod.200.1602218717083;
        Thu, 08 Oct 2020 21:45:17 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b2sm3628794ila.62.2020.10.08.21.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:45:16 -0700 (PDT)
Subject: [bpf-next PATCH 5/6] bpf,
 sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:45:04 -0700
Message-ID: <160221870378.12042.9140246148992032681.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
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
index 0bc8679e8033..ef68749c9104 100644
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
@@ -826,7 +827,6 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb_orphan(skb);
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));

