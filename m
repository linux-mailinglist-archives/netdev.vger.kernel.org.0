Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75111439C0B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhJYQvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhJYQvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:51:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE45C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u12so4688445pjy.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8PghNy/avxVQfHWNjAjlXaqoKopvj9ocRaUMCgv5H0=;
        b=mxBu7WhTI5eWJAWz0NSTeIjAWPQH7N6QuVUFKD6nRvOVyfKIh74zAIbBkX3gSOPHRH
         yfShXPPPfEEezBQ88W4kyOGdo/1/Y84BwIywqxnLMNwu52gNGKHXo/lJJtg75VC0CvAn
         XnoewJIJ8gpBeuq67EtOAV0WqMgPv55HEuiC/yMQSO7to5ABODYMxdLkZ+KHdB90bqzv
         b+9mIrGHuVIBdlnnXu+POB4JI+QXr/HWXUl2BWWR0UTOUTs57hSZ3TRNnVr119VpijEG
         a4XkhV4OaBRbrvvo+r2p/dBsuk9DDQb1F3Laghznf3XTDX+IexbIKvDq192k+4TCsZ2k
         TOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8PghNy/avxVQfHWNjAjlXaqoKopvj9ocRaUMCgv5H0=;
        b=Rb+pGESpQRvORufOmRKeCODfIoru4MIh+wn415f+n9M2HEQq1ABvyNPG/aVxsi3V0l
         AmkPNZUrorH5yK5LOCVrK7XHsz+xDvmWeZDSUsoNaF/ZHEd4NoTZbU4bXav5PvZ7z0H1
         vKCGzL/Ve9v1KFRuIIbORMUdX7BO6WxMrLAcXE8BJpx623vzRZ5StPQSAPFUwNHURj8Z
         A9CfcOIxjy9IiB9o5D/m0NGCGyPD2UW8ZWUu+UR83CENfCSthPKE6C25L10KmXItV8EL
         9W9RLtyyEVoZ56kMfQFP7C9WEsvry947Y4XOTfTh8uQ9zRetf9aH6P+NbcztfrlCsAy0
         e/XQ==
X-Gm-Message-State: AOAM5329R+jeDbM728ASsBvMkpeBUo70vJY0egbHugWUzCzQw/IA/VSh
        b4qcqz1lEG5/thMENzyzyi0=
X-Google-Smtp-Source: ABdhPJyJFZxsCioHc5ojYvDNgrEdexAhjIppLFzFOW2CFDewRl6Y3gDNFSs+RbWudeY143/5Nevk0Q==
X-Received: by 2002:a17:902:aa03:b0:13f:a07e:da04 with SMTP id be3-20020a170902aa0300b0013fa07eda04mr17681273plb.80.1635180518478;
        Mon, 25 Oct 2021 09:48:38 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:38 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 08/10] ipv4: annotate data races arount inet->min_ttl
Date:   Mon, 25 Oct 2021 09:48:23 -0700
Message-Id: <20211025164825.259415-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

No report yet from KCSAN, yet worth documenting the races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/ip_sockglue.c | 5 ++++-
 net/ipv4/tcp_ipv4.c    | 7 +++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b297bb28556ec5cf383068f67ee910af38591cc3..d5487c8580674a01df8c7d8ce88f97c9add846b6 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1352,7 +1352,10 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		if (val < 0 || val > 255)
 			goto e_inval;
-		inet->min_ttl = val;
+		/* tcp_v4_err() and tcp_v4_rcv() might read min_ttl
+		 * while we are changint it.
+		 */
+		WRITE_ONCE(inet->min_ttl, val);
 		break;
 
 	default:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2bdc32c1afb65bb123a27444d9f6e4d01a188074..a9cbc8e6b796207f4880b2b32ff9289321080068 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -508,7 +508,8 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
+	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto out;
 	}
@@ -2068,7 +2069,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			return 0;
 		}
 	}
-	if (unlikely(iph->ttl < inet_sk(sk)->min_ttl)) {
+
+	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
 		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
 		goto discard_and_relse;
 	}
-- 
2.33.0.1079.g6e70778dc9-goog

