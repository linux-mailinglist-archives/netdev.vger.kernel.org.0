Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6260454F4D5
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381518AbiFQKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381525AbiFQKGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A8369B49;
        Fri, 17 Jun 2022 03:06:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x138so3757309pfc.12;
        Fri, 17 Jun 2022 03:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLTpWfEYARxnaBZe2tmsRz6wbhK6fZ6IiWkByiKDceA=;
        b=MTh/VJ/tPqf9Tn4PdIuUuCnQnJbjOY07iXIBuJxeLqPfIaaxEh6MwuhScJYveVC7uV
         cIOLCVe59Y+XxUsWlvf7slHWxaODld9L4nZWZY2BnM3RPOZsHSmXMa+tJP8ZTCQdiAMt
         bl5qG8AuyRIpuO24OuNHvFS/KjtRziOh17bEpyTRddNV2Z2xAtW7uacdicJZapDhkDgg
         nacnAKz12TzUTzkvp3BDfI91N1LNwn5ABKLSV9jZ0SCXCMKZRiTAkEsFXS1SRIH3RYAb
         3I0uK7GAyHQQh1RyLO6/EUFb85Ugy1OtYw2obxQDE9FQGulaJ9G88lonyC690YyTmozu
         aiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLTpWfEYARxnaBZe2tmsRz6wbhK6fZ6IiWkByiKDceA=;
        b=1iid+DgEvVxwnSM6r1gglBpOcgjIFHvmJWvR75L+8oTn5HBLaw6XIWjMpTPwzdFfD+
         4v4DBluOQSIa/kZvPKQRo/2n8hWafirXkMLMiZqs6nG0HQ7eYQwtLQv7VjBJGAPc1zGa
         3CUmWBtiFY7kedD6CyP8IXeUHtipVE6ai39gINbHs1nllXwYwbUIle1+b15Sbq498pow
         Z/OPOT/y6EIWhXCbeN5Je/rXCLtxM022xzQvD8wXi4gB9ZJYwqX1xyN+ma46SMy9H/T4
         gnDON5Wk8IfY2IxiujciavWh6Qrwdb1UTOAP0i61uozHN6Bfcr9HtHupefbutTdVJ8j6
         3BHg==
X-Gm-Message-State: AJIora+DVF1BZqUcoXuISFykPO2LnCEmLwkU8tGYySeiEBjJdpJEz1qE
        mA/yJA0oChH06eNs7ifeLUw=
X-Google-Smtp-Source: AGRyM1svebNa295jU6OfIPgr5/df3AH5N3J7cq6DaBlh3kkmtgQRigFEocIov36fxPtUPtGMsUmcGA==
X-Received: by 2002:a63:dd56:0:b0:405:34ac:9bc9 with SMTP id g22-20020a63dd56000000b0040534ac9bc9mr8489797pgj.324.1655460372657;
        Fri, 17 Jun 2022 03:06:12 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:12 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v4 4/8] net: inet: add skb drop reason to inet_csk_destroy_sock()
Date:   Fri, 17 Jun 2022 18:05:10 +0800
Message-Id: <20220617100514.7230-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

skb dropping in inet_csk_destroy_sock() seems to be a common case. Add
the new drop reason 'SKB_DROP_REASON_SOCKET_DESTROIED' and apply it to
inet_csk_destroy_sock() to stop confusing users with 'NOT_SPECIFIED'.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/dropreason.h        | 5 +++++
 net/ipv4/inet_connection_sock.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index fae9b40e54fa..3c6f1e299c35 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -231,6 +231,11 @@ enum skb_drop_reason {
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/**
+	 * @SKB_DROP_REASON_SOCKET_DESTROYED: socket is destroyed and the
+	 * skb in its receive or send queue are all dropped
+	 */
+	SKB_DROP_REASON_SOCKET_DESTROYED,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index c0b7e6c21360..1812060f24cb 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1129,7 +1129,7 @@ void inet_csk_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
-	sk_stream_kill_queues(sk);
+	sk_stream_kill_queues_reason(sk, SKB_DROP_REASON_SOCKET_DESTROYED);
 
 	xfrm_sk_free_policy(sk);
 
-- 
2.36.1

