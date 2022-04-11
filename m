Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF34FC375
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348903AbiDKRdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348963AbiDKRcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:19 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836232F000
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id t11so5353825eju.13
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gXs4PLlNleG26f62x9RTRqzIlUWK/kMjrVCPwUa1nnA=;
        b=h/abJgZ7Xi7Z8GrRRVLZ9oJrGOddEMunkLHKWxtlp+fwN2PldD4vnxb64qRFtcMtnG
         7ud6gDPS5htQEfOasOEaqV0IoLDMIXOci2yXz8OFVmtmDnfKNvwzGMnJulOiXwzC836r
         KIa2tpBzt5Vczm85ycT/Vqm3OEmiP4b+rNwaETRlpMR4qjgNEz8Sha3JQStB77hSerJW
         sA2GNp+VhAACxEbyKUdL/tByb2bkkeV+8AwxBPtrWvCnpMJn6JZ892xznxuHHPsrNm+J
         ocw0SDU6unmkqZ+1XBsrzaDoKF4nTfV4XZ1gi5yN5aTo07U4LsirxK/7ELhNecAscgbf
         SM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXs4PLlNleG26f62x9RTRqzIlUWK/kMjrVCPwUa1nnA=;
        b=fsCIRm8VsA3AHlpcu/hVZvbwmERIyy/J8ymRq20rG0QQ9+4Cj26SD/qpFy5RN9IuK5
         KaW7dcKXsivPf3MAs8FFnSbdJWNmIhhF1DqaRR0e2oVeBQXfAyGwJ3GP9sKL5XN4QGP0
         8HfNOvV7d+jONrhO1cxSAq5IM75H0oDkF2feCClfHI1GWkIYgbTt2J3Klj+aXRjjXfuR
         lnRWxoKhrTckwgXZY4g3YCb/pBIXGzAgsn4W4NkbahX5ckbcyr0UQnl1qKFjZ9GFj1/3
         ygYFRf8dqT94Gavs2ouYi3S8oewhePGlmhPZZODFFLF2LzbiJBcBfoyIEwT5TLFPp1IH
         7R6Q==
X-Gm-Message-State: AOAM533W3TZE1FCcDEmNt3BA9MhOAjfBNaJsbIKGa9C3qzqbvugpa0Ym
        gOshFVtu0LGQFnkL3S+44UYOeYw5kUUSuXWg
X-Google-Smtp-Source: ABdhPJxZYIAj/HLnAQxh3UKtNigoheZ0fMk5P//AeQTYV1XdQ+ppgUYTl9GsPboO3KbWvuzyXzrRSQ==
X-Received: by 2002:a17:906:d555:b0:6db:148e:5cc with SMTP id cr21-20020a170906d55500b006db148e05ccmr29965894ejc.63.1649698201585;
        Mon, 11 Apr 2022 10:30:01 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:30:01 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 5/8] net: rtnetlink: add common flush attributes
Date:   Mon, 11 Apr 2022 20:29:31 +0300
Message-Id: <20220411172934.1813604-6-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
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

Add common fdb flush attributes - ifindex, vlan id, ndm flags/state masks.
All of these are used by the bridge and vxlan drivers. Also minimal attr
policy validation is added, it is up to ndo_fdb_flush implementers to
further validate them.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/neighbour.h |  4 ++++
 net/core/rtnetlink.c           | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 60e728319a50..5ab4e9b5edc8 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -214,6 +214,10 @@ enum {
 
 enum {
 	NDFA_UNSPEC,
+	NDFA_IFINDEX,
+	NDFA_VLAN,
+	NDFA_NDM_STATE_MASK,
+	NDFA_NDM_FLAGS_MASK,
 	__NDFA_MAX
 };
 #define NDFA_MAX (__NDFA_MAX - 1)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7325b60d1aa2..379b6a066fbd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4660,7 +4660,11 @@ static int rtnl_fdb_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 }
 
 static const struct nla_policy fdb_flush_policy[NDFA_MAX + 1] = {
-	[NDFA_UNSPEC] = { .type = NLA_REJECT },
+	[NDFA_UNSPEC]	= { .type = NLA_REJECT },
+	[NDFA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[NDFA_VLAN]	= { .type = NLA_U16 },
+	[NDFA_NDM_STATE_MASK]	= { .type = NLA_U16 },
+	[NDFA_NDM_FLAGS_MASK]	= { .type = NLA_U8 },
 };
 
 static int rtnl_fdb_flush(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -4670,6 +4674,7 @@ static int rtnl_fdb_flush(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *tb[NDFA_MAX + 1];
 	struct net_device *dev;
 	struct ndmsg *ndm;
+	u16 vid;
 	int err;
 
 	err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDFA_MAX, fdb_flush_policy,
@@ -4689,19 +4694,24 @@ static int rtnl_fdb_flush(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -ENODEV;
 	}
 
+	err = fdb_vid_parse(tb[NDFA_VLAN], &vid, extack);
+	if (err)
+		return err;
+
 	err = -EOPNOTSUPP;
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
 	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
 
-		err = br_dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, 0, extack);
+		err = br_dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, vid,
+							extack);
 		if (err)
 			goto out;
 		else
 			ndm->ndm_flags &= ~NTF_MASTER;
 	}
 	if ((ndm->ndm_flags & NTF_SELF) && dev->netdev_ops->ndo_fdb_flush) {
-		err = dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, 0, extack);
+		err = dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, vid, extack);
 		if (!err)
 			ndm->ndm_flags &= ~NTF_SELF;
 	}
-- 
2.35.1

