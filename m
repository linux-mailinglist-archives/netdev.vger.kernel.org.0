Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8046AF6D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378758AbhLGAzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378755AbhLGAzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:31 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D5C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1257290pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uESlj0SebAtKU58T3/hnoy0rgiCsLFjX0HarrZvJTjA=;
        b=haFKdNKhWZ7RDgW2RRvl9yFR8dDodOEaL6bjjQOBnrpxqr9NjszWNCjW7ANYvOhZlt
         43OWPwnz6asXKb69WA361zSxbJlwHCiI2kJhw0U/4uO4C98c4mC1WacNV3Ayel1JcYxR
         wV2DFL5ChInIqsrhE/94UGjIxf1pRpfaimImIB21x1noQWS2vrKSMgEyY7pF31meIFyu
         hFtsyjX8J+osbGNXI+fWbBpk7lf0+1UNjlUJ9BBMVzHBUwolmAwEh3AoWjF5TH2pjcR2
         Tq3qCUyW3hnvW+6OwpMqxdMnhM0HCYRbAvCFCx6B+OmhCsHEEBlxXi10tw+eSysHfp9Q
         cGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uESlj0SebAtKU58T3/hnoy0rgiCsLFjX0HarrZvJTjA=;
        b=eD36uxJR/g8GPsOGLGBF5wTjUG1hWEMN1gl1+EnjvWjX//l27E5coeOsNhBCWIaiyP
         amrn+Zg9P74BOzTdg7M9TV55nnokhTd/SEGfWRvxb2nLBfEmb6rakeU7nIiM10OU0KvO
         sEIKt2PYpct3ia93ZzmoIvILRkJTjCEnw1oNPZNWA+yLUGoBdc5UdkbdmujTam9JOR3T
         QkpTOsuHQHyRrbxNK+LOi35o+bNNkglbUmGNx5U9poc0JnkDqUewwMUBwYgqwUJFXE2S
         g9UTQ2WB02N7h7zjAEBuwKHcntD2x4MfGyFUQAJEdYk3NmGIF5VeKKpHnfrf02ls5swE
         +NWw==
X-Gm-Message-State: AOAM530zGmeFp7//HM13GroLMFOHx0bIJ3u3gmYwx5TdxRr5r1wk6U2u
        uGfSHvTvlEP6DbK+iF2KCj3OG5OWDxg=
X-Google-Smtp-Source: ABdhPJzyjt0421vYQqqxvbnO2ypT/fAwqKUObJqA53kvOV0QTDCqzZFXqR05UAr5355OOEioGDJ6Og==
X-Received: by 2002:a17:902:ba84:b0:142:5514:8dd7 with SMTP id k4-20020a170902ba8400b0014255148dd7mr47877218pls.87.1638838321229;
        Mon, 06 Dec 2021 16:52:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/17] ppp: add netns refcount tracker
Date:   Mon,  6 Dec 2021 16:51:32 -0800
Message-Id: <20211207005142.1688204-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

