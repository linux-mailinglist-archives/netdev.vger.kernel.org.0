Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55156842A0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfHGCuv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Aug 2019 22:50:51 -0400
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:44458 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbfHGCuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:50:50 -0400
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.147) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Wed,  7 Aug 2019 02:50:31 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 7 Aug 2019 02:49:48 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.72.11) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 7 Aug 2019 02:49:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huc/nwcaRr4lbs5ciZDuWkZ3pzzbampwc1sDftjJLEl4xNHbh76C7vuJoMB8E0mGKS+HryLAs2ccK4h2E72AKenN5Osp42eb1LnWw6oQdLeBeCAZbMFQRBUflfiAHvTJBg6j3kBf1uN8L4/oaAs9pYuJnSU9qVY6vqCxQuo9sFLiewGoD3u0layY1bVBfBQDPThlGMurj+7I2fXDfc4wajRDQEToSRoQLM7aKenSf/nXl2vAmIfGL0kd4robhvs+oN/S0HdYEZOVIL2m+MB1Q4MssB/b2FrBjz6sgzolwoAvIhfHJnWxW8s5NV6HIMiBz15jDYcVZg+3gJuhGBE3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjA0KI7GnF7EgSCPDj+n1ygbaPRbKH9pXsE3/vpt56Y=;
 b=RLnRDZAh7ghnFc+m/PubEJbO32z2ZCxDqHmEFg3Y1diRddz3YO9vMNc5lE6/eDo6lzPy0tNNxreOCie0jLAoug/IN3jvo+LeFarpg/PyVchizBbFuYhwcBfazHKBrkKrjFB0vLf32T2+TxMQvkuEiFEgjEDKh1dIsI8qsazUaMRDpH8Wk5bdFWPepPVnV0N0eCOXcjQflCrL44On3Zgq6ZEc9GMwrUkDNBbHoB3U6eIFpolsZLxj/VBnAsbCB9wOjtjx581ISxAU1Z9//X45GwV5JWwqdWrtx9bwhB7XQ4ZEusfzN87oDLJiEYMVNCZZ3DgHMnI0i4mSssYjlvVgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=suse.com;dmarc=pass action=none header.from=suse.com;dkim=pass
 header.d=suse.com;arc=none
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3169.namprd18.prod.outlook.com (10.255.139.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Wed, 7 Aug 2019 02:49:45 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac%4]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 02:49:45 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Firo Yang <firo.yang@suse.com>
Subject: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
Thread-Topic: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
Thread-Index: AQHVTMrFkDapNm+vukGfNKy6YOsjCg==
Date:   Wed, 7 Aug 2019 02:49:45 +0000
Message-ID: <20190807024917.27682-1-firo.yang@suse.com>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0088.apcprd06.prod.outlook.com
 (2603:1096:3:14::14) To BY5PR18MB3187.namprd18.prod.outlook.com
 (2603:10b6:a03:196::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.4
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e738d238-4c73-4015-f681-08d71ae1e7b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR18MB3169;
x-ms-traffictypediagnostic: BY5PR18MB3169:
x-microsoft-antispam-prvs: <BY5PR18MB3169DB93B12EF9EEC59509C388D40@BY5PR18MB3169.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(199004)(189003)(6116002)(3846002)(25786009)(5640700003)(6436002)(6506007)(386003)(99286004)(54906003)(26005)(478600001)(2906002)(6486002)(68736007)(44832011)(6512007)(107886003)(486006)(2616005)(476003)(186003)(36756003)(53936002)(6916009)(14454004)(102836004)(4326008)(86362001)(66476007)(50226002)(66946007)(66446008)(64756008)(66556008)(52116002)(81166006)(81156014)(1730700003)(8676002)(8936002)(7736002)(14444005)(256004)(5660300002)(305945005)(1076003)(66066001)(2501003)(71200400001)(71190400001)(2351001)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3169;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p8eXH/9hmixvlilwAvX2TpmqCf3nsS/mqFRTOPXapxykJjWFL8VCMrumfVZMg33vUlscJtKMOhiukfwZfUtjCAo0W3LL6o2UG/KGXIeVluSUgxDKTk/rAJ3YvmHewFClgx8WDnpZt89vdT4vOl5VVhmLxZLM7nFBaXUKwuPeSfRwd8h6bZkG/T1B4w34ph9+/lUrdYmnr2Bw817yleRQjmeuWL36H+yTos1bTl4TmbjQdRzzphoKmfGikMJQRAeB18ovgbvWgq9FSXxQ+ABoUzKguME4oMtbV1ULbL2dFkq5jY2jNTVEAaZBUkP06Sl5Rgsslchz/XbVuaWTme0MxUKNm38wx1u4evKhR9Tn6U14XsymekHqUvEYccjwPO8bWiahaW9dTgoIrGCgJtTXzwseN1DomLwI2Iw8NKRu7Ww=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e738d238-4c73-4015-f681-08d71ae1e7b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 02:49:45.6312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: firo.yang@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3169
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
could possibly allocate a page, DMA memory buffer, for the first
fragment which is not suitable for Xen-swiotlb to do DMA operations.
Xen-swiotlb have to internally allocate another page for doing DMA
operations. It requires syncing between those two pages. However,
since commit f3213d932173 ("ixgbe: Update driver to make use of DMA
attributes in Rx path"), the unmap operation is performed with
DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.

To fix this problem, always sync before possibly performing a page
unmap operation.

Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA
attributes in Rx path")
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Firo Yang <firo.yang@suse.com>
---

Changes from v1:
 * Imporved the patch description.
 * Added Reviewed-by: and Fixes: as suggested by Alexander Duyck

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbaf712d6529..200de9838096 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1825,13 +1825,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
 static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
-	/* if the page was released unmap it, else just sync our portion */
-	if (unlikely(IXGBE_CB(skb)->page_released)) {
-		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
-				     ixgbe_rx_pg_size(rx_ring),
-				     DMA_FROM_DEVICE,
-				     IXGBE_RX_DMA_ATTR);
-	} else if (ring_uses_build_skb(rx_ring)) {
+	if (ring_uses_build_skb(rx_ring)) {
 		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
@@ -1848,6 +1842,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 					      skb_frag_size(frag),
 					      DMA_FROM_DEVICE);
 	}
+
+	/* If the page was released, just unmap it. */
+	if (unlikely(IXGBE_CB(skb)->page_released)) {
+		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
+				     ixgbe_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE,
+				     IXGBE_RX_DMA_ATTR);
+	}
 }
 
 /**
-- 
2.16.4

