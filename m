Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08706612337
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJ2NMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiJ2NMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:12:07 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FAD6A528;
        Sat, 29 Oct 2022 06:11:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s196so7078163pgs.3;
        Sat, 29 Oct 2022 06:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JJILX3ZbsEa361mIUD+wzD0iIrs7toiHw6XLt3BD9E=;
        b=qvYUTBXcXhBSZYb5Vsmt4UtsvcK4CfKtaeyCVNyMOxHcFos8BM09MT91GxuuJ/eZJ+
         xGP4CXooZLTZNvl7vT+3D6F92zVURH3EQ3qqAtqsa4tjAkcn6pwGaRZgLEpEcFD3m0Fx
         6qrsge+dqIDX35qqiQem0Nnch2Hm1DL51MwPysC533Nmd0MNaIo14e4NoSoXXL3LayrZ
         UrGTecy6IQyDLpV2gWe7SV91nMdF/Jk6we6PM7Vh7sA3oJN+MFtG14zdrLKlfO3RWa6b
         kQ+8cKQJ7P35HicspVCL7IRE3rUX72J41W7I/YI4K8584JAQEBYtJAlX1Mh45k/tVwoD
         wbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1JJILX3ZbsEa361mIUD+wzD0iIrs7toiHw6XLt3BD9E=;
        b=xtFBTaeQYrZpJzCDbD04ohVvJLo9NXXORmiuV7SZaNEswxrLiAB22YOMmFKnz5bAS1
         ZGZyf6DGdWY/cg1NqNK1pUuLG+IAkt4FagXZY293+caYHgJffqYzqCLwdR36BVpYhhZ9
         cdNunjTcKsI9SvB35Yv4wpkvXex6E2V9hC8e1djeuLn8n6dh6Sm7z0pJ51+qH8x11Q/g
         tEKy95bzon/pQYG7+bRCfN3PDDmahGE4oqS1dUDRZ9Lp75qC6dGzfxhwbf6Ft85KUyYz
         NR3Vn0iK3sSKFSJDmPCAAq9JQERUVYSH6grIy5t0B+/wzAKyB/OJ/eGUZHcUidYlZkLS
         cRfg==
X-Gm-Message-State: ACrzQf27VXBR8Rde9E0A6tQEAvR4etTgPAIqIm9JlLP7Wf1wB/R8a/YO
        9XvvMCTfHmH1u4UultTXeC0=
X-Google-Smtp-Source: AMsMyM76qICTm97A178uDAF6502Rdci2c5qRflRjgvcIKTN3xfTp98+5kiQl9jBPYbnYHziukUCAPw==
X-Received: by 2002:a05:6a00:1145:b0:52b:78c:fa26 with SMTP id b5-20020a056a00114500b0052b078cfa26mr4243643pfm.27.1667049098803;
        Sat, 29 Oct 2022 06:11:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:37 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 9/9] net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()
Date:   Sat, 29 Oct 2022 21:09:57 +0800
Message-Id: <20221029130957.1292060-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221029130957.1292060-1-imagedong@tencent.com>
References: <20221029130957.1292060-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The statistics for 'tp->linger2 < 0' in tcp_rcv_state_process() seems
more accurate to be LINUX_MIB_TCPABORTONLINGER.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e08842f999f8..e8623cea1633 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6608,7 +6608,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
-			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
+			NET_INC_STATS(sock_net(sk), SKB_DROP_REASON_TCP_ABORTONLINGER);
 			TCP_SKB_DR(skb, TCP_ABORTONLINGER);
 			return 1;
 		}
-- 
2.37.2

