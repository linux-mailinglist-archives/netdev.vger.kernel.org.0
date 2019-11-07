Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288D9F2F45
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389085AbfKGN2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:28:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43392 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbfKGN2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:28:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id y23so2253323ljh.10
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zXDgHEnXmAd5c8hm63wbideMGJDr2j+Jf+RGDuNusS4=;
        b=rBMjZCqHLRK4uxWE3Jn85OBeFCg3CIPM6/SBq/1nYky4z9Z8LfxMCO78o3o6il5kqj
         Hl+e7g08u6R8M2JBZt3wvjlwBW5rbrdROXabAdePH/8fgNHmOp34ydg0fsr1rIz437g2
         72/gOjwiBCmsnSgxYS7h4qhz8grxYzGuiMlEPMv6I6GS4wIsD87XRkqJZcT3aTGdXKCK
         Umu+mYlwuM6faJ01pr59Iz5lggc+vpcb+idodwaBaOaiocXbqmvNC8+Vw8oGwsL/TpIm
         2ezfyhwVN3C1vTt4a3DBiwdyhkBiuB0m5sZvCo3zJ71OF9x4uw59HFwMx/LYIYkHpxTl
         GuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXDgHEnXmAd5c8hm63wbideMGJDr2j+Jf+RGDuNusS4=;
        b=M+wMnIgxu8yds27veRlRxZg3LC+Le/ZAffHJ5KeXcnNKLUeIqRi+HgUQFqQjl1JOB+
         N6oKHIGRIZyrNRswWd/26+xfsJZKhybnEiitIgqw6Y4eK+9jqrKMnM33reE6fmqDSTF/
         r7U9ertGmDsHLK0hih6FGNFPi0l/Os7h0N+Xt0bbFzG0tuHVqFsM0zho1MXHAPzSqV15
         lP7rdgQ80fGH3bcUMuhriXsgDSYvE/wjkN0xJVBbhe7g+jpfg2AHLj2JAbP2Jm7x10wA
         3+zy53ZKGKHrUVJGr2SCu4do2QaJDqxkRWN+t9moBMmmmlhdStJ2+J8/Nhi/mVBGQqOU
         HfEg==
X-Gm-Message-State: APjAAAXxh1/O105UDMTPjQ/gBGeMJ6hd26hFWF/YMbPquliuHw+6y3Ov
        tjheIqwBDw+/1FD1sxssSDwqwb6wnjs=
X-Google-Smtp-Source: APXvYqyBWis+vPxpbD+JmZEOBgKo3ElSBxQQsXXtFqZF7NzkD09vQlT2OduOj2N3/n5Y1L41NCvgvA==
X-Received: by 2002:a2e:9e45:: with SMTP id g5mr2273176ljk.58.1573133284676;
        Thu, 07 Nov 2019 05:28:04 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id y20sm3151507ljd.99.2019.11.07.05.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:28:04 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 5/6] net: namespace: allow setting NSIDs outside current namespace
Date:   Thu,  7 Nov 2019 14:27:54 +0100
Message-Id: <20191107132755.8517-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107132755.8517-1-jonas@norrbonn.se>
References: <20191107132755.8517-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is only possible to move an interface to a new namespace if
the destination namespace has an ID in the interface's current namespace.
If the interface already resides outside of the current namespace, then
we may need to assign the destination namespace an ID in the interface's
namespace in order to effect the move.

This patch allows namespace ID's to be created outside of the current
namespace.  With this, the following is possible:

i)    Our namespace is 'A'.
ii)   The interface resides in namespace 'B'
iii)  We can assign an ID for NS 'A' in NS 'B'
iv)   We can then move the interface into our own namespace.

and

i)   Our namespace is 'A'; namespaces 'B' and 'C' also exist
ii)  We can assign an ID for namespace 'C' in namespace 'B'
iii) We can then create a VETH interface directly in namespace 'B' with
the other end in 'C', all without ever leaving namespace 'A'

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/net_namespace.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 39402840025e..ebb01903d1f7 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -726,6 +726,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *tb[NETNSA_MAX + 1];
 	struct nlattr *nla;
 	struct net *peer;
+	struct net *target = NULL;
 	int nsid, err;
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(struct rtgenmsg), tb,
@@ -754,6 +755,21 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return PTR_ERR(peer);
 	}
 
+	if (tb[NETNSA_TARGET_NSID]) {
+		int id = nla_get_s32(tb[NETNSA_TARGET_NSID]);
+
+		target = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, id);
+		if (IS_ERR(target)) {
+			NL_SET_BAD_ATTR(extack, tb[NETNSA_TARGET_NSID]);
+			NL_SET_ERR_MSG(extack,
+				       "Target netns reference is invalid");
+			err = PTR_ERR(target);
+			goto out;
+		}
+
+		net = target;
+	}
+
 	spin_lock_bh(&net->nsid_lock);
 	if (__peernet2id(net, peer) >= 0) {
 		spin_unlock_bh(&net->nsid_lock);
@@ -775,6 +791,9 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 		NL_SET_BAD_ATTR(extack, tb[NETNSA_NSID]);
 		NL_SET_ERR_MSG(extack, "The specified nsid is already used");
 	}
+
+	if (target)
+		put_net(target);
 out:
 	put_net(peer);
 	return err;
-- 
2.20.1

