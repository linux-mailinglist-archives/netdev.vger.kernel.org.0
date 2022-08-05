Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B885158B04F
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbiHETYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHETYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:24:02 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457366132;
        Fri,  5 Aug 2022 12:24:00 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275Iw8pF020710;
        Fri, 5 Aug 2022 21:20:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=azXcdsLu4260lFD/yn5j/LkPyKGtpHhYWRtPGk/Sl68=;
 b=XHhpZyddNNuQrs27za74WwQGmy52oTf/pq0+JkAkSYjmZ6wRqRHAMXTw4O8dHNh9Wg9i
 Lubrqb1D8ZW0OeH/h3Gt2e9l9pQfrOACmhx3t3zuC352b8VBsDFB5I//CUQ5VSSoPDG8
 wbpFHmkNgx6ww7fa1dqcYQuyOgMmwbWboahgM++pPW2gjZQYv6QGBDi/RoZWqgL1j38/
 0MOYiZ2B5Or7hNyjNuYbKz4ZCap10v8pI31M6j+QgrJ9ZNoXq+AS8GA6G0Wvs2vGpjQT
 fKBSYwq/RmrxHneZ2CKJdI4D2BBzlZwP3I0pqnY3xxFQ1UZ7kQZEHu6+DX6kiDzJay03 Pw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hr3tdsntg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 21:20:08 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Fri, 5 Aug 2022 21:20:05 +0200
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
Subject: [PATCH v3 net 0/4] Do not use RT_TOS for IPv6 flowlabel
Date:   Fri, 5 Aug 2022 21:19:02 +0200
Message-ID: <20220805191906.9323-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: P-FzDb9V4CZpy967eeQjyxN_EOsIRN6q
X-Proofpoint-ORIG-GUID: P-FzDb9V4CZpy967eeQjyxN_EOsIRN6q
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

---
v1 -> v2:
 - Fix spacing of "Fixes" tag.
 - Add missing CCs
v2 -> v3:
 - Add the info from the cover to the actual patch message (Guillaume Nault)

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

