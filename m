Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB74FE275
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356032AbiDLN3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356731AbiDLN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:06 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2E2AE34
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r13so37348580ejd.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETWbF7zKsZG9skDxgFBuQOsMiuFT3MmfMSLOxhDh3mw=;
        b=Q7Dpt9DQjInhOCoN2TX1SM9fAaM/ZcyKh2wLi9yqBD8CWhScrhMlf8KjQdw9i35ktl
         ALa9AsW7WDZd44cDkQNSIsMMnFkqftQt+Z4p5hQlKbA7xPufx1OQCid2gCrTGp+in0LX
         CrhSwFsMKQnfPDBO33PnPHpDw6mcG1G5Bg/8kX9L0tYEPJ/tE3avhZkN2SjqblBIFBlG
         zz1GdiAF+HZG7BuryzyhQfgFp4eikC6THMi9IkFweQZ9qbJoMT55KJalDQ7kbEpapC6k
         /XAG7JYI7mGHXI6ode8zK9IzGRuWAr1tT5K2m8SSNSgcAqhSUkZ7hk3Jjc6QEnGi+56E
         GKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETWbF7zKsZG9skDxgFBuQOsMiuFT3MmfMSLOxhDh3mw=;
        b=VuiaECxki4v+WZxsodRCQRd1JJU+Xnxgmwxyjy/vnXCPErCTOyfCssUm+9R7vcxyB+
         XeAFGcmmN8ZlQFXLtvA9lzgm/rGF5I5Z3KuLZdWPmQHrrkaN9uPmMT362xRFyWYRsvvE
         ckDHSZ5Jt7wTcAWZdggoX49BaAisBJu21UNkx6Wnhx6jNp0r6nHAzIdCIzoF25/ZPli0
         /lMcjdKmeVP0SPrEHaeiZXhT6TGRhxkIi3YVpv23QqEH3VnFbOQmg+ToCF0iGD5YDrKv
         gPPUYTgqgBBH/IbZEE9WyYLpYkX6jCVYgLNsmOz4P41/ikaYvadufE5rHY3dPlOuhyfe
         Uy8Q==
X-Gm-Message-State: AOAM530QGWsvhOWIQKnmmkR8V0zMPtFl/6XTMFwnU2mlW2wcGb66DLl9
        bjGrQ1paLen5wX3lDvlDQh1FzBnAKdQHR67Z
X-Google-Smtp-Source: ABdhPJw5byT8y5MZ5mbH7NPOSQMVFjKhfITSKVTsXhxpS47HhEtSaibWOHFbYL/p/jAv0JWEliD4Xw==
X-Received: by 2002:a17:907:3f8b:b0:6e8:318d:1def with SMTP id hr11-20020a1709073f8b00b006e8318d1defmr26133568ejc.153.1649769791697;
        Tue, 12 Apr 2022 06:23:11 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:11 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 3/8] net: rtnetlink: add NLM_F_BULK support to rtnl_fdb_del
Date:   Tue, 12 Apr 2022 16:22:40 +0300
Message-Id: <20220412132245.2148794-4-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NLM_F_BULK is specified in a fdb del message we need to handle it
differently. First since this is a new call we can strictly validate the
passed attributes, at first only ifindex and vlan are allowed as these
will be the initially supported filter attributes, any other attribute
is rejected. The mac address is no longer mandatory, but we use it
to error out in older kernels because it cannot be specified with bulk
request (the attribute is not allowed) and then we have to dispatch
the call to ndo_fdb_del_bulk if the device supports it. The del bulk
callback can do further validation of the attributes if necessary.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/core/rtnetlink.c | 64 +++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4041b3e2e8ec..824963aa57b1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4167,22 +4167,34 @@ int ndo_dflt_fdb_del(struct ndmsg *ndm,
 }
 EXPORT_SYMBOL(ndo_dflt_fdb_del);
 
+static const struct nla_policy fdb_del_bulk_policy[NDA_MAX + 1] = {
+	[NDA_VLAN]	= { .type = NLA_U16 },
+	[NDA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+};
+
 static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
+	bool del_bulk = !!(nlh->nlmsg_flags & NLM_F_BULK);
 	struct net *net = sock_net(skb->sk);
+	const struct net_device_ops *ops;
 	struct ndmsg *ndm;
 	struct nlattr *tb[NDA_MAX+1];
 	struct net_device *dev;
-	__u8 *addr;
+	__u8 *addr = NULL;
 	int err;
 	u16 vid;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX, NULL,
-				     extack);
+	if (!del_bulk) {
+		err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX,
+					     NULL, extack);
+	} else {
+		err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX,
+				  fdb_del_bulk_policy, extack);
+	}
 	if (err < 0)
 		return err;
 
@@ -4198,9 +4210,12 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -ENODEV;
 	}
 
-	if (!tb[NDA_LLADDR] || nla_len(tb[NDA_LLADDR]) != ETH_ALEN) {
-		NL_SET_ERR_MSG(extack, "invalid address");
-		return -EINVAL;
+	if (!del_bulk) {
+		if (!tb[NDA_LLADDR] || nla_len(tb[NDA_LLADDR]) != ETH_ALEN) {
+			NL_SET_ERR_MSG(extack, "invalid address");
+			return -EINVAL;
+		}
+		addr = nla_data(tb[NDA_LLADDR]);
 	}
 
 	if (dev->type != ARPHRD_ETHER) {
@@ -4208,8 +4223,6 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	addr = nla_data(tb[NDA_LLADDR]);
-
 	err = fdb_vid_parse(tb[NDA_VLAN], &vid, extack);
 	if (err)
 		return err;
@@ -4220,10 +4233,16 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
 	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
-		const struct net_device_ops *ops = br_dev->netdev_ops;
 
-		if (ops->ndo_fdb_del)
-			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+		ops = br_dev->netdev_ops;
+		if (!del_bulk) {
+			if (ops->ndo_fdb_del)
+				err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+		} else {
+			if (ops->ndo_fdb_del_bulk)
+				err = ops->ndo_fdb_del_bulk(ndm, tb, dev, vid,
+							    extack);
+		}
 
 		if (err)
 			goto out;
@@ -4233,15 +4252,24 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Embedded bridge, macvlan, and any other device support */
 	if (ndm->ndm_flags & NTF_SELF) {
-		if (dev->netdev_ops->ndo_fdb_del)
-			err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
-							   vid);
-		else
-			err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
+		ops = dev->netdev_ops;
+		if (!del_bulk) {
+			if (ops->ndo_fdb_del)
+				err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+			else
+				err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
+		} else {
+			/* in case err was cleared by NTF_MASTER call */
+			err = -EOPNOTSUPP;
+			if (ops->ndo_fdb_del_bulk)
+				err = ops->ndo_fdb_del_bulk(ndm, tb, dev, vid,
+							    extack);
+		}
 
 		if (!err) {
-			rtnl_fdb_notify(dev, addr, vid, RTM_DELNEIGH,
-					ndm->ndm_state);
+			if (!del_bulk)
+				rtnl_fdb_notify(dev, addr, vid, RTM_DELNEIGH,
+						ndm->ndm_state);
 			ndm->ndm_flags &= ~NTF_SELF;
 		}
 	}
-- 
2.35.1

