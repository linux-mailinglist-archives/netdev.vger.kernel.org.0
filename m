Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED37EF6F4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbfKEILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:11:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37136 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388261AbfKEILe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:11:34 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so14380649lfp.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O8fWg+Ma5bc8RsOBhTOll0AqdVjJK6jvagus6dMpmcQ=;
        b=Zcf4/SyWe5TJNkVp+0Og7VVNUrzIJk62VtAw908Cq926vhBECbqpi87sK3UifO9toC
         VyvSu7cfKgtaSDEGhdF+Q/G7vi+qbj+G53TTnhRGxdrRmmjOsFvJf94JM//cgMrEivhn
         wyrdIC+bVhEGxoPogeHAngMH3EG+TZjkAiwQAw+tmblPDlMeRpQ+G3fskeG9SuNRN/B+
         0dD2gy2AcvjxViWGaRHzIxhfvs/8lyymdw3t1yVn3HWjAKO4f5XO8sf+SgAJl1SQBKqj
         +Bk6zcBR8pOyZ6pVDd+vm5v+hoHHue1uH2U9RslWBvdyu25XFAHrlM9mju58d2CG/HAM
         cTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O8fWg+Ma5bc8RsOBhTOll0AqdVjJK6jvagus6dMpmcQ=;
        b=n92w9e/3l5kdDUroV3+J5IzfylxM17aoxNgT4BI09ayAN6c2Jm/OXZp3M2aUlTC2Qn
         JbyYHoUHNM4oNNww0xJtCUhdymIRKbcfKI2bPwfBkiKDUY1jS05JNIEXoI/XtMNuYHSU
         hMjbcqhmDJnn2ExSWlgfY3GJzdtmwTTfFhta/8ochGoUz4I/wjQet8+RfQLTqu49vVi5
         rHHTd339QnCmus9IiKXAutN/9f9y4tnpARfacg/UpPoMmMFoJXCmHyUhXDAcoubL1ACE
         hjTLSytyvmW72Vzsuk/aD6dwyKHwYelCd+IxWeA+8DFJAis/YRNIF/gnHb4B4jKCeYbb
         Vy3w==
X-Gm-Message-State: APjAAAUb1ms7eaovdroIVgnuSMxT2ixSA2NkIt4qcAjb7N9oOEsiBbjM
        Pp9ZEBWLC3KuQgt7foK7n995uw==
X-Google-Smtp-Source: APXvYqzgOP+hJ5RdtqNeaOlt2COzFb1ydxd6VC3SKkSgezejBt0KMHpw3WWYey9uj5bbBvxrhRoGrQ==
X-Received: by 2002:a19:614b:: with SMTP id m11mr832939lfk.157.1572941490745;
        Tue, 05 Nov 2019 00:11:30 -0800 (PST)
Received: from mimer.lulea.netrounds.lan ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id m7sm7275986lfp.22.2019.11.05.00.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:11:30 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 5/5] net: namespace: allow setting NSIDs outside current namespace
Date:   Tue,  5 Nov 2019 09:11:12 +0100
Message-Id: <20191105081112.16656-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105081112.16656-1-jonas@norrbonn.se>
References: <20191105081112.16656-1-jonas@norrbonn.se>
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

