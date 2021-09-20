Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1AB4112C6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhITKUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 06:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbhITKUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 06:20:51 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757F4C061760
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:25 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a10so40706896qka.12
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=owsya/fAc4fC+5PO3VaM2gMWH9/gcNYLcnGTc5c6gMI=;
        b=dmJJatofPyUDttQb7mA0XbmpfYIkfmQctAk6+blkE06fNgM2cGXjCnDMJ2G9Shgkx7
         ymsaKg968hiZVvn53+TJVbmvVD2wIhAxRyuZNqYxxDaIqSSze19jAhuciCXdOvZzR+Vr
         py6SxGoH4iV7dIPSKzrVT7w08/kS8/iuBOuFTE5u+GwsKVt7xRwhMYmJP+8FkK6swGo1
         9l8AiD2W0REcfVgKJTIFZuhwgaiB94awJ80qaiNmYcQ2u7qHieKqkgf8B8vXommOmubK
         emSAoD4yZpNv6nbgRtO8MrcuYFbLkbg7hiSmN9zJRYwt0SvgDRbuas3iTMFj+w2oTJsC
         f1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=owsya/fAc4fC+5PO3VaM2gMWH9/gcNYLcnGTc5c6gMI=;
        b=kY82bAnoskR6Z7kO8q7/ab/okcA2P+jI3HeItRF2zR2GVn+57h1dlzZV6FouehtvCD
         A9xhUcZn6Mysd3tOvbNq1xpQc4kmEIKSFxXEa/nM13tubCQakfjo6nzZtsWHdR8eHYdT
         zz/mHzFRjOodPxL97mhtO+qWtPvuXtXTz6mEBeftK33/SNspDxCbo/Is5xw2J1zh8HA+
         vPpb8zWKyggQFr1+cbP0uksYepHqUgG0PyR6e8x6bneZb8hEY7z55n9GLltGzEXKI6ZS
         /Q3ziwH39bMTOJViOn5/7r+N5FvjzQoBD4Wp21z98MYN7olmPg6U6Txa5d/2gNoruIpx
         j83g==
X-Gm-Message-State: AOAM533Dwau5uARO4jUtofub0MQhkKO3hmoMqPRupPaj1ZksEdovvXp4
        FraraDQJ2B9yzb2kP7+Ubzoylf6N/0AqoA==
X-Google-Smtp-Source: ABdhPJxWT2Ra6OsbRDugggOqsr//iLJ+TjaoK7xcHsWVP0q/xGKAt9BTXTRmwXtA1H0ssbTt/VXYEA==
X-Received: by 2002:a05:620a:430f:: with SMTP id u15mr23488968qko.32.1632133164470;
        Mon, 20 Sep 2021 03:19:24 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u9sm4637985qke.91.2021.09.20.03.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 03:19:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] net: sched: drop ct for the packets toward ingress only in act_mirred
Date:   Mon, 20 Sep 2021 06:19:21 -0400
Message-Id: <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1632133123.git.lucien.xin@gmail.com>
References: <cover.1632133123.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
those packets that are mirred or redirected to only ingress, not
ingress and egress.

This patch is to move nf_reset_ct() to tcf_mirred_forward() and to
be called only when want_ingress is true.

Fixes: d09c548dbf3b ("net: sched: act_mirred: Reset ct info when mirror")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_mirred.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index d64b0eeccbe4..46dff1f1e7c8 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -205,14 +205,12 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 
 static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
-	int err;
-
 	if (!want_ingress)
-		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else
-		err = netif_receive_skb(skb);
+		return tcf_dev_queue_xmit(skb, dev_queue_xmit);
 
-	return err;
+	nf_reset_ct(skb);
+
+	return netif_receive_skb(skb);
 }
 
 static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
@@ -271,9 +269,6 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
-	/* All mirred/redirected skbs should clear previous ct info */
-	nf_reset_ct(skb2);
-
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
 
 	expects_nh = want_ingress || !m_mac_header_xmit;
-- 
2.27.0

