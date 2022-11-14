Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE249628611
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbiKNQxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiKNQxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:53:42 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020024.outbound.protection.outlook.com [40.93.198.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897897671;
        Mon, 14 Nov 2022 08:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjAFn0hQdmVf0/z0GujKoeb1xdQgMMSrCjpwimqJYrOstrP2cC65v+6lUCqmofJxrLu7yezy9i0v5ne6yzOmqhf8Vnu5Ubykbd/PYqJykZYTp0hxlcnyLTw73kupCeo3K3G6LufCuqy19FX0DrNwNrcv8pRRUtjRIGPKvKUZsvURolh65kd/xI2zsAJTojVJeq9ROQmaFdsaGjM97xqGUQCclkOswqcPwNZb7bRd/IdaWtalU6iIbfM1QutFeAC7t5Ba9IiRPYb2Ev/ld3C8Oy0w79Pih9Nn1aj9rkBHTB6OuyGEBkVkxGJET1Zy+aliPhosCM+/V08SnvhiwU0ERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI7T54HKAYBKorO1edEDaslKJTl+nRjGTBwh87lx0uw=;
 b=OsqebSeFXAQ94VH1sQeT5MJJ90kzhsAhH7ve/3Q+Bk8g6o7o77VrVZ+wF/2W9cUdb4ogJKDR7bm+U+r8N21Uc9hrzR6XeFdUMgDid5f5Hd2JGzmaAyomFgIzD0OqYKjD/Dl5QINl8OVZ2k/8b6AaFe3OVxuwMOQvkqXqUA94JuBdz0QmXoufQCzvni8b3/wzCcPO+NnFx0yOH6EeU6GuZDXXjwodPRCJAD0bwVmrSZhJ8iqCzPerynSCoyP5ssyWUK6GlLrkjoOnB6zca4jxC3oq17HWye1PZLH57WK9lxe/Qk1KePY2wAZ2Wh2Q+zWRysQPk9zMpeZuXa0SuEF4QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI7T54HKAYBKorO1edEDaslKJTl+nRjGTBwh87lx0uw=;
 b=OMw3OB0hw5TUkLJ++DKvG1+vzEW7HighPL3zJuXLjEr+4AOMFiMm4tBMqWzd88H7MO0gnMIm8WMRDusVReCur+8WGg5rhkkMVjOW3IpprKCO/Tlx6sLJqm0ctLD6+kKefgcynzd7zluJ8NjqhKxOy7Lbxl8qaBd1FLMd3mh6Fts=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3557.namprd21.prod.outlook.com (2603:10b6:208:3d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Mon, 14 Nov
 2022 16:53:37 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7%3]) with mapi id 15.20.5834.006; Mon, 14 Nov 2022
 16:53:37 +0000
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
Thread-Index: AQHY9ZXvB05GbI897ESEeyxWArQdDq4+pF2AgAADf1A=
Date:   Mon, 14 Nov 2022 16:53:36 +0000
Message-ID: <BYAPR21MB1688430B2111541FE68D3569D7059@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
 <feca1a0a-b9b2-44d9-30e9-c6a6aa11f6cd@intel.com>
