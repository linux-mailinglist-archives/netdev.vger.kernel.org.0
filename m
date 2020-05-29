Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5F1E7CFA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgE2MRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:17:34 -0400
Received: from mail-eopbgr80128.outbound.protection.outlook.com ([40.107.8.128]:8286
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgE2MRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 08:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L333geKGDQ6o4dqzfRjsoCBZEede3UZZMMh1SStezjz5T3wrLQKqgeP9FymbmGFJmqid3+dziltghYQwbY31mIbZ1/O4XiqE1XCBni2iKQ2B2B/AI0UOfxdXkddF/VpYi+CiRv7E6e0d4TR65aGnAKS8UlqGZ3NJ9aurI4M5T0Es3JDmKuhrjgefGGiDRnBvYfpMulY0U8wOEU5MZNNRRwIzvJNbVG3ZExxSGc+pDZ1MZ+m9kTlEVl2/M1xZ3Dky5QHPzLwNLqKO+FwM/lGyNLb2VWNDtPWv2PFFyj1APwz4vTmTDRYUj3TNecXSbshXvc5SXR20NCgFenrxupyBMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00hQXON5WaBG8O5ZKPii4pmn/B4oStQV/XCn1hsAeuc=;
 b=ajO0qeDczrVuHpbp5CqFVP4JrKIqB9YgRaSI6YvWAmvW+1lizr+8RX6Tw6E5x43wLaAwDG1H7SFA1ccMsKWqS+iFt3iAsY3zd1DzBWn7ahOhwrxu9gXQmUOlyTNjsjGqW+mGXTrh41OQ6cjOgsVlyP0bfHu3B6sh4uj9K+Eni37IpD7Ep1zOm7gtUhQxzJK7dbBGKs5HbRO/yOpK88Nt0LbTtP8i2Op2TT+YlupOEU6GG2HPPxB4ZUsP9gOwMeyN5ri8w/Su6XOcNTz5XRV+QkDxQ32sEw6YPD1hxe7KR7D8apY7tsQTqZ1erQYdThsZb0dUeFoHbHGVeYDerijzbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00hQXON5WaBG8O5ZKPii4pmn/B4oStQV/XCn1hsAeuc=;
 b=odE4BPCZ7PPnwmx8Zs4yXNq1gxJktweM6H7bIOnkougzfWhrXo0Td8yuEjaMJlDnZHbzPe1QRA6WmHaG+jcJqXb0CfzglRy+FBAM/xR8tJNw2oYz51sXao1REim6ZnNQgEDAP1z9jScY5pxxeCrpgFygcT53UySD0Pbhi5YLIQ4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB6132.eurprd07.prod.outlook.com (2603:10a6:208:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.13; Fri, 29 May
 2020 12:17:29 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::55f1:90c6:a5ae:2c82%4]) with mapi id 15.20.3066.007; Fri, 29 May 2020
 12:17:29 +0000
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] net: octeon: mgmt: Repair filling of RX ring
Date:   Fri, 29 May 2020 14:17:10 +0200
Message-Id: <20200529121710.548394-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR08CA0064.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::35) To AM0PR07MB3937.eurprd07.prod.outlook.com
 (2603:10a6:208:4c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.2.28) by HE1PR08CA0064.eurprd08.prod.outlook.com (2603:10a6:7:2a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 12:17:28 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [131.228.2.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc4b714e-ec12-4e94-b7e7-08d803ca41d3
X-MS-TrafficTypeDiagnostic: AM0PR07MB6132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR07MB6132A1E4E58F428DF90E1E73888F0@AM0PR07MB6132.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJVyeJoVgazbItgWQovp9AE7ycbHJdzVKmc6v1DIT8wYI2lg43jGounsJyCRntgHgh4oxBVHkBjrLS93mKYHuQOy5gkL6RdnSOUgEucquc8zCtggEudwpw+clpA4GEHWefvgJakXUJKS4vANYaNEAD79jgiXR2FYDzpTsllp8zXHCv9VtYOSreOBLRqkz6pFtf07YisBrzU7W01lZbjLMd/9Ac3NlDWPsCYJ+l8GNOmnVHefwNDraxL4x6q+t3YzcOIl/lYz/PEauVFddeW3sc06zg/ylDoPNkd4HjQmsFmSB4HA2IU0cM4Qdk+4wK13F88BjJ99M7FzioUPx/qB5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(6916009)(52116002)(2906002)(26005)(16526019)(186003)(66946007)(2616005)(4326008)(8936002)(36756003)(83380400001)(956004)(66476007)(8676002)(6512007)(316002)(66556008)(478600001)(5660300002)(86362001)(6666004)(54906003)(6486002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ayGFACE5bBnF0z3T75JMVP5Sfoykl/ZJtuhFKgY28v8Lb7nXV1nSnV/GLfQcOlwbxvvnY8tn87GlLWYAPGkmJx1GXvPV6B88stOZLGj2kyEiHi3jZ2ofhPIQZpuJrmj3RQwoxiT/P9IiiVCKJSIDq9xN1IMa1zQ2PIK5fldDaCUBfkyKg+9DD6WcOJoHzoCAVAZewj1N4nTSc1LG2k39yWVUHvXx2SJwGHAmk+ECUlYTmTM7d1KziTupqewIlLUTkTtFt1PhKVPRDgQLM4nz5T8ljTrsvQeKKBby5+kDbn1e/B0JwsMKDOS2hdSMR89I59KynIGK0S9nkjBF8brzH2LH4GfbWFGaazX5+58gnHT/jF8zK3Leet1P1gH/aWPxavNwVeIgtKQJeyNu9Qf2LfPuF1sei75gJ7DL/pvZhtEYbWZjsV+KBt88QGAByq4dHrVxL/NsJDSEerHBfakcD83yEeZxm6Xk1Uvz+pF7HRg=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4b714e-ec12-4e94-b7e7-08d803ca41d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 12:17:29.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPvqt9MEnHXSGVGVHxKt5Qul4LwGbIfXEM/9HuA226JX6v0Kr8OMlkIIaHHwIajklsgqIdX8Cegm1yDRV8qy5/F4wX0upCGILfcs45vfVY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

The removal of mips_swiotlb_ops exposed a problem in octeon_mgmt Ethernet
driver. mips_swiotlb_ops had an mb() after most of the operations and the
removal of the ops had broken the receive functionality of the driver.
My code inspection has shown no other places except
octeon_mgmt_rx_fill_ring() where an explicit barrier would be obviously
missing. The latter function however has to make sure that "ringing the
bell" doesn't happen before RX ring entry is really written.

The patch has been successfully tested on Octeon II.

Fixes: a999933db9ed ("MIPS: remove mips_swiotlb_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 07b960e..79c110a 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -235,6 +235,11 @@ static void octeon_mgmt_rx_fill_ring(struct net_device *netdev)
 
 		/* Put it in the ring.  */
 		p->rx_ring[p->rx_next_fill] = re.d64;
+		/* Make sure there is no reorder of filling the ring and ringing
+		 * the bell
+		 */
+		wmb();
+
 		dma_sync_single_for_device(p->dev, p->rx_ring_handle,
 					   ring_size_to_bytes(OCTEON_MGMT_RX_RING_SIZE),
 					   DMA_BIDIRECTIONAL);
-- 
2.10.2

