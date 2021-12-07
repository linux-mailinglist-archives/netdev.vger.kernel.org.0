Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB5446AFDA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351784AbhLGBfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhLGBeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:50 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB49C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:21 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 8so11836195pfo.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zBd5jniNUBoWcP1WUAWhYgrOff5AQ2Nwkrlj8LiKJvQ=;
        b=LasREC6htbu6VOqxLS01VFgT5iy4y9ahG8BSHMiFR9CqDYlFcoTLu0GyidTIZ+6ljk
         19G0uT1oQveEVg6fnMbnbPvRMwZTH6iVC61yTCC9AVdcP62x/gnqlLNEby+HxNRhrU99
         x4JfSnxuQbqPjfjJ/+6S8ivzR9ZeRG99FT4oUNAlXkGS3lw2ImvO3524u+7Wb5Adq6zo
         pKQmZg3QiKznKPGVqNNBH6f4/aSroo1n5hYk9yd4R6XUoAaZmdNUiK+zoq2SOD4Ga9Vp
         amAPX5mwn7IbNS1iYWso/41LV498dhz6VL8kJWEkTmMxHCSX0FTIsRVMkJZ/7Y+et3it
         0nBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zBd5jniNUBoWcP1WUAWhYgrOff5AQ2Nwkrlj8LiKJvQ=;
        b=t9GwbegwIq2PWFkzGCxmvfB/CZ9KI/2cIWWFv7HMwZOcx0TizE/KXzcos55upm86yk
         NYf9dfGP7HqkvacVhrr9in95VgsibQT8bk5BzH+g867eP8n5mNqtyiSDWnk+Gp+lWjfL
         6C2H5c1UJoLMcEDGxUuoxszSnfRYlzVB8IQhhiPZEdTdUQZIuHLoUbuw1T6Hk9k8o6RI
         lrqR3Ei3FzAk3+wy9Pm4sHDaNNJ+nPFsYfaDBnj59TDwcLe1cwYbgReoZrZef1AlbCNE
         zHt3j+sdfC+HVwi7cgRHVQbYKApgvMmLhzQ8hKh1hHaOKNhcZN0vT5A1uM5/9YNfqeIK
         BukQ==
X-Gm-Message-State: AOAM533WHMFIgyb9Gs1iQ3mj0WXQoV1uI9Q4iVQKNErrgBmifnlPukyw
        Jp4ebJrmpcFfIE/JU/sCg+g=
X-Google-Smtp-Source: ABdhPJz5kgsAVVmnhPIeiySCJO+cQDspf7hSdVkQAhvc3YWYNJZSN/NXHu1QMc8UTfaopywsa5CzQQ==
X-Received: by 2002:a05:6a00:986:b0:4a2:c1fa:8899 with SMTP id u6-20020a056a00098600b004a2c1fa8899mr40399374pfg.61.1638840680726;
        Mon, 06 Dec 2021 17:31:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:20 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 13/13] net: sched: act_mirred: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:39 -0800
Message-Id: <20211207013039.1868645-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tc_act/tc_mirred.h |  1 +
 net/sched/act_mirred.c         | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/tc_act/tc_mirred.h b/include/net/tc_act/tc_mirred.h
index 1cace4c69e4450963e5392a555d7b3fd9f10456d..32ce8ea36950e86745cc1d31f49e69962ff2c6ee 100644
--- a/include/net/tc_act/tc_mirred.h
+++ b/include/net/tc_act/tc_mirred.h
@@ -10,6 +10,7 @@ struct tcf_mirred {
 	int			tcfm_eaction;
 	bool			tcfm_mac_header_xmit;
 	struct net_device __rcu	*tcfm_dev;
+	netdevice_tracker	tcfm_dev_tracker;
 	struct list_head	tcfm_list;
 };
 #define to_mirred(a) ((struct tcf_mirred *)a)
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index efc963ab995a333ab21ec3d00884097c6a10a2b4..952416bd65e6ae00fe048a32b37252d1ed13ef0a 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -79,7 +79,7 @@ static void tcf_mirred_release(struct tc_action *a)
 
 	/* last reference to action, no need to lock */
 	dev = rcu_dereference_protected(m->tcfm_dev, 1);
-	dev_put(dev);
+	dev_put_track(dev, &m->tcfm_dev_tracker);
 }
 
 static const struct nla_policy mirred_policy[TCA_MIRRED_MAX + 1] = {
@@ -101,7 +101,6 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	bool mac_header_xmit = false;
 	struct tc_mirred *parm;
 	struct tcf_mirred *m;
-	struct net_device *dev;
 	bool exists = false;
 	int ret, err;
 	u32 index;
@@ -171,16 +170,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	spin_lock_bh(&m->tcf_lock);
 
 	if (parm->ifindex) {
-		dev = dev_get_by_index(net, parm->ifindex);
-		if (!dev) {
+		struct net_device *odev, *ndev;
+
+		ndev = dev_get_by_index(net, parm->ifindex);
+		if (!ndev) {
 			spin_unlock_bh(&m->tcf_lock);
 			err = -ENODEV;
 			goto put_chain;
 		}
-		mac_header_xmit = dev_is_mac_header_xmit(dev);
-		dev = rcu_replace_pointer(m->tcfm_dev, dev,
+		mac_header_xmit = dev_is_mac_header_xmit(ndev);
+		odev = rcu_replace_pointer(m->tcfm_dev, ndev,
 					  lockdep_is_held(&m->tcf_lock));
-		dev_put(dev);
+		dev_put_track(odev, &m->tcfm_dev_tracker);
+		netdev_tracker_alloc(ndev, &m->tcfm_dev_tracker, GFP_ATOMIC);
 		m->tcfm_mac_header_xmit = mac_header_xmit;
 	}
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -400,7 +402,7 @@ static int mirred_device_event(struct notifier_block *unused,
 		list_for_each_entry(m, &mirred_list, tcfm_list) {
 			spin_lock_bh(&m->tcf_lock);
 			if (tcf_mirred_dev_dereference(m) == dev) {
-				dev_put(dev);
+				dev_put_track(dev, &m->tcfm_dev_tracker);
 				/* Note : no rcu grace period necessary, as
 				 * net_device are already rcu protected.
 				 */
-- 
2.34.1.400.ga245620fadb-goog

