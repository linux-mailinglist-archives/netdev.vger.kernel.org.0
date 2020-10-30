Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33529FAB5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJ3Btc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:32 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgJ3Btc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWV/XVMT+9cz8MEVcQ3QTzKwU/2Q2uJq94CV9B82n4W5kO7ux4ZHtCV7bBNtqecMzww1zedGJ3t+mJOQRqybtEu0Ko+gJccGAVytz6jbGNRHBvGx57IMO4xFYxf9zHpZUtPHdZv8jWgVZsxQ74+Pd0UDCP/hx76H3AwgEjhtXCwdrdir7bjifAiZ+xAS25XnL+tZZb+A19ZU6E5fm8S1hkMajdNz7qxuoV5+WSxE7taGDJOnfl/DKNL+P4M/waMvKY45yuiKe2zDAWLyqBRMHZ8QDDCEj7ASfOK2Lzn4o7a266pMlKchmaoonB0dPJznNntY37nrXipH/vBT8gIJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdC6WFA4M0F9nRdiO1f5gCqUJ2T2qhT0z/ooAeTb0vM=;
 b=ft7uEicfwu4wrlD3HGBZKK2+J1yyUqO4N/FVxFF1EtHyy4W4y2Xuv2Qlem6lp7cBMelyxJJrnWq642l2ErBvstKUhg66R/LxZsN1+hSUGl7Yo11x7dyV4sXCXX/lw52XQYsl9N0XTYy6aAB1Zbp3NjMT6QLsJvaUH0Ak1B7tr/+WK5g+0n0jNG9U7rIqk2h4SdwuF3ccl9JaK+77GpZtIaFIeWtUB2P99AUhV+yO81AR3VOCgaj2n3NLDEEuAeejopuMK/bv0rvpyQZbArzAdQHkvChxegOLO2MECLY/4tYUwnXFauc/0q3QbWMya33W/53NmAhiMzm+Bf6Ehz/NRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdC6WFA4M0F9nRdiO1f5gCqUJ2T2qhT0z/ooAeTb0vM=;
 b=jG+dy8KPX3raAPV/JCSmWoes7BSOWrMjVTgpAnnHBria+yUJDrHW3Ayxa8xSumPjagMHYJls7cALwb0Ysd8+5WSAJlsHHij2U5kVnj4H0i9V1Btv5kG1dELCiaqBUOv8TeSMuJlK9i0zNxo4kRwIRJ66dc/cprhScYx9oibwNrM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 00/12] Generic TX reallocation for DSA
Date:   Fri, 30 Oct 2020 03:48:58 +0200
Message-Id: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db17c22e-ca2c-4d0a-ef58-08d87c76090b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250959B1237B6440E0AEC54FE0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQ681gEbXIRpgf4OPnkEBNJ5NptjdnYjYRf5KfbCdJGRJCiiyC0ElC5hkUC7y5Wd/xPGzUA3r6P1PEjw0jraZq3Rhhwvj0/VOjLP85FcMWdbzyqDsnY/S15DfTEZyf4yO1X55fBjHBHHKaSQhqCLLpZZrFiWJo8t3YuX0uceSvIXssX10totkUgLa6EISA0uBj+rZnLCVa42plty+OVaeRB3CPZmcu0UMaq7nKfErZ+wUDp2hPlqFv5UPvLBFMKwbxw7wkiCgzabSnsL3Yejs7uoZ3wM6hJGS3F41pS5ySgdMx0upyDwepTNksyCxaIuOvd9SEAH5ZNs7anROzyoilRShCOCb9gtWbfivYuhwX4HhwMSpPQMObOCZ24PWU0tuPK+R4Ym2l0NijBfrS58037XH0AlT4/l9VK595ElqZxT91/SwIcjDYuW9r5JRqJpZ4YISAzegh2v7cHc7LKykiIm4ohs8ispTuXwkO4lbIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(966005)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P+R2KMG/YSpYDh/6KdzCMpeMMMR+qzwdpsqirRhs7XI2IqOe7lIxX+IFVe81JhjQKRP/AHrZReuoNubwce/iFF+9tgofBBv99tiek2ng6WV5IT4GgE99oOUREv6DH3Uj5BvOnZcvuGX2u4rSl+HTtmi/AzCL6kcAFYCgFye2kNcusQ5QBdwqfxDKfQr+yal3TF0SIT8XzMsV4UY6Xqnu3Xqj1VPLjFxa+XCMEDXenoWlBT2aIPo963RrY9J4yfgPy0vUMoMaCeHH8TaawDEHGI1giEhK3Ka7Rbm3MVOzoGLno0akzpRVb7VkDsydzBae9AE1c7aoZ+twAgNrAkHXgNrzthiUqTG8cocWVVNAbrJ+1QQuspXcNvJ+wdRDFz258WZAh9DPo9aI1ZTeWG2fl17b8DW+14tFqS0ffeNheJFyJA3k9FD98+O5sjLyMwRc9aS97Xz2RDssAangSWzIRMDKWFGeM8uSD1UwxPq2uX2DbnxMrkJyoImIRoAQ/MLXIXpOS8agqUlLODLlw+Kz2Gy8ZD0zqr2GYTXuahd6HXy+UoMzEaTAMg1o32aCbI4W+g3VbHNWoH27/FQgqZraHH1qK0rNPqDbk729DvvFL4kylyTKnHWCmJHBfHMg0m+TXOvutlb908/rZnBqWCV7vg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db17c22e-ca2c-4d0a-ef58-08d87c76090b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:27.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GC0tARqF6IZGfq58dIL2dqjr1RezpmZaVvzmWk58RoqE2k9B2cCVmVN+Fg5qcP5PD4ucDDWpXf9xlTKEQ/Y/1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian has reported buggy usage of skb_put() in tag_ksz.c, which is
only triggerable in real life using his not-yet-published patches for
IEEE 1588 timestamping on Micrel KSZ switches.

