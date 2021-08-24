Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243263F6355
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhHXQwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:13 -0400
Received: from mail-centralus01namln1003.outbound.protection.outlook.com ([40.93.8.3]:59676
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232261AbhHXQwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Km2cX/IMS17WH7wwc/PDMUUO9hAahjfEgroDrNr48yozQfPijQMY14WaujQn/pTE2fqkMdGgrdqIPtAxrwYwTpPL29zhP7ZugD3HLhh743aRVSCRMZ1CWeIdRyryuze2PtUI3FYn3CJn5wQq2ix7fsVg43kMxxoF79KjbzUox59j7/1e9JHF9Qyn4z/58h4fm57Ck2RSy4vi/W8DQceW3uzhwrz1wFyJZhm12+W1a7aAcYqcl9uPR+YViZDUS2wv4fQ9+ghOLT9KKSgnDLWVbt7wd2dQBVjqRwb/wRfI/JxtS0ZNAReU1AMzktaTqLVetE2TWAvAJBURFCZAJvFGfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ylVZD9kpMrdj7SDq4+b4Ds6wJ2WJdfsjq46KJGyofyE=;
 b=k7AFW5UNQWxzJKFWwyhEgQg372SkpfmZPKlBXl48o8TYGJgZcJ6iLf+z42yIIcdXkgOxJn4XzIw7ah9ywSXDSf8MeXWUqxsmk5ibP8CXZO9WLjg1YQST571lXeQ5O1qUsuzSIRjOZGkb7lPtnBPm32TGG2SwwWovqz8cFhG7zUijngmmg0yXlyBVte1rncRqhdfZWIsclC2Lq35TL6zThczQyve3UdMtHoCeGlRmu/NsdXX8OzGMt8zLbnXpP3O7QZQfHdvSHGFjEqqjvtFrvffv3QrS78ePtqwctWWw5mBYICx2ifS4N0r0Femj3XfZHZHlstxNp4+h+zU/1b7LPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylVZD9kpMrdj7SDq4+b4Ds6wJ2WJdfsjq46KJGyofyE=;
 b=G2kuP6ynotSnOlA3rGbJ2upxpqdSesdIb4+nghKULyT99RirEXQy0dN7yhU9mSnOep8BaQjPV28Hp5ZV64H9xNC9wnMHVkEqB145puRKc2NrI6sIiL++EAb3N4eSf8SygVDlf0QuYBC8ssprejUNRAN6q8DlegF109xSAajMpwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1765.namprd21.prod.outlook.com (2603:10b6:4:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2; Tue, 24 Aug
 2021 16:46:57 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247%9]) with mapi id 15.20.4478.005; Tue, 24 Aug 2021
 16:46:57 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 3/3] net: mana: Add WARN_ON_ONCE in case of CQE read overflow
