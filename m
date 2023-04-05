Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046AA6D8A4F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjDEWJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjDEWJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A61859D5;
        Wed,  5 Apr 2023 15:09:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso40951241pjb.3;
        Wed, 05 Apr 2023 15:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732551; x=1683324551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=GqaQaaxdwowB6YZuVu4fHKAIeDeVdT374hvhAvm1MCcd3pO+foMKVik5dB/acFkgvs
         Rb+rRDljY7UiPVmrlu0vpAkdhrX2/N7EmRCBbFUFl6lMMJPVESHI/lltvo5dvVGLRi+R
         0K23SeM0ACGrNDPlV5ldh3VVclGQTEsPQR55e7M+eVyd2TGrrPWJA5i1T67tf50JJ+jl
         OCENSIhhSfdPyXeFLvij8Erlu6WidiD/KFw0dn+tQjU/XIgdash+7caVDJptGkAW9RM5
         XtdJYl91ESmGoy0fN1MPhwF5LzhkOmUmTHnEoJTOHhwSeiK5yVEakV1RExuGoWpazL8O
         dwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732551; x=1683324551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1SkSwJ+B3plp80uNFxZv+C5LrwCVTyzF6SA03WoEAY=;
        b=XxrN+sYJpkhwJxilOJM+MFuD7S78lPcMXU504GhHfrRtYKqy8rSX6cU06GoqboBvVa
         E/sBs0kOfo4m5rPRnS9GNxU+rqLpwmQdmize7UwaYYL5noN4YRN981cMxac7KgyGKpNd
         KkFkQY0cMApjEKWwBGO0KnDQwOpVLWpGuJSTMfii7mVfGUNr8EeMffufA/d5dSTqiqwn
         V/gi+btlipiVXNAJ/MGMSoKo8h/n/qm2OZ7MzZZODjTWm+SnZuxPOTww+izMauafoWAn
         eFng7HrLzvhZ092BICPqTixwPND+e0bgrYnOg2lXAfrWwrBpnqtoA1N2Z338rdRTfhQM
         +h8A==
X-Gm-Message-State: AAQBX9cbZnoROlKyoCD0aVrCKpDhtdPyANB6A1OGhLG4yaB1WRyPtqe6
        GhXBbW6CNRj4Pfdl+Puuki0=
X-Google-Smtp-Source: AKy350a1cTuP5kTE+R6oUKwNjT+Z6ODi28Y/GaxJs9rUges+aMA6gREADPymNbCrYGym7Cy0zeeTEQ==
X-Received: by 2002:a17:90b:3907:b0:233:f354:e7df with SMTP id ob7-20020a17090b390700b00233f354e7dfmr8675208pjb.18.1680732551599;
        Wed, 05 Apr 2023 15:09:11 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:11 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 03/12] bpf: sockmap, improved check for empty queue
Date:   Wed,  5 Apr 2023 15:08:55 -0700
Message-Id: <20230405220904.153149-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
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

