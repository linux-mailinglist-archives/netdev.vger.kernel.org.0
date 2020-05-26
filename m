Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436931E27FB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgEZRKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:35 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgEZRKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShIfuDqxrk6HvoWQdcEZcvU48CX3BX09hpdoEveL7fbzZn1UdcYsUFT08kkb2mBiaKNpX09mfHCVb3u5WrySwSoMj/MzETS0djMFiH4fZYdb/z9YObgUqfSBcwFvCNfbQnfivg+DbAdm+dSgn6DwOdwdJJiJXUuFBcY5WVgZAeZBEM1wYJWPvQhMWpmm4tEgorrV3RC2d0vEkmNn5YHnxENKhqfq8FslaohUritfjjuSo+xNCVUjcVneeXFYjPTBY0k7n7rFKFq1KVMTdb13Gs9rJsNa7Jm82NYP1rAf023XlgNmJJwTg5mhtnqSS0dNvO6wzvkkC2Z/YxrrTbMQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZWsW8C677/NAzvYzPSKjNgKdTxylSX2XIpPsuzZ6ZA=;
 b=X33rEocjb1/GwqR/oa/5eQPImIPZ/PYRC9PgtczA2wDNrsIYUw3QFptBkxPqa+/LiwHAlLx1o9VNkJaaT8lQAJ4XpPPWLxC6ewKE7VHJ8h7u3shstEseQum91QtJS8QJui2QBQZSx+YVpPju3NiQk8r7XpYjjEFYKVunmCmaWDcJEKpI6B4YNc7k5GMqHnIkXwepZIlJIQFImhUycTLN/4eK8BMyUVC9bhROF0KVg+SpPi2osoi4a+ngN0vtGxX8e4VnJvAfilziZwKn5n2xDApWBsBKS0TVhNylCvze6akbVeIF4rXpKZahBCzOn2v1XmzS03LIQYyvIXa58G89OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZWsW8C677/NAzvYzPSKjNgKdTxylSX2XIpPsuzZ6ZA=;
 b=a4fmQkowOuaFD+shX1lji3a1ZQyhJ8RuNqp2izcSjCsSk8z31QRTn8tuL9UkJF+7eaofSMPA91BJp46N3ejEbPA+bhUMENZq5jW6ssWHs5hle9Hp4KgARtZt4IOSMZEd0yut40pO2XqqMSMj5GnNtNNTLjKAIWQ0UrAyfAobEG0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:30 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:30 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH net-next 0/3] TC: Introduce qevents
Date:   Tue, 26 May 2020 20:10:04 +0300
Message-Id: <cover.1590512901.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:28 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f65e7068-6d95-43cf-02e0-08d80197b117
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB32259D9CDBE91851C9EF604FDBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbKgWcvYdsqBsWMJROkFI5ZM9tUuCpGrI0mDYCVf0WvQCldxsm9GWuxUOLLSX6kEqq7de3rgY75Kp/wY2/MU/6F9RV+Wk5ruufZvXzNL3JejipBjvPJM+kn49LNJbU/4EYSyb2aQEmJCQ3m9PWOBgc9WKq41xC9Awi0bvU5Yanjx+BkcYlei7pFPO7Gyc4V7nnzNoJ/w//lP9TyrJboPAt2AjATHhPWId/dKK1NqUugD6cTXHWvs8ji5OT11kJaWEUkJFJ1JtDP8rZJrFr99BL7IKHTBEoElWYhlY7Fhd1Ut/Um9G/d3p1zpHQn3PCQ/zQamjv3b71CxivrrjBu5mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ndRSAs4kmYExY0j4C+5rhoTrziISkhwdU+eVqAzOf6SfkVBiK/uRG6XbMokBjewKiGgnv8+HN9kHtf/aLxhiVBpXWcqvLV2ALK/E5nLHspg9bG7qNkQFqbL+8rDLxOOp+E0b4oGxq6FWMoL49bgCZ7lp44AAALGADZx69DKruKEtgC114awNVQAnJTDNGR5efA3ukiOI8gIvdmszlZPIWnq98897z9qYMK2Kema7eTgCheHp/yT6TFQNJ97xOP5BXoB6DocpM35kUBq7hmpD5Cf1+dBr5qJynG+aMdy9kS6Ln/+KiSnozYJ1ZSkZ8Mz7xhOgy4qGFYK5aIWBAhCYI7fIIXAD7FxJ+ExL2QbfEckEGx8cBXGvsddWyl8FL1xdbugekHf51k4aUMwW1vYRwH3V2kKdrYJGRt84lJr+4YDhhoHCLvmcCwF+AWoamLguc2gYsrgZRJZ8sDH0arT9u5UYVms/z/coIVDZJHM3HgQcDqjRBrcK2Z8SuCG1RBB+
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65e7068-6d95-43cf-02e0-08d80197b117
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:29.9018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1PVZn2NjoHPeKJ5thcDeYhB5qpLHw68lNpm/Ds+1J9LAWOxnvSU5fOzT2ZAnqQ5CJS/ftzurYeYYYhljglvRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Spectrum hardware allows execution of one of several actions as a
result of queue management events: tail-dropping, early-dropping, marking a
packet, or passing a configured latency threshold or buffer size. Such
packets can be mirrored, trapped, or sampled.

Modeling the action to be taken as simply a TC action is very attractive,
but it is not obvious where to put these actions. At least with ECN marking
one could imagine a tree of qdiscs and classifiers that effectively
accomplishes this task, albeit in an impractically complex manner. But
there is just no way to match on dropped-ness of a packet, let alone
dropped-ness due to a particular reason.

To allow configuring user-defined actions as a result of inner workings of
a qdisc, this patch set introduces a concept of qevents. Those are attach
points for TC blocks, where filters can be put that are executed as the
packet hits well-defined points in the qdisc algorithms. The attached
blocks can be shared, in a manner similar to clsact ingress and egress
blocks, arbitrary classifiers with arbitrary actions can be put on them,
etc.

For example:

# tc qdisc add dev eth0 root handle 1: \
	red limit 500K avpkt 1K qevent early block 10
# tc filter add block 10 \
	matchall action mirred egress mirror dev eth1

Patch #1 of this set introduces several helpers to allow easy and uniform
addition of qevents to qdiscs. The following two patches, #2 and #3, then
add two qevents to the RED qdisc: "early" qevent fires when a packet is
early-dropped; "mark" qevent, when it is ECN-marked.

This patch set does not deal with offloading. The idea there is that a
driver will be able to figure out that a given block is used in qevent
context by looking at binder type. A future patch-set will add a qdisc
pointer to struct flow_block_offload, which a driver will be able to
consult to glean the TC or other relevant attributes.

Petr Machata (3):
  net: sched: Introduce helpers for qevent blocks
  net: sched: sch_red: Split init and change callbacks
  net: sched: sch_red: Add qevents "early" and "mark"

 include/net/flow_offload.h     |   2 +
 include/net/pkt_cls.h          |  48 +++++++++++++++
 include/uapi/linux/pkt_sched.h |   2 +
 net/sched/cls_api.c            | 107 +++++++++++++++++++++++++++++++++
 net/sched/sch_red.c            | 100 ++++++++++++++++++++++++++----
 5 files changed, 247 insertions(+), 12 deletions(-)

-- 
2.20.1

