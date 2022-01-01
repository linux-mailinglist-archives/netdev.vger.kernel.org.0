Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682E44826C6
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 06:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiAAFls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 00:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiAAFls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 00:41:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118D9C061574;
        Fri, 31 Dec 2021 21:41:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c3so8169965pls.5;
        Fri, 31 Dec 2021 21:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1dR3g8GY5Euozr0ox0MhudsRm4E1DeVHdsfvznKOpDk=;
        b=a2k/eogEwh6cFihXTy5Nay5P7MpFloJWyCc8jScDDXlHf8Bb0mJoCdAbczo+vMYTUz
         IIDImoWAsU7QBi8rAV2LLQmBmxjkgADtgUMgG/j93r+QfR5rLlhkuXLXCnTGc5H7ut0h
         9b7icckn/TMUa1zRS76kylBwoypdiu0TFJJPgvTJASq9WKLw2/PDrAx6KHZjFQohcY0d
         07eu7tq4U3no5TMsuvbJ/aMEu1bM1Z2JZU8z6IJCtI3ScRNebTOyLZXLEXtYfF6EVVq+
         IQs4RnUDgz/8j34LCvMWagWmnxzXZxgMP9RkIMN5A510r9tduBYUTBxLtm78UjLOu76p
         N03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1dR3g8GY5Euozr0ox0MhudsRm4E1DeVHdsfvznKOpDk=;
        b=RIIMpkJSoQ27ItUEFbzHaZ+VBA1hVs/OP/9ZbbX7b5SokSO4CEn6y9hB/W4Sa2DQHD
         O7GHlqf/0AqOTCNYPEd7OhjpfQD/QjppeVr4e3MmdDJfwovdjTAj4ECdcrfbXqe7xQMh
         8vC3qOmA+qeC9YLn0h8JunQLbjSWTSMxCG1O8IFPwCYkolwkZTI4AFPMTcWUOxLqqbtk
         0mudap7IsE655K1Cv+I6GzobJh0PECEWi96jCArh2QdLC+1+24Qyq11/mjn8YLRBV1G3
         d9ACAluz63jUE5wKOScfUOJhdvvNRg1XT+B/egWLLCSeO0In+BbDR7/dDARXgpbm/p4b
         TOiw==
X-Gm-Message-State: AOAM531Yzj1LbI5ZoBP3ya0z4ieX4V6ZNexh15Yuixi8eTQ4kaYvvtaL
        TVow4Pn2WXz8sdmaLXp4u3gA26yDTmy8VQH1TtU=
X-Google-Smtp-Source: ABdhPJzhiV/BmCtdaC4FnA4JF5VKsqhxHqY4YjYA5nKBJ3WiHVoJLknNK3uJIC1ixAAyKjOTUZReDw==
X-Received: by 2002:a17:90b:3b8e:: with SMTP id pc14mr46641451pjb.217.1641015707453;
        Fri, 31 Dec 2021 21:41:47 -0800 (PST)
Received: from gagan ([45.116.106.186])
        by smtp.gmail.com with ESMTPSA id cx5sm29448148pjb.22.2021.12.31.21.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 21:41:46 -0800 (PST)
From:   Gagan Kumar <gagan1kumar.cs@gmail.com>
To:     kuba@kernel.org, jk@codeconstruct.com.au
Cc:     matt@codeconstruct.com.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gagan Kumar <gagan1kumar.cs@gmail.com>
Subject: [PATCH v2] mctp: Remove only static neighbour on RTM_DELNEIGH
Date:   Sat,  1 Jan 2022 11:11:25 +0530
Message-Id: <20220101054125.9104-1-gagan1kumar.cs@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211231181709.7f46dbfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211231181709.7f46dbfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add neighbour source flag in mctp_neigh_remove(...) to allow removal of
only static neighbours.

This should be a no-op change and might be useful later when mctp can
have MCTP_NEIGH_DISCOVER neighbours.

Signed-off-by: Gagan Kumar <gagan1kumar.cs@gmail.com>
---
Changes in v2:
  - Add motivation and impact in the commit message.
  - Split long line > 80 chars into two.

 net/mctp/neigh.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 5cc042121493..6ad3e33bd4d4 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -85,8 +85,8 @@ void mctp_neigh_remove_dev(struct mctp_dev *mdev)
 	mutex_unlock(&net->mctp.neigh_lock);
 }
 
-// TODO: add a "source" flag so netlink can only delete static neighbours?
-static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
+static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid,
+			     enum mctp_neigh_source source)
 {
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_neigh *neigh, *tmp;
@@ -94,7 +94,8 @@ static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
 
 	mutex_lock(&net->mctp.neigh_lock);
 	list_for_each_entry_safe(neigh, tmp, &net->mctp.neighbours, list) {
-		if (neigh->dev == mdev && neigh->eid == eid) {
+		if (neigh->dev == mdev && neigh->eid == eid &&
+		    neigh->source == source) {
 			list_del_rcu(&neigh->list);
 			/* TODO: immediate RTM_DELNEIGH */
 			call_rcu(&neigh->rcu, __mctp_neigh_free);
@@ -202,7 +203,7 @@ static int mctp_rtm_delneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!mdev)
 		return -ENODEV;
 
-	return mctp_neigh_remove(mdev, eid);
+	return mctp_neigh_remove(mdev, eid, MCTP_NEIGH_STATIC);
 }
 
 static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
-- 
2.32.0

