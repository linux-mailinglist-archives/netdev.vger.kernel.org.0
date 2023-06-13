Return-Path: <netdev+bounces-10356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F6672DFF1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25A99281024
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56384290F9;
	Tue, 13 Jun 2023 10:43:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5515CB0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:43:40 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D56131
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686653018; x=1718189018;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VLXuAvxEzSuwOZi6ozyGfceio1q/vzIq6lSnCv0YinU=;
  b=I325YZexrT5oCIZb3iO8Xu+Qhfem8ZHzBbEbwxMa/Fz14QTvP8VtBTDZ
   Vq2MEw7IV3TLHNXe0FSdOLUJuFj8F9GBVSQeznopNpYiZGZiqzBu0zRlm
   KSQNeXegdVHMQ9zYjyFDmdGSdcqZmwiUSopH5BhWvacHsHYshWGDL2MTf
   /QPtF+p+XE6wvU0hk+3eud46l5OMEFpCINlaTQwmTZ7737xoF2ltsvRdA
   YZJ0yI+bHCnF8i2vIUtf+eJbAyf/+9lDHxiE6yySv63rSKMpaZ0NEMHdn
   3KOVb9lQDOUXZjjtKPJqTKG7kA12dy5n8KpuiX0MJ8HSpOcraNN9fhV6J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="444669062"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="444669062"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:43:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885801489"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="885801489"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2023 03:43:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 03:43:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 03:43:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 03:43:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 03:43:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrAMYWqCVa54FgGrR8FxbSMWYTOE/mw/O7EW8ibMeyCg3Kjq9T5ZCcq97KJ0G2yS/X5+wyHJmIhvohG+KJqzyp3UlyLlpHUFM7aFuPQPNCmVRkFwRljwSdyORYt/54rjuVh+wVWkePnA26D440Uu3Uuj1ojONxOmrelvVA813Wistd7nPduVM5dQe38mlO723o4XQD3ADuuNi0RhIdBeFFaF5xtI/NoFaynJwHKyAcaeBuHkYYIEYl52ABvFRp2lFcIG0MxuNUBffOKBCvlto/dWOEhiB3V6yZ1AEcTMqPIxWd+EcMIirvBjFNzMZu52xKDyMUKeVcYtfO8RgwPNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LU9ujSAczHt/nf0kO3Fh+JSqCwFWsf8pVgaHx7RW2Y=;
 b=gNCYtTCRbCPIlTC9WxClYetff4n6sNx/2Q9JgzTA63gQoJcRYoRRq3CD/HZX67gIHUpfTBJOY4VQLaAn4UYml3EQvoIXSzWlVYlHdae3TZR/926TIZq4agAJHSr9Kbf2q3m55/qNuTPN6I2l+Yi1tJczSbJnLdQb8YCh6Qa9JEWp8842JVPuXXuNQuouACB62coiRruz7NtA76T1iF8uJd/G/YTzTvXkRPncHrs/+eoQ8UNftyqJ3w2v0+Ay5v58WbmwaKYfnXGsWUfo4oK4IHNtjqIAobyWJGEQ+57nddAMm077VXPQORuE4DZ/xvtti5BRA+s18JN19+w5B1n5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN0PR11MB6253.namprd11.prod.outlook.com (2603:10b6:208:3c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 10:43:34 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 10:43:34 +0000
Date: Tue, 13 Jun 2023 12:43:19 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<anthony.l.nguyen@intel.com>, <magnus.karlsson@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: use ice_down_up() where
 applicable
Message-ID: <ZIhIRyFxM7Uz81og@boxer>
References: <20230612141730.331674-1-maciej.fijalkowski@intel.com>
 <44e523ad-e68c-725f-efb5-b1a1323adfb2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <44e523ad-e68c-725f-efb5-b1a1323adfb2@intel.com>
X-ClientProxiedBy: FR2P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN0PR11MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: fba799f6-cac8-49b6-091f-08db6bfb08ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57F+VjmoaZDijqxu7+lv4qz9IoRm6885n7m48zxkuO+yp30C2bo/+zRyAebnZC8UnedccgyhMRKppGAcUgqNEQwVeBxldg5py8o4Op1urDQAc1zUC0R/bkJirds/5RdV+oSTjwBTtsqceMjah/A2NnzHHIcAf2Tuerp5kpw1AqerLPh8AB/9aQdaYp7azh2qV4//TI3576z5af7Ien1d/PMT8ypt0Seb3z3NdNIvgNjPaZE6rUGTJd+FlwTFCkW34d1P0tzDi2nMWXKQVC3IvIV08wlnKM51T+FetqOtDZmnh9UPd3HUILlpkDPbOLjBOejUbSIxL3gRUd+iAqKSEkKWtk7Qjo9Pgf8fAVblChLzjz0j9HeK9yUKLuzyqzGVXnrT+z3D2B30b8aKhiniRrWQpuUEjymea0TvjFjaBa7ydnA8wls2meCdStZbQDkGZi6h+n6xku3+TeURJwWgMVnSK+tbV2F2m4BlRangJJWySMlJuGoWexs5L2byP6/w1LB3kIoVh31S93pXczuhrzyYKSQWMpgf/qi34Da0KdQvN4r/P/RhvS2XyUoZ0A7T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199021)(86362001)(107886003)(6486002)(6862004)(316002)(8676002)(33716001)(41300700001)(82960400001)(83380400001)(5660300002)(26005)(6512007)(38100700002)(8936002)(9686003)(53546011)(6506007)(6666004)(44832011)(66476007)(66556008)(66946007)(4326008)(478600001)(6636002)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fo8Bl7FGfO7ZywzjSM55b4ar42VnH1nFlMgw3amUcGo3rNbh2ERNUfIAcu27?=
 =?us-ascii?Q?VkaEttp7GdrlSGU1LpwnUw2hZfqzI/NEVrUj2YmVIcecuv79vF9BJj47zIfV?=
 =?us-ascii?Q?91OAONRgncqAEGDzj+bUsz0tb8cyfLfo0WewOfr0lKTP6P4wCw5gXjb0THTg?=
 =?us-ascii?Q?Mrk77v6teKe/zI+scFXKCgSmzvEiOxb/4GkXHH7Q5uJvQvp5cveGNc75nEhs?=
 =?us-ascii?Q?dUVciZ4Bolt8RwXGBolc4JiJ4XqROC/WOkJdTyVg2EKp95qSIRWh+38qzqnV?=
 =?us-ascii?Q?B2jUmTEv45YDaM+SQiv6HAoeGgLg5O47cofpTbwEkvyvRwdkhrkfundQWRa2?=
 =?us-ascii?Q?dLmF7eT4uhiEUVu/vFFrwwtM75adeBNtKcuUb0BWmZ8QaumyhG+4iY3Utbmf?=
 =?us-ascii?Q?/OquZXAKbP3m3GdRdo2IpeLPPCK1D1j2Q6zA4xdWvqaaEpemEN88hxJ/ygxe?=
 =?us-ascii?Q?ZimTC/oIf9avpqOr7BXZWYixsS283sBj5vIX6m8YHv3qjxg6I+fHX87KTsf3?=
 =?us-ascii?Q?kstsozQ6GuL0z8ZNkjlKH+ELKY9HPQSHxaEtPADa517NByYM6BXhpD2fCXda?=
 =?us-ascii?Q?rPRESjOuirIAAp0PrFOf4qd5oAP9CZbcHg+ol2APpF9CI2Zz436nWtyyxuw/?=
 =?us-ascii?Q?7aBJz4fLkVJa99TjnHfmRVYs8+VEL+nZ4Q0slSuSG82JcYmkVNQSkO0DwDq+?=
 =?us-ascii?Q?uxNPsj+RDfVuEDWB5A31oqVQwxEC3uMYV76Hr7bZJbcrfKJfEL2C4MGTT1va?=
 =?us-ascii?Q?ih6jipeENqkxP4bYZM2egGPBh3ht5nGwt1wOELjzmeX01RsDmqte2Yr2CW+8?=
 =?us-ascii?Q?dsVUNmwYhDTNlUnBnnRPi5lueYgkiSHpPdXosE7Jqqsuw+eTqjjl5XR53Jpd?=
 =?us-ascii?Q?p3zzPaa+sL9L/sqox0sH4E1OycOU0vgGdD56vkB+BmF20u7OeXgE0DB7hZiw?=
 =?us-ascii?Q?sptQKy3OrUlmxdSd9al8EVpYPSOkF9kpbaI0Nin7ECKzo0i8+b7h1sk8AFzQ?=
 =?us-ascii?Q?wA7MOKVTMeAkcOqN8iyoSXAb0yDX6EVuo/MEgUs0+5g7ywCX8T1UiE9EOEGF?=
 =?us-ascii?Q?1tWv2ypXv3RwjRBQeZYiQsn+IkxRRZZxNkcl25EPWidmHuM7zMoawZ9RUAQD?=
 =?us-ascii?Q?4SBZxSa+0F3FeX9eVwlDDRXhqkfrfkU2BFWc+zdDQdXZ71MGuEit8cViFIaC?=
 =?us-ascii?Q?58YTL7Q+wfkSU9pBne9X5ExIY21ZOagfaHb0GsTSSNXPWLh6oOpP4dZqP2VN?=
 =?us-ascii?Q?xgMitfDqw0C2aw3NHbegggE9X04AHaNm9tPIz2rdVgZGliSsKE8efUF5ZIlI?=
 =?us-ascii?Q?Lv9dzTY8LX6jeGfyTjJZ1/kLjt+6cYFbheRYOTBT04Ejj4mrsemNsL3jduIp?=
 =?us-ascii?Q?Kdj2oKIhi8b1S26XxY4H43cx31sSokUQLTP8MRLpJ7P85+H2ZBhpqwCVICgW?=
 =?us-ascii?Q?m4Hl8TRcOfzKJ0z8mZB/vb0P6hrfa1wkkJ22WqykeThqdfMmTgvEzrboSvVr?=
 =?us-ascii?Q?tw2yUBcdbchrtNMUC2qr+psiwhJ8tpRiPz5ACGvoqw3xUgYnCFUX64LyIzpe?=
 =?us-ascii?Q?W4mrwNIwOwsgNvMITEwM+4fYJ0fBwDS9JNPUXrL3lB1DkTbnPZpI3LstAAZ7?=
 =?us-ascii?Q?WClotWQur9pUPSBpmHzHRo8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fba799f6-cac8-49b6-091f-08db6bfb08ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 10:43:33.6406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8DeMAVhlmglo0oJ6+DilEf9Qam4s2kSOBcg3hAut9H4O4hUv4Q6pz4p2DdqfUuCOEIjFYfpST3aFOc2sNsHwlLDyuQQM32G96fkWxV2le0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:25:08PM +0200, Przemek Kitszel wrote:
> On 6/12/23 16:17, Maciej Fijalkowski wrote:
> > ice_change_mtu() is currently using a separate ice_down() and ice_up()
> > calls to reflect changed MTU. ice_down_up() serves this purpose, so do
> > the refactoring here.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   drivers/net/ethernet/intel/ice/ice_main.c | 12 ++----------
> >   1 file changed, 2 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index a1f7c8edc22f..609df077c314 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -7634,17 +7634,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
> >   	/* if VSI is up, bring it down and then back up */
> >   	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
> 
> I would remove the above if(), as ice_down_up() starts with:
> 	if (test_and_set_bit(ICE_VSI_DOWN, vsi->state))
> 		return 0;
> 
> which, with your change applied would just return 0.

Yes, thanks a lot for paying attention, sending v2 shortly.

> 
> 
> > -		err = ice_down(vsi);
> > -		if (err) {
> > -			netdev_err(netdev, "change MTU if_down err %d\n", err);
> > -			return err;
> > -		}
> > -
> > -		err = ice_up(vsi);
> > -		if (err) {
> > -			netdev_err(netdev, "change MTU if_up err %d\n", err);
> > +		err = ice_down_up(vsi);
> > +		if (err)
> >   			return err;
> > -		}
> >   	}
> >   	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
> 

