Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF995289144
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgJISiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgJISht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:37:49 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B776BC0613D2;
        Fri,  9 Oct 2020 11:37:49 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r10so5170170ilm.11;
        Fri, 09 Oct 2020 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gRyrlvVDVlXc/XMAOZqzAVEoP6/JHU/5tv6ZTGQTtNg=;
        b=pu+f2Ulle1TdFyVItqGH76v8zqC7FJUV1xtf2vO0Q7hAL90Z2oM25LmXscFZGryIhm
         t/u8JH23jWQ228kWmb/mDgNvfEbdynEUrOxxdLBcZNoR6v3vwfpuIh23gJ3Mad+1jWFk
         GQN//UWs2Embi6+XnhFIKFL8bch8Bo4h3XVLYUFcniMg2UVxjJsS1pZ9m/rJgdmkXnVn
         2Oe1vFcnzBTIkbMZ0t9XobO9UOoV/m824u/FJA1aNrcKJJN4z2KumpMhkaXcpAOv5NqA
         9Nr43uo5ByMHT2EEkw8ofDtTWijDCUYS02iu9zZcpa8BQM8oz5Eg5kddSFPn/kXSscpO
         7Xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gRyrlvVDVlXc/XMAOZqzAVEoP6/JHU/5tv6ZTGQTtNg=;
        b=oQ4CVSeG9mVd2aG1dbg0rYONtcMkzvTV9XamDPJx9loSuHcD5c1S7iwGqfJUnk0WJY
         xsIplDB7V+rkva2xwXpbsyYWkIrvqzAcOb+7Cp+fbN8LBqAgxYRVvU2GjCaPKLGoJbrT
         MVDyBqjhdv8eBiZNtQh3KhJ9AqBml5fqVQafK9Aa+S004H475Ilcreg7iwg8bZcdJqjh
         shyPTp3zUz5aY3l+0OR8lkHYdWX12nc2rKmoPpixNC9h7nfPliXwm/DQ8KwCqA1SPMC2
         TG/Qd/PFJiGsP7qiDloD3hD7+XrLJTFz4C9VTp4eC0HeSVlmGr3oUaaaOlsjbg58LiWM
         S6iQ==
X-Gm-Message-State: AOAM531jznIb6MMxdApgCIljJUELAtfVV96nD/xOZB+Leav1tgcj8+rs
        H9ST9HnflqjhrX1QMiNjIo0=
X-Google-Smtp-Source: ABdhPJztslSs2B+8OVOuKdZS6EUXBPacSDecdXOGM1Z/8fKaJj4poflLNdr68wMmfC2zWuchItMR/A==
X-Received: by 2002:a05:6e02:eaa:: with SMTP id u10mr10586442ilj.57.1602268669034;
        Fri, 09 Oct 2020 11:37:49 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k198sm4793327ilk.80.2020.10.09.11.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:37:48 -0700 (PDT)
Subject: [bpf-next PATCH v3 5/6] bpf,
 sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:37:35 -0700
Message-ID: <160226865548.5692.9098315689984599579.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
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
index 880b84baab5e..3e78f2a80747 100644
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

