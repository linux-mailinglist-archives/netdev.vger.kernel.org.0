Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAE3B0C8D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhFVSLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3E6C08C5F1;
        Tue, 22 Jun 2021 11:05:14 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c22so123976qtn.1;
        Tue, 22 Jun 2021 11:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lFaVA8ynwTRBHLtjjsL9zt5M7ukivgd5igatTtTkqqU=;
        b=Op50wKqIim6pHEY+bq7PiGwf3e0ZppznyydcP4ySMyH/tHEtPOOuuiQ0cUKpggZi2e
         nvz3zJI000w33S3ewGsUBMSJxtYKwEN817vVcwtD5ZoKoXC7oB6jeef62qF+EC7VXZfS
         PWC2d4cVKpFjyoHLskSsq/Zd3KEvRrYVkkk4mOV5/jYWSex0CazAQ6lZeY2WBYoaETa+
         4xMyqwY2zFyflK9iOvIfGjVYmAfdkcDXxTh4+uWhiGStWBgP+WO79anDDD7uGS5FR63c
         U6BT7A9swpe7yo/Vg6CooTdUdOw+qIftLAG1NeqfXCvGvqPsyF74AoSQDpTOHDsU7D1O
         hkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFaVA8ynwTRBHLtjjsL9zt5M7ukivgd5igatTtTkqqU=;
        b=lXOyX3vvLiz69pL1ajN7y0uUl2DasVaPcoUdmLjqXxUR5Lo40BlVmP5OTOC5WL7GKa
         TYlha8AnaMyqGmBStzlh35LHalbOVecNY2tb4Y4e0axvng4mQnkCp6WEqF5e4cjBFAi1
         rj5jw1qlYcAgBd7rG4TDzLPWZc8xmCuoFm3LkiurqUNoGMzpJMYTweHgLe4q7ad0zw+B
         B3VOeZ+QmheSTXKSsxJQ6IcGh2dk5MTGI3Lg0fFIRg9YRJUqEBYEQVJ9VTLgOrsso9x5
         EJSnaov4Mtqx2+uPF3KZiYMVr5Y47M8YgAkpLj6gaW7MA3Wf5rMEOeG6wp1cVS40EEDq
         /+qA==
X-Gm-Message-State: AOAM530Vf06fMBHFohOjC03lQ54mptsNgxNtbqMwajdlbkuoBc3Bmjvf
        8O9qHbfRbZKSrPuiWcxTBRVszayN8ETQag==
X-Google-Smtp-Source: ABdhPJyfsnzfTGlE4pbgizHfv+SHv5c0XVNEqa/fbh17LYoiWhiAuAShO13Bq7uydGoiDdsiu/AqBA==
X-Received: by 2002:ac8:7f88:: with SMTP id z8mr25650qtj.77.1624385113675;
        Tue, 22 Jun 2021 11:05:13 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e10sm12969558qkg.18.2021.06.22.11.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:13 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 11/14] sctp: remove the unessessary hold for idev in sctp_v6_err
Date:   Tue, 22 Jun 2021 14:04:57 -0400
Message-Id: <9fece25ab4004dcfdd350d2b60f82cbe387fae96.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as in tcp_v6_err() and __udp6_lib_err(), there's no need to
hold idev in sctp_v6_err(), so just call __in6_dev_get() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/ipv6.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index bd08807c9e44..50ed4de18069 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -126,7 +126,6 @@ static struct notifier_block sctp_inet6addr_notifier = {
 static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			u8 type, u8 code, int offset, __be32 info)
 {
-	struct inet6_dev *idev;
 	struct sock *sk;
 	struct sctp_association *asoc;
 	struct sctp_transport *transport;
@@ -135,8 +134,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	int err, ret = 0;
 	struct net *net = dev_net(skb->dev);
 
-	idev = in6_dev_get(skb->dev);
-
 	/* Fix up skb to look at the embedded net header. */
 	saveip	 = skb->network_header;
 	savesctp = skb->transport_header;
@@ -147,9 +144,8 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	skb->network_header   = saveip;
 	skb->transport_header = savesctp;
 	if (!sk) {
-		__ICMP6_INC_STATS(net, idev, ICMP6_MIB_INERRORS);
-		ret = -ENOENT;
-		goto out;
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
 	}
 
 	/* Warning:  The sock lock is held.  Remember to call
@@ -185,10 +181,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 out_unlock:
 	sctp_err_finish(sk, transport);
-out:
-	if (likely(idev != NULL))
-		in6_dev_put(idev);
-
 	return ret;
 }
 
-- 
2.27.0

