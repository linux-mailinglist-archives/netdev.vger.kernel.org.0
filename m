Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BA249D6C6
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiA0AeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:34:15 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:64819 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229724AbiA0AeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:34:12 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QIuxUb025804;
        Wed, 26 Jan 2022 19:33:53 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duc16g77h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:33:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av6DDO/gvwPTT3iGu8vtowpeJ3Ybg+3pVvz0QymH1H6mbDB9h9CLUNEkuFksNhzy49HfFiX4+pd91r1ypRDH/PVeRH/l58OHocE+X+xUFhPRLjsCS40Bf3H0NGjBC1VXNwkt43Sq5cZUj1EtIV3lp0Zp7/sDLDfko7xvb/95cjnSaB3YgwzwekyVfCAWPPdhKCjXYXsHgY5DWusSaOmC+Q+nfpX3miLqkgY8WVkmb+/ENwIutmN/ruqgWhvKNePez/rnrjgjViD7ywFs8ThdB5UQtJHfFEsx3JkrpsvnJ1XHN7G/yM4j+Iy2TyZqx3hjNkCuJnA0csy5+wzJ/NB/xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBV51ia/xjyZQSQ/+iGLff1odBi7rwKUWb6GIFqtoP4=;
 b=IkQvlTmZsAny5BavjgNvzhMtskGYoKeF/Fsi084ZDuEsgW3D8+vrKITBrauHw3V/IYxbM+3tW2ER5qBIunc11lKTs2FC6S1TF+RNMknrlJVx98Cqzc4RyauEkGuyjLXOqO2O2gaiHkNX+MrLbtVMbkqBU0h+PMuACHRffF82F8g23A+sZIwMlNm4qrP6gKrJFDap3mZXwQRMFZQZsnFFCjLTYLCUaw6fNozzl+dsmfwruv9uR+B2C+DeO9haQY/Da2owmIWjpFLiULkbgINO7b+q1ccOdFxhtUjHlmFF2Li21WwuF6WwPDQ6per9qP9HRqBAbchntMeFqjYbANbXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBV51ia/xjyZQSQ/+iGLff1odBi7rwKUWb6GIFqtoP4=;
 b=DA0al47pE+6nCRHoG+7SoQHhSsx9Zl9ISIwrglFkXPhZHV+0g9bGk1tw8Yaog1XA1amEKOuOZatZ7Jrl1YkU+9rll+w/Ien/fIeKVM+Yl8UeMQ0yg8MNNhi1niKfynkqbPIkyvVMOPByoTSsSQxHkB7cWmwhbwVNDsXsWLlJ+Mc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:33:51 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:33:51 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 0/2] Allow disabling KSZ switch refclock
