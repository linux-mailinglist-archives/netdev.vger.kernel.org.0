Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45849D6B3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiA0A14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:27:56 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:29395 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229589AbiA0A1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:27:55 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QK9ps5002638;
        Wed, 26 Jan 2022 19:27:46 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dud3cr3qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:27:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZCTQQi6CGIF1zCYZmpp6qFfhzVBazzN1oGhe4BjZXV63Fwgkx726WbA/4wKDqbDMjPQ+ARenQQuWF0YVeoO8g4OuUqY/fL/bnaxt/kmbFA0YcmqTFGiiWqY6CY7ZLKN+rHLh5rnRGZ7MKGa7GyIiT4sIZ3xqXtl65yEdY5JM0BDJQ8p6NmkFKH3E8TFPlIBiyox0036M+yWjqT7zu8RDw6jZSB4u31ET9AmpxqfQ9kRxiyJhoNgV59MV7zwEzQ/2N7kOGUK7lFoBD/96CWYEd3k3xu70fMeRPuhjJUTQCBWrmS/EOyUZzOTnMPsUsGfwTmSImcSYVtABjrbM5ho8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxVliNm9pHtTTBj8UWWW5igeLZ/yQYE+zW4H0mC1vgc=;
 b=OFPs2+y2Ua9qJIEzssZt8EjGCWHq27sRP5twe2Y6GompitmpaDWkN8KF4lhh8xiog11AK5rP9oSwnSLcM0MdgAi1ph0oOmTCa3A97ZkjUvBSKG4kwvBqKMmIKFr/+a0aag+nLP9558xOJ8gjyuB8aeaW96orEwrLkroYtSrKfnHuEmEceRbkcPi+ffH3CQ225sXZuuVEFaNxIFzfzRf/CK7T7tss77zxnxv7vhDwG8SAMGC99ksLDwcnrQlCEVlCNfiOlBgy2lRN4PthfrqpQYA9WisrPvctAdW173o339nyZX1U+XdkWzlIo4wplZR79d+upIEQQdSVs6UlIbdbOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxVliNm9pHtTTBj8UWWW5igeLZ/yQYE+zW4H0mC1vgc=;
 b=W5j0ET3jV33Z3mNKXI4tqGUdnWr8ycmXfMddEdMZdhFtuxMwV9dBOI9v/7d1z7EsfEM4dtmEek6mc4NSZea2hGSApKH0aJoh/G0ENoYjC47J+mOIHUeaOdMxlMmD7pbBBsvLA6Fl/t7wQ+L8IjYp5CtgyAYADkuxSHmnPlL/K5g=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Thu, 27 Jan
 2022 00:27:44 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:27:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 0/3] Cadence MACB/GEM support for ZynqMP SGMII
