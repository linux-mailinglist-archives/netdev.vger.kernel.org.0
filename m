Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B26D8C50
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbjDFBBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjDFBBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:14 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8492C7AAD;
        Wed,  5 Apr 2023 18:00:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l184so13753655pgd.11;
        Wed, 05 Apr 2023 18:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742841; x=1683334841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=jA5Ef/DNnzvE8ZjYF3FnHhFod47dhBzwFi1AyIeoekZdrdTissnA3/t2Tesw7Y+MPz
         C5Oott3FhsnjzPVGyuNx+VC6VhmBi+ufSzNeUcnkYsugPul/WMsuLVZr9LRiy1EtOLBX
         IYGe5AeuAvlzFnO/6354he0wou//vi+8iHt9oukkH91WtDrBKobDUlJQ0eynGVY83Lww
         J/ESeKOzl3F52/Kvi23nVBKIu+IhD20C0I87wtHNVujMy/wDJqbVFuLNQuKGiGu4TQGz
         3+oIcKlRTbBbrKkZTczXZNcy0l8ta4QX9FFgCXeCwUMTbSY8sUvkd3jtyzQ/+jN8Mneu
         E5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742841; x=1683334841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=AHC/L/Qgd2VJqej3L9xl+vXn8npa5ms1KZRay9lDvgWVMT8Fi5U6uJsLQJXk1rDIAN
         ywXcKLSleIjpKqJhevD0+L1k6UcaUXlK3v9zO3LyQofaNFa6i9VI/eAOy8Ovf7YIcAIf
         5uWzgjrlblmo4/ci4Of4U+FKSjkL7m6wZMN5EfgtZvIOVFx4eLq/LgSx3Xjsj8Z6dXr8
         mj3Vat+fTNyUE/3iAAQHcli/qxjEvA5Aobt4q9gAcL8hpKsX29nscezFtv4Fg3rlwd2R
         xITGlnfylK5Cqh1SLDc6VRwhOS0BIGq94/byNoR0NDyNfri33lPH7yfIS+CFPBBOAv0A
         YE8Q==
X-Gm-Message-State: AAQBX9dqUbr/Qdg6OqryWlZmusrGkQ6+j+Tl1RE7hTBIqn+R+/6R1flV
        0TtYottbs0+P4MrDOhgTmgw=
X-Google-Smtp-Source: AKy350ZBSeYC7gy0RwAtdSmRLoaDXudI8qhPQiSWaUsNRpS6gT09W/YGQgZjxtMH8vedAsdqWfxPmQ==
X-Received: by 2002:a62:1955:0:b0:62d:d9a6:bc9e with SMTP id 82-20020a621955000000b0062dd9a6bc9emr7111715pfz.18.1680742840889;
        Wed, 05 Apr 2023 18:00:40 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:40 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 03/12] bpf: sockmap, improved check for empty queue
Date:   Wed,  5 Apr 2023 18:00:22 -0700
Message-Id: <20230406010031.3354-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
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
index 198bed303c51..f8731818b5c3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -987,6 +987,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 				  int verdict)
 {
+	struct sk_psock_work_state *state;
 	struct sock *sk_other;
 	int err = 0;
 	u32 len, off;
@@ -1003,13 +1004,28 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 
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
@@ -1030,9 +1046,11 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
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

