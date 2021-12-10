Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA73246FC04
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhLJHsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbhLJHsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DD0C061A32
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:45 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i12so7741211pfd.6
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fswLm17K9FUOjTCZo1tEwPooYov4M7cVFHiKdQKFhL0=;
        b=FakCLBye1J1Q5C1gcK7SN2vOLDTwi/6LOTW3/uPuCfX73zawXCnLepP4BrRdp++LJj
         exrungIB+zJm+nJgArln4OmpIaYghOxopdFllCTBGSoqmitlLXv1DwTNKDTiMZowdxSL
         Ri/0j27W2WMRKG5u/wBNmB+a+oPGJfzxUc5g4u9kVsxSIxxKhjrTcn6a98tZhHAk/wo5
         A7IC/9Ovcxcg8HutvRvVIJBEeLUpFkm+7OwQNnPJ28Xc/k5MmnU9CLdqI82cblYYLlzB
         C+4Dl+FJl5XlEPe5lXdoXYXCC4jVQGIQfyLHYgV65rVWFcGCEpHsBXTIk717vVSXTajF
         aSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fswLm17K9FUOjTCZo1tEwPooYov4M7cVFHiKdQKFhL0=;
        b=sbIGjUSDdwMnTo/xrBiCHMqb8JrpQbWNOgwKs5kotBC7l4hPo1HJC64TPMf3+URupO
         wtZK2TLMKq6nuL5Bdkod1MMwDVW1OcNNEtSgF3N+HZMzxXt7ndGTd6QWEdThuKrz5yb1
         vEMrWB6Fw7bKTmrQoagXyFci1D2dd/PMDPKyQf0x6lEt0xO4KDsydjIbQi/92luXuZU4
         hHNAWXQG8jWByw3c50rRSw9e08miYa8ldwd9StosbxEvP0aUiJaPzp+MRxm0npDPEZig
         oH/7ItpqGMhNUh01Qce70TV0VDDE/tqadMwJes2H5Tu4JWpAOikxW1lsRAr9Fo60/6pN
         b6ng==
X-Gm-Message-State: AOAM532ih0j4WdQezX7hyuSJc67amWsWU4cKR4dAlw7+hRFkFC9vnW+p
        lDmmtMGiY8JQ7KGgGm4SReM=
X-Google-Smtp-Source: ABdhPJxm6KHu5Typ/53v8G2XZB4Uh3CI0PNzSP0P3NdEyKxK0x8PE2+ANMwvFcYtCwQFqPJsq+5/1g==
X-Received: by 2002:a05:6a00:16c6:b0:4a8:261d:6013 with SMTP id l6-20020a056a0016c600b004a8261d6013mr16350409pfc.82.1639122285327;
        Thu, 09 Dec 2021 23:44:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 6/6] ppp: add netns refcount tracker
Date:   Thu,  9 Dec 2021 23:44:26 -0800
Message-Id: <20211210074426.279563-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ppp/ppp_generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 1180a0e2445fbfb3204fea785f1c1cf48bc77141..9e52c5d2d77fce39b230605ec96fed9798858a13 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -173,6 +173,7 @@ struct channel {
 	spinlock_t	downl;		/* protects `chan', file.xq dequeue */
 	struct ppp	*ppp;		/* ppp unit we're connected to */
 	struct net	*chan_net;	/* the net channel belongs to */
+	netns_tracker	ns_tracker;
 	struct list_head clist;		/* link in list of channels per unit */
 	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
 	struct channel __rcu *bridge;	/* "bridged" ppp channel */
@@ -2879,7 +2880,7 @@ int ppp_register_net_channel(struct net *net, struct ppp_channel *chan)
 
 	pch->ppp = NULL;
 	pch->chan = chan;
-	pch->chan_net = get_net(net);
+	pch->chan_net = get_net_track(net, &pch->ns_tracker, GFP_KERNEL);
 	chan->ppp = pch;
 	init_ppp_file(&pch->file, CHANNEL);
 	pch->file.hdrlen = chan->hdrlen;
@@ -3519,7 +3520,7 @@ ppp_disconnect_channel(struct channel *pch)
  */
 static void ppp_destroy_channel(struct channel *pch)
 {
-	put_net(pch->chan_net);
+	put_net_track(pch->chan_net, &pch->ns_tracker);
 	pch->chan_net = NULL;
 
 	atomic_dec(&channel_count);
-- 
2.34.1.173.g76aa8bc2d0-goog

