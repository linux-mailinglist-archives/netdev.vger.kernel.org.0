Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE9377386
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhEHSBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhEHSBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 14:01:42 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5DBC061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 11:00:39 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q136so11725238qka.7
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 11:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kvK/pmKFbOnmCou6ksgxatSaJjM4bLAVrNMa/otiXME=;
        b=IHpmeEW3XlRhN6SE2wohv0X2T0jGL9Hzd4DwrsERyIC1Tn/ukesGNWsShdMu7QKLjF
         51/3HgrwL2xWqVxZxwU+F8tCOMT5+DPwyOTu6b3YS7h4+vwzexvYsoGV3LHmMfav8lhA
         n/fcmW+24LO7sIiZNceBolT21IwaxpmUFW4NBWzeom+tShVyaJ9HJqW9jUaHIgmcDyDf
         Mh1mxAYoDqlfSbOl58FnPoC0XuahD/ySTEnMb/O859XCSyWOQYSSCAESYwlwn3s8EfGS
         Dd2ZglnWe5ssz0g+Oe5Palo4WRBRQWmf7RcvOMN/HWH5bU6kncsAnrWcjwDMu9iAB7l5
         Gm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kvK/pmKFbOnmCou6ksgxatSaJjM4bLAVrNMa/otiXME=;
        b=Ypq5ZsOUYIQFswCjLOQYSw4LxD32tbxF9bYVHyOFBBAkHNKVdscSgHwWda55BkgHaS
         u/LYFuiF8aoX6eXefxW9DQes518/+qwVjoIjB3KATGGhleYhJBeSvYlgxNl9WcX5sd66
         Fh7SHXdgL1vYTOYUZ8Ob5WIdqo3wXvdzKyQyC8Cb6wxcjy7YAUvvs6EdtIyvT3qTANa+
         JdZFfss3Q4VD82icbREnZnJTVP/imJq5Tz+c73KF3ypIQfjkvK23KLUGDqbW3UrnQ8P3
         hMbRt8jztYpcrlQGhllAPQLsqRI6VhuiXGh+6+R2k4DKa2uae7pDlvVsigc8MBpzjcxx
         3r1Q==
X-Gm-Message-State: AOAM533MjNCkggMi7aeLV4f2NgmkvTyVrxLPoj00sqOKyQEYu181cAwE
        ikKBgJDiC4XRaERCXgImzm1jgH/BuEci4w==
X-Google-Smtp-Source: ABdhPJwjEJeKrtNyjXnFmt5YwBKFfNm1Gz6RL18UCbdqO5OLKropaySweD+fyc0B/jEOjePIuV3IoQ==
X-Received: by 2002:a37:27cd:: with SMTP id n196mr14659794qkn.420.1620496838872;
        Sat, 08 May 2021 11:00:38 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id o10sm6153290qki.72.2021.05.08.11.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 11:00:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>
Subject: [Patch net v2] rtnetlink: avoid RCU read lock when holding RTNL
Date:   Sat,  8 May 2021 11:00:33 -0700
Message-Id: <20210508180033.44455-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When we call af_ops->set_link_af() we hold a RCU read lock
as we retrieve af_ops from the RCU protected list, but this
is unnecessary because we already hold RTNL lock, which is
the writer lock for protecting rtnl_af_ops, so it is safer
than RCU read lock. Similar for af_ops->validate_link_af().

This was not a problem until we begin to take mutex lock
down the path of ->set_link_af() in __ipv6_dev_mc_dec()
recently. We can just drop the RCU read lock there and
assert RTNL lock.

Reported-and-tested-by: syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Tested-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/rtnetlink.c | 26 +++++++-------------------
 net/ipv4/devinet.c   |  4 ++--
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..04b4f0f2a3d2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -543,7 +543,9 @@ static const struct rtnl_af_ops *rtnl_af_lookup(const int family)
 {
 	const struct rtnl_af_ops *ops;
 
-	list_for_each_entry_rcu(ops, &rtnl_af_ops, list) {
+	ASSERT_RTNL();
+
+	list_for_each_entry(ops, &rtnl_af_ops, list) {
 		if (ops->family == family)
 			return ops;
 	}
@@ -2274,27 +2276,18 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
 			af_ops = rtnl_af_lookup(nla_type(af));
-			if (!af_ops) {
-				rcu_read_unlock();
+			if (!af_ops)
 				return -EAFNOSUPPORT;
-			}
 
-			if (!af_ops->set_link_af) {
-				rcu_read_unlock();
+			if (!af_ops->set_link_af)
 				return -EOPNOTSUPP;
-			}
 
 			if (af_ops->validate_link_af) {
 				err = af_ops->validate_link_af(dev, af);
-				if (err < 0) {
-					rcu_read_unlock();
+				if (err < 0)
 					return err;
-				}
 			}
-
-			rcu_read_unlock();
 		}
 	}
 
@@ -2868,17 +2861,12 @@ static int do_setlink(const struct sk_buff *skb,
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
-
 			BUG_ON(!(af_ops = rtnl_af_lookup(nla_type(af))));
 
 			err = af_ops->set_link_af(dev, af, extack);
-			if (err < 0) {
-				rcu_read_unlock();
+			if (err < 0)
 				goto errout;
-			}
 
-			rcu_read_unlock();
 			status |= DO_SETLINK_NOTIFY;
 		}
 	}
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 2e35f68da40a..50deeff48c8b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1955,7 +1955,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int err, rem;
 
-	if (dev && !__in_dev_get_rcu(dev))
+	if (dev && !__in_dev_get_rtnl(dev))
 		return -EAFNOSUPPORT;
 
 	err = nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla,
@@ -1981,7 +1981,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
 			    struct netlink_ext_ack *extack)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int rem;
 
-- 
2.25.1

