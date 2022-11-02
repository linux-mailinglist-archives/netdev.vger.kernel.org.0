Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D4616DE5
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKBTjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBTjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:39:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E169410D9
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667417942; x=1698953942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FlOhhK8WDYGy1gjMG7x6JFugl4rNg+wiO2zLKVF9BOs=;
  b=S3xGPlWBJOWi2/vLK2rQz6UjvMGImQznuHlKX+D/S4WJ9zGzem91g2ux
   Uqhq48AroyADP8wVcg7xiv0vtcRTu8Y7FYkr6PYM73Te1l7yqkM8vZoxp
   Ibhl2gkHGv7FvDSJNPktIS+LDdyQIWYaNohDsDZVLEWZxOqkHqCCf+VKA
   3GKwGrdQMGosyII65LMfhtO6g6DHI6tmWxjNY4MmMk9P+auumi5xHBrZm
   onNiwhPYPiI7VNTYcA5i3z2lOrFqxNlrEhPePr27npm7HBZELJ+yjoy6E
   0RZcZ488qP4WwB9CNCUX3h/nuahakJEEfirZyWdEqWXcDX6UsqeqLpGbh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="395813382"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="395813382"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 12:39:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="739891534"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="739891534"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 02 Nov 2022 12:38:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 12:38:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 12:38:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 2 Nov 2022 12:38:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 2 Nov 2022 12:38:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhKLPO+Uo1CUOECU3FDWCzoOejbpHGY7TVxfzh9p5Ns+YpXb0tVJ2NtID8qlzO1BtTEHmTK1SO35z6HBA5LYaLLYhVbi2xIEWtOOhN4hvEru2MEguxxROwDaHdVpgaeYNPzJFHfm5Tf7xMEMMsIhB+66N0xus5F1OahsONld4wS0/SkDyBliXAccYqN9asrht9hHCY5IrNo5biaLg+TaJFuzkDIFm84osJKosO/C6UC3OcohnsZLN9dfBnqMJisirwYx2mlP6EPWHadqKOkJ+Ut4Uc3fxN+qzsKQXv131WDWyqxEcu8vtlT6KqjaEv9EHDHfpp3PabQ33XYw8S/9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlOhhK8WDYGy1gjMG7x6JFugl4rNg+wiO2zLKVF9BOs=;
 b=FSMUmT5dHgJuIjbRCgF7XzkwY0p0gP8MRK0cB40u4Kn0725c7vYYB2MQJKIWbc7nMHOc/UAs2s33CtosAr/gREesFmSEdRpDnkPH19CIytUKur+Or1LCffmu45KNzSFuGxfnTxvp/KiAt8gSESc1OC9x/C8Thi5B18PRDBZb1tuc9WAoxN05TjsVpcK3ti9gJAI5udfXWeUQfsceRIwX+QSbFt21alMwU0N6+2+PT5GJJJb1xW0x5weFPe+8QMMO8exbtAXkZj2vZmo0qyI36B1CA55Hunkgi11/CVi3WIM6aHZLV/ZkLw1dmG3i2AhRZP7PxbEb1BivCPRtNdVZRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO6PR11MB5665.namprd11.prod.outlook.com (2603:10b6:5:354::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 19:38:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Wed, 2 Nov 2022
 19:38:57 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH net-next] ethtool: Fail number of channels change when it
 conflicts with rxnfc
Thread-Topic: [PATCH net-next] ethtool: Fail number of channels change when it
 conflicts with rxnfc
Thread-Index: AQHY7Q+5XRfw/4op4U+Uw+84T1cwNq4pRw8AgAEC6wCAAU2gAIAActig
Date:   Wed, 2 Nov 2022 19:38:57 +0000
Message-ID: <CO1PR11MB50896EA9D92C148FD2A40443D6399@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221031100016.6028-1-gal@nvidia.com>
 <20221031182348.3e8ddb4e@kernel.org>
 <d6068a1d-bf73-950d-749e-70fbbbda489b@intel.com>
 <ceeadd10-51c4-9afb-58b4-ff113b8829b9@nvidia.com>