Date:   Wed, 26 Jan 2022 18:33:16 -0600
Message-Id: <20220127003318.3633212-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:610:cd::6) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cb4f194-3aaf-4f15-afaf-08d9e12cb0f7
X-MS-TrafficTypeDiagnostic: YT3PR01MB6084:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6084780846E2B6B49B4D03EBEC219@YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WxZCvrQe9EzAtA1WhSjYKZ9oj71b2uIoa0CdU9hpWRhSNND7G3ljEoGwBC8fE391fxKyUlO+pSips2gRc3tDbLcNAuKp8nR7E1raKAaHbogNT0vmLihEkiWR1nzAgKyZTnHJil1kCqJFNw9i/2Mor5bFCPBxj2t2jzYynKBO6LliQqW+ESyID4FXnfWIhj/hvbkWgmheM5UDthYR5LkmgO5EeDDG9FP+zX5Fhhiht8oyMe39akYZ3fTgQtytN9lfgG17XjnVgUm8EWP2JwZHM9I/h7tjevRLn9TO6wSMObd9atdXjNGU66IhkGBvhtEVoiCivHkiHdVSt+MpmrOBO2ydHjlPrWGfQt0baaB3sST9/UjwGbwuMKHThkNRU9Jr7UyrUqlg+jeIsf1FpAK8NtyLUJgzBEP4H6Y+6nj4u0YSxp8otTBBza5tHqA2kobkq2TT968zQ3rsoqO4Wmjol/X2DzLnY7iySeYg5eMSYOF+dI6Fq5sRChoKVsFknQhPgXbH0eUTU2SwRfyCyFbHIegk03j2iIHI14f+IyNZ+hM6jlaoTZRKaPUPcPRQ2boTRKauVWteb6bncNAknZ0lpw/6X1gb6qH5sP7vv9yiJp4YesLiDwy18JXhNIG6jP7oh7FiVKQL9HG7JEIbY5J5PBQv/E+xVxljTzar9Gom38zkceOlTXLLODSfWX8sBIkVDqErx3qNTEJy833Zuidqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(107886003)(4744005)(38350700002)(38100700002)(44832011)(2906002)(7416002)(86362001)(6506007)(6512007)(5660300002)(6666004)(6486002)(66946007)(66476007)(316002)(26005)(36756003)(6916009)(8676002)(4326008)(8936002)(66556008)(1076003)(2616005)(186003)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ysd15iYkRD/PHF4EJzTeIBGuicHtjRiiqac+kD+AEsKtpmlrs+ol1B3/a9rO?=
 =?us-ascii?Q?7sNZtQsXTuPyk6xkp3rp2n0RhV5feQZq/6G7Q27Vdf7qvO8ygTFBcXhTBcXQ?=
 =?us-ascii?Q?SF0ZxRI07bN3t2xRT8VEJ48Ga7RcZRqN7By47yUuBJXobNeRbNrEfpJWEznU?=
 =?us-ascii?Q?L11TXq4sSVsAc8MU4unaGJHnhjrQNBmx6adfKHH8xGVGercD0j3bpmsLTklT?=
 =?us-ascii?Q?iF/VLOfe6L9VdD6d1cuXpTnRzbPTuMAbyPY2wZy7DJ+WxriWASDpCQFDC8Pi?=
 =?us-ascii?Q?+ZZVd/B69451KyD88/yuwLcwdhpwwj6fhhifEkYdCJCsu5NJC7G3MBTPLBzq?=
 =?us-ascii?Q?gR7bIG7IlZlejr0S6KTiJu2aL9+sK+fYyEmYeHAvTu7tFF0plWT7OEwlJ6dg?=
 =?us-ascii?Q?wY06VwaNucuJkBe8ADb4nbpc2j/HDJaP53wZRsbLhYvSyO/jISUs7YKZhye8?=
 =?us-ascii?Q?cWjlvayfi9+sZjCo6zIxskxe0+YLfzZh9UMOkLRiRVAu4nQhuH6pnVMdbxOG?=
 =?us-ascii?Q?uBaJCCI6Djjrf6RYnYupDtnZbmJVaaRDhRVKcSaSGPQBrtM8c7U5131LRAO/?=
 =?us-ascii?Q?hQd/sDBNG8n07F/UqBRrR+XuBWvY4S8kls0XwbvoAs0gE1xs5HwKDaffdHsj?=
 =?us-ascii?Q?toOGfT7jQPfAiyVT+4DlyvLM6LBDkaco65MqvhE+onV54jg1XN+dl1mAGfId?=
 =?us-ascii?Q?iX3jvZwcHKm4Tnz5B6tmgZhxTPJF5KomokXvScb0gr8w2Py4JJxaT9Ue8sFa?=
 =?us-ascii?Q?ZYUHzjPqnwup9yTxGMBvHJYbGdvamPEg117z9s0LDfD0HyAPeLx6tOkXJrsP?=
 =?us-ascii?Q?AZwF9WXt4M7iu2u8ZYkm0DZNAPOvr7j3RFFj3YgehOJXx2YxtHSfQteoq35K?=
 =?us-ascii?Q?nDRSe7lywOn0u7CwNB1cb7SA9wvJ44VLXvLmhBapXC9A3X3nHyXvb+gPFA9N?=
 =?us-ascii?Q?z/A+TsywdOqRcNraxAfyDUMYvtETkN5hsfbAqNiU2U287U7NZrdF6t2S6/r2?=
 =?us-ascii?Q?f/DWuTMg4X9sTyzKu49Gem3tvmwxkUMqFcxHY4JX/AJZmu1IPKCbnH4u+YAH?=
 =?us-ascii?Q?KpFBrAl1UpG+4RleZVXwAQyQE8vfTqGeNV1qexssNKcAluBl9mM9tF4PfNVm?=
 =?us-ascii?Q?Zx9Pyhazarq9LLYFivEasHnH7yav4cjZcxb6a3+4OZ0XhB7pXMlCJMNWU5X3?=
 =?us-ascii?Q?KEiAAILcrOngAaqXTviwHVkDWDTwIvopSNCip0eF+WqpLotnSDO/phR3KSL3?=
 =?us-ascii?Q?crISK5Sgo6pRCJCmjnrjAK6mY7L47e3Yvfail+7R36Y0wL4ZVABK5kw2amRq?=
 =?us-ascii?Q?BimIdxYnxjrpyRnaKQMwbRVZXW6W1QGvNLwYM+nwdOxR0tRFMRp43NLX4Wwu?=
 =?us-ascii?Q?4yk5R6/S0zClBX6QEVPy+LFXJsxNBJYu1Pzw2i/I+OUYmex0vcCPGsr+jXFx?=
 =?us-ascii?Q?g7yASb7vOQghdB/3HS9greAYSPn+f4TL+Jv8lde6oljRFTrfXWUF9Tuq9VeU?=
 =?us-ascii?Q?dHFrDq+mHD9Db2VGtKH1RZp9YlKrrqAXYwBVmNCYVzKt1CMrDNqPvgi7l/sD?=
 =?us-ascii?Q?qlifK0aOicZpuDwFZfjoheajxJ67BFJ9F+WQcvMi6BIqOPV3WOqpxbuufUX6?=
 =?us-ascii?Q?BIBD9UnjPTIZGzoN87NuqQEogUj5NOgM9Fh5lS21mRqfUIumH3dCWA1BKq9P?=
 =?us-ascii?Q?sVuCgHDL5Y9DGu04/+AZuS55GmQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb4f194-3aaf-4f15-afaf-08d9e12cb0f7
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:33:51.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP6DWxaQyaZRIgKaxxEAgAAlv/2g8HfDoWUMbUU6tT6V/BlyTjJxqaAON1MT7tTQNFmgjUHGINa9v3D14uXCWZ+TL76MPjD/kEbBi66o6tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6084
X-Proofpoint-GUID: qkV6TrLJz1sbPaAy4jAjkXViC2HtMYsM
X-Proofpoint-ORIG-GUID: qkV6TrLJz1sbPaAy4jAjkXViC2HtMYsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 mlxscore=0 mlxlogscore=750
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference clock output from the KSZ9477 and related Microchip
switch devices is not required on all board designs. Add a device
tree property to disable it for power and EMI reasons.

Changes since v2:
-check for conflicting options in DT, added note in bindings doc

Changes since v1:
-added Acked-by on patch 1, rebase to net-next

Robert Hancock (2):
  net: dsa: microchip: Document property to disable reference clock
  net: dsa: microchip: Add property to disable reference clock

 .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 6 ++++++
 drivers/net/dsa/microchip/ksz9477.c                        | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c                     | 6 ++++++
 drivers/net/dsa/microchip/ksz_common.h                     | 1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.31.1

