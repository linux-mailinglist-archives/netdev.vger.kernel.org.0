Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE3337EF5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCKUTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:19:07 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:63839 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhCKUS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:18:59 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BKBoQR029473;
        Thu, 11 Mar 2021 15:18:39 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 376bes9j08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:18:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQAa6AIGKxpc1+d4TGAbGYCmmCz/vf5VEnLwiccY4NmNEUpiSNtUXAu6oldO4msIT1cUvQvx4mMevVCShP++HeDPjlyGYcmGx78yfqUPSSa4UoPlVUIv6IzaJIM8hs4iZU4tzvPr2Il2dkj3m0JVr/V/kc8K4HbqhHT9SYcE+WcXjRzuOxp9Z5Wg2Kpp2BL9JTwHzUPCVLBxrfP30RCXmhNSOa6IKwVozIrhQrGqBsSMM1/KnyBJ1GqN9JLpM2vnYKdHr9tBHFXUk3zSbxiFD3vLVagtbUDnVaH/j/DQ/CGj1+ouM+4TT422v+BqfUOcaHrkcwtM+zjdR6ysF1OZzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raW57/4tblB6UWUk6q6xeyZ1Jq9zjYc2DXSH3byE/pE=;
 b=iVigf0R00bCF3i/amfYF6ybaQSAFGqUF0W8NeXTRakqOZnhKhDrTFJQNZxNwLKeJqIgsJfKk4MB0fj+kPtxJ8NE3/i2ssypjdpyz5CaQOMQo+3nCMBVot7XVj1nXw6RnZovV6l0wldstfF9yR4KFZqS/tT6bERf/7rSqvIzM8EcMpTP/2bjTAqWwiPt9jYLiBRQyZtAQJR/Ii8ELMis44NUFworJAb0n6aChLAEQ5BZBYOrf3MdAP2bd4fQK9i3unRfgs8VRJ0IVQGQBCL9+ip2gSojAopP8kiPBOl9YZN9RSS8+kb8UUL7DIpCLfxYqyZV+Xub14xicccD9VBcnRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raW57/4tblB6UWUk6q6xeyZ1Jq9zjYc2DXSH3byE/pE=;
 b=R2VJLLn195Ilg9itzrhwNMK+rFE40GgHU+rWOut9MfaS+DP3lGEe4eU8O6WYpLJFDCOYvSCxTO0Vc5mSBieP5ZuqfQI1Cj3C6v+clw1AkZm5E9K0WQMg7MGLOOY+Lmtt9H31WSo4Pb3CFenkjPPZ5Q3Yl4TYqQiC5pyYeJzADVE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.25; Thu, 11 Mar
 2021 20:18:37 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:18:37 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] macb SGMII fixed-link fixes