In-Reply-To: <ceeadd10-51c4-9afb-58b4-ff113b8829b9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CO6PR11MB5665:EE_
x-ms-office365-filtering-correlation-id: 24525086-fc78-47c8-d821-08dabd09e27f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YASGv4dLrUQqrg3/rrnaRCi3v/g8QF+GQRhl27GW8mCbWIuitf5t2hISRXVePa9hMegR28baJavu7/hSFfFTsgjJUSGLBqZ7o47yHYkRdwj3KWZacdQwkR2jXFknwUWY3TQcuK2mPHXUfe+g4BfWgXNGvk6d0aHVG21QUaR8xyMKGC98nZZxHPPIfW9jAf/RDTAvcXdpCC3q7JXiyYls2JnQED4beb9cuZFUBNX1IgjRahM8KCGINkMfe/CVsK7SdB8RobWWN7dbJgQNnlKtSLOWVaP0XDuNXz1YM809LIqIqngmMa45c8Ot7E/4odxGRqKXKi39jsHtcxhPyefZRB35cAI/5dd6TZ7l7KMfHqXOdshKtd78DO/ONc0D9zYooLMWRn/qoAP8SD3u8ncxoWzadsoGEUegm17BqZeT84aclbn4t1lDFS41+osU4MWE94m+xPMq0S9dtsE1zFPWxgmeue2QExFN7/HUNCFrSHkyKP26rBwxLaBwmyKp2E4APjftONARUKdJWyU/UT4NXCcQpOdzgi2IDlNCGrC1OEzpFGQhDVstkij7nybeq9DFA00TGGX3LxT85M9VQ0KqDvSj5sP0t+mHN9jtW/crEjOyoxifCFkofq4+8i0WzQ2s612o9FMMi1L0+qlek8gKKgVpnEXXbKgPJL5jOskAYgAGhHrkab2oIy7NA/+yKUWbsqGY+5pcZSw6WJcrWyYCKpeQPrdrs98RBEj8aI0lsP4WmPB1uKg7PoI6JmsrVnupwKlA1Dlci7uicgZxwb04n4DV1GmdzjUiViz77nVfkrQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(186003)(6506007)(82960400001)(38100700002)(7696005)(2906002)(53546011)(55016003)(8676002)(4326008)(86362001)(316002)(122000001)(66946007)(66446008)(66556008)(38070700005)(66476007)(64756008)(33656002)(76116006)(54906003)(52536014)(8936002)(9686003)(26005)(41300700001)(5660300002)(110136005)(478600001)(83380400001)(71200400001)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REFOOGMyVDFLMWNYbHpoVkNWSGFRRlRqQ1dwRE1FeThxWENUUTZkM2VaQjAw?=
 =?utf-8?B?Y0ZFd08yMGVsMkJ4MklldnlMRTBCUkg3OXhhSVp4VlQ1ZDBFZzVpTGtGYmlN?=
 =?utf-8?B?S296a1VxelQ4QTVXUmhYcTl4TUhkeUN0U0ZiQUE1TDZLcG14Nll3V3ZMdGNo?=
 =?utf-8?B?R09sYU15VUNrWVU2KzVrNmYveVhMdmdNUjhVVFdXM1dsL2hXb0pzME1oRFNZ?=
 =?utf-8?B?MWdaNDJwbDNGeFZ4bFVxTnZHUnNZNUd2ckRYd2pMRVpDQWI1Q3RWaWh0SXc0?=
 =?utf-8?B?ZStsQTdSeEZrWXVOYkZPaThYdGQ0ZzRXM0lydjJkREF3cWFialQ4Q3B4OGM5?=
 =?utf-8?B?K2RnRTZjZit4YVB1Vy80dVZjdXA5ZytFc2JPQ25vcjJlMVpJZ3Nla3dwYnB2?=
 =?utf-8?B?VEJzTUtZM0pjZnNpZDgwbStWd2Z0WktTVzl5dkhTRTM1VWRuQnA1WG1VZmc3?=
 =?utf-8?B?VFFjd0dGTC9oWVNkMERjZVdpYVk1c3FjSTRRclg1OHlnM0srK1ArdjNINk5X?=
 =?utf-8?B?WjRjbGpUc1hvTC9sbVg0eEpSVXc1cWZCUHBlbnlWUUJmdnU3a0ttZERRWm9W?=
 =?utf-8?B?eGNGR3hkUzFINlVGNk1LTHFuVC9uWkRtdy94Tm1GbkRiYVBBZ2ZDL2xrSkJL?=
 =?utf-8?B?UEFUVmNQMk9aaDNOcElSenVONkwzS1BhaGQ0MStDQ3NBMjJFaERUeFd3dzl3?=
 =?utf-8?B?V3BtZzU2UFMweEkrUUUwTXBxNkZ5OFdjb2pWSnVmc3dXMVAxdWtkZU13SWI4?=
 =?utf-8?B?eTR2VW8wTjJ1WXhQZXhwSDRNbS9EcmNGQlZBTldCZW4yWUZlUVlmZDdvS0Nv?=
 =?utf-8?B?THNhM2V6MG1VWHRQaUxqb08yNzZ4YnZ5QTJnRTVUd09xVVpHWGRFMVFTYlJH?=
 =?utf-8?B?THZsNTlVT0FTQm9ZQ1BHTkNHL1A0bkRPMnFXSU1zL0FYZFZ3VEQ5NENwbk0w?=
 =?utf-8?B?WHl3T2xpYzRUS1ZZaVpOK3NOdVZJQkJ5QmtrTVpGd3lBdjBiMGU2R3FnMlUw?=
 =?utf-8?B?WmNMbUNiNW1qbFdMNnFaOFhmUFBTN2Y0L3ZORVVYWU9VVEtzWmpRTDF6ZWtL?=
 =?utf-8?B?dCtPbnltNFdoUnFwUjAyelpxZmFjRFlLZ2tvNG9uaXlaRUpybVVVaGJmdWc5?=
 =?utf-8?B?TnRyMVlRSHFLZUYvMHRaTzU2NWRSYzh1K3hRY1NLUFBQL3NTMmN6ekFrbTQ1?=
 =?utf-8?B?eUdHL29RM01nWXZyUEtmWFQ3MlFnUGtpODlja1d4NVJjd0lWdmVXaEl3RFRC?=
 =?utf-8?B?NUhBSWtUSHpoNFZHbmRhQk1ISE90N2I2SDVCc2JNY1dYdVpoNXJTTE5kMktN?=
 =?utf-8?B?QUEzcXJzZkxldXd6eXdocVErRmozR0ZyV2JYeUhYbkNNVTFnclBGT2ZPcFpL?=
 =?utf-8?B?UjdEUThtWUs0MmhYRDhCbEtESDNSZDBITjlRYUtDUk5GS2dGbStBZDU5S3dC?=
 =?utf-8?B?VEd2Uk03dEdjeThHbng3WjhiWlF2RG5GMll2RHJKMHV0enZYRDlrcmQvZEJS?=
 =?utf-8?B?SnFiU0M4cmZtVTBXZTFxTHVhanhZN0xSbUxZeDhFblEzMndyTGZkSlE2WEVy?=
 =?utf-8?B?Y0NjUXFOOVc1TitwZFl0bHhmQ2xWQldqMFpkM1V3c0tvL1Q4MEpCN0NwUG53?=
 =?utf-8?B?WlhkZ2JFbjNJbWl2YjV6blNnVVRONkNPSkhPdk9JaDFBU2s2ODVlWEtSbDlz?=
 =?utf-8?B?T1MxQkJJaUJSOVk5QnI4b3FrYVZjWUw3SkphSTFmK3IvNW1NVWdVL01ZQTgy?=
 =?utf-8?B?VE8wQ0ZkSGUzeGVEV2tWV3YrSFhYTGZwakptRHRQZUFPRHgrQWdYVFFISFdR?=
 =?utf-8?B?L054Rm5yRGhxaFhXcERnTWNFVlNsd3FRR3ZiR3M5TjIrNThHOUY3a3VIeEht?=
 =?utf-8?B?NnAwanZhU1BWVEpnbVJlUEx2V2xwT0puRW91N1phbU05OTBEUTh5OHQ1NEFL?=
 =?utf-8?B?SW5xZzNJakEwZ0ZINzFUeGU1QWRlVVhEQnlLdm5YaDNVUDgvUEY3MjFRTG95?=
 =?utf-8?B?Q2FuYy94TlJaTXA0NnppdXQ4MnppUHk5U0RicGdzbG5weWlydE8zOFQraVFr?=
 =?utf-8?B?R21HYVYzSlI0MFQ2U28xRCtPbUFPL0dhWmc2eVByMUxueDI4Wk1IM041Rlk1?=
 =?utf-8?Q?i1StzAz52Fp9aI0hwRcYSoPb9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24525086-fc78-47c8-d821-08dabd09e27f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 19:38:57.8261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAS6YQRC7u8FDOnuTgxNAH2LH5iv5jl07vnGtJUSduAvJjMlM/QkVbxOX++dYvJPV4t6pFBhze/Y+nvr9YmJMsxFAWtXfTX1Bf7ZUgjc9R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBOb3ZlbWJlciAyLCAyMDIyIDU6NDUg
