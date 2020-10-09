Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A4928816D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgJIEoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIEoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:44:22 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908BC0613D2;
        Thu,  8 Oct 2020 21:44:22 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q9so8823960iow.6;
        Thu, 08 Oct 2020 21:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ue3SsOhZdq7UxtSZgVrpSUS1g0m/Xb3ufNzGhGzXbho=;
        b=SjQ5r6tMwj59/CA36tJMOZM5eHQ7ARLBS7UJYM9HX5m73cHld1YwDxW4mXpbe0d0Hc
         hN1xxCTmgG8O9zxu1z4WQ3YDsZlSf2LILzbmcpPhFkeFDNfG5NAQw+d/Pkg3+iT5cDVM
         QNFuBg4yzoZsYdJN4WB72f4aDlyC1xyrh+zMvWDLl1hkzKJBWhaH8hengXotPa8WaH5L
         yCvfdw1SWqbYjpKZZX9NlPMDOy7KEAsMFNXAyOa5mZqWvRPEV2lLQwes6GKawKPQbDQb
         B0PJYlDqKUSePKH3CUp5Dm+V66FK95tnsYcUMEirmybP9vmu6BlrKWrKFlmelRd6d0BO
         k21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ue3SsOhZdq7UxtSZgVrpSUS1g0m/Xb3ufNzGhGzXbho=;
        b=iS3+DD+5ZXvQoSEfDCZqXu1wfV47zBD0Z2Rd0YaMYleiHA1blrPQISNq+j74Hz7E72
         S9hG8ECdeGfNZ0bWUpS05D5K0z2/lTOFk+RRl8IFSpevKLDdu1dpQAKt3ZpevgEQDJT2
         yO5zVDKUN22d/JJGwUsc7O+s0MBFQVXnBaphp2FX2GyjePewM4RNkYMMxrXpQG440k1P
         HvS2Kf1DLHCfOnWorWI5UM7osnuIzk7OMRJ03Z/g2wvCH2W2T0WIaeMa1n0d8a7cBMoE
         4F+6g3oFp1MVB53ZJFNbJOtstrCULQpZ0HNQe82mAEnY/gEH1sLK/wgNuOyVvpGwA/Wo
         zvyQ==
X-Gm-Message-State: AOAM530xpWH6UiTM3IJdNMst5zsijIH0ScmHsvhWVyIB8oznDiWBbTR9
        UhEU/uxxGyhj/Qm9NF4Ig6Y=
X-Google-Smtp-Source: ABdhPJwzQnSnfNEcMSzt43/Qadw0zOOfQvoD0N+YCIExLk5rs9gPk44M/IaNLbb9IitlphuMOds9pA==
X-Received: by 2002:a02:cb0c:: with SMTP id j12mr7700105jap.54.1602218662074;
        Thu, 08 Oct 2020 21:44:22 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v13sm3638619ilh.65.2020.10.08.21.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:44:21 -0700 (PDT)
Subject: [bpf-next PATCH 2/6] bpf,
 sockmap: On receive programs try to fast track SK_PASS ingress
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:44:08 -0700
Message-ID: <160221864872.12042.14533177764605980614.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we receive an skb and the ingress skb verdict program returns
SK_PASS we currently set the ingress flag and put it on the workqueue
so it can be turned into a sk_msg and put on the sk_msg ingress queue.
Then finally telling userspace with data_ready hook.

Here we observe that if the workqueue is empty then we can try to
convert into a sk_msg type and call data_ready directly without
bouncing through a workqueue. Its a common pattern to have a recv
verdict program for visibility that always returns SK_PASS. In this
case unless there is an ENOMEM error or we overrun the socket we
can avoid the workqueue completely only using it when we fall back
to error cases caused by memory pressure.

By doing this we eliminate another case where data may be dropped
if errors occur on memory limits in workqueue.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 040ae1d75b65..dabd25313a70 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -773,6 +773,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 {
 	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
+	int err;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -784,8 +785,20 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 
 		tcp = TCP_SKB_CB(skb);
 		tcp->bpf.flags |= BPF_F_INGRESS;
-		skb_queue_tail(&psock->ingress_skb, skb);
-		schedule_work(&psock->work);
+
+		/* If the queue is empty then we can submit directly
+		 * into the msg queue. If its not empty we have to
+		 * queue work otherwise we may get OOO data. Otherwise,
+		 * if sk_psock_skb_ingress errors will be handled by
+		 * retrying later from workqueue.
+		 */
+		if (skb_queue_empty(&psock->ingress_skb)) {
+			err = sk_psock_skb_ingress(psock, skb);
+		}
+		if (err < 0) {
+			skb_queue_tail(&psock->ingress_skb, skb);
+			schedule_work(&psock->work);
+		}
 		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);

