Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948F76CC268
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjC1OpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjC1OpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:45:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2095.outbound.protection.outlook.com [40.107.223.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84E7D318;
        Tue, 28 Mar 2023 07:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIx121nfRLJXRXiuwqfSZVWgBX25DZW9xwbeBDiBodu5cO1USZfCorHfoTVrfp6x6ISIc7B7QazI4nnILZ0ZAbBNmIv4FoouYhoGNgDlfwMuPIFF3ziTsWwDfs9OKhXbQEqsdmf4VzoPW8NAHcVz1FjXVlqqkc/BtVz64UDD683dbJCezsQHI2ilB6fx9MMSdJGCetd3yRlwBrX/WTit6zZaUZQ1MLBpHdcSCBDjlKKTd5qS+yd2SgszsU4vjntQGIXTqzRyw+XeNJ83Zg+rgDgXknQhf65DjgS5p3qESZHLgjzU3q52jsJqFy257JUw4DmeOyhZ0euQye5KohnSjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2tfz8Rxhh7gs1pW+GfvoQv+4o1nUghp9xk0EsyJayY=;
 b=ZW5Nv2bv4qXqWvPvS4ivr1oPRe9KukSbQ8cfyPdhIP5yprwA6iiQ1ZL+9FwFj6lNdQaNBYzbrCCg1soD1UYZYR775lM6NgLkDJcjjip/8pWO53VstxTxt5yO+XvLJj3f/svi9uj0XU2L+dCMyPlmVeu5f2KuOOO3/VoSm8SjmOBrmkBhgDVStsZejWe6yKuovlXSmS7ZqnrG6QxMyJ8yqlxfiBY7jMdxmHzX1Gst88+yi4kMl2TE6gvxV06odB1fI6zSAUO0Y+D6JjYyD+vMsq/u/sibQFvovEs7esFv6vGeaMK5NxVOVHNGQd4NMPHjguuRo0DMvkko4/i3E0G2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2tfz8Rxhh7gs1pW+GfvoQv+4o1nUghp9xk0EsyJayY=;
 b=K4dbD+oCAmgR5CFh4KuTZYZ9fbylpp1atbSLyCB+sifqsyKPncg7DEAvOlS7s5eQ6S9IqHodZfL2OSLWDSbpQgX+Z/suWKpZZlNGBWCWQMXVBlfZuh44V8K08D7yZ5T8vZH+JS2hWjW9D1s0oDBywxTnWdFwqOs6zBohEEnE5aw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4635.namprd13.prod.outlook.com (2603:10b6:610:c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 14:44:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:44:45 +0000
Date:   Tue, 28 Mar 2023 16:44:38 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 2/6] octeontx2-pf: Rename tot_tx_queues to
 non_qos_queues
Message-ID: <ZCL9VkdqhHPtc9i1@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-3-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-3-hkelam@marvell.com>
X-ClientProxiedBy: AS4PR09CA0018.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: a60087a7-3fa6-42ff-0276-08db2f9af928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MEuLjPzlGAOkjK57eI9mcNVhTIRxgKfamcocCE9Z62BM9XmtYzvplQ4FhtKTjyIYp3UPWE0F+9+rufIfEqg8r4zj9uFJpqPvf600ZJ72FvcpDaWS5cBtwq0E8F7qWFbZFeLwF9NfdGBcArEkWO0nspQ8GzdXmc1m3VivHQQsL2tg0dM1eveCrOpGGH9GFr38HYv5Yd8ZSadQz2QAJiTiOVc0ZfNp56oRsxgJH81Fj0UI2pJhRW01ro0LJEKuLqsUz94JU3Z6lNRM3FNHGSSVAKOClncqc3h5szzUcXyjVFj+6gON82IBRu4vSbxBJ0/OEBobKkauAXIIZweYuaJVN6ui5CIEmbrM06lmbed7SZXtyuqVUct29Lv8131qieoy5hkhTp7g2Zs4sXddSiAAeEwBhSGDVhyRwV4k6aQHLU/RUVaPlGl8EsAELuYF6ctNtebMYh4WRnBSscu4OJzitCQqvVld5p4L+sssoc2d9IBzaIp3+6BXlVRLwz1h3GD3h+hIyU9YMybiYbxWv4kh6u16+CkgkYtHp2tQLV/M9JWs3Gf9z/xPkDWY3ixzRRJS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(366004)(136003)(396003)(346002)(451199021)(186003)(6666004)(316002)(6512007)(6506007)(66899021)(2616005)(83380400001)(6486002)(44832011)(478600001)(4744005)(38100700002)(8936002)(7416002)(86362001)(5660300002)(41300700001)(36756003)(66476007)(4326008)(66946007)(66556008)(6916009)(8676002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PcO9+vuIY+WWD2HzpETLNFLb8aJz5gzDFTzjQblaUScXo/bOnN10qNJ2dCM9?=
 =?us-ascii?Q?icK4WyVvCm3Je1DCW8rR8G4NawdI3NkU30MboH1LoU4+WPj1I+xqIZNTbteh?=
 =?us-ascii?Q?8iTd97g5fz0yyrdzbOrkvw0KWgPleIIKLlnU1YL4A7aya/p47YbyKmv+rqZh?=
 =?us-ascii?Q?+VygHK5Mp6vD+TZuGBKyZ8qHf9Nx13MbFq9E8J5eITNxoYsHLzd6A3eA30D0?=
 =?us-ascii?Q?ojKUKUPrvl8YO+E6HgN5vbowEqZMUQpbG6nomOK+z+E6CdTMNxDlN1d30vUm?=
 =?us-ascii?Q?CBkvIGxPFbzWTGPDVyLyYXbZhkLLOxjL+weHwZGQF6QOFNlKmqQhSZRsbWpx?=
 =?us-ascii?Q?R0x+bv+NSe16RpSuo98PHNyHgeI5l2cKwikOUy8qZHb6hjTN4ru8BZXVtfvA?=
 =?us-ascii?Q?NZN2Ot+mjBgLznqAggDV7hA05F9ltGqk38mWp3UrxhK4Gjv+EPzXCT9KxgDr?=
 =?us-ascii?Q?yoANUf83PfDGTjIcYbjYOGN99P9O588gXQUqWz3ZmdhQQ+Hkk1eRD5lMGaJm?=
 =?us-ascii?Q?prHu+SjkDFFFYmRdu8SmKUgODADtousr21bCGUR9jwNZ3K972U3dYX+slsZ9?=
 =?us-ascii?Q?oJ8VB2gPP3geAjMUuxOY+0N02ZLMAinIHiYB5hGW9JdRLjY13L1pKeX4X94B?=
 =?us-ascii?Q?V99ox9rTZr5CC1zXClX1C8N8rP/LF6uQE7M1nzjw+VtU18+d/3iXJq8+toEN?=
 =?us-ascii?Q?HiIVSVpND5YxXOc6C9Qr7ylcKzT3PYcmvyXJSk+sSmJyPfhghoVNTqfRVUY0?=
 =?us-ascii?Q?RFwmwGKhoDhArpoG130jqL3fEWZNlazjJ+MObHUXU19Hb6slvUq+EUv31DUf?=
 =?us-ascii?Q?v6vuc7MqlfJwWFffiwN2Jnz8tuzV0Jp/DrHZU5Vl+RuZEyoEliMUw7SZurZr?=
 =?us-ascii?Q?Gu8x2waKDKqtBLEsK68+o3Ki7BQQ6i9Pev0xbGHClQz/suC1F1SL5ZnuswRg?=
 =?us-ascii?Q?ghrCBgnndz58/T0QTjNEEaTP3NcNPU3KOsvWBQghMu1VZI7oMx6NFVqoYKcH?=
 =?us-ascii?Q?oylTTLJnA1kqb/jvbakzmnp/tPoj+IFacKipjspY12QcgMCs5oABk0e726aE?=
 =?us-ascii?Q?/2DNysELDaiDAePlxGqZKQh4YEmpjjXoOysKBmWNiyevPZTtYRkZrMJE+2CO?=
 =?us-ascii?Q?3ARq6mbr4/RVZlLdG7owv7OINrDpZ9cgShs2+uaQJIaR8nfv5yZehyJLZn1Y?=
 =?us-ascii?Q?fFt2mlGn39nYimQrPov7E53qMuHeZHX7Nhn0aH545xvqxMFmhX7Fjaiee+8s?=
 =?us-ascii?Q?BeNTFWTDC5I4o6g/w7CimwdHp62A+Eratzn83R+5+IiaERvCKOPNK5tu1VKW?=
 =?us-ascii?Q?i1LJZKAhObhXm6/yPzywnMAyh5LeRyBiqPbyWjRzHDoc/pvuDXdfNLnNtp4a?=
 =?us-ascii?Q?hyaEctzfgZRLSuRAz0CJXZm86AU/20NV2xmksesrJXqiIOkA2btO24DmjXhs?=
 =?us-ascii?Q?KfLtCrVnzrgM9JNV1foH3FWdVkAMm+VX25tp0GQr8RLV9iDhz9sMBRjAKsxT?=
 =?us-ascii?Q?tDGS2V1h4LF9bYMm4teWJDuugFeBuE5+4vzCJZXq8Ugdr5fnXiAOxQ1HXfTj?=
 =?us-ascii?Q?QvleoBa6JNfL7U4Sv//j1IfA0969oD1eVb7o2QLZHYBa9VrrHpoeuKRx9MeV?=
 =?us-ascii?Q?pEg3QdcqSYzlRC7JjCbfxMnU7nRng5CgYb2qYlt8TicwHGPeWQcWo2RKV6yd?=
 =?us-ascii?Q?dtIUcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a60087a7-3fa6-42ff-0276-08db2f9af928
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:44:45.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0mg0rM9WJD1kibOe8Qp0Ol7fRXe+j5xVaig7AD9fI89NCqDkouUFwqEWuUNJ268jIo+NF1PubRp3xFW3ljNBK+reaEOONXBCwlfYKBmxYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4635
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:41PM +0530, Hariprasad Kelam wrote:
> current implementation is such that tot_tx_queues contains both
> xdp queues and normal tx queues. which will be allocated in interface
> open calls and deallocated on interface down calls respectively.
> 
> With addition of QOS, where send quees are allocated/deallacated upon
> user request Qos send queues won't be part of tot_tx_queues. So this
> patch renames tot_tx_queues to non_qos_queues.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

