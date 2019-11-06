Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F755F0E74
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbfKFFji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:38 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35836 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730987AbfKFFjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id r7so15889088ljg.2
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nheAZEvkv4WhdWdV6TIir5cz0kQhP+59XXc12ABo7pc=;
        b=kIYeAYrjHWg2GFGOpruAxujtdh3wbmCUraF4IyCwX5CD3O+a5H+wkCMLewdc/yD+dG
         B5NL9ZmEAkj46hq0oQs+Sk4d9BWvkqoDm65Bg7J1Rg2asaqQw60iKiD7zRiwk1ECZNJ6
         qBrI3T6rtNj7iwsduxGGDfY/Q38OgQfKubGAdNeGjFxQLQu/nA+GtbgxBB4ANi22Qb2c
         lH9D0F2TAhD1kevPGtibF4qTf2OAgQo14UaMZ0PqeTX66I+tuBlnLl0UqJiHj9Amz0bA
         MPlWCIWcwtwH3uz9zURJxVJapjR0EbBQRPE77Ef/2DfFD8YzTFeKG1nNcJelblYltZD2
         wfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nheAZEvkv4WhdWdV6TIir5cz0kQhP+59XXc12ABo7pc=;
        b=Hbtv6Dz+h6X/c3WIJ5WMZUoLY6835s3VE3D5x8LuciNGqAD8qc2l6Ev1Yv9USwn5AN
         JjymalOKrsK0A+U/Jekv/9YyATVdfmu/yycRxBWJM35yR8OifwIbjYLRkJXDmJ/I1LXM
         PbF/uEuYwwWBwD6iRawZxvFXrrEulUmH9oFEu8ArJ3/15PRunDgSrgAW6VD9kUl8ldGT
         uhDTgxNbj/LuhF3AlwWgL+bKoO2qawElTJ6gnMcUYI39siClm23/jfPmJzGqUeC7qTLE
         cVgdlvsUpX9nj3SfjtcFKBiNnd17ijgOTwY699pUwg68ENi+QmoOBxKGBJgIlc8S58bm
         ZpEQ==
X-Gm-Message-State: APjAAAWx99qDIyJW0maBQxXhVBOpeJazFOdh2joa4wkPNgqUOcQBKtjF
        g9dRrCVzL7fyi6ZzGAryeHfbFA==
X-Google-Smtp-Source: APXvYqwH8nu8dAepTAIesKpvaxxiBkagLjJ0C6Ab793jliy5lUDersmIqUqtZOtwmPNecAeXH/iGbw==
X-Received: by 2002:a2e:970e:: with SMTP id r14mr399846lji.57.1573018774960;
        Tue, 05 Nov 2019 21:39:34 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:34 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 5/5] net: namespace: allow setting NSIDs outside current namespace
Date:   Wed,  6 Nov 2019 06:39:23 +0100
Message-Id: <20191106053923.10414-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
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
index 6d3e4821b02d..0071f395098d 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -724,6 +724,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *tb[NETNSA_MAX + 1];
 	struct nlattr *nla;
 	struct net *peer;
+	struct net *target = NULL;
 	int nsid, err;
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(struct rtgenmsg), tb,
@@ -752,6 +753,21 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -773,6 +789,9 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
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