Date:   Thu, 11 Mar 2021 14:18:11 -0600
Message-Id: <20210311201813.3804249-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:3:13f::33) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR17CA0071.namprd17.prod.outlook.com (2603:10b6:3:13f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 008326c1-b5a0-40bc-4a67-08d8e4cada50
X-MS-TrafficTypeDiagnostic: YTBPR01MB3872:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB387248EC5441493E7BE416A4EC909@YTBPR01MB3872.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kl1EsYDYFgL+DtsiIDM0KfXWvSHXac6GLQ0hKrZ8x7+2tOF+w3r1Vm9++PZyA+vbhVAs0oFsCB3Hl2AaUb1WkUmT0YQrnsy4MYCslxJ75wflaW2mdn5QFHQNUTcr0ucLseo53TKWQHxIMD+v/Ftxm0JVO3Rprafr2TQOoBvnpTQV86jp9XqbhFhCkDAHsc7EP8wkrMFyDdEdPiDYCSHSnkl+08j4cdhSMFtIIaEsry18DNY0Myc/GNrWzGrzf6k2RmxKrL50bB6yuoi9NpmFrpKQ8yyMi2BDdCgr9KbM16hfDxIsG5gb4AguiUavPxacdP5MxEQaCmRSOXcUbkiBMNiiT7l3LThkjki/YZfeRRdO2n0WhkiVJxIcb6sz5lV/eKmUVQ7aGib9r1ZcR1TbBNLhyzTU2LrJuiv9WeVdicRpxSHa9ohawn48J6RYv7X0trOnjn4Irgx7ZwemdO22otbDAlUXG/r2FRMN00TRs4kvTw9oz+JEuIeeNzteD8AgkqU6mVBhZLOeUwCjSxzSe2AfGKtUoVjiKyjLYggiS4JwS9i/C8kcb6KnNh9As6GKY7Kv3t4O1Ugiqior+nbKyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39850400004)(396003)(66946007)(36756003)(6486002)(478600001)(52116002)(69590400012)(66476007)(2906002)(66556008)(316002)(44832011)(86362001)(6506007)(186003)(16526019)(2616005)(8676002)(956004)(8936002)(26005)(6512007)(107886003)(4744005)(5660300002)(1076003)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7NMcvNgLHFsuMmBPaf0UpQTVxjf0srFPLV6wVrg3szwUbveO/sicpjj9OY13?=
 =?us-ascii?Q?tgR8Nhw1Ecs32plkqtM98jd3Nk8/P2Rpbj4aTmosRQ89P7afXlKtUO07hd+/?=
 =?us-ascii?Q?frAF86s0ghXD4yjdgJ6ZKsiLNFDjEF9EjLka39ybLb3rDAt24w4i79vqqLQl?=
 =?us-ascii?Q?Y+0eDpO7WQeqZdjqXUeOnysElefq/WVAEfiqG4qfwLd4RjRIx7LcEZpFJM1M?=
 =?us-ascii?Q?IURCqOC4jBIwQvxgqXcKolF9T6ClbNI7Ss3KUnDpgV0J7za9ocnv9eiWx8mA?=
 =?us-ascii?Q?fGuAd78Tw5jQhgSf42PplCkdKknxnoEGyj27hBRkFV4josxFF77/Yi4ORWtG?=
 =?us-ascii?Q?zUX5HvEs5utchMmy7EgYWdUp04GpV8TK1xvjIA7MR9wMwIcTD9fpMlf0L+85?=
 =?us-ascii?Q?1sx5d5EfB95DPCKshB8DaZ4bi7PfHENH5IoTeVk1ufe1FOBCNeVzfpGJUch+?=
 =?us-ascii?Q?ykSbZ1REejnm8gZfI1q0QSEzCYCTzygrfTUs2mLn1baagykGKNQy7SEhiPSr?=
 =?us-ascii?Q?cLT4721zR4Awnv1zGofWV8Y9n/7KRX1doa1Ek/N58o1lKU1qWZAdP4BSlEgw?=
 =?us-ascii?Q?9WbUWqQ1tQmSmJN1hWiku1yagxcCwNV/ZKfpZ9gkBLVef85MTxQYYghkBRdk?=
 =?us-ascii?Q?IsjcFGreymMhanp5RqHIj8MQsGCHkqJ+L0STO1kwOzNA5DoR3l8547GKgQEN?=
 =?us-ascii?Q?ALOcc6GyvHcdy6TAj7iGwsgkB0KZqc7MMJhTWJ6fPtPfuCqa4rAbTD5QpPCy?=
 =?us-ascii?Q?JYZaLR6ikoHQI27CuT6o2wpKJGrFNuvbzmCDWgo5IpCN71HVYNwTppiAyYTt?=
 =?us-ascii?Q?FrNW9y4Q0ZVDueo/H56FUns1mNSH6rKfcwqTE9A7UA446h6LbI0DTmLn5AfF?=
 =?us-ascii?Q?gaqMsC4zd3sAPE0fk4+m8QoIZ43p11UjAHYU9+KwC4t80eEjKKAihwG+Ld8d?=
 =?us-ascii?Q?GrEx4lmSPQq3f95lA4bfdgann8fg9F+0hDp/zYS5McBVf0A0AUgeb24LlYD+?=
 =?us-ascii?Q?nX6LS045w0FwMoZscj890sTBcwVoM0SwREY6uCvskfii/Or2sC30OTwkb2+K?=
 =?us-ascii?Q?QmoeJOB7gcwr+p5oBFV0aoK+mOByB9K5n5ndHs0rL0vEA6s5302ey41Mgstp?=
 =?us-ascii?Q?NHiCaZlLrtMHpz7D9NXqt5mGar5nICPJX5MEXv8djtUAZnwDS+IjJ9hwrvNX?=
 =?us-ascii?Q?O+Ne0OMKwnScgG5TT0AmNEP4ohsGno+Id9VI1hxM+RUriGDN9r7R19q79BOr?=
 =?us-ascii?Q?E9GCIUaCpXsg5FbBbAXsy3AWCA3TYlvLn0ggGOBQTBebidrUfHeehzB0v0k5?=
 =?us-ascii?Q?9czl3aWCQGSW7UUsOIvbUTjj?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008326c1-b5a0-40bc-4a67-08d8e4cada50
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:18:37.1805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzJmgFQW14Qp4byyrJeqkSeistnFEBwdE44uodVxoflpWSBfriTRaYJpctvOxUsT5ExiI7Dwo1Gi6kIUgLur2DuX67jj7Dd6faQCM6nLDoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3872
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=577 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fixes to the macb driver for use in SGMII mode with a fixed-link (such as
for chip-to-chip connectivity).

Robert Hancock (2):
  net: macb: poll for fixed link state in SGMII mode
  net: macb: Disable PCS auto-negotiation for SGMII fixed-link mode

 drivers/net/ethernet/cadence/macb.h      | 14 +++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 30 ++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

-- 
2.27.0

