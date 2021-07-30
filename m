Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609243DB975
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhG3NkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:40:09 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:37764
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239078AbhG3Nju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:39:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTX9AfPvn0apczWDA8P2IYFdB85MtN38o2jfXbzhnXn2hUIcxX76Cti3Cdp6dnmzdi3OJlwZ2JlfXrUNgxIOqIHwJ8Cu2YeM/mLBZrbfr5WBJk+MvIUWC4QfuCCp6LGvzb/EyHCYzpVVWjYm1L2MaGxR/E4HDPnXPTZ5iyx1YVQHR+1OWnuETmyfZZ90jNl4dgz+O8lS71hBSnUv73vuiollSdCfwPCn84TGSx4RTMLO4RRrkdcGZ6WcSGk0tgltgk3y8oPxDLwV1yUAwLY0cpe9UgSbRZ4UFogkMJ2bVkmCxdKsLT7tedK10+jUEOrgQLEeSMjTMNOURHHZumXydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=MlZNnCouaMwDzkD+aAT/BmwmdFYeL/2w6CddCVD7Q9ZuSN5RDIF7ifD86OblU5tlCNYURm7DjQDc1sP+AsoSQWbDjajWMdxwOBkNFDZ+oPz77CaU8tD7ZLmBCHowRhHbpc2YaB6VrFiU8QWxpCL3BEfcucJ8VMsdjEqcCGMTWYuLSzCwnCuW5027e1NYFzKUfCudKeo8xArwQ+fdQNgtuZ8o60TUorH8W7U2iSQY8HoSbX/g2ikgM7eZFiJiKmRCEwhyJ8Q7qvqEokfRAxn88YSMbllDdiE5WcR1q2INuygAeLaGnbZJSrEmO7kMQj0JdqszuxzaU6cTA4ABieyjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=j5gPTYQGVWjfNDj8twlC4rrNuDEgBSldVz4qCrFdVLwcW+ZrxxdNri5itBXsdqQiizK7MrKYyCXEePTz9v2SACtFVB6mCSBh9I5J128+WwRnIn8F87+FU1TvHAAhmSu9bqXCPAW6pBYFaTImbnxhK0Yt9Eu7G4j5F97bVefpza4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AS8P190MB1271.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 13:39:43 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 13:39:43 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 1/4] net: marvell: prestera: do not fail if FW reply is bigger
Date:   Fri, 30 Jul 2021 16:39:22 +0300
Message-Id: <20210730133925.18851-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730133925.18851-1-vadym.kochan@plvision.eu>
References: <20210730133925.18851-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::25) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 13:39:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdbd04e5-9936-4a9f-3154-08d9535f7cab
X-MS-TrafficTypeDiagnostic: AS8P190MB1271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8P190MB1271929EDE093BFCF70BD10595EC9@AS8P190MB1271.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXYU6BSKAWB5DWgS3uyIqiwXRuMEtM/U7CUNzhwruXq9D9AjnpCHlChRuE9gRJtIbXSVrn60dZVo0laAQda31Rd5MUy8nTIHauPF2KGQ3qfddLde0IeormPznHUYXamM2jZ9ljrJ9+yB9rkR0ZS1Fwqscjrfjq/HBs0MyZGxxqB8/aR8Uaaj6FRAbmB3MRz8QPsgZQ8PD9ipnn0YvKWSLR/cYHUcfXVYJH2POVbnNl11+9Wxy3fHurFzKGACt/KrEscGNOS9taZCPMsK/J406gh0WvbOHag+gP0ZtvJ+yT71Y0NYw63oQeXTlyw2a7cxoNc8bWuliMi/qUjCkuRlBtt/5gu6I/4BQVZscJZC1Sic/Q33cBzqJ1y1Rndz9Bk5NjZ3YvG0AC6uZ4glLbFbNlfDYh7vWdY8F+UeCR32HoxSU1jlxgrJz2SQYldKiBRw/oKS59cmYojWP3Bjx/1g5huu3ktDa/wKcN3Ilzyv+IOnHT6+2HU17EoaE35IbiKGZRLnxcDcQTTYyGCLHKdrKO19pK1zhMLrw6Bwi43GHmcSHfVo4EVOyB5j320S5qWJYYAI9nxXm6/VD0xOvwy4RVUAtFdqG6BEapDNeTFVRo9iRigIfC9Wp/12WLI4QAjomv8zdcTd3QI4GYX64SE5YUdrzSoc45hw4XPEZpw7Mf6wuGCW1BQtR/rMzuocLrcl1c5nLSPaz+Szra+qBlH/RcTUdBBr47bFfZ6D/Ahf69k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(52116002)(8676002)(83380400001)(5660300002)(36756003)(54906003)(26005)(186003)(110136005)(6636002)(6666004)(8936002)(44832011)(2616005)(956004)(478600001)(6486002)(2906002)(6506007)(1076003)(6512007)(38100700002)(86362001)(38350700002)(66946007)(66556008)(7416002)(316002)(4326008)(66476007)(135533001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLtz6C+Jv417jtYym92abSJzhxGkjhsBBeyON28FcMus5yxYOniWwn0aSDwh?=
 =?us-ascii?Q?A5eJxmlxajDiDrgAOMUzvKpWQcJ2BFYT099OJ2QgmGJTPRAEZsCjGgg1mp+u?=
 =?us-ascii?Q?zA1L4EdFECrmPJqzeZ04pXa3F3A3SneDP4KxnSfZpBPX9avhhKRSGwJUDFEh?=
 =?us-ascii?Q?dJc7IquSFjVdPllt34Zlx2vY9F5u3negnBGwyImRriqr3YGhaIih7aBktk5t?=
 =?us-ascii?Q?D8VcY0Hu48VgQr4C4g5Sj0e653k7gxANpubvJvAr3YYLRGXwluS5Nq244vH3?=
 =?us-ascii?Q?m1kadAB0Po10PQJNj9NJE30aMXzvDFasLP5ZQ3qxqfqAhV06Bww5SxMUYhpf?=
 =?us-ascii?Q?xx3i88I2TdeIduYBhznkA246rQlxGUGf3dzFSD4KR24RHb0Ff5w+i8Wuvkwu?=
 =?us-ascii?Q?Un56WC7g6+Sn02Ad9y1ets2n4bxjoTiffHiT6BZowlmLCQ2JXZB5QvCC1Fur?=
 =?us-ascii?Q?Wp9sT31L/SzRQdS9MdlMIHGE8oIgbFJ/9bYPljFCLshIOVlBh9gh18QIEJ8w?=
 =?us-ascii?Q?cps9FCO1UltEbSHBwGXXLT0PVo8+0knlUY8+7nzMmSbcjcXw0j7fk0dcq4k3?=
 =?us-ascii?Q?w89EQb2m179Xddm1IgaMYCRUDthrPBJvammGXW/70RkwWfBM+qfPRO0wIKcY?=
 =?us-ascii?Q?yQWW0vtZHjOxYtZUjQxpjYCo8xxKE0U0nQ/Htr78AFjhKrLZC/NgINQEP9Zz?=
 =?us-ascii?Q?4cXrJEU0SJHRWSij3cH1vdf4jY4Rwt14tRhuM3TTWJkTz4xe+kd+Xx3xUj2H?=
 =?us-ascii?Q?fEA6b90XIqk70knynrpvMyJxi+f/ZlSbYuT7NsiJg3l8pxj+WjN19AwdRGdl?=
 =?us-ascii?Q?2B0TdwHhjBFq7LSeBFowwDgvlSz0R6Md9AlO06UP8c2V/TnwXP4SWtnRmac7?=
 =?us-ascii?Q?JrjGczxVjX425+8LV4BV1aV45J2zj9qbT8RGtujLfo8eGzZmSMHQ9dR7iRdR?=
 =?us-ascii?Q?RURjrlyeCdeuqKg1TreJsw9y9espzY0u4q0mOZ6H9voLU74XM3/+Ru15URAC?=
 =?us-ascii?Q?e/58nasYULUy3OHh+vyhbRFUs4CTTUsKfBj7PMNzP4P5OSnVbypeXbrulQtc?=
 =?us-ascii?Q?XkRwStPLFR/D6SvWga2X5fcj6kLhlBO6k9HHgp1NrW4kqrSdMZqfrONNovtj?=
 =?us-ascii?Q?kl/OMA8vO/OvdPhU38LjIlXvGPDEL37fOhtDKRNGA8IhNGOS3rKI2ThpPKnl?=
 =?us-ascii?Q?oLJIUjnVENrPhvX7WGIrkNvKc+pEITQqTDhrbYlHh1ORhuuRL/qg91Jf8eSf?=
 =?us-ascii?Q?6CFB/MSTb8qGaZLpM+TMU6e2EvKMZKh+FjgzqVWOCFYMJRMAjfTVvPdwI7gU?=
 =?us-ascii?Q?11I57Nisl1wUt3Vfpx9dpcah?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbd04e5-9936-4a9f-3154-08d9535f7cab
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:39:42.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Izoj9PGMsCSUlTjBGzlveQ2+nRL4Xx8di+VIF4l7dfm/giHPAPNL5xskOzZdqw4zMkZ4hW0xGcmK6foQGxMbGUeHYhgG3YljbC3GeVUCVhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There might be a case when driver talks to the newer FW version
which has extended message packets with extra fields, in that case
lets just copy minimum what we need/can.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..58642b540322 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -359,12 +359,7 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 	}
 
 	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
-	if (ret_size > out_size) {
-		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
-			ret_size, out_size);
-		err = -EMSGSIZE;
-		goto cmd_exit;
-	}
+	ret_size = min_t(u32, ret_size, out_size);
 
 	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
 
-- 
2.17.1

