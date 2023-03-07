Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47496AE6EC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCGQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCGQmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:42:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2115.outbound.protection.outlook.com [40.107.94.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69596C18;
        Tue,  7 Mar 2023 08:40:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REcsNhbI0gQRLrI646IoKW7Yc3sxazT4Re1RZejH5hHySQkcePqM9+VzsWdptYPBOrjRSbfT5Gd0w7OA2MPY2QXMotumvD4SvjM0yfr0GwtooGaExXaZsX9i8uEYIAmJa8lfb+tLavuObRcmG834jrUTN4SUwgtk62VNDGwPqZK+FU0c5HxfenXszDnmgE/rYJXHxrWNyD63nc+i1j2WGIkggMnWWPz+LgJ+gljjEktKvfeDgZjatLsY9PIJ7FxNhl6pSNAVflsksqv8sMl1iQOlRCMttKRL1B2wCCdfeQyY9Spw2Clm/3Lt5Wh2qiu7F/KZVGHPvYbEzwBXzij6Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0IuU+ZBbrbvQU6DN4Z/+EXIhAo0bD0l23xqXt4834o=;
 b=Cu2TpdPTC7GZcLQDUdpBozkHhBVDQgPLegxTx9niysmynIP7fBeryC5omWtaAohFx5G72S65RyiYcAL5MxFAcepsMHqTeRXSVQIOXa7GNqObxKUURz+sGrbiRZLabqTpKf22FS0By6n7fcgBVRaKqF6FnHcHdHZsxSqnl9zyeoh18kPJXOnX4tN2RWm2KnBQAIMQjj25pYBdS4Akp++Ax1GrykMsj86fYbpTVbPLzxYaPqN6UPCe886O7Qs82ra9tinoX+7nVsw91ADotLNZ1y2CIBw1SZF0nXvshSi4RS9aQUGrWvyRPHcEnNYElSVOqoJXtks4qjSeskR86/t3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0IuU+ZBbrbvQU6DN4Z/+EXIhAo0bD0l23xqXt4834o=;
 b=gsvB+9KvbvqcxNDIiQayq411XRK8tySa8Av6ABVUSaMein7ZkWPiifUw1n4R5svP+YCaM4D3bcmX1DUJ0OjL9RFhhyrGpc9+1xHy4co+Yk6DUy4/GlBJyHqpRChKl9u+CHsgZjCTtXdSorqh4QZznvcMtXhYLDwBIsfZa+gs5r8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5513.namprd13.prod.outlook.com (2603:10b6:806:230::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 16:38:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 16:38:41 +0000
Date:   Tue, 7 Mar 2023 17:38:34 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <ZAdoivY94Y5dfOa4@corigine.com>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
X-ClientProxiedBy: AM4PR07CA0032.eurprd07.prod.outlook.com
 (2603:10a6:205:1::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5513:EE_
X-MS-Office365-Filtering-Correlation-Id: d3581952-2b2a-4d31-a495-08db1f2a68e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuBSD/ODF28eyiZFmYpkV03kY0SKJgkTDSGxg6IuTmwtaoeHUa8WT85FkRb/YV3qN37YZQL2ZOlWt3+iJyJu9aAhtG8V4ET33Y9dVDdWwh8oWXKEr1z15L37nwVA895mBmmqlQ/9mIA9JwNngmkkkor4GjAvcUd5221cppoiU3nqIXN4tE4IAurIDyMTC52KHTSoEY71RM5QLkw5CqtTMLa/sKacBvnrY5OquU5XhIZ2LQvWZKZWwDnOAqdJ+uTKcueyv1WUWIKZOYf8etfmkCwO2tvXBOx3k47fb9l+V5Q2tF8xpbqsa1EvRQdf5rlDA5cH+mqBPyLExl8oIJ0CG2RAibufIv2z3vvr0D97z91tcZudOozJfu1kRmvv7Y7NYC+4JO5N1PmBUlj1I+SDAQv2UxxjQaveBS2Hw/znc31GBEPWN5vSwyalc3iDRff/J7AMExTm+tUaOf3Q4CbhO2g1fRjajQmB83Q6js7yNx6XLeHv8LUS9gLlJ2oRo6OM0B+aUzXgJsVDWoP+HIh+RL/SVxUEUuypUDipIEZJfddDWb7t7wpfoN6Rj39op1cosROJZazKH3YMYAIXN+0LFP+rKmCaS9RWFWrVX1LEu1XzWgt1cNmhYZGfOSNT8B+qcC82lCuXvUvd6uckZgSDNXuQil/3df0lNr/74KiEn4TLTCwxWobGv6X5fJ7j6swb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(346002)(376002)(366004)(396003)(451199018)(54906003)(6486002)(36756003)(316002)(83380400001)(86362001)(6506007)(186003)(2906002)(4326008)(66476007)(44832011)(6916009)(8936002)(66946007)(41300700001)(8676002)(7416002)(66556008)(6512007)(53546011)(478600001)(2616005)(6666004)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVVmV2hlRDBYUWRMdVY3MEwzdnRwbjBXTmhhbjFmTWs2YkpzeXlGUjZUY2Z6?=
 =?utf-8?B?NEtraVZWcHFQV2h2czlEUS80TW1vK0JNS3cyRHZya3M2eWZOYmErWFpsYUd5?=
 =?utf-8?B?UHo4c1FIM3NxUnQwQVhETUdFSmRvVmZiVzk3VXRZcjRTMGs4QjlKZWR4M2li?=
 =?utf-8?B?L2RYREhvUE00RTJjNWdtREdpZ0w3L3RGNVZGL3dtbkRFMjViK2QzWGVLV2Na?=
 =?utf-8?B?dzZlNnBZdkdWYWQvRnpIS2wxTkN6K0dyUG5kVmZRb1U4Q0hRQTFNbTloOXlN?=
 =?utf-8?B?ekhxam9VSXdaQkl6dnJCbWYxSkMxclRhWGlIdDFhUEs4M1VObDlZN3RUV2dN?=
 =?utf-8?B?Ym1QRmFsWGZZYVZ5WUV5bEVHSzlydi9ub2Z1Y3ZyRXF2cFRXOHhCeUp2TFJT?=
 =?utf-8?B?NUQ0d3JxMk85R3YrVnNsWUw3d3BtQmMwb3RWU1dkUVd5NWMxcHFXT29ZNWk2?=
 =?utf-8?B?ZDVmSU1lcExNaDJVQW9CKzR4dXd0V3E5VTVuMC9EbmJmcUNzZFU0NEU5ZjdB?=
 =?utf-8?B?WnhXb0x2TFNtQkxGQWtBTE9WVUhVY0tZblZjZllqRHc5ZXhXc2Z2dWhzaCtK?=
 =?utf-8?B?UXFFdkhQVU1DY09jQWVzWE41dFo5RVJtYzYyelV5NzFmK1BEWFhsb2RNZFRZ?=
 =?utf-8?B?RW03czZ3Q3NyV1NwUU5EMnFnTUp0SHVhdTFFS3Y5UUVWamRzdTNiNDltQnlF?=
 =?utf-8?B?cE5DSzRWdVZyOWdoRTdsRHNJVWs2Q0JxeU5ISmY5VWlrT1c4UVo0TzZyUXhv?=
 =?utf-8?B?S3EyekZNbWhqWTVYb3J3elJqbGY4SG9GNWIxSE9rSSt2ZDYvNGZETDM4L2VK?=
 =?utf-8?B?M3h2d2dubW9oaXhpRkZiVkM4b21lZzN4WmJJOGpUemFuRlZKWURXUkR0bFJX?=
 =?utf-8?B?M1lsZWgyQS9XWlFoWEV2a0ViczRTSEJYNU1OQUUvS0drbmtXUjF6Vmthd2FM?=
 =?utf-8?B?Z0JTSUlBRW5LS1NIZ1dueW14NElEZDJuaXFjcGFmbUVzZGR1cEtGdTZFZmY1?=
 =?utf-8?B?TVpobjNHcGpNTENiZDRlamQ0bVg5WWZydER5UUlvT3hkSjJ0Wkw1YTZqM0V3?=
 =?utf-8?B?dWhjUTVnazEwaStVMExGSjhsS0FQZDR1YnlON0NWUDZobWJpKzcyZmovcnky?=
 =?utf-8?B?L0pTTHBHd1F4ZnJBb0ZHZHZBcTlsQk04Q3Y5SHdJNUxoaEtPczFoUnhSM2NX?=
 =?utf-8?B?Ukc2VUhPcStlQnJsZHlLajJNb1phMTZNVE45T0pveXBHalM4WGN2dkZOZmlE?=
 =?utf-8?B?eHJadGRGWXhsVnNyeCt3V1MzVTBubzRjWFZLb2pleDNEUkxTWG15TjhlNUl1?=
 =?utf-8?B?a25DQytDWXdsamFCQUc0U21RanJYN09uUDdaMW5nbnlZTzAxTkxwdFNwNEgz?=
 =?utf-8?B?b3hEazZkclc5bDdyVUZkakdhQ2dOUnpGRDZKMnQ0b2ZYTm1VVDEzY0tQZkk5?=
 =?utf-8?B?OFhMTkF6ak9VWFhqUzRZWmhvbHhMM1VnZVZ3SXE2MkRUK3g1bnhXWThLNGRQ?=
 =?utf-8?B?SUYzRFJaMHNwYzNDUVduOEFuUlZZdmU0S2pSdllHZ25lNG1sNzVLRU9ScHZi?=
 =?utf-8?B?TlpUYmRMQ0JUWDJ2UWpBQ0hrTm4wZytNajlSK0JNbm1LSURGSE93RVVZOXFz?=
 =?utf-8?B?VncxT1daa0xPNG5ZdkZ6WGpoYTk5bE95MVNUYkFIUVFTdXJDK3F1WlZpWW1R?=
 =?utf-8?B?eDBFOFAzUW1JOWJaTFV0K2xyTkdld25mbHZsZFhrN0Zodkk3VTZ3UmdiVmxT?=
 =?utf-8?B?dWV0Ny81ODVPRTJCYUUwcjBUd3laV1EvUXNiZXhiWmxNdHF0cnpRL3dUS2p4?=
 =?utf-8?B?VWgvOW4zblBaeDdmVFVTQUdJdjRMRUlzYU5pWWNoRjNVUmx2TC9vQVpvVWJU?=
 =?utf-8?B?OTlYVXNESlFFQ3d1N3dXTXppMS9OYWtBTFBzN1pBTUNWK1ZtZStUQm4yV0Zj?=
 =?utf-8?B?QldsYjUzZTE0OWVEbjFuelhjRkZub0NocVpxNWdWSkloZEtzalB0Z0pMcHNp?=
 =?utf-8?B?ejZIMXdwZ2FQaG5pak9jczlacEpqQzR4YkllbDlVb0dUNHBPMXpJVlJHdVhQ?=
 =?utf-8?B?YW1lRDM2bytsaXY3MTlPQ2EzbFhrYVpiS0ZPU0JhSjRSZU1LMTZSMXVTYU1U?=
 =?utf-8?B?dU9GSW9aL2VPWlJ0Y3o4UDh2S1BIV3lEZ29KMVVNbitDaFhNeVFNUzhHTytX?=
 =?utf-8?B?ZFFjNFpiUDBuSGdyaUFFWGRqSjdTYS9KNVByMU5wU1VMSHFaSmovY0Y4RERM?=
 =?utf-8?B?NWVBQzNaSkpheTNGTWJyQlhPb05RPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3581952-2b2a-4d31-a495-08db1f2a68e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:38:41.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erCbbG+zSEFiF9lw5Z4Z+Oijdo4ayLrEtMUbpc+2JFZTPhwT0wDPpGX5nNym/oeQ2Kt0UH+N5pmYnGvuL1zW33sR1Lkak+e9K5+ZmZdBcLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5513
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:39:20PM +0500, Muhammad Usama Anjum wrote:
> On 3/4/23 4:54 AM, Jakub Kicinski wrote:
> > On Fri,  3 Mar 2023 23:53:50 +0500 Muhammad Usama Anjum wrote:
> >> make versioncheck reports the following:
> >> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
> >> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
> >>
> >> So remove linux/version.h from both of these files. Also remove
> >> linux/compiler.h while at it as it is also not being used.
> >>
> >> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > 
> > # Form letter - net-next is closed
> > 
> > The merge window for v6.3 has begun and therefore net-next is closed
> > for new drivers, features, code refactoring and optimizations.
> > We are currently accepting bug fixes only.
> > 
> > Please repost when net-next reopens after Mar 6th.
> It is Mar 7th. Please review.

I think that the way it works is that you need to repost the patch.
Probably with REPOST in the subject if it is unchanged:

Subject: [PATCH net-next repost v2] ...

Or bumped to v3 if there are changes.

Subject: [PATCH net-next v3] ...

Also, as per the examples above, the target tree, in this case
'net-next' should be included in the subject.
