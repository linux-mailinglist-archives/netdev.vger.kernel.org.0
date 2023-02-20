Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D6D69C893
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjBTKcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjBTKcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:32:11 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2123.outbound.protection.outlook.com [40.107.223.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6935219699;
        Mon, 20 Feb 2023 02:32:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2YDo+ckL3FpfyuT8kLsexFuOmPhXtuOxyVaeEQ9Cb0r/TORp1mcesyPf6xxrgYHKejAxNfwzaZIeJoEW/6eBTdcTUQltagGbQHrXQWRkM+pncfcx8GMov3hOUA99Dgi8eck2O5QQJjJtlO6lNiqf5ER96WB4HISceFgTrDQZJ/b6vFtnTdzwM3zLRzSLh1v9W/dwuzOvsfVQU/CAsi2xbnwz/uw/wM5GvWD+ARvNUGe2p4j0HUkjuIEWkG2xPtxotwJ0rPWLZaEs+DnUe+0Z+I7Rbb0iAEcCweM7QV4HWBzKJjVv2fQw3sy0KfWkjO/9k1ZdCRrHhpEr4foaHctmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bIvZOOeiH+U+LZ3bFmtJk9hhq77/9vt1PUVGYolbao=;
 b=LanTQUUT8ZoFcVQvaa8LtzBbqgbeFlPson3XLolUpZU5/odMQkTroCKAuptlTxC47pwaT5Rgvu087mRxhCq3lHSZAHZMHRKw2s9s1Di4QY1W19j9Zqv1FKIMVHbFW24uIqf24khVQQ26S6b9yCA13pnp72bJ1fZXtxRzPCsUvpJZyGMqnAEt8ZDz8GyCb+qyr8ds6U9gr8nH1mPSEmLHugMvgYpDKm5aJXnbwRhVsyMeUjn8kYQQ2eQAMjq6KQqAkDzpftzjC+KKezOaomU3qpMGWafJ+gbitSauwZB+o73KzCJ33mqrLV3qlEOmOd0+rYxt+01tjBh+Yf+mtGLNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bIvZOOeiH+U+LZ3bFmtJk9hhq77/9vt1PUVGYolbao=;
 b=IvBaTKF7ZyLdfs0tOjqXzXVj0FaKvbVOFdvDNS9YicHu1eqdiO85B3FB0/TOWqKlAcZChAmgE/OO+8JxVfsLktSJ5a/b6Kt6y6sIop/eaH2AC43+flNpm/mih12mbJGTn104cqlq+CfAZhJMvHqlZ8K+v/zDAMt+ZMrnEmTPbEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3738.namprd13.prod.outlook.com (2603:10b6:5:245::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 10:32:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:32:06 +0000
Date:   Mon, 20 Feb 2023 11:31:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Message-ID: <Y/NMH2QRKoUpdNef@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com>
 <Y/KHWxQWqyFbmi9Y@corigine.com>
 <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
 <Y/MV1JFn4NuptO9q@corigine.com>
 <c8fcebb5-4eba-71c8-e20c-cd7afd7e0d98@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8fcebb5-4eba-71c8-e20c-cd7afd7e0d98@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0131.eurprd05.prod.outlook.com
 (2603:10a6:207:2::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3738:EE_
X-MS-Office365-Filtering-Correlation-Id: 106420f8-4329-42e4-2405-08db132db69c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cfO7teoyis0jbOiybJzEwFp5x+MWu60P4RrTRAZzhycIPpLRGop1jHgttY0FzhmmhwnYjOymg26x3wRr1aoOPFKsMTDn+8GeOwmO/s/klFWx8/OLSOhsScfd7AFSCPaSr1KE+eKspYLdjx7IyvMz1PTaO8qkGjNih9ew+qLfqwW3BvK0v2lV6fZCdLrrCtY5r6JQtPXKIKkDtOuItCtuxmYm7d8qwHeKAG9Ki7CiWiUuxl5/YdV1KdiE/mgd5DBESGVgfj5lyPh+kdFBoRohQBSLuIKcbA90aeb0BKci+Ul4ed+sNH2HuAqtw7JTGdAD8dg+ZT0Vx7ocX1XJupsqoiz0qkMIZjgZHVv9Ew0uzdK9rUHg0TpZM60ilOVv6Sny8GYPlFbgp70VmVgHyfondGvsbKeraDyhFdqfpVbl4CANQhonj1YU1Ua6ed/wKWHLMDaG4ejvd6Sb5DdTBv2KQ159rFvjBTEUe5Oeg7ZKs+vFLySURWl4WpyGF9RWNYbUzDnlQs2lF1FfOT0AHW05yXE5bDViruWKn2CbZtg7IOgAI3gp2wYQDxFl1OnVj3wU18BTyec2qcqzFXEamqOaIT4+Dj0CIgueGvCe6gDHY3R6L3eI/BT4fszEQSWoffFho4+2fBl2VVC1DwXh2ug4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(376002)(39840400004)(136003)(451199018)(316002)(186003)(6512007)(53546011)(478600001)(6506007)(6666004)(2616005)(66476007)(66556008)(66946007)(8676002)(6486002)(6916009)(38100700002)(86362001)(83380400001)(2906002)(4326008)(36756003)(5660300002)(41300700001)(44832011)(7416002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnNyTldpTG1PdlJqSERFSVV4Ti85RnRUT2U2WS9FQ3lSKzEyUnc3Y2RkamYv?=
 =?utf-8?B?aHNXbFVKNVJyc2tKT1NtV2Z6YzVzWU44aG4wSEpUeXdoYU1JV0RoSFI5dXVh?=
 =?utf-8?B?bGwyd0R5Mm12SFpOSXBVVmRCaFo0dkQrZXJhSjM3RU0wRElJN0pkUkZIdHYw?=
 =?utf-8?B?VmkzcTY1Z1NlRnNyNG1ra241QUE1cGNNcVhHZ3RQUndjL21jZHcveUw4UFJs?=
 =?utf-8?B?cVcvTjBRUERhcDNzNXVEdDJtWUR5eHlOY29xa0JtK1REMmYwOWJXalU4U0lj?=
 =?utf-8?B?RFlwS2x1QjBzNkliQWdzZ1hGcXVyNnVONmVNUEFLaHozKzZDcmhGRkx6SkJ5?=
 =?utf-8?B?ejJValQrVDBDaDE0S1BTK1UzMFRhNjhLeEQ4YVVHS3dYTVBYaDlQUXM1aFlK?=
 =?utf-8?B?K2VraC9PY1VDVUM1WFBmWHczMEVFWDRpREtTb0FjTDM1NnFyT1VIMk1jM2Fa?=
 =?utf-8?B?QWJ3VThtc2gvMWc5dGF5S295dnFSWEZkVGFnM0MyeDB3MU96S0N1NkVNcEhn?=
 =?utf-8?B?TTJTMWM1RlREbmsxWnlsRUF4Rm9WdEpieU5yOC9zOWlyYk9RUFQ3TzVkVFZi?=
 =?utf-8?B?c2ozeHp3SVpNZ1JwdXVLdHZLc2tOajVCaWN2d2h2Q3dXdldwUEhJVG1lYzFy?=
 =?utf-8?B?VlpKc3hDYXlYak5XemN6Tm9HU0VoYmRqejVjWjVFYVZBT0RHeUVFck91YmFC?=
 =?utf-8?B?WjRabVAwUjF2TnN1UTk2NHlsVlJSNnV6NnNVb3hualZBcW5Qd1lZSEpDSjlW?=
 =?utf-8?B?ZGxibGhkc2U5NGpEYzBvazE0THdPMExmSFV0WWwyMlM5WkJJazZlbGRRUm9W?=
 =?utf-8?B?Mm8zVUtwZ2FJSjd2ckZkZEYzbHRTWlJyNEZNYytVTjYvaEowcEdNWlNJam9j?=
 =?utf-8?B?SHRtT0k4VUNlS3VGbmE3Z21wanpwcTYwK0ZNU3pJUjVzM25UckFPa2prejFL?=
 =?utf-8?B?bHc3QUkrbWZXamtzVkczNjRRMmp4QUkrMHl4bVlQZ2hCUjZOaDhzVG5WRUc0?=
 =?utf-8?B?SC9rbHRnYmVuSndzU2lBWERuL0syYmFxQmt4RnZQNmwrQnlja1VWVzFzOG9L?=
 =?utf-8?B?cG9oQXdEMTVvY1o3TXV2N2tjUVdxR2VWN3FHL2pRendmK3BxYkZLTmNjT0hQ?=
 =?utf-8?B?OTdReHNMeGZPMmhUOVJJMWs1UGNDME0yMnh2b2piV2pyYlZ0Q0d2ZHVWcEN5?=
 =?utf-8?B?enU5S29TWXhSdklUdDNBZ0R2c25mdGVyNUtUUEdFSlNoYUlKR3owRzduOEJC?=
 =?utf-8?B?WUhnNXN1YmRQZ1VObExBNHZkc2ZOWmg2ZzNVUmVoc2F1M21KQVB3NTlKS0Ft?=
 =?utf-8?B?dUQ1eGQxdFVVek9RbVI0QzAxNGRCR0IzTnRnaHZoQzFFT1hpU1hjZHJKcW1V?=
 =?utf-8?B?TWQrRVd3akt0aWlobkVzQUNxVTFPODRWU0dWYWxJcG9OWHlRUFRYN2hjb0Fx?=
 =?utf-8?B?S2taek5VYW5WRVRUejFSY2RmVFgzSHR0MURNV1FEb1Z6Y05iQzU4ZzhkOHJq?=
 =?utf-8?B?cWhwbENlbW1qVHJCZVAvTSs1Z0p6NitnRis0QlRqT2VTQ3FSU2hCNnk4blpL?=
 =?utf-8?B?M3hYMWk2MXlLVnVaczBiREhUSStIV0xNbFYrWmZocFpPcDlEZmhXYmEvN1pL?=
 =?utf-8?B?bjF2UG5LdGMvVVpyQU9MbkhWN29nQWFLTGpQd0pVZXd2SEhwNmg5bk90dDhk?=
 =?utf-8?B?cDh3WDZoNG90SGRnQjNWd1hyWXdqWUJSeHJjZnp5bU5GUGYxKzN5MVFCTUlX?=
 =?utf-8?B?dHhnZ1ZRYjdlZmxQalRya1VJNVpMcldMb1BrOC91NklVTC94K2lVekpxck9m?=
 =?utf-8?B?cEJuTlJteUkxOFFkYWt4VHo0TjFkT2doRDUvT3FpV3pxb2NNTnNIbDFmUFZO?=
 =?utf-8?B?YXUwU2MvV2xnTGltaUNZN1hxb3pOMW55Y3B3QkZuMWczR2pESmhzd1VUdk11?=
 =?utf-8?B?UitzZEpNY2tWRHhDaXY3MWsvcit6R3A0OUxOazRvZUtINkxwMGZoS1RKWWpK?=
 =?utf-8?B?blovKzJxSitGZVFkdi9rMUV6eitaNFNUeVRxa0srTkVkK2JSU1NhS1pLSEJI?=
 =?utf-8?B?d0NZRktPYmEyMGU2Zm1ndUJKQldpWGYyQ2RmZC8zWFJzYmFscWpycG9meVEy?=
 =?utf-8?B?M0RtK0lnS1didzkxL1VjUlp6czJrSnUyek5FZWNxOEVHTEFZVWhrTGw5ZmVN?=
 =?utf-8?B?S1Nxdk1ud2Q1bkhRd1dmbmJuK0F5eU5zSjNudThWWDgyYUF1aGNhU0s0dEpT?=
 =?utf-8?B?WDJBTXEvU1hPYXBYZmpaTVdVUXh3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106420f8-4329-42e4-2405-08db132db69c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 10:32:06.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BxjoMikMzyDvEsDrnfGTgx/69E+cQY+Vpx72t8aD86HLJttWtmxVzhKp9mo11QjnQOUeVG8Txorpyts2qTlSPGz0DTxM1KV4o25gT5eo3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3738
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 03:15:20PM +0800, Gavin Li wrote:
> 
> On 2/20/2023 2:40 PM, Simon Horman wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Mon, Feb 20, 2023 at 10:05:00AM +0800, Gavin Li wrote:
> > > On 2/20/2023 4:32 AM, Simon Horman wrote:
> > > > External email: Use caution opening links or attachments
> > > > 
> > > > 
> > > > On Fri, Feb 17, 2023 at 05:39:22AM +0200, Gavin Li wrote:
> > > > > vxlan_build_gbp_hdr will be used by other modules to build gbp option in
> > > > > vxlan header according to gbp flags.
> > > > > 
> > > > > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > > > > Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> > > > > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > > > > Reviewed-by: Maor Dickman <maord@nvidia.com>
> > > > > Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> > > > I do wonder if this needs to be a static inline function.
> > > > But nonetheless,
> > > Will get "unused-function" from gcc without "inline"
> > > 
> > > ./include/net/vxlan.h:569:13: warning: ‘vxlan_build_gbp_hdr’ defined but not
> > > used [-Wunused-function]
> > >   static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct
> > > vxlan_metadata *md)
> > Right. But what I was really wondering is if the definition
> > of the function could stay in drivers/net/vxlan/vxlan_core.c,
> > without being static. And have a declaration in include/net/vxlan.h
> 
> Tried that the first time the function was called by driver code. It would
> introduce dependency in linking between the driver and the kernel module.
> 
> Do you think it's OK to have such dependency?

IMHO, yes. But others may feel differently.

I do wonder if any performance overhead of a non-inline function
also needs to be considered.
