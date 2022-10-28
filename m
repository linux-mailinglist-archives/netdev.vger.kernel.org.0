Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066F8611C00
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 22:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJ1U55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 16:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ1U5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 16:57:43 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021025.outbound.protection.outlook.com [52.101.52.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4C67061;
        Fri, 28 Oct 2022 13:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0pbNul/QEHC7RX5pyWBB6bXJva1B2nR0uSZ+/Gzv1v1lcmUPMjgCMuqdCvJTLfVteNV6z+IBWuY+7A0p3Y5+pTZ5Cf4/YjbZLvvB86iY30s5isXh7u/kJGFN+V5MUWlfr9QF6H5QAK+cavuc9ns9EPSKx5GgdeL1qj7dZ4ZQD/DoGXvrwZYOaD8lxCKJgMwth8MZE+tYyQ+LoKUCHc3iXIIDfPYCpWznf1avu2jYzkNPZOW31JlUTqwsuUzxQcSemxV2z4KwDBJu0SYG/Dn9L4AXucqa35VsE4uYmWlKgBiWDfUxRTUAkgOfUN/T0ewNiLgM9hhbKOfMxdLmsFKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZThoebMZbhM4eHlZN+9VDH81cPFQo81k6w8AV9KlOs=;
 b=G4iSPzPhPbtmh8wUEnSoS8Xld5AzT2tas2SX787dzmxLBRcLzWpsv+54LmyLnIrQuGRBvRqDKLRVVKAU/ZtANu87kKbTEKzCf4WLML+MtigovGosJvmNbJbFktoKjlALo8rGkm3AALHONu7/chEvcbISrRSKadbnyHUy48fyk5IMF3h6LprM2knMz+jS2C3MxENKduA+VK66e5UiXn+hQVcHntsMoNLVXgw2ZHJJelvsXz8bzXR1NGXBvoi/KPXzQkKnT3cDpN6UzEfoKtAQTfHLSta5FiWaJa2cymXDJZjE6aPI3kemv1tK84M4f/fvUaMYQu5EP4VThsV6655opQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZThoebMZbhM4eHlZN+9VDH81cPFQo81k6w8AV9KlOs=;
 b=ElkzgMMuf/1GF0CmD6vNg1/wqCrgLJERFMBelB+kKfq8U14478n/71s+zwphr+umoy6Ri5ba/f6Uxvtv+pQHztRYdw6/PnubpEExwJhQYoKRxDyY8/kVWvPDwyFT8jycJ4oIm7lruBbkdrJxIHM5epJTwvipp/4fE8KSVRcIMv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH0PR21MB1912.namprd21.prod.outlook.com
 (2603:10b6:510:d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Fri, 28 Oct
 2022 20:57:31 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%8]) with mapi id 15.20.5791.010; Fri, 28 Oct 2022
 20:57:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 1/2] vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
