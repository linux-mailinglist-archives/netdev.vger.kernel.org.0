Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF33587B62
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiHBLON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiHBLOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:14:11 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7F618362;
        Tue,  2 Aug 2022 04:14:09 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272AqotU029528;
        Tue, 2 Aug 2022 13:13:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=KtBdZ4PHF0Bh/BhAkFzl+uA+TAc7eBGlkWIvzvsFIXM=;
 b=uquVkeHuJuzI3JDrdhnNhf6FrCkZ2lSvEDVMSiG9o/Nso3cTtjgG2VKKHVVyRR1eilXw
 zx/3rGQS51oSGrYjxkbEDfqoXRkM7lOOc8Py5SKLGyT6JnpkIsBKmE2xL2nPQcICveX4
 Aajk2ELw+2lNmrh8Lyux01jd0APVJEGEFYRlasbw00PBVrYoNH0RD8uKv/T35BFX3kd/
 7CbgjuFRgDJt/AbRO3c+pwvSaj92UPw/q/5IepC9CD49GlTx+0a7P7zL69GWGoEH5k6g
 o06fhPGATJtnyVLKT0wlkN3rqrjCp5SpHGPkF00+2PrlkQbeXvwMXD/bName1INXhT7M zw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hmrn42u0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 13:13:34 +0200
Received: from Orpheus.westermo.com (172.29.101.13) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 2 Aug 2022 13:13:31 +0200
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
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH net 0/4] Do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 2 Aug 2022 13:13:04 +0200
Message-ID: <20220802111308.1359887-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.101.13]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: CV9hysvU_QhaSQVLt3PZsZaxVZBClzpH
X-Proofpoint-ORIG-GUID: CV9hysvU_QhaSQVLt3PZsZaxVZBClzpH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Matthias May (4):
  geneve: do not use RT_TOS for IPv6 flowlabel
  vxlan: do not use RT_TOS for IPv6 flowlabel
  mlx5: do not use RT_TOS for IPv6 flowlabel
  ipv6: do not use RT_TOS for IPv6 flowlabel

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 4 ++--
 drivers/net/geneve.c                                | 3 +--
 drivers/net/vxlan/vxlan_core.c                      | 2 +-
 net/ipv6/ip6_output.c                               | 3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.35.1