QU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFRhcmlxDQo+IFRvdWth
biA8dGFyaXF0QG52aWRpYS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIGV0
aHRvb2w6IEZhaWwgbnVtYmVyIG9mIGNoYW5uZWxzIGNoYW5nZSB3aGVuIGl0DQo+IGNvbmZsaWN0
cyB3aXRoIHJ4bmZjDQo+IA0KPiBPbiAwMS8xMS8yMDIyIDE4OjUwLCBKYWNvYiBLZWxsZXIgd3Jv
dGU6DQo+ID4NCj4gPg0KPiA+IE9uIDEwLzMxLzIwMjIgNjoyMyBQTSwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4+IE9uIE1vbiwgMzEgT2N0IDIwMjIgMTI6MDA6MTYgKzAyMDAgR2FsIFByZXNz
bWFuIHdyb3RlOg0KPiA+Pj4gU2ltaWxhciB0byB3aGF0IHdlIGRvIHdpdGggdGhlIGhhc2ggaW5k
aXJlY3Rpb24gdGFibGUgWzFdLCB3aGVuIG5ldHdvcmsNCj4gPj4+IGZsb3cgY2xhc3NpZmljYXRp
b24gcnVsZXMgYXJlIGZvcndhcmRpbmcgdHJhZmZpYyB0byBjaGFubmVscyBncmVhdGVyDQo+ID4+
PiB0aGFuIHRoZSByZXF1ZXN0ZWQgbnVtYmVyIG9mIGNoYW5uZWxzLCBmYWlsIHRoZSBvcGVyYXRp
b24uDQo+ID4+PiBXaXRob3V0IHRoaXMsIHRyYWZmaWMgY291bGQgYmUgZGlyZWN0ZWQgdG8gY2hh
bm5lbHMgd2hpY2ggbm8gbG9uZ2VyDQo+ID4+PiBleGlzdCAoZHJvcHBlZCkgYWZ0ZXIgY2hhbmdp
bmcgbnVtYmVyIG9mIGNoYW5uZWxzLg0KPiA+Pj4NCj4gPj4+IFsxXSBjb21taXQgZDRhYjQyODYy
NzZmICgiZXRodG9vbDogY29ycmVjdGx5IGVuc3VyZSB7R1N9Q0hBTk5FTFMNCj4gPj4+IGRvZXNu
J3QgY29uZmxpY3Qgd2l0aCBHU3tSWEZIfSIpDQo+ID4+DQo+ID4+IEhhdmUgeW91IG1hZGUgc3Vy
ZSB0aGVyZSBhcmUgbm8gbWFnaWMgZW5jb2RpbmdzIG9mIHF1ZXVlIG51bWJlcnMgdGhpcw0KPiA+
PiB3b3VsZCBicmVhaz8gSSBzZWVtIHRvIHJlY2FsbCBzb21lIHZlbmRvcnMgdXNlZCBtYWdpYyBx
dWV1ZSB2YWx1ZXMgdG8NCj4gPj4gcmVkaXJlY3QgdG8gVkZzIGJlZm9yZSBUQyBhbmQgc3dpdGNo
ZGV2LiBJZiB0aGF0J3MgdGhlIGNhc2Ugd2UnZCBuZWVkDQo+ID4+IHRvIGxvY2F0ZSB0aGUgZHJp
dmVycyB0aGF0IGRvIHRoYXQgYW5kIGZsYWcgdGhlbSBzbyB3ZSBjYW4gZW5mb3JjZSB0aGlzDQo+
ID4+IG9ubHkgZ29pbmcgZm9yd2FyZD8NCj4gPg0KPiA+IEkgYmVsaWV2ZSB0aGVzZSBhbGwgdXNl
IHRoZSBzYW1lIGVuY29kaW5nIGRlZmluZWQgYnkNCj4gPiBldGh0b29sX2dldF9mbG93X3NwZWNf
cmluZyBhbmQgZXRodG9vbF9nZXRfZmxvd19zcGVjX3ZmLCBhdCBsZWFzdA0KPiA+IHRoYXQncyB3
aGF0IGl4Z2JlIHVzZXMuDQo+ID4NCj4gPiBUaGlzIHNldHMgdGhlIGxvd2VyIDMyIGJpdHMgYXMg
dGhlIHF1ZXVlIGluZGV4IGFuZCB0aGUgbmV4dCA4IGJpdHMgYXMNCj4gPiB0aGUgVkYgaWRlbnRp
ZmllciBhcyBkZWZpbmVkIGJ5IEVUSFRPT0xfUlhfRkxPV19TUEVDX1JJTkcgYW5kDQo+ID4gRVRI
VE9PTF9SWF9GTE9XX1NQRUNfUklOR19WRi4NCj4gPg0KPiA+IEl0IGxvb2tzIGxpa2UgdGhpcyBj
aGFuZ2Ugc2hvdWxkIGp1c3QgZXhlbXB0IHJpbmdfY29va2llIHdpdGgNCj4gPiBldGh0b29sX2dl
dF9mbG93X3NwZWNfdmYgYXMgbm9uLXplcm8/DQo+ID4NCj4gPiBXZSBtYXliZSBvdWdodCB0byBt
YXJrIHRoaXMgd2hvbGUgdGhpbmcgYXMgZGVwcmVjYXRlZCBub3cgZ2l2ZW4gdGhlDQo+ID4gYWR2
YW5jZXMgaW4gVEMuDQo+IA0KPiBPaCwgSSB3YXMgbm90IGF3YXJlIG9mIHRoaXMgZW5jb2Rpbmcg
c2NoZW1lLCBzaG91bGRuJ3QgVkYgcnVsZXMgYmUgYWRkZWQNCj4gb24gdGhlIFZGIGludGVyZmFj
ZT8NCj4gV2hhdCBpcyB0aGlzIHVzZWQgZm9yPw0KPiANCg0KSXQncyByYXRoZXIgb2xkLCBhbmQg
dGhlIGlkZWEgd2FzIHRvIGFsbG93IGZvcndhcmRpbmcgdHJhZmZpYyBieSBydWxlcyBpbiB0aGUg
aG9zdC4gSXQgcHJlZGF0ZXMgc3dpdGNoZGV2LCB3aGljaCBJIHRoaW5rIHdvdWxkIGJlIHRoZSBt
b2Rlcm4gbWV0aG9kIG5vdy4NCg0KPiBIb3cgZG9lcyB0aGUgUEYgdmVyaWZ5IHRoZSBydWxlcyBh
cmUgaW4gcmFuZ2UgZm9yIHRoZSBWRiBxdWV1ZXM/DQoNCkkgYmVsaWV2ZSB0aGUgUEYgZHJpdmVy
IGhhcyB0byBjaGVjayB0aGlzLCBhbmQgSSB0aGluayBpdHMgc29ydCBvZiBqdXN0IGEgaGFjay9p
bmRlcGVuZGVudCBvZiB0aGUgUEYgcXVldWVzLiBJIHRoaW5rIGl0IHdvdWxkIGRlcGVuZCBvbiB0
aGUgZHJpdmVyLiBpeGdiZSBrbm93cyBob3cgbWFueSBWRiBxdWV1ZXMgdGhlcmUgYXJlLCBhbmQg
d2hpY2ggb25lcyBiZWxvbmcgdG8gd2hpY2ggVkYuDQoNCkkgc3VzcGVjdCB3ZSBkb24ndCB3YW50
IHRvIHVzZSB0aGlzIG9uIG5ldyBkcml2ZXJzIG9yIGFkZCBpdCB0byBhbnkgZXhpc3RpbmcgZHJp
dmVycyB0aGF0IGRvbid0IGFscmVhZHkgaGF2ZSBpdC4NCg0KPiBBbnl3YXksIEknbGwgZ28gYWhl
YWQgYW5kIHZlcmlmeSB0aGF0IFZGID09IDAgaW4gdGhlIGlmIHN0YXRlbWVudC4NCj4gDQo+IFRo
YW5rcyBmb3IgdGhlIHJldmlldyENCg==
