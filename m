Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A7C6F30DB
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjEAM16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjEAM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:27:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2114.outbound.protection.outlook.com [40.107.244.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09641A6;
        Mon,  1 May 2023 05:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wt5/3zSL/rZ5YXcixUI3TWIp4ylJgxUbrPy1Fqj1hq3rcgwxhLlmrxj0ueEB+CxxiB3TPoCvZpr2JyZlsqonchjTE9XDL3jxGdiySLZifEMmSEWxrT6bUuMutsOtw0wLnQhpJWIqvnIOnM7TX/1H1K55Czvgvc5UUwCAX4cb1/aHE9XmNXIB/Zm/D1y609W2z4DyVrAhO5LJWWoV0RyKjcPTWlSX5UU1+z0bsCAmlb8eapB8hda21Ns9yHygFs1uU7uEEkEy2bYWq9PUHazopuwru3ehq9stdIFZ+Atj8pqfAsbsFvr+G0eJBry2djF3m8t6cF5v9GLbvTClVf+xbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49enj4bGHVDbPILFVd4Kk2wFJyZsPnu/YCWf0MQVgnE=;
 b=bGTiQYLR9CmHZEZIcHaRXiGTrjwfUTIH/mzwWRCPwVt6GPz2Wx9V4uL6VssonVnHmHls1zBmjMO210n228GvS3Wtg61ZTOYUqqkNx1P0Cxh0PzMTHisP1VihiGAq5TVFRnu01cOE9aeCAvIFKMdASs5W5m2oF/Sjj1jkmbVcS32tXD5XhbrUCNFHt0OGmG+kn06vZFASetKB5QtWT5ZMmsnt1etedSOV8pYjOhYqnJqOwqYNd81mdyz9YZYKPTEc596tePSollbXuh6KAECPO9s6T17SIqK3YHJLnE8aHtRLOS/3KXZMekfQv1CBiZwZmlAZWa7cVTLxAO4XRTE2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49enj4bGHVDbPILFVd4Kk2wFJyZsPnu/YCWf0MQVgnE=;
 b=hOiLsXK/R0OXe/KQHotwhlF/GyyXX99/kst59mgGPiXfvdPZpvUPvQmtCJP6vj67tRxO4JlHtdaLVkyHNO4W5hYPjJxEFNnk00TEVpg0uLC8fe3Zb/S8xJzBPxqMJa6VJy9hMSUT+RHc8mIrhCj38ubaj++ouAC14k2FrwOeY2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4147.namprd13.prod.outlook.com (2603:10b6:5:2a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 12:27:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 12:27:50 +0000
Date:   Mon, 1 May 2023 14:27:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net v1 1/2] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <ZE+wPrqKatZY/zDM@corigine.com>
References: <20230428223712.67499-1-feliu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428223712.67499-1-feliu@nvidia.com>
X-ClientProxiedBy: AM4PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:205:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: e72ee9b1-8f26-4fa3-f03a-08db4a3f7a94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EP3YDh6/oCTJYj804PI06fxANcLVZEpX6bivbi7jj9qLCCv4srmqPAgs7S5oTnaOXAxFerLEENQSkKOW9kJtUHA8lDcotzWvEqK6/xbsulv5w6vlXGGwcLJJTEUwLoT3tr/iyvFBlU4oNSH+/4O1LrWO1Lyj5upxTS1MqcDgXJP2w0lb5849CmkePppwpWylMEVETwPsk7SbROPhMtC3g7aW7kcbu6PUBTjtsqsmNwmeaKdxZfPFKasg7Wjf/P9eAKbg9U6GwMTvtF4T9aXN60Zukx2JgMCT24A405u8oOVAkH/ngQgkfjGBTLXchM+81QWxFLZ96CQqUcQfAT1CmtMm+4E6+R1LXAL0oppxeDJ1wK2gEuJTsk9pmC2k3ASIvwoXsBZ4Lm5U+NPK0mMlv6bhwfwOm57x0qgZ6J4B5oiRcn4zHtXeX3N2H2e64i6B9VfzpK4a4W1ruIFU6l5o1MCJ8kcKTK3GCthUXnqI/x22EMeIu83GGR71vOVWmWC+IltiUlQRrAJC6g3nGWK4wOT+qTWL21eg6W7gRVGW+CcQ77ZRbf4fucuWbFt9AxoQ2gW1Wx+WSDM6FbK9j31rHM9UxJ+8p4zeEbFJTOM95M0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39830400003)(451199021)(2616005)(186003)(6506007)(478600001)(6512007)(6486002)(6666004)(4744005)(44832011)(2906002)(54906003)(7416002)(8676002)(86362001)(8936002)(5660300002)(38100700002)(36756003)(66476007)(66946007)(66556008)(41300700001)(6916009)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WmgvXwNpIF9JY9aGlgn9lAFR0g+03dq41NWo3YW37yAfQdSjoF5QAyHLJ/hx?=
 =?us-ascii?Q?lAn2DYVEPTBD4RYosk/SK8luEJYR71mKu2l0RABU0wpObl/yJKKs323juzgx?=
 =?us-ascii?Q?yg14aV65b9BOIyta/Cio1dpuCSwaoANmUmq2g6dRlQuyx437egBano0BlqMO?=
 =?us-ascii?Q?DT3exFgddg/r1+HrqRygGOGcPb/r28nYF/9qkfiSEtTToyEbqIP13khmVMZz?=
 =?us-ascii?Q?K3zLgEsKxxHu3VpNL8F+lVaMsSNbeY6nqKmLY0B2+r4vmGu/ufcci/X8KsgR?=
 =?us-ascii?Q?4iBGVlf0tTSip8MmvLISWeB/gw2WlIdchwsc3+XnfOtPGPRf8iIxBGrZ2BDU?=
 =?us-ascii?Q?cT7Pjpk7OGxW7BXWAkPOsaaTwCvB/VHkXOhcHNNkW5i88TQkfIFxQO/j1Ehz?=
 =?us-ascii?Q?7CC/+WeRKdHBhr3rb016BIbiqLBqpHuhNdubNviuTfhFFPD3c/B533WmsZ6Z?=
 =?us-ascii?Q?9bBVUXk7Rb3EyelJE6cyn6KKkKn12zxdV1yf2HX6CrvPT6spLtSCQnK55Z2V?=
 =?us-ascii?Q?aBLkdQoXPY6rE2ewDJDdBhkykNdj8voLOs/QvT2kCgyy9MZeD6pmnefgswNu?=
 =?us-ascii?Q?JO+E79O5+guusu03k4ib5Kji3FeNlG6IcQ8oRECdul8GV96OXFJCBAvkcsZE?=
 =?us-ascii?Q?5l38/Pem45jtuvyOl+5v5ewZs+LiGoXeKiKYflOlpVFoB55nGSYkoFIJj2wA?=
 =?us-ascii?Q?PAwjSmdwv52zBTQEawGEf3sqnDOIRkayhKJt00DoBgNfgoci/wxOUdrFVkCh?=
 =?us-ascii?Q?3Ix84puYF2rdasPJysHWL4HWPRVHFQJbE84ydOxeM7DUbWMXynKtEicJ8oAK?=
 =?us-ascii?Q?rA/rtrMw1tosHCU7oqY+7GhlJG2+63ho8xmZJiCIZkIZODoBFMYfk+BnqJEs?=
 =?us-ascii?Q?tJ9jC2Q32KFeCLS424KDFV2lDeuxXKIndYDUF0U/3Dlq3apOyKtt/wi9i7Aq?=
 =?us-ascii?Q?Mi+2/feqMwxA/u8y0YO4g1odL3x6yVbUsi36s3WgkUDh8u9fT/uKKmh7MZ1y?=
 =?us-ascii?Q?aoZB8ERUrbXkCVl9oevdMbuAMaXndsORDi87OLvrnp8p3AZY1pOoiEt7zK/z?=
 =?us-ascii?Q?JnGjmN2IfrpytZiRrJY7p6xmp0a34Ia8wv3yUbRcqgCYJsS+D/od8F/HINGq?=
 =?us-ascii?Q?b1mHdJTcDss5BJCRnYnRNV1PlzRvzIut+QNlwUCqqWcWNir5gqXXFU1Lf2lk?=
 =?us-ascii?Q?Qh88cnIYDuYJ5PrOMEJwUQ95p7miGqbXGZe6kNOlob/cYjjNmfpu+RzqxHkr?=
 =?us-ascii?Q?VLGr3D6yllD0dqSk6VMI/4twqfnBHZknCW0Ni5Qv/+XYobEWMiSaWmZABu3h?=
 =?us-ascii?Q?jaIfmscCFFs86sdPKGID+joHOWuaQiqaWNyH/QSXeOaTqj0LiaBIeJaxsUge?=
 =?us-ascii?Q?bE0QWYLM+YBstJW05gyKDHqZaaXGorZeGe1eqGsYWqaLOQP/a1W5VVUUw7Ls?=
 =?us-ascii?Q?gcSD8aQ1FFB7aFGMPHdI2N8ZLc1MD6OJ4eoNGk1CNR0MLZzE0f7AmJG/Vh7/?=
 =?us-ascii?Q?9rClWY04oqUaEYZBcuNURLfWp3nAb0S+hK4t34cqDrRCfExTD++SE6bdA9s8?=
 =?us-ascii?Q?80CXpWDcU57cwWBtx7UpsMqoTz5c04tnhbadWimrQDb14vn2UWuSscppv5T6?=
 =?us-ascii?Q?Omow7wtuXtOhLPp42arqOTkxdzQgydx6Xgb+397/+b8ZJ7MllrgqDtoDNxad?=
 =?us-ascii?Q?3WOC+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72ee9b1-8f26-4fa3-f03a-08db4a3f7a94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 12:27:50.7298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmQNI0s8yxPWySxY1p0SNqd6HNm0u8sN58LSyxd5tAq2tFXIxkd6AXjblfSF6BXlXCOQh5ZbTItJzGPvyrix1h/12IvJ3/Lky0Aau40guyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4147
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 06:37:12PM -0400, Feng Liu wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
> 
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

