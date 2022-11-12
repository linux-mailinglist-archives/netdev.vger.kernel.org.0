Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88C626705
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiKLEss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiKLEsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:48:45 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020015.outbound.protection.outlook.com [40.93.198.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19859FD3;
        Fri, 11 Nov 2022 20:48:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7oeiQNZA/SsNmtVYMagXfOH6oB2P25t5twOlp8EZ63eZT5TMhEXv8MuYORUooUTjDl4thFM9X8V170OzWG3Ng7kelEpwSMJhOn/bfE4yIu/4TQABBMw23GQUtHG4bTKE34F2Gx8YRye04YmaCEx7Onuwr82U+3yEoccTcEyjtwUYZTCFDF254fLX7UiJRcjDX/PpJ9guat6QQxFAWmmBn5YkXhdcdH0XNMmgP+zek/3NByuPo8xM3EGWMF1L/KtIBLvg5rI7ocuvf7CrhOBu/DnXrne5Vi90LTkQsUlVIOHAf2K7w0S16lVCjOEjHTJjsef45GBo8dTDQ8e36phqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGvQpR68Xn5lowMZpqqdVpMwVhrib9uSAaX//+J0MHA=;
 b=cBsKzOgECdKtRdrcTFDM4ymZNKRqchVO2DkN5z2qDcK5Svbllmf0p74vHem9znHVYfbWGqpOhwgIzzGPKzgKnAQGRIY5o790usLziJAeyP/kzzh3t3iWvUpHiHHeNnKS6HX6GKGpvc5vtPRJgMCikjhu4IwlhCPooOcdjIqGTFP/zhI319DCazAuysXBgDC9m/StYH2nTr/sDy5Dqn+QcBMmKZn4iU4fOvEdJdgdzWAnOrHXBrbwMDhLb9voBMDnmrGWbryCwWo0anwNS9xCD6CdvWHsRpytzUeQ33629rN4wNkfEjZy39+m0cWJULE9DzM/ZtbYKRX2CprAN7Dgeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGvQpR68Xn5lowMZpqqdVpMwVhrib9uSAaX//+J0MHA=;
 b=E3qz8RiAG3krzVctRuIYtZWgjAOJyEBEJVBNx3n0HYNiQ8Ev8p4buuhB83G2CLiBOPLGjt+jsGT250SWjjeN8TYyacwaQLW/lwiVjMP41Qfkit+5zUMtiQi6JIsGVR+QLD4ADN3Uf9zPSnJY5yZRiE8IH1f1gbB5BX558L2f4tg=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM4PR21MB3466.namprd21.prod.outlook.com (2603:10b6:8:a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Sat, 12 Nov
 2022 04:48:40 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%7]) with mapi id 15.20.5813.015; Sat, 12 Nov 2022
 04:48:39 +0000
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
Subject: RE: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Topic: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Index: AQHY9ZXxgPWJEvDlW0KqJPPwNb8jV646blKAgABF+cA=
Date:   Sat, 12 Nov 2022 04:48:39 +0000
Message-ID: <BYAPR21MB168860D4D19F088CB41E7548D7039@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
 <50a8517d-328e-2178-e98c-4b160456e092@intel.com>
