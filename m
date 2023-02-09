Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9A5690F80
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjBIRrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjBIRrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:47:17 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021027.outbound.protection.outlook.com [52.101.57.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357FB1ABF6;
        Thu,  9 Feb 2023 09:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDpJf/G4yluoRzUOxyi2gTCNWAXTAvRtx5RsxuxahuN0Chk6tyshizBB7Ecl7SiBWPu0VPs8Fx6pP7h9dQeTbug6TjkF2RIAL7kRH6jZ7m3jJiBYkL0B6MHDQx0VXtWBPuZOfdKS55O91Gavf4PhiduhA4CoZALicmuFsly4wEM+w7u/MVoEiIPsGuzrZ0AbXfcpdovhh5KXTJxndXz5uo+zZETVMuG+vFFT0O95DWqOjLZQMnFKV5PoXm6g37iqFcFvKZsP0rp+ywsPWKE0zSdD+pXbfBcbtKl+8QbDQhaDxYn+EQEKZuVn3som+zuzXyQlauDnflyXhCuahtHkVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McBsrB96ckpPLqnxzFSQ+2Mqo2LjV4kzKJVOqv/rQfA=;
 b=aqvt1PtIVrPzjtp9IxgYviFWQJD6FQotzui/Gz0cj7hM4byy//q1pLVT9muAx7/FCTa0Caqf2QBebQte+UlsaPd3CxMxjua1WqDL6PSh/fIGKiLMpDfl7tz5yhteQ1aBhEXWx+bkoTlDbMh4yB4yLoGBYZbTc0j4kKAXQhmz+tf3CnhmP81F/ehVgPIvGJTArI4gxRX0uHd8rUfZGGfYoNAGS8IM6K+O+9qMWtw+1BY2++Wv+Cg+tEi0rys/14HeC+26Rw3aAUhZZuWkyDh33sot5rcamonZqu7hiyqixz7AxRXaw/1OJ4yECeGzpQT8RP/CQXgppgeJRBaYmwmWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McBsrB96ckpPLqnxzFSQ+2Mqo2LjV4kzKJVOqv/rQfA=;
 b=LDKCerx11OX4uDcljroFVcDIophnoMNyx4i3QvTob3Kz47G1ql61kHHv9r8Klv2PeIlkf2zv2idD+tmkFoYCDKYA9MWdzLcyazdY9jS4Yg816hBrJIT8t47wbd6EBU5BUifI3BZ0SRP6kEz4dJIpNic70LUNRGiO4I+t5k7Rcsc=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ0PR21MB1999.namprd21.prod.outlook.com (2603:10b6:a03:299::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.5; Thu, 9 Feb
 2023 17:47:07 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.004; Thu, 9 Feb 2023
 17:47:07 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95A
Date:   Thu, 9 Feb 2023 17:47:07 +0000
Message-ID: <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic> <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
In-Reply-To: <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=12598b71-2e0e-44cb-8d10-03f984e0ec6b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T17:29:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ0PR21MB1999:EE_
x-ms-office365-filtering-correlation-id: d725775c-4d5d-4a2a-6f9d-08db0ac5a979
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bmi8DtD+SUdvRzhDjNz3aBKjJj5VPPAws1+NI4Ne3Xx//mAYXypEieo0ASvjm9oC9zpCnAca5sOr0eC7sEOOXCFGHtletFv01i2mMaLLEMuy4Owg+FIrCXjeRATZvzODuI83dh/JErxjPvvW0OpUwVj+vY85IzcNTiP68SpsKROjA3Hsw6zTvP4QaMYfPzLon4kHdPu1bW0nYw+2bD1m0Vcnm1guFAWblj23TEFCJ1AiCblMX28GuAxDfaLbznn07ejDSOZ9gTPUiX61CHfuaZNXajsPwE/P4ROzXzMzu+/z1X2+nUgfotkoEUjYXKcfLLblCmZDca7PQV/p9Jz7XtqvAPexIkKFfNQMy0UUTkhwEAsVYBsEaWdSckuwqOM2ZEbKjvQPth3Cu8erEUR67fj3oBI8o2IyPYlVF9fsrH0Yfz8D5HIdYu8B2kYxCx6Ju222KwgyOSSOdOG8P03XrIex7qzF2pXcTlgHcBjZn+8pvIlWZPnnup2fGEUCgm3l22egAXzDLz+CNqgBtMlaTjUJz0F1i9fMyMPDiPaqy/SrvSQkRyZR8LmiT/9Z2vFRpv86wcOiweYlXBCHyaMocHLSNVieG00ZLQK6OWe0gRh83ZHElnpCCEDmks7Mp8YmGuxVt+hC01z1mJW2bCbgUehJgfk+va+d7vem/YQ15G3hMHpyqBrrJCA9hlihyS+UmEg/pTFcL2QZJN5bBsuzCZlWYK3LUDBIrTQBN7vfGgg2n7uzjgkW+2JKUPUtltif
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(41300700001)(8676002)(4326008)(66556008)(64756008)(66946007)(66446008)(66476007)(76116006)(55016003)(122000001)(33656002)(2906002)(38070700005)(86362001)(8990500004)(82950400001)(82960400001)(38100700002)(7416002)(5660300002)(7406005)(52536014)(8936002)(7696005)(71200400001)(186003)(26005)(9686003)(478600001)(6506007)(53546011)(316002)(54906003)(83380400001)(110136005)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUg0blUrN1YxKzJsUGdMbG5ycytZTGtQRW92SlJYSDhIY0FqRFRweWNlWnMw?=
 =?utf-8?B?ek5hZm9TTUpPZW5idjAyTFl0TU9zQXVXSjFVYzJyRnR5Mm5sR1R1S1dVU1JI?=
 =?utf-8?B?SyttN0drVXlmc0VGZHR1ZXUvSlk4eFlLaEh4NG5XV00rVlY0VVVpbjFsTjR1?=
 =?utf-8?B?N2NRaFAySDFsZEFoRys1T1BxKzhYcnhjV2ZzVWx0d3BEaE9WdGw2d3NySXhT?=
 =?utf-8?B?NEVIMzR1YjNFRVUxSzdQWlQvbXU4U0l1WVA2Q0wrUG1ZSmFEQk5zdDRjbWJa?=
 =?utf-8?B?OXJja1hpZTJXb3lGZE42aHVvRkV5d2lCOTBabUhWRXJaUTUySGFPaVFPK3pN?=
 =?utf-8?B?dlpNU21yc242K0dlYnhQanBpMTJ0MVdqUXZ0VlViYmdwWmpxRktlL1ZWTGRs?=
 =?utf-8?B?ZE1YTjJqRG5LLzZlY0hlWFJWdXlKZ0FrU2NML1l6Q25NRy9jVHkrV09JcUtH?=
 =?utf-8?B?RlBmc25SbFJVZlNrTVFYSmE2WFBXRDRWNC9oMUVha2dIaUk0TkpFdnZ6eG52?=
 =?utf-8?B?SG5na3h0M2M3TFlYWTgzTU1nRnpZSEk1Kzk2bUl6OTVmTG9yV3k4S29HVkZV?=
 =?utf-8?B?clQ1UWxyUWdlY2lSYStzeDQ5b1cvSE9RNVJBOEVlZm53ZXVadHdvVjNRTmRV?=
 =?utf-8?B?ZHNqcmpKUzA1S1VROFhUWkpYRGJCVFp6WTBwUFdwZUNMYkRjbWZJSEt5L1o1?=
 =?utf-8?B?dHhIZm1wam5IdmljRUk5UzBYaTA0cjFkZGxsaHpYL2grSDVneTJYdWw1UG9B?=
 =?utf-8?B?U3NGTGZGS1FDV1N5Y1M4SG4zVnl1dTdTcWdUK0RNTGM3ZUdQeTVFZlVHSnc0?=
 =?utf-8?B?SDRtdmZpQUpRVTcxZEFzeWU3bHFJUDBLNGVTZGRQVUhmbTJIUlJ4V0lab0pl?=
 =?utf-8?B?Tjl1YUFjbVlZMld0bWx2THNDby80YWY4cDdHTWV6ZlN5T0w5ZFZzWUVFVDNq?=
 =?utf-8?B?ekYvQm5kSWdPV3VFRTJjUzhIVFMyMVpZYnQ2V0JlRE01eFdPc3lSem9ZVlgz?=
 =?utf-8?B?VGJYTmk1TWVnU2FTTGcyVlFFdHM4NXZhTS93WDh0MkFOUEFBUlExWEp1QS9j?=
 =?utf-8?B?ZU1YZG5tRkZvY296SHg5SzJjZ0lWdTg5WEhNTWZ5SldlQmZGSFNPSjJiZTU5?=
 =?utf-8?B?QXl6bmp0NHExdmpmQ0lqUGNZbFBzeEZLcEF2TG1KbTdMYmt3MXlweUw1TzZX?=
 =?utf-8?B?TUF4dkJiejZlODBrSnlzZ0x6VmNiVG95OWpybnpsOE5IWHhCRTNLVVpaQTZ6?=
 =?utf-8?B?L1dMY2E2NTRGQ2dTTzMwWEp6bWNER2lTak1HY1pCWG1TYkpKR2d1SXVhdFhw?=
 =?utf-8?B?SEx5eG5vbTVVK2tucVVPbFplOWsvVEIxS2JyTllNNWNhOFlaUjJUSlVESG1h?=
 =?utf-8?B?Umhid3ZXRlJhcVk3cFBOMUFUZXZJOTJ1aEgzNnh0ZG5ERTAvT0lhenRySkd6?=
 =?utf-8?B?dXFJcnJPRlNGWGpQZWNONzF6WXJveWhSVXV5Wkhnak9aVTVwVWQreGphb2NZ?=
 =?utf-8?B?Yi9qd1doS0ZRbFEwRDNaS2JYakp3STlMZ3haVCsza2l0UzlyT1VpalpUMGJI?=
 =?utf-8?B?cm9wUHQ1ckpucUFlaGhpOWVZRkNoUTJYVjVlUXlvNGsybWhHWnZ3NUFPTUd4?=
 =?utf-8?B?K3BZcGUyeE54bWMreU5mNTFyM25OWG4zSFROMzJWSzhDME1lcHZlenBpalZw?=
 =?utf-8?B?aVNBWnJuZU13RmtYZGl3RENXTTMraFFrMmtCV0g4YVl0L2JqbDMyc2Vid0tr?=
 =?utf-8?B?ZVU5dDJLdTI5WE9iNWl1aFBJakp0R1pTbTBBMDBGajlVbXJvU2VtYWV4dVdj?=
 =?utf-8?B?MXNSa2FsNVpXQWpxUFlUOWpIYlBZc3Z0WHdEbitReElpQ3RzWnhxSTgvT25M?=
 =?utf-8?B?ZG9OYWZMMFo0QTBIKy9HaGdjTVFDRkpNcDNaaVNqeTE1SC9nUG9GSDVLWkpm?=
 =?utf-8?B?L1YvZ2NEMDgrODRiY2ZvY3h5ODZ5M3BiZ3F6T2s0VFhPeXAyWGlqaW1NWm90?=
 =?utf-8?B?WjV1bGtxbzM3TkZiVGVkalgwR2F1V1ZkMkRxWnhReXlxYUxzZVN1N2I5KzRp?=
 =?utf-8?B?VUExYXlwVS95Q0hUZUNmYktNT0p3RDJVMGovaVk3clVvdUJYeStDNVp4RzAv?=
 =?utf-8?B?SURJelZuVUd3aEVaS295OEhMWGZrUjV4emlYbFZ3MkZhVXdnVW9oQzhFbk4y?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d725775c-4d5d-4a2a-6f9d-08db0ac5a979
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:47:07.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIs/RzMy9she7RRMI+bGW+yrYwii3RgOE1YGt7qNAKH3v4OrUS/BvTGdU+TNbBW0V6IVOLWiGAy4J2qxW7f3LYe9igkdkP5Ta8RQE/IZTg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1999
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogV2VkbmVzZGF5
LCBGZWJydWFyeSA4LCAyMDIzIDk6MjQgQU0NCj4gDQo+IE9uIDIvNy8yMyAwNDo0MSwgQm9yaXNs
YXYgUGV0a292IHdyb3RlOg0KPiA+IE9yIGFyZSB0aGVyZSBubyBzaW1pbGFyIFREWCBzb2x1dGlv
bnMgcGxhbm5lZCB3aGVyZSB0aGUgZ3Vlc3QgcnVucw0KPiA+IHVubW9kaWZpZWQgYW5kIHVuZGVy
IGEgcGFyYXZpc29yPw0KPiANCj4gSSBhY3R1YWxseSBkb24ndCB0aGluayBwYXJhdmlzb3JzIG1h
a2UgKkFOWSogc2Vuc2UgZm9yIExpbnV4LiAgSWYgeW91DQo+IGhhdmUgdG8gbW9kaWZ5IHRoZSBn
dWVzdCwgdGhlbiBqdXN0IG1vZGlmeSBpdCB0byB0YWxrIHRvIHRoZSBoeXBlcnZpc29yDQo+IGRp
cmVjdGx5LiAgVGhpcyBjb2RlIGlzLi4uIG1vZGlmeWluZyB0aGUgZ3Vlc3QuICBXaGF0IGRvZXMg
cHV0dGluZyBhDQo+IHBhcmF2aXNvciBpbiB0aGUgbWlkZGxlIGRvIGZvciB5b3U/DQoNCk9uZSBv
ZiB0aGUgb3JpZ2luYWwgZ29hbHMgb2YgdGhlIHBhcmF2aXNvciB3YXMgdG8gbWFrZSBmZXdlcg0K
bW9kaWZpY2F0aW9ucyB0byB0aGUgZ3Vlc3QsIGVzcGVjaWFsbHkgaW4gYXJlYXMgdGhhdCBhcmVu
J3QgZGlyZWN0bHkgcmVsYXRlZA0KdG8gdGhlIGh5cGVydmlzb3IuICBJdCdzIGFyZ3VhYmxlIGFz
IHRvIHdoZXRoZXIgdGhhdCBnb2FsIHBsYXllZCBvdXQgaW4NCnJlYWxpdHkuDQoNCkJ1dCBhbm90
aGVyIHNpZ25pZmljYW50IGdvYWwgaXMgdG8gYmUgYWJsZSB0byBtb3ZlIHNvbWUgZGV2aWNlIGVt
dWxhdGlvbg0KZnJvbSB0aGUgaHlwZXJ2aXNvci9WTU0gdG8gdGhlIGd1ZXN0IGNvbnRleHQuICBJ
biBhIENvQ28gVk0sIHRoaXMgbW92ZQ0KaXMgZnJvbSBvdXRzaWRlIHRoZSBUQ0IgdG8gaW5zaWRl
IHRoZSBUQ0IuICBBIGdyZWF0IGV4YW1wbGUgaXMgYSB2aXJ0dWFsDQpUUE0uICBQZXIgdGhlIENv
Q28gVk0gdGhyZWF0IG1vZGVsLCBhIGd1ZXN0IGNhbid0IHJlbHkgb24gYSB2VFBNDQpwcm92aWRl
ZCBieSB0aGUgaG9zdC4gIEJ1dCBhIGd1ZXN0ICpjYW4qIHJlbHkgb24gYSB2VFBNIGltcGxlbWVu
dGVkIGluDQphIG1vcmUgcHJpdmlsZWdlZCBsYXllciBvZiB0aGUgZ3Vlc3QgY29udGV4dC4gIFdp
dGggQ29DbyBWTXMgaW4gdGhlDQpBenVyZSBwdWJsaWMgY2xvdWQsIHRoZSBwYXJhdmlzb3IgYWxz
byBwcm92aWRlcyBvdGhlciBkZXZpY2UgZW11bGF0aW9uLCBsaWtlDQp0aGUgSU8tQVBJQyB0byBz
b2x2ZSBzb21lIG9mIHRoZSB1Z2x5IGludGVycnVwdCBkZWxpdmVyeSBpc3N1ZXMuICBJbiBhDQpj
b21wbGV0ZSBzb2x1dGlvbiwgaXQgc2hvdWxkIGJlIHBvc3NpYmxlIGZvciBhIGN1c3RvbWVyIHRv
IHByb3ZpZGUgaGlzDQpvd24gcGFyYXZpc29yLCBvciBhdCBsZWFzdCB0byBpbnNwZWN0L2F1ZGl0
IHRoZSB2ZW5kb3ItcHJvdmlkZWQgcGFyYXZpc29yDQpjb2RlIHNvIHRoYXQgaXQgY2FuIGJlIGNl
cnRpZmllZCBhZ2FpbnN0IHdoYXRldmVyIHNlY3VyaXR5IHN0YW5kYXJkcyB0aGUNCmN1c3RvbWVy
IHJlcXVpcmVzLiAgRm9yIEF6dXJlIENvQ28gVk1zLCB0aGlzIHBhcnQgaXMgYSB3b3JrLWluLXBy
b2dyZXNzLg0KDQpUaGlzIGNvdWxkIHR1cm4gaW50byBhbiBleHRlbmRlZCBkaXNjdXNzaW9uLCBh
bmQgSSd2ZSBnaXZlbiBvbmx5IGENCmZhaXJseSBoaWdoLWxldmVsIGFuc3dlci4gICBUaGVyZSBh
cmUgYXJjaGl0ZWN0cyBhdCBNaWNyb3NvZnQgd2hvIGNvdWxkDQpwcm9iYWJseSBnaXZlIGEgYmV0
dGVyIHJlbmRpdGlvbiBvZiB3aHkgd2UndmUgcHVyc3VlZCB0aGUgcGFyYXZpc29yDQphcHByb2Fj
aCB3aXRoIFNFVi1TTlAgZ3Vlc3RzLg0KDQpNaWNoYWVsDQoNCj4gDQo+IEl0IG1pZ2h0IGhlbHAg
d2l0aCBiaW5hcnkgZHJpdmVycywgYnV0IHdlIGRvbid0IGRvIHVwc3RyZWFtIGtlcm5lbCB3b3Jr
DQo+IHRvIG1ha2Ugc2lsbHkgYmluYXJ5IExpbnV4IGRyaXZlcnMgaGFwcHkuDQo+IA0KPiBTbywg
bm8sIHRoZXJlJ3Mgbm8gc2ltaWxhciBURFggc29sdXRpb25zIHBsYW5uZWQsIGF0IGxlYXN0IGZv
ciBMaW51eA0KPiBndWVzdHMuICBVbmxlc3MgSSBtaXNzZWQgdGhlIG1lbW8uICBLaXJpbGw/DQo=
