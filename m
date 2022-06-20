Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2F551609
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiFTKji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240982AbiFTKjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:39:32 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2112.outbound.protection.outlook.com [40.107.95.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BA81409D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:39:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxASgbdWeYqW4hmkx1ggqBJ098C/ig8oOJQcA0bVW9cfaFfgchDAiMkrj4P1WdgHY9HTDAPjOzoDW/z6Rn/GKvpCc7wg2fuzubcflxF2OOgdKq4hKmH1DxvlRnOAoKSkjDY7PL4y28Mos1koh2gQHN58NLlqwSbrfONV1EKkXgN6dlgx4eo9ynMpZh/P9Jtu3YBkYagfIhpQ2TQNAkj8k0CwoRdLT2tO7eL6qQGqVAk+kv3mEns3sO27ZoAWhoCvvyIBzY2azznA8ORWJihQK96abbwJ7pgn6HubMAfiv/HTQVOpN8v+LlGYb1xdTD1jxUsyxAyF/Fjk9HfldFrMHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xT4unmI1diimh2IBRSMw/L0n4LqpoC7gA7F7nDi2v58=;
 b=dpqGYa3HUtv2uEreo7Wbbdbxi+wfkLfX4uvErd9EDqOYAN72FgD9xJnfCcpQq6qGWgVgfqXo2zrR96VgOfyaWr01I/hQgIOnFJ6lG6e7szOfwHZGUA1WEp60Vbky0MoYVMosok5nQlCw12IDaSOODrZAe1EuaThPFYWMsIuOXeUmiDQ1C5fUZOAqs/mKqOvVmVWDue9pdxL5Qcz4Qg+F2aYphW2mV8dsQy64suonFFP2coKKqrdX8AFKgcB1firNI3NlRQRdY+zOvOTKPuSrU2sip/p/b67GOpJxN14K8q4VK8hDXSl5rsNNP/bOkx+UXKYHhzO8PlBcOBJyhhGjnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xT4unmI1diimh2IBRSMw/L0n4LqpoC7gA7F7nDi2v58=;
 b=kocVylNrsXU5G86vFoVsuPPkgaUPb2dUrMi695S6KuedfvpBTL27yB+lefnz2Vs0vqMjOcsT2dnvgclx/yKXpAHuzt+ElK2V8J4RtYa1LPcmhpo4fSWDDpjfokjjcejSpMOQQilOauTOLgkmcTIfIbqcmiGwYMkqnL5cUW2ujb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2849.namprd13.prod.outlook.com (2603:10b6:408:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.13; Mon, 20 Jun
 2022 10:39:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.015; Mon, 20 Jun 2022
 10:39:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>
Subject: [PATCH net-next] nfp: compose firmware file name with new hwinfo "nffw.partno"
Date:   Mon, 20 Jun 2022 12:39:12 +0200
Message-Id: <20220620103912.46164-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ab0749-a794-49d6-7a06-08da52a92587
X-MS-TrafficTypeDiagnostic: BN8PR13MB2849:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB2849E09E66050A0E23F9E613E8B09@BN8PR13MB2849.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7bXgnz1eGPtI5wo02nfWek6Mu2Cl9um8TS7NirvX7XidyYy9CNVsHY/DWdBKQkNvGJvsQpuyCT6YDPbuWnCLHQ21a9Ck2yoWCvHcscgmUDHv5KQ/21AODj4egt57qigBARBnJexCkx+cL9PAIVehrqQwqICLAvfBMbjK/Crxu8tid2nLJLnSg+FU+59BzVNA7hxoK4iUW7uz7PNzTqDbKVz8bxFYmlnWdsTwCR4t6ZDuFTkDNioqYZpDwfJl1SaycspN218e2t8cYgi20ZDA4iUceSh93hLbQQzM/K4Ex6adytzWsgP2qxg3Xf/cd/Kigo9r9BUTCy9gaPbwfmbOw9Z6qRRl207XJmBF1ctjiqOb+TiN1ipFv1I4ZiQgrB4h6nvn3fIawN8S9N3rOs+JkzhhZgu0bxIciAWepnVhDFiQ/dqB4KL6Qidq148ak9gmBofJEk5m3Tq72IMQ6Ei9WNzVS94Q9voo2j2K5ScP3FM2jLM9dzMC+mLIh05mju1ynS77cokWuk7hFKIHNn0niEUUjx0y/9T6Rztb/mbOWxWwd9lcJmRw8iTDqR8b6W4OIUjvjFB/Gc4clon+cyrN1PSKYoCVfftgPP8utWNc1fHRCuYfWFFwlLImsaeqWhuMVMmZD/B+F6zrofhMkABOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39830400003)(366004)(136003)(396003)(38100700002)(44832011)(110136005)(508600001)(6486002)(2906002)(8936002)(5660300002)(316002)(52116002)(6512007)(66476007)(107886003)(66946007)(83380400001)(186003)(1076003)(6666004)(41300700001)(66556008)(86362001)(8676002)(2616005)(6506007)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VYwrjLWK4ddXXCA0fxLIjfBn4XmZCef87AqXZR8SaiH6AemwcCFUJs3wDNip?=
 =?us-ascii?Q?UJ72d8HJfW895kV88QW54ZlsSj4GO0/drbfXZOR5yWnKR0JO1Y08r6VQZQq7?=
 =?us-ascii?Q?EfoEuW5pk6fi86LsdiDqI0a3j0lHHhqrc1DsbIOBOh7KHlRK+NZrzQM3nfmi?=
 =?us-ascii?Q?Lzw5Tjns/Wc5RTb3MRRQAFM9fOXV7/8DI2zNH0ekprrxk7slv/gZRrGclzIA?=
 =?us-ascii?Q?69RxUQtES+6xncLHIRoJXlcWxiZFYqqWmQ+/3Mpz3yLktq2fkaVTmlvIdxs3?=
 =?us-ascii?Q?gSqzius8ioIrySKqxBGk3Btbi48CBOThpzu2+g8LQjVKERUc9EY0E70DtUm4?=
 =?us-ascii?Q?dx02dbg7Zt4fgdLxtxz427ViESzBxuXhls8/H0awlIvJRhW84wUzkBkuaapI?=
 =?us-ascii?Q?85EHcvTrfFK9s2GU2luY9Ir1N0MNzODAfvjiScuZRzZ/iHLdn5e1/pO+3oqi?=
 =?us-ascii?Q?1xC0MWWFV32YkFpNJ1ln9iq1aCXbQ/dgwnXJpXK2kJ7GnmedGmLUphq9Psf7?=
 =?us-ascii?Q?cNjgaK7Vs0CcqUwBfUzpGxFhvYo2YMXSMtuK0PEo2TIJpO+7/H8LeOdSyXav?=
 =?us-ascii?Q?QOEx8BNUn4SFZ+KKerJd8vSemKHiO93AIi2ie4dcRMsk05MkRYfuVG+jgRX6?=
 =?us-ascii?Q?X9g5mzs5yq/JiUArsy1L6IEnAKABdXKzJ6pi8oXHWN9UUK6rkIo+EGmNI9us?=
 =?us-ascii?Q?QevEUMwwXFWAfefl5sl932lwdZVVpvWUSDIQ1tr/SRuS8dTIcpx0GTBjfJVa?=
 =?us-ascii?Q?eDRBNmZe5FAWhipvhHSIZI7BUX3vvMnNabop4dr3ULRVgOs1YX9NtIUyrHxJ?=
 =?us-ascii?Q?UztfYmuaKvLtVTgQ+XF/Po+8YNwPQX0okLlD1RGINzEigC5jCvm7Qpsxp20u?=
 =?us-ascii?Q?fhgBALL1XNkkHA6jrrzGkbBWDcKhd0B5OL1fny7xn8VIyeqLzEwDx+csQF/F?=
 =?us-ascii?Q?Yaokkz7re6AUnq0Bv1ulAh58LJUPf5AflyZNRGRt3jH1/CghYyDQREqO7swI?=
 =?us-ascii?Q?pmZFUuxz5k0UacemrE8sEeLFEpxEemEu6SzAnRNy5TD9w5VYcoHFtYxK9qKR?=
 =?us-ascii?Q?BtqfyHWd5jeA8bh1S+TqlBIM2VHJpr6Nqffmyrgj7oGEXXSncLJ0Rn3K9BeR?=
 =?us-ascii?Q?R6x3FusI6w42qlGDdEVc1lpUsyRZmU3+p/gnUWup5XKqiWlWLRsKSn5LEkpk?=
 =?us-ascii?Q?9LhIfreCk43tGjAEGkqBDw35zeHl5VRMPdL4oKXOddkjbRIY9b5EAs4kO1dV?=
 =?us-ascii?Q?O1LktrjvnP+FC+pxgn+7RnLWKz7lD3fkq/BjEYmVWWKjFfH0+Fh/gtguPw8Y?=
 =?us-ascii?Q?0tBFFMk7RjyLQpxfsgBJ5vXm/H7xqv/djh5cUa7UIFMHlwOCIvnWAm7DIcdf?=
 =?us-ascii?Q?QBae9C/8EfIqk4qf1mPTzgYM1enXa4j7S0f+JYxTVRxb3TNZctNHKW7S351Q?=
 =?us-ascii?Q?5xoWM1XHaHTsOJx/gNY85/rlinoRSgCS81Fm2BVjMQb11aV4ZSFvGNnnNyKY?=
 =?us-ascii?Q?sipGFFDLXz8N2FBGXKCsfcae9XSpei0MQomjdjrdwveMLWlI6Ym24iWPIMvi?=
 =?us-ascii?Q?nktU8mDuYRqVrWr3tOOCdQZVPeUp/MffNkAo1Sil8Bcgsd1WgYnN45SE7tpI?=
 =?us-ascii?Q?lsrw7X7b4RZDnvm1vGnlw6BssNKgIwYYrQj8w3U+b6VBCNouZjPcB9R2r6o4?=
 =?us-ascii?Q?PdS7ED+IAAlKef5hkdQyyq+qcnLNjd3Hom1yhVVPMW072x9xDcW1A6WPSzKN?=
 =?us-ascii?Q?pVwHtkYjV4o3exTXvVig3Co6CfqeihRweWJl0ayaCR967PUknbrAJ2kqZC7N?=
X-MS-Exchange-AntiSpam-MessageData-1: CTAAoWR77mVQBtHvs8iskYR2Pd4o/emeqHs=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ab0749-a794-49d6-7a06-08da52a92587
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 10:39:26.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24Hba1vl1ExVHHWdsyB4N5KIBc1CVNvwlkzJM2TFbz4AbBjZQEruRtmnROcJI4wrs4lc0cPtoWy+bqdqrxMEZwTldC5VdR1B72P4BFyuqdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

During initialization of the NFP driver, a file name for loading
application firmware is composed using the NIC's AMDA information and port
type (count and speed). E.g.: "nic_AMDA0145-1012_2x10.nffw".

In practice there may be many variants for each NIC type, and many of the
variants relate to assembly components which do not concern the driver and
application firmware implementation. Yet the current scheme leads to a
different application firmware file name for each variant, because they
have different AMDA information.

To reduce proliferation of content-duplicated application firmware images
or symlinks, the NIC's management firmware will only expose differences
between variants that need different application firmware via a newly
introduced hwinfo, "nffw.partno".

Use of the existing hwinfo, "assembly.partno", is maintained in order to
support for NICs with management firmware that does not expose
"nffw.partno".

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 4f88d17536c3..36b173039024 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -410,7 +410,9 @@ nfp_net_fw_find(struct pci_dev *pdev, struct nfp_pf *pf)
 		return NULL;
 	}
 
-	fw_model = nfp_hwinfo_lookup(pf->hwinfo, "assembly.partno");
+	fw_model = nfp_hwinfo_lookup(pf->hwinfo, "nffw.partno");
+	if (!fw_model)
+		fw_model = nfp_hwinfo_lookup(pf->hwinfo, "assembly.partno");
 	if (!fw_model) {
 		dev_err(&pdev->dev, "Error: can't read part number\n");
 		return NULL;
-- 
2.30.2

