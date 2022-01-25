Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469DF49B9DE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355358AbiAYROB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:14:01 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:53275 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345434AbiAYRMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:12:23 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PCACSo029427;
        Tue, 25 Jan 2022 12:12:08 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsyrhrjeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:12:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzM/AGP1d0dIavjez80KjunaFzaS3nn+sDHpWWgF700usyfWWtruboeI+OeJ93awK2Khxkc570qHSmW9yLIX7MqG14iVPZ4BxbvKgTQyun+1J5M2izbWJ/vDvw1S360Wh0KoVtEiEDI7I57hgIDOJy0b4VS3aCqlETCsIf+PW8U8DPa5Ota7BYtNrZxkClKfx+z+TeiRaHp5M9a5VrPcNz9bh6MOyGP+DgmeCjek8/MVtOxhfdD4z0FsqnqKTRJCM2GBckL37kTBphiRCQfxqfC0M+hW6s/8IqMskBRcwnNdZfKXvQmNcn1BsrA0yYpzMn5cOj2ALXXpGRhHZQBU3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0cpVBGPudZ2bPdGwWhUfwBx7x/q5PcTUoHHhEJ5TUM=;
 b=WNa0w7rhORfJ6TqsOrmRq/3aTZsbPDxpiX8tmIkzd86g33RDa6AaM6ovGmO9heR/xC4qQzjNoReQkhbO/emWOoQ6q77bL4gGI6gmh33lUf5nAZp4U+KR0m5cNS3MwcgK10pRYvA2g1N38hBdHb3uLKUOh2nDqIcUtps32itAtPW3J7dP3uqgtLnRV/rCGeTKnQl0Nec/Iuk4LqFvPZqrA4i/7Ht+ph6db9RYOv41Mr1ydTxyHGvf1r38xOD1OvTB0KFMVg5Xhv7JhwMIyapmrB5EAoBQivpeB7//0OfAUsDeZFctIBt2vO7Hauc6OTPTxUXeL5bNIYwQa+fbeaFrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0cpVBGPudZ2bPdGwWhUfwBx7x/q5PcTUoHHhEJ5TUM=;
 b=R5Z+r7iLldrDtVYthy/KeF1IWFWhj2S1KLVtJzhiW0SIJ4OEKfxRKmhqJFUxZwy/wMlF5v42ssgJ1tcGTJ5JqEZomsdKv5JnFQiEuS1r6E/MxkChTpjgRodaNR80cPxIF6tbtfra251gbEr1jBB1cEd47K2dMSvAQenUirUdV0w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB4368.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 17:12:05 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:12:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/2] Allow disabling KSZ switch refclock
Date:   Tue, 25 Jan 2022 11:11:38 -0600
Message-Id: <20220125171140.258190-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0020.namprd12.prod.outlook.com
 (2603:10b6:301:4a::30) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80740e19-f379-4dbd-5aab-08d9e025cf6b
