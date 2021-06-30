Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057AF3B8A40
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhF3V4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 17:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3V4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 17:56:48 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C9C0617AE;
        Wed, 30 Jun 2021 14:54:18 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k11so5003443ioa.5;
        Wed, 30 Jun 2021 14:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F/8nR4dUL48grJSNi7BYMG27OhQ0n5HV9QCQlycKaCo=;
        b=aetCVABMbIeOdvWTer65rGbnFkeICjsuz8Vczhy31uQMac7f/wWTUXuRMQbfDWuS2/
         FPpChgcsgh7ktiJ9VkJROdAf5gG606NZ76afdmFAemzRKbNMYIw8PP38Xdmf/9utfVuI
         anSWqH7LFzWT9gSLN92SO0lXtjTGa0SS+1U8AxF76Ho6hf3D02y+hh2apPpTlcf6diAa
         cHmpO8/5TBmnad1Id11ETewI4cFd/OAezhBfXZEMZUJg3b8IGzR8VYuOcYwQtIBpGGEr
         v6jK8TAFfVAf+P48hFlN80G0+KvWde6PXyq8bEIbd+VqM2NfznFO5xNPhS11kbm7of41
         lCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F/8nR4dUL48grJSNi7BYMG27OhQ0n5HV9QCQlycKaCo=;
        b=KcU6FIytCatT20pH0Pf9TF5mMjM1rNvul5rapRU5LDU85/XiYtbZDuh7LM/Pl2x0um
         RqAWeIM5YhNiDkTzxU6ANuCtA37VL8AsW53hpz1RTyYYCej3BJkPP3+xS9uyPfIWCHQQ
         V1lfw2GXtEx+c7NuaidsXhcjvM0GzOyEJQDjwz0D8jbkBTueTDz5k3NYMfkXzkQRUbqx
         GjO+oVH+i7K/TciRKsKRMZezChsPWWGCZAo7rwp+SdFLk2+Ms1P6ldiAGsL+e78RCMXL
         smPMZEhRSpWg69ABV89zh5EHHbal+yjDdPejF2XhXsv5lQBUDZtDSWFFhVhAaB3l1UQB
         Oo4Q==
X-Gm-Message-State: AOAM531h+i91rX/bey1O4m5LNBBi0UkNQMFNL4jSwQ/flIzNjqVPxoml
        aCO4ceVjMSz7xpiM6c+dbWs5R1G5SfnHtA==
X-Google-Smtp-Source: ABdhPJyCab6Rwj5i0twIAeDIfkb5sGg0BDEmxxd4vrwnoevhL8V75Vbhud3IBCWpo8d+XB7k5Q++DQ==
X-Received: by 2002:a6b:4905:: with SMTP id u5mr9042867iob.55.1625090058007;
        Wed, 30 Jun 2021 14:54:18 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b3sm5541210ilm.73.2021.06.30.14.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 14:54:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf, sockmap 2/2] bpf, sockmap: sk_prot needs inuse_idx set for proc stats
Date:   Wed, 30 Jun 2021 14:53:49 -0700
Message-Id: <20210630215349.73263-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630215349.73263-1-john.fastabend@gmail.com>
References: <20210630215349.73263-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
We currently do not set this correctly from sockmap side. The result is
reading sock stats '/proc/net/sockstat' gives incorrect values. The
socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 60decd6420ca..29e7bae65db5 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -221,7 +221,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	struct bpf_prog *skb_verdict = NULL;
 	struct bpf_prog *msg_parser = NULL;
 	struct sk_psock *psock;
-	int ret;
+	int ret, idx;
 
 	/* Only sockets we can redirect into/from in BPF need to hold
 	 * refs to parser/verdict progs and have their sk_data_ready
@@ -293,9 +293,11 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	if (msg_parser)
 		psock_set_prog(&psock->progs.msg_parser, msg_parser);

+	idx = sk->sk_prot->inuse_idx;
 	ret = sock_map_init_proto(sk, psock);
 	if (ret < 0)
 		goto out_drop;
+	sk->sk_prot->inuse_idx = idx;
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
-- 
2.25.1

