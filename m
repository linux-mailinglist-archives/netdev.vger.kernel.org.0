Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6016407EB
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiLBNrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBNrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:47:11 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2124.outbound.protection.outlook.com [40.107.223.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1F0D3DEB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNKqlqp48rXoB2wnrjhtYHzSBUz1x73P2Mopy8VnYWi/OMDfcA/T731DbLhW0XvxHfCgYOAsqivvTETaHfHXYJZ9Wz/IRSoBqSsVNk/XXcPI+J7hPzwcgW/zFdcTAdZRMyzeat1FjLtI4ZlWLW6uD6FH/RP6n7eQDwNyGmia1fPekey8q4R0FvvbXTn41GymUi+294Pc/DEZ6EsXc+T7oKjwiu+edfEYkYC48LCo2GLcvngEFnBtHZp0C1Rkgu2UzczbnLWlPuJYgEySuNDAVi/Oj6mHMGZDAj2Wr7GBxdAIoEHelPiZuPi8n3Kv06Sl/kjIDFk5/Ge5peFA3kmPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdXA1gx2N42YEB4TXIvtnVFhRonA5muuUbMjbkcY1lo=;
 b=NJZe3Dm5yKin4rwEtMQmlpRXLJtiRFOpcKDagc29ZXOjQnl3T9lt5G//QcnUO5HbYPt5+LXgGgKsKzDFrZQPOgGol1Ih+cYXc7UPtCMyGRGU+gl/kd2mEo3wIKgsntkuYxBiwkzEPQZ5y7L28eI5vcXzJZ1YXvkfs3onAgXhq2YovNs9u8dK9ebc4XuEk9T69RerRFEUn/O7MRI8b5XVNA7bWPnWaGgJEmZD5bUcvoNmyPJReY7jrMzY05kEwp1Qq7usoj/Kt6HYm1OR1LtwJkuBkNc+mTVKYAy22BSYt0Dn3/TBFcRnm+RbbY6uRWKPlHE3/lx8fT0+KeNkiY9qnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdXA1gx2N42YEB4TXIvtnVFhRonA5muuUbMjbkcY1lo=;
 b=pkEAnjlUl+p3CFx04oXzUajETSR9+KBcrL4mGxGsrcMbcFn5/bcDZkypDwd/9v5Jzez7ghdLxITWkH5mKtWoW1rIPbqF3TwWYA9bcSlU+VvCB2hZNX4tAHfeCsn1GcnirZZRxrBay1CXC7sIX4RHE/4139EivTyuU05HFcZTTng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5913.namprd13.prod.outlook.com (2603:10b6:510:158::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 13:47:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 13:47:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Richard Donkin <richard.donkin@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: correct desc type when header dma len is 4096
Date:   Fri,  2 Dec 2022 14:46:46 +0100
Message-Id: <20221202134646.311108-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec8f545-c7ba-4bb8-3f4b-08dad46bb411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s66kifB8qUfHPBVE2PhtN2Ed3qajqgX+NHdNGtVZ6v79O5zFgItAZZGqGCKAo6agfWx+hqmMWA+89JiTNM5coOPx/nMp0rWtTiYAB5Y+VirGeitXCR5ho5Vih5iqP/0swGKVE3W/spDSLhYYVjS/IPczEZdMf+ip1p3pT2voQ+wlHvvQdmX2jGmKRWYYZRkpUYtPf0KEQWEsWDiP4eJkZ+bHBx76CrqUE3/FzAnUdvnrvvB9kS4Oru6RtDzH4jrZ+VgxJpXrAVEDY01TBEgaSsVHkXt/6eHOAYbbSGWgG+ELY/Hk55y5Km/Yfk/+iDULLxwx18xppfsJE4xTc/fExaJDIsV3ywzZ5lVO1aP2cwr54U//zyQkXGzRBm2hVUH1h0RYrYYj8G6MqAqFL1smgo0RwkY6V0963zkZmVAJgvg/AIc6PFUtJTHblUuI1AG4VN7LfSoc1so0lazWcOm4jk4VRmKazfZ1gBw7FFIdIuFw9NmtyybrNVh6z6RyWDmNYQcodMRpSi3BcR9yiKt8JSlCDIqJaeDvejtsqDSl/zG68QhhW/yALlxXWwAsBQbby9YSJkr9Ui80cJNt/k/MYVOkpChrTAnPZ2qfy+01SdiVeR353IIwNtTpB/qgRh07Nskw5IATJX5hGNlp7VtDBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(136003)(396003)(39840400004)(451199015)(2616005)(2906002)(107886003)(83380400001)(6486002)(66946007)(66476007)(8676002)(66556008)(36756003)(6666004)(6506007)(52116002)(6512007)(478600001)(41300700001)(186003)(5660300002)(8936002)(1076003)(38100700002)(316002)(54906003)(44832011)(110136005)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SStGdnM2SVFKcXBtOUNDTVBvQk9TUk40bWVLRlllcmRUVUZXcHh1a1I2RTdS?=
 =?utf-8?B?R2Z4ZXhEZ1VYN2VZRTdmWjl6ZWx2RUxZTWhsVFRwbVdHejRwM1FLcTU1aVlO?=
 =?utf-8?B?dVJKa0I0U21yd3h4eWJ0dlVtNzVWSWM4aEtuMXE5V3pjNmxKZ0s1aVo4djNJ?=
 =?utf-8?B?NENydWU2QlkyamJEU3JUVXBBVWV2OS94WEF1eXFyZzA0MG9Sak5uSU9QU0hI?=
 =?utf-8?B?aHRXdW9VUG5pRmpKM2NoQnZadEwrcVlaa3pZOXdldnVxZWUyYTMzWEdoVDZq?=
 =?utf-8?B?MFdvVGhyYjg0SVJkbDZYZ2M2WDdvc2Q1YURuSW5jeHdZM21saHUrWWtJZVQ2?=
 =?utf-8?B?TGlBQ2VjU21BbWI5a2N1WTNPQ1NQTGQrN2ZEN3lYUzdkNlRvZ2dZOWdoaUh4?=
 =?utf-8?B?Z0pRNE04dU9VdEhPN0d6NEtNejNwK0ltbFEwYjdNakc2ZTcrYkY2NkxlWkFK?=
 =?utf-8?B?Tm95Ry9UZ29OZnhBdTF2WmwzK1RDOWV4dGNjL3AxOHU2RlEwKzlEb2JYNUNP?=
 =?utf-8?B?RTZLajROZG5rMHMxQTlRelRKbWtHNHJFVlJXT0dvZTVCck1ueHVCRDlhQmF3?=
 =?utf-8?B?UTVKVDdPQlljVDI1elJBWXRVdG53Nzh5UE9wRnFqeGRnc1pRWXZpazMvT2N4?=
 =?utf-8?B?QVpDZEJJK3dMN1NVdVgvemtpNUFPTnpRM1BJRk5FYVp5T3daZ2FXUG9ZaHNR?=
 =?utf-8?B?alNVRTFFVDAweE9OVnU1YUxSeHhiMTRvRnVkNmtMZ3FqYlJhTGJrV3JTejRa?=
 =?utf-8?B?RnZyRmY1dEFOblYxZGw1WTMvdWxJTjVaUEVGY2xXRHlEa1VpMlc0ZVBlWWZq?=
 =?utf-8?B?cS96dUxNc2crSHJRaE1ueEZCeDNhVGZlWGsvYnA3Mm9sSURNNzFkSWlLTk1G?=
 =?utf-8?B?VWplWGtzVStvckJ2b3JqekRRUEtIcVU3V1dVYXJHMEY3RnZHckhPcUNoa2F3?=
 =?utf-8?B?bTR3MG9XckFGcThzNHZxUENKWXpmK0daSUFGT2tkYVJwWUxvdzFCbUhTU3RP?=
 =?utf-8?B?N08zUGM5N2kvWjY2QXVDWTM5ZHBuQ1FvS3VXUlV4anJ6Y0YwMEdDeUdKdUNh?=
 =?utf-8?B?VVNJVGZQUzJFN3R4MTVNUTBFTFd1cjFhMm1FVzlya2lKUDB2cVRUZXdDT0pB?=
 =?utf-8?B?VWZkZDFTRDR1dEgvNEM5bEJCRGpCTzkwNGZaTEE5U2lhbEgxcWRRZHlGa2Jv?=
 =?utf-8?B?ZXJtdThvNlVCQ0dCNzdMYUtMZXA3UlVWKzBZL0ZpeTZybEtMS2FNUnY4MGVh?=
 =?utf-8?B?aUtySVIvVzZsQ0pMbHRkeXZLSFpjdmd3U1RUTFYyRzVTK3dYNHpGWlhiRjJk?=
 =?utf-8?B?SHJ4MWRZS0FxbHEvSDk0VlZPV01LWTNoZVM3eDVJVVNkbXRyakROdk1FL1Ur?=
 =?utf-8?B?TlNia1hEOHEyVUVHWEYxYm1QK3AzMVEwZy9xOWI4cWIxUUFYZWxHaE92VkpV?=
 =?utf-8?B?WlVxM290QjVlQTlZdDhPdUJVNTUrU08wcUVoNW9maVZXdldIL2Zrb1VHMFVo?=
 =?utf-8?B?ckpoWVRCZGR1akFNOVNMeUphMlVPVnBGSDAvNFZxODJ2R0tzWDR4ekVOdE5E?=
 =?utf-8?B?Qm14cXZVaHozWlJHdzVrWnFBaDlLRjlBRzJpOHN4TjFyVDNRRDkydk9EUTJU?=
 =?utf-8?B?czNicEhYVkRhUFdpMEdLWWhHTDZCVVExTXFDMllzT0sydWtaN2h3dnNiaThv?=
 =?utf-8?B?T3p4YzhzN3lKazI2NjlDcjZDTXZrZUpjZFZQNkVXK0JmMENGVDhRUGFraldj?=
 =?utf-8?B?SFBqZVIxT0R5L1ppTnNTNjFxZ01melV3THVkamlkamxlUWxIU2RCZlRaZG1m?=
 =?utf-8?B?eE84bm1pTkN3Lyt0VHFXVGZnR1VDSGJCUWpROE41dllpd1AzbWFhaER3SEFa?=
 =?utf-8?B?ZFhkWFFaRTVwb3hKSzBVZ0R0T3R4YVJONTllNkwzNTV5RGNHR1lCdUlSTGJx?=
 =?utf-8?B?YmhCWUJFMlFpZVBDb1pPQnpBZUVWeTI3aFlhTk53T3pKQU9EUDAzVTNKZWtR?=
 =?utf-8?B?dGlKcGovbWphL0dOZXg1aFhCZWZZZWtURU0vYktPRnJsb0FzR3hVVTJQSmVu?=
 =?utf-8?B?bjEzR08va3ZkRU5Qck54ZGx1WWFia1Y4WlRIdVRWOWlwSCt0SEhpTCtDUTFp?=
 =?utf-8?B?RXFld0xtSmhtVG53VU41alRLV2Y0eURPSFdpR0tpTVNjUjJmdmtZSHBUUG5R?=
 =?utf-8?B?U2pYK2ZWTURlZm9VWlFVYU1PWFU0K0JGRjBRdnBVem05UkZaeDJHTUFhc3g0?=
 =?utf-8?B?eDNVdmY1SG80NzFob0pEdno0dE93PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec8f545-c7ba-4bb8-3f4b-08dad46bb411
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 13:47:07.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63SZVeSbV8oo39HAJcJE8GR/QTMCKLGIwRmNpOU4x8Vn4DC8KdM7Ixm3DkDYfopOD5XyEEOQUX/mpjkBS+S2wN0owdSVhki3btAm+vrNcUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5913
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

When there's only one buffer to dma and its length is 4096, then
only one data descriptor is needed to carry it according to current
descriptor definition. So the descriptor type should be `simple`
instead of `gather`, the latter requires more than one descriptor,
otherwise it'll be dropped by application firmware.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Fixes: d9d950490a0a ("nfp: nfdk: implement xdp tx path for NFDK")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Richard Donkin <richard.donkin@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 2b427d8ccb2f..ccacb6ab6c39 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -282,7 +282,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_len = skb_headlen(skb);
 	if (skb_is_gso(skb))
 		type = NFDK_DESC_TX_TYPE_TSO;
-	else if (!nr_frags && dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	else if (!nr_frags && dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -927,7 +927,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 	dma_len = pkt_len;
 	dma_addr = rxbuf->dma_addr + dma_off;
 
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -1325,7 +1325,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf = &tx_ring->ktxbufs[wr_idx];
 
 	dma_len = skb_headlen(skb);
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
-- 
2.30.2

