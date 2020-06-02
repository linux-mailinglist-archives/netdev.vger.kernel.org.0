Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658721EB6F3
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgFBIFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBIFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:05:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FAAC061A0E;
        Tue,  2 Jun 2020 01:05:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b201so595469pfb.0;
        Tue, 02 Jun 2020 01:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VmsAWnP0O08xC6A5/1RKLXXMeARPygzzyLJjjBOAChY=;
        b=QDtXRSN+kdE4n7U+lfSCk+i6qwtZE06oSr5hlb9glQkQu5gzoyG8WNElhPTGX7Bz9r
         bO8MYBypauImxehYw9HTibVqrdKSfLsUNAanIieDIarNpuntaMqiNpeKRaE+hWeEbI9F
         DgkPF+OzsCNzSEBbDXQ5y2j2S2MwFpyqhC4HyTnVCS15ZV8RWZvZ9CUYn3pDU8291U2x
         /ACXph1uR2Dn0CnriE+lV9PVtcAl+4CmIc6oaAZkZxJW9plcMr8WGaTojaQQdLgtL1MD
         UKOd4n0YMuEfvzo9rC/zUCJvfs4vSg7rwc0q2XlirtMLufYDKEpRcJnzOGHRqxH3NRcq
         iM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VmsAWnP0O08xC6A5/1RKLXXMeARPygzzyLJjjBOAChY=;
        b=hgltD1hVcnK45awcR3KymCmZs50axeR6UZ0kwvboyvKLNWdqj3jtZnm0IJD2uu6Zyf
         rhd6FAw3ckZgjfqrIdeMSPmenLn9juIEHiEYWVhTv9oxy3HSxz2nb5OQ80makuTm6eLB
         BXkU2NPpUOcaIiA1hyJvurY5z8Ai4I3qFFnEHnBlpLEFojrQa/oUU08huFjzfecl3R7J
         Aj/jGRnkEAW940rClmcfijQ5amIJjsMkkCATNBUcvb6KrH1ZSjYI6qPtXZaArbPVETSE
         oTS9StbEMoFTtsAEjcfZ5Pm5oRRebpGouvJKmhw0YHHzHERabA5SR0/vYfc6BdatO468
         YFKA==
X-Gm-Message-State: AOAM533ZNoaL60kFmNOS3ehIvEARwcBIon9DiUsKVIWArS19YslGiZZr
        wrA2GUwewrjBvTEYztyf9vY=
X-Google-Smtp-Source: ABdhPJx1QIYuAIhcf3j5ThsKLfHs/AIlMrhWQJgS+dpOKutSnDkx5yhPN5dzRldYHQr+H9kf6UMXcg==
X-Received: by 2002:aa7:93ac:: with SMTP id x12mr26297388pff.143.1591085099727;
        Tue, 02 Jun 2020 01:04:59 -0700 (PDT)
Received: from localhost.localdomain ([45.192.173.250])
        by smtp.gmail.com with ESMTPSA id j7sm1545305pfh.154.2020.06.02.01.04.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jun 2020 01:04:58 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, kerneljasonxing@gmail.com,
        linux-kernel@vger.kernel.org, liweishi@kuaishou.com,
        lishujin@kuaishou.com
Subject: [PATCH] tcp: fix TCP socks unreleased in BBR mode
Date:   Tue,  2 Jun 2020 16:04:25 +0800
Message-Id: <20200602080425.93712-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kerneljasonxing@gmail.com>

TCP socks cannot be released because of the sock_hold() increasing the
sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
Therefore, this situation could increase the slab memory and then trigger
the OOM if the machine has beening running for a long time. This issue,
however, can happen on some machine only running a few days.

We add one exception case to avoid unneeded use of sock_hold if the
pacing_timer is enqueued.

Reproduce procedure:
0) cat /proc/slabinfo | grep TCP
1) switch net.ipv4.tcp_congestion_control to bbr
2) using wrk tool something like that to send packages
3) using tc to increase the delay in the dev to simulate the busy case.
4) cat /proc/slabinfo | grep TCP
5) kill the wrk command and observe the number of objects and slabs in TCP.
6) at last, you could notice that the number would not decrease.

Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Signed-off-by: liweishi <liweishi@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
---
 net/ipv4/tcp_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cc4ba42..5cf63d9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 	u64 len_ns;
 	u32 rate;
 
-	if (!tcp_needs_internal_pacing(sk))
+	if (!tcp_needs_internal_pacing(sk) ||
+	    hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
 		return;
 	rate = sk->sk_pacing_rate;
 	if (!rate || rate == ~0U)
-- 
1.8.3.1

