Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68F649E7E1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbiA0Qo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:44:28 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:50946 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244026AbiA0Qo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:44:27 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCIlU5006794;
        Thu, 27 Jan 2022 11:44:13 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6t9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:44:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Thgd1Vt0PX+MP81tS5GEoA//U1ri56i8qLH+lhvX0rTMgae1tOR11cuEi+cIZkBBNP7Iw8Bg4T4u86BOFki3Up7DupnyYJF1wzI0auRRTt4UawalhgSmgGP+TO2f69o+TSPIez9sNpQAvqiDAo3u5yk46FWPeHa6WXNpPy7nWknfyzgK8UZS8QBg+aBrsFLU8kcH/c2dgiRZ/UhsQe17VKx6m3vbax4YTjSYdOoqBt/syW1Ygv/SS5cwTJhQ8XJanTx6/AA8kheR3YdyYavceLYncbFc/smkNH+WF0kRspqcIpa4JouuYdcW+Ehzi35f902Hqv6tbd440PgR6Ex1lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaxCf9uH1I8QfcjMjqYWFIZLsMGApIUlcBMhyrjNly4=;
 b=nMNu6XbQVgoebHwtd75PdHdfKkPkAs6js8GWf46bzQbgb0celptVx2ABdvwkJay0eIZxYHaxCbxPyJ0Q6CK9oMzIyio1WbbbCNxg0NbiPGqgW1HZGuVNXDSTfFEeSP4D/TA8WZOfaZP277HSF7LxZr+gWSJOKvHee/tqx9Wmpt01jGVBqXd8sAHmOQWY2AYVo/Xn1cnGq+VroJ9HuP0J3OPpdE1WxZXkArchPy9j49XeW1BmAL7lZHIz2Q27I5r8+Mp58E9hZQpoaZgozA19OjN0o9jUb7QKHWofY0k4hBA1VN0VQD5jBGsrv5/RQyZugkC3hqERtKdr1J5ElVPV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaxCf9uH1I8QfcjMjqYWFIZLsMGApIUlcBMhyrjNly4=;
 b=a91xMmOxGmlAkniJVMO/JKMOolncsRf0gQcoI5sVnhuAqCurYTpRpI/arcKhEpZAtILI1GUDw9exnxEpaSf6MdI+XGppok7stx1DjPYCFR94WIjzcHrRgQRX47amTrE8Hm9w0ZCQ1MF1KVEc6MRDOtIT676VkqszGJ+oMCRxDzY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB2775.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:42::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 16:44:12 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:44:12 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v4 1/2] net: dsa: microchip: Document property to disable reference clock
