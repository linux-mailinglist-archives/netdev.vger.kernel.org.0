Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04728A5B8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 07:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgJKFJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 01:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 01:09:32 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DBAC0613CE;
        Sat, 10 Oct 2020 22:09:30 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p16so4476851ilq.5;
        Sat, 10 Oct 2020 22:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=M0bAWQd0WTnt0/w1exFU5fB4VtkL954BS24rcnrY8NQ=;
        b=HZztZDs5YcwNqU2bB3eVr5AFfuZ4Pt1OcvT0Nz3SoyeybuJ5iy6Iw0Fr5RT2Bs2a13
         BAWo86bb94BymR3ofGsINIbf4AJea6wVekvsnlstXebkaCSLuFNVG5IKlgL3aObQ/rX+
         JbOV9VCi1OaCJ5vuuTNVymtSKfX0ySUkRo57a5Nn5JfgKdhPT3AgL795LSYv8Fi7UNsA
         jCphRMSBM7wcGu71pnWkdRk07MhwjL34VCo53DGmEZc3YJLXbRmJO4L2sj4xEQ6bvk5G
         HSaGQexB40npYOY7+hlKJ8BX6xdS4Y4EF8KbN+8hLJHleoqf3rP87x6Sqx+1on8L806C
         YIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=M0bAWQd0WTnt0/w1exFU5fB4VtkL954BS24rcnrY8NQ=;
        b=GOtagEq8afdHCId4ZKrrKdrSc75PJINuTMfWb8csb90V1AxfedY1loHTkVvJS2qYVz
         plfX206mVrTkI35RWxTriNJk+nQm/6EDmC9uUTtyTwjp3njC9tXHjdkUgQFcqg1GNj/Z
         wCWiOC2g1M2gKvcP2UE4pIWI1tUQbBN9BxMAPv75rVeIvOwJwYm+/ETu3lph8+W5V6Br
         /+Z/sZCNNPshM5accyjPriKegUbIxw8YFGtBRorHeo9fDtyEDIY7XaCrGQtC51DrOErY
         cZhmGe5kL9m4tUFgjzefIagB7ldEfBG/yK8z139MVygtZlRAFx4upyqScX1a3TEmmfPM
         yuIA==
X-Gm-Message-State: AOAM530hqJlupD/Bhi8B5tfcm4fJ+XCnM+J0ZANnUkZn7SvFVeMc9foe
        GdI4Qw642LDZY7imteaQtKI=
X-Google-Smtp-Source: ABdhPJxFLLqI5JpScDfdY8gJPJHbdEt33oizOFZdqj3joaQoEmIjcPluZhWjgEy/kHsse5sC9mObhA==
X-Received: by 2002:a92:6a06:: with SMTP id f6mr14759022ilc.53.1602392970406;
        Sat, 10 Oct 2020 22:09:30 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e15sm6712209ili.75.2020.10.10.22.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 22:09:29 -0700 (PDT)
Subject: [bpf-next PATCH 1/4] bpf,
 sockmap: check skb_verdict and skb_parser programs explicitly
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Sat, 10 Oct 2020 22:09:07 -0700
Message-ID: <160239294756.8495.5796595770890272219.stgit@john-Precision-5820-Tower>
In-Reply-To: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
References: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are about to allow skb_verdict to run without skb_parser programs
as a first step change code to check each program type specifically.
This should be a mechanical change without any impact to actual result.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e83a80e8f13b..a2ed5b6223b9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -230,16 +230,16 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 {
 	struct bpf_prog *msg_parser, *skb_parser, *skb_verdict;
 	struct sk_psock *psock;
-	bool skb_progs;
 	int ret;
 
 	skb_verdict = READ_ONCE(progs->skb_verdict);
 	skb_parser = READ_ONCE(progs->skb_parser);
-	skb_progs = skb_parser && skb_verdict;
-	if (skb_progs) {
+	if (skb_verdict) {
 		skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
 		if (IS_ERR(skb_verdict))
 			return PTR_ERR(skb_verdict);
+	}
+	if (skb_parser) {
 		skb_parser = bpf_prog_inc_not_zero(skb_parser);
 		if (IS_ERR(skb_parser)) {
 			bpf_prog_put(skb_verdict);
@@ -264,7 +264,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 
 	if (psock) {
 		if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
-		    (skb_progs  && READ_ONCE(psock->progs.skb_parser))) {
+		    (skb_parser  && READ_ONCE(psock->progs.skb_parser)) ||
+		    (skb_verdict && READ_ONCE(psock->progs.skb_verdict))) {
 			sk_psock_put(sk, psock);
 			ret = -EBUSY;
 			goto out_progs;
@@ -285,7 +286,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	if (skb_progs && !psock->parser.enabled) {
+	if (skb_parser && skb_verdict && !psock->parser.enabled) {
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret) {
 			write_unlock_bh(&sk->sk_callback_lock);
@@ -303,10 +304,10 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (msg_parser)
 		bpf_prog_put(msg_parser);
 out:
-	if (skb_progs) {
+	if (skb_verdict)
 		bpf_prog_put(skb_verdict);
+	if (skb_parser)
 		bpf_prog_put(skb_parser);
-	}
 	return ret;
 }
 

