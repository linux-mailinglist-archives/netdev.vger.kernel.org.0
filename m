Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9572632E67
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiKUVEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiKUVEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:04:11 -0500
Received: from DM6PR05CU003-vft-obe.outbound.protection.outlook.com (mail-centralusazon11023020.outbound.protection.outlook.com [52.101.64.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0BBDB847;
        Mon, 21 Nov 2022 13:04:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeUtyUK4NFCQgdDpo/62fcKJZi6l9HkGQskch2A+XORTfoX4q5HGlzvxgToW9g6yFzYL/JI+GBFlBByG3p80yp1AfRVdrja+2m7iUuelvogyuCt+dEScKwvLuRst6/ZTKFtHMjpdVbjhCEQ/N9Mca0gtqK6v5TYRX3wlOyK+Q6J09Dgn7+PG4i2P2w27K76KnnQAFWW756SCPliORRY2daOEiS3Wyu/K/Db2pdelriMB3QxkvJV3THZWUQDutRTzSA1a1XC1AZ6R4Y6ODNpwTJvFNBJiIR3S/O6T/jgyxXwCXUXFw8dp9DzX2nLDFy4tc3Ll8jP59zNnp4GCYnpg8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXvkLmRj3k7vxik/1kMav/AfSiGJe5dOXukxe7mereE=;
 b=UbUikTr8VzqYhJDg9oAQ6I3uvebkLC/hln1SyqLl26cWAJKoAoqBkdB7AlZlfdOIWsmrRzTHDnOGBLcsWYXrzE3S67Ox7rUnmRS5xlBrmndpHlavMa1OP7Zh+S2Va90juAl2nzf41dGVdXxbO/6lDN9V53DKUA3cekcbIcmY41zIA7fQVu+iuxkrMg82roQxdsYNbEl93WcQWEcIMP/GffVedCvnQMWq25CdHl+lSAt/emP6Hzn+k2VWpgXIMB4NqaH/sogVY2gTE/tay1LFhoHdrHQjeG7Ydl4UDNzqRTCkSqsM+tEu4UHnivOVkKJv54J/SQC3piDf2SUQPA/NsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXvkLmRj3k7vxik/1kMav/AfSiGJe5dOXukxe7mereE=;
 b=G7/3kjKy+eff2cIsksbfJLzsxMnPbyv6XKjPzYHnjK+Z55VCHw92mAWBgnn22sah7OP9bxYdeKLE8X0r2WYJq5S4Do7MZGylNth8PjnSLxfFmByc3xdh/5DrD5sWXgwipXhyPq5oknZt24FFsK5TW8v76yEz8d4wEAY4x0+ER0k=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by LV2PR21MB3399.namprd21.prod.outlook.com (2603:10b6:408:17d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.1; Mon, 21 Nov
 2022 21:04:07 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5880.001; Mon, 21 Nov 2022
 21:04:07 +0000
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
Subject: RE: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Topic: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Index: AQHY+esrEByVeSYqBke7qvqW2Lryi65JtliAgAAu3xA=
Date:   Mon, 21 Nov 2022 21:04:06 +0000
Message-ID: <BYAPR21MB168831473395F841EF51E541D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
 <e5f9529f-955c-fc28-5d46-c77f23a71d04@intel.com>
In-Reply-To: <e5f9529f-955c-fc28-5d46-c77f23a71d04@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b9ddfb9d-3fe2-4b94-bea7-309c0a575b0a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-21T21:02:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|LV2PR21MB3399:EE_
x-ms-office365-filtering-correlation-id: 6924d30e-d8fd-4870-bc3b-08dacc03ed99
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JUjKUa+D2U7WtEAufQMy7/wbdPAZ/W21fbmou7YKOp+q+pfi97XZOe5I/QLaUJVYksZ4+VatFpbRj1n27FLsyqgDsF8Ct2xaffINVALDyn7zLBqY/tLbqtzIhf7tlA/1N4y3nIZRcxfDgGkLvncsl2e+RwE05JJVFBcS02uAqzdMN15GLp6DgFu5GaWHDreGHFw97nSEtnlNs1GQ9nuUE5lJbVLX2vxTiF7DDymYNoUtBB5xVhqCPRwRHmfQeq+lY2UYHyDQSWzwARYk7dJdW4fBadz27uz3CqGKtvys5M1La9oaIQJPyEZ/geo479aV2FuDeHap/C3LwPHG+FArlgREONstxFdniryyq+U1Y7dksL/f8xkOWKwZpFxPE71TO5gr37zJzzDOJR1DjfTFlzEFAzljs0/UE6RvgfKxLxH2wgh9X8Lp+rMupucn23YtSi9vGMe1SJD04ytocc9t3OF/D9/gIIcAFiTs/QJA5VzU1cjzVdsSG8sQg6zVeU9xpiS5ZCUPr2IZqCz1z7S6wUGQ8HQVZcdcPgLbPShLK2iRUn7uOUnKvXjabCEtdHfdVUaMRoQiDP3hmOtlnpjWB/bpjr6lpQIpy7eVXQgDRV9Mb+cggOpxV0W1rWhWpsYNtvIbv5p3frxMgCL3msc+YjF6Vaap3Hcpirl4MbRyRyGDPP3gtl8pz5I/dYse5IV7IAJtP27S1m4urCsxdc2ZEbc5jldaxfJuqCEjZkTIfz/9Qksl6KVz7fiPJq4Pa4vMHBN4H/gmlzVitXHTCb9ohg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(83380400001)(33656002)(2906002)(186003)(316002)(5660300002)(38070700005)(921005)(7416002)(7406005)(52536014)(82950400001)(82960400001)(55016003)(8936002)(71200400001)(8676002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(86362001)(122000001)(38100700002)(41300700001)(8990500004)(10290500003)(110136005)(53546011)(26005)(9686003)(7696005)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmRFdExlSDBRNkcrMGN6eWpuSUNHUWxSZjJIcEZYS0NqZHgyWnZ2bHZUL3NW?=
 =?utf-8?B?RG8xMDAvc2lCUk1FOUx4ZVZDL200ZGdPMms2eG9JZDVIbEo3MDNDd2hyRk5x?=
 =?utf-8?B?UmhCaGVjT0xYVldUSEVVUDlBMmRTSHh3aWduclFFQUpqUGhQOG9LS3poMWRO?=
 =?utf-8?B?MnRHR08zMStZN1dXSjQrZ1VMdGU2WkxHN012U0kzVFFQM2ttdGpUdDBGTmtm?=
 =?utf-8?B?c0dENzZPREpSeGhMbTVKU0YwcjROZHFkYlF3SmVPMHlabUNzRVlLcjdWS091?=
 =?utf-8?B?NGFlK2dNNXFEVG1FM2xEZzRHaFRWWkdhZEtmazlWNmYwSXExajVuNEowNTJt?=
 =?utf-8?B?N0M5cGd5RFBlWTAvbmg3T0x2MFR5a2ZSZFpQbzZsS2NZK09ZWm1NVGxMQTQ4?=
 =?utf-8?B?dHBTeUY4elRKenljdmFSbUo1ZktsOG90RzNPZTJqQ2l3OE82QVFXci96OEZS?=
 =?utf-8?B?T0VOQjI1Rk43NWRnYW5wcmt1MEYrVkFZV1JOVTY1ckYxb2FzMGxyUm5OQ0xJ?=
 =?utf-8?B?VFBYaDN6MTFzdkdmTnNZMGE5NGlvMTFLZjNIblV3UXlmcmI3L0lXWGc1Z1dr?=
 =?utf-8?B?QTJHREgvSG80YmZManRtbkh3d01ocmw3Wmd6dHVBZ2tENlZGNE80RTlXcm9m?=
 =?utf-8?B?TmNuOVRQZTUzVFJDSkdWcnNnaGhpNDJDY0k3Y3hlYjNET3VNQTdVS25vMFY5?=
 =?utf-8?B?YVpGVGI2bnZ4RHRBMHdDRUVjQjhqTkwzc0RYMGFqZS9GajFOVUdaSDFvd2lF?=
 =?utf-8?B?VlRJWHdRSUtjdy9kZEtNdDAreEVzZnFmU2hqY2k2MGFHcEZuWEhjbFRPWkp3?=
 =?utf-8?B?dkZjb21obXpmbE5PT0dCcDRkRXRJdVRNQW1oeURUcjRsdndhM1hlTWxtdkVa?=
 =?utf-8?B?ZVNybjdWd054SS9GdFBXazF2MXBRTWZneGp3ZFNod3JZOUVXdEszUmNmUXFP?=
 =?utf-8?B?ZnpUWTgyWE1qdHNHUzhrVVBscWlwSExkUE0xVmNJN2dpdDFEV3J1emQ5bW5k?=
 =?utf-8?B?UFRKL2VsM1BHcGwydWpaVzVaeG55RDI0OUFjc3J0a2JuTStsZFI1bjVvOCtM?=
 =?utf-8?B?QzJFWjlBSnpZd09xQm9xeEVTYWVJemhNWVNBZ1JYKzAveG5oUnhsK3M1cjVQ?=
 =?utf-8?B?MmVEOEF0U2Jhdlp0blJQUzdhdXJucW1yTHowMHZIY3dtSndRVUw2QUQ4d1Ji?=
 =?utf-8?B?dWk0TlhyNjdDL1NhSENOVTViVTRVeExxd09hdlZ1Z09uYzJsb0k1UTJHMjU1?=
 =?utf-8?B?d1ZHVzhIWmI4R1U1VnkybDRGQ21mMlFBNGg5NUZCSVptSHdFZ2QxaWsyOHVw?=
 =?utf-8?B?MHgzYzZ4TXMzY3FKNlZUSWJFaFk4K0djaTRYcU1UYmlJMUJmODRJSUZWdEpM?=
 =?utf-8?B?b2NFV0g2YS9KMkwvYzMzSHovV05oWW9FMmZIQTFNZjBBNnRReVZHaFdpbm9v?=
 =?utf-8?B?c2t0Q3Nhb20wdkVaUnZlOS93SWZpWnMxUWgvR3p5QlMzVk1JV01nOG4xSk5C?=
 =?utf-8?B?K0p2RHdLOEF2WVJmSkdpc2RKcUpWS1g2NUhBemxSWDBPeW1lb1UrblVxWHl0?=
 =?utf-8?B?UEhLSVlTTTIvVkI1dzl1WnJkTmZ4anF6NmdTNVdjRVBJdUNKbnJ2Y0NrdjE2?=
 =?utf-8?B?TmJwWkE2SFl3bzBwaU15c3dyS3lBT29QajZ5cHVUQXZ2UTRkbFNKSmp0R0J0?=
 =?utf-8?B?eVhzbWJKc0tveTg1TjBodDFVbWl3L2xQUGRxdCtDSU5Va2doZTZ3SXJsVngz?=
 =?utf-8?B?SGcyQlZWSjRaWkJ4SUFRY2JrYUdVdDVVN2RwLzFIRVRiY3VXQldIa2NjNVhw?=
 =?utf-8?B?Y2UvNWRESVZRMkljbXdTMTNMVDFYQllEL2t1LytuWmJUODdNVW1zZFVFWnky?=
 =?utf-8?B?bTVJQmNxWDcxSGVWZnZjUmxIWFR2M1d4OEcyZTFEb09tZVdJUUUrV2MydDA2?=
 =?utf-8?B?bUY0cC9LR0tNdkVDcVNUb2dwc2lXQnh4MEpBZThGc2QyZEhha2FGU3A2Y1Y3?=
 =?utf-8?B?bHhnYzVHUmhUcHVrUDVvNm9Sc3hyTWZobWVSYWQxRDlZZmFMdjltaWRFcTBL?=
 =?utf-8?B?TWVJK2FYbzJlK3A4em1WQ0o3T1BsQzdYbUVvNU1RcDdYMVEyaXFmRHFnREJ6?=
 =?utf-8?B?bW9uaTFiSUpEZjZKTWhJRWlZem5uSWduNi9YcUpaQUhITEZSMUVoN1orMjMz?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6924d30e-d8fd-4870-bc3b-08dacc03ed99
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 21:04:06.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXqIwCpg4MJxXNDKAv9BHLnMfFzfEt670V21WNV/bW7gtkouaBjPaqJs39/5prysyhnShdcUONMnaeEIuJkqRQV4soGcHxUFh6AuRFxk5t4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3399
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogTW9uZGF5LCBO
b3ZlbWJlciAyMSwgMjAyMiAxMDoxNCBBTQ0KPiANCj4gT24gMTEvMTYvMjIgMTA6NDEsIE1pY2hh
ZWwgS2VsbGV5IHdyb3RlOg0KPiA+IEN1cnJlbnQgY29kZSByZS1jYWxjdWxhdGVzIHRoZSBzaXpl
IGFmdGVyIGFsaWduaW5nIHRoZSBzdGFydGluZyBhbmQNCj4gPiBlbmRpbmcgcGh5c2ljYWwgYWRk
cmVzc2VzIG9uIGEgcGFnZSBib3VuZGFyeS4gQnV0IHRoZSByZS1jYWxjdWxhdGlvbg0KPiA+IGFs
c28gZW1iZWRzIHRoZSBtYXNraW5nIG9mIGhpZ2ggb3JkZXIgYml0cyB0aGF0IGV4Y2VlZCB0aGUg
c2l6ZSBvZg0KPiA+IHRoZSBwaHlzaWNhbCBhZGRyZXNzIHNwYWNlICh2aWEgUEhZU0lDQUxfUEFH
RV9NQVNLKS4gSWYgdGhlIG1hc2tpbmcNCj4gPiByZW1vdmVzIGFueSBoaWdoIG9yZGVyIGJpdHMs
IHRoZSBzaXplIGNhbGN1bGF0aW9uIHJlc3VsdHMgaW4gYSBodWdlDQo+ID4gdmFsdWUgdGhhdCBp
cyBsaWtlbHkgdG8gaW1tZWRpYXRlbHkgZmFpbC4NCj4gPg0KPiA+IEZpeCB0aGlzIGJ5IHJlLWNh
bGN1bGF0aW5nIHRoZSBwYWdlLWFsaWduZWQgc2l6ZSBmaXJzdC4gVGhlbiBtYXNrIGFueQ0KPiA+
IGhpZ2ggb3JkZXIgYml0cyB1c2luZyBQSFlTSUNBTF9QQUdFX01BU0suDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBNaWNoYWVsIEtlbGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCj4gDQo+
IExvb2tzIGdvb2Q6DQo+IA0KPiBBY2tlZC1ieTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxp
bnV4LmludGVsLmNvbT4NCj4gDQo+IEFsdGhvdWdoIEkgZG8gYWdyZWUgd2l0aCBCb3JpcyB0aGF0
IHRoaXMgc3VwZXJmaWNpYWxseSBsb29rcyBsaWtlDQo+IHNvbWV0aGluZyB0aGF0J3MgaW1wb3J0
YW50IHRvIGJhY2twb3J0LiAgSXQgd291bGQgYmUgYmVzdCB0byBlaXRoZXIgYmVlZg0KPiB1cCB0
aGUgY2hhbmdlbG9nIHRvIGV4cGxhaW4gd2h5IHRoYXQncyBub3QgdGhlIGNhc2UsIG9yIHRvIHRy
ZWF0IHRoaXMgYXMNCj4gYW4gYWN0dWFsIGZpeCBhbmQgc3VibWl0IHNlcGFyYXRlbHkuDQoNCllv
dSBhbmQgQm9yaXMgYWdyZWUgYW5kIEkgaGF2ZSBubyBvYmplY3Rpb24sIHNvIEknbGwgYWRkIHRo
ZSAiRml4ZXM6IiB0YWcuDQpJJ2QgbGlrZSB0byBrZWVwIHRoZSBwYXRjaCBhcyBwYXJ0IG9mIHRo
aXMgc2VyaWVzIGJlY2F1c2UgaXQgKmlzKiBuZWVkZWQgdG8NCm1ha2UgdGhlIHNlcmllcyB3b3Jr
Lg0KDQpNaWNoYWVsDQo=
