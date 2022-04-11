Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A814E4FC371
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348968AbiDKRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348939AbiDKRcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B10F2ED6E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so32370517ejb.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNyNzOzmDc1f/pBDx4/a2ruUbQq4AUD3l7VG1GzL5dE=;
        b=DjoyoEa5SBJt3hqwkb9DF+bYBRu/wLQsubSS2953Gkp4QRuJGRUbRTJIqT/76L2o7q
         LIj4IsVyTbEKPYKxQFo8gbjxVn1aZM0XAAjabs6CRiIzZRRpAtPjjGZaF8BnWZXgg1lg
         rsqmH5r6esv/3MlJcXaXb7el2YwVANoDkyI+WX7IIMsSql+S4JzT+epU3z37FDU3srFA
         2m7RMEQP3CNrBDdkZsfFpaQdVZlTyG/6mUAAVrAJYQLN0/tpRokYODZmAPtrQLQ1DaBv
         KcESQyYDfFe2FFqSdCCCmLuRDNb+Ubn/dN13hAV3ar10OHYm9EK7bGvFHbfglNgQOKxx
         LUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNyNzOzmDc1f/pBDx4/a2ruUbQq4AUD3l7VG1GzL5dE=;
        b=oNIvk4McevjpjoXKDTALpt1j0KWOd9hnUiT7vHg1OjiJx5aB4Sao2n9GF6bimuzLWJ
         AmayUnIr2eHmNnshkUhbIqInh6QfWavciGGbeDVeLM7nGbc3qG39jT7PaIl8CV1z1PDo
         SxXrHwW21DxeDXOuL+RUyd4kFKWLApLHPODvG26Qs1iE0jkjUaZL9VKJsQztLI6YuxPI
         2QUVNxYVjkgILr1lQXCvYC5Rm+mcmKnI2KoZryPMqCd1dOrrCNGzsOdREvGCYVNGJrbX
         tcY7Yc9zCQUVjU8GqR5kCI3TGly9nyiVAuFUJRKPp3Kb/gDTbG3D5nkamea7Ny5d9+3+
         hILg==
X-Gm-Message-State: AOAM533se674+DkfJ7VE2WAGG6EZLJxIBLuMB1QIVHQr+ul9MfKWreOI
        OYRW3ejUlYTfUWK0S1ySq4HGo895QxKDQojh
X-Google-Smtp-Source: ABdhPJzNbJycALTMkxA7fQ3oUTeI057Xp772m0xbK5FuefZeOSgbvUJ61y2QofojBMhi0UkKgHepjg==
X-Received: by 2002:a17:906:7314:b0:6df:839f:af7 with SMTP id di20-20020a170906731400b006df839f0af7mr30909242ejc.65.1649698200609;
        Mon, 11 Apr 2022 10:30:00 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:30:00 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 4/8] net: rtnetlink: register a generic rtnl_fdb_flush call
Date:   Mon, 11 Apr 2022 20:29:30 +0300
Message-Id: <20220411172934.1813604-5-razor@blackwall.org>
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

Register a generic PF_BRIDGE rtnl_fdb_flush call which does basic
validation and dispatches the call to the appropriate device based on
ndm flags (NTF_MASTER and NTF_SELF). The flags are interepreted in a
similar way to the already existing fdb add and del.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/neighbour.h |  6 ++++
 net/core/rtnetlink.c           | 52 ++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..60e728319a50 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -212,4 +212,10 @@ enum {
 };
 #define NFEA_MAX (__NFEA_MAX - 1)
 
+enum {
+	NDFA_UNSPEC,
+	__NDFA_MAX
+};
+#define NDFA_MAX (__NDFA_MAX - 1)
+
 #endif
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4041b3e2e8ec..7325b60d1aa2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4659,6 +4659,56 @@ static int rtnl_fdb_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static const struct nla_policy fdb_flush_policy[NDFA_MAX + 1] = {
+	[NDFA_UNSPEC] = { .type = NLA_REJECT },
+};
+
+static int rtnl_fdb_flush(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[NDFA_MAX + 1];
+	struct net_device *dev;
+	struct ndmsg *ndm;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDFA_MAX, fdb_flush_policy,
+			  extack);
+	if (err < 0)
+		return err;
+
+	ndm = nlmsg_data(nlh);
+	if (ndm->ndm_ifindex == 0) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, ndm->ndm_ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "Unknown ifindex");
+		return -ENODEV;
+	}
+
+	err = -EOPNOTSUPP;
+	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
+	    netif_is_bridge_port(dev)) {
+		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
+
+		err = br_dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, 0, extack);
+		if (err)
+			goto out;
+		else
+			ndm->ndm_flags &= ~NTF_MASTER;
+	}
+	if ((ndm->ndm_flags & NTF_SELF) && dev->netdev_ops->ndo_fdb_flush) {
+		err = dev->netdev_ops->ndo_fdb_flush(ndm, tb, dev, 0, extack);
+		if (!err)
+			ndm->ndm_flags &= ~NTF_SELF;
+	}
+out:
+	return err;
+}
+
 static int brport_nla_put_flag(struct sk_buff *skb, u32 flags, u32 mask,
 			       unsigned int attrnum, unsigned int flag)
 {
@@ -6144,6 +6194,8 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_BRIDGE, RTM_DELLINK, rtnl_bridge_dellink, NULL, 0);
 	rtnl_register(PF_BRIDGE, RTM_SETLINK, rtnl_bridge_setlink, NULL, 0);
 
+	rtnl_register(PF_BRIDGE, RTM_FLUSHNEIGH, rtnl_fdb_flush, NULL, 0);
+
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
 	rtnl_register(PF_UNSPEC, RTM_SETSTATS, rtnl_stats_set, NULL, 0);
-- 
2.35.1