In-Reply-To: <50a8517d-328e-2178-e98c-4b160456e092@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ac0c3fec-e008-42e4-b74d-3e412a78771c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-12T04:32:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM4PR21MB3466:EE_
x-ms-office365-filtering-correlation-id: 8dfafff9-6cf0-4d3c-3c8e-08dac4692ac0
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AauHjwZ9V7vi+GGx8iULCuSWAd5Ho2HWgMlePPkZZWjtR1BOn0Eggh/9nBhhOubehZF3PWb+RJscQq9+/SHBjZqh/pwMNYIOsrZjTnQrHBKwcmx6LPIsSbUL+oPrWAat30aObAJ2QbCFC8f6rhKckyNGNRBDn31A1ShCoSDpIJrBwVGLILBA2lY4DZ29Z+WiC4IJIYHUEmSOBmRMkKySnqvWZnYgHMqTBb6B2k+7O/GbxBHiW2972hUJ9uPxQnCPDNWQRuGWOUrsOPa2Qjrr7/bqRIU/14gHFBIwaL9Ra57a/VpHm1JNXmEZPMKpTwTjXHcmhJYdvl6SQkJzl0azATR24UVWDUVV71Vs3lVoRv4aVli3FHvvAoWvcZ0QkTxyfwY1XrN3H/C6+si4Eb2KR+zO7M9RRQVCDMltNCCP818elDrX+dNQcP1jsicq33bOIlN90w8wBHQZbHA7qPLXToibXKzW1pitfkSxoUi8FABtmWNGLPE5f8e8Ag6KdksTw78shaGs5TRajq3YfJm5962CjKWv/JwP2PB6654NzWIuiRHtCJ1tOxQcBBW6ZL6/AxSscm/uitxxDJ1weEiE4TrFoU3ajJ/hrQsFUizkxyztkBz+NsbYftAuRRpPIuRDqT3T4JRPuTWU9xNLQkDO/H+SIFXs8K2WxNOl2FLFMPBQ/sKC8vzx4WBZVciPsZhFLR1lXuuhP9xE/WSkaYhTLMbszszNTmf6I6LQcQbxrtWlx/7Zc5SsSn7/+wVLrMt1NvcRQ3X2LxkB4kUq1WsD/pv+vA5bpSP7mYX51O/GBHIbTXWLanokixO761+y0mJPgrKzOlhtpX7ldgyBwheftA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(9686003)(186003)(53546011)(26005)(6506007)(83380400001)(71200400001)(33656002)(7696005)(38070700005)(316002)(921005)(82950400001)(52536014)(5660300002)(55016003)(82960400001)(41300700001)(86362001)(122000001)(2906002)(38100700002)(7416002)(8990500004)(478600001)(76116006)(66476007)(66946007)(10290500003)(110136005)(66446008)(7406005)(8936002)(66556008)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG1PeCt1cWVjNGx4b1N6cUM0RlQ4R1pKV0hwSmpYZTNmdkZvTVlBRUFOOExQ?=
 =?utf-8?B?QjE4M2JLenNZVWNKN1Q1NllvYzVuamFnL0YwQXZVQm1GK3dqbTNlN20vNXJy?=
 =?utf-8?B?bUV3VTVSRU1pbklXcnBSejFQOWpxWTRDU1c3MktEeWlMRkpTTXdhSEN5Sk5q?=
 =?utf-8?B?UU9tQ0FRSHhuQVQvT0d3eEtTTDFvWjJ5QmdPZWxGUlpKMzYwTitITkVnNk1h?=
 =?utf-8?B?UWdyNGNxdHozS0JnMjdyS0V3b2oyWlhYWEZPcE1QNFltUWwvZHlpcXJCUzFi?=
 =?utf-8?B?UlQ4Ujc5YWx4UE5vQ0o2b1RQdHpFaHlRK010QUw2SzlQM3hpY2UrcXQrQzhQ?=
 =?utf-8?B?Sjd0eEhkU1Z0UVNsL3hQeFVsbE5vTnlBeWFDWnhCYkx3Mlc4L1pnMDJUd242?=
 =?utf-8?B?MEtHbmIvSjNmRDN1Y1VYQzN0Z3pQcnZGN00zaCtwM2szTHhyZ0hNZE81Sitm?=
 =?utf-8?B?YUMzc0xGb01OZWdkY2NZUGtERzFyUE9ENGx0d0VzM1lwSEdOUmdBOENlOHlH?=
 =?utf-8?B?aFhFZTdrTnNGbEdWYk9uVFJBVEdwNzBGdWxacFI3V0RPeVJXdE9FVWptQnZq?=
 =?utf-8?B?dEhvVlR3bWlmR0hocVUvVWVEVHhMTnM5SE52R1p6STR2Ym5YaFdhcHdxM0hq?=
 =?utf-8?B?czdROGpEWnQ1bVZ2dk82V0p6TlpMZWRuOVhoMCtReTNRRFV0RGRnRjZqaE5F?=
 =?utf-8?B?bDFBUjZkT095RDNZd2xmR0VNbVJxVnNjYzFOTy9Jd1RQZGZDZGRwS3ltU0c0?=
 =?utf-8?B?VG9XaVFzRmF3WEJoN2dMQTZLclVXVS9xNTd3V0Q1bC9nTGgyT0xaaUlIc0xq?=
 =?utf-8?B?eHF3VEtxbDVGVHJDcHZ1dllsbWpkRDNLY0cvWHBnU3JDMlNaakZDUytKWTYz?=
 =?utf-8?B?MG1IVXFsbVpMUGFGM2pJelgwWTV3MzRtTDRlamZmbGJ2S20zcE1WZTZBZ2dM?=
 =?utf-8?B?REVkNTN4MjA2bFJ5aFVGNWZUeFk0RlF1QSt1L0lOYW0xQUhIQmxEM3FMbDE0?=
 =?utf-8?B?aHFuUUNIYjJBd3lYYi8vQlRKNTBVRXhhV3dkRmZOTitVaXdwelNiRHNlaXVR?=
 =?utf-8?B?dEU3aUFmYmZDMmxZTjNSMEQ3Wi94RG1KLzNlSXovNjVaNENYZkRwbUlxeHZQ?=
 =?utf-8?B?cG82WFVJSmIyQ3hYRG5JbnBabzRzL2NHNHlsbDNXQ05DOWNLR1ltaDBPQzhq?=
 =?utf-8?B?Q3NaWmkwamVLaG9TSDM3SzU0aVI2S1ZDTlpnNU5sWGNzeklzOXRmRnVCbWJt?=
 =?utf-8?B?WVVHNTJMQVJ2aUJGRDlDTWxIWmpBUHNBbndrNTNBSXIwWFlmM0FpaENZSEZP?=
 =?utf-8?B?Nnh0L1dHYUFDUTRVeCtHRStaM0tUankzdTZ5SFB5aEZOcURRYjAvTCtodTBL?=
 =?utf-8?B?aGtkNFJCTGptWHJOSnNYTTZMLzNGZFZNOWhmb3Y0emxLSkNYeFJadndHMm9q?=
 =?utf-8?B?VWNUZzJHdGpXSG5ub1pQaEZtUEducmxEZ3BtNExtN0NoY0tJUmFtNlMvU2M3?=
 =?utf-8?B?LzJQcFA4VTlnM05KVnpJQkRPSGRiR0VTdlMwNGRQbUFUbU1ua2FsVVJ1MkhX?=
 =?utf-8?B?RWxodXUvVDFkVTZ3M1Irak8yeU8wYW5sYVdYb1gzQmxaR0gwZDl1YWF5WUZW?=
 =?utf-8?B?azNGeDRkalpzT1FWbmM2UUFnMkI0QlB3eldtZUpDdExkUFpRaUNTdmNOVTVt?=
 =?utf-8?B?dGNHMEVtTFgyeFhERDBEUm44NzlXZlhLcDhyUDV6MWFPQWhUSGRyUyt6cVU3?=
 =?utf-8?B?dHFLbHhwSzFxVWphVHc4OXRnSG9QR3EyRm4rUnk1QjB2Zzh0dHZoSGN6Ukk3?=
 =?utf-8?B?WE9oanIzSm1NUVVqVUJuK2tib2FTRWtmeSthaGlma3lCMUxjTDRTbVhMRklK?=
 =?utf-8?B?RExFWDZGaWVvSldKenREdHRRY2tWOFEyVHI1OE1BRHlYQUNLV0lIQytpRW9w?=
 =?utf-8?B?L0hXV1hjeXVndm9YY3BJTlRPdUlPVFRzMUZUb3BKQlRXMW0wd3BZblFpVEJt?=
 =?utf-8?B?eFptT1poZmtSVUNMTFdmRzJJTThZNTUzU0pERlRFNE42Z0dpY1huNkhmSkJZ?=
 =?utf-8?B?TDkrUlNXQTllWGw1MFJmUlNJLzlKNm4rQlBrVlZUK0xoT1lPYXpIcjBFQllL?=
 =?utf-8?B?aFIzTlpDQWRNRGlsOHE5SnFvT280dkc5MjZUV2tUdGVKR2s4d1BMcXJXK2lV?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfafff9-6cf0-4d3c-3c8e-08dac4692ac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2022 04:48:39.4041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uO1hsFs4/NANwUxdmF64/RP8BYJUEkelZ8IRHJvreRXynrpcc6Z+NjF/8Zf9XEQoPJGsaSMNOzD8VFpeK4uSZYBitZX3Tt1eW9v3+lI34dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogRnJpZGF5LCBO
