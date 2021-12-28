Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2C480971
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhL1NKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbhL1NKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:10:33 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3446AC061574;
        Tue, 28 Dec 2021 05:10:33 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s1so14456163pga.5;
        Tue, 28 Dec 2021 05:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AaV3U4Q/YoY3GBRDKrb7mtceSC4KeM61/N6BjB4XkOM=;
        b=WCnV7riryFUCC8EyXq6wGlThahzfdlZn9gcTEcnphg57+EEz12W3qWsjq1fkIdCi+E
         pqXwPgs41MWob46EPMnm6ZalHdCkTNw+C258iV5PU9OelrVzIFWiPYjm3H9+8sBwebLQ
         DtWuC4Gnp8TE7SWQA4ZFs9H54135/WV+9nPSJtOFgdSBsHz3FFm0l8t81PWsOiwLZ7Ph
         6M/N4yTOehI1KRMdF+6u+CGSEPpNrhn4H5ryCH+n8KG7s9uie10L/6bL7G4VPl6pmJOo
         P+pLLr4vVXCb96uoRTMsTLCOpvb21XpgEIKZ/QaW9rvd50gI7aoKSmclDiqYO5ekrGjG
         CioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AaV3U4Q/YoY3GBRDKrb7mtceSC4KeM61/N6BjB4XkOM=;
        b=ZRGqGL4ifBscK8oza4dNGGvgs1g0Aey2Y1w2ljig+fDPWBO7G7gOoa50/7AbIoVWyV
         JpkpOhzHJpsy4K9hWKS0d0dKLDypJnhvtuutXF2uGlVOzSoTfRvhdJz0QWvIVup3ILcS
         TMP8Q3JLRpQRGdSW1jRLJjxAjvSjedvHOij9p6jyFoo94lfJXMHd6HA9guTjIGDQDfL9
         A+K47OJdYXkuzPl8iBkwyeTB5T9UsV6H4hc5az3XP/zRnYpummh6dVWxDQceCkH5xHdc
         iiGG9Dae+OYGxFkcKd1SHy/C8pNSFtpVCBUI6fEsf5IcOvXSF2vufxfsN/O66vXjjIQu
         ZS4Q==
X-Gm-Message-State: AOAM530/2zaEnf+GMLd+v5f8o1YPPZtqTf/AK+r6Bd7ETaacePJBDKiF
        fm0BuncZ0oLkVEek87+nAVg=
X-Google-Smtp-Source: ABdhPJzvP5bNSxfiXDIWQbXdmBTcpzQthLPZHQaONqRgeUch0HAQkHQf6eE56pcFkU9sRoBYl80crQ==
X-Received: by 2002:a05:6a00:1a03:b0:4ba:c23e:df67 with SMTP id g3-20020a056a001a0300b004bac23edf67mr22021603pfv.63.1640697032658;
        Tue, 28 Dec 2021 05:10:32 -0800 (PST)
Received: from gagan ([45.116.106.186])
        by smtp.gmail.com with ESMTPSA id mw8sm18813610pjb.42.2021.12.28.05.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 05:10:32 -0800 (PST)
From:   Gagan Kumar <gagan1kumar.cs@gmail.com>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gagan Kumar <gagan1kumar.cs@gmail.com>
Subject: [PATCH] mctp: Remove only static neighbour on RTM_DELNEIGH
Date:   Tue, 28 Dec 2021 18:39:56 +0530
Message-Id: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add neighbour source flag in mctp_neigh_remove(...) to allow removal of
only static neighbours.

Signed-off-by: Gagan Kumar <gagan1kumar.cs@gmail.com>
---
 net/mctp/neigh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 5cc042121493..a90723ae66d7 100644
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
@@ -94,7 +94,7 @@ static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
 
 	mutex_lock(&net->mctp.neigh_lock);
 	list_for_each_entry_safe(neigh, tmp, &net->mctp.neighbours, list) {
-		if (neigh->dev == mdev && neigh->eid == eid) {
+		if (neigh->dev == mdev && neigh->eid == eid && neigh->source == source) {
 			list_del_rcu(&neigh->list);
 			/* TODO: immediate RTM_DELNEIGH */
 			call_rcu(&neigh->rcu, __mctp_neigh_free);
@@ -202,7 +202,7 @@ static int mctp_rtm_delneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!mdev)
 		return -ENODEV;
 
-	return mctp_neigh_remove(mdev, eid);
+	return mctp_neigh_remove(mdev, eid, MCTP_NEIGH_STATIC);
 }
 
 static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
-- 
2.32.0

