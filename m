Return-Path: <netdev+bounces-10354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3967772DF9E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3E49281241
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251182910A;
	Tue, 13 Jun 2023 10:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9C29105
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:33:18 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44DB1BE3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686652363; x=1718188363;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8frTE4vDdwzKVLqZKBQUHWzQckX1vz5You7SIZzCeQ4=;
  b=nJ/K1E/czCIGhjGxggVm2g5WApKUK3ivvej0hf03Q4KX5fbIIa2Gv4Sd
   xC5dG8PakZE0ejrXLYGH+0YyIcTE6mCTvp0NKl2s+aIM205VbJsGOlwcf
   lR2BJ0SJA6fs53qpyLBZ6QXDy7VIDwVbtsorOOeuDv3eb6TUmVml3X9kI
   XBERNIP0KDFqN/TI5PT+t4WO0FE023jjB0WIRcMN/5ogSeMDAFE/dtcJC
   ZNfZZ1f0q1FDOuHyVq2YOBxWVZRN/C4D1Jtj5x50nQix/yZOS0/KDuWsP
   a5WGBZAbZIAWMm5MlbrzrkxTJBx2ztj7A0nQJ78scWVzjsR5yzmbLhnUm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421885380"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="421885380"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:25:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="714745586"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="714745586"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2023 03:25:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 03:25:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 03:25:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 03:25:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 03:25:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/NVi6Ez3XPprC5r6A/CE5eNbLE7aF/mhsEWqcBnjxh3L7jiII82tPiwYeobnnUk3OVAIr0Xv2bk/vxVePnnHuOHq7uAodfdLonuUBsnM11KLNNdEUM9X9vD1kH/K9+EF3HdUmQMsjl+M/Fjcuj4IgZxcLWcDZbfSdmNOrKssrBWX8ngyzrszCRM4IzR8M7F/b4CEEgx7iOoaPwDzLtmBsH2JkXT5+TDMhQnoyAvGIjd4xnvyQ/ZKCsLwqTPLWLAIAX46kA37ag0SQAP7SK1OG2gP3vQwldkNYUZ3vZtGYid3JcgWUB0b2WnDnhpz7/cK8GtNKBqkSRGwj4w67Z6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbuISDKgd/iIp9B5DN8VXsjix8Y1bcHOVIWDFFjHCDM=;
 b=LbuDUCzimMG5uPq8fG54tTxLXQXU7PypdinJlRDmrBMvtZB2eQw/d/iNkgjbGTJ7nilMACKKS8VB1oz25JwlrMLxxir9G4aP4DfNddYXf1xj/K5Pz/b/JwUbXvj/3oALjXSwCL+b58NQLHczG42B6UPD8hLyZF4ObLgJkJ1kz36jJT+pdi+mJ6mwsbN6owA4a3rl2wFL1OnofEUA7JkIOdKpuO5nesZW4Jel9YrCedUu7L0tcA8QnqdKoldpyXr6SRVfYo+zxQz0lO9GNfc5PQrU5GN1Ioz8hN5y5ohpvMUHqtv9d/dqdUaT4axRIb+1gogZR+rh0Aft6dzMytlzlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by SJ2PR11MB7428.namprd11.prod.outlook.com (2603:10b6:a03:4cf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 10:25:17 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 10:25:17 +0000
Message-ID: <44e523ad-e68c-725f-efb5-b1a1323adfb2@intel.com>
Date: Tue, 13 Jun 2023 12:25:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: use ice_down_up() where
 applicable
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	<intel-wired-lan@lists.osuosl.org>
CC: <netdev@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<magnus.karlsson@intel.com>
References: <20230612141730.331674-1-maciej.fijalkowski@intel.com>
Content-Language: en-US
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <20230612141730.331674-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0018.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::23) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|SJ2PR11MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: af21f31f-0a20-4ff3-e137-08db6bf87b36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StHlnr7kXks8lHTVW5zlGGOqFXtnr5DUdYW73RZqqurD8oDeWfUJTl1LJwAi879mrsb0Mf0xU5Ed8zqtSpUcgpGNG60iXSiDKKu86zTKwXXhZ+2gy7aq2/+zfSgc6rsGh9yeZsAbS5H0XFXEjKUQoIZiMmLQcj9R5egvasPjbpVDMe/9iAXAHMDOJedgfoTEXUXvEZL4Y34kaVrnmhTP3sLCTED+gm3xhRMt0aC8FcfewZeDAfrAFK8Kj62K/Rml5Qr1YYT8orfya7UB3ziuLcyRj09xP177El8MAGxqvFPgKp87Mn4FXT7V8j0+4quBPnlIAbeZXP1VlySRddmg6ngzwHjd7mvSC7MceU1VRhoPkbDQ2m/q/k/lqB4iixA+O/pwF4rByvCvSP/OGg4LrZec8AC0KtJXBcxtbp75+lzdF7p55rDxZgA7HFsSnHGBf2zf6AGFq+YmtBp8+RBXRReuFnmBmeugAoyC2kURjjy8hGu0AtVjA0e+MM9VDwdJJBbGIW14ufN2yGtVL7HGVKQfNjazYE4E+P4S97af5l4M2I67tH8Vuih09zreH1TVLq7NGWbOE0U/mdGbUKkOmS3ZwSvuTn3MqJomYSTq+X0sgmJbEjh+z1qqL9k/IHkMKLKXJJQyedhG/jv5OU/R/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199021)(66946007)(66556008)(8936002)(8676002)(36756003)(5660300002)(31686004)(478600001)(4326008)(66476007)(6666004)(316002)(6486002)(41300700001)(38100700002)(82960400001)(83380400001)(26005)(186003)(6512007)(6506007)(53546011)(86362001)(107886003)(2616005)(31696002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3BqNnF3MGJwY3d4cXg2alM1d3VlcmJ4SFJsR3Nidlh5NGRoK3k1UkRudUxS?=
 =?utf-8?B?N1dHM3hmNi9tbE9vVVBxSURWajA2RThHOUhQanp6TTlIbVV0cWI1Wlg4Q1RK?=
 =?utf-8?B?Y1RSc2FRSFNDSTZxeXJHYVRuclZHVUU4Tm4vK1Fnc2RZS3NoRWN1THcvL1JF?=
 =?utf-8?B?NnlYWEtsVTV5QTZYdDZEeklkMmVmempIZ1lWay9Nd0pSSGtEWXM3ajNndFBP?=
 =?utf-8?B?alJiQnh1V1hvNFplRUJLTjMzbEJHMjVCYXorS0RJK0lrUElqWVR5dkJtSzN0?=
 =?utf-8?B?SkdSTDJUVElqMjF0L2kybG01ZjJIODZWRTVIOFhxUnFUMVE3Z0FoT2h4UjZo?=
 =?utf-8?B?aTNUeXQrQk16eVBmbmtRaGlxNkNRNXVLMkMzTklWdnc1b21ydWp1OHpXZVRs?=
 =?utf-8?B?VnVHeWhFdE96cmduMUZMZzBmVENDSnp4OXZZdThiSHc0cVJOZGF5amV3OUtO?=
 =?utf-8?B?dU1TeWhralJocURSRkZmWVZvdWg0aEdzY2hDL2x3L09WOEtpN2EwV240TGdx?=
 =?utf-8?B?U3JONERFc0lWNytoM3d3d0ZyYUdMSC9heGVnU01UVFgyZS9oQ284cE5CNmY3?=
 =?utf-8?B?c0pKZWx5NzlnR0FjdEtHVDFDTUNYN0FiQzBMaWdqaFJyUm1vNDRsTFhyWFdM?=
 =?utf-8?B?NEE5aFh4dGVKWFRhYklQOUltLzdCTHpVTWZOelJLdmI2OXlYclJFSlZIQjlm?=
 =?utf-8?B?WFRaem5zcUxnTnhCZzVVcVdsUHEzS0RmTHM1VWNoQnZ3RU1Oa3ZsYldZYW51?=
 =?utf-8?B?a3ZYdHdhZmpieFVuSllWWWNxcUlTQ2RxR28wdGJXVGlZSkpuaGEwWGgySzZo?=
 =?utf-8?B?eUpWZU1uSEdmYnVRdUFSak01Yk5SNmk1cG1lYnhmVDRLdGtvSStKYlhmVmtl?=
 =?utf-8?B?UDNrUUNZandWajN0K29qalNoNXkzN296dEp1OXJPV01lbU9KSE5jeFZ3Sklw?=
 =?utf-8?B?dlc1TTdjMzI4T25xMkpZQVdsdUU1YTA5M0dDUzlTd0kyczRkbUt3UGZWTjVP?=
 =?utf-8?B?ZWYzNEgvTFhva0JFUVJiU3hXL1VqVUpuamVRWHlTV0VEMkQ1cStzY29PWlc0?=
 =?utf-8?B?M0VkMW9OeVh3WU1pSXcrR2RuTmRuMlQvRVJmSnVIblJyVG1yUFdWdWltTlNh?=
 =?utf-8?B?ZkhtS3Y3akNhR3o5dktVVHhLc3FvcHg5Vm4vWitTS25pd2Z0V1lJKytPbi9C?=
 =?utf-8?B?WnRWOGxrdi9VV3hFY2lob2dXZ1ZkRkxOS2QwdWc5OHhhREMvamVCcDFTNndu?=
 =?utf-8?B?ZWNkVGp0ZzRvRjRnSk1USHRlRlZlOE9ib3ByRXMyUE1PZml4bzlpU3JZdmNu?=
 =?utf-8?B?YysrVTl0Yk1jc3ZTQUVPaWVRV2FIVERTd0ZCb3lvRTRSNENzcVRNalpneVha?=
 =?utf-8?B?OXlycXFtVFlZL1hPL2xCcDlybHZMSm5ubnJhL0V6cHJsazFoMWR5dVN2UHFa?=
 =?utf-8?B?VTZiRVJaVWpkejM3aHViK0RISUMxS0t5M241cUJ6QXpyZE1SeWNUR3U5VlJn?=
 =?utf-8?B?MVRQbkN3UW5Lb1ZMWFZpRWl3N2hKOU9yYXhKTzY3R0hPT0FsMENSOEMxM0Zn?=
 =?utf-8?B?WGN0NVdMU2dpb1hDcVI1RkV2MDl0MjMyZTVoUTZ6UzdjL0FBUGE4UFVOSyts?=
 =?utf-8?B?ZjFsQVB2YXROUUh5VFVQUU9iWHRoVHJBQTB4TVhIdzB4NE1DcGhTUDdGN0Vy?=
 =?utf-8?B?VDh0ejdDelZwUSsvSHdSQU9BU1pacW5LQmNZcC9WRDVwN3pQOGovbWhpTWx5?=
 =?utf-8?B?bXR4OE5RWmd6enhrYzFCbFhYRCtocE5hVDhnK1hpS3hPTmpYbW85MTdzaXlU?=
 =?utf-8?B?bWJWUDBqMmZYNkp5RTlNSkRFL2ZVR2pqcDJRSWY0SklZZDRmcUkwTEdhQ3NW?=
 =?utf-8?B?Zk0vVDlHZU0xLytMYkpWVlVON0lvWW5WY0UrR1lYUFlzeGxMa20yMlRzY1hX?=
 =?utf-8?B?ck5manJsZjFrdnFZVFhWeElPdHQ0TTJXVWRZczF1Tklhb0dNLzZMRkNZL2Ev?=
 =?utf-8?B?NEh4cXZuZFJZNVVRb2hkSE42U2JNZHZabUN6bXFEa0d5cW1CYWYyKytWMGRw?=
 =?utf-8?B?QTVnaSt0YmY5VVBUbXp1bEVNWjBDNnN3aWdzRStNYWR3OHVGS1JDdGxMZzFW?=
 =?utf-8?B?a3pJOXZ1NW5jSVZmNDN6TW9IUEpqZUl3N3VJeS9IM3lGa1JuK09YYlpubm9k?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af21f31f-0a20-4ff3-e137-08db6bf87b36
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 10:25:16.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KRUMn8FCMi6Eru1WWXe9rJGtMwJ4oHQe6a0rUtv7vWJnb0QV3au6zGV5xj+UHWUP9vwFPwU719ynhtHPTP6k5Plz7FGQUa3VIXsBzX/E4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7428
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/12/23 16:17, Maciej Fijalkowski wrote:
> ice_change_mtu() is currently using a separate ice_down() and ice_up()
> calls to reflect changed MTU. ice_down_up() serves this purpose, so do
> the refactoring here.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_main.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index a1f7c8edc22f..609df077c314 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -7634,17 +7634,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
>   
>   	/* if VSI is up, bring it down and then back up */
>   	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {

I would remove the above if(), as ice_down_up() starts with:
	if (test_and_set_bit(ICE_VSI_DOWN, vsi->state))
		return 0;

which, with your change applied would just return 0.


> -		err = ice_down(vsi);
> -		if (err) {
> -			netdev_err(netdev, "change MTU if_down err %d\n", err);
> -			return err;
> -		}
> -
> -		err = ice_up(vsi);
> -		if (err) {
> -			netdev_err(netdev, "change MTU if_up err %d\n", err);
> +		err = ice_down_up(vsi);
> +		if (err)
>   			return err;
> -		}
>   	}
>   
>   	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);