Date:   Wed, 26 Jan 2022 18:27:08 -0600
Message-Id: <20220127002711.3632101-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3fb356f-48b5-43d6-cea6-08d9e12bd645
X-MS-TrafficTypeDiagnostic: YQXPR01MB5578:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB5578AA007C5B9D1AA5C32560EC219@YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwoadVL2k8W+G0njHe9XfPAOkEJpqAfwxYPixkSdn1oQvzMrOANTPJ+0aN91InecoJYcIg1Ed33CzQ/xh94E26W1Pq68jG1qfpAYnarDheH1Zyu8Y5I28BbQWKoJ8W64etJ96LGcke96isR/3n02axFfrZhk+JAIpJXwklKndF9Nx0Syy0BdM3oa1Zw4NtpeNpzU0ZW9ByWqdEljsTg0wBHrobIzrjiWS9KwZqcaNAdftunoZzjL5R219/76Q2QNJFT6hTpf2z5rNlvYi7afbYvmcVbpCUm9eLObmEMp/mPIwJ5x6km3yns0NMJQNJK6MrC/CoqxTdD0aulw6DiPEKB2RFCGc31tvZ9xZXNX/pbIHQXK0yZsYOgHTMohzORcWnrHPB9hRpsmqtySy3eCeLn+AvktUcrI3nc7Spi9CRN1iKLuG+g5fdyybkG38a0T5R3CJNm/1QEhBMuo7fvitXhugm5vbB4Df0yc6EnlhVavygj/9CMbQd28BIu/Lg0ehMTpZ1iPvD/n4cAeWOKxbLofg59sL+LrLJLsk/LXyNTt6DkjbLq6Iz3/0B3xLMDr9ZZBqLR5bSXJHYoSEPIoZLdMeOveZV300YTPhdA2YFoZ+xX+MNI7kO8MIyMlbQh3ZugFI4ldulPKQIJ8fBsinGrycuWQIsXuADJvlA+8xYqzdX7biDxu7huHE9YhrGlBIThjVDaKDzZQZ0TxXl1oog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38350700002)(107886003)(66556008)(8676002)(66476007)(38100700002)(66946007)(4326008)(508600001)(6506007)(44832011)(4744005)(83380400001)(2616005)(52116002)(26005)(186003)(86362001)(2906002)(8936002)(6512007)(36756003)(1076003)(6486002)(6916009)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/8aKmukoI03CCTJGdCBiFDO8sG6YAJSW8eWl1+uRx6ksVsTY5hkhPFXKX7Xf?=
 =?us-ascii?Q?yZ9DOzcXyw7n70VB2zxfBbxPmBvqV34i4k0BYQ/psWN4+Ct2qBfv9pI4pXck?=
 =?us-ascii?Q?vyyj3VA3iZiyADR0ipl+DuHaqGbjeoJw1WcVHyDuqf193WQf+7R8eOzFeROU?=
 =?us-ascii?Q?yGAKgNHO/2MJ0tYvQmRSxDjNDXwcp5dP0bWDxBzQkvdcO0pBYNOFS/CBIUkP?=
 =?us-ascii?Q?vnWWyZ2bw1WlotNZZA2NViEF4OC4XRHmsdm4Us0TkNRJ73SugVnhnhU6U9iI?=
 =?us-ascii?Q?qMx+YJhgwnqZONt+L3LHKVNv60oWuErADX89C9US383VehPB92cZuSyUyctt?=
 =?us-ascii?Q?vO2/DzaPI3LPO01d8NjJ36MIItIlIUhwAaruASXF8a0QjzIkE5TRmyHfoGDH?=
 =?us-ascii?Q?nwLL4A9+Nu9dwtB6jOx8qLUhuzGHh/Pbfjd5jWBDb0Z6oWfJaLabZvH7TYbz?=
 =?us-ascii?Q?gmsU/YgTiKXBSQM0mUO5tdCsvow6QVJQ2gt3v1pxS+AvK4puPmvyXYHjP7rp?=
 =?us-ascii?Q?5/0/QXKnT+EfP1t5Ka3sce42AvMGBLbc2YWrmQ1NNm1NpO1uiXC0+ZEv/zHE?=
 =?us-ascii?Q?/15lafBbbjOJXmahBPbdK3K1OndOJsj6xB53RLjvI1jg3/uSsE4z0pjgY7T9?=
 =?us-ascii?Q?QbpXnSRoTNEvpfW6R2lgFZyJvB3xgWhKa3VnpdmWhz085DAU2Y+h1H9WqqFL?=
 =?us-ascii?Q?+F39GH93msTIK7LBEl6M7A5en8EnEntATyKlRUQnif/C4Dh9afMbQMAnIpVS?=
 =?us-ascii?Q?+o9XrNQr5ex0HLhaKMBseuJ4ALBey0yO62L14FZ+/n0rQ1M1CVs8cODncHDs?=
 =?us-ascii?Q?oehabJBvfcc4K45LEpH3KRnjjJFy4XT+OWIDL7GKxC3ayDTX9t/023IR64YJ?=
 =?us-ascii?Q?AZSN+FU3TZKKgrQKo6SE3AhTgfbO9MVIDpn3mrW4h4hZKTyN5SyK2wN3A95W?=
 =?us-ascii?Q?WIXfHOGDWTf9FQ8LYWLz/D43Pj8oaH+YEANsCYuhPSmO2lqRoKG/ED9md1SW?=
 =?us-ascii?Q?4cK0WuCSRdE3sOr+TkNCFi6LLd0r+8SkEDAuNbWdCZXX64TbAvimjI6fA1Pe?=
 =?us-ascii?Q?DxoiSBXTHhsj5swy/+TsdBrOxBxz8eReD56b/SwGbXHaQT6Je9L7P46SHILI?=
 =?us-ascii?Q?O2ktJJc1xwt9ir5rKrKew8pk9zMIDA67cAxrdawWe5r+8KZsMTgILUz8s9E7?=
 =?us-ascii?Q?sRBEK0KQV0lnDto/mUHGeaJvmPgJBPi6bp7GWZ+tIPAozR1fJ4NHQqKkIniO?=
 =?us-ascii?Q?pMQtzIASbYMpIS0r9HQBewyAzj21M+H2FexjLTwXpEJGgQDCgTc2SKXQ1JCk?=
 =?us-ascii?Q?/rXJzzHXkkOcLpTLk32a5z7JRYVWWNxjalEbb0sf2yqPGnyDIC//Lg6cKb4f?=
 =?us-ascii?Q?ue9oVdUq2XBxKANKOv2e8nv0hCrpyQBKvR9ELVJY7gr3G3x+E/nOK2rZK8r2?=
 =?us-ascii?Q?uSDwRakytjeBJBCIB4MRuqN/ADCBSSjcLGSGmIEy/VlEACfjO4rF+xHW5pk4?=
 =?us-ascii?Q?zpa1QjbN4hwcj3ZkEj/0nrOl5crZuvHttzOhEDc2EWLnrsmYG2leWOTHgLiI?=
 =?us-ascii?Q?9TYDOCbB8wlEUE81p/P4RFDV07sPRSp/13aTVKacrTW47hKfzZUcPCxAIzxe?=
 =?us-ascii?Q?qBEoZ7xLmKeeSvDIU1xNaDC3cX0wYeZrVHK4FSoAeFTo+5BjuWJnpgD7pn+Q?=
 =?us-ascii?Q?kIK58XtGwtF9Rg2KC1G6P2hvHMg=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fb356f-48b5-43d6-cea6-08d9e12bd645
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:27:44.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GegTjgJvyhBK0S5Bc/VzSZ1onhpKUpy2xY10z1TzW9Xqdi3czAVYlkSzqoNbeIW1Ens7BJwxD5CYU833jf7wuRmeSO4TAFAKRXGCrB1AQx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5578
X-Proofpoint-ORIG-GUID: pB-mSBUoJpt1HK4ZT8FjpIc18diLQssQ
X-Proofpoint-GUID: pB-mSBUoJpt1HK4ZT8FjpIc18diLQssQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=619 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to allow SGMII mode to work properly in the GEM driver on the
Xilinx ZynqMP platform.

Changes since v2:
-fixed missing includes in DT binding example
-fixed phy_init and phy_power_on error handling/cleanup, moved
phy_power_on to open rather than probe

Changes since v1:
-changed order of controller reset and PHY init as per suggestion
-switched device reset to be optional
-updated bindings doc patch for switch to YAML

Robert Hancock (3):
  dt-bindings: net: cdns,macb: added generic PHY and reset mappings for
    ZynqMP
  net: macb: Added ZynqMP-specific initialization
  arm64: dts: zynqmp: Added GEM reset definitions

 .../devicetree/bindings/net/cdns,macb.yaml    | 56 +++++++++++++++++++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |  8 +++
 drivers/net/ethernet/cadence/macb.h           |  5 ++
 drivers/net/ethernet/cadence/macb_main.c      | 53 +++++++++++++++++-
 4 files changed, 120 insertions(+), 2 deletions(-)

-- 
2.31.1

