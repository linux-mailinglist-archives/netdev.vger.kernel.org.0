Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F46750488F
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiDQRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 13:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiDQRNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 13:13:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FFE63F8
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 10:10:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u5-20020a17090a6a8500b001d0b95031ebso5233384pjj.3
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=84VJQi/2/yPzYKLQB3UGdKxxnh2pxi0liokf2t3z3C0=;
        b=eco7xcTdvKRBSg2qoFtNgyiwQHCMRe9+wAUO0NshNhp1/TcM61VSGXJz56qX0GP31Q
         jxRKTwMNRevDRxNlueIvr52IZNXHyrMIDVrLytOUeFysYhjOw9MK66LLArsLXHjyeogE
         XLLTOmdggvsP0OJlQAbFCJAJHY5TMKKGWuSE5C+kQgcMvXJPtOmcIDHt2qCIxxkSLkPe
         zEIv1Jr3C7IZDEfGzQo5X57FBuHz/xywXXKcW/ijOcIYwDxI5H3xf24tzOgRhIjBJO24
         7d8aXkY02ng4e1AMTAunmV7eT4Jppn1lpQHR4xOlq+3xpbqYLWNpyYf07vLiC3dIR4cd
         FGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=84VJQi/2/yPzYKLQB3UGdKxxnh2pxi0liokf2t3z3C0=;
        b=ClD6vN76Put2yiL13prDbnjgPdR52fxoRScdwzAO1hKycSXYg5iIK4Nf9JULZhbvy7
         6zI57OOaDTgO2kTks7oxDMoKJ/d/IC9RDKWQpc2Kyt7zmqssKYfAL2XErbuuOOL14vf0
         TDijHUZ121cBZCrZZKIrN170bDMVYwSkbvlW7mK65CfEDvzb+2ffMz74FjCPw99To1zp
         aFLYDPh0almeLZ8bVwrnA7H8qICzy0stoE57n/WlIknE9zaBcX764FNBOlOnKB4OWAyx
         bgyVj5/f2EBrFshHp4o5lRgrZgrA5kaegDvAjFq+bdTMJCqDuTnltDKnzPQYaibh/YaK
         pSzw==
X-Gm-Message-State: AOAM533aUoIh9mTG8e96Shz06/uCCaNgreyHrEoVDYkzrqK3f+xvjTtY
        yh1sJFcDEiV9rpimLmGJt7M=
X-Google-Smtp-Source: ABdhPJzT2unK0fz+s2wvT6Sdz1BDgqGiAOyhuIvyWamDH0KUFb59Nlb/IJsVxH2P2ABvVKDbR4bcLg==
X-Received: by 2002:a17:902:d709:b0:155:d473:2be0 with SMTP id w9-20020a170902d70900b00155d4732be0mr7360311ply.151.1650215431625;
        Sun, 17 Apr 2022 10:10:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2a7a:266f:bc8e:11ae])
        by smtp.gmail.com with ESMTPSA id c16-20020a631c50000000b003a39244fe8esm5861312pgm.68.2022.04.17.10.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 10:10:31 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] tcp: fix signed/unsigned comparison
Date:   Sun, 17 Apr 2022 10:10:27 -0700
Message-Id: <20220417171027.3888810-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
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

From: Eric Dumazet <edumazet@google.com>

Kernel test robot reported:

smatch warnings:
net/ipv4/tcp_input.c:5966 tcp_rcv_established() warn: unsigned 'reason' is never less than zero.

I actually had one packetdrill failing because of this bug,
and was about to send the fix :)

Fixes: 4b506af9c5b8 ("tcp: add two drop reasons for tcp_ack()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cf2dc19bb8c766c1d33406053fd61c0873f15489..0d88984e071531fb727bdee178b0c01fd087fe5f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5959,7 +5959,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 step5:
 	reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
-	if (reason < 0)
+	if ((int)reason < 0)
 		goto discard;
 
 	tcp_rcv_rtt_measure_ts(sk, skb);
-- 
2.36.0.rc0.470.gd361397f0d-goog

