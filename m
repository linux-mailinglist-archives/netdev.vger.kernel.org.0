Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15826EF16E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbjDZJvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbjDZJvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:51:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04E393
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682502663; x=1714038663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G7WR2xFBzgK4afQEwWGHSqi67etIlTcMmKb/+YAVVbQ=;
  b=ncJHt9pOkZ6hldxESdIav9hTbOPF5riDkzFEPG2cdbFME5ZUev9DGQh2
   NFEmHAaAf1nW6EKEoGI4jZY3G1eX1Pby2Tgcb5a15e99IkRBt5gdwTztb
   6pTfhxVbMDpClElY5pQMl1QZ/XNbUa7hQAN14rFZfjtbhfZAOVPNsbREX
   N/zn9qK2awZTd8Ax8Fn6JX8JZ1R+pliTej5t1C7bxh9fOpSdZNRcl13tD
   3VsK/2pkAjugj8hWraDGxFyY5yk8kMblXCexTC57yFwervy79T0y+JDpD
   cZEgP8E3nXu5L74EEm09b2xntXL6KAaNKIgP4oCdVNpd5cCSmvwsKr792
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="331284542"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="331284542"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 02:51:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="940145180"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="940145180"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 26 Apr 2023 02:50:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 02:50:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 02:50:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 02:50:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 02:50:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvuUWebtoU+r3fcP30qopDE96mMsw4CLj1gJUDW+Y+YqyzXqQJK9eO3tiItdaXqjYAAC87BDPsDIgHNmuNJIpXuyecQL1S1ZpYV4UlDtlF74WZvLsKP9jJRk2KIS0mtnBCJvoCex6wJAc7OpImNNkkWBGnR+NIH8pS5lYuH9uZ8nNZWj109nra8CxkLRDENmQaHfmzy3qiXmLsq163Z0JawlUBpvta6+uN4VHnsv84fyxzMiRO/EA0KTjy9xkIhWdqC6lgkazFyhMLWjN5Gh5ZrkqjXGYLEfunM4tKLPpkkzwIWVp7oTLIz8toXajLkHaD2mv8xp7VKX4lW8RW5RBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7WR2xFBzgK4afQEwWGHSqi67etIlTcMmKb/+YAVVbQ=;
 b=CEC0S8yAeX3O2SteUsNg+9VFNBovz3p4t56hJCmDDSq4ItRkjeMF+iJs7pFDXxsNCC02XmaSBFz7fYCitpSDIVCwE8QkQdWcSY7DdO/u9U1Vq749YorP/YEmRw7c3Zaj2r9ozH42rKYovuslMpV403BHq9QrkWKMfSlRo9ny4d5VSyS8msQkmYWlyHVGKGXkPflpdyU8rIyW+R+SSxSIHFP8OIyFEettynmiA97qizRVLjZkTD0yOT9b7e7O7wyhRHw0cqWlPwATNdMO/bnyIAyU1WcRAUniBJtmMRaRCv2YFIuNnV/CCgqGX3Uj3cHUlhG5WIjPglr/onF8oT9lGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN9PR11MB5484.namprd11.prod.outlook.com (2603:10b6:408:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Wed, 26 Apr
 2023 09:50:57 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 09:50:57 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Topic: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Index: AQHZdFz0yKQvf74srUeucgetCSVNH687uWiggAGmb0A=
Date:   Wed, 26 Apr 2023 09:50:56 +0000
Message-ID: <MW4PR11MB577640D359484E99EB333D05FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-7-wojciech.drewek@intel.com>
 <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
 <MW4PR11MB5776FC269FE6CFAA5B0E73DDFD649@MW4PR11MB5776.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB5776FC269FE6CFAA5B0E73DDFD649@MW4PR11MB5776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BN9PR11MB5484:EE_
x-ms-office365-filtering-correlation-id: 44c33810-b20f-4a51-42c2-08db463bbba9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FFqUE7ubXf2lmB9cQ36CauEwr8w7Nj0TagTLgyeUnYkIwHkzmDQ2mi4naHj+OAsGgK0LUhXN4H0O91EjY5REgsgcchUKJCa6C8NEQC5ygQIh5eFTqy/OQiTrKToE9kQpt5RrJGyB/Vai0zmjjG41l8rJnXHkwRINTWdL4/Pl4Jwa1jzw3VK5FbmIOzrWuzlsASJcxEOygARkgmY+Zt6W+SCgWv9nkT+n9WTD2+xhpv4s9Q8jIlgZ61QUdU4JMg0WNz+pLi9gpAGohSIfIxiisOBREr+uydZrySWxSnxROdae0SK+56vJ4KsLduXVFNMDeJ4uNMdYsElwxnZ1qqZvqeEZBjOwDi0/6CvG7nBcjKQsBqPSxhyT0deF0OymcX0CB9+9e6FSqr4P+F4PmXC1wGkDEooCwS/ZpHQ9QaChWEsb65trqayi1HHYewj12GU0HG8kY5ahI/RRJYrrcUQ6p8m9koJUKP/SdVcj+KIpt29I9xJ9jBuXU9U/jI780bmoaZ6/mJbR+vER5BF9CMdfjmUdPFgGh+2J1cjCnmH3mM12S9WZGfBSEIpF9HX1od9VZ6oWaaFvB1S11X67nKsBZ0pr/z1kIoL1eK/n7jJI2E5uXD2xa4TPT43E4gqHCxBX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199021)(38070700005)(5660300002)(54906003)(82960400001)(122000001)(478600001)(52536014)(186003)(55016003)(66556008)(4326008)(6636002)(66476007)(66446008)(66946007)(316002)(76116006)(64756008)(41300700001)(6862004)(8676002)(8936002)(7696005)(71200400001)(2906002)(38100700002)(6506007)(26005)(9686003)(86362001)(83380400001)(33656002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vi9adzVBTHY2VzlnN0Y1NHRkMzFUVEVPSXZtRk5kNkI5a3J2dmc5UTZtNjhw?=
 =?utf-8?B?OVpaWW5VMDQwZk1OOGVMVVhtVGxSM2dkb0hqL3paclR3Nnczd2xBbjBQZEg1?=
 =?utf-8?B?Yk4zV05JU0I4TFFKYytPM0pLMFBnNEdadmlsS3dwYStaTGxDbTFtRytJNUpO?=
 =?utf-8?B?S09INEVtMGdTUFdZUE9RQUJscnkrakVjTjhDU0J5eE9OMmd6a0tCdnpkSFlt?=
 =?utf-8?B?ekI1TnRmTk53eXExbmVhemtOQW9ITzVWVHQ4cHZmMzJ3K2xKZUZuYmJQdzRt?=
 =?utf-8?B?Y0J1ckVFZ3V1amc0b2NYNm5ueEFmU2czQmN1T0RibkFMNUtXQy83dGo4SEoz?=
 =?utf-8?B?Q0ZieWZtZWVURHRkQXpBRkd2bmEySno3Q3dxb0huWkROWTVHSkk4Z051VTRP?=
 =?utf-8?B?Zkh2bmFYWTFKaVVsMjJXc2d0VWFNOGxaa1R2S0lYWDdqVldKMmtSeDFzOEJx?=
 =?utf-8?B?YzhOVmw2N2dRWlhqUVdjb2lPN2s0VmZldEFVMy84N21KSGRhQytkTk1YZSsw?=
 =?utf-8?B?TUVxSkdmQVFTZXdRUHVucGQ2dHNyekpyRkZldDMrZzFtdjMxOHZ2MXZtMDRU?=
 =?utf-8?B?c1pEWWFhTm90QlVKV0pkRGNwRHg1eE5FelB0RGtEdVdZejJGdVpreHhuQ1Er?=
 =?utf-8?B?ZnZKZkdiczZwb3AxVU81cFdKOG1NeFk3ejVDNTJVUkxkYTJGNEtLMEp5R2FW?=
 =?utf-8?B?eVpaSytINjVMai91N09CNDBaWmJqWWlvUWlYUzM2TVAvM3U1NW9vZDJYakJ4?=
 =?utf-8?B?THEzTzU4MTNHQkZkSHo0WldwUTQ4NStmZVh2TWdJZUJzNFNwK0lyMkN5ZEFa?=
 =?utf-8?B?N2FCN1dvNEg0QmYyK3luSG5KK0RaVEEvTW5UVjVkNE5saGttd0hGRjZlWk5R?=
 =?utf-8?B?a1ZxOEFmOVpSb3hVK3hGU0tsT2t4OERmN2NvWDd2YVo2b1FUOE9NVGVPOXI3?=
 =?utf-8?B?T0FMT1pPZ01keXZQMUpPbkFzYy9RenhBZGZrTWV2SVZmeHhodXQvcG9aVDNl?=
 =?utf-8?B?NDRpMFBnNlBEbVZrd0NvdTNpTm9LWURGWXMvRXljQ3pPcmRVU0VIOEdSZWw3?=
 =?utf-8?B?eVByQ2hOa0xyTjgzbHQ2aFRKckJ6dUd2U3ozQjdNeTJQWXBmSG11VU5VN1gr?=
 =?utf-8?B?c0lURkdHUXptUGEyMzRXWTBiTmVxR1MvSjFTSEg2ODZHWXVZYkhZNTVGK085?=
 =?utf-8?B?ZVd2Qk1qQ0dFb0JpRDZwcmVPV3RnZXNSSjNSQ284emc5eFlQblhxc0puK2RU?=
 =?utf-8?B?cFJ1T1ZuRHdOaVJQbjB4K3g5UWdRaFY5WGRzS1FXeXVUeVJQY3M5N285NGlx?=
 =?utf-8?B?a1diL3R2b0NheG82THN3NkpkQzh5a0d1czFYOVFER2ZrTUhiMkVkWlJQTDN5?=
 =?utf-8?B?WW92SVBBbzFPZk5aTy80VEQrd3FPekQ1bVg4NkJ2MEtDck9yK0gvWEVjYU9W?=
 =?utf-8?B?dEs1eFNlMTg2amxYNXJaR2lodXcrNkdHS1ljYjdLUUNoRExVSjNTa3hmeWlw?=
 =?utf-8?B?NTB5RVhubjkyK3VpbU9pQ2lidDNUNmFrMTczd1h2ajNXZG1TTDVhTmk1YURx?=
 =?utf-8?B?RU5jNEdndXdMM1NGd05ISjVkd3FYaTBmM1BZbWFYN1dEemRGZ0pNNTUzTjBr?=
 =?utf-8?B?Q0JjYStBdkZCSjYxQUxPc1Z3WjRrVHZ5RzZST1ZnQUlsL1kzVjZwQmV4cjI3?=
 =?utf-8?B?UWlucDhTVGdIWkNuckk5WVJua3kzMUw0andHanFQeGdtNWNJMEZYZVY3a3NN?=
 =?utf-8?B?eEY3ZGhzZEx1cGNBTWxQeVltaVZwNG9SV2NjQkxsUGxRMVNqQmZ6T282dUhI?=
 =?utf-8?B?cFl1OEZsZEIrRVVMUlVaeHhEbzErSmw5MGVzTmp1ejR5d0ZiYVRJLzVEeXd0?=
 =?utf-8?B?a1h1N3RxTXQ5OU5HSGNac25GOXhlbGU1a1IvNnVUbE4yWGxyQVpJd3M1MDlG?=
 =?utf-8?B?a2pKZkROUTlONDBhY1o3cTVUNjRhakhmYmZWM3V5bkpldmhqR2t2Sm5QYmZJ?=
 =?utf-8?B?d0xRd3ByeExDQS9Qdm03NkdHZlQwcU50ZTB3Y3RBRGwwTzZHTC9IUEdKMmFj?=
 =?utf-8?B?Q202c3Y0bXVENGNraW5nTkpHY0swMU1ZNWNOclladysxN0Q0QlFGZnFKM1Qy?=
 =?utf-8?Q?cUB+hDjbXGNmyxHHmnLkX4iFW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c33810-b20f-4a51-42c2-08db463bbba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 09:50:56.7959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1T/b7SYZ/U/BiVTrMD1JLv1G3AZPxS0GpctpKnaf4kGilfxWmr+XM6FFnx0oyjT+mnAydJdedRgeRJ2WZpLs4wMmgS+YyYg2O3WqOnfYq2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5484
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRHJld2VrLCBXb2pjaWVj
aA0KPiBTZW50OiB3dG9yZWssIDI1IGt3aWV0bmlhIDIwMjMgMTE6MTgNCj4gVG86IExvYmFraW4s
IEFsZWtzYW5kZXIgPGFsZWtzYW5kZXIubG9iYWtpbkBpbnRlbC5jb20+DQo+IENjOiBpbnRlbC13
aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRXJ0bWFu
LCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+Ow0KPiBtaWNoYWwuc3dpYXRrb3dz
a2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4uc3p5Y2lrQGxpbnV4LmludGVsLmNvbTsgQ2htaWVs
ZXdza2ksIFBhd2VsIDxwYXdlbC5jaG1pZWxld3NraUBpbnRlbC5jb20+Ow0KPiBTYW11ZHJhbGEs
IFNyaWRoYXIgPHNyaWRoYXIuc2FtdWRyYWxhQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6IFtQ
QVRDSCBuZXQtbmV4dCAwNi8xMl0gaWNlOiBBZGQgZ3VhcmQgcnVsZSB3aGVuIGNyZWF0aW5nIEZE
QiBpbiBzd2l0Y2hkZXYNCj4gDQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+IEZyb206IExvYmFraW4sIEFsZWtzYW5kZXIgPGFsZWtzYW5kZXIubG9iYWtpbkBpbnRl
bC5jb20+DQo+ID4gU2VudDogcGnEhXRlaywgMjEga3dpZXRuaWEgMjAyMyAxNjoyMw0KPiA+IFRv
OiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPg0KPiA+IENjOiBp
bnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
TG9iYWtpbiwgQWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT47IEVydG1h
biwgRGF2aWQNCj4gTQ0KPiA+IDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+OyBtaWNoYWwuc3dp
YXRrb3dza2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4uc3p5Y2lrQGxpbnV4LmludGVsLmNvbTsg
Q2htaWVsZXdza2ksIFBhd2VsDQo+ID4gPHBhd2VsLmNobWllbGV3c2tpQGludGVsLmNvbT47IFNh
bXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwuY29tPg0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDYvMTJdIGljZTogQWRkIGd1YXJkIHJ1bGUgd2hlbiBj
cmVhdGluZyBGREIgaW4gc3dpdGNoZGV2DQo+ID4NCj4gPiBGcm9tOiBXb2pjaWVjaCBEcmV3ZWsg
PHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4gRGF0ZTogTW9uLCAxNyBBcHIgMjAyMyAx
MTozNDowNiArMDIwMA0KPiA+DQo+ID4gPiBGcm9tOiBNYXJjaW4gU3p5Y2lrIDxtYXJjaW4uc3p5
Y2lrQGludGVsLmNvbT4NCj4gPiA+DQo+ID4gPiBJbnRyb2R1Y2UgbmV3ICJndWFyZCIgcnVsZSB1
cG9uIEZEQiBlbnRyeSBjcmVhdGlvbi4NCj4gPiA+DQo+ID4gPiBJdCBtYXRjaGVzIG9uIHNyY19t
YWMsIGhhcyB2YWxpZCBiaXQgdW5zZXQsIGFsbG93X3Bhc3NfbDIgc2V0DQo+ID4gPiBhbmQgaGFz
IGEgbm9wIGFjdGlvbi4NCj4gPg0KPiA+IFsuLi5dDQo+ID4NCg0KWy4uLl0NCg0KPiA+DQo+ID4g
PiArCWlmIChlcnIpDQo+ID4gPiArCQlnb3RvIGVycl9hZGRfcnVsZTsNCj4gPiA+ICsNCj4gPiA+
ICsJcmV0dXJuIHJ1bGU7DQo+ID4gPiArDQo+ID4gPiArZXJyX2FkZF9ydWxlOg0KPiA+ID4gKwlr
ZnJlZShsaXN0KTsNCj4gPiA+ICtlcnJfbGlzdF9hbGxvYzoNCj4gPiA+ICsJa2ZyZWUocnVsZSk7
DQo+ID4gPiArZXJyX2V4aXQ6DQo+ID4gPiArCXJldHVybiBFUlJfUFRSKGVycik7DQo+ID4gPiAr
fQ0KPiA+ID4gKw0KPiA+ID4gIHN0YXRpYyBzdHJ1Y3QgaWNlX2Vzd19icl9mbG93ICoNCj4gPiA+
ICBpY2VfZXN3aXRjaF9icl9mbG93X2NyZWF0ZShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBp
Y2VfaHcgKmh3LCB1MTYgdnNpX2lkeCwNCj4gPiA+ICAJCQkgICBpbnQgcG9ydF90eXBlLCBjb25z
dCB1bnNpZ25lZCBjaGFyICptYWMpDQo+ID4gPiAgew0KPiA+ID4gLQlzdHJ1Y3QgaWNlX3J1bGVf
cXVlcnlfZGF0YSAqZndkX3J1bGU7DQo+ID4gPiArCXN0cnVjdCBpY2VfcnVsZV9xdWVyeV9kYXRh
ICpmd2RfcnVsZSwgKmd1YXJkX3J1bGU7DQo+ID4gPiAgCXN0cnVjdCBpY2VfZXN3X2JyX2Zsb3cg
KmZsb3c7DQo+ID4gPiAgCWludCBlcnI7DQo+ID4gPg0KPiA+ID4gQEAgLTE1NSwxMCArMjAyLDIy
IEBAIGljZV9lc3dpdGNoX2JyX2Zsb3dfY3JlYXRlKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0
IGljZV9odyAqaHcsIHUxNiB2c2lfaWR4LA0KPiA+ID4gIAkJZ290byBlcnJfZndkX3J1bGU7DQo+
ID4gPiAgCX0NCj4gPiA+DQo+ID4gPiArCWd1YXJkX3J1bGUgPSBpY2VfZXN3aXRjaF9icl9ndWFy
ZF9ydWxlX2NyZWF0ZShodywgdnNpX2lkeCwgbWFjKTsNCj4gPiA+ICsJaWYgKElTX0VSUihndWFy
ZF9ydWxlKSkgew0KPiA+ID4gKwkJZXJyID0gUFRSX0VSUihndWFyZF9ydWxlKTsNCj4gPg0KPiA+
IEFhYWggb2ssIHRoYXQncyB3aGF0IHlvdSBtZWFudCBpbiB0aGUgcHJldmlvdXMgbWFpbHMuIEkg
c2VlIG5vdy4NCj4gPiBZb3UgY2FuIGVpdGhlciBsZWF2ZSBpdCBsaWtlIHRoYXQgb3IgdGhlcmUn
cyBhbiBhbHRlcm5hdGl2ZSAtLSBwaWNrIHRoZQ0KPiA+IG9uZSB0aGF0IHlvdSBsaWtlIHRoZSBt
b3N0Og0KPiA+DQo+ID4gCWd1YXJkX3J1bGUgPSBpY2VfZXN3aXRjaF8uLi4NCj4gPiAJZXJyID0g
UFRSX0VSUihndWFyZF9ydWxlKTsNCj4gPiAJaWYgKGVycikgew0KPiA+IAkJLi4uDQo+ID4NCj4g
DQo+IEkgbGlrZSBpdCwgbGVzcyBwdHIgPC0+IG1hY3Jvcw0KDQpBY3R1YWxseSBpdCB3b24ndCB3
b3JrLCBQVFJfRVJSIHdvdWxkIG5vdCBjb252ZXJ0IHBvaW50ZXIgdG8gMCBpbiBjYXNlIG9mIHN1
Y2Nlc3MuDQoNCj4gDQo+ID4gPiArCQlkZXZfZXJyKGRldiwgIkZhaWxlZCB0byBjcmVhdGUgZXN3
aXRjaCBicmlkZ2UgJXNncmVzcyBndWFyZCBydWxlLCBlcnI6ICVkXG4iLA0KPiA+ID4gKwkJCXBv
cnRfdHlwZSA9PSBJQ0VfRVNXSVRDSF9CUl9VUExJTktfUE9SVCA/ICJlIiA6ICJpbiIsDQo+ID4g
PiArCQkJZXJyKTsNCj4gPg0KPiA+IFlvdSBzdGlsbCBjYW4gcHJpbnQgaXQgdmlhICIlcGUiICsg
QGd1YXJkX3J1bGUgaW5zdGVhZCBvZiBAZXJyIDpwIChzYW1lDQo+ID4gd2l0aCBAZndkX3J1bGUg
YWJvdmUpDQo+ID4NCj4gPiA+ICsJCWdvdG8gZXJyX2d1YXJkX3J1bGU7DQo+ID4gPiArCX0NCj4g
PiA+ICsNCj4gPiA+ICAJZmxvdy0+ZndkX3J1bGUgPSBmd2RfcnVsZTsNCj4gPiA+ICsJZmxvdy0+
Z3VhcmRfcnVsZSA9IGd1YXJkX3J1bGU7DQo+ID4gPg0KPiA+ID4gIAlyZXR1cm4gZmxvdzsNCj4g
Pg0KPiA+IFsuLi5dDQo+ID4NCj4gPiA+IEBAIC00NjI0LDcgKzQ2MjgsNyBAQCBzdGF0aWMgc3Ry
dWN0IGljZV9wcm90b2NvbF9lbnRyeSBpY2VfcHJvdF9pZF90YmxbSUNFX1BST1RPQ09MX0xBU1Rd
ID0gew0KPiA+ID4gICAqLw0KPiA+ID4gIHN0YXRpYyB1MTYNCj4gPiA+ICBpY2VfZmluZF9yZWNw
KHN0cnVjdCBpY2VfaHcgKmh3LCBzdHJ1Y3QgaWNlX3Byb3RfbGt1cF9leHQgKmxrdXBfZXh0cywN
Cj4gPiA+IC0JICAgICAgZW51bSBpY2Vfc3dfdHVubmVsX3R5cGUgdHVuX3R5cGUpDQo+ID4gPiAr
CSAgICAgIHN0cnVjdCBpY2VfYWR2X3J1bGVfaW5mbyAqcmluZm8pDQo+ID4NCj4gPiBDYW4gYmUg
Y29uc3QgSSB0aGluaz8NCj4gDQo+IEFncmVlDQo+IA0KPiA+DQo+ID4gPiAgew0KPiA+ID4gIAli
b29sIHJlZnJlc2hfcmVxdWlyZWQgPSB0cnVlOw0KPiA+ID4gIAlzdHJ1Y3QgaWNlX3N3X3JlY2lw
ZSAqcmVjcDsNCj4gPg0KPiA+IFsuLi5dDQo+ID4NCj4gPiA+IEBAIC01MDc1LDYgKzUwODIsMTQg
QEAgaWNlX2FkZF9zd19yZWNpcGUoc3RydWN0IGljZV9odyAqaHcsIHN0cnVjdCBpY2Vfc3dfcmVj
aXBlICpybSwNCj4gPiA+ICAJCXNldF9iaXQoYnVmW3JlY3BzXS5yZWNpcGVfaW5keCwNCj4gPiA+
ICAJCQkodW5zaWduZWQgbG9uZyAqKWJ1ZltyZWNwc10ucmVjaXBlX2JpdG1hcCk7DQo+ID4gPiAg
CQlidWZbcmVjcHNdLmNvbnRlbnQuYWN0X2N0cmxfZndkX3ByaW9yaXR5ID0gcm0tPnByaW9yaXR5
Ow0KPiA+ID4gKw0KPiA+ID4gKwkJaWYgKHJtLT5uZWVkX3Bhc3NfbDIpDQo+ID4gPiArCQkJYnVm
W3JlY3BzXS5jb250ZW50LmFjdF9jdHJsIHw9DQo+ID4gPiArCQkJCUlDRV9BUV9SRUNJUEVfQUNU
X05FRURfUEFTU19MMjsNCj4gPiA+ICsNCj4gPiA+ICsJCWlmIChybS0+YWxsb3dfcGFzc19sMikN
Cj4gPiA+ICsJCQlidWZbcmVjcHNdLmNvbnRlbnQuYWN0X2N0cmwgfD0NCj4gPiA+ICsJCQkJSUNF
X0FRX1JFQ0lQRV9BQ1RfQUxMT1dfUEFTU19MMjsNCj4gPg0KPiA+IEkgZG9uJ3QgbGlrZSB0aGVz
ZSBsaW5lIGJyZWFrcyA6cw0KPiA+DQo+ID4gCQl0eXBlX29mX2NvbnRlbnQgKmNvbnQ7DQo+ID4g
CQkuLi4NCj4gPg0KPiA+IAkJLyogQXMgZmFyIGFzIEkgY2FuIHNlZSwgaXQgY2FuIGJlIHVzZWQg
YWJvdmUgYXMgd2VsbCAqLw0KPiA+IAkJY29udCA9ICZidWZbcmVjcHNdLmNvbnRlbnQ7DQo+ID4N
Cj4gPiAJCWlmIChybS0+bmVlZF9wYXNzX2wyKQ0KPiA+IAkJCWNvbnQtPmFjdF9jdHJsIHw9IElD
RV9BUV9SRUNJUEVfQUNUX05FRURfUEFTU19MMjsNCj4gPiAJCWlmIChybS0+YWxsb3dfcGFzc19s
MikNCj4gPiAJCQljb250LT5hY3RfY3RybCB8PSBJQ0VfQVFfUkVDSVBFX0FDVF9BTExPV19QQVNT
X0wyOw0KPiA+DQo+ID4gPiAgCQlyZWNwcysrOw0KPiA+ID4gIAl9DQo+ID4gPg0KPiA+DQo+ID4g
Wy4uLl0NCj4gPg0KPiA+ID4gQEAgLTYxNjYsNiArNjE5MCwxMSBAQCBpY2VfYWRkX2Fkdl9ydWxl
KHN0cnVjdCBpY2VfaHcgKmh3LCBzdHJ1Y3QgaWNlX2Fkdl9sa3VwX2VsZW0gKmxrdXBzLA0KPiA+
ID4gIAkJYWN0IHw9IElDRV9TSU5HTEVfQUNUX1ZTSV9GT1JXQVJESU5HIHwgSUNFX1NJTkdMRV9B
Q1RfRFJPUCB8DQo+ID4gPiAgCQkgICAgICAgSUNFX1NJTkdMRV9BQ1RfVkFMSURfQklUOw0KPiA+
ID4gIAkJYnJlYWs7DQo+ID4gPiArCWNhc2UgSUNFX05PUDoNCj4gPiA+ICsJCWFjdCB8PSAocmlu
Zm8tPnN3X2FjdC5md2RfaWQuaHdfdnNpX2lkIDw8DQo+ID4gPiArCQkJSUNFX1NJTkdMRV9BQ1Rf
VlNJX0lEX1MpICYgSUNFX1NJTkdMRV9BQ1RfVlNJX0lEX007DQo+ID4NCj4gPiBgRklFTERfUFJF
UChJQ0VfU0lOR0xFX0FDVF9WU0lfSURfTSwgcmluZm8tPnN3X2FjdC5md2RfaWQuaHdfdnNpX2lk
KWA/DQo+ID4NCj4gPiA+ICsJCWFjdCAmPSB+SUNFX1NJTkdMRV9BQ1RfVkFMSURfQklUOw0KPiA+
ID4gKwkJYnJlYWs7DQo+ID4gPiAgCWRlZmF1bHQ6DQo+ID4gPiAgCQlzdGF0dXMgPSAtRUlPOw0K
PiA+ID4gIAkJZ290byBlcnJfaWNlX2FkZF9hZHZfcnVsZTsNCj4gPiA+IEBAIC02NDQ2LDcgKzY0
NzUsNyBAQCBpY2VfcmVtX2Fkdl9ydWxlKHN0cnVjdCBpY2VfaHcgKmh3LCBzdHJ1Y3QgaWNlX2Fk
dl9sa3VwX2VsZW0gKmxrdXBzLA0KPiA+ID4gIAkJCXJldHVybiAtRUlPOw0KPiA+ID4gIAl9DQo+
ID4gPg0KPiA+ID4gLQlyaWQgPSBpY2VfZmluZF9yZWNwKGh3LCAmbGt1cF9leHRzLCByaW5mby0+
dHVuX3R5cGUpOw0KPiA+ID4gKwlyaWQgPSBpY2VfZmluZF9yZWNwKGh3LCAmbGt1cF9leHRzLCBy
aW5mbyk7DQo+ID4gPiAgCS8qIElmIGRpZCBub3QgZmluZCBhIHJlY2lwZSB0aGF0IG1hdGNoIHRo
ZSBleGlzdGluZyBjcml0ZXJpYSAqLw0KPiA+ID4gIAlpZiAocmlkID09IElDRV9NQVhfTlVNX1JF
Q0lQRVMpDQo+ID4gPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3N3aXRjaC5oIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaWNlL2ljZV9zd2l0Y2guaA0KPiA+ID4gaW5kZXggYzg0YjU2ZmU4NGE1Li41
ZWNjZTM5Y2YxZjUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pY2UvaWNlX3N3aXRjaC5oDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pY2UvaWNlX3N3aXRjaC5oDQo+ID4gPiBAQCAtMTkxLDYgKzE5MSw4IEBAIHN0cnVjdCBpY2Vf
YWR2X3J1bGVfaW5mbyB7DQo+ID4gPiAgCXUxNiB2bGFuX3R5cGU7DQo+ID4gPiAgCXUxNiBmbHRy
X3J1bGVfaWQ7DQo+ID4gPiAgCXUzMiBwcmlvcml0eTsNCj4gPiA+ICsJdTggbmVlZF9wYXNzX2wy
Ow0KPiA+ID4gKwl1OCBhbGxvd19wYXNzX2wyOw0KPiA+DQo+ID4gVGhleSBjYW4gYmUgZWl0aGVy
IHRydWUgb3IgZmFsc2UsIG5vdGhpbmcgZWxzZSwgcmlnaHQ/IEknZCBtYWtlIHRoZW0NCj4gPiBv
Y2N1cHkgMSBiaXQgcGVyIHZhciB0aGVuOg0KPiANCj4gQ29ycmVjdA0KPiANCj4gPg0KPiA+IAl1
MTYgbmVlZF9wYXNzX2wyOjE7DQo+ID4gCXUxNiBhbGxvd19wYXNzX2wyOjE7DQo+ID4gCXUxNiBz
cmNfdnNpOw0KPiA+DQo+ID4gKzE0IGZyZWUgYml0cyBmb3IgbW9yZSBmbGFncywgbm8gaG9sZXMg
KHN0YWNrZWQgd2l0aCA6OnNyY192c2kpLg0KPiA+DQo+ID4gPiAgCXUxNiBzcmNfdnNpOw0KPiA+
ID4gIAlzdHJ1Y3QgaWNlX3N3X2FjdF9jdHJsIHN3X2FjdDsNCj4gPiA+ICAJc3RydWN0IGljZV9h
ZHZfcnVsZV9mbGFnc19pbmZvIGZsYWdzX2luZm87DQo+ID4gPiBAQCAtMjU0LDYgKzI1Niw5IEBA
IHN0cnVjdCBpY2Vfc3dfcmVjaXBlIHsNCj4gPiA+ICAJICovDQo+ID4gPiAgCXU4IHByaW9yaXR5
Ow0KPiA+ID4NCj4gPiA+ICsJdTggbmVlZF9wYXNzX2wyOw0KPiA+ID4gKwl1OCBhbGxvd19wYXNz
X2wyOw0KPiA+DQo+ID4gKHNhbWUgd2l0aCBiaXRmaWVsZHMgaGVyZSwganVzdCB1c2UgdTggOjEg
aW5zdGVhZCBvZiB1MTYgaGVyZSB0byBzdGFjaw0KPiA+ICB3aXRoIDo6cHJpb3JpdHkpDQo+ID4N
Cj4gPiA+ICsNCj4gPiA+ICAJc3RydWN0IGxpc3RfaGVhZCByZ19saXN0Ow0KPiA+DQo+ID4gWy4u
Ll0NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBPbGVrDQoNCg==