The concrete problem there is that the driver can end up calling
skb_put() and exceed the end of the skb data area, because even though
it had reallocated the frame once before, it hadn't reallocated it large
enough. Christian explained it in more detail here:

https://lore.kernel.org/netdev/20201014161719.30289-1-ceggers@arri.de/
https://lore.kernel.org/netdev/20201016200226.23994-1-ceggers@arri.de/

But actually there's a bigger problem, which is that some taggers which
get more rarely tested tend to do some shenanigans which are uncaught
for the longest time, and in the meanwhile, their code gets copy-pasted
into other taggers, creating a mess. For example, the tail tagging
driver for Marvell 88E6060 currently reallocates _every_single_frame_ on
TX. Is that an obvious indication that nobody is using it? Sure. Is it a
good model to follow when developing a new tail tagging driver? No.

DSA has all the information it needs in order to simplify the job of a
tagger on TX. It knows whether it's a normal or a tail tagger, and what
is the protocol overhead it incurs. So this series performs the
reallocation centrally.

Changes in v2:
- Dropped the tx_realloc counters for now, since the patch was pretty
  controversial and I lack the time at the moment to introduce new UAPI
  for that.
- Do padding for tail taggers irrespective of whether they need to
  reallocate the skb or not.

Christian Eggers (2):
  net: dsa: tag_ksz: don't allocate additional memory for
    padding/tagging
  net: dsa: trailer: don't allocate additional memory for
    padding/tagging

Vladimir Oltean (10):
  net: dsa: implement a central TX reallocation procedure
  net: dsa: tag_qca: let DSA core deal with TX reallocation
  net: dsa: tag_ocelot: let DSA core deal with TX reallocation
  net: dsa: tag_mtk: let DSA core deal with TX reallocation
  net: dsa: tag_lan9303: let DSA core deal with TX reallocation
  net: dsa: tag_edsa: let DSA core deal with TX reallocation
  net: dsa: tag_brcm: let DSA core deal with TX reallocation
  net: dsa: tag_dsa: let DSA core deal with TX reallocation
  net: dsa: tag_gswip: let DSA core deal with TX reallocation
  net: dsa: tag_ar9331: let DSA core deal with TX reallocation

 net/dsa/slave.c       | 45 ++++++++++++++++++++++++++
 net/dsa/tag_ar9331.c  |  3 --
 net/dsa/tag_brcm.c    |  3 --
 net/dsa/tag_dsa.c     |  5 ---
 net/dsa/tag_edsa.c    |  4 ---
 net/dsa/tag_gswip.c   |  5 ---
 net/dsa/tag_ksz.c     | 73 ++++++-------------------------------------
 net/dsa/tag_lan9303.c |  9 ------
 net/dsa/tag_mtk.c     |  3 --
 net/dsa/tag_ocelot.c  |  7 -----
 net/dsa/tag_qca.c     |  3 --
 net/dsa/tag_trailer.c | 31 ++----------------
 12 files changed, 56 insertions(+), 135 deletions(-)

-- 
2.25.1