b3ZlbWJlciAxMSwgMjAyMiA0OjIyIFBNDQo+IA0KPiBPbiAxMS8xMC8yMiAyMjoyMSwgTWljaGFl
bCBLZWxsZXkgd3JvdGU6DQo+ID4gIAkgKiBFbnN1cmUgZml4bWFwcyBmb3IgSU9BUElDIE1NSU8g
cmVzcGVjdCBtZW1vcnkgZW5jcnlwdGlvbiBwZ3Byb3QNCj4gPiAgCSAqIGJpdHMsIGp1c3QgbGlr
ZSBub3JtYWwgaW9yZW1hcCgpOg0KPiA+ICAJICovDQo+ID4gLQlmbGFncyA9IHBncHJvdF9kZWNy
eXB0ZWQoZmxhZ3MpOw0KPiA+ICsJaWYgKCFjY19wbGF0Zm9ybV9oYXMoQ0NfQVRUUl9IQVNfUEFS
QVZJU09SKSkNCj4gPiArCQlmbGFncyA9IHBncHJvdF9kZWNyeXB0ZWQoZmxhZ3MpOw0KPiANCj4g
VGhpcyBiZWdzIHRoZSBxdWVzdGlvbiB3aGV0aGVyICphbGwqIHBhcmF2aXNvcnMgd2lsbCB3YW50
IHRvIGF2b2lkIGENCj4gZGVjcnlwdGVkIGlvYXBpYyBtYXBwaW5nLiAgSXMgdGhpcyBfZnVuZGFt
ZW50YWxfIHRvIHBhcmF2aXNvcnMsIG9yIGl0IGlzDQo+IGFuIGltcGxlbWVudGF0aW9uIGRldGFp
bCBvZiB0aGlzIF9pbmRpdmlkdWFsXyBwYXJhdmlzb3I/DQoNCkhhcmQgdG8gc2F5LiAgVGhlIHBh
cmF2aXNvciB0aGF0IEh5cGVyLVYgcHJvdmlkZXMgZm9yIHVzZSB3aXRoIHRoZSB2VE9NDQpvcHRp
b24gaW4gYSBTRVYgU05QIFZNIGlzIHRoZSBvbmx5IHBhcmF2aXNvciBJJ3ZlIHNlZW4uICBBdCBs
ZWFzdCBhcyBkZWZpbmVkDQpieSBIeXBlci1WIGFuZCBBTUQgU05QIFZpcnR1YWwgTWFjaGluZSBQ
cml2aWxlZ2UgTGV2ZWxzIChWTVBMcyksIHRoZQ0KcGFyYXZpc29yIHJlc2lkZXMgd2l0aGluIHRo
ZSBWTSB0cnVzdCBib3VuZGFyeS4gIEFueXRoaW5nIHRoYXQgYSBwYXJhdmlzb3INCmVtdWxhdGVz
IHdvdWxkIGJlIGluIHRoZSAicHJpdmF0ZSIgKGkuZS4sIGVuY3J5cHRlZCkgbWVtb3J5IHNvIGl0
IGNhbiBiZQ0KYWNjZXNzZWQgYnkgYm90aCB0aGUgZ3Vlc3QgT1MgYW5kIHRoZSBwYXJhdmlzb3Iu
ICBCdXQgbm90aGluZyBmdW5kYW1lbnRhbA0Kc2F5cyB0aGF0IElPQVBJQyBlbXVsYXRpb24gKm11
c3QqIGJlIGRvbmUgaW4gdGhlIHBhcmF2aXNvci4NCg0KSSBvcmlnaW5hbGx5IHRob3VnaCBhYm91
dCBuYW1pbmcgdGhpcyBhdHRyaWJ1dGUgSEFTX0VNVUxBVEVEX0lPQVBJQywgYnV0DQp0aGF0IGZl
bHQgYSBiaXQgbmFycm93IGFzIG90aGVyIGVtdWxhdGVkIGhhcmR3YXJlIG1pZ2h0IG5lZWQgc2lt
aWxhciB0cmVhdG1lbnQNCmluIHRoZSBmdXR1cmUsIGF0IGxlYXN0IHdpdGggdGhlIEh5cGVyLVYg
YW5kIEFNRCBTRVYgU05QIHZUT00gcGFyYXZpc29yLg0KDQpOZXQsIHdlIGN1cnJlbnRseSBoYXZl
IE49MSBmb3IgcGFyYXZpc29ycywgYW5kIHdlIHdvbid0IGtub3cgd2hhdCB0aGUgbW9yZQ0KZ2Vu
ZXJhbGl6ZWQgY2FzZSBsb29rcyBsaWtlIHVudGlsIE4gPj0gMi4gIElmL3doZW4gdGhhdCBoYXBw
ZW5zLCBhZGRpdGlvbmFsIGxvZ2ljDQptaWdodCBiZSBuZWVkZWQgaGVyZSwgYW5kIHRoZSBuYW1l
IG9mIHRoaXMgYXR0cmlidXRlIG1pZ2h0IG5lZWQgYWRqdXN0bWVudA0KdG8gc3VwcG9ydCBicm9h
ZGVyIHVzYWdlLiAgQnV0IGlmIHRoZXJlJ3MgY29uc2Vuc3VzIG9uIGEgZGlmZmVyZW50IG5hbWUg
bm93LA0Kb3Igb24gdGhlIG5hcnJvd2VyIEhBU19FTVVMQVRFRF9JT0FQSUMgbmFtZSwgaXQgZG9l
c27igJl0IHJlYWxseSBtYXR0ZXINCnRvIG1lLg0KDQpNaWNoYWVsDQo=
