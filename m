Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1473F6D9AFB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbjDFOqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbjDFOpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:45:42 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA69A26B;
        Thu,  6 Apr 2023 07:44:58 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id h17so39746960wrt.8;
        Thu, 06 Apr 2023 07:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZSwILUq0bXFsvcMRWtndpmGM8P1qf1/sQjCxk4q0WaQ=;
        b=sk5WTKzXIQ4S/RT2IGTAT1q2Ph3JGvLwoTwMzBuWB3YGwnHCB0Jd30lpg6Y0XfWKCf
         QbePU3tPiClTEPRH+k4/6dOdjoKJjUMoBtzy2klUc4WuHvRzzwPp18Yf3+91qyACBOyg
         qPV/t57maMh5wgp8HATS3JPcBuym9fOvcWwTvDmyPyTx1ONlPbnlWkM3QYBOIFl67zSf
         /Y8C77QXXAFpt4uPoQHS42kC8Re9jcLHzLPCQ2e3ydm+9siL7aB14LcxfWUiBYnBwfmz
         L9BWlIF0sxmBio+r/k6DQXe1XiMIGsKaoO7u00df4gFMC6oLpvjPEx7zzmOmTTpo9HKF
         HlCQ==
X-Gm-Message-State: AAQBX9dOOxpI/c5XSMm+cEZls35g3NFcAbxrL+anb5TGYC+vqOXJd6Kj
        CwkFBXPB0tPersOeo/qtvAjMm8Y/D78UVw==
X-Google-Smtp-Source: AKy350Zn7t1xL+3RJUFBdw9cSQ8W+2kDMZmMrQPe3DuhdPo/XAA2bkpkQ5mYgwteGvnTnO9WbUeBwQ==
X-Received: by 2002:a5d:5259:0:b0:2e2:730a:c7dc with SMTP id k25-20020a5d5259000000b002e2730ac7dcmr7620959wrc.25.1680792239398;
        Thu, 06 Apr 2023 07:43:59 -0700 (PDT)
Received: from localhost (fwdproxy-cln-024.fbsv.net. [2a03:2880:31ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id d16-20020adff2d0000000b002df7c38dc3esm1927729wrp.87.2023.04.06.07.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:43:58 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Subject: [RFC PATCH 4/4] net: add uring_cmd callback to raw "protocol"
Date:   Thu,  6 Apr 2023 07:43:30 -0700
Message-Id: <20230406144330.1932798-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230406144330.1932798-1-leitao@debian.org>
References: <20230406144330.1932798-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of uring_cmd for the raw "protocol". It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which is similar to the SIOCOUTQ and SIOCINQ
ioctls.

The return value is exactly the same as the regular ioctl (raw_ioctl()).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/raw.h |  3 +++
 net/ipv4/raw.c    | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/net/raw.h b/include/net/raw.h
index 2c004c20ed99..ba7a96dce16b 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -99,4 +99,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 #endif
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
+
 #endif	/* _RAW_H */
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 94df935ee0c5..3db828bc1224 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -75,6 +75,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/compat.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 struct raw_frag_vec {
 	struct msghdr *msg;
@@ -857,6 +858,29 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
 	return do_raw_getsockopt(sk, level, optname, optval, optlen);
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCOUTQ:
+		return sk_wmem_alloc_get(sk);
+	case SOCKET_URING_OP_SIOCINQ: {
+		struct sk_buff *skb;
+		int amount = 0;
+
+		spin_lock_bh(&sk->sk_receive_queue.lock);
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb)
+			amount = skb->len;
+		spin_unlock_bh(&sk->sk_receive_queue.lock);
+		return amount;
+	}
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(raw_uring_cmd);
+
 static int raw_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -925,6 +949,7 @@ struct proto raw_prot = {
 	.connect	   = ip4_datagram_connect,
 	.disconnect	   = __udp_disconnect,
 	.ioctl		   = raw_ioctl,
+	.uring_cmd	   = raw_uring_cmd,
 	.init		   = raw_sk_init,
 	.setsockopt	   = raw_setsockopt,
 	.getsockopt	   = raw_getsockopt,
-- 
2.34.1

