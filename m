Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C810D3D7A79
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhG0QF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhG0QF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:05:27 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE6EC061757;
        Tue, 27 Jul 2021 09:05:26 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id y4so12588193ilp.0;
        Tue, 27 Jul 2021 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZifGDj0i72OMHcbWcN8+M1mnLi/8e3/AA0xyn+AGvc=;
        b=Qf/05xUAzETmjR2wS8pU+i2TFTpKrX/tWbiWyO+K0spCYjB71YkZOweTKcP7soF1ut
         aSVMHv3Ta0XIiIqLamI/g+/ow7TkVV/1PKdAhcKJlgoi+UqNYLGuvISvlpErV6V7pCMi
         pP4KoT3RK1V+OKdQNP14oueHqNZrtu7P7HCLHL/PZTG/ko3DoaKtvzw4qfLrTbK8sZ4x
         1erY8gkb0KZpLIoKKSJtCU14izGSKnNAwyi3SUKTFaj2rlneDVLD2jTsTK1X5Eb+Rpjp
         WTHj9dEN0gDjUU1nRCI75cwIHiLSGjsD43WX4CJMuuXXe5wEtd6n8CVryozNpGIQQ9Y0
         uZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZifGDj0i72OMHcbWcN8+M1mnLi/8e3/AA0xyn+AGvc=;
        b=DSHBCYz85VZiEWJF2QeabIWMHsu7h5ILRVewEUZd7bEQYWtxfS9KEHvusq++3XJP5v
         WWR2vyAmDhds754oGoBqL8j80Jq6QPkGptPM36gJcghXX1cfvngbbc5Jzch4PWM8SvLe
         Xu7/nLvRd3cuvWsa9fSRRo2j8/uDF13rYxfTs/QbAaHME57eHokm7MJbZKedi/hIRLbl
         MGXZmYch+lzOuWc2mR9ifSqDYaa7tf0UHVp2xVgS2Mj/VSNWzWY4YJNjpQ52HN41fzCs
         f/eHJXkqieri+Ax7LvqoIbcY5gebOPMAnA4r4uv2Ge1vjOz1tgy7TdswuAHgDu/kpRw6
         lZ+Q==
X-Gm-Message-State: AOAM532xqTfd/9YW4BulxVOtKb/GCEupPTB+HwkhbhhM0UCuWxtM37Vx
        E+gsU+unYn9l5+kT0OCVOJs=
X-Google-Smtp-Source: ABdhPJwTekIHPg1fJLcroPfwmQ3Clzi+QWa7is0m3cc4jzMFYqdZiMoxS26LRKjYezU86l+CzUjzsA==
X-Received: by 2002:a92:dc8e:: with SMTP id c14mr17797627iln.91.1627401925875;
        Tue, 27 Jul 2021 09:05:25 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm2028689ilj.65.2021.07.27.09.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:05:25 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, kafai@fb.com,
        alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v3 1/3] bpf, sockmap: zap ingress queues after stopping strparser
Date:   Tue, 27 Jul 2021 09:04:58 -0700
Message-Id: <20210727160500.1713554-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727160500.1713554-1-john.fastabend@gmail.com>
References: <20210727160500.1713554-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want strparser to run and pass skbs into skmsg handlers when
the psock is null. We just sk_drop them in this case. When removing
a live socket from map it means extra drops that we do not need to
incur. Move the zap below strparser close to avoid this condition.

This way we stop the stream parser first stopping it from processing
packets and then delete the psock.

Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 15d71288e741..28115ef742e8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -773,8 +773,6 @@ static void sk_psock_destroy(struct work_struct *work)
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sk_psock_stop(psock, false);
-
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
 	rcu_assign_sk_user_data(sk, NULL);
@@ -784,6 +782,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
+	sk_psock_stop(psock, false);
+
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
 }
-- 
2.25.1

