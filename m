Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240FF5BFF0C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiIUNkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIUNkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:40:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2124.outbound.protection.outlook.com [40.107.243.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE082BB37
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns/Og4viZf79V0VHe98SccjIQK0d/KLzUsm6ye/Vr+OYK5IQSJJHLlgOzKQXHHKvRdSWlMTPk+3IJOE2+dWFzHOX/1PltVAIaTFPliLtMcM+h/PH4+Vc+tqL0KQp8Uz/b6Y6KUOt1FgzRcqOExIrxVXYSvLZUA6Yqb2Eha88TkwbrVg+YNmdbRZRptzsXnOPY/a1E1jev+JyEASixjDtmvarRghvSELEsIXK//kN4HvO2z25ZniOVPQrv9Mw8of+FJPyVmwEEfpPUDb6DTMb3n/M5omQQ+2EsMTJszSE7KrIj9bdys+CwVIETLCeTrBP5dD7TLc6MkdoYioi/TLWYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQQz7oBD0U4BM6EeZA8vXj+mkRZ3ClRMPV49NK7XBZw=;
 b=KNmAp8FQYCKcE/Hws+TRDZ/hMRsmtgL2x++ZpIGoRF0q4VY2CxwPeVi+NxVwFd1n+aF6j0pUdcZ+nFAcUK/3Zp/ry3GUUa+1UvujJOV5BfVsIPYbuaeCFW/MRH6Ig4qBiab65ec6MTLYea/h543JVWRH66pF96piIHDUS0UgjDTS9nMALjNpwBYa26Qti2JhXhxYGnGxfFmHlNXCLpV1Tcq5nADHu2Pr+hIK84ctjRtp5d4hoKU9l6mYgUkq5Eji6OkXJtyHH8Wtah50JXYd59Br8O9G+WkJeutdQ113y+OslniCGpKWRudSfjNnOidZ24Ve8WbjpY4WWiAZGFhaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQQz7oBD0U4BM6EeZA8vXj+mkRZ3ClRMPV49NK7XBZw=;
 b=VTo5mX5B235yGM1YtYv3v2WBozTtsL1nDm1Lq7pIupjQyZcy6j0EEnktk79dgl+8iiFJProVN8XpwjhzdjIO8S1qxqzrQRJEIF4vHcWtXiaGiQQs2s2XIuqRhCLugbE0omTsBXTwOr3k/3HoibdKEZS9jEnyiNY4FWoIqUNA5n8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3766.namprd13.prod.outlook.com (2603:10b6:610:9d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Wed, 21 Sep
 2022 13:39:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 13:39:55 +0000
Date:   Wed, 21 Sep 2022 15:39:48 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Message-ID: <YysUJLKZukN8Kirt@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921063448.5b0dd32b@kernel.org>
X-ClientProxiedBy: AS4P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3766:EE_
X-MS-Office365-Filtering-Correlation-Id: 442165ba-9482-40a0-2a50-08da9bd6c49f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbyF7uMKzZRxmRUIVqcBh0KQSSYNqIbZdkdW7yg0/pJD+aHWH+OBJTiNEVxIqO1tMQJP5+PS1vn4rW64ziCD5T4qF6p7KWMwRGrFkGO5euP76Y2RvgEVuSqJZHLP0YIoZ4tqZmL8ObXf8R65LMrx/1da7LQ4/RXZO+R6z7AUioope61jJXit9Jfi6ACKbmBvt2WvhKjEscwTeh/Xpt0L4o1DVVxPHR0EzET1PmLdN8ljRMH4x4hxdl2K4d2cPfcQfEuJQmeAHSKKagCd7lzROKqpH8hdp7e1Dnfu5IwXvSAJsp0hrDHOUji4UEYRu5ANcsk0XeyQCB9LNgjo8XqRsNq7R4nTzlxWrgqpTL8nxhbeMmu8rurdGU4X+seJJYRQnA3KuLDv7aYfgsVg8hq0v7dQ1bs6NGYvZ3s8cxuxyiJHXVdSJbdpuoOw9AyWHuL3L4wbLkCmkTR6zgChRdJUedP3Rq/QyzBMlIBFzaRPl1PmyXDxbvOG6STYE4zXGqqI0MygMzizqn0JQKLT6ViBO+SjnNxhy8el/ti5RIqKqhjrdYbMro4aSH+7ZQF6Gy1MoRednesJiY0A4HmaKdL6dlEx5t9LUirXCQ9YEbkjQ+y+e0ZSP2T7IxXPycVV9/OBJV/dbWxTPnqezass4urjds38/ktf5USs19FKXG4CquT/JM6kincQcsDS2UOk1gPBU+CLH0QcgYR11BXpPLwygg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39830400003)(396003)(451199015)(6486002)(2616005)(36756003)(2906002)(186003)(478600001)(8936002)(54906003)(6916009)(86362001)(7416002)(5660300002)(316002)(44832011)(41300700001)(66946007)(6666004)(38100700002)(4326008)(8676002)(66556008)(52116002)(66476007)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ik1WmM3naU0koektNgT3dgFf0NcslB6IZODmJ51s1ahjXhJSXpqF8z2LKXFA?=
 =?us-ascii?Q?BmB80/O1NXOSE6hy+0hzDkTRLo0nnnKNIRWAmyDEb58jJRFkidzE2KDYtGnA?=
 =?us-ascii?Q?GPkzUd4UQfB1L7JzNbwIYHMcICI9cyLupYSrt51/ST+/Z5WCpGkvslszsq6X?=
 =?us-ascii?Q?huBefrFyJNP82TyieCoWp72VNU32mR7ksukLCZg+ib2TecWhRkywuHOOnFX1?=
 =?us-ascii?Q?LON2F6ADmpJLh9KYN5WpdRauk4l83lrDA8TAP52Dd/dHoRl1BACpdxcnnciR?=
 =?us-ascii?Q?OsmvEkPgOMJFsiMcuaQuCqfpo2Xz0TBcEh5i05nqYU9f4HLn3VlcMbyHe8Hh?=
 =?us-ascii?Q?jufPUg/vE4RWcNTKkpz4tNrHXOyez2Wn66BqHCZeO+M4pcfVlKHoCWF8L08X?=
 =?us-ascii?Q?/jgt/IeLeSv1RIc0yX88CG6DILMGPnxhGdcszKvw5XH2eact/1097hspIVAF?=
 =?us-ascii?Q?bHZOcToKVcH66Foc2q4EW96Xn6Sdgk6ABwmebZVIntA8JNTKXcBWW0wl9Ntx?=
 =?us-ascii?Q?Xr3XaNrBP1Yqvin2bCg8JQ0GpNnPemiSHYukyaYn8JrAIpg8/yA71aMrIV6i?=
 =?us-ascii?Q?wT4jwbxP7TM6C8hJlJRnQjByOUR5ioEh2om/J9v5UWfURiXA3AnvLHcacvtI?=
 =?us-ascii?Q?tN9KYQrx0S4toTYiNdNQCgjaLRpxCy1oUBDIIOcQei6CoU5wjKkLvVAidIdq?=
 =?us-ascii?Q?QY9PQwg6kM3da5+eRzMq1o1k5U3ZPdYSMQJ4DacY/+49OUkZFCfgcAzAKX4v?=
 =?us-ascii?Q?NgxL+PXRmMxMB6YMeIBqMKuIZM4oUM/WqyuBHdE3Se6B+Ef7dABD5BbWDpYc?=
 =?us-ascii?Q?vM7Vaux0gD5DTmJnRnijQ0DywQ9GDnyPCmGBOyv7f1oFnk/k/uJQ5jUlyog6?=
 =?us-ascii?Q?SdRJ+vvskWY/9fffb0rVmu33KGqZ1d00RSSh5K402okbo0n840lXKy5E0ymu?=
 =?us-ascii?Q?d3z1clBvN6O57dlARS8LcSRScKO4Cz57wtMwW0SD5b5uQDvD5ph6akuBHAjV?=
 =?us-ascii?Q?h0bRhRXGnafRbQ9aFuHPzlKUykVmg1JJjWw4JPXNy5WX5G0PuD6EHbxCr29k?=
 =?us-ascii?Q?easkTdTIcSoQAnwfgGGhqSUx2aWexkiZNTSGtF5ukE7OzeL6RC1u0n0sLUEQ?=
 =?us-ascii?Q?xTrhHpiEvWe32mDFJRBaAxp8oLCI/FWOjFEOqqblcIddUZVsktmoKsE1mXd6?=
 =?us-ascii?Q?kTh6x9PEZmNl3z0xX3wv/Cgi7U4lBrjyHi5USvaXUmALeli4Iev4Zy9OSJRN?=
 =?us-ascii?Q?wYTnUwxCpi0pvkWZkCVschvvbFotYHdYa3fiZgj8eqicLy3GVlnnzSk8xDWJ?=
 =?us-ascii?Q?gayikjlXgl8iGz602uYOTPo9vf+DA94aBtCBwcjQIS+dlqwC6KnWTB2I6qb3?=
 =?us-ascii?Q?1Y47pv8u19jPoJhTYN06D+Tb+WGgsWnW4mkvGanStZJcpv0x1qjPDznrBDSs?=
 =?us-ascii?Q?QR7gnWvWQOaZBEFnmD+WuztfoEqGZefxYcDQDLVIPLRpu34u+uHL7DY2g4y4?=
 =?us-ascii?Q?6LUOynIaZqr+Z/bG/tWjUGI1yd2InMlfPAJBppwSVhnV4K+MD/Ym/1XMbj6u?=
 =?us-ascii?Q?gc9yUmXolCxsr0SDB50LsDu/Sqb/Lmc5Eiel5WpaoENa3jy15NG4olKobLef?=
 =?us-ascii?Q?buZCsWp2XLFx+yh7h9de+Y2CcBW2eBWc8ukmqwCfyTpAaFVIxQkfoTnwxV4N?=
 =?us-ascii?Q?Srgqow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 442165ba-9482-40a0-2a50-08da9bd6c49f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 13:39:55.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ge2IEu5m/NGjj4vwwWDHWRF1YgxuiSidSp3Ihoc9ivpRiZfvz/6x+cR4XgKPuvyNZ8geb17pqpjIrbMfnbFMkJn6TcFpVoBMYdPskW3WL2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3766
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 06:34:48AM -0700, Jakub Kicinski wrote:
> On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
> > this short series adds the max_vf_queue generic devlink device parameter,
> > the intention of this is to allow configuration of the number of queues
> > associated with VFs, and facilitates having VFs with different queue
> > counts.
> > 
> > The series also adds support for multi-queue VFs to the nfp driver
> > and support for the max_vf_queue feature described above.
> 
> I think a similar API was discussed in the past by... Broadcom?
> IIRC they wanted more flexibility, i.e. being able to set the
> guaranteed and max allowed queue count.
> 
> Overall this seems like a typical resource division problem so 
> we should try to use the devlink resource API or similar. More 
> complex policies like guaranteed+max are going to be a pain over
> params.
> 
> 
> I wanted to ask a more general question, however. I see that you
> haven't CCed even the major (for some def.) vendors' maintainers.

Sorry about that. I should have considered doing so in the first place.

> Would it be helpful for participation if we had a separate mailing 
> list for discussing driver uAPI introduction which would hopefully 
> be lower traffic? Or perhaps we can require a subject tag ([PATCH
> net-next uapi] ?) so that people can set up email filters?
> 
> The cost is obviously yet another process thing to remember, and 
> while this is nothing that lore+lei can't already do based on file 
> path filters - I doubt y'all care enough to set that up for
> yourselves... :)

Not defending myself here. And not sure if this is helpful.
But the issue for me at the time was not being clear on how to
reach the right audience.
