Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3661244C
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJ2Ppq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJ2Ppo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:45:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB9D63371
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w190-20020a257bc7000000b006c0d1b19526so6970616ybc.12
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCyffB4MSniqUYkonUIKsEsqK+rJqfdThOXNzyUknc8=;
        b=lZL59mF/wEpb41k+c39lqkSOaUxPEEyZTnq/6oVZC1F6BvtSC2A2uVtYm+82rtMgPC
         GKSxYOsXxdoO0fsWULG1Z13tw6dFdQX+0wNtVYaC0YyGotx8c5UCq3hQzm4TfoFLhJqi
         qaSv3Gw0Ko7ZUrSTkWsvp2IEvYRUOfACcb2r6gMfVqynimENwBq9Jl7Gf7OMsDIstxGP
         wVmachv2eyJjs950D2kxvKBoKGTdGVweTF0aKOAjcvJ0IhwCbN/rqYbSedbOeQ2SZjhq
         909+CqAaHopcz4z18p3QOaScCSVXoC/kjtVZGsydUFFaNdWZMstToicxaeZEwLvODSkL
         FMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCyffB4MSniqUYkonUIKsEsqK+rJqfdThOXNzyUknc8=;
        b=GOm/s9cFYWu9IcQ3jp/C6g7fW8/pFjKmlCVQbeJbuVogLOEHNiQskk44KgN7TWgbz/
         j77qIxczl6hEuXiNgEkuF4JIzwblPPRLFa15OxBkzT48HFDjVE/Xu7g5ZUfeUZtmt5D9
         kW/YXa0sPpZmEQLPlv4a103s8pdWYVwUCxgoHlTuq4S4YPxvSgPNnDF38ZT63qrSrscY
         JCHlsPNcpIo4dx/KeUcNt1/LVSjclahTJRuqCY1bP62pmCQmXkuPVwdGdgsQR6Q0Nzgi
         5rPvnAUD3bWDDt4xQrjDDt2isCVyVp9fK0cCmhJxS3fkz0qJJtDPDSR6pQuUHDuQ0lzv
         iNjg==
X-Gm-Message-State: ACrzQf118MpcsRsuSgQtNH0mRSLyD/9rD15FxlX55FXaSHMPpUBwuvEn
        lkdAmCbVSb9s765XiAYMX5Hjr0i4ffQMkA==
X-Google-Smtp-Source: AMsMyM7SfcBVMUHfY+zU/hCwGlrj/+/svCMaX2kmrUjLHB157RDyZPFN7bAmnSz0JhH4d+/eHII10XJySgPY+A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:b805:0:b0:6bc:ff7:b3ee with SMTP id
 v5-20020a25b805000000b006bc0ff7b3eemr4665204ybj.616.1667058334248; Sat, 29
 Oct 2022 08:45:34 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:45:20 +0000
In-Reply-To: <20221029154520.2747444-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221029154520.2747444-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029154520.2747444-6-edumazet@google.com>
Subject: [PATCH v2 net-next 5/5] net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 reassembly unit can decide to drop frags based on
/proc/sys/net/ipv4/ipfrag_max_dist sysctl.

Add a specific drop reason to track this specific
and weird case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 6 ++++++
 net/ipv4/ip_fragment.c   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 1d45a74148c305c6dd60408b98d3bf896dfcd599..70539288f9958716f9164cac3435cce34bd21f51 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -70,6 +70,7 @@
 	FN(PKT_TOO_BIG)			\
 	FN(DUP_FRAG)			\
 	FN(FRAG_REASM_TIMEOUT)		\
+	FN(FRAG_TOO_FAR)		\
 	FNe(MAX)
 
 /**
@@ -306,6 +307,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_DUP_FRAG,
 	/** @SKB_DROP_REASON_FRAG_REASM_TIMEOUT: fragment reassembly timeout */
 	SKB_DROP_REASON_FRAG_REASM_TIMEOUT,
+	/**
+	 * @SKB_DROP_REASON_FRAG_TOO_FAR: ipv4 fragment too far.
+	 * (/proc/sys/net/ipv4/ipfrag_max_dist)
+	 */
+	SKB_DROP_REASON_FRAG_TOO_FAR,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 85e8113259c36881dd0153d9d68c818ebabccc0c..69c00ffdcf3e6336cb920902a43f4ad046cc8438 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -256,7 +256,7 @@ static int ip_frag_reinit(struct ipq *qp)
 	}
 
 	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
-					      SKB_DROP_REASON_NOT_SPECIFIED);
+					      SKB_DROP_REASON_FRAG_TOO_FAR);
 	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
 
 	qp->q.flags = 0;
-- 
2.38.1.273.g43a17bfeac-goog

