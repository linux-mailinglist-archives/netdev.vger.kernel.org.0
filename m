Return-Path: <netdev+bounces-10719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6F872FF14
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40C9428143F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976F88C01;
	Wed, 14 Jun 2023 12:50:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E72568E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:50:39 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31116E79
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686747038; x=1718283038;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Z5Oafq7Moxfe8j2cVUVfIIjG9RgFckur6bPmtIVQV9A=;
  b=GovUJzy0vN+QUPgP+HyEjLFzSrqAEk2uq2WnsYFdkIlBgw3V4x4ZiIpq
   /uH4LQsi0G3qDUgCPn6AqHuHqsJF6N7iQRU9/a2F+9OnEwvJGV/z0VKR/
   1DmyQqA9maYAOxP/i/oFbGzL5HZ0lc70irJAgqSS2PWLvUvblndnCSll2
   2cAfTpIJAGzN93jnXKbVMZET2doLRIaPj0JyfYV5p3YK/MWCx5rBb8u0P
   ocRSSdQHp7Ii1BteikWvJh0gScCO1xHuO+l/KAL3sp3pdkRbpg2C0SlrE
   6pdNETOztfmwFb8UT7MG3b0uG77jB8oqoNG7tANeiowJ/y6injaeWQ0LW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="361081095"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361081095"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:50:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="741830536"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741830536"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 05:50:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:50:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:50:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:50:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaYtorS/fNTEInsRx3GH4q+qxPgEfDlYud3qbf/OePswBPSaZq375v8z9Umaj3jCQu2DF2avu7Y0b8eWFRNhgxCSWM5w/E6xGuAeT9dwMAJOjYDEOPKLgf4WlWyT19Vp/4O2GVDPMnKEVNbU/Rbo70cCXv5snaBZq8IQ1OwKq6GdkF2CMISYc6C90+YHRK5mNjMcRCJm5iofOEwVHGlVG3AKLFV5f93bfxKY+MU037ViNNpR3ZnDbjw40InnISmsySku9Ub5M6yKv28goZ71OlPWh7tZ1RX+iE5AGZHWADf5isnQYTtt5xJnAKMOq41VMs+CNLkTjdoD0/bcmcbF3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfxK78YVVYVFNswI1Ynig6+Mb4N4UI7e9491lIaFgyw=;
 b=c/5cbpeTM1yyYGZV0D5yg9uEBdUpr2Yvs2rxdtMmB3lkWRrlc3CYTaGpBxQjjpHcbysbHwQDieKr99K3OlWjcbr8oqhoUjZdjaFSr67CMO2B62UHpFCYNGQnLiqp+gQoWVNrkbKnEZDea+rCdT/K+jjP2b4JlbVLv0HEmbT4SYQDap6DZ71CRp+bzEaBAQ0lHUpZZrFMjPTtJCJ0w8EEzFHjZfDx2pOH2GZzZkmHgCYlRfbPWuxCUt6lMLcq5NRp3elVCAr1pBGD8+PlkrP8oQappTxnu6z29G9wagFDHeE3wkJ9vrGCY8ctRMUBVfx/gf8HubUVr28UgZ89jA1zaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7386.namprd11.prod.outlook.com (2603:10b6:208:422::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Wed, 14 Jun 2023 12:50:34 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:50:34 +0000
Date: Wed, 14 Jun 2023 14:50:28 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
CC: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
	<netdev@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <magnus.karlsson@intel.com>,
	<fred@cloudflare.com>
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
Message-ID: <ZIm3lHaa3Rjl2xRe@boxer>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com>
 <ZIiJOVMs4qK+PDsp@boxer>
 <874jnbxmye.fsf@toke.dk>
 <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
X-ClientProxiedBy: FR2P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bcdd8eb-3988-4c64-35a0-08db6cd5f1c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shgvtExka2tiJi7d92Xshz+uyW4T/dYapGxhdbSu/Pf1dTvjTdfkpfTE8Qky3YtpeZMMQ+hG3YsXP2iDuFPHUxIEm75dg6yNFqV1HCd/AbDWJ+3InqKilSk7AXmleUBlT/jvMbucgy+ceC7PQmxhm2Bw8M7n7l9aDsX1lDq5o6EeDPK1Fd5Oy8aO1RwdfQdD1ycT8sz8hrNBOnxxVgZ62Pvd/jvZQRE5yUf6zz5SfZ+p5UM+s0DXljbEtRg9k7ZXNIAGWet1YF2zunYDklOChTJp2PDB9JRo3uGU+uBSUehnCEjRLDXVV9+DAzAUTxa6fbZe7wmM08gghidiIiblKM15CZCKdT2oPJGdHd5QjrYDHOVFlKY76CaPMxfKmOgAHlp+fKILxQ8MSA3RskiIQJ/78m1mPca3GFJ69pdvJ1MNyxnLAShtKwiXE0xdZC41taq7vOjpVCfH/1m0pn7IKnWZsluChXxwgCysDd14jTK1pD2phc2WslDOcpqGW+X3n+7/FO43tFVoAGOf4/CDpo7pOPpr0jhLgXUDb5yMAMH0RvuRe6ENw4zvpupLVWBF/Tx1yucAdHL2JOAYn6vo3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(186003)(66574015)(83380400001)(2906002)(33716001)(82960400001)(38100700002)(6486002)(6666004)(966005)(41300700001)(316002)(6506007)(5660300002)(6862004)(8936002)(86362001)(478600001)(9686003)(6636002)(66946007)(66476007)(4326008)(6512007)(26005)(8676002)(66556008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VuGA2AHpdbylcJ6F0k3BTJEcir6neigvv+PAbX1WfYrnubll+J5VksH1y7?=
 =?iso-8859-1?Q?3l7Ffewld24WDeF9Z0knYfN2mMJ/Z+Z2qlppl9dBNAOa9DepxxqwhptYKn?=
 =?iso-8859-1?Q?RU1qq/7rWQ0NF8u4U/v0LJ76ukXoD28uBA9MbiGKE/koginLHRCTF+PzGm?=
 =?iso-8859-1?Q?kP4e1tcooTgRuLrYrKrB6zTxx2XBx75h5dBafEWYQYjoxShS1UADFb4w9S?=
 =?iso-8859-1?Q?nasB1M3+LKKg8UA58QfmYPbe2WH2TS3CnF9H2oHXRnMxd69ptFVvFrDImn?=
 =?iso-8859-1?Q?EjBeZwcK6o0tqrW3CQo1baaGyKp1lPoTJD0qbTBdmLprF7rkepw/PfuKAb?=
 =?iso-8859-1?Q?rfmS3B8GgNAdxp+mj9bO0olqrSHtabEr+45RGH7+HYIRpfOYxSpnMu68us?=
 =?iso-8859-1?Q?MRyupS7GuMjtUz0ugt6U5AGcKqIdYLmUlxTyEu2zRKghogezY6rLbPrCQN?=
 =?iso-8859-1?Q?1ajQlyenUW8wRnip3hTXUol1Ie6qOWEYULTLUgyr9Ejj9DSNp+l5rMvCjh?=
 =?iso-8859-1?Q?lHTuw6JxpQbJEiuXbpF9+h7xg1SUjr2dL5rtO2dlRrdnFlEftV2/4SCJcM?=
 =?iso-8859-1?Q?loYYs4bAMILBBZjhtuAFTnCJqnImeK7JW40ZLLP8vsa7gE3FUIsoyKHNu6?=
 =?iso-8859-1?Q?g0sT0eKQILM5amf+bh9mkiHnoxBaPtQ+U5OUz9Gyf3o/Mdx9pJ7kTuhn4Q?=
 =?iso-8859-1?Q?JiiheJx0hqEthbdv6XJn93rO2GKw0cxggafLp3VFlO75evpOO3WpPR3/Xi?=
 =?iso-8859-1?Q?nfD8Iu3es3qZOnJ/mW+sNi0uUNIJ7SO7C8h28BZZANCZ0nWsx5bwyI6OrG?=
 =?iso-8859-1?Q?kwPpkkI/BVAo4ZDWKP9mEd2025iAX5O8DAen6oUf4moIqxt9maEA9Tx5ho?=
 =?iso-8859-1?Q?pimlXdOXMWZ4y2fq236G/ly9tkYQQ2ucEuLQ7UfeogvZSNnDTJmtWuIDzL?=
 =?iso-8859-1?Q?MXrhf9x2eajvYKvbxjBlgT3etfm0gErEHdHurTs9wRQuRESTKV8cf3xkda?=
 =?iso-8859-1?Q?O+yRXXV+1tQm9HbzZZwT9PedIXrmazlKcK/am1M0lJtCpUWlxNbS+Qifhf?=
 =?iso-8859-1?Q?fyRsQj5RSKLN5o5aLQrJM99S2sl9b4I3wdDkCvUhw1MDLrbUixyiYeI3VC?=
 =?iso-8859-1?Q?OnFkYSNQOfelXoBgLXvNzF/BeQNiVUHr4oekqYMelai7afAVZZqQNZesV3?=
 =?iso-8859-1?Q?zwVEw6O96EGLTi1LSMk4fOsnK8F8vLHwBshs2xqzvX4rPXaJ2a/1V9XPJM?=
 =?iso-8859-1?Q?j5TSqahkEUT0nfAfNGsjFSvkagwbTuESv/ndIJ66cCMjMY8C3MWL9t4+5S?=
 =?iso-8859-1?Q?gZQivY93LzI6SL18PFZUTEMy6pGOJFwL5qPMUBNixV39toE0t+wKTgvZzp?=
 =?iso-8859-1?Q?Yh16Zq+88upNmav1LYpRF2sOIpNyuU5bc3pFqtvzkk3uQZsn/vRwXHyNvQ?=
 =?iso-8859-1?Q?sr2VqkA9OTQf5BzuXHkl6Ke/NlqLKTGgCEO6hgm7noC+DbwmhxXiZdn/Fe?=
 =?iso-8859-1?Q?eFvDkSqClWEd6bJspwnjezhRmD6DpII9E+5y/faa1hndpSCYDnkvIKA6mv?=
 =?iso-8859-1?Q?3iHKG71KLXx1ZKWpIwlPgH9w7gLfjFk4Qgj0KCj893kRcI0x8LC0nmC17H?=
 =?iso-8859-1?Q?u9U86bGF9PbKUmkXRUyGSH0Unc0Kt7Nt7mRD1pVolmHsCcO11X8j1a0w?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bcdd8eb-3988-4c64-35a0-08db6cd5f1c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:50:34.4222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBqiwrevzdpJSxAMkM8NeR8guiemsxR0453DScSF7nU+Q3Mr8MyCo6wfEvxFuuNfECKQipy9kjR94Fb3fPG/V9D5gfZp1sbz/SjRu6rDgMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7386
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 02:40:07PM +0200, Alexander Lobakin wrote:
> From: Toke Høiland-Jørgensen <toke@kernel.org>
> Date: Tue, 13 Jun 2023 19:59:37 +0200
> 
> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> > 
> >> On Tue, Jun 13, 2023 at 05:15:15PM +0200, Alexander Lobakin wrote:
> >>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> >>> Date: Tue, 13 Jun 2023 17:10:05 +0200
> 
> [...]
> 
> >> Since we removed rcu sections from driver sides and given an assumption
> >> that local_bh_{dis,en}able() pair serves this purpose now i believe this
> >> is safe. Are you aware of:
> >>
> >> https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/
> 
> Why [0] then? Added in [1] precisely for the sake of safe XDP prog
> access and wasn't removed :s I was relying on that one in my suggestions
> and code :D
> 
> > 
> > As the author of that series, I agree that it's not necessary to add
> > additional RCU protection. ice_vsi_assign_bpf_prog() already uses xchg()
> > and WRITE_ONCE() which should protect against tearing, and the xdp_prog
> > pointer being passed to ice_run_xdp() is a copy residing on the stack,
> > so it will only be read once per NAPI cycle anyway (which is in line
> > with how most other drivers do it).
> 
> What if a NAPI polling cycle is being run on one core while at the very
> same moment I'm replacing the XDP prog on another core? Not in terms of
> pointer tearing, I see now that this is handled correctly, but in terms
> of refcounts? Can't bpf_prog_put() free it while the polling is still
> active?

Hmm you mean we should do bpf_prog_put() *after* we update bpf_prog on
ice_rx_ring? I think this is a fair point as we don't bump the refcount
per each Rx ring that holds the ptr to bpf_prog, we just rely on the main
one from VSI.

> 
> > 
> > It *would* be nice to add an __rcu annotation to ice_vsi->xdp_prog and
> > ice_rx_ring->xdp_prog (and move to using rcu_dereference(),
> > rcu_assign_pointer() etc), but this is more a documentation/static
> > checker thing than it's a "correctness of the generated code" thing :)

Agree but I would rather address the rest of Intel drivers in the series.

> > 
> > -Toke
> 
> [0]
> https://elixir.bootlin.com/linux/v6.4-rc6/source/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c#L141
> [1]
> https://github.com/alobakin/linux/commit/9c25a22dfb00270372224721fed646965420323a
> 
> Thanks,
> Olek

