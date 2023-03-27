Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C946CAC63
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjC0RzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjC0Ry7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC932D65;
        Mon, 27 Mar 2023 10:54:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c18so9162659ple.11;
        Mon, 27 Mar 2023 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfTerV6/U69AI92CPlAfsf8FX5XYFtSurKpJkvd75cI=;
        b=EfSuHwzAQxcT0QXdd86YFMLlA3HlDryz9kg83k/x5t+1jmUu/5Gy0NZhpacX41MDbM
         2bhHoUaL+IGZOuqdbQ2Sm3LJJTO0YFnr4IId2i0GWgsvDHTkfO02Z7Ik6HkOXwz/HtGQ
         ssjKytD/hIZ+BAGxbRcIEnakTEhuKi9hz+ySNNad3/l/+pUJRi8ulCnVq/PqHEok6elz
         Ag7Gw2oMDdzJFgif/3gD4Pu5Q7benvJjCBXvWvK73IWls03O5n49htil01UyWYtVTCn0
         jDv18ZMGb+zN9uq4zw5uvlsBnUsDuyIcwZeS+qwHD/sZn4PMdNePgJErtZcD8V1t1uP1
         oI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfTerV6/U69AI92CPlAfsf8FX5XYFtSurKpJkvd75cI=;
        b=ItHEu+dyQaMd6OH40w3H72ep0eoTLZ9jU7ne2wuuaBlPM4dV2VmTQXWzYmTI/0Q12c
         KQXRI5IQDkG9HqPzAgkQWliiTBY1uwa5Nw9Y7jUsHplSpCOxhQyxlntQ2onVZTB1vx38
         ynFXKM2u9b4CCk1DcUxjJui4oNH+iaHLxvxGqlHBg7WlzY2ZXPOIPGzzxEKgSzqK3GrH
         ru3yh0qEbogLm14yr2y5nSIvWsleXLs52TqyjOm95/qFkRup01zpKHKc7Nz+MuZslVG5
         ybQTeggffHGl+c7sXOz0HAFVoN4dwUggiUqHO+OdRR58eC51BAmh5wYxsG69yn32mwi8
         Zptw==
X-Gm-Message-State: AO0yUKUC+gPBsTcz01s8IHxRD1aZ9CJrXo6k6rXUCNDsZDPYlCRfJwQV
        IDHbA1558/r1/9gGiC0eZM8=
X-Google-Smtp-Source: AK7set/CRTesWW+HYMx4XSEn53uvqJguIQsExdns0MUMSJMbzbiLMgWX/3U9BxfOFnC7cboYuph6Ww==
X-Received: by 2002:a05:6a20:1790:b0:db:ae75:c70e with SMTP id bl16-20020a056a20179000b000dbae75c70emr11641043pzb.15.1679939693891;
        Mon, 27 Mar 2023 10:54:53 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:53 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 03/12] bpf: sockmap, improved check for empty queue
Date:   Mon, 27 Mar 2023 10:54:37 -0700
Message-Id: <20230327175446.98151-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We noticed some rare sk_buffs were stepping past the queue when system was
under memory pressure. The general theory is to skip enqueueing
sk_buffs when its not necessary which is the normal case with a system
that is properly provisioned for the task, no memory pressure and enough
cpu assigned.

But, if we can't allocate memory due to an ENOMEM error when enqueueing
the sk_buff into the sockmap receive queue we push it onto a delayed
workqueue to retry later. When a new sk_buff is received we then check
if that queue is empty. However, there is a problem with simply checking
the queue length. When a sk_buff is being processed from the ingress queue
but not yet on the sockmap msg receive queue its possible to also recv
a sk_buff through normal path. It will check the ingress queue which is
zero and then skip ahead of the pkt being processed.

Previously we used sock lock from both contexts which made the problem
harder to hit, but not impossible.

To fix also check the 'state' variable where we would cache partially
processed sk_buff. This catches the majority of cases. But, we also
need to use the mutex lock around this check because we can't have both
codes running and check sensibly. We could perhaps do this with atomic
bit checks, but we are already here due to memory pressure so slowing
things down a bit seems OK and simpler to just grab a lock.

To reproduce issue we run NGINX compliance test with sockmap running and
observe some flakes in our testing that we attributed to this issue.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 96a6a3a74a67..34de0605694e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -985,6 +985,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 				  int verdict)
 {
+	struct sk_psock_work_state *state;
 	struct sock *sk_other;
 	int err = 0;
 	u32 len, off;
@@ -1001,13 +1002,28 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 
 		skb_bpf_set_ingress(skb);
 
+		/* We need to grab mutex here because in-flight skb is in one of
+		 * the following states: either on ingress_skb, in psock->state
+		 * or being processed by backlog and neither in state->skb and
+		 * ingress_skb may be also empty. The troublesome case is when
+		 * the skb has been dequeued from ingress_skb list or taken from
+		 * state->skb because we can not easily test this case. Maybe we
+		 * could be clever with flags and resolve this but being clever
+		 * got us here in the first place and we note this is done under
+		 * sock lock and backlog conditions mean we are already running
+		 * into ENOMEM or other performance hindering cases so lets do
+		 * the obvious thing and grab the mutex.
+		 */
+		mutex_lock(&psock->work_mutex);
+		state = &psock->work_state;
+
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
 		 * queue work otherwise we may get OOO data. Otherwise,
 		 * if sk_psock_skb_ingress errors will be handled by
 		 * retrying later from workqueue.
 		 */
-		if (skb_queue_empty(&psock->ingress_skb)) {
+		if (skb_queue_empty(&psock->ingress_skb) && likely(!state->skb)) {
 			len = skb->len;
 			off = 0;
 			if (skb_bpf_strparser(skb)) {
@@ -1028,9 +1044,11 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 			spin_unlock_bh(&psock->ingress_lock);
 			if (err < 0) {
 				skb_bpf_redirect_clear(skb);
+				mutex_unlock(&psock->work_mutex);
 				goto out_free;
 			}
 		}
+		mutex_unlock(&psock->work_mutex);
 		break;
 	case __SK_REDIRECT:
 		err = sk_psock_skb_redirect(psock, skb);
-- 
2.33.0