Date:   Fri, 28 Oct 2022 13:56:45 -0700
Message-Id: <20221028205646.28084-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221028205646.28084-1-decui@microsoft.com>
References: <20221028205646.28084-1-decui@microsoft.com>
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH0PR21MB1912:EE_
X-MS-Office365-Filtering-Correlation-Id: d40166e8-f677-43e1-383a-08dab92707a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvQtBA4HfMln2+/7fTiMuTXNR0sWS1iFu635AzLchWZDd4GCxTC0z+3CTXPD/NBrF81P9HEi9GzIhU+DdWKE60+r6Kth3+n0XTyIcCDRhUnhlbI9u9y2GE9YCS6ZuuHDtCvjMcUyR0nUFLSoiXTCyTv4Fd0vyAlPPPSHvwH0ymjHqA/IUveHtNoVMRFswnpXawsUxJfNTnYRkvfy8r/1UnFwLsgcHEkviIKt4YpFZJOxwGLi22qXBlnOHmchKyF/2ycH7Do2U4YBChxfkszBEVuX0ZpdWwGrp2FJ392nRrisWnICyU+TQ9sIFokqHeV+K032qA3sMIH7i2UFLzgUNZgw/uP4HcGRRTRE/TT+XYhtXTWhD4czkBW4dluEbg16DE+PlM2htyWkOLIvsLBN+feaqme6ovtKu3uOJlO6OaE4yestKPFGTFNwinXUpsymiJFz4LYnhQGljM+Nd8EtlDTb15Lp07HTbXu+dLOWLI8C9AKo8MDFNbfrQmgjIjwXqJ0UAYpTXzhGPPonJdMP9R1eXHRyc19RyRVeZ1DIJEFdTKteddtVSYhcVF2hMRC6cahrCE4oc1TSHUwBgUV0dQF726pWPtzO6cIezpsRHDHBGOdgjuDWi+GhceThCwJTecCTwI95hF7ivmsR3Jsb0KAb+SXC6tSkg1iwkJA/zui2crjTrAsmJVBoSmxeZOtG7g3/WuMuDQZuCIPNtVMHLEWPjFzqEPirrFaPF85LrmtTIB3rRZLG94nx8ZBVxCbM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(6666004)(107886003)(52116002)(6506007)(82950400001)(8676002)(4326008)(7416002)(2906002)(3450700001)(66556008)(5660300002)(82960400001)(38100700002)(1076003)(41300700001)(86362001)(6512007)(66476007)(66946007)(316002)(36756003)(2616005)(186003)(83380400001)(6486002)(10290500003)(4744005)(478600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKLr3U88AvUzH6dbtJerAJAw0dCuyDKUYdUlqIqqQGaqnEQrrD7RVSc/WomP?=
 =?us-ascii?Q?tLMjDEOgCFteuSq21GcotQKUWIUQTkT/MTuaQRZv96qVDeQEgLYL0etcB6rL?=
 =?us-ascii?Q?2mVSwSBlVB9b9bRkJPewVsnoVzOiYjBSanZjCPvxtuOO64KZGAZ9P135iK+Q?=
 =?us-ascii?Q?gM5hAtn8P8eiC1Jzc/C2rMY8JLg2es2yOF7bs6WOYpIVwSHSV0xtgji0zq9O?=
 =?us-ascii?Q?sq0LgPoX731/OmaP0h0tR+ZIF/R1aA26R+3yzyRrlpnckqQvwNtgwIn1bskP?=
 =?us-ascii?Q?htV6cqcpaUJNFigoQNS8fplBVT/QqnzbNtQ8iQRggwy1Z38SlkjKOJhBmS5D?=
 =?us-ascii?Q?m+TYgHMMH3Krp3lpX3J4hW4gbwfkyJF6MxzqGC02DQKu3Nc6dz/y6YUyDoUr?=
 =?us-ascii?Q?pprN1s0JwbbhJ1U/zFOSnjCAA5S14mO9UniQUyHjmLzTX5GhKsd1L4D9aPjX?=
 =?us-ascii?Q?J1NvafHItASMGw1AkY1QrtVW+70Kf9JmqGeT8Ad2qJUfNHVRJAX6c+JRcxdV?=
 =?us-ascii?Q?QyKiuWiHDNo1FlREz6zHPj1l7IVfwEjG0uPl5uDMhEc+RTLrxJQQKXSxfW5Y?=
 =?us-ascii?Q?BjUd1lwiw4q0Q4YsUIbNQyu71mdehix4BE/YypRZ/jqDloc1ha1U8wJsIWo6?=
 =?us-ascii?Q?E7VoxDuXf9OcHTJUuek+eNDlC93VHae5D+f02p9RuL/kU/lWlBpJCKrzNiRX?=
 =?us-ascii?Q?sD6yrrbdjlSUJLSw0wHNhUcIcMntpjCSva0+9HRKQ2Vze8Ob2a5yrU4yat2o?=
 =?us-ascii?Q?lMHQZqOHto1YEWXQ+xeRE+Flelg1IuZGzdJn9PWZRMAlin7uY43aQMKe0TRM?=
 =?us-ascii?Q?bGVGhzlTRnUZwUY2Nt8pCRkurbdMpWlqyCFH9moBB1SYfA0N2qvzIol1f123?=
 =?us-ascii?Q?CehtUPgARRQzakJPaTAYEodSHst5xvBWdAPYr1vCksAphWY8dq1pM20iV35b?=
 =?us-ascii?Q?DSjUJDeEpuvRG6h41XPYZ4G6pEHrv3vLTGEK+8UbbMgPZlxJadEoyi07jwsp?=
 =?us-ascii?Q?0G/xqQkEz4sjMbN8MWjVWX1it7JpEssm8Jl1TSESuOIC0jhgaqHdbNIL0z+f?=
 =?us-ascii?Q?gdqZlBcBkOhOnQivGFTdJuKYE0mGXgT3MAnL60K/Zki8FYB74s2xNPvOm9ZC?=
 =?us-ascii?Q?wbQzeeyaL4iu9k2GOP+mRp3QmI/aRThQ4Lws7S0pxv+T+WiObG9pubMgo1jy?=
 =?us-ascii?Q?M1xDqt0P19KZ8UMdyZ+gJ3ueokx7PIgw2110OQ+WGFSBsIkH2lPQYnQobr5U?=
 =?us-ascii?Q?YUv4eajGbg1a85xXx/Ewv5O8xzpS9j6HD+JgcHzSkeUNvteyFa86BPgIE+A8?=
 =?us-ascii?Q?RmrdyEj/coYh8j1NouSRihbiSsnlAiwywaktopj7IyC7gk+UilkP7rEXu+1e?=
 =?us-ascii?Q?t8ZbwWj0CgFesOJdX+nCE+9ivCeMleLivm2SgZEw0AN1RdMEVtqZv3a+NUpM?=
 =?us-ascii?Q?rj9hc8CBufUNyuArVDPI8vlgUwqY82xA2ITpA549QTbnsqorPUN3phE9Xf42?=
 =?us-ascii?Q?upj9XcuQA64rnLQYO73tYYx1DBUNeoBHkx6jsAgk6uiGZrdLeBekUtDNLtV3?=
 =?us-ascii?Q?UXbvL++5uUNH17cAjAASt8+48ntxBUp73qQ4/o1Tzh14Tp+Tc6J7aVb0w4W7?=
 =?us-ascii?Q?5MjWzHVZLWMJdDYjUBfhCLkjVZTThCo2rbChytyyGpqx?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40166e8-f677-43e1-383a-08dab92707a3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:57:31.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsiQdR/LfoAn4kT1sKjIKfDa9PGNVGk1wkX6vuVXOHWZI154hjOBG5nYEzMYYu9tr4oESMHXActN9u9XMOcbsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1912
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused variable introduced by 19c1b90e1979.

Fixes: 19c1b90e1979 ("af_vsock: separate receive data loop")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 net/vmw_vsock/af_vsock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ee418701cdee..d258fd43092e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2092,8 +2092,6 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	const struct vsock_transport *transport;
 	int err;
 
-	DEFINE_WAIT(wait);
-
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
 	err = 0;
-- 
2.25.1