In-Reply-To: <feca1a0a-b9b2-44d9-30e9-c6a6aa11f6cd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=34509673-6e40-4f1b-9e8e-0a3d67de7408;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-14T16:52:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3557:EE_
x-ms-office365-filtering-correlation-id: 3b0bb5a3-a7a0-47d7-6a72-08dac660c61e
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f2nEN78tJb+8xjhxYuz2pBpvmapmG/ijEHz0ytkSwVgTlnXNpwRTtF5pYFh7GoZEC3LQ+A6T/05phiEOSHZAAlWyvcdaE8jzzp53pmMYN6SYV1Mgxh9/KwPU1e+8oPFFZMEDxqkpRDC6Hg1XWPeHaoNy/VIj6rF8HPquMj+Mlew7zMyMZiMVszYwnUfou9o5DY3uQEKVgIpBQbGXIMngZrl3csgNw6UUM2ksrb3hD7/UKIcz0Zi/H9MCVVbMfTOGy7hdNZm/M+EABlo0JMPh/jBcQ7NGYSLsh8L68VxPC42MZot2EQM3++RrNklUvmqCvNs4OdrGWUCq2NbTC/HN+YvWgbKIFd8sy6MKtb8QNobX4YEiJtR6zdhR3hWJp6hscjIIOTcm5BzABODDh2SZpsm5efs3np10WggbzsUi4O53GTod3A75CC5pCCFA70Wx1wCe8jbU5Ukdziy6v0so5GrMcn5uwKPgwcSxK/rMg0sjGneu8UgqYbJZZO2jJt7RQM8V94MoeB39wUKmijAda/s1eAphbUygWqY8Q05gzDfvUZ7Ihu0iS5dA85ibCjsjXqnLTXY270pI7nlWVTfBd2aToD0WAsQHGp/wXxmP1EYd0xGl3GzoOGJ7q1JoLNmX9eoPotEh0RRDZiPSLh6f/CV3TBnRqnbS3Kx4i31/oFW2CNKC8yPLCkkdzDx0RshYMSYSSCm0LhSkUbVxQNqHutLzX4flQI88F7IZrIPFy5Wxh/MLKvfpCORpvYcoFf5QZF/YEH/7Bn75aqSh0ayWMZ1Lyb1cGddFhdefJ5nk6jXWwcSlPE98/gS1jHQNRs9Qz9G2GUqYDIn+TAZE6kn4wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(5660300002)(9686003)(86362001)(6506007)(55016003)(7696005)(7416002)(7406005)(110136005)(71200400001)(2906002)(64756008)(316002)(66556008)(66476007)(66446008)(76116006)(66946007)(122000001)(8676002)(186003)(33656002)(52536014)(41300700001)(10290500003)(26005)(8936002)(53546011)(8990500004)(82960400001)(82950400001)(38100700002)(478600001)(38070700005)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dm9aczVOMG5IV2JpeDc5dERxZFBjMHdlcitLZGFNdTNvS3U3S2tVSEdTMi9I?=
 =?utf-8?B?a2ZqUWJiSnVPYXB6MFRQR1lFNy9wVXhmV3pzZFFNVk02RjlPcis2anluMG5U?=
 =?utf-8?B?SGx5N1NReG9qYUViTVNSbTRwWDFvUmVFUzVZWUU3Vll1dGZvcnI5ZHJUdXNP?=
 =?utf-8?B?S2NRNmYvYitpMkFPSCs4VytiTHlBcEdsUklrT09UdDZlL3dWa0ozNEFWRDJo?=
 =?utf-8?B?RGt2Q0U3eHZxb1Vkdms0NktWWWFaayt1dmd3SUdSL29oa2tuWm1rc09rWDNO?=
 =?utf-8?B?S0NVdGdEaGRONmErelFud2lkTS9WS1lLZVZxZVVueWFINVRwMVdiTUdUcVlh?=
 =?utf-8?B?OWtsN3c0SU5DQ2kvZTZ3bm1XY3doNnFHS3FMUzFnYnZRL1UrQXVNdWlQbkU5?=
 =?utf-8?B?QVVXNm0zZkpFYnRmb1I0bTJqOHNUcTVNKy9DL1E3U3E3NHZVZTl1VHdnNEc5?=
 =?utf-8?B?RU9YTUZ6d3hndk1zbmJGQ2hSQlBFeDBKeFc4UWdnWTJlSHd1M3owc0pRS1hq?=
 =?utf-8?B?YnJ2NXF0NFpFM3k2UGFqYXROZmR0Si83NFNRZ29aZmdHUXlod1pEVE8raWZC?=
 =?utf-8?B?aGtFbjRwTWc3VnVQTUVsTElYaW1SdGQvbllBUWk3QzlQS3JqY1pPNnl6djlE?=
 =?utf-8?B?RWhpd0Q5bGdrRUllbUt1Znp3QmFGY3M2eDNsSEpVMm1qUUJkQjBlcW1iU2g3?=
 =?utf-8?B?QmJwd2JUSENYb3BISWpIaEdCTy9YS0F5MlpqNzdRd1VzbEFpVTJPV3k4TnNY?=
 =?utf-8?B?Y2d1NmZXSzBTb3QvaWp2eVp5ZkpPd09qdUU5LzhWSldBV0FRWk1GQ3BZajV5?=
 =?utf-8?B?cmpuZHZsN0IyZUc5bEtQMXFwUHQxN2tTZThVTnpmV2ZuKzliaklMeDhjc0VG?=
 =?utf-8?B?MFBXbitPL1ZTeXBqbUpWUTNKTnBLajE2NzlSQ3JzZGYvQnl3bEI5TXhSbHQr?=
 =?utf-8?B?azY4bDZCOTdGSXc5VVMwOU14TWFqbFVRUzNObVFkcHN0b25RNCttWHYvVGZh?=
 =?utf-8?B?YUNyMkVCRHBKSnNPU3RMblZiRTVJTXprdjYrVG9IbDJZaGFZS0s5Z2svMjEy?=
 =?utf-8?B?anF5cU1MN2FxcXBCT3FrTHFocjdISUdyMnNzWkJFQXNMREI4OHJXRm5UNGpz?=
 =?utf-8?B?blk2bWV1L1Q2YzFodlZnbm5sbldSR1ljcHFXbENoSUlNYUk3eUVFVEhodWtY?=
 =?utf-8?B?N2l4T1BIanRjOHJYZHNWSDd0OUtjaWVMQy9Ha0JHblRMMndFSG1NWGJoRmV4?=
 =?utf-8?B?U0Q1ODRXNDVJdDVsNVF0QnZpTW1NNDh3UURuUU1RVys0ZmlhNkJnQkIzQXU3?=
 =?utf-8?B?cm5walFUWmR2N2E4R04vNU5nYTdPbGdNM0s0Q0Zab2gycU1MSUhtTUMxWStB?=
 =?utf-8?B?blowRXVpanNwWmdWbEI1TDdFWmpKZUxaNzFKMjVKRmdoREthWjlWZzVqa3hh?=
 =?utf-8?B?T0QvTTBZaVMwdWozRjdJVWszMlJBcWh2UWhwbi8rT3ZDM1A2YlgvajNUZ21q?=
 =?utf-8?B?UVUxOUpZbEpwamh1b1NSeEl5blBnL2U1elBrSDdUMk9xTHFjOW9KdWJ5VVQz?=
 =?utf-8?B?cnFHUnplaVpKOFhLQzUrUmpucXlpQy9LZENqVTBmdmxUTWJUekRvR3RWR3li?=
 =?utf-8?B?bU90K0w1R1RPU3BjbExDckw2VE1vTXNZSXB1NVZYL1dmYkVDS0VCZFpMNDRY?=
 =?utf-8?B?WWh6ZzZqbUJnbWZiMzRIQklQVEVRVjBpcGVEd0QzMDJGd1FRWmJIc3pEaGU0?=
 =?utf-8?B?YUN3NkxaL0dHdDk0RHZoQWMvMExsTEM0cHBWNXVOaUpKa2krZGJJVmtBak0w?=
 =?utf-8?B?emUwT3ptRENDamtVQTMxZDBVTTBZSTlRL1p5UmxGVGxGSk5hMVFlSklPVm5y?=
 =?utf-8?B?V3pVa1htYUVjNXBEQ3FLcU1TWFdVL0xMQmdCZmx0ZTEyOXhTNm03czR0VUNL?=
 =?utf-8?B?d2VHbHV5VzNnalNod0JONitZRjVIbVJzTW5Neko1dW94b3hwYnB0UTFXNkt4?=
 =?utf-8?B?SWlLRlFtZnA0endTWGZXNFhmbHdIcUZIelErM2VQUDRsUENXMFBhZ2RETkFB?=
 =?utf-8?B?Wlhjc0UxVnR1dUJrTEEzWGJQaU9ucUNmOFlmN2FJU0EzNWgwbUp2UWxTZGp1?=
 =?utf-8?B?U1M4Q3lOYmowMlMwbk9FM2hibnVQSUxGQ29Cc1pXd0R5Ni9GYUZsTkg5Umcy?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0bb5a3-a7a0-47d7-6a72-08dac660c61e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 16:53:36.9232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAkdLCchQDvy7N3+0riAc4cWO3aQjAM3Vey/QNewf8zf5ZhEHyrHZGbcvPsNJZO77rxznua/bLVm/0/uFdbszfFSY4xyDGEuHX5Ck9JTros=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3557
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
b3ZlbWJlciAxNCwgMjAyMiA4OjQwIEFNDQo+IA0KPiBPbiAxMS8xMC8yMiAyMjoyMSwgTWljaGFl
bCBLZWxsZXkgd3JvdGU6DQo+ID4gLS0tIGEvYXJjaC94ODYvbW0vaW9yZW1hcC5jDQo+ID4gKysr
IGIvYXJjaC94ODYvbW0vaW9yZW1hcC5jDQo+ID4gQEAgLTIxOCw3ICsyMTgsNyBAQCBzdGF0aWMg
dm9pZCBfX2lvcmVtYXBfY2hlY2tfbWVtKHJlc291cmNlX3NpemVfdCBhZGRyLA0KPiB1bnNpZ25l
ZCBsb25nIHNpemUsDQo+ID4gIAkgKi8NCj4gPiAgCW9mZnNldCA9IHBoeXNfYWRkciAmIH5QQUdF
X01BU0s7DQo+ID4gIAlwaHlzX2FkZHIgJj0gUEhZU0lDQUxfUEFHRV9NQVNLOw0KPiA+IC0Jc2l6
ZSA9IFBBR0VfQUxJR04obGFzdF9hZGRyKzEpIC0gcGh5c19hZGRyOw0KPiA+ICsJc2l6ZSA9IChQ
QUdFX0FMSUdOKGxhc3RfYWRkcisxKSAmIFBIWVNJQ0FMX1BBR0VfTUFTSykgLSBwaHlzX2FkZHI7
DQo+IA0KPiBNaWNoYWVsLCB0aGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbiBpbiB5b3VyIG90aGVy
IHJlcGx5LiAgRmlyc3QgYW5kDQo+IGZvcmVtb3N0LCBJICp0b3RhbGx5KiBtaXNzZWQgdGhlIHJl
YXNvbiBmb3IgdGhpcyBwYXRjaC4gIEkgd2FzIHRoaW5raW5nDQo+IGFib3V0IGlzc3VlcyB0aGF0
IGNvdWxkIHBvcCB1cCBmcm9tIHRoZSBfbG93ZXJfIGJpdHMgYmVpbmcgbWFza2VkIG9mZi4NCj4g
DQo+IEdyYW50ZWQsIHlvdXIgY2hhbmdlbG9nIF9kaWRfIHNheSAidXBwZXIgYml0cyIsIHNvIHNo
YW1lIG9uIG1lLiAgQnV0LCBpdA0KPiB3b3VsZCBiZSBncmVhdCB0byBwdXQgc29tZSBtb3JlIGJh
Y2tncm91bmQgaW4gdGhlIGNoYW5nZWxvZyB0byBtYWtlIGl0IGENCj4gYml0IGhhcmRlciBmb3Ig
c2lsbHkgcmV2aWV3ZXJzIHRvIG1pc3Mgc3VjaCB0aGluZ3MuDQo+IA0KPiBJJ2QgYWxzbyBsaWtl
IHRvIHByb3Bvc2Ugc29tZXRoaW5nIHRoYXQgSSB0aGluayBpcyBtb3JlIHN0cmFpZ2h0Zm9yd2Fy
ZDoNCj4gDQo+ICAgICAgICAgLyoNCj4gICAgICAgICAgKiBNYXBwaW5ncyBoYXZlIHRvIGJlIHBh
Z2UtYWxpZ25lZA0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIG9mZnNldCA9IHBoeXNfYWRkciAm
IH5QQUdFX01BU0s7DQo+ICAgICAgICAgcGh5c19hZGRyICY9IFBBR0VfTUFTSzsNCj4gICAgICAg
ICBzaXplID0gUEFHRV9BTElHTihsYXN0X2FkZHIrMSkgLSBwaHlzX2FkZHI7DQo+IA0KPiAJLyoN
Cj4gCSAqIE1hc2sgb3V0IGFueSBiaXRzIG5vdCBwYXJ0cyBvZiB0aGUgYWN0dWFsIHBoeXNpY2Fs
DQo+IAkgKiBhZGRyZXNzLCBsaWtlIG1lbW9yeSBlbmNyeXB0aW9uIGJpdHMuDQo+IAkgKi8NCj4g
CXBoeXNfYWRkciAmPSBQSFlTSUNBTF9QQUdFX01BU0s7DQo+IA0KPiBCZWNhdXNlLCBmaXJzdCBv
ZiBhbGwsIHRoYXQgIk1hcHBpbmdzIGhhdmUgdG8gYmUgcGFnZS1hbGlnbmVkIiB0aGluZyBpcw0K
PiAobm93KSBkb2luZyBtb3JlIHRoYW4gcGFnZS1hbGlnbmluZyB0aGluZ3MuICBTZWNvbmQsIHRo
ZSBtb21lbnQgeW91IG1hc2sNCj4gb3V0IHRoZSBtZXRhZGF0YSBiaXRzLCB0aGUgJ3NpemUnIGNh
bGN1bGF0aW9uIGdldHMgaGFyZGVyLiAgRG9pbmcgaXQgaW4NCj4gdHdvIHBoYXNlcyAocGFnZSBh
bGlnbm1lbnQgZm9sbG93ZWQgYnkgbWV0YWRhdGEgYml0IG1hc2tpbmcpIGJyZWFrcyB1cA0KPiB0
aGUgdHdvIGxvZ2ljYWwgb3BlcmF0aW9ucy4NCj4gDQoNCldvcmsgZm9yIG1lLiAgV2lsbCBkbyB0
aGlzIGluIHYzLg0KDQpNaWNoYWVsDQoNCg==
