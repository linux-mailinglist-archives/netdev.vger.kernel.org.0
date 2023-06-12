Return-Path: <netdev+bounces-9961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0766B72B736
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 196E72810C9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 05:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E57A1FB8;
	Mon, 12 Jun 2023 05:16:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B8D1C06
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:16:14 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD9FB
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 22:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686546971; x=1718082971;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i0Y4BlhUkzLZVxCsLmILrPPcTna732UF3BuOWug27VU=;
  b=ZttsDdn820+LPafOkOvF3yAFoXZCVuuQa6b2ZZVIZhc4qHdtRReOxKsm
   J1XSkvDjzMHPoABh0dTFtHN1cGD9kM5Ls1jivtCdD9PIpm65jUN3LAKES
   /8qRUm9n+5DgXhKTHVdZdqAc434EuXKxWS8wl5QImr4oR1JNzEC2LJ6J1
   Bbb47iPUY1dY3+fNs0u+5TInc7OPQnVsV5IWDXaYpCFNqGAW7G0tiWyeK
   GZ8PUskAf8+tnFFMnPN074vBlY1L59HqZdYai6y2B2s5pv9VUG4ZnKzUP
   WBCKdCmjXRDEFd3XUdEnymnISzdGyagyjp4lAYYpA2rtevHq65F1yKY1z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="386329986"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="386329986"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 22:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="740866865"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="740866865"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 11 Jun 2023 22:16:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 22:16:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 22:16:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 22:16:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 22:16:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP3DPqsLORS+vy1XMZnPZdX+fQvlj5h7yWgx+83hCp42rXPdOPidl+uEPRf+PhpqrH+fUyOxp0ef6XCUYkuCCe0VtqI+hA1KhAL5n6cgUgsPO9nTEZWriscIFW7QbUUs2RriFuFHpjlKLtHo+HZQ+P0MuhZQwtGXv7eDDzUO0wOqAh8cK7e25UmXe8Mp0iI3wCfp0UMMTAK2ZMDOxH8HLHkiGMQXqt1cvfk1pQ7cUM8UKiLCek958NmbKH0dmYGJWY76SzMcOnBS3U5e797RJsw0PbczG/E8HOrca/T6GqySraA4ouVWkwTIiDD9nA4OyytSW/tqcN9bjn/fzpYopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0Y4BlhUkzLZVxCsLmILrPPcTna732UF3BuOWug27VU=;
 b=kYqsMTuxlfP3gcKfnEaLCJFdhysVrP0bB/Q8PMU/2Z2SOjqKuIukBklxy8LW4i0/olYpUs+rXKNw4k3TCYnip4E2cDjFwpfUVHBkw88zLnSlLqQnfrWRe56TTeG4CY/Fb2mcOOoldtP/MCxLqH3iJ97HvF91w4h1VFKjumZFhrOeBxoW5QZXZeDK5GhzJkwnEN8zo60t8HNyH94v2nv3pMdlkpcgznd6ENM6SaWCp95Ktf3/IUBEGUh31eucLf+g+w12ZYFN/w1pO9kp/6J/y4CKote7SR/XgySioHQbe2hSbN6iYhdp2TTcNDQJFDPVPEQ18QN+lFUhIff5ttWQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5597.namprd11.prod.outlook.com (2603:10b6:a03:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 05:16:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 05:16:06 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>, Paolo Abeni <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Saeed Mahameed <saeed@kernel.org>, Richard Cochran
	<richardcochran@gmail.com>, Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: RE: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
Thread-Topic: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
Thread-Index: AQHZjbkGF4AktioTr0G+fg7j7jn9S69q59qAgAAA4ICAAGQEW4AW0buAgADcwPeAA8J+QA==
Date: Mon, 12 Jun 2023 05:16:06 +0000
Message-ID: <CO1PR11MB5089C523373812F3AE708A3FD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	<20230523205440.326934-8-rrameshbabu@nvidia.com>
	<3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	<1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	<87r0r4l1v6.fsf@nvidia.com>
	<3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
 <87fs70wh7n.fsf@nvidia.com>
In-Reply-To: <87fs70wh7n.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5597:EE_
x-ms-office365-filtering-correlation-id: 19aa1023-dc3d-4c24-3219-08db6b041ff3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UGynxm0vZHipTW4W87xuZAPQWLIWjP8NrMqXr1yk1U7d1oDxDy8A6u7oVX3yQKQqitfqyv+aMvM+Nsh+7hY+KKSKUkXoC8ICrgzOYcJgQwfc3T8gprToIl24WNeH3nbQJCxKgxwYybEbcGL3mm57+t6eIYIUD96fsTl6dZYszADsWW6xgUI3EhU1siVjGLkyMPeq698H7Ti+d+8ZufKbTQKrwYbTU6/cUHGUfLIn1Ym07MW/eaje2h05KnT5ayORROydAfRzugDXmvGIijRTR5NH6se1sINM5Gj2TxL3E/7IeBPhjbSO0g0EybWYy03FzVTQ6YwwM/YUlPdMoeZFYWKp45EdKG9/JRMwWnjJ4sFm13tg4HXyxKfQSFrKs2w2p3ymZ/MFT/iy0AsFhnfhH2Cm7fiXBWQpHTdwE7jLtMBO4WrbYBsnRzlQXKcBdpjryryqK76lgGWu2D5wNw65K2rCLXU/ko9f9I2e5/JgPWbBHvrxVmWtEmThMV3zYIDHg6R40yrk7hPrxrq35D1A+Yaqc2wIyh7X9vGFctTE+rqJxK+4nuqgF6hgv5WfiIHgVfOkJZwfDErWCREBuZaUbE1QbTFmoM2MttTkaeo0U8zSLP83YyJTL7HgZa/8atUSXJLti8JPVyt7Mr4GO33tMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199021)(76116006)(66446008)(66556008)(66476007)(66946007)(64756008)(8676002)(8936002)(5660300002)(52536014)(478600001)(4326008)(110136005)(54906003)(71200400001)(7696005)(316002)(41300700001)(38100700002)(82960400001)(122000001)(55016003)(6506007)(53546011)(9686003)(186003)(38070700005)(26005)(83380400001)(86362001)(2906002)(33656002)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1UrZTVuTFlmRmpMbVVZSEV1Z1dNVVdQbnNjWE43M05wbVBtM0NPazZBK1M5?=
 =?utf-8?B?NEZKdC81Wk5KNjlzSGprRnlEaUJXQXhqcUJiOG9LTTBJdE5sVGVRV3pCQ1N4?=
 =?utf-8?B?MG95Z0N3N09YRWJEcERsbzBveHE0cnFCZEFrMnpTMkdXRjJWV0Job1FmT3pz?=
 =?utf-8?B?RjVtYUtTbldVRlkva2JxU3lzRkIxYnE2U0tMRUxPc0FQYmxGSjVJSWY2eFIz?=
 =?utf-8?B?OWFvZnUxcmFVbGlkMXBrSndOS2tJYlNLUGFmRGMzTnRlWUppMWwyWERjaWNJ?=
 =?utf-8?B?bk90NDJuMExjc0tEbTArWG03Q21wSGl4bXVGeDhSaTZITDVhcEZaL21RVnNh?=
 =?utf-8?B?UHZFRGIvS2RBMmE5N1h0WGlrb01tQm5aU1owcTFIeXkxWmRWckQ3T0NSOUJX?=
 =?utf-8?B?SlNCYStnTWlCUWJyYnRmWUFmdG81cC96ekJmeDdjNWQ3K0ttVytkTXpHSExQ?=
 =?utf-8?B?ajlVeTN1N1lsOFY2U1JXVEVqS0Jidm5ITFVYMlRWVlE3NVZnNXJWTGVuWUUr?=
 =?utf-8?B?MGVHaElnMjFjUFhLMnVmb2t5alFaWmRTRFFQZkwwNnR0UWkzV1I2amlaZ0F4?=
 =?utf-8?B?bkkyVlFxMEQxYWh5Tk54Rmc2U3I5U0paakEyVWdBUU1VSXpZeDBOY1dJZWJp?=
 =?utf-8?B?WXhTTmo5aWJGTjRLMVZqSHZCMk1NYVViWUJlN3N3R0tLYkNmSzRRY1FFZDdN?=
 =?utf-8?B?UWozeWE4RDBYNXJkTnNBODd4UmZjTmxRR2Q5Qld1QTJOVFJWaFdDKzVJakVa?=
 =?utf-8?B?TTFmUER5eTJFdVpzVFhLQ1JVNmQwQUFSNS9uZ3hWTFFZbERuYlNxRndFb2Vq?=
 =?utf-8?B?b0dIN3ZCMFBKT3JKQVhmZHB2TE1JMnlvRytHcHdjQU9xYmJRV3NrdTkwQTVm?=
 =?utf-8?B?UG83MFBQWEEwa1BEMGU4SklhSCtDUU5BSDJxUGx4S1BxNGU4ZzNjZEluRUpu?=
 =?utf-8?B?WWd0Z0wzcDlyTlBXVGc5cm8yNHRzRFpqekhBSWUvOWhyc3R2QzFmTm12T01N?=
 =?utf-8?B?U0xLdW1ad1JEcTgrc3NDejhWS2NucW44ZGpzUk1pOExZNHZ1ZDdsMURWQkJH?=
 =?utf-8?B?Z3k0SWF3OFdrdEorMzAvU3d1bmVSeVhhcHl4UThuRUQ0ZHZRMExMcnJUdWov?=
 =?utf-8?B?b0dja2hEb1l5b1BuWlZDVTlsLytXNHF1S0hEVWx4TU8ySUJtaUVkU21YSmVR?=
 =?utf-8?B?ZmxHU0FSS1o0ekt5YUg5SUg2WUFVQTVuYnhTTlFZdnBDSWE4WFU1YklqYnBm?=
 =?utf-8?B?N3h2Rzk1c2ZsYlBtQWxVSHdLWjJKaEw2THhPMHZuMEpjTE5jVS9OQ0VSSXUx?=
 =?utf-8?B?Zk1HOXhvQ3JkUlMwMFJiQ1dOL3pHN0lLMGIvTUw3WmZDYk8wcjBNQ2M4NU12?=
 =?utf-8?B?YjNzYmUzcmRhQWFFM21hR3dWR3AxN1c4UGRhVmlOdzB4dnlCbFBnbFBHa2ZT?=
 =?utf-8?B?ZXJUUStLOThjZGphYlFXdzN6TVRtQnMyVE5ISHBkT0ZCMWVVcXlZQTRqQU10?=
 =?utf-8?B?NThBVWlNcXZNcGQ3YWlZaW8zdFJ4cHY0VExaMVRNakxtSHNBT28zSVpQaWY1?=
 =?utf-8?B?K2htVk4wcVYycGY0blI2UmR3MEFicUxVMUhnWFh5Qm1reTdNdmFTUVNJVjQv?=
 =?utf-8?B?WllNb2dSMnVFaTRCMkNYbktYbHNlaGdJbkRTVTRabE5xT1NQdFRuYVBXSVQ0?=
 =?utf-8?B?SHRiRDMvWXlvN0VRNkwrZFhWV1ZEUDZOcUpYR2lVeGl5UXU0ZWJ4MW1KelBC?=
 =?utf-8?B?eCtKa2s0ZFhIVjZUa2JsTnBsV1pCSDdGNkN4RE81b1Z2c2poc1NDUkVFMHpT?=
 =?utf-8?B?Y2tXKzdrQzdWVjUzOGJHRzJ0Z2t3WHdrQ05qSE5ZSzNJcm9QUU5yOWdXWlpG?=
 =?utf-8?B?c3RYclREZUh6emNDb1V4bUxaQkNRTUFhNFNSS2JnUGkzOS9Ea3JFNDRVVkN0?=
 =?utf-8?B?eG9uZXp1WXJEeE1vV1pHNVl3d2hWMSttc1ZFaHVqOS9XUmRGTE5iZVEzSklG?=
 =?utf-8?B?YzY2OVN0QU5TRXpEOU9wdWlGYWNVWjVWMHpNaHM3a3FzQ3cvOVBoZTJPYXRJ?=
 =?utf-8?B?S2kzNjk0UXFtRXBSNitjVTFrWWcrNmFVZ09RYmM4dmZvS0gvdmZYbnhUM0FW?=
 =?utf-8?Q?2oj31xh4HW9IPl66nJE/V2hC6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19aa1023-dc3d-4c24-3219-08db6b041ff3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 05:16:06.3076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +2arqH9Y7rv+5HezS46SuYQTqjvffqZ1dedyDYEi/2bLii+zzLGoc8LtC5xYe+IPVwBcSxSqYcjU+ALTyqlqiKBl2naSWKGBD3w46DjyJco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5597
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmFodWwgUmFtZXNoYmFi
dSA8cnJhbWVzaGJhYnVAbnZpZGlhLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdW5lIDksIDIwMjMg
MTI6NDggUE0NCj4gVG86IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gQ2M6IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47IEtlbGxlciwNCj4gSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgR2FsIFBy
ZXNzbWFuIDxnYWxAbnZpZGlhLmNvbT47IFRhcmlxDQo+IFRvdWthbiA8dGFyaXF0QG52aWRpYS5j
b20+OyBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz47IFJpY2hhcmQNCj4gQ29jaHJh
biA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgVmluY2VudCBDaGVuZw0KPiA8dmluY2VudC5j
aGVuZy54aEByZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MiA3
LzldIHB0cDogcHRwX2Nsb2NrbWF0cml4OiBBZGQgLmdldG1heHBoYXNlDQo+IHB0cF9jbG9ja19p
bmZvIGNhbGxiYWNrDQo+IA0KPiBPbiBGcmksIDA5IEp1biwgMjAyMyAwODozODoxMSArMDIwMCBQ
YW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4g
SSdtIHNvcnJ5IGZvciB0aGUgbGF0ZSByZXBseS4gVGhpcyBmZWxsIHVuZGVyIG15IHJhZGFyLg0K
PiA+DQo+ID4gT24gVGh1LCAyMDIzLTA1LTI1IGF0IDExOjA5IC0wNzAwLCBSYWh1bCBSYW1lc2hi
YWJ1IHdyb3RlOg0KPiA+PiBPbiBUaHUsIDI1IE1heSwgMjAyMyAxNDoxMTo1MSArMDIwMCBQYW9s
byBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IHdyb3RlOg0KPiA+PiA+IE9uIFRodSwgMjAy
My0wNS0yNSBhdCAxNDowOCArMDIwMCwgUGFvbG8gQWJlbmkgd3JvdGU6DQo+ID4+ID4gPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3B0cC9wdHBfY2xvY2ttYXRyaXguYyBiL2RyaXZlcnMvcHRwL3B0
cF9jbG9ja21hdHJpeC5jDQo+ID4+ID4gPiA+IGluZGV4IGM5ZDQ1MWJmODllMi4uZjZmOWQ0YWRj
ZTA0IDEwMDY0NA0KPiA+PiA+ID4gPiAtLS0gYS9kcml2ZXJzL3B0cC9wdHBfY2xvY2ttYXRyaXgu
Yw0KPiA+PiA+ID4gPiArKysgYi9kcml2ZXJzL3B0cC9wdHBfY2xvY2ttYXRyaXguYw0KPiA+PiA+
ID4gPiBAQCAtMTY5MiwxNCArMTY5MiwyMyBAQCBzdGF0aWMgaW50DQo+IGluaXRpYWxpemVfZGNv
X29wZXJhdGluZ19tb2RlKHN0cnVjdCBpZHRjbV9jaGFubmVsICpjaGFubmVsKQ0KPiA+PiA+ID4g
PiAgLyogUFRQIEhhcmR3YXJlIENsb2NrIGludGVyZmFjZSAqLw0KPiA+PiA+ID4gPg0KPiA+PiA+
ID4gPiAgLyoNCj4gPj4gPiA+ID4gLSAqIE1heGltdW0gYWJzb2x1dGUgdmFsdWUgZm9yIHdyaXRl
IHBoYXNlIG9mZnNldCBpbiBwaWNvc2Vjb25kcw0KPiA+PiA+ID4gPiAtICoNCj4gPj4gPiA+ID4g
LSAqIEBjaGFubmVsOiAgY2hhbm5lbA0KPiA+PiA+ID4gPiAtICogQGRlbHRhX25zOiBkZWx0YSBp
biBuYW5vc2Vjb25kcw0KPiA+PiA+ID4gPiArICogTWF4aW11bSBhYnNvbHV0ZSB2YWx1ZSBmb3Ig
d3JpdGUgcGhhc2Ugb2Zmc2V0IGluIG5hbm9zZWNvbmRzDQo+ID4+ID4gPiA+ICAgKg0KPiA+PiA+
ID4gPiAgICogRGVzdGluYXRpb24gc2lnbmVkIHJlZ2lzdGVyIGlzIDMyLWJpdCByZWdpc3RlciBp
biByZXNvbHV0aW9uIG9mIDUwcHMNCj4gPj4gPiA+ID4gICAqDQo+ID4+ID4gPiA+IC0gKiAweDdm
ZmZmZmZmICogNTAgPSAgMjE0NzQ4MzY0NyAqIDUwID0gMTA3Mzc0MTgyMzUwDQo+ID4+ID4gPiA+
ICsgKiAweDdmZmZmZmZmICogNTAgPSAgMjE0NzQ4MzY0NyAqIDUwID0gMTA3Mzc0MTgyMzUwIHBz
DQo+ID4+ID4gPiA+ICsgKiBSZXByZXNlbnQgMTA3Mzc0MTgyMzUwIHBzIGFzIDEwNzM3NDE4MiBu
cw0KPiA+PiA+ID4gPiArICovDQo+ID4+ID4gPiA+ICtzdGF0aWMgczMyIGlkdGNtX2dldG1heHBo
YXNlKHN0cnVjdCBwdHBfY2xvY2tfaW5mbyAqcHRwDQo+IF9fYWx3YXlzX3VudXNlZCkNCj4gPj4g
PiA+ID4gK3sNCj4gPj4gPiA+ID4gKwlyZXR1cm4gTUFYX0FCU19XUklURV9QSEFTRV9OQU5PU0VD
T05EUzsNCj4gPj4gPiA+ID4gK30NCj4gPj4gPiA+DQo+ID4+ID4gPiBUaGlzIGludHJvZHVjZXMg
YSBmdW5jdGlvbmFsIGNoYW5nZSBXUlQgdGhlIGN1cnJlbnQgY29kZS4gUHJpb3IgdG8gdGhpcw0K
PiA+PiA+ID4gcGF0Y2ggQ2xvY2tNYXRyaXggdHJpZXMgdG8gYWRqdXN0IHBoYXNlIGRlbHRhIGV2
ZW4gYWJvdmUNCj4gPj4gPiA+IE1BWF9BQlNfV1JJVEVfUEhBU0VfTkFOT1NFQ09ORFMsIGxpbWl0
aW5nIHRoZSBkZWx0YSB0byBzdWNoIHZhbHVlLg0KPiA+PiA+ID4gQWZ0ZXIgdGhpcyBwYXRjaCBp
dCB3aWxsIGVycm9yIG91dC4NCj4gPj4NCj4gPj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGUgc3lz
Y2FsbCBmb3IgYWRqcGhhc2UsIGNsb2NrX2FkanRpbWUsIGNhbm5vdA0KPiA+PiByZXByZXNlbnQg
YW4gb2Zmc2V0IGdyYW51bGFyaXR5IHNtYWxsZXIgdGhhbiBuYW5vc2Vjb25kcyB1c2luZyB0aGUN
Cj4gPj4gc3RydWN0IHRpbWV4IG9mZnNldCBtZW1iZXIuDQo+ID4NCj4gPiBPay4NCj4gPg0KPiA+
PiBUbyBtZSwgaXQgc2VlbXMgdGhhdCBhZGp1c3RpbmcgYSBkZWx0YSBhYm92ZQ0KPiA+PiBNQVhf
QUJTX1dSSVRFX1BIQVNFX05BTk9TRUNPTkRTIChkdWUgdG8gc3VwcG9ydCBmb3IgaGlnaGVyIHBy
ZWNpc2lvbg0KPiA+PiB1bml0cyBieSB0aGUgZGV2aWNlKSwgd2hpbGUgc3VwcG9ydGVkIGJ5IHRo
ZSBkZXZpY2UgZHJpdmVyLCB3b3VsZCBub3QgYmUNCj4gPj4gYSBjYXBhYmlsaXR5IHV0aWxpemVk
IGJ5IGFueSBpbnRlcmZhY2UgdGhhdCB3b3VsZCBpbnZva2UgdGhlIC5hZGpwaGFzZQ0KPiA+PiBj
YWxsYmFjayBpbXBsZW1lbnRlZCBieSBDbG9ja01hdHJpeC4NCj4gDQo+IEkgc2VlIEkgY2F1c2Vk
IHNvbWUgY29uZnVzaW9uIGluIHRlcm1zIG9mIHdoYXQgSSB3YXMgZm9jdXNlZCBvbiB3aXRoDQo+
IHRoaXMgcmVzcG9uc2UuIE15IG1haW4gY29uY2VybiBoZXJlIHdhcyBzdGlsbCBhYm91dCBzdXBw
b3J0aW5nIHByZWNpc2lvbg0KPiB1bml0cyBoaWdoZXIgdGhhbiBuYW5vc2Vjb25kcy4gRm9yIGV4
YW1wbGUgaWYgYSBkZXZpY2Ugd2FzIGNhcGFibGUgb2YNCj4gc3VwcG9ydGluZyAxMDczNzQxODIz
NTAgcGljb3NlY29uZHMgZm9yIEFESl9PRkZTRVQsIGl0IGRvZXNuJ3QgbWF0dGVyDQo+IHdoZXRo
ZXIgdGhlIGRyaXZlciBhZHZlcnRpc2VzIDEwNzM3NDE4MiBuYW5vc2Vjb25kcyBhcyB0aGUgbWF4
aW11bQ0KPiBhZGp1c3RtZW50IGNhcGFiaWxpdHkgdmVyc3VzIDEwNzM3NDE4MjM1MCBwaWNvc2Vj
b25kcyBldmVuIHRob3VnaA0KPiAxMDczNzQxODIgbmFub3NlY29uZHMgPCAxMDczNzQxODIzNTAg
cGljb3NlY29uZHMgYmVjYXVzZSB0aGUgZ3JhbnVsYXJpdHkNCj4gb2YgdGhlIHBhcmFtZXRlciBm
b3IgdGhlIGFkanBoYXNlIGNhbGxiYWNrIGlzIGluIG5hbm9zZWNvbmRzLiBJIHRoaW5rIHdlDQo+
IGhhdmUgY29udmVyZ2VkIG9uIHRoaXMgdG9waWMgYnV0IG5vdCB0aGUgb3RoZXIgcG9pbnQgeW91
IGJyb3VnaHQgdXAuDQo+IA0KPiA+DQo+ID4gSGVyZSBJIGRvbid0IGZvbGxvdy4gSSBtdXN0IGFk
bWl0IEkga25vdyB0aGUgcHRwIHN1YnN5c3RlbSB2ZXJ5IGxpdHRsZSwNCj4gPiBidXQgQUZBSUNT
LCB3ZSBjb3VsZCBoYXZlIGUuZy4NCj4gPg0KPiA+IGNsb2NrX2FkanRpbWUoKSAvLyBvZmZzZXQg
PiAyMDAgc2VjcyAoMjAwMDAwMDAwIHVzZWMpDQo+ID4gIC0+IGRvX2Nsb2NrX2FkanRpbWUNCj4g
PiAgICAgLT4ga2MtPmNsb2NrX2Fkag0KPiA+ICAgICAgICAtPiBjbG9ja19wb3NpeF9keW5hbWlj
DQo+ID4gICAgICAgICAgIC0+IHBjX2Nsb2NrX2FkanRpbWUNCj4gPiAgICAgICAgICAgICAgLT4g
cHRwX2Nsb2NrX2FkanRpbWUNCj4gPiAgICAgICAgICAgICAgICAgLT4gX2lkdGNtX2FkanBoYXNl
IC8vIGRlbHRhIGxhbmQgdW5tb2RpZmllZCB1cCBoZXJlDQo+ID4NCj4gPiBJIGd1ZXNzIHRoZSB1
c2VyLXNwYWNlIGNvdWxkIHBhc3Mgc3VjaCBsYXJnZSBkZWx0YSAoZS5nLiBhdCBib290DQo+ID4g
dGltZT8hPykuIElmIHNvLCB3aXRoIHRoaXMgcGF0Y2ggd2UgY2hhbmdlIGFuIHVzZXItc3BhY2Ug
b2JzZXJ2YWJsZQ0KPiA+IGJlaGF2aW9yLCBhbmQgSSB0aGluayB3ZSBzaG91bGQgYXZvaWQgdGhh
dC4NCj4gDQo+IFRoZSBwb2ludCB0aGF0IHlvdSBicmluZyB1cCBoZXJlIGlzIGFib3V0IGNsYW1w
aW5nICh3aGljaCBpcyBkb25lIGJ5DQo+IGlkdGNtX2FkanBoYXNlIHByZXZpb3VzbHkpIHZlcnN1
cyB0aHJvd2luZyBhbiBlcnJvciB3aGVuIG91dCBvZiByYW5nZQ0KPiAod2hhdCBpcyBub3cgZG9u
ZSBpbiBwdHBfY2xvY2tfYWRqdGltZSBpbiB0aGlzIHBhdGNoIHNlcmllcykuIFRoaXMgd2FzDQo+
IHNvbWV0aGluZyBJIHdhcyBzdHJ1Z2dsaW5nIHdpdGggZGVjaWRpbmcgb24gYSB1bmlmaWVkIGJl
aGF2aW9yIGFjcm9zcw0KPiBhbGwgZHJpdmVycy4gRm9yIGV4YW1wbGUsIHRoZSBtbHg1X2NvcmUg
ZHJpdmVyIGNob29zZXMgdG8gcmV0dXJuIC1FUkFOR0UNCj4gd2hlbiB0aGUgZGVsdGEgbGFuZGVk
IG9uIGl0IGlzIG91dCBvZiB0aGUgcmFuZ2Ugc3VwcG9ydGVkIGJ5IHRoZSBQSEMgb2YNCj4gdGhl
IGRldmljZS4gV2UgY2hvc2UgdG8gcmV0dXJuIGFuIGVycm9yIGJlY2F1c2UgdGhlcmUgd2FzIG5v
IG1lY2hhbmlzbQ0KPiBwcmV2aW91c2x5IGZvciB0aGUgdXNlcnNwYWNlIHRvIGtub3cgd2hhdCB3
YXMgdGhlIHN1cHBvcnRlZCBvZmZzZXQgd2hlbg0KPiB1c2luZyBBREpfT0ZGU0VUIHdpdGggZGlm
ZmVyZW50IFBIQyBkZXZpY2VzLiBJZiBhIHVzZXIgcHJvdmlkZXMgYW4NCj4gb2Zmc2V0IGFuZCBu
byBlcnJvciBpcyByZXR1cm5lZCwgdGhlIHVzZXIgd291bGQgYXNzdW1lIHRoYXQgb2Zmc2V0IGhh
ZA0KPiBiZWVuIGFwcGxpZWQgKHRoZXJlIHdhcyBubyB3YXkgdG8ga25vdyB0aGF0IGl0IHdhcyBj
bGFtcGVkIGZyb20gdGhlDQo+IHVzZXJzcGFjZSkuIFRoaXMgcGF0Y2ggc2VyaWVzIG5vdyBhZGRz
IHRoZSBxdWVyeSBmb3IgbWF4aW11bSBzdXBwb3J0ZWQNCj4gb2Zmc2V0IGluIHRoZSBQVFBfQ0xP
Q0tfR0VUQ0FQUyBpb2N0bC4gSW4gbXkgb3BpbmlvbiwgSSB0aGluayB3ZSB3aWxsDQo+IHNlZSBh
biB1c2Vyc3BhY2Ugb2JzZXJ2YWJsZSBiZWhhdmlvciBjaGFuZ2UgZWl0aGVyIHdheSB1bmZvcnR1
bmF0ZWx5IGR1ZQ0KPiB0byB0aGUgaW5jb25zaXN0ZW5jeSBhbW9uZyBkZXZpY2UgZHJpdmVycywg
d2hpY2ggd2FzIG9uZSBvZiB0aGUgbWFpbg0KPiBpc3N1ZXMgdGhpcyBwYXRjaCBzdWJtaXNzaW9u
IHRhcmdldHMuIEkgYW0gb2sgd2l0aCBtYWtpbmcgdGhlIGNvbW1vbg0KPiBiZWhhdmlvciBpbiBw
dHBfY2xvY2tfYWRqdGltZSBjbGFtcCB0aGUgcHJvdmlkZWQgb2Zmc2V0IHZhbHVlIGluc3RlYWQg
b2YNCj4gdGhyb3dpbmcgYW4gZXJyb3Igd2hlbiBvdXQgb2YgcmFuZ2UuIEluIGJvdGggY2FzZXMs
IHVzZXJzcGFjZSBwcm9ncmFtcw0KPiBjYW4gaGFuZGxlIHRoZSBvdXQtb2YtcmFuZ2UgY2FzZSBl
eHBsaWNpdGx5IHdpdGggYSBjaGVjayBhZ2FpbnN0IHRoZQ0KPiBtYXhpbXVtIG9mZnNldCB2YWx1
ZSBub3cgYWR2ZXJ0aXNlZCBpbiBQVFBfQ0xPQ0tfR0VUQ0FQUy4gTXkgcGVyc29uYWwNCj4gb3Bp
bmlvbiBpcyB0aGF0IHNpbmNlIHdlIGhhdmUgdGhpcyBpbmNvbnNpc3RlbmN5IGFtb25nIGRldmlj
ZSBkcml2ZXJzDQo+IGZvciBoYW5kbGluZyBvdXQgb2YgcmFuZ2Ugb2Zmc2V0cyB0aGF0IGFyZSBj
dXJyZW50bHkgcHJvdmlkZWQgYXMtaXMgdG8NCj4gdGhlIGRyaXZlci1zcGVjaWZpYyBjYWxsYmFj
ayBpbXBsZW1lbnRhdGlvbnMsIGl0IG1ha2VzIHNlbnNlIHRvIGNvbnZlcmdlDQo+IHRvIGEgdmVy
c2lvbiB0aGF0IHJldHVybnMgYW4gZXJyb3Igd2hlbiB0aGUgdXNlcnNwYWNlIHByb3ZpZGVzDQo+
IG91dC1vZi1yYW5nZSB2YWx1ZXMgcmF0aGVyIHRoYW4gc2lsZW50bHkgY2xhbXBpbmcgdGhlc2Ug
dmFsdWVzLiBIb3dldmVyLA0KPiBJIGFtIG9wZW4gdG8gZWl0aGVyIHZlcnNpb24gYXMgbG9uZyBh
cyB3ZSBoYXZlIGNvbnNpc3RlbmN5IGFuZCBkbyBub3QNCj4gbGVhdmUgdGhpcyB1cCB0byBpbmRp
dmlkdWFsIGRldmljZS1kcml2ZXJzIHRvIGRpY3RhdGUgc2luY2UgdGhpcyBhZGRzDQo+IGZ1cnRo
ZXIgY29tcGxleGl0eSBpbiB0aGUgdXNlcnNwYWNlIHdoZW4gd29ya2luZyB3aXRoIHRoaXMgc3lz
Y2FsbC4NCj4gDQoNCkknbSBpbiBmYXZvciBvZiB0aHJvd2luZyBhbiBlcnJvciwgc2luY2UgdXNl
cnNwYWNlIHRoYXQgKmRvZXNuJ3QqIGNoZWNrIGZvciB0aGUgbWF4IHZhbHVlIGFuZCBhc3N1bWVz
IGl0IHdpbGwgYXBwbHkgd2l0aG91dCBhIGNsYW1wIG1heSBiZSBzdXJwcmlzZWQgd2hlbiBpdCBz
dGFydHMgY2xhbXBpbmcuIFVzZXJzcGFjZSB3aGljaCBwcmV2aW91c2x5IHN1cHBsaWVkIGEgbGFy
Z2UgdmFsdWUgYW5kIGl0IGNsYW1wcyBub3cgZ2V0cyBhbiBlcnJvciwgd2hpY2ggbWlnaHQgYmUg
Y29uY2VybmluZywgYnV0IHRoZXkgZ290IGRyaXZlciBkZWZpbmVkIGJlaGF2aW9yIGJlZm9yZSwg
d2hlcmUgaXQgbWlnaHQgZXJyb3Igb3IgaXQgbWlnaHQgY2xhbXAsIHNvIEkgdGhpbmsgd2UncmUg
aW4gYSBuby13aW4gc2NlbmFyaW8gdGhlcmUuDQoNCkkgZG9uJ3QgcmVhbGx5IHNlZSB0aGUgdmFs
dWUgaW4gY2xhbXBpbmcgYmVjYXVzZSB0aGF0IG1ha2VzIGl0IGhhcmQgdG8gdGVsbCBpZiBhbiB1
cGRhdGUgd2FzIGZ1bGx5IGFwcGxpZWQgb3Igbm90LiBOb3cgc29mdHdhcmUgaGFzIHRvIGtub3cg
dG8gY2hlY2sgdGhlIHJhbmdlIGluIGFkdmFuY2UuIEkgd291bGRuJ3QgdmlldyBhIHBhcnRpYWxs
eSBhcHBsaWVkIHVwZGF0ZSBhcyBhIHN1Y2Nlc3NmdWwgYmVoYXZpb3IgaW4gYSB0aW1pbmcgYXBw
bGljYXRpb24uIFRodXMsIG9uIHRoZSBwcmluY2lwbGUgb2YgbGVhc3Qgc3VycHJpc2UgSSB3b3Vs
ZCBhdm9pZCBjbGFtcGluZy4gSSdtIG9wZW4gdG8gb3RoZXIgb3BpbmlvbnMsIGFuZCBJIHRoaW5r
IHN0YW5kYXJkaXppbmcgaXMgbXVjaCBiZXR0ZXIgdGhhbiBsZXR0aW5nIGl0IGJlIGRyaXZlciBi
ZWhhdmlvci4NCg0KDQo+ID4NCj4gPiBUaGFua3MNCj4gPg0KPiA+IFBhb2xvDQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBSYWh1bCBSYW1lc2hiYWJ1DQo=

