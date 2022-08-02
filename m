Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360AF587C08
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiHBMMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiHBMMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:12:55 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C740F4D80D;
        Tue,  2 Aug 2022 05:12:53 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2726lw05021700;
        Tue, 2 Aug 2022 14:09:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=wxvH2rGlHe9grf+ppG57EJkuecYG69EpgZCujpsNrM0=;
 b=K2aIatVLYn5pRal+0eqIRBU98VNLirjjAJMTKMdiI+idwtymOkcrVSMg2Z/WS6iggqr5
 O6f+vcS0aoRJlUw0UYTIEAJaq16e1aYb/T271QyomFp7usQdyJa8eb1QMrwXC/6NvOVw
 CGrr+Q0OyYtZxjp/z8cSjUYAkdY6md7CQFG3t4RPzvJj+N61RqzPpyaJneyNiaVJ9nCb
 kdJaqd5i+5LxDvc7lwwfHE3gbHWAF7YmYIo0EZAYTyWo0YWPPLjFyyrkTDLH9PVotJZq
 Ucin18UAJZnWN7i/dxUSH1Fi48N8Xz8+0xzdR8UrCBZ6nwlA9Nb6jqX1gzUhOP5xExpm 6A== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hms0c2wbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 14:09:58 +0200
Received: from Orpheus.westermo.com (172.29.101.13) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 2 Aug 2022 14:09:56 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <roid@nvidia.com>,
        <maord@nvidia.com>, <lariel@nvidia.com>, <vladbu@nvidia.com>,
        <cmi@nvidia.com>, <gnault@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <nicolas.dichtel@6wind.com>, <eyal.birger@gmail.com>,
        <jesse@nicira.com>, <linville@tuxdriver.com>,
        <daniel@iogearbox.net>, <hadarh@mellanox.com>,
        <ogerlitz@mellanox.com>, <willemb@google.com>,
        <martin.varghese@nokia.com>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH v2 net 2/4] vxlan: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 2 Aug 2022 14:09:33 +0200
Message-ID: <20220802120935.1363001-3-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220802120935.1363001-1-matthias.may@westermo.com>
References: <20220802120935.1363001-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.101.13]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: sZJ9aE2wcF4H939_dPzX9i35OYBxkBVJ
X-Proofpoint-ORIG-GUID: sZJ9aE2wcF4H939_dPzX9i35OYBxkBVJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
Signed-off-by: Matthias May <matthias.may@westermo.com>
---
v1 -> v2:
 - Fix spacing of "Fixes" tag.
 - Add missing CCs
---
 drivers/net/vxlan/vxlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 265d4a0245e7..797585fbb004 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2320,7 +2320,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.flowi6_oif = oif;
 	fl6.daddr = *daddr;
 	fl6.saddr = *saddr;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tos), label);
+	fl6.flowlabel = ip6_make_flowinfo(tos, label);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.fl6_dport = dport;
-- 
2.35.1

