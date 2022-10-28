Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680CC6112CB
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiJ1NbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiJ1NbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:31:00 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B281BB56E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:59 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id i4-20020ac813c4000000b003a5044a818cso1676882qtj.11
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=egV3NVpWdy5jA+rc7AFJDo41XjgjLknqSr2qnbG9W7s=;
        b=Mez6uEy/kGq9X94NxlTLdU5n0QEikZu6WomiCisw5rFZlg9Gg7cyfdHGYT5S//1b/g
         bIFP6CCBGSJ4eqq0M1eFOtsMuX0Vv5jBP1yhgdmkUOLDY9pd3soSWjV2MuaKi+aY9F0P
         4SBRUnVGcN6xkGIAFirHHpvb4ah2LIGxabd6M6g4MZYp8In0R/dYj+t0u8KaaPnv1OA7
         BOxnP9oFLtX7AmnFFRtOPfmQD3TUXHP86yKaO4S2LKZfHz7VbnukJffhOBFj7BNogFWV
         VEokZnDpgkSF1edLK+h9ctCyKbwFkSruY3NhUMQZWMFmbmf5r8p36mMAHOMZd94PSJwR
         /14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egV3NVpWdy5jA+rc7AFJDo41XjgjLknqSr2qnbG9W7s=;
        b=CxpWr19VqzRopMqZNdUQkfRpLMesvt1QsMAwEb6PigaWZUC+uvuEWac1Mz3t8ALdR5
         GpfytLizvhMN5N8eCGaqblHMyDtOCP5VASlWZoMrY5eda4NQcjEHHcifJn4O8fYGd9jH
         sTDGQc6xNIXIocM4klsrNe42i88GtiwmqyoEwn937M8F2GIAkohQ1h642DGhCj5TIW4r
         rUZPX2rom9zq4EOLpUxaUyWNabkBpw1ccvvL5cd43IThed8Z31ygWzbl/ZvYsB+ttOvJ
         UxE9SVt25wNkMZ5Fa44N7E3mx+MaCPpp/MrVj+b8R1J6yX1kwZ79+8UyqcC2/4Z4ic+4
         H0CA==
X-Gm-Message-State: ACrzQf2ryaHoeaZckMkfaAIB6YXSOfLOCCvoBBm+PIA2bdVyCPJs6qgr
        jtHN5nESx6SIuhLdNW4I2AYta3WLEqFJ3Q==
X-Google-Smtp-Source: AMsMyM6NLsVDQn4wABNcOndO1CZ6MAQ0z9J9Px4qT2Zaiy0FtWOsnHO2j9vwgy64srf2e/0eSazatkAzRXce5Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:29c6:b0:6ee:cf89:40cb with SMTP
 id s6-20020a05620a29c600b006eecf8940cbmr38922140qkp.107.1666963858817; Fri,
 28 Oct 2022 06:30:58 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:30:43 +0000
In-Reply-To: <20221028133043.2312984-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221028133043.2312984-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028133043.2312984-6-edumazet@google.com>
Subject: [PATCH net-next 5/5] net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR
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
index d3d44da889e4f002ed1485a10fd081184956c911..d3df766c117bc1b0373d9e19d9baad944b5fb776 100644
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
 	/** @FRAG_REASM_TIMEOUT: fragment reassembly timeout */
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

