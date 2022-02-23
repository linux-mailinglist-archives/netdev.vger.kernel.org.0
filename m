Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07204C19DF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbiBWRYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiBWRYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:24:54 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D77250060
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:24:26 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id d23so32328573lfv.13
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=E6q9nT33+JhEWdWqbn7Jtyhs2XGadu1h5pizK24uBCg=;
        b=j5+HslsbTa454hYKu1B8fWo/elCJyO+/urMRd9Ycje9CO37gBlYKKIbGoeGrQC321d
         dXWtHIE9WmtZ2gO+RuqwkYkNxgbQcQsMcfoS0I0z5Gu6Vf4CM/DbuFBrYn6YLjGnNNUZ
         KLufBbIo8OqX0osCUm5Vck6LQA+k+1WkNdQNb5t5bfDEfwofwPKiEFr5YirC3UPXCwAA
         MIoEtvK53oN8ogfoUD4p41pGhaSj3IlonirRBsC4cFUIup0YgVhhBnvw5wmNHRFMdtMG
         zdadSG8QocJveFJ4+ErzHBtYK2lWDipyoeXban2wHE/FJT8P2DGz7qHoikig94oF7trM
         KVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=E6q9nT33+JhEWdWqbn7Jtyhs2XGadu1h5pizK24uBCg=;
        b=qPIuhFcv70aFj2Ho3+pw4WogVlpw82/RajwlmQSl8QUO3v64II0WLaDwCZKplKaqDw
         PcYDgj89ljzCBcJU0e8VjquQYKdE0DdZc+DDeXqWBizhWd0sYgSUshRvKZLleEDKHuzq
         U8yUOnUTIJ/7Nl10EpcrlOzbsoQlTWDbAujygTiWUHpGyg/01Jib5Px7UjOANbUfajKm
         Zi5SAJ/DBRKZBBqIN3kTM3HqPlblWiVD7nurhHIU+i5Yx9Y1FBgCd2dGMa/RlBZMtfbm
         1krHkDIr/pn7cqLJGolCfibHLAm4eBxN1SY2AQMJLn4bBm8Pbt2Gohd0Se/dq+I1pSO5
         CB0A==
X-Gm-Message-State: AOAM530g18AYhyDm1aB7u6xNQ5H51iETUrHDm4l1wcBpspqlRMUe5E6H
        3FxaCYUCeb1dVum60H4Pzis=
X-Google-Smtp-Source: ABdhPJxwP/4eWrjw2G/tNiH+afZ+y/mKhi63FVaX1czMKzS71RYTJ3zBdTTQTfbdn3pl2ZU5Sr9p6A==
X-Received: by 2002:a05:6512:331b:b0:443:7db2:6af8 with SMTP id k27-20020a056512331b00b004437db26af8mr466231lfe.240.1645637064331;
        Wed, 23 Feb 2022 09:24:24 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id u6sm7981lfg.291.2022.02.23.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:24:23 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb entries
Date:   Wed, 23 Feb 2022 18:24:07 +0100
Message-Id: <20220223172407.175865-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch expands on the earlier work on layer-2 mdb entries by adding
support for host entries.  Due to the fact that host joined entries do
not have any flag field, we infer the permanent flag when reporting the
entries to userspace, which otherwise would be listed as 'temp'.

Before patch:

    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
    Error: bridge: Flags are not allowed for host groups.
    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee
    Error: bridge: Only permanent L2 entries allowed.

After patch:

    ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
    ~# bridge mdb show
    dev br0 port br0 grp 01:00:00:c0:ff:ee permanent vid 1

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 net/bridge/br_mdb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 4556d913955b..9ba5c5cc2f3d 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -257,8 +257,10 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	else if (mp->addr.proto == htons(ETH_P_IPV6))
 		e.addr.u.ip6 = mp->addr.dst.ip6;
 #endif
-	else
+	else {
 		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
+		e.state = MDB_PG_FLAGS_PERMANENT;
+	}
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
@@ -873,8 +875,8 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		return -EINVAL;
 
 	/* host join errors which can happen before creating the group */
-	if (!port) {
-		/* don't allow any flags for host-joined groups */
+	if (!port && !br_group_is_l2(&group)) {
+		/* don't allow any flags for host-joined IP groups */
 		if (entry->state) {
 			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
 			return -EINVAL;
-- 
2.25.1

