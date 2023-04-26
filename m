Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F796EF080
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbjDZIvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240211AbjDZIvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:51:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8A44A0;
        Wed, 26 Apr 2023 01:51:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f1957e80a2so142770955e9.1;
        Wed, 26 Apr 2023 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682499096; x=1685091096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQt4d0zWjQY1z91uepy6h4EuQqaXR87jdp20zwNy9IM=;
        b=Jev7bC09f73ytwL6RhVXUm13rEkjPw1XJeN8aS8h8KCnmZO2qm/sHWJVpXBaE4nGBs
         PkHBqrVvqPKqQYg73GusWKoDJlfDePOXbYI1cFkKobK4dBEdzY4iRLi/rZnDio5vWQyM
         +z1u70vE3xs4WZbczJti8wWBLnG7e2gsNntNcNKm7gCPi/E/RgRZZC0L8oRrQukW++zT
         9fnKouvSTfBd6A3V0OvNTUcodHCzyUKfW5hnGqXyKN2lBCruxwB8ri8WQrtWY3j6SORN
         8Mc9x+LnjkZnaS2pmdAI1b2++DoD0vq/L3HFLOXJJJG/Opu9nsDZip8TyrD5aejqqmpF
         LlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682499096; x=1685091096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQt4d0zWjQY1z91uepy6h4EuQqaXR87jdp20zwNy9IM=;
        b=fcd9Y0L6B5m2vcigLKxHUGLKgCXjZZd7cphC3NYXrncKSt6JCW2JIFz4sOp2ySq0LW
         F0hcV4JVdrxMKsTdDVk95ehGWEK4lUM5Z8TKvFxU70qM+NXt8BWWGbu/mr0CO97pef8q
         Sri0LMOBGzQgIhUVH58ZJtPfdO8lHXSe+iv08fxRKWLNkhAOygJ6uZ4/EjPL9zGnip4v
         qILYmW1fuzbeM7MQxFUdEyuIccpWZGx0+cE2GAGGYSJDkDi8+d3B2YGMjrnidFhO0krm
         psmMqvhsj4HoHCuRrOJYwjKGsNDXaZ/Aj2fM0JJRdSxby3qIjbHAfxfzl544DWD+H/Ow
         8M7g==
X-Gm-Message-State: AC+VfDwnVvayeLSYS4VClhEYMp8ZqmgFtoKkwLhN/8Nu5lzatmhBnvgL
        DH4BJq5SU+OMSWj2k4XNXVQ=
X-Google-Smtp-Source: ACHHUZ7JEenGRQo3ZC+Lkz0Xkw5WuzIaAL1xarLAvcJSVxxGgzZegVBAdVE7jtyqbEuxT9ORcM8+gA==
X-Received: by 2002:a1c:ed16:0:b0:3f1:71d3:8ddf with SMTP id l22-20020a1ced16000000b003f171d38ddfmr1043679wmh.14.1682499095952;
        Wed, 26 Apr 2023 01:51:35 -0700 (PDT)
Received: from localhost.localdomain ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id q11-20020a5d574b000000b003049d7b9f4csm1229838wrw.32.2023.04.26.01.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 01:51:35 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v3 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date:   Wed, 26 Apr 2023 11:51:20 +0300
Message-Id: <20230426085122.376768-3-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426085122.376768-1-gilad9366@gmail.com>
References: <20230426085122.376768-1-gilad9366@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->dev always exists in the tc flow. There is no need to use
bpf_skc_lookup(), bpf_sk_lookup() from this code path.

This change facilitates fixing the tc flow to be VRF aware.

Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5910956f4e0d..f43f86fc1235 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6704,8 +6704,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
-					     netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
+					       ifindex, IPPROTO_TCP, netns_id,
+					       flags);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6723,8 +6727,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_TCP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6742,8 +6750,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_UDP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
-- 
2.34.1