Date:   Tue, 24 Aug 2021 09:46:01 -0700
Message-Id: <1629823561-2261-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
References: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 16:46:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 704d50cd-1c87-4aef-4996-08d9671ec645
X-MS-TrafficTypeDiagnostic: DM5PR21MB1765:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB17654B870309230A50916179ACC59@DM5PR21MB1765.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/g5BS/7vcLbjwt8mP4VgcGJEdsCvdDYZBQhUGNTH9zWhiEt1dHx7HApuSt537c0BeykitVRHjohE06tF3PtJ2yrgfPpjeqZFMGdhazUsc7tCCGjii7ADXgXwZ2gO/rYC//MdmvcQii0N1OYLRY4JSYWr4dL77VVV5pCqACxYg2qTrN7FzpyYJRyZtiVhxZTmuo+2gYjkeyxSUZQk6UmehTCw1oMlK7oujrMUHd//TlxMRue6oUIThJ14QT6TiUE1n9pRUatixMC73XDy0vQ8zYJ3OvYZbWHNZzXcLURXXQfkLtRbnIRel7x+fMnFmdKRz11NRbiUFI5T8GqkQbt3uqlnbyw0qQjmpm25mBz4iG62sUGVZTnVajbypllFOds+JNFUDaHOOBBn5vIH78sJA15eJIoNQpMFfaXwiqXU45YVWBOD403XKUYW/D/+Vb7Ej714Zoz9bXnRh/FXoy1HnumLQzffQwgXCfArn3Ac2wAdL7xrm+eVJbjeKqU+DJdyqp0kQGtXrE6Sea7oMieIxqDeX3kwViZK9Pxxxcfurp53daGkclAGEPchJKFmLiJvFo/6kwIbcnCN1GvRi8f2TW99HNPVe08RqxNgjHv2lx8+6liUl0+U904VYZdnkFva5ZMHU6QOpBaX0lyLhlyeiLntTuFoYKbLwdjxiKzaiNAjCrH4wOOQgg3YgRPHUveWCKocLs3736l6YZ0hSVZmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(5660300002)(4744005)(6486002)(316002)(10290500003)(82960400001)(956004)(6512007)(7846003)(36756003)(2616005)(38100700002)(66946007)(38350700002)(66556008)(66476007)(186003)(2906002)(26005)(6666004)(8676002)(83380400001)(4326008)(52116002)(6506007)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YjR/DV8zQ7cQ2cGMr87pQvo1jdGToJcQiDsRc0DJIm4svwSOFidu/M6APfZr?=
 =?us-ascii?Q?IO9yYuAi0ChKrKJ/B7wylGKRdSuu9avJHu9NraDRLTHarMmp+5+WroHLWBvb?=
 =?us-ascii?Q?BiPwSweJC5zAyj39HLx5VhpBQObOb93sNnYH6eHfk0oFkL1KGfD+qvH/6ucq?=
 =?us-ascii?Q?XLCjepme6+cKabP41jef697r+DK6Q2TV10Sp0RL4Gva09jPd4FwJsklCJhe3?=
 =?us-ascii?Q?Xhhq777byxLOxim5RQNO998gm0UsOnSVzN7FTwPXE7hagleVlxUq/nz8xytk?=
 =?us-ascii?Q?4tKGKjQjdhg7f6fQCC32jEUuZFIBO8uH8gIKXb0VPJ4P8cXFBYwqlpI7JTop?=
 =?us-ascii?Q?fgZHCO79QSiuK0Hxh9g4b3K+bzBRB7cs5AU1kW62Axt8XDntHFExDAkJYCfC?=
 =?us-ascii?Q?S0v4hwksoK3yGIHxa3SuCQZcZ9C4sruR+Ro9jN4ciwsJ5pmLUdRFX4DfA2uJ?=
 =?us-ascii?Q?sQbO95EnQlFlPlQv9aOi69ihKi2otL7vzfAfZp5f1PTfZFpRbSFjCt6OjXqt?=
 =?us-ascii?Q?Cnps7rLthu2jeOXEw7gAn/ba13PMJCQXvNKZFF5d8EmyzGQKYgcWHHebyGJ9?=
 =?us-ascii?Q?nJVfK06MAnPKa1KvVWFUUOPLuBi2Cc3e8q1QB4MLF1ICZ1DstRXr4MLH6zOZ?=
 =?us-ascii?Q?NR50Qg2MpkLiSsG6x5J++vEANn8FobbG6UgYyINWY2/0e5jQ0G0hsUhYRpde?=
 =?us-ascii?Q?+8uQQGqSe8togXKaW/9nbJwyQqvJd5+6pmfB0h+PverXocKJx6oklbS1X3WZ?=
 =?us-ascii?Q?9tQp1kUsrqjVS4m/cfVj957ljiv50gcxS2k1Qje8VlMACG/Zj2KXQ2Ypxaiw?=
 =?us-ascii?Q?DGbgpky7X1xFTrgsvOqx/H67oxCgOaJxhOJsnQGcRlAkmQz2JNlQF75DeKlb?=
 =?us-ascii?Q?Nd1IcHX016H5tXLMXbh4Frd92vaB9pP3Yioo5NQNxsnWcpWxmKWmwpZIvGNu?=
 =?us-ascii?Q?KPXCBi8KvJEBPegmU45A5BMN6i1D4tFxMc69BLPNI98XBWxO0hxpdYHlOng1?=
 =?us-ascii?Q?kl7ZNXqKxZORQvn8pqlDEmmejrzaXojAcpXrvrbjHEJkWFzxvWVOdslYUQ2r?=
 =?us-ascii?Q?Cp28zFphCh59tzC4jEu4ClKoMg0q2geEt6XakeF3bwCK6hKBVsZBMGxWnkI1?=
 =?us-ascii?Q?vjvab2iLkFK/TqBvThOu3x8DQd/8wvrSxxgPfkQKb92uEIVbr5jRekVYMsQl?=
 =?us-ascii?Q?wrDI2o3RA3LNMp9kGPbhn6WD2Q/T8O1mP8yeXDuoHDqJgDsw9dgeaSO4S9+i?=
 =?us-ascii?Q?Q5VDtYhMUQGrbnSAujgiHgT9UGDfAjsLJMJrARYKF79KWxgZ+CNwpwvqwkEB?=
 =?us-ascii?Q?YHjil3BPKzssoXHy06WRJTYu?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704d50cd-1c87-4aef-4996-08d9671ec645
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 16:46:52.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwXiWGOgZU6v9Peewuqi9/vFwRLJpEhhOqMQp21emyOWJxYn1+rbDiYUvEuAP4g8Hci7cPWCetgN91O6mXyKIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not an expected case normally.
Add WARN_ON_ONCE in case of CQE read overflow, instead of failing
silently.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
v2: Add this warning suggested by Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 798099d64202..cee75b561f59 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1093,7 +1093,7 @@ static int mana_gd_read_cqe(struct gdma_queue *cq, struct gdma_comp *comp)
 
 	new_bits = (cq->head / num_cqe) & GDMA_CQE_OWNER_MASK;
 	/* Return -1 if overflow detected. */
-	if (owner_bits != new_bits)
+	if (WARN_ON_ONCE(owner_bits != new_bits))
 		return -1;
 
 	comp->wq_num = cqe->cqe_info.wq_num;
-- 
2.25.1

