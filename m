Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE23263B116
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbiK1SU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiK1STn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:19:43 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021019.outbound.protection.outlook.com [52.101.57.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F66A2AC7E;
        Mon, 28 Nov 2022 10:06:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dR6WJk0FQaWwgFfMcxFZMWNHhZJtuxMfgpevwW+v9ZEzkEz7/FKrqzFBSTbkaHQveNvy6DIGv8oYMcYoInP0j3YB+W09NQpf7WG0wtFkxnIrjd6FgTIuyL5qDVJ40xJeRsabVfWERkd/si+1GrSbLZGFCFYIVReeoxKwUccvZAkyDcqzgN4lUxOGReMAIKZWW4NV0LVq8SDfCdxcskIiA7z/xjhYb4wV624RLQZ6t0HYB0zOimwKf3XdZD8Ahumz/oM1K+RTJ0NU8b8NbhLLivLsRBBuZlrgABKtLq3b9cSvjXv0MLVIG5jDWODFEOenLvScM/I73qWntLUxSofYkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxxPwB2akai3saP/93ma8ag5k74qZK0TqXBTmZHmBRw=;
 b=JTe3jPwUWRMSP7yfu1gU65lcqO5FkZxUyoaCHo91i0M9dninkzepQu9cPiBIFX7W0Xd/+ZNuYMqUNJImTEIsLxuZMz0kXYCBcQpZEXf/BvtVOXSS7Xg+uOe0VtjL0OiCR8chv1YbEYkpmk1agrVz+xizTmeq+bw5dRXZIGyK2t3Jdi1qesO3hOy7Ad1u8dYCNSJDaa6/4Uom7/gKFfAyGdanOjYpeXmQVt04XvAH5azTYtgebqKokZZapeNqsd22HouXZe3cP5JlnoPhe4yviBZJcb4Tw701+qosRmxjDhWZpzZZGMwEFDiXJ5d3BR+cyp2n9kZzqCt4qoWyibU1nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CD1PPF08B6E7A8B.namprd21.prod.outlook.com (2603:10b6:340:1:0:2:0:4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 18:06:26 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 18:06:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
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
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
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
Subject: RE: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Topic: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Index: AQHY+s4ztxnVbL+L5UCX76A2RK98j65D/NUAgA+0gRCAAMDsAIAAP/RQ
Date:   Mon, 28 Nov 2022 18:06:24 +0000
Message-ID: <SA1PR21MB1335D3133B884CA4221BB16DBF139@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
 <SA1PR21MB133512D4B7B78DB38765EBFEBF139@SA1PR21MB1335.namprd21.prod.outlook.com>
 <fbf2cdcc-4ff7-b466-a6af-7a147f3bc94d@amd.com>
In-Reply-To: <fbf2cdcc-4ff7-b466-a6af-7a147f3bc94d@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f2833e17-622b-4296-b903-afed3f98bbc2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-28T18:04:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CD1PPF08B6E7A8B:EE_
x-ms-office365-filtering-correlation-id: 32abef16-6f50-43c0-f816-08dad16b4332
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSGs1Y5//Apu12L8w2j6Bclmyq0UzVBX6nPAdyZyWLMgfIST6DjH6cC+bYpggyBUe6Kw5jLFlLQnz6Mq+kZfErmbisviythZmSHITyN0AQ9gavB0bvz1v3D0kwa+72/pXr1Kj+eOj6exSHemg9REKoVqRUJrJXut6vyYqwUHFjYVvltgGDFuSTOYb3kUlHG3wLAMXqAJK1Wddv6TGPGeynUe92aZoSSgyNI6qA2334qoxLdU1rNqzjLzv3J1spOMCLCKDYzSyWcuxxARL3hMRZ+bL4DrT0dBe8vhvOvoaymoRA/q/bWysRak7IuCRJiPjQUUx89yXxXuJZfPLSU9gnjVTI3MfFtFu9nE7LVw7ABMf1OIF8gyG1jDYQg+NFd07x0Lw2GSYaUwZkYZhJUYeq/90P0GjqEUOSGiJjdamO1nmOo2O/NVxfQFAj+69EBwhSnC+vUaAPrmHuZCEI61yAbtZp2TaK5ZiHjA9kftV4x+KxzvmWu/SOarllKCBwZa6uOZlFSIWuZHq05Zke0Kc2Z2fpSWaU4+MFCQJbHcq5glZCLT0+S+phHuchuEpmrpG0h03R+/MmWShObTnszakvF29cGx12JnJVd6P3XCe5UGFgtgvqV/hQUWGWiUa2KWOJ3HiMF+vkP78Q0FlS7lKddpa1NW3T+QuAvZd0eikQ5iQcU1lUCFiEHT8CLV/RjKfGTi5A97UnqCoCBccwiy9vQTItkbmdBp0ArPVdj6pOx6QSCCFprBeTGpPGHHyxHkKKiMchg3TXDPivx5ptxHOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(2906002)(26005)(9686003)(83380400001)(52536014)(5660300002)(4744005)(8936002)(7416002)(7406005)(41300700001)(316002)(110136005)(66946007)(64756008)(8676002)(66446008)(66556008)(66476007)(76116006)(10290500003)(8990500004)(71200400001)(478600001)(7696005)(6506007)(86362001)(55016003)(33656002)(82950400001)(82960400001)(921005)(38100700002)(186003)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGMzV3NtRWYyelpsOVBIcjRUdHc1OXQrc0FOUE54YVc2amZnSEtnUVN6bmZX?=
 =?utf-8?B?QWpiQU9kY2JFU2JOOFQ1U1MxRHpJcDVhMVlSZ3ozSFo4UTZmbE9sY1dLVFlm?=
 =?utf-8?B?R1p5dXlSTDNoenRzdlpUWmliY29wYUFsWFVTSmo4d1F2bTIveElQaDlOSGJR?=
 =?utf-8?B?SVdKWVBEdjVaUHVwSjNlNXN1VTc4OE9JSkNEM1JtaXAyNm9rTURXQU9zdlkr?=
 =?utf-8?B?Y2cvQTU5bzk4M0ZMWE14UXl3K2p1enJ1by90ckNHaytZdE1QVFBOVHlHSWt3?=
 =?utf-8?B?dlZLME8rR2ZXd09maUhRSlBuNStxV3dwbFBWSktxM25aWG11d0lUYTJSTHd4?=
 =?utf-8?B?U3FPemhiZDV1NkhMbnhESTZOejRjdVp4bnZQNU9tdVd2VlJYNHNCZHMxT3J6?=
 =?utf-8?B?ellEb1IxTU13RlNrSnlCZ3pwdEpsNDQvSDk2Nm9YMThXZ1pMUDEzSzV5RlFR?=
 =?utf-8?B?UDZFandzUitHTmNmaGpkMkFCeElRVFA4TUI5ejh0R3kzS3pTZHFOQlpyRWVF?=
 =?utf-8?B?VzRTejhzVW5jdGExT3RHK2hpaGtWZGgzYnA0QnAzRUhUL0RsaUxhejFGYWda?=
 =?utf-8?B?bCtpZG41dmdsWHdGY0I0ZGl5NVo3TzFuUmlObU9UQXN4NG91ZG94amc0Mndk?=
 =?utf-8?B?OFpPdDJBdDFmWkJDRmREeDdGUTQxRDREQnE2RGJFaDNsV3JEeDdzZWw4Tk1k?=
 =?utf-8?B?MVBROC9mQnZ6MllIWlVTRnNMdGxKQnFvMzV4LzQwNUVpT2pvTzJrTEcrU2kr?=
 =?utf-8?B?bURFdEdnY2h1b3dLektwbHFHeTNjZEF1KzVWU1Vpbmk1cUVWaTM0U2lMV1lG?=
 =?utf-8?B?TVJGRmNoZmNya2dMdkZtQ2VPSElaVUlEV29uZk8ybnVlbS9taHZvUWg4QzRP?=
 =?utf-8?B?citGU2hrQ1orclhHc3pNbHVKLzhzZnV4NGxoVG9TSU1xZFc5VHJ0MDZ2dk12?=
 =?utf-8?B?SU9zZUQxYXZPclFoUmNieUJDdmZOcVFGcTZ0OERHRGRFVG5sQ0NlYlhNdkNB?=
 =?utf-8?B?QmlwVVNwRHpUR1ZwY3Fsc1hzQXA5M1k0b2ttQTN3N2cxeWczZ2MrbkdGUHJY?=
 =?utf-8?B?THVwTE5VQWw5WWx0NURsUXFQZ2Y1Tml1SHcrd01DWUwxRDRjdjNwaXZHc25B?=
 =?utf-8?B?VUR5RFZjdjBtYWFxMTZwQzVKWXhsaXJKTk1PdUg2eGZCOTFBSVpGZWQ1Q3lr?=
 =?utf-8?B?bVQ4Rk90Q2FiV0NhdG0rWkJObzVEWVBiTnhhbGpGVGh5ZHNiY1VvNUdaTkE2?=
 =?utf-8?B?ZUxiRy9Ia0JUOWUwYUY5VzJtRGxJM3k2WjFYdlVYczl5cVJVSDJQT0tNZFBr?=
 =?utf-8?B?VFdQS0ZNVU5sSWVDN1BLbjFvK2RtejlndWRLN250dU5GWnNyS3pJWjI5Wk1Y?=
 =?utf-8?B?WFBSOVF0UFFSUHdXSDZBZHFCc1piSDJoeWhMRmZ0Y3RWRVB1dTRVcW95L3Jh?=
 =?utf-8?B?eVN5VEd5YXBuM1lTNVEvSXNWd2FhRElsMjllOEg4ZW9SOGxZNXhNQWpWWUsz?=
 =?utf-8?B?djMwYlVQelRzZmNPeWFtalBCRUpCbDlrR3FVRG91T0huc0kvZHNaVkJpK0JF?=
 =?utf-8?B?OUcwVnZxSG50M1F4NnRKTDlkbjJWMksvM1BSYVhGMmhVRXh6cTRXa2VDVzhr?=
 =?utf-8?B?Mkh3OTYyaGN4Sy9veGtzMlc3eFhpQitqOHhWOE14M3krREJyblVYb1RTKzRN?=
 =?utf-8?B?MmFua1hNQWp4d09GcE8zU1J6bW9TTUZwU1pqMExPU2JhR2w4cE55dk9zaGhB?=
 =?utf-8?B?djdPUERLTFZSRHFBREtvaG5NeldXdW5kRXNLaTlMOUM0ZFRlZjJRZkx3aWlx?=
 =?utf-8?B?Zm1qWnhreEZ2TytuUjJxdTlHWWx2d2t2L1NPUDQ5bzlFQlJyUUdGeGo2a3hm?=
 =?utf-8?B?c1k4VUNycEtPdjNEMHc4ZXB5WCtKZmdJVGEyeVNzbTNCUGVPcVhaMERucGd4?=
 =?utf-8?B?WnZlNGlnc1k4UVovTUkwNFhGWEg3RWgzY2VQenhldzBiREczMXh5QjRiWWZM?=
 =?utf-8?B?WnlIV3lCYXlBTjFOb2VHeWgrMjdTYmNUR0luRlYrVGcydzVuc3pCandraGFH?=
 =?utf-8?B?eDJDYXA4VjZPellzMXpWcmZGLzdmeEJpcVZWSFpWRU43L3RjM3pCcGRrNDlv?=
 =?utf-8?Q?ScbBbVr94ThmmSpiunYypb2eg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32abef16-6f50-43c0-f816-08dad16b4332
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 18:06:24.5152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oS4YbM3Xx1bSkr5HU78Xpb0WZY8WfuLjq1a5TZTrRim7uyvZxPzkmhCEPnPqvCO+K847bDhU/d0OkgQ9fiXyvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CD1PPF08B6E7A8B
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0KPiBTZW50OiBN
b25kYXksIE5vdmVtYmVyIDI4LCAyMDIyIDY6MTYgQU0NCj4gPiBbLi4uXQ0KPiA+IE9uIGEgVERY
IHN5c3RlbSAqd2l0aCogQ09ORklHX0FNRF9NRU1fRU5DUllQVCwgdGhlIHVudXNlZA0KPiA+IG1l
bW9yeSBpbiB0aGUgYnNzX2RlY3J5cHRlZCBzZWN0aW9uIGFsc28gbmV2ZXIgZ2V0cyBmcmVlZCBk
dWUgdG8gdGhlDQo+ID4gYmVsb3cgInJldHVybjsiDQo+ID4NCj4gPiBJJ2Qgc3VnZ2VzdCBhIEZp
eGVzIHRhZyBzaG91bGQgYmUgYWRkZWQgdG8gbWFrZSBzdXJlIHRoZSBkaXN0cm8gdmVuZG9ycw0K
PiA+IG5vdGljZSB0aGUgcGF0Y2ggYW5kIGJhY2twb3J0IGl0IDotKQ0KPiA+IFsuLi5dDQo+ID4g
Rml4ZXM6IGIzZjA5MDdjNzFlMCAoIng4Ni9tbTogQWRkIC5ic3MuLmRlY3J5cHRlZCBzZWN0aW9u
IHRvIGhvbGQgc2hhcmVkDQo+IHZhcmlhYmxlcyIpDQo+IA0KPiBJIHRoaW5rIHRoZSBGaXhlczog
dGFnIHNob3VsZCByZWFsbHkgYmU6DQo+IA0KPiBlOWQxZDJiYjc1YjIgKCJ0cmVld2lkZTogUmVw
bGFjZSB0aGUgdXNlIG9mIG1lbV9lbmNyeXB0X2FjdGl2ZSgpIHdpdGgNCj4gY2NfcGxhdGZvcm1f
aGFzKCkiKQ0KDQpZZXMsIHlvdSdyZSBjb3JyZWN0Lg0K
