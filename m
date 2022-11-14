Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D376286FF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiKNRZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiKNRZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:25:32 -0500
Received: from DM6PR05CU003-vft-obe.outbound.protection.outlook.com (mail-centralusazon11023015.outbound.protection.outlook.com [52.101.64.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8481571D;
        Mon, 14 Nov 2022 09:25:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQm6OcUzl1i2GL2jZyktkzyUMqqjYJKys7PSpUjrueWRHJPHbzSxaaKm+bWfqrWXFxlGxUbtxC3LnaXm+P6FQscGxaCQrpO3BHPFWq2IfermDXCgRN32jxwCvlsjN5sIBhWerflZBta7bgOo1W5H/hipCcIIWy/9+dqgFfaNCxbVQk06JZMx/Pr0NR1jarFgH7LMA++O9eWwiS45+9+OZO4yB5afC+j+Wmh+CnvhA5Ir+BhJ7MfiS11tTPK7jZ1IH27pogn5ZSlvmkQ++u9QLxhYMEWwygM9ygZyqy+jfU9+4Mpvbp8GBlBZAZJcyIVcY+tICJeXNqeRJg/xDFsF4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yE9D6MUPl49ZGLTRjsAW+RaQsowmBQ97HZprGamDnqw=;
 b=QNrx6YEQK0VLRw7G7ziOTdI+7KHAveS9AwoL9Y4QPPDkJvEUTpgwVlGPi4JSmTs0LdGI3Vwj4PL4TWwIQ5xJR+TMXIz3wroUKf20BqXhd7p2NxQX7z5roNPpHV5vcXKNdHoODdctHzI/i9jOmcSFoTC+eWeys7SDxmAwArPWPlE9kSAfbdHtxXEyeeIbII6rZkg+CyRQxyIP2cLZGtmUEvBXoXFdlrkxfvId3ykSmq9cQhliwKxB2MNRTlGrOJL23UGUG8axqunUHYKeR0gr8swqe5oDaMhRJwSbKW93WOHfxf/frLP5oDiwhQnjvOYaoJNcj/olAsWiNmSP9a0u2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yE9D6MUPl49ZGLTRjsAW+RaQsowmBQ97HZprGamDnqw=;
 b=js/c4R9LOFKd0kwIHAjmTuRX7GG31hCn8CGICTaUQlXnrZrdo2zQJ8VDI1IGYxmSlDF7WlCAdPFi+utKw4ILxt+Jxw9KndhBpAk3iscf/rTHDYIjuxrf9wzCXlahvzB2IuzvZMapwnqGT/RFmfT7nQcVVeI2/sIZDHlMnbiEZyk=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN2PR21MB1405.namprd21.prod.outlook.com (2603:10b6:208:203::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Mon, 14 Nov
 2022 17:25:19 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7%3]) with mapi id 15.20.5834.006; Mon, 14 Nov 2022
 17:25:19 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Topic: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Index: AQHY9ZXvB05GbI897ESEeyxWArQdDq4+pF2AgAADf1CAAAFrgIAAAVqg
Date:   Mon, 14 Nov 2022 17:25:19 +0000
Message-ID: <BYAPR21MB1688B9B05B7796FD8D7D50DDD7059@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
 <feca1a0a-b9b2-44d9-30e9-c6a6aa11f6cd@intel.com>
 <BYAPR21MB1688430B2111541FE68D3569D7059@BYAPR21MB1688.namprd21.prod.outlook.com>
 <10a4eb94-4764-717b-7c20-64a3d895b3d1@intel.com>
In-Reply-To: <10a4eb94-4764-717b-7c20-64a3d895b3d1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e87849b4-1bc4-480a-aebc-14a92cc1e05f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-14T17:02:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN2PR21MB1405:EE_
x-ms-office365-filtering-correlation-id: 1ab02955-91a6-4211-7085-08dac66533e2
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: spVAqXorag2rRJp9RAjoSSrUr16G9qheWNQW7TeeHe7pBIpn69PIGh88ZupbLUljqgJtwtpZF1O8LAfg1mKxkww2rdXCc5E0WK0CWhC+LD0T2NnQ9kOZf0KlgrZLM99eqjMU8mxriRIf1BmiF7HPzGozaA4ZFiRoFY+WPJrysQPYB0EQK4xeH325njplgz2pR2dtnzXMGkRXDt18ky7T1OU++QVuD61NNRQJaUIOXGiYTCTNF1wrZL3AMDVp9Bjp83FFMFYEYsDoL+/dTJgRUWgCWYN0cHTZNagTNRnS2es4xocgN+gctIdz4nBlZMYGArpFFSNrf2jbJ/cF8nC1jyjBzZVi/I8iDys720WgIxrOoM4CGhJhG+rLvKT+9YoDEtHiKbcdeHivQyF6QikLhua3rX1mgM6vbPmjJ8WYw3LoLz3lurbvExbO6L2Gyj748HxCSeEc9kHfl06//SVHvG6Mdlmqd3ll4XINe9w3XIEL/3+2FGGRgOoXc7xvQEIeGXiUwLeNt4xcBXrbcxUeRzE0Cmy0NWghUuEWK9Ggv0SU+2d7h+QDDcG6bJ8E/e8GtE4Ix84EQ5Jk+qF6XzbIDMId1JFo45aq5oy6rbf5NpuORHkjHfWLPxWoJpzebC2Y2rd6G1Os7+exQaKBuwsuOjwXaFYE/haHDIL0N345hBDPUES9jIrHn8iVs/DX0BYM1/6bnNRaIfprfSZ9cNMw8s8T8oIu9IMxlieC1OiVdmI8nImIFyswvkdD0CN7fPZNqW/baCYFqmzSHZuk8ouEW2t1ZyD4Q09IoqmxY0ZCAzvmOUjIdkOu+RrnW8NUKUiYlsyDSO4C/y5g1xUka7uc1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199015)(38100700002)(82960400001)(8990500004)(82950400001)(921005)(38070700005)(478600001)(66556008)(66476007)(66446008)(316002)(71200400001)(2906002)(64756008)(122000001)(66946007)(76116006)(8676002)(7406005)(7416002)(6506007)(86362001)(9686003)(5660300002)(55016003)(7696005)(110136005)(26005)(53546011)(8936002)(186003)(52536014)(33656002)(10290500003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTR3OGt0WllsL0N1S0dwWDN1eE5YczJ3WHhtTit5dU4yenBVNEVSajQ5Y3py?=
 =?utf-8?B?OVdNZUw3bDNKeHF6QW42eGJLVUFGS0lwbDVOaThna2hOZjY0Y2NEczQzckM5?=
 =?utf-8?B?dlozUTR5dmk2K3FCVVRGeURLK3ZSblZyand2WnNSQXZJeTB2SFlWeFU5Rktx?=
 =?utf-8?B?cWg5Z2tQR0hlT1UzTHUrbGVTZG0zd1Z3ZndJcWNteDFEMHhvY1IvQzFlb01u?=
 =?utf-8?B?K0hVdnlFcTFHQzhuMHpNL1pPTFllUFZkdkY5VnJHT0lja2ExOFJFQVNSaVVr?=
 =?utf-8?B?SHNMOFU4ZDdNaVQvNGpxUUtOZUhzSkZPdFpxNjRJSlVXMVlNUlVJYVU2OGtX?=
 =?utf-8?B?bEJrVE1BckZ5QlpsRE4wZ1JYRE5YOVVIeGRPWXo0UG1NTGxVYUcyRUFHUXc2?=
 =?utf-8?B?Q0JZbGw1OCtGSStwcFR5VDI1QUwyYnhoYWRFczBJTWgzSXlKK3daL0hTbTFR?=
 =?utf-8?B?ODZiemVzdzhTKzhUcVFWbzVZYk9tL2U1bXFOc0xLOVJ4eGV5ZjFmWVpvOUFl?=
 =?utf-8?B?MHNubnF1bWhpT203MUluSGtDSDF5RmgzY01abm9nTk1TYzhYOG5BT2pLbzBK?=
 =?utf-8?B?cFZjazU3Y0Z0ejZQRGJ4d2FHTmtXcWUxVzYzYUtkc01lV09kU0RBdUtvWCsw?=
 =?utf-8?B?SUVCS1dwZzNsQ0UrQVAwNkIzT1gzYzhFcDZvTlBuT2M2K2RWeDNRL1pxdmV2?=
 =?utf-8?B?Ym1YZ2Z6bW9mRlA1QWdJSDhiRlJOUmdSb0tOcEFhZUhQV2tiQ1kvR0xEcWo2?=
 =?utf-8?B?ODFnU3dtUHdvbzRlTkQ5OFlWYk44T1dlVWxUNUFXVG5Yc2kycVlwSG1xb3Qz?=
 =?utf-8?B?Q3ZUWkJGTkRHUEhodEYxNm1IRmFpNDNDOUI5blFGeUpSbWJuYVF6MzFXdnY0?=
 =?utf-8?B?dWtsWlNxSSs0L2t1NnNTVytzTngwWXNhVEt3eVc2cE1OWGw1MCthWCtLa0Z6?=
 =?utf-8?B?RUZaRU5UL29NeXR6MWhEeXVWelJhc1JnK29WbUdUK0g4Vy9pOFlTOUxvWTVK?=
 =?utf-8?B?WWMwdVhOTzgyQlZlaHdVZHFMUk9PQmFWSEZUSVFwSU5YMFh6RSt4YVVMOG9h?=
 =?utf-8?B?ZTNpUDNRSElvZzlpVjFFNUs1M1RScnd2VDRYZU5LajJVVVo3anAxbENFZlZn?=
 =?utf-8?B?dlBraFVTOTVWalZpUVkvSHIxN2RWdUNwMTJ4bzNQKzNUU3RsN05UNWxEMjQv?=
 =?utf-8?B?UDVTSGhGdXZodkxMb09lTlB4Zi9kMzQ0MmdlMFViSjE0aTk2NjZ3dXJ2RGov?=
 =?utf-8?B?cmNwTGltQW5oWkZJUFlDZFBDVjVtQUlWSnQvY3Y5M0FVTFNpSEwxNTN6Sm9v?=
 =?utf-8?B?Z2hvb0Jweks3MGsrSFQyS0g5ekJIN3Q4Ky9SRGNlK29tWkRrV0JPQzBybHhi?=
 =?utf-8?B?MU5uMDVWLzcxbDR3anlqcmN5U25DQ0dNb3h3YzBYbVZpVi9UM2lZZjJKK0Ex?=
 =?utf-8?B?N0hPZlFwTkR3eVU2bGVJemVXVGU4RVFabWNmTUtmK3ZQZFc0Rk05eXVrdzly?=
 =?utf-8?B?QmxuMW1BRWVneDFvQnZBY0JjdTdFck9wYmkybzIyL1hkY05QZFZqVUVLQ3hF?=
 =?utf-8?B?TG9HR3psRSsxNi9pYUNzTlRhS3l2RkRlU0RqT3JIZDZlV0ZERjN6M05LZXpN?=
 =?utf-8?B?WnlianZtWE1YK282UEZYQ0krTk93SWhicFVHYnliVHh5cXFkajlMTTJEZFNQ?=
 =?utf-8?B?N3ovOUJTTGpTV3oyZzFGYnQ4K3VGd2JSampJVWFKay9DOUEzSmJZY3FyZ1pB?=
 =?utf-8?B?d2ZVK0U2TGdCRGE2Nzk4L0tJNDJ4UlhvNmo2UmRQbUF2OGVXYzFURHNuK3U2?=
 =?utf-8?B?WUpqdnNmYzVzVmNkM2thbWE4SCtKMGFPUXAvYkhRNUthTkpGMVpZZDdvcUts?=
 =?utf-8?B?L1R5UG5IYXp5Wk8weHBzOHE4YktoampNeFZBZnAyZ1V2UE5PNmlXK0g0c2Yv?=
 =?utf-8?B?Y1UyMmE1QUxKSU56VmVGaEdxSHN4b2p0TTVFc281bkk4SWlXUnpFdVlra2pG?=
 =?utf-8?B?UEY5L1BjdHhwa2JEZjVxeTBoT285OWJzUVZzZUlhQUhPWUxReEREVmFTcFVn?=
 =?utf-8?B?OGFnNFA5UHBqU3QwQ0ZyZ3prLzZTZnJONmVyb2plNVBKOGV1UjBkT2tFY3Vw?=
 =?utf-8?B?ZXhMU0ZDdTlPNy9xdzFqZTcrMEpwME03d01Bamo2OWlraWw5SWZselpQWTNt?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab02955-91a6-4211-7085-08dac66533e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 17:25:19.0340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHsPxQ+tyqz/HPvp6AOoV4JnS07BE3MWKIJtHrtWmOInEVMXv5dQ4DeA9LGhspTwAJD+4NJlc7anxMVTEZoavGIClGbubg08b+pJVgi3BVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1405
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogTW9uZGF5LCBO
b3ZlbWJlciAxNCwgMjAyMiA4OjU4IEFNDQo+IA0KPiBPbiAxMS8xNC8yMiAwODo1MywgTWljaGFl
bCBLZWxsZXkgKExJTlVYKSB3cm90ZToNCj4gPj4gQmVjYXVzZSwgZmlyc3Qgb2YgYWxsLCB0aGF0
ICJNYXBwaW5ncyBoYXZlIHRvIGJlIHBhZ2UtYWxpZ25lZCIgdGhpbmcgaXMNCj4gPj4gKG5vdykg
ZG9pbmcgbW9yZSB0aGFuIHBhZ2UtYWxpZ25pbmcgdGhpbmdzLiAgU2Vjb25kLCB0aGUgbW9tZW50
IHlvdSBtYXNrDQo+ID4+IG91dCB0aGUgbWV0YWRhdGEgYml0cywgdGhlICdzaXplJyBjYWxjdWxh
dGlvbiBnZXRzIGhhcmRlci4gIERvaW5nIGl0IGluDQo+ID4+IHR3byBwaGFzZXMgKHBhZ2UgYWxp
Z25tZW50IGZvbGxvd2VkIGJ5IG1ldGFkYXRhIGJpdCBtYXNraW5nKSBicmVha3MgdXANCj4gPj4g
dGhlIHR3byBsb2dpY2FsIG9wZXJhdGlvbnMuDQo+ID4+DQo+ID4gV29yayBmb3IgbWUuICBXaWxs
IGRvIHRoaXMgaW4gdjMuDQo+IA0KPiBLaXJpbGwgYWxzbyBtYWRlIGEgZ29vZCBwb2ludCBhYm91
dCBURFg6IGl0IGlzbid0IGFmZmVjdGVkIGJ5IHRoaXMNCj4gYmVjYXVzZSBpdCBhbHdheXMgcGFz
c2VzICpyZWFsKiAobm8gbWV0YWRhdGEgYml0cyBzZXQpIHBoeXNpY2FsDQo+IGFkZHJlc3NlcyBp
biBoZXJlLiAgQ291bGQgeW91IGRvdWJsZSBjaGVjayB0aGF0IHlvdSBkb24ndCB3YW50IHRvIGRv
IHRoZQ0KPiBzYW1lIGZvciB5b3VyIGNvZGU/DQo+IA0KDQpZZXMsIHdlIHdhbnQgdG8gZG8gdGhl
IHNhbWUgZm9yIHRoZSBIeXBlci1WIHZUT00gY29kZS4gICBBbmQgd2hlbiB0aGlzDQpmdWxsIHBh
dGNoIHNldCBpcyBhcHBsaWVkLCB3ZSdyZSBvbmx5IHBhc3NpbmcgaW4gKnJlYWwqIHBoeXNpY2Fs
IGFkZHJlc3NlcyBhbmQNCmFyZSBub3QgZGVwZW5kaW5nIG9uIF9faW9yZW1hcF9jYWxsZXIoKSBk
b2luZyBhbnkgbWFza2luZy4NCg0KQnV0IHRoaXMgcGF0Y2ggc2V0IGlzIGV4ZWN1dGluZyBhIHRy
YW5zaXRpb24gZnJvbSBjdXJyZW50IGNvZGUsIHdoaWNoIHBhc3Nlcw0KcGh5c2ljYWwgYWRkcmVz
c2VzIHdpdGggbWV0YWRhdGEgYml0cyBzZXQgKGkuZS4sIHRoZSB2VE9NIGJpdCksIHRvIHRoZSBu
ZXcNCmFwcHJvYWNoLCB3aGljaCBkb2VzIG5vdC4gIFRoZXJlIGFyZSBzZXZlcmFsIHBsYWNlcyBp
biB0aGUgY3VycmVudCBIeXBlci1WDQp2VE9NIGNvZGUgdGhhdCBuZWVkIGNoYW5nZXMgdG8gbWFr
ZSB0aGlzIHRyYW5zaXRpb24uICBUaGVzZSBjaGFuZ2VzIGFyZQ0Kbm9uLXRyaXZpYWwsIGFuZCBJ
IGRvbid0IHdhbnQgdG8gaGF2ZSB0byBjcmFtIHRoZW0gYWxsIGludG8gb25lIGJpZyBwYXRjaC4N
CkJ5IG1ha2luZyB0aGlzIGZpeCwgdGhlIGN1cnJlbnQgY29kZSBjb250aW51ZXMgdG8gd29yayB0
aHJvdWdob3V0IHRoaXMNCnBhdGNoIHNlcmllcyB3aGlsZSB0aGUgY2hhbmdlcyBhcmUgaW5jcmVt
ZW50YWxseSBtYWRlIGluIG11bHRpcGxlDQppbmRpdmlkdWFsIHBhdGNoZXMuICBCdXQgd2hlbiBp
dCdzIGFsbCBkb25lLCB3ZSB3b24ndCBiZSBwYXNzaW5nIGFueQ0KcGh5c2ljYWwgYWRkcmVzc2Vz
IHdpdGggdGhlIHZUT00gYml0IHNldC4NCg0KTm90ZSB0aGF0IGN1cnJlbnQgY29kZSB3b3JrcyBh
bmQgZG9lc24ndCBoaXQgdGhlIGJ1ZyBiZWNhdXNlIHRoZQ0KZ2xvYmFsIHZhcmlhYmxlIHBoeXNp
Y2FsX21hc2sgaW5jbHVkZXMgdGhlIHZUT00gYml0IGFzIHBhcnQgb2YgdGhlDQpwaHlzaWNhbCBh
ZGRyZXNzLiAgQnV0IFBhdGNoIDUgb2YgdGhlIHNlcmllcyByZW1vdmVzIHRoZSB2VE9NIGJpdA0K
ZnJvbSBwaHlzaWNhbF9tYXNrLiAgQXQgdGhhdCBwb2ludCwgdGhlIGN1cnJlbnQgX19pb3JlbWFw
X2NhbGxlcigpDQpjb2RlIGJyZWFrcyBkdWUgdG8gdGhlIGJ1Zy4gIEJ5IGZpeGluZyB0aGUgYnVn
LCB0aGUgY3VycmVudCBIeXBlci1WDQp2VE9NIGNvZGUgY29udGludWVzIHRvIHdvcmsgdW50aWwg
YWxsIHRoZSBjaGFuZ2VzIGNhbiBiZSBjb21wbGV0ZWQNCih3aGljaCBpcyBQYXRjaCAxMCBvZiB0
aGUgc2VyaWVzKS4NCg0KUGVyaGFwcyBpdCdzIGNvbnZvbHV0ZWQsIGJ1dCBiYXNpY2FsbHkgSSdt
IHRyeWluZyB0byBhdm9pZCBoYXZpbmcgdG8gbWVyZ2UNClBhdGNoZXMgNSB0aHJ1IDEwIGludG8g
b25lIGJpZyBwYXRjaC4gIEFuZCBzaW5jZSB0aGUgY3VycmVudA0KX19pb3JlbWFwX2NhbGxlcigp
IGlzIHdyb25nIGFueXdheSwgZml4aW5nIGl0IG1hZGUgZXZlcnl0aGluZyBzbW9vdGhlci4NCg0K
TWljaGFlbA0KDQo=
