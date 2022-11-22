Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4146349BB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiKVWCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiKVWCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:02:31 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11021026.outbound.protection.outlook.com [40.93.199.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E212A5FDE;
        Tue, 22 Nov 2022 14:02:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcq0j6ccxqZlmsg7+ViiZEMAxCkXfVFky+a8REZBYV50SP05qT8UpXGwDAYf9IHmCrEpgzjLQCrveIfpxah8LHf5sIWY1axRmwI248q6S0VQ6Sh4MKymXt5EILMB7ZMX77/DfaW4r5FvUSbDn2TnBbpzUEQXsB3MvVKwyp6Poc/0g6UFouIrq6G/pqh8lgNjWoVLs2Siim5u0srzXoJ9pVeqogogTVxlFGFMxehrdBw72YrB8SyeaJYB5IhwMqaCyELJrjHDpxI5dZMYalwlkFPB3DjL1Hpa5OIdr3Y5oo1hhcCqdHSvg16w3HHz2YqohKCwSZttpRpKqBlK4tRVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/kwRdPdLsfNY5D5WvEtssYBvdPnWXGcxxOy2Pyttkc=;
 b=d/9bCzNWd0YutMSk94yiwNk3YDHqVIcAMw4R/Nr5vG2Rm528elDcaGTZ3RNS+Z/GO8Yr/+CsNDXz4m/Gx2PCCiC3JwiqcejRYYMqONqHMD6f5VazPZMJv0/oDc/ygC0N48NiRfY+/9Zl52XPlJVy/shbt4nbGhrj+yfin9FKQX25sIAnBKtARtd3uast0Rdskq+8PM+aZwNY+zkJ5rpiOfeeqiZ6jnNwFYjVRWJEq+15qSHbAYF4Rmj/aa8Q4TDKYKqT8i4BpF/It9W0EBfYEJ5Y9j7amqEc4u9jgWECtt7iEPi25kZviWZ5TM07TQEVJD+jijd3SRrM01Iodl/0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/kwRdPdLsfNY5D5WvEtssYBvdPnWXGcxxOy2Pyttkc=;
 b=FwOo73a6NS/Hz6hc+yNNGbenC/G+LcCGSLnE4CfA4EJ5uAJKUg3iO4le5EncOAhWyYpKdydcdShZjqjlCNgSi6nvHZibXkfiBmqLSgTXwx3h0Ydkn8LJA5zvO2Ot6XDssmA+fQrFiKo4XQf6gofV8ymjzvoFHPdOaaF+xF9TNsQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN2PR21MB1438.namprd21.prod.outlook.com (2603:10b6:208:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.2; Tue, 22 Nov
 2022 22:02:23 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5880.002; Tue, 22 Nov 2022
 22:02:23 +0000
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
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
Subject: RE: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAAiYgIAANXqQ
Date:   Tue, 22 Nov 2022 22:02:23 +0000
Message-ID: <BYAPR21MB1688888557A5807AE0754CCAD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <cff68b1a-c239-4d52-27b0-536079243981@intel.com>
In-Reply-To: <cff68b1a-c239-4d52-27b0-536079243981@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6c665557-8915-4ba9-8bed-e22079cb76ce;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-22T21:41:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN2PR21MB1438:EE_
x-ms-office365-filtering-correlation-id: 6fa4d8de-2694-45bc-439c-08daccd53bf4
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v8zngJZHePDuCae0PYiyqfERe4/UFt8mTw27Co9OXHWNkEjp2AnIkbnpDDetFh8RRr9tuDkGzE9OtPLmsPbrDppSQKzk6RbmH6LFtfhxB2msNcCmEZ2g1cxJNi7iYOb3SUpP45/St9KxgCG8M7UEp3oprM8kUYkPDJ0gxYbN7Hlx2kHCiXY9F4RxyTHqTs1mzJKLfBoIEa2Z0urlZrF5PZNnVveVRCLsHiObM+KOZKeI+GmitlejhTLBqTauhyEFNCfIvPTpseHipFWnYY52XDiEZGsZrESSCuy8CjZgBpHTTbWqJeVCOUjyHcIbn/7GGLbj3iW0Nn36uXSN7D20Ec+xE4GOYpkF+Hw2cp2I8exxi52iT/T85fxjF0LYy+3sjWml7A46z4vY7jlZGQWiXL1hF2/WzeMc2c5cqNEyUuWDR9hBBwoMQeL04Yd0d16FSI+II+MYkjRPUzFj0IeKJCN1gjETdwZIt0Vaf8dMrG0eAjmXFwPHmplWiQ6i0DeMVTf2Fw3Zjery53/iI6jWSokCDw0QILfJUmVpj39AiR/mENxFPwapbqOq4BwL/QmFXyKpVScKjYpH53/xl3u0UtKD/18Ne3gC0vk14c4UKDDzmYgCkMycwFn1abIN/K3dU0ImJaQliRAl36uPN5+a680XtJL2PE8aVXjAUVmfI5hqT1YuGFqPeRlNVCMCrYjf7ZfXWI++sOaCbMl4/qVcipd7Lrop5zaYqMMA6hrV+/Brn1hZkfrzaNVq9SWNQj7X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(8936002)(82950400001)(82960400001)(71200400001)(52536014)(186003)(38100700002)(5660300002)(122000001)(7416002)(7406005)(10290500003)(86362001)(26005)(110136005)(53546011)(7696005)(6506007)(33656002)(316002)(54906003)(55016003)(38070700005)(41300700001)(9686003)(4326008)(64756008)(8676002)(66446008)(66556008)(66476007)(66946007)(76116006)(8990500004)(478600001)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWY4eExEV1NpMEhGdnBMVm1iOEpXalRQa05iUjlYb280RU0rdUxZeGZodDVw?=
 =?utf-8?B?S25aYklvKzB5eTJxamlNNzNGVklnVE1oeGR1MzRHWU5ROVovVWFzaDd4SzBr?=
 =?utf-8?B?WEtDQm1sSzNRWkNlKzJmd3E4d29EWThNWHFvRUZRWWRRaUNPRlZKd3EwMHc3?=
 =?utf-8?B?dWFtMWFVeWN0dzVObWgyNUQxS01Ya2RoTmMrbjZpbGxhcjloVDZFaU1nQTIz?=
 =?utf-8?B?eGhXcnVXTnJqckVaOXBQUnNRWTVqVS8xc2R4Zy9qQXFkYkNNTVJHdVNuM0Uz?=
 =?utf-8?B?RUkrZWNvWE85MExKSW8reSthUWpJem9USldLY1dUWlN3L2Z5N0JxQXZ0YWdz?=
 =?utf-8?B?Zm0vTG52dXRvREk5WEZqdGJqMDFtTHVtVWxIUHhoYnZjNDUzNkhrZjRSNHVk?=
 =?utf-8?B?NVZQVDBiQWtwQ05sdjhhSnVYSytmMzRSSU0vb28yTGluZ1RUTmtlU3YxU0hx?=
 =?utf-8?B?cGFTV2VmbTVBRTExV2dkMUNMY2NhRmsyVW5ya1FSTE01ejc1dGhDNEtUNGd2?=
 =?utf-8?B?SU5RTnhlcVJzY2NPM0tRT3dpNldQMzhtamdObWZUeDNQdi9RYm8zV0tsZTZF?=
 =?utf-8?B?VU1MZFZ2K1lXbEQ2dksyMjlkcVFyamRRTFQ1RSsxNlpCOWdUb3pCWktBbW53?=
 =?utf-8?B?VlhYNnVDWGo5OW14RGV0SHNzWGFpWE1PYzg1aWFlV3BSdmVwdlgvRlZ0TXB5?=
 =?utf-8?B?OFRBSngvQ3BLa0RyUW1PYmVkRXliOVArVTBIU1BXS0VOT1QrRjAySFVJWmdH?=
 =?utf-8?B?YURHa2pZSGFvMC9VN29Db2VROG1xU2htenplVFJqZWVMWlQ1NXlUUWYwRGxS?=
 =?utf-8?B?RHNNV2RwRW9FZy83S3Uza2RmcnZLRFNvbk82VGtpMnBmeUVreTdNVVVVM0lv?=
 =?utf-8?B?RVNNc3BRRG9aU3phdGFyMktoeHh4OEd5elpuQkFpZ05kQkFjMkpJMlJoeThw?=
 =?utf-8?B?NFBIdU1FcGJIeFVBb083eWRNSUdvazYyNEVSczNSSzdnaU9kNGsrSDVqeG1q?=
 =?utf-8?B?VzZHQW1GelhZa0hRdmd6UGp6WkhQYTNMeUlzSno1QzBpZ25COHNDTHVUS2ZG?=
 =?utf-8?B?Qm9VKzhYbk1May8zTkkyZHU5bDRobEc3eG9VOEpyZXAyL2VKbGprdlArL1dP?=
 =?utf-8?B?aDVDbUp3cEpSYkZKN1VvYStxWlFmQ3ZRaHg2YXdGZE90dW53MkJQRUhET1Jm?=
 =?utf-8?B?Q3lRN1g0Nkh6NDZpVjRpMGgxUXBVWXlYVmhjYnRiVXhlOFE4SGxqbjhMZWlX?=
 =?utf-8?B?TDhZR04ra2VzalM4clhhRGNmdjR6bTZsVXFVRStYMFZrWEhHenZhRGkxT0Zn?=
 =?utf-8?B?bXVSeXFUZHRveHY5aFBXcS9oZkxKRkJCK1NKR1EwWVNkdDUxOTVpOFhlQWYv?=
 =?utf-8?B?N3dDWWp3d29kY3NNY3RDTStKSzFpYm1RcDlpVkZiVyt3K2pmT0pXQVBmQmts?=
 =?utf-8?B?alVvY2JScG1BMjNWcE9rS2hQekx5Y20rOU0xT0d1aWRtYSt2NXh5aUNsbVVK?=
 =?utf-8?B?Z2tzdW1Xa0xmZVpIckRFVzdDRm90VlpEcEIyRTA3dW9PZWdTVXd4N3gvL3Jv?=
 =?utf-8?B?Tlh3dTNyUmwrNWNkLzhxNGRTK3laODY2WitXL3k2OTNDcDFNZ2pHRThEeFU0?=
 =?utf-8?B?dmswNU9HZ1FaSnhwL0orK1ZFWUlxME5MS0FKOE5SNzdkNW5hcnd1cHpxVWFo?=
 =?utf-8?B?VXgzek5tS3B3Sm9sN29rc0VhN1BUR2xWL0Q4b2RrM2pOZXhabkFIRlU1WXBj?=
 =?utf-8?B?b0R3RFV5bi9BZHNHMTFNdEM2WXhjNENEK0JzeDhXdnFVSklsL1N2anVBZnBF?=
 =?utf-8?B?dEpyM2tUdXk4U2VsRlQxWlZ0WFQ2V0RpMCsybnZNSU53bzFEV1RjK3FBTVM2?=
 =?utf-8?B?MTkyTXlqNnRBOStnYURqNDUrSnBPck5hU2Vaa09ubGZ1bkwyZDA2bzVQalNh?=
 =?utf-8?B?ZEcyenl0TGhhRENwWGdyZVB1ZjRuNm0wclBWL1p2cEdFR1A3bmZJbG9kN3M3?=
 =?utf-8?B?TExiRVJPNWEvTU05NGJjVlRhZWxobkRPYWZlZHpuT2MzR0l0WFE1bUY1Mnl4?=
 =?utf-8?B?Q3dqRjZuUFoxREdSTXZCVXdYTzloa3pDQ3dORm9ORXpwWEJqK3l0ZzhJYVFK?=
 =?utf-8?B?czM5NG13Ym1uL2haM0F3TGtPNUZydHMwb3hEa3hOaHRnVUdqUTQwQUJiSHBO?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa4d8de-2694-45bc-439c-08daccd53bf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 22:02:23.1998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A3ABfqQ/nGumRBFOK+9Gpf0PmKxa2r2gD1sJE+t3dxZbMwMwDaFstHWY0WOyTURt1wgQ20mCuAJQuSZoQi0qKa1fIaRFaiaUdRcs0pSqpvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgMjIsIDIwMjIgMTA6MzAgQU0NCj4gDQo+IE9uIDExLzIyLzIyIDEwOjIyLCBNaWNo
YWVsIEtlbGxleSAoTElOVVgpIHdyb3RlOg0KPiA+IEFueXdheSwgdGhhdCdzIHdoZXJlIEkgdGhp
bmsgdGhpcyBzaG91bGQgZ28uIERvZXMgaXQgbWFrZSBzZW5zZT8NCj4gPiBPdGhlciB0aG91Z2h0
cz8NCj4gDQo+IEkgdGhpbmsgaGFyZC1jb2RpbmcgdGhlIEMtYml0IGJlaGF2aW9yIGFuZC9vciBw
b3NpdGlvbiB0byBhIHZlbmRvciB3YXMNCj4gcHJvYmFibHkgYSBiYWQgaWRlYS4gIEV2ZW4gdGhl
IGNvbW1lbnQ6DQo+IA0KPiB1NjQgY2NfbWtlbmModTY0IHZhbCkNCj4gew0KPiAgICAgICAgIC8q
DQo+ICAgICAgICAgICogQm90aCBBTUQgYW5kIEludGVsIHVzZSBhIGJpdCBpbiB0aGUgcGFnZSB0
YWJsZSB0byBpbmRpY2F0ZQ0KPiAgICAgICAgICAqIGVuY3J5cHRpb24gc3RhdHVzIG9mIHRoZSBw
YWdlLg0KPiAgICAgICAgICAqDQo+ICAgICAgICAgICogLSBmb3IgQU1ELCBiaXQgKnNldCogbWVh
bnMgdGhlIHBhZ2UgaXMgZW5jcnlwdGVkDQo+ICAgICAgICAgICogLSBmb3IgSW50ZWwgKmNsZWFy
KiBtZWFucyBlbmNyeXB0ZWQuDQo+ICAgICAgICAgICovDQo+IA0KPiBkb2Vzbid0IG1ha2UgYSBs
b3Qgb2Ygc2Vuc2Ugbm93LiAgTWF5YmUgd2Ugc2hvdWxkIGp1c3QgaGF2ZSBhOg0KPiANCj4gCUND
X0FUVFJfRU5DX1NFVA0KPiANCj4gd2hpY2ggZ2V0cyBzZXQgZm9yIHRoZSAiQU1EIiBiZWhhdmlv
ciBhbmQgaXMgY2xlYXIgZm9yIHRoZSAiSW50ZWwiDQo+IGJlaGF2aW9yLiAgSHlwZXItViBjb2Rl
IHJ1bm5pbmcgb24gQU1EIGNhbiBzZXQgdGhlIGF0dHJpYnV0ZSB0byBnZXQgdGVoDQo+ICJJbnRl
bCIgYmVoYXZpb3IuDQo+IA0KPiBUaGF0IHN1cmUgYmVhdHMgaGF2aW5nIGEgSHlwZXItViB2ZW5k
b3IuDQoNClRvIG1lLCBmaWd1cmluZyBvdXQgdGhlIGVuY3J5cHRpb24gYml0IHBvbGFyaXR5IGFu
ZCBwb3NpdGlvbiBpc24ndA0KdGhlIGhhcmQgcGFydCB0byBzZXQgdXAuICBXZSd2ZSBnb3QgdGhy
ZWUgdGVjaG5vbG9naWVzOiBURFgsDQpBTUQgIkMtYml0IiwgYW5kIGFyZ3VhYmx5LCBBTUQgdlRP
TS4gIEZ1dHVyZSBzaWxpY29uIGFuZCBhcmNoaXRlY3R1cmFsDQplbmhhbmNlbWVudHMgd2lsbCBt
b3N0IGxpa2VseSBiZSB2YXJpYXRpb25zIGFuZCBpbXByb3ZlbWVudHMgb24NCnRoZXNlIHJhdGhl
ciB0aGFuIHNvbWV0aGluZyBjb21wbGV0ZWx5IG5ldyAobm90IHRoYXQgSSdtIG5lY2Vzc2FyaWx5
DQphd2FyZSBvZiB3aGF0IHRoZSBwcm9jZXNzb3IgdmVuZG9ycyBtYXkgaGF2ZSBwbGFubmVkKS4g
ICBUaGUgQU1EDQoiQy1iaXQiIHRlY2hub2xvZ3kgYWxyZWFkeSBoYXMgc3ViLWNhc2VzIChTTUUs
IFNFViwgU0VWLUVTLCBTRVYtU05QKQ0KYmVjYXVzZSBvZiB0aGUgYXJjaGl0ZWN0dXJhbCBoaXN0
b3J5LiAgQW55IG9mIHRoZSB0ZWNobm9sb2dpZXMgbWF5DQpnZXQgYWRkaXRpb25hbCBzdWJjYXNl
cyBvdmVyIHRpbWUuICBXaGV0aGVyIHRob3NlIHN1YmNhc2VzIGFyZQ0KcmVwcmVzZW50ZWQgYXMg
bmV3IENDX1ZFTkRPUl8qIG9wdGlvbnMsIG9yIENDX0FUVFJfKiBvcHRpb25zDQpvbiBhbiBleGlz
dGluZyBDQ19WRU5ET1JfKiBzaG91bGQgYmUgZHJpdmVuIGJ5IHRoZSBsZXZlbCBvZg0KY29tbW9u
YWxpdHkgd2l0aCB3aGF0IGFscmVhZHkgZXhpc3RzLiAgVGhlcmUncyBubyBoYXJkLWFuZC1mYXN0
DQpydWxlLiAgSnVzdCBkbyB3aGF0ZXZlciBtYWtlcyB0aGUgbW9zdCBzZW5zZS4NCg0KSSdtIHBy
b3Bvc2luZyBBTUQgdlRPTSBhcyBhIHNlcGFyYXRlIENDX1ZFTkRPUl9BTURfVlRPTQ0KYmVjYXVz
ZSBpdCBpcyByYXRoZXIgZGlmZmVyZW50IGZyb20gQ0NfVkVORE9SX0FNRCwgYW5kIG5vdCBqdXN0
DQppbiB0aGUgcG9sYXJpdHkgYW5kIHBvc2l0aW9uIG9mIHRoZSBlbmNyeXB0aW9uIGJpdC4gIEJ1
dCBpZiB3ZSByZWFsbHkNCndhbnRlZCB0byBqdXN0IG1ha2UgaXQgYSBzdWItY2FzZSBvZiBDQ19W
RU5ET1JfQU1ELCBJIGNvdWxkDQpwcm9iYWJseSBiZSBjb252aW5jZWQuICBUaGUga2V5IGlzIGNs
ZWFubHkgaGFuZGxpbmcgYWxsIHRoZSBvdGhlcg0KYXR0cmlidXRlcyBsaWtlIENDX0FUVFJfR1VF
U1RfU1RBVEVfRU5DUllQVCwNCkNDX0FUVFJfQUNDRVNTX0lPQVBJQ19FTkNSWVBURUQgKHRoYXQg
SSBhZGQgaW4gdGhpcyBwYXRjaCBzZXQpLA0KQ0NfQVRUUl9HVUVTVF9VTlJPTExfU1RSSU5HX0lP
LCBldGMuIHdoZXJlIHdlIHdhbnQgdG8gYXZvaWQNCnRvbyBtYW55IGhhY2t5IHNwZWNpYWwgY2Fz
ZXMuICBUaGUgY3VycmVudCBjb2RlIHN0cnVjdHVyZSB3aGVyZSB0aGUNCkNDX1ZFTkRPUl8qIHNl
bGVjdGlvbiBkZXRlcm1pbmVzIHRoZSBDQ19BVFRSXyogdmFsdWVzIHNlZW1zDQp0byB3b3JrIE9L
Lg0KDQpBbnl3YXksIHRoYXQncyBteSB0aGlua2luZy4gIENDX1ZFTkRPUl9IWVBFUlYgZ29lcyBh
d2F5LCBidXQNCnRoZSBiZWhhdmlvciBpcyBzdGlsbCBlc3NlbnRpYWxseSB0aGUgc2FtZSB3aGVu
IHJlcGxhY2VkIGJ5DQpDQ19WRU5ET1JfQU1EX1ZUT00uDQoNCk1pY2hhZWwNCg==