X-MS-TrafficTypeDiagnostic: YT2PR01MB4368:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB4368DB325F78FFA909C16283EC5F9@YT2PR01MB4368.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnYXwS8iMnJfiV3P9nW9TNBlKR9dO6q7ayVl5H2rhLFuC/8qGqzs5N5VU/JKnLOORL+NLBXn210nF3Trns319/BdG1lqStH7TwNqxNlj9m/Ej2521o7W416E6HU57gLfCXkEotUEUoFXHfJ7UHfA809pmUEyb/p5JFKkXYcnNKQOyDlKiHaPoE1y2jrGfCjOf61741q38iaAMK8y9c6zw8VaYpjjet20a2Av4+JcRpWGzVkNaPeAAa+/4iOOt56OLfdth8KRYL7pa2lWyYIdDuzyNGNVqb1Ae1TbxaRVezYSRNHcvyEbCbIL/+KA7h7FzsHiJNnKyjDox4xZlu9hhWAUQb4X3z6LeAwsmZmgFXOEP3xX4ed4v7xoNmDV0q4iJwY2OXFSqL5+xEY/zK6qSo4M91hMat3/elhxssM4h3h5MjdcyLE4qRvleWJbeJo4ik1YT5+KTD67u4gFCokfIUKIY0KfM7D3GZFupk5g+RdgG94vzBxE84Burx7mqA81Nuoy6umnEy2c/OyN3xBOdD1A3QjHqvsDPV6NRQlrvu1FR/Ncq6RojSY8QUX+RrwUUMS6iqnAlO22ECY+2nfLBMeJCmlxSLuM1+lkOlqTgIwLm9tX+KPaEGUT/Iz+sokYYoCTtu+3JVpudelyQ56YhJpkdEYs/xEZi9HIv9iOoxyh8Rof2DKHJaVG2t4tcXQHlgNK0ta4V9t3LWTVO1sQYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(36756003)(66476007)(7416002)(107886003)(316002)(4326008)(2616005)(5660300002)(186003)(1076003)(66946007)(508600001)(6916009)(2906002)(26005)(4744005)(6666004)(8936002)(6486002)(8676002)(6512007)(6506007)(52116002)(38350700002)(83380400001)(86362001)(38100700002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sdZDwdutk/mRPf+P8+jQjaZy9+qukHHPYGSs4oSPOtjLHbjYP8adjdzfjEDe?=
 =?us-ascii?Q?O4gKQ7VPumZxPTh2xtixu/uztHwYKUWB9m0vMsw1FElGOPoPyG01fYe2Br1o?=
 =?us-ascii?Q?YofPTeBvBIsfjaAJhbJPZwP6VpjVYAhdQ922VYvCFtFNCa46MW2PJuPLDD0p?=
 =?us-ascii?Q?JV4ACk8zjBoTARNGu9lLyucsScw5x8uguFJI2qVurQHBKz3i/71dxEZaq2ud?=
 =?us-ascii?Q?ibMDj99XKAmnpx8Oy+U7ZdlvhwiM6W/hfbGqQIISZtmYvQlrjZp9xt+wppuc?=
 =?us-ascii?Q?PFDn1e4HaiXLyvJVOr/42KCaug2kRJiRK/qFhGpSXt1X1SmiqES8DnLNAdZb?=
 =?us-ascii?Q?kHmlKdbwX6ne7+e/3+8SXQCYBo0CVcIM7gUBIwYJnaxbQqZo32niB1bHz2CX?=
 =?us-ascii?Q?bp2SVwiJ/YMsMs7fI6XWQxjHuSsWFXt3isDk5O4PVKZDGoCTb0jSljEnH107?=
 =?us-ascii?Q?v1K3O7Cl8pxM4COgZRuTH7tvS/VCbpc7brtfcA7bBG6ADoQP9Y+CYwDtJK1R?=
 =?us-ascii?Q?UhzB4MY5k4Q/xWgYa5KNtCmyDKvzpUKbWUC9ACabkuvBajA22JERL3L4Pftl?=
 =?us-ascii?Q?UZn/GsO+W1WqFHzaaKwZWdMTfjEezy+R30nPVT1FtKkTTSAjwvTJUZq7jleA?=
 =?us-ascii?Q?svUDEnmfQ/MhSyVIFC0P7tC310HcraywHAZimoM6JRjxg5rXjnSc6N6Tldli?=
 =?us-ascii?Q?KkpeAZ2TwLD/1TEUlvHszN1qKdlW8AvX5Vcp1Er1F9M8sO8rJCRRuLu/CuMh?=
 =?us-ascii?Q?2v2ezezVYMQM59F1+nBS8R428mMOrBNWiKH4dhZAAqwUJob3icwmI8RiFlYo?=
 =?us-ascii?Q?Q+Stq5OAmlN/khWIKaqmUWZfgzSzVxu3HjaU6zYOaqQvmHLTpSzPyIZA6dg2?=
 =?us-ascii?Q?7SLgI93wRCCGla/imy1yuj4mDlDkSmSHl7g5Kpd2IDTYwdvDVlhveSC+3A4Z?=
 =?us-ascii?Q?ureU5jS2x4/U4TECoFaCz7lRW0hPRem+D9uPqbUoIRJY+eZvHmNwQDcVTRZ0?=
 =?us-ascii?Q?xHE8l9ktXGTQ2nlKbiiTC41Ts+h/35cu7ns/Rz4RVe0oRQ+yXQ5t+o0YIzz3?=
 =?us-ascii?Q?QX8F4GFyMhk+3p7lYDpj8L/XmEwM2ZmJkuoUQq9xfBrykuEGLkc06R8nBISO?=
 =?us-ascii?Q?zK8YAhJT+qOVsJGl7iv6VbnPl4DNex+J9R4Ps1xA2b8otGyjIYy+O5iRI65s?=
 =?us-ascii?Q?pyBODfrtYf8wzFoH73q0l76aFzfNZ8Suz8DoxIU8UrEKDzv99akDDMiizGuw?=
 =?us-ascii?Q?mTmTlg+ZIXqE5hoKjz3IeBk/1VN+L0BUV+XbUnLNdQ4FFFYBqNnJUPyyJfz3?=
 =?us-ascii?Q?qHTPMFrAELAy3ql6GRRriA1ErGcI8tt95RpNoZdcotyb06vrhl8oMV/J7lWd?=
 =?us-ascii?Q?r4VBq1/wH1as+rlamaqQEvJfzS91LfZO15TiNvFUWEk2ql4ne47XCQRSc4rQ?=
 =?us-ascii?Q?OoT8ZN8NHixSnsn8zb2a1O4F4KgHxZnnLZ4WMt6qlssbv3/k4ux3+1eai5I5?=
 =?us-ascii?Q?HSlLBCPl/T8BlcdXJsUHL8N2Qgct5HrS+UV+3TIg37ISVcCXdpraAjtAXUrn?=
 =?us-ascii?Q?hgMWjbBGc+Amjgec0X6kDuZ/Ek734i7GN35l9QAHpPq5XGbq9WZrGr/UZzvP?=
 =?us-ascii?Q?MeH/+chG5nED7/8tXqB6ZQjS2DDJgS3oRq9cBpV6Y4djLY1Il815uzDOfUDc?=
 =?us-ascii?Q?4HQ6GPFq7jbv6Z9EC/v8STpKbHc=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80740e19-f379-4dbd-5aab-08d9e025cf6b
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:12:04.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF00q5iq14OwCnSSgCM1M6MSoQm3h59DXo2QM9jnIIZQdwTCJm18TuvV4WbQEvKZCFrRELGa1NBsgj3ZSRviAbw/VaV1tFJH/sqgS5gFRjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4368
X-Proofpoint-ORIG-GUID: y8Y2YWkch9qQD_OuQW4V1JoU4EBhKR_9
X-Proofpoint-GUID: y8Y2YWkch9qQD_OuQW4V1JoU4EBhKR_9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=713 clxscore=1011
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference clock output from the KSZ9477 and related Microchip
switch devices is not required on all board designs. Add a device
tree property to disable it for power and EMI reasons.

Changes since v1:
-added Acked-by on patch 1, rebase to net-next

Robert Hancock (2):
  net: dsa: microchip: Document property to disable reference clock
  net: dsa: microchip: Add property to disable reference clock

 .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 5 +++++
 drivers/net/dsa/microchip/ksz9477.c                        | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c                     | 2 ++
 drivers/net/dsa/microchip/ksz_common.h                     | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.31.1

