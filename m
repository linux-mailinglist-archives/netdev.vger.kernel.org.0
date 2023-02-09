Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA1690F3C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBIR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjBIR3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:29:17 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790CB31E24;
        Thu,  9 Feb 2023 09:29:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9iR+pgktDGKqOCDVXOydqa/CJGTPcEi8qdp0JNDkhpzMfXDz68MS2RpoqtGiiGy8LLnh2UfVaH4gM55Tzayyh5rJWAnoHpzJnQoH5bTX4zlFlj+z1bJy+7O2v3qnYzw1GlvgJF9v61LFOzjMx3GMRfSUDK7kujnXpySlbPrxyCfCqBCfpi3xiBbrNM1EuJKbEZlBD3f0ASQoHyN5mj+TZVxPyBpvCEQjABT3Lz/7+ZUpN1wl60AeJNIp6UfZLYpyItZ71oNdutNw2C8qWhQCubiWBI6/2nRSIeOe7z6P9WauebBK2TtQ4W6ufxJw5uIKIwfPzcP3n2h01aU3s6bkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8kCFD3cm6esnSON5rf9x4kOtnCTZR5cpWlXqldm1i4=;
 b=aesaao82qWs71nNnhILIebsYYJZp9Xh/ngwwiB5DIHTStqZVa150UFmYZuQAm0PR9S5vEtA9IqhPsMsP/9chL9eA3VeGSHmHBeacBzIHzLKOECOI7g2Vt51rVyLWS61BS+BNF0OEW9nkyLFmLixhcCv8WFIX68QbCTZ3YZ3K6hkvH8qRiUebwIcGUkAM81+11NrDZeQQVkRcwBYqd4wxtYDeDVqlyrcLBcvnHLpw+9YUK86aNQ29cVmeIfGj3AF9Jw7VZ81hmUF+IP4bAA1mE5wHVA3gOvzLeoZAaTTrkdOp+M5973RbcodM+JyjPUTdCBBhetJDT2I8iQP4bcGZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8kCFD3cm6esnSON5rf9x4kOtnCTZR5cpWlXqldm1i4=;
 b=AG1mnQkBB9ujOtjf4Ie8kOkeAqSAjLIN+RDyH35dHaaRYWW6uVlX7T3cC/Psq68bueQbzBPbv+0/srUMxjLO4C1mGW3jMcQ/LlFWXPyZlfeISntt1SvotGi500I3AT3NFfo5ioNvgTnk/1zufyEF7HWj1zHneoUW3xUQGwIpKbw=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH8PR21MB3924.namprd21.prod.outlook.com (2603:10b6:510:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.2; Thu, 9 Feb
 2023 17:29:13 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.004; Thu, 9 Feb 2023
 17:29:13 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAGgMUIAACvuAgAACa5CAAAOQgIAAR90QgAD62gCAAbeZgA==
Date:   Thu, 9 Feb 2023 17:29:13 +0000
Message-ID: <BYAPR21MB16886A07302A09B96FFFAE84D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <BYAPR21MB1688A80B91CC4957D938191ED7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KndbrS1/1i0IFd@zn.tnic>
 <BYAPR21MB1688608129815E4F90B9CAA3D7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KseRfWlnf/bvnF@zn.tnic>
 <BYAPR21MB16880F67072368255CBD815AD7D89@BYAPR21MB1688.namprd21.prod.outlook.com>
 <76566fc4-d6be-8ebf-7e9d-d0b7918cb880@intel.com>
In-Reply-To: <76566fc4-d6be-8ebf-7e9d-d0b7918cb880@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0c510f67-3e18-4c6f-a7e3-20cfb8101efb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T17:22:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH8PR21MB3924:EE_
x-ms-office365-filtering-correlation-id: 36a2c528-3114-4dad-9a6d-08db0ac32950
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJY+JmnVYdeNCy1SFUkHGxFOJ/fgco/2Q9ODTz+1+AFhhw762JUG/dDRv15oM7mx7cWFLf9mQdQpjd8nKSy3l+DFFEkwbEGSK/yFf8iM+aXlf08U+sWeqbSyNqAfIPu5UqBRMpnpuGxrBIYEXQz4wPPxdzvGgaQ35JB8rUzQCxycI71/Ts723bbGiB1SKfi5dMiE8bRHbwRbdaj8gLGq8DZZW0uxVY5ZmuseOfr74gGLEmIpUKqQROTsED2VP8hJXjrebx3xQDQXBkvVcoy8E1qshnMbx+WTddgIFU8tKI/AauIQfPEHaZ/WDqZXu/Q4GEcGnY3DfsNdQZTqG1FoGf5GC8gG4mPfwVZ7wMWq5ghUrBJ0ZcBM2eN/GfQZgoxIGbWJDzxFCYVZKB1fxZCXd3C4EJpzslb1UJt2ufOowljLdw/9E8LQH94i5ifZERRXSzCZqPssq6OHf2UmhzRy/PNXtAQ3NMSfZhHR9RvrtosNTy5sUzLC+Msqjq4CTGTAQZhmD02S7YhlnzhVL+LE7h5nleZPmU8Gr44eLAUzVcTDByjjhASepq83jaTRzgt3qB4tH+KXuL3Q9yDhP/DVnOLdfC8X3yFngz0Ff59uVfFoFrbmQurg7hGBHcNcjJsGvqUJSgybZGAHnVKWgfQJSccZfA2nqVi/GA6/BP2OotnLrlLiKgKlKgF1VJYIvaCo8V8oL5FJ3prJz6OCjwABHf7ll9ldqmdZ1IBWzf9yq5XH9AoKpwbbZzYOKPwuALbj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199018)(7406005)(2906002)(7416002)(8936002)(5660300002)(41300700001)(52536014)(66946007)(66446008)(66556008)(76116006)(66476007)(55016003)(33656002)(8676002)(83380400001)(64756008)(9686003)(6506007)(54906003)(110136005)(478600001)(8990500004)(10290500003)(7696005)(71200400001)(186003)(26005)(53546011)(4326008)(82950400001)(82960400001)(38100700002)(38070700005)(86362001)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emdTd05QZ2xnOXJJMnkyZyswRGNDaFhmeXlCaWFMSW8xcUNmMDlhc2NJNS9L?=
 =?utf-8?B?L0U0cmUyL1N3S3ZPWFNVUE9XZzBHSkZLRFUyS2thekRaVDhTYmptYXBMN2Qv?=
 =?utf-8?B?OU40dWh2MW1GK3lvVU9KaWV6OEpLQWZ1QkpiY0VDSmJyaGtSZEp1L3J0UHlU?=
 =?utf-8?B?MDFJUUl5bVpuNTVWd2lXb0Y1bzJhRU9VOWdFemxsdDVOTnMvK3RPaGtlcGh5?=
 =?utf-8?B?TitGVGwzSy9LZ3RaWVhFNm1kYmlPWCthOHR5RU41ZjZLbkVWcjlBbHJldmVF?=
 =?utf-8?B?SGVnMjR5NTI4WFUyMExrWnFJRHpwZ01KVWlTdTlGdWFLeDN5bXFCdExIVGtJ?=
 =?utf-8?B?TFFIVExhUHoyK2xDYzN1R1pGQWx3TGdSNXJnZ0hzWnRWMkRwbEhscVpBM0Vo?=
 =?utf-8?B?WGlVZmJhNmZ2VERWQjgrQjFSNzRqaThKbzVqdmVFcVFjNm81c3kzc2RaQnBJ?=
 =?utf-8?B?c1h4THVFWXFLaGluL0NBK1dHM1R5MzducGVnWStjNU1BWGlHU01pQUZmSjlJ?=
 =?utf-8?B?SEt4YnFzQk0vb0VneldBR00zdEphSWhRS0RwN2srVEhzZytKZGdReWFpS094?=
 =?utf-8?B?YlVmd2R2bU02N1NONVYwSnVtS3kxaEluTWJHanFLOVE0aURveHhuMDk2eTRu?=
 =?utf-8?B?cHBNb1VGcmZINXVtVndGSS9VMEt2emRUVHlwNjF3S3VETWdEVlhDbEM3SUQy?=
 =?utf-8?B?TUljaXpWamp1NExkTVd6c21RMUZGVWxBYmFsNXQyTFJtdXZMaFJ3QUFHbks2?=
 =?utf-8?B?b0pqdWQ4R1F0aHVDY01TMmFEL29tandyK2xQU3JzWFkwZlQrWFBLVlBjZ29X?=
 =?utf-8?B?dlRHdUsrdjJUYW9nazBxY3p3Tms5eTlCRWNRSnJQejNWUExaWDAwZHY2M2hR?=
 =?utf-8?B?UUNiODN4M1pYZnRoRjBxZklMRm14dmNiSEpLWDQvdGRpQnNjVzJBR1ZwaXVJ?=
 =?utf-8?B?Z21WRmd6dkc5UEI0ZmxhT0pVMDNFSnlyS0FqcVlZV1FlMWxSTndHc2wvaGJF?=
 =?utf-8?B?SFg1RmVBL2ZsYWxaOFRaV0k4RWFvMWQzcFJ4Y3EwMU42djJxYWZSZUhCdmJV?=
 =?utf-8?B?TlFFb3lkSUVlV1dnUVBzRDFPRHpGZkE4dE9Oak9STk53cVFQWExDWmpjZnNO?=
 =?utf-8?B?M0IyYkZ3bnoyVFFWc0gyWDlZU1FjQldUZWpBVzBIeEVCd0lFQXpKZWFhOWVN?=
 =?utf-8?B?SHBEQWthdVc1S0hobTRwNzM5c1dmMVJlRExiOWhBZExqVzR2S2FUTlh6bzc5?=
 =?utf-8?B?alRqWVplclNpaFhVQzNkQlRVcGpyYkYvOEovczBpTEJLWksrMC9PVGV4Z0Ev?=
 =?utf-8?B?dGZHY0ROMlczZHpKd2ZNek9VREVKMjMwMFB4dVQ1aXo4MUxvNGxPS25MT2dh?=
 =?utf-8?B?ODZuWlFjMDFpSW82YXZlVjArQXorL1Q5WUpHU0N5S3JHOWk1V1JpNDZXdERk?=
 =?utf-8?B?V3VqR1lFQXJLd282Ym81ZEZCM2hXM2hENGI3citjWGtEN1dacmYvR1l5WEQ4?=
 =?utf-8?B?QkhxNFE2b29tdEUydXZrR1BtN3dKQnhXNW1CSFNBTUlHdmw4elNJK3NPUzln?=
 =?utf-8?B?TEc5RE5US1YxWjJ5VDdHOEJrLzZJY0VRNHhXU0ZaK2VkOWlvTnpBUEpwczJt?=
 =?utf-8?B?OUNDQ0FXSzZMK3o4RTg1SDZXUVZHTlR6Njd3ak5NdjVScHdWTGhxR005d2xW?=
 =?utf-8?B?dVZ0TWRsL3k5NmdtMW9YM3o4UlFvUU1idi9aV0MxeWV0b3JXT0szaTl0U2dm?=
 =?utf-8?B?S3p0YlI1eWdzRm5TYWxqdjhtL0FXYUYzb1NadTRmNG91YlZ6aEs5K1pzam5t?=
 =?utf-8?B?dG1yYzQ5b0xqSGpRRUl2UDJsVkppbnU0UkRSN1hITXhjeXlXVEdCcVVsaCtG?=
 =?utf-8?B?b05PalV5QlZKVmpHUlVzY2VGZURTR2VEbnpDcityRS9UeEwrWTNJRzRjRjFI?=
 =?utf-8?B?RkhLZjJvS2JIR3IxOG05MU5HdjZxRHZMU1hKbE9yQlJUanVCU3hJdFZ2eHkv?=
 =?utf-8?B?TVJOOWw3TjdsUXZHc1V3NUQraEQyZWcwYlhXcmFBVUR2M3B5REhvY2JPL0xN?=
 =?utf-8?B?KzVXcS9YNzJvYllLakh2K0NLempwRWNHaWJ5OUVvdkdOZzg1NUt5L1pvMVhz?=
 =?utf-8?B?ZXVSUzFzSUYvdWZlN2swV3NoNWd6WUVxV0tNNERLR0pQL2tYU2NJVzZiOFR5?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a2c528-3114-4dad-9a6d-08db0ac32950
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:29:13.0949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8LJJpVDThkJH7906aOaep1qNS082pHdlCHcGWKj7143fbHrAGAjC+DEVMIGTxIOZgt+DM+k+o3NMV3L1R4zl1cXLf7etvgZw9+7YMWCWd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3924
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
LCBGZWJydWFyeSA4LCAyMDIzIDc6MTAgQU0NCj4gDQo+IE9uIDIvNy8yMyAxNjoxOCwgTWljaGFl
bCBLZWxsZXkgKExJTlVYKSB3cm90ZToNCj4gPiBJbiB2MiBvZiB0aGlzIHBhdGNoIHNlcmllcywg
eW91IGhhZCBjb25jZXJucyBhYm91dCBDQ19BVFRSX1BBUkFWSVNPUiBiZWluZyB0b28NCj4gPiBn
ZW5lcmljLiBbMV0gICBBZnRlciBzb21lIGJhY2stYW5kLWZvcnRoIGRpc2N1c3Npb24gaW4gdGhp
cyB0aHJlYWQsIEJvcmlzIGlzIGJhY2sgdG8NCj4gPiBwcmVmZXJyaW5nIGl0LiAgIENhbiB5b3Ug
bGl2ZSB3aXRoIENDX0FUVFJfUEFSQVZJU09SPyAgSnVzdCB0cnlpbmcgdG8gcmVhY2gNCj4gPiBj
b25zZW5zdXMgLi4uDQo+IA0KPiBJIHN0aWxsIHRoaW5rIGl0J3MgdG9vIGdlbmVyaWMuICBFdmVu
IHRoZSBjb21tZW50IHdhcyB0cnlpbmcgdG8gYmUgdG9vDQo+IGdlbmVyaWM6DQo+IA0KPiA+ICsJ
LyoqDQo+ID4gKwkgKiBAQ0NfQVRUUl9IQVNfUEFSQVZJU09SOiBHdWVzdCBWTSBpcyBydW5uaW5n
IHdpdGggYSBwYXJhdmlzb3INCj4gPiArCSAqDQo+ID4gKwkgKiBUaGUgcGxhdGZvcm0vT1MgaXMg
cnVubmluZyBhcyBhIGd1ZXN0L3ZpcnR1YWwgbWFjaGluZSB3aXRoDQo+ID4gKwkgKiBhIHBhcmF2
aXNvciBpbiBWTVBMMC4gSGF2aW5nIGEgcGFyYXZpc29yIGFmZmVjdHMgdGhpbmdzDQo+ID4gKwkg
KiBsaWtlIHdoZXRoZXIgdGhlIEkvTyBBUElDIGlzIGVtdWxhdGVkIGFuZCBvcGVyYXRlcyBpbiB0
aGUNCj4gPiArCSAqIGVuY3J5cHRlZCBvciBkZWNyeXB0ZWQgcG9ydGlvbiBvZiB0aGUgZ3Vlc3Qg
cGh5c2ljYWwgYWRkcmVzcw0KPiA+ICsJICogc3BhY2UuDQo+ID4gKwkgKg0KPiA+ICsJICogRXhh
bXBsZXMgaW5jbHVkZSBIeXBlci1WIFNFVi1TTlAgZ3Vlc3RzIHVzaW5nIHZUT00uDQo+ID4gKwkg
Ki8NCj4gPiArCUNDX0FUVFJfSEFTX1BBUkFWSVNPUiwNCj4gDQo+IFRoaXMgZG9lc24ndCBoZWxw
IG1lIGZpZ3VyZSBvdXQgd2hlbiBJIHNob3VsZCB1c2UgQ0NfQVRUUl9IQVNfUEFSQVZJU09SDQo+
IHJlYWxseSBhdCBhbGwuICBJdCAib3BlcmF0ZXMgaW4gdGhlIGVuY3J5cHRlZCBvciBkZWNyeXB0
ZWQgcG9ydGlvbi4uLiINCj4gV2hpY2ggb25lIGlzIGl0PyAgU2hvdWxkIEkgYmUgYWRkaW5nIG9y
IHJlbW92aW5nIGVuY3J5cHRpb24gb24gdGhlDQo+IG1hcHBpbmdzIGZvciBwYXJhdmlzb3JzPw0K
PiANCj4gVGhhdCdzIG9wcG9zZWQgdG86DQo+IA0KPiA+ICsJLyoqDQo+ID4gKwkgKiBAQ0NfQVRU
Ul9BQ0NFU1NfSU9BUElDX0VOQ1JZUFRFRDogR3Vlc3QgVk0gSU8tQVBJQyBpcyBlbmNyeXB0ZWQN
Cj4gPiArCSAqDQo+ID4gKwkgKiBUaGUgcGxhdGZvcm0vT1MgaXMgcnVubmluZyBhcyBhIGd1ZXN0
L3ZpcnR1YWwgbWFjaGluZSB3aXRoDQo+ID4gKwkgKiBhbiBJTy1BUElDIHRoYXQgaXMgZW11bGF0
ZWQgYnkgYSBwYXJhdmlzb3IgcnVubmluZyBpbiB0aGUNCj4gPiArCSAqIGd1ZXN0IFZNIGNvbnRl
eHQuIEFzIHN1Y2gsIHRoZSBJTy1BUElDIGlzIGFjY2Vzc2VkIGluIHRoZQ0KPiA+ICsJICogZW5j
cnlwdGVkIHBvcnRpb24gb2YgdGhlIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3Mgc3BhY2UuDQo+ID4g
KwkgKg0KPiA+ICsJICogRXhhbXBsZXMgaW5jbHVkZSBIeXBlci1WIFNFVi1TTlAgZ3Vlc3RzIHVz
aW5nIHZUT00uDQo+ID4gKwkgKi8NCj4gPiArCUNDX0FUVFJfQUNDRVNTX0lPQVBJQ19FTkNSWVBU
RUQsDQo+IA0KPiBXaGljaCBtYWtlcyB0aGlzIGNvZGUgYWxtb3N0IHN0dXBpZGx5IG9idmlvdXM6
DQo+IA0KPiA+IC0JZmxhZ3MgPSBwZ3Byb3RfZGVjcnlwdGVkKGZsYWdzKTsNCj4gPiArCWlmICgh
Y2NfcGxhdGZvcm1faGFzKENDX0FUVFJfQUNDRVNTX0lPQVBJQ19FTkNSWVBURUQpKQ0KPiA+ICsJ
CWZsYWdzID0gcGdwcm90X2RlY3J5cHRlZChmbGFncyk7DQo+IA0KPiAiT2gsIGlmIGl0J3MgYWNj
ZXNzIGlzIG5vdCBlbmNyeXB0ZWQsIHRoZW4gZ2V0IHRoZSBkZWNyeXB0ZWQgdmVyc2lvbiBvZg0K
PiB0aGUgZmxhZ3MuIg0KPiANCj4gQ29tcGFyZSB0aGF0IHRvOg0KPiANCj4gCWlmICghY2NfcGxh
dGZvcm1faGFzKENDX0FUVFJfUEFSQVZJU09SKSkNCj4gCQlmbGFncyA9IHBncHJvdF9kZWNyeXB0
ZWQoZmxhZ3MpOw0KPiANCj4gV2hpY2ggaXMgYSBiaWcgZmF0IFdURi4gIEJlY2F1c2UgYSBwYXJh
dmlzb3IgIm9wZXJhdGVzIGluIHRoZSBlbmNyeXB0ZWQNCj4gb3IgZGVjcnlwdGVkIHBvcnRpb24u
Li4iICBTbyBpcyB0aGlzIGlmKCkgY29uZGl0aW9uIGNvcnJlY3Qgb3IgaW52ZXJ0ZWQ/DQo+IEl0
J3MgdXR0ZXJseSBpbXBvc3NpYmxlIHRvIHRlbGwgYmVjYXVzZSBvZiBob3cgZ2VuZXJpYyB0aGUg
b3B0aW9uIGlzLg0KPiANCj4gVGhlIG9ubHkgd2F5IHRvIG1ha2Ugc2Vuc2Ugb2YgdGhlIGdlbmVy
aWMgdGhpbmcgaXMgdG8gZG86DQo+IA0KPiAJLyogUGFyYXZpc29ycyBoYXZlIGEgZGVjcnlwdGVk
IElPLUFQSUMgbWFwcGluZzogKi8NCj4gCWlmICghY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfUEFS
QVZJU09SKSkNCj4gCQlmbGFncyA9IHBncHJvdF9kZWNyeXB0ZWQoZmxhZ3MpOw0KPiANCj4gYXQg
ZXZlcnkgc2l0ZSB0byBzdGF0ZSB0aGUgYXNzdW1wdGlvbiBhbmQgbWFrZSB0aGUgY29ubmVjdGlv
biBiZXR3ZWVuDQo+IHBhcmF2aXNvcnMgYW5kIHRoZSBiZWhhdmlvci4gIElmIHlvdSB3YW50IHRv
IGdvIGRvIF90aGF0XywgdGhlbiBmaW5lIGJ5DQo+IG1lLiAgQnV0LCBhdCB0aGF0IHBvaW50LCB0
aGUgbmFtaW5nIGlzIHByZXR0eSB3b3J0aGxlc3MgYmVjYXVzZSB5b3UNCj4gY291bGQgYWxzbyBo
YXZlIHNhaWQgImdvbGRmaXNoIiBpbnN0ZWFkIG9mICJwYXJhdmlzb3IiIGFuZCBpdCBtYWtlcyBh
bg0KPiBlcXVhbCBhbW91bnQgb2Ygc2Vuc2U6DQo+IA0KPiAJLyogR29sZGZpc2ggaGF2ZSBhIGRl
Y3J5cHRlZCBJTy1BUElDIG1hcHBpbmc6ICovDQo+IAlpZiAoIWNjX3BsYXRmb3JtX2hhcyhDQ19B
VFRSX0dPTERGSVNIKSkNCj4gCQlmbGFncyA9IHBncHJvdF9kZWNyeXB0ZWQoZmxhZ3MpOw0KPiAN
Cj4gSSBnZXQgaXQsIG5hbWluZyBpcyBoYXJkLg0KDQpCb3JpcyAtLQ0KDQpBbnkgZnVydGhlciBj
b21tZW50cz8gIFRyeWluZyB0byByZWFjaCBjb25zZW5zdXMuICBBDQpzb2x1dGlvbiBhbGlnbmVk
IHdpdGggRGF2ZSdzIGFyZ3VtZW50cyB3b3VsZCBrZWVwIHRoZSBjdXJyZW50DQpDQ19BVFRSX0FD
Q0VTU19JT0FQSUNfRU5DUllQVEVELCBhbmQgYWRkDQpDQ19BVFRSX0FDQ0VTU19UUE1fRU5DUllQ
VEVEIHRvIGNvdmVyIHRoZSBUUE0gY2FzZSwNCndoaWNoIGRlY291cGxlcyB0aGUgdHdvLg0KDQpZ
ZXMsIG5hbWluZyBpcyBoYXJkLiAgUmVhY2hpbmcgY29uc2Vuc3VzIG9uIG5hbWluZyBpcyBldmVu
DQpoYXJkZXIuICA6LSkNCg0KTWljaGFlbCANCg==
