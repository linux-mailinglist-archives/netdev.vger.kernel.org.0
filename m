Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B426E97A2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDTOvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjDTOvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:51:13 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE12E6EAE;
        Thu, 20 Apr 2023 07:51:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f182d74658so5396985e9.0;
        Thu, 20 Apr 2023 07:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682002265; x=1684594265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AopaMoC5xc+EJVFzmk3bCqCl7qbsAjlFgnhPt7Vtm9k=;
        b=Mzs4nZlhoOkf0PHtVKy55bpf7zkPshHBXbSxY5GshqziNncYTgh4LMQwzr6bt1mbom
         Owqhou1tVkhJ66WL51Wb5J0qSdrVgWF8OwrbMwOvdGgsgsAtkZE291KO2/mEyJ/MGrF5
         ioYc8QC9xHyXxRJ30TWfz4CxiMK7r5SDO0PKItM9wmwxVaQtm7sSs/65XjctG287yFst
         +8B7pY9BhF6udtMhf5NUy1xwgKWxZ1URtHNa2lIBOfXgT8Pk1ysdh6GBVFphs3cIVqGY
         vLaA5Meqear3X6/lbFqlZKjkHyRvlkXJ4Kb6tdqEWNjnTx0XasnRiUHgP/S+24seM0Xt
         FlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002265; x=1684594265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AopaMoC5xc+EJVFzmk3bCqCl7qbsAjlFgnhPt7Vtm9k=;
        b=QeN3g8BTY2NXatFu5olBcgm+gHqoeyiexnEN9zU7siwluoKJAFtHqFGjOLfilXJSGl
         Y5K6YhGlGF60RRxGwj8B6j2yxPC5s33YEpLGTGugdKjyLVAT/dqLrmyT32pvN+qS9mZu
         Ds3HGeTrTvq5F2nDSNb3tZZLyE7vZQx7Ny2Cvgc4+FpNz6oLiWUShXWX2nnKbdgkqQ87
         Gb7PAlMkLlPLlAIa3s7LZT4HcJzw95N1Oxgxydu8xvlt4Ikr6uNQ0Fw8U5ALKxi2odMH
         tMX6B8P3NIB2k/Wf+GNIi6B11WaiMTLylA9Emw5/j9ETf3+L7q4xZFI+c/GwWo5bdYKM
         vH4Q==
X-Gm-Message-State: AAQBX9dd+gh4mm2dNlKuuTA0UjEnHnaDbUMzsoAdYsbRYdvJpP5+Nmoj
        JcrcFvJZZsZbywEXuLk13zE=
X-Google-Smtp-Source: AKy350Z0Bs/Ory8+f1RfFmUvcpLvBKjPzPJ3H2A3PY+rT/8ZpuUGWEj6UdN7Wu5oF6Ary411wV0BfQ==
X-Received: by 2002:adf:ec90:0:b0:2f0:27cc:1e7 with SMTP id z16-20020adfec90000000b002f027cc01e7mr1428305wrn.9.1682002265278;
        Thu, 20 Apr 2023 07:51:05 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003f17b96793dsm5534619wmk.37.2023.04.20.07.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:51:04 -0700 (PDT)
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
Subject: [PATCH bpf,v2 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date:   Thu, 20 Apr 2023 17:50:39 +0300
Message-Id: <20230420145041.508434-3-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420145041.508434-1-gilad9366@gmail.com>
References: <20230420145041.508434-1-gilad9366@gmail.com>
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

