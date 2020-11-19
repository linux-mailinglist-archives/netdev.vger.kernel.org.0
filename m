Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20AE2B8CC3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgKSIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:03:06 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:54310 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgKSIDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:03:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107]) by mx2.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 08:02:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYEPT+1A14hxnC/4GZWdz0vHOgFKUTHdJpzssBWZX6xqAuF4ZM+NMh8lOr2KPj0Ygd4mCAjJKdbQBwXy7lLXV4cCaGoRvSIFuw+CR3GY7PtnjXJfR5h0ygWGqO7AfnwMUPqogYeQxXeiMUXw670voMAYAfEKkQSenc2iEGf9DSShF9rcx8h3TY4f/jfGM7Zzk5zpX2y2GKrS0+zwcVZYSfT1Z0IHIqGmcjkBt+LItu5R2djLk3gbJu7liGhAwhIy8jsHU1eQ+QooeY/8AKcxfGEW9275nqliO5CaNXAaYsSqohgIoVrTVGR2bC4f2oVbFM7vCCX07AeMMPDYdVLgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=cd5kxUmUj5N+x5coFd3Z6M0WFpXQF33/DLDy6VNPGUWVfTYJR/G2RcYtbQtfwJQfhidwKo+dmO0LBtWs89K78JREFixHnYVDY2H3wNS5cuvheADo0mCAhyuv0i3SwLY2j0bnNXDIc3RiPRfY9Vh+jxG+c9+Vmp280Dw8VosZ4L2It8CUl0YkfAR6WXFI205iUeiGBbN81RyebWm7sp6TzIgNen1l9+mK1ECm/KvkoX7aKybbzcbMt6UHGN9lHk4Pv5QfBO2fsLNMDABx7dynkYOeQfhpZTNLripFROBKurkudlv5VotFk03auHyo/ktmif283480v7wkM9bCBJQYCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=IvDUlNcRozWKt0Tp1gGSmtnAm7znFL0yXKP5euXgcQXZtfxtOXFXcGVmlHJ8xLmaj2dsXbPT0SHQshCuZ+T/WEmyERggMr13OLwspH6WtC5/sH6oUmEsHkO6QYoLYwge84FW0X9HoH+oCy+IldVGvSdfc83EB6NuvWjCZmqlzNA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4399.namprd10.prod.outlook.com (2603:10b6:208:1d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 08:02:52 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 08:02:52 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v9 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Thu, 19 Nov 2020 18:02:27 +1000
Message-Id: <e4c8097e78a3277a7ac90d6a4899b110657b13bc.1605684865.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605684865.git.pavana.sharma@digi.com>
References: <cover.1605684865.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SYAPR01CA0046.ausprd01.prod.outlook.com (2603:10c6:1:1::34)
 To MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SYAPR01CA0046.ausprd01.prod.outlook.com (2603:10c6:1:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 08:02:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e0eb68a-2210-4781-4fbf-08d88c61836f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4399C11D327C6F72C00417F195E00@MN2PR10MB4399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xepD4bEtHKEwsuhyakMgleAZY9uOIP7pDVn9CmKuYoqhlwfdpEONbEuJ5/vGlqFi5AtFKqSshrDRXRTe1YSJpJ6fH5NpP+7hBrmgiuL+5vXyhV+hXn5PJoJY+BKd7mW28FzX/+s7H3GoJ3OgOt45iUGi/9HF56hunxRUDnJgycGuvwew+lDpc/9OqvCyGaZy+E/eyU+XhYpY/Qy0S/NNORmjFyIMQdZ4Sjf4ZMmpe5m+B7dOp4KznBa/15T4s0aPXnEpI0B7yqg5Aa1pWzoLK2IXj5NWN33RlKrjx3h67FklJbgESyZRh4lLtUrsVWAamCn9mIU2BWbJjCmYt/3WY3wiCwdLSa15acMXS+0hbdKpxEqrKa0hCkaAb7UnPzr4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39850400004)(7416002)(6486002)(956004)(8676002)(44832011)(26005)(86362001)(6506007)(8936002)(6512007)(6916009)(36756003)(52116002)(478600001)(16526019)(66476007)(66556008)(2906002)(316002)(5660300002)(2616005)(4744005)(186003)(4326008)(6666004)(69590400008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: d7PbkK9esf3C+K9wRSwHs90hrFpw5aqNumwRiXajKIMBrOCXZ9iJSN/z+gQUHJy0+CC4AgnH28XLt+9zNzu+F4C6cYwLiJlNSA3rZWaJLBN9PWJ2bCNOrLiJggjCv/Qm9cPY+dupQQczlDrUxRYxmy1+uxLvpkFJTmrpwwCQzpVjadA/OtZj93v99vn6ynyp01eYQyFisFpQcspgmpRO6fIVwd9nHxJ8Ay4lCl7XKVxVJwmnDINnuMuZh7qowYOXFqRXFW40EsO0U9nITJi/AnisDaTsRfLJfw9X89NTeC74ZmIvJSpRS/QaGRZkx+TTX4FP8uvrE+/db89r2dD575BzOTzyoU3yy7iJ8Wc8GMmu6QbLuXJFTCMHxXntQE1YVSW3ctY3O3KwSp8xNiGwEVtK24aWB0qRkzrdMhYjgcsHqBNNr6mP3zn9GzJ7sb66Vo/q3GlgCzhAjXsM/B1xuMVZmJIQcQYIGaKUW6O4nq277MYjHBDx1uNm9P0+PpgHpLOy9+Ka20NkMVSxLdpyWVuggiFj/EqV+pPnby20Pi0Jcm1CvGsT9vom5ey2GBVcflySX5/ytqHywImC8qKeoGRljR26jIyGYzN9wuD2/7Q8TXT/T1849EFjAnKKPubWQUVbXT0mD3zZeIhcCpcIoKYTfh/JfzQvaDaaBdZVitT39eLrbRY+TvzC+5Ft9nQsWjO/oltpARqvYEFGhtHrrBVOvhYUG3xmIPYyllSf1dlE4zG0GOTHWrSWyYthbYiCjI8CnPGwVUcIytXbNDzXkMDCuNE+S0arzX49bkGFTYB2rXDO6bdHTAfCL4LS7dphqGIULqZbKri+GuQenVInjBAsEpLWeP7VAlTpMIcdW9owLyzEKQiDooGq9KCjrlEs6qpcKAjfgT7bXe2ASVeXyQ==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0eb68a-2210-4781-4fbf-08d88c61836f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 08:02:52.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbGYyVchib7TX8VJeVdleglD/o+dlJzzc6RghwLIgKHp2J+dT+++XUm37QhK/LzY5MVoAacY0AD7wgrRX/FZOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4399
X-BESS-ID: 1605772974-893002-12923-54978-1
X-BESS-VER: 2019.1_20201118.2036
X-BESS-Apparent-Source-IP: 104.47.58.107
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228292 [from 
        cloudscan12-147.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..aa6ae7851de9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,8 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      # 5GBASE-R
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

