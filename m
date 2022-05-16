Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B91527C82
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbiEPDqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239802AbiEPDqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:46:17 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC235A9A;
        Sun, 15 May 2022 20:45:59 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c11so13244914plg.13;
        Sun, 15 May 2022 20:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0SkwE7BtienOsXtLAXbao8++DFmn5xtmncAv1lNe8cg=;
        b=lsfQB/F6AiLdnC1aTrNIp+6yqA/uNJDY9QOqivFXaR25FXpTbkqVtTYk6s29Tjv6HJ
         7vN3FoIPN9U1LqY7p8V7azfTdu6YbNJem1F9c7huIaaaDKaAdxH1LQHJ84FL8q+3Rx6B
         TeQl8W+L8z9U256+F0IcvG56weBZvCL5XswBC9OZi0ebfR+jRjU1fRnKfxgqzQtu9L/X
         kZIQP4x5ibVb+p+F+ZMeVeHJlukrfp8F4bdfSrS3z4oTUJmaaw9eiJe/vFvBnxoyI2vu
         AYyWsn7l+QcRNbM9N2QKD12KhlNjBhfwHu9I1HL1XYTyTd4CV8wkIaWeuiVy+XREL8bl
         I8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0SkwE7BtienOsXtLAXbao8++DFmn5xtmncAv1lNe8cg=;
        b=BDKVhQaXVj9ekn0QEPgxg1ku0B2WFsDq++/gms1j4N2KEBOT9rN1ixFg6z/oZow3/c
         m/VK9iSokkuWv8iC0rL42fg5jyP7hvwjYTOyp7JMg2AlKNaOqtmSkfIY8aQexwheXvYh
         ONvA31gJhVrEv9e1A/a9fl6N+EuXtNKabTRN0t2jzcl2oyI7kLjROlK/zwewoxEYGDsl
         TapDdsiACY00JZ5TsyXGLkhSBt+hWh0PhtG4M29yH3JNDNhdH/9zIrNmetteoRyO39MT
         L2MemYyhEVPRs8lJ1mTn9Q5vatQRPuoyz78E72FDMhgwR9fqL9K8P/W1c+LyXphCgl5D
         hAsg==
X-Gm-Message-State: AOAM532W9AG6TpV+RUDjSHeXziEpQF9NFICDU4L1UeXfgNEvhf+DmBd6
        b/xnJMSPW63foUAxSNJNPfw=
X-Google-Smtp-Source: ABdhPJxucF+5S8I8GvShfpRmYqehs4xjYg69XWU2Rjh7JfGWWVOlk0RJseCZLPFe8mVIv0bkupUgWA==
X-Received: by 2002:a17:90b:3b8d:b0:1dc:7637:91c3 with SMTP id pc13-20020a17090b3b8d00b001dc763791c3mr28328121pjb.186.1652672758913;
        Sun, 15 May 2022 20:45:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:45:58 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 5/9] net: tcp: make tcp_rcv_synsent_state_process() return drop reasons
Date:   Mon, 16 May 2022 11:45:15 +0800
Message-Id: <20220516034519.184876-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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

The return value of tcp_rcv_synsent_state_process() can be -1, 0 or 1:

- -1: free skb silently
- 0: success and skb is already freed
- 1: drop packet and send a RST

Therefore, we can make it return skb drop reasons on 'reset_and_undo'
path, which will not impact the caller.

The new reason 'TCP_PAWSACTIVEREJECTED' is added, which is corresponding
to LINUX_MIB_PAWSACTIVEREJECTED.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 1 +
 net/ipv4/tcp_input.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3c7b1e9aabbb..36e0971f4cc9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -619,6 +619,7 @@ struct sk_buff;
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
 	FN(SOCKET_DESTROYED)		\
+	FN(TCP_PAWSACTIVEREJECTED)	\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 97cfcd85f84e..e8d26a68bc45 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6174,6 +6174,10 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 				inet_csk_reset_xmit_timer(sk,
 						ICSK_TIME_RETRANS,
 						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
+			if (after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+				SKB_DR_SET(reason, TCP_ACK_UNSENT_DATA);
+			else
+				SKB_DR_SET(reason, TCP_TOO_OLD_ACK);
 			goto reset_and_undo;
 		}
 
@@ -6182,6 +6186,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			     tcp_time_stamp(tp))) {
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_PAWSACTIVEREJECTED);
+			SKB_DR_SET(reason, TCP_PAWSACTIVEREJECTED);
 			goto reset_and_undo;
 		}
 
@@ -6375,7 +6380,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	return 1;
+	return reason;
 }
 
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
-- 
2.36.1