Date:   Thu, 27 Jan 2022 10:41:55 -0600
Message-Id: <20220127164156.3677856-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127164156.3677856-1-robert.hancock@calian.com>
References: <20220127164156.3677856-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:610:e7::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 030f5f33-f6ae-4d78-319d-08d9e1b43f22
X-MS-TrafficTypeDiagnostic: YQXPR01MB2775:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB277590DBD413571AF63C5424EC219@YQXPR01MB2775.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XObsx4UHMl97uMr0ywolPF2mbCWob2hEOlgAgrk256VOGT3+OT9iI4mvizetyDszexV6YDMV2MikRjEMP3B/CLpqRgG6ffgrbDavObvGaRzdCABg30QOHJo68uH8jq8O8qcouqYVe1lCcK4uX0YwUbb+5a5OIn93RMOrS492vyfXkHK5Z6B6SvEUkZ6JNYQbQkqW4h+VpQ83j6fhmzgh29/pc9AJYfFscs40wzkgTB5yOChHe70rUFZnx4QttO9J8aYUYtL1PDAy+alq03QeixkW3GdC46WbrKnKywszRg0LbRrDzKdS4OfJQQ3PW6YLq9ld0pR4xo93gxV+ep3vkA6YKi6k1bhg7FcHhagfPNEeDv69oXljzDFbSN7CEyyJ+5u7SJ2HMolyrtG/WnnsppHQrwuI3/UbnwQiiF2xqWxVQYCVgQViYYDvNms9nmXrgGc/bb/2ko8W8VXr6mJzl+gQU4o7b0ZF+9ls0bwZ9ykMX5VcLyzsB9A62Xczwoxju12LTjXF3ghpxy+O8xbK2/K/tshlbKkNPTNW2ULZtmOE/Znr/Kz+aZX66GOIKnQNPLSxhPASDYLWDgaNeLiGPWdILIfZOs41Gs9PYphOAjbFfyrawIWPU9YFa4oolbKI04S9+LW7WN25DusNOyhzRbj843vP8Q12zrU3s15s3dR9C9oh8Yz4vIejXA2brXrT4EKpctoM2lvGZG2ULtLgiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(7416002)(36756003)(83380400001)(4326008)(6916009)(26005)(6666004)(38100700002)(38350700002)(186003)(8936002)(54906003)(6506007)(2906002)(86362001)(316002)(508600001)(66476007)(5660300002)(66946007)(6512007)(6486002)(66556008)(44832011)(52116002)(8676002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5Ca5LTl8MP7FVVSaV94h+bZmYUYHOmRPEA6s5FDU2yA2PhAQg8gzSAGSXgr?=
 =?us-ascii?Q?JavLx8BsMb726TlZignGJI7c2VNFUrVBFqJCkc3P5ybwzd1JB7NFtWXpQWbq?=
 =?us-ascii?Q?vMEsxs/wuB0KbX2ielTjvZvOMYs5RfYfXXbnYklvV3HT/SqSgkMBdY1GLJQi?=
 =?us-ascii?Q?IsKmsyP37C55HqJqmQkpfPVUGKsJA1lkDyIBAkkJDBlKl30ZKLcuDO9TK+V6?=
 =?us-ascii?Q?AhhC4aggU1DgNlKDbwJQ0zcab5WvbGbrkXHjT4NLdHj19jJeXFWmbmYVOHa4?=
 =?us-ascii?Q?izxvU96FpF/HTq4eobeH3/tQXu2TVjC6gM94Xk/yLXIopRKI9JOTdrVPp6mm?=
 =?us-ascii?Q?cLEs8GTYOUTZtw9X03NnUdU/GcYdUUAoBuAgiMQr1If8fUuktFusfYFEJoLi?=
 =?us-ascii?Q?jC6eMlo2JzrQHPTw+3GdxzrYRHbtvFZKZwtaqxZG+jrbK/b1ib+IOXgpg54e?=
 =?us-ascii?Q?HEc8tYQsWOUNR05VBGbTMy5PkB/cpYZGX1O5xG60h/agqlhkbD98cmmlEGqj?=
 =?us-ascii?Q?P//oqLtX55mRDqea6PdlFR1BMtVCokeYb7ousIXAEIiE6n1WWkUaiC4BXn8a?=
 =?us-ascii?Q?cumuxpRGalKK55jv25xgHynaDqSlX3UmQm8AnGBJv27ADEmT8omUx/mSwu1/?=
 =?us-ascii?Q?ydFXTwZx9jjzz8LkBm8m95tjyzYZsLcCdg9TbP0cKzCTeoczxMZFWWtM1yr7?=
 =?us-ascii?Q?YUlLVhLDDZ14BPkXiQ3CyO635ftojfhevN4OZ9km1RFYfltzORqxMq1kwwJU?=
 =?us-ascii?Q?dm91vgjrzueQwqUac05uFvWwADz3/UWp8l4UyTih/KUv41dc5HtALmjmTCuE?=
 =?us-ascii?Q?MuvwNIt7ADjmujxYxV2MdqQjESs0cNN72axNLG/gB0yW5d5rFAi24H13J/eI?=
 =?us-ascii?Q?kPLaVLMK8uUkOECO2rRXfGH582LulcKtOQWRSES6S6qowVsKeEHU7iKYJPK1?=
 =?us-ascii?Q?csnThJKudXhlQlzkQzdi6Iu8DN0dBD1o51znpwa6V1wqPKyK3+WrG/5Zpwb+?=
 =?us-ascii?Q?H9364xEaKPw9zLs631e3KWg3/9gj5v/olLMdJXBA31/dsiK4zDxu2JvpJLgB?=
 =?us-ascii?Q?xRGDRDCIxnSFmvlB40A6LwL7Mk3R+QKiDOoEkcwXJV+8pouw3R1ysJR61sIn?=
 =?us-ascii?Q?RTShi86ZAQm6lFM0lQukV+BUzOwwobQ2kxMFUBcwaUKDraDugJAgTtuOyUL5?=
 =?us-ascii?Q?vLb11il3Jm0e2wXk973woUPWmcCriq12+Rhomo83Ewlr5KjA87/Gu35jKg7a?=
 =?us-ascii?Q?zHNvxME6c3JAxJ+udMRmDDZekE5gEgfF/LPsl8mGGGv2/vFvB1unLcJ3Xq+2?=
 =?us-ascii?Q?i+2TAPVexwmnciUc6+Doxf07qi3R/JyFRCWjBmtBHy+ztzj7VscqeB/ItuKM?=
 =?us-ascii?Q?kTdwl/EwH5if35CvaPTuIk+nlpj+kD1vmao7ogvhgFUybh1u4xml03USyB3p?=
 =?us-ascii?Q?mBzEPM+Ae2QuQQSwf0jOx/2X38MQz/RVWTJJClkdcAj0PoekaoSohnc6Kw7d?=
 =?us-ascii?Q?LkAGhp7d5y3b2auia511ha5HWNLvdw4y9kaJ/YTJkl8oHLe2sl1YkXG+sVQd?=
 =?us-ascii?Q?G0hLmdxorHlBTO5rkIqRkwg3FkhFytRiL7pr7qU+FhroFCXNxuWPpBBN0Dhu?=
 =?us-ascii?Q?wnCJipVMuQO4zaZbztIwlSh3/jUVZTmkEzz9yJZLruUGBULXOnCgY9HWnI+G?=
 =?us-ascii?Q?7PnYGzPsnQN/8KJPfAVNDNt4wT8=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030f5f33-f6ae-4d78-319d-08d9e1b43f22
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:44:12.0766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uDHIvy5wELUNL09rjEPSDpzk41qX03a+VAGwsJoIcrXzHZqQDVXIwIKybqsZ4ooTt6F4vl8t/9liK92ZNHQXlqZGZHBZrwFoXXDuarIghk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB2775
X-Proofpoint-GUID: 1MX-rNNMLF2tkFvLbATpRTcJ1l5kpjqe
X-Proofpoint-ORIG-GUID: 1MX-rNNMLF2tkFvLbATpRTcJ1l5kpjqe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new microchip,synclko-disable property which can be
specified to disable the reference clock output from the device if not
required by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml          | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 84985f53bffd..184152087b60 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -42,6 +42,12 @@ properties:
     description:
       Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
 
+  microchip,synclko-disable:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set if the output SYNCLKO clock should be disabled. Do not mix with
+      microchip,synclko-125.
+
 required:
   - compatible
   - reg
-- 
2.31.1

