Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6D362EC2E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiKRCzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKRCzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:55:41 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021019.outbound.protection.outlook.com [52.101.52.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3415974AA2;
        Thu, 17 Nov 2022 18:55:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnoQp9KlX5rMQvso+Dv8TYtStCcVooFHYYMaADSggdzbujYaIUFWXw3hgPzGZyXuLuHdMqdMy1N+Dia/Ipv1jSraAxMpjFitGSXTTeCcEjZCqSOxLf+ytatIsX/5x9YAPQBtQgg7hmPo66iShPfdqPG1F0T5ik4EPa/wTjKHJNVvkVm922UVMM3F895+FjhE2Bqdl/Jmf3krWr+3XJmuGnEOro7jnJI94liknXoMl/RWu0djFqLAKgdzpZZcgglTMBvNcQlg8aLcEQNyEoG8UGRcTUWTbPw60kKSwE89PY/+HLtWVoYGi8D/K1Wrd77oRRlXOpo+GDtqxrEqITSYMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBPnG5RtHwkiLL9SB7NnKIPFZT4hBVOPjpgaR3Lb2XA=;
 b=Qu690UhM8ekvIza7Zh2RSxiqUrXtFlQ1t4kpCo8cAJjz8mCKIWKsHp/aiGYrpwFlsTkyUkClPBszX5rb2/C6tFni5JnceG6uV+wdN9SkyYn1FJiloDAkyBVuMdHYxkFocL17cnyj/cV+W2Cw7iKp+Z/lEJ1o0RfmUmjBtjqVHlnPLXcNV7ctszksf9BGObIZtaju9LNcdOtT3dggzOv7Nx3YwxsyMPFnJD0a0/7bBewQJX8SnrX86yAGZ5evVai6ZH0q/E5AXV4kieCLM51WzqATj0KprFQ02CcmnFu08RXJ3+E19LyXliAi9AMMQSgrY9gaqaMXzX0z0OXt7f5QiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBPnG5RtHwkiLL9SB7NnKIPFZT4hBVOPjpgaR3Lb2XA=;
 b=DsH2dhWLGS3v7cXXwOjwnAX+5/LSn8TGgYcX0dQotFhh6CNmGt7KPjr9LVYsLp/ViLyXYBELzm074OcfnHY1jk966moWEk3AE61RjDUZM9gQNuC3ZRNeLB04QVf2IykP5YxHpo2O/28aMt+Ydauo9Nz2N6nvK50ZzvpFeRLlZnE=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CY5PR21MB3471.namprd21.prod.outlook.com (2603:10b6:930:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Fri, 18 Nov
 2022 02:55:33 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5857.008; Fri, 18 Nov 2022
 02:55:32 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
Thread-Index: AQHY+esxZzvGjSwYNUG8Av9Zi67yOq5DqJGAgABSJYA=
Date:   Fri, 18 Nov 2022 02:55:32 +0000
Message-ID: <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
In-Reply-To: <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=44062edc-2214-466e-b1b5-eadfe699b503;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-18T02:41:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CY5PR21MB3471:EE_
x-ms-office365-filtering-correlation-id: 7dd53309-13f7-4215-8c37-08dac9105c14
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5YbdcwECcSbW/YNY7LQe8gQm5lKKiyhiP2fZ55RvVHKEkhOrLmcYUqkOtSLKb5saMINzm1+Hpr1bPKwplkpzZZVm0aRiXEaBfFLK/fHdUTaHf+1BnCLPSOwuq25sEw0wSp8zXReB8zk3nx7nMywlLt4kNizHf+I93BZpKLwZoTLeYmI3BLwl2hjOU9P8mPvccYXiQNF88l8sFL91/gDi5rPzdTa7US0V7UZXTGnT7QmzxtUuRfvG38KHC0oE66A0wLkfnQKo9hKySE4mHyif9D8oTiFlZolxOrBSb74yMNdX++okvQLysqF3LsYBhjFiTwa9MzZ9ENB0WT1FRzz6s+tRxGEvdhtVpU11ubVFrgYQlJx8Cg+Hyez10TkIQC0vscA7X4BOGF1jZQylcKgJo3IwZFE8DlQOllwRC63sVAgea6CH/w7y/BlJBIHhIDM7eGkdLt4bBkmLvg7x/ZoM5MQaVNMBTOrRFt2ZGMYRQaRUN4VqOtKiStV/YjBWAri4OMwwpFVI3EAyk4G72WijmAwrQKFfWoUE79XIgaIoMzNTjaw7bJbz8DS8LccMUFNvf48JBxzntwjf651M/6u/ZJ2sQ7DO8cxoPNKb1pHgkCtW9BRKns/92UUVnXRkvK50PaOUdZVZsynbgJxUlODsu+Qrlo7HiextHofFO8ccF3FcspcJNIQnEFh5WdXN2/4AGJfFaj1SaiJLYJtC4VJAKAjKZO9JiOGoyQ0Ff2b5UReby686Xzpbx03Eovy2Rgtq5Gs1dLZs0Fao5SjZNHL9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(10290500003)(478600001)(71200400001)(41300700001)(66556008)(52536014)(64756008)(66446008)(8676002)(66946007)(76116006)(66476007)(8936002)(5660300002)(186003)(7416002)(33656002)(7406005)(7696005)(316002)(110136005)(9686003)(53546011)(6506007)(26005)(82960400001)(82950400001)(86362001)(8990500004)(2906002)(55016003)(921005)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlFYT2dWSE12STNnaENkaTZmdDV2b0JUemxJWXcra1pZbHQ2eXIzRnIyenVQ?=
 =?utf-8?B?KzltT0FKSjFZVFpEMVZhaG5QbUd4RjRJMlNQaWpvcitSd0JxZGVhanhwTFJ2?=
 =?utf-8?B?VzJvbEgrUElrL1BOTWhXcmU5SGpkZkQwK01iblRNcjRMbU9mZE9sRTVHZlJs?=
 =?utf-8?B?elJtRzh5UndXa2JRK0xYbmdlZmhYK1Z3d3dyNWVJV1lWNmNIVjBWTU84Y05o?=
 =?utf-8?B?R3B5QnNmTW9yZ0pRaGRuQmdpRkdScWNIV0k1MzVoS2lBeVBpMUlDdzVaQ0Uz?=
 =?utf-8?B?dkcwSjMxRkRuc2xSSlpSMHhRdDJEc2s3Rk1NZjQvWkF0Mkc2YzMyQ2VKT2Y0?=
 =?utf-8?B?QVFLN1JodzhwdGs5eHBKT3ZNNUZzTkVVU21ndGtoK29xUkNMWmd5R2wvd3Zk?=
 =?utf-8?B?YW1uVjJCcit6aWY0eFFQQTB5dG1na3ZTd3ZZQTB0QUlFVW5kVkcxTXBUeUlK?=
 =?utf-8?B?YkNZYy9BaytUQ0QrY0tXMlViYzRsdDAxamR3OGd0N1dtUDBBTUZad1czVlRp?=
 =?utf-8?B?YkN4MnpwdmJZSk1IcnlWQXc2cXQzQTdVZDdzWGRmNlZFb0p5UGNmalZickVF?=
 =?utf-8?B?Q1lTQWhRSjRxT1IvTGw5azYyaXZ5S3FTbHpiN281NEc3QjRTZEc2S0lzRVo4?=
 =?utf-8?B?NXd5T09zMW85dFJQaGx3ektJSXlZM2EvUFZacXhuQXBjRTVPMHE5WG42QnBD?=
 =?utf-8?B?YWxnaldKbHRZYVdZcDliblNBRjZvcTZCTEtZdDhRWDNqSFViWVk3cUY0cHo3?=
 =?utf-8?B?b0RHa0NpamZpQVFvRXF2WDRsQXJGQjA2N2VaVHBMekJMYjFmWXU3TFdvQzFa?=
 =?utf-8?B?TXJBQzFONDViQUtTOEFSaEdqenR2NHV3bmhkT0lOY2RnZGJVNW0zWm1yM2wy?=
 =?utf-8?B?RnRrVHk4U3M3Zy9DOHlpT1Zvc1JjL3I4ZHd0NWI0d2NUa05nTENocE5ldXRS?=
 =?utf-8?B?TDJmTXdBVnNiNGJtbmozNnViSms4Z25qUDJqZ3JkNVBSZGdzNXNHZmx0aG51?=
 =?utf-8?B?WUhYWCtXN3h1bDNUeWkreVdjM0NQcHdrVWViUWpMeC91MGIzV0hVQ3BnZ29s?=
 =?utf-8?B?RW9BQithYXRBay9lM044T3dSMGpmbmxBOFlyMmNCSjBPT2V0QVdOQ0VRa24x?=
 =?utf-8?B?bDltZWFFMVlZbndtc09DSDNwcldpbllwc2dWM1Y4cXpQWTErb1VzaWVOUDI1?=
 =?utf-8?B?WTcwQ2h3VWc1aTRzUEUvOURXUUxEVFdlWW42ZlQwUlZHdjNybDEwb3F5U2dV?=
 =?utf-8?B?YWRzNmNQR0tVZ3Y3VUtGN1lUZXhSWmx2RG9EOW82ZXFYYUkyOCt6TUs5cGZK?=
 =?utf-8?B?WkJCSGtBN0tIMmlkQlFKNDZIaXo3cWFuT0t0bHY3ZkxVaVVvejJZVkZsNm5C?=
 =?utf-8?B?cWdBMWlGYWplRkx6VFJpclZGQnV0U2Q5VzVjaWU1akVvcGdWbEJzalhWSk1J?=
 =?utf-8?B?Q1JQTFpobDZuQjkrVkJLcGNlRUF5SE5HcGRqeW95VkMyMFdIWHJJbkhwUUxO?=
 =?utf-8?B?ZnpZSmJxU3pxUXdIQUR4QUE5eG1uTm13MmtFaEMrQ1Vwa3pyclQxWUN5dC9T?=
 =?utf-8?B?QnNRMXY4ZzIvNkVxM0RtVTJUVys1bkZ3VjV3cWJuL2gzNGRjMHFDcXJ4Z3dj?=
 =?utf-8?B?YXEwb01yTkpJSE5heDcyVnRmdkpLSzB2UG1VOVpnOGJEUHh1czdNOGhpQnZV?=
 =?utf-8?B?My9NMjAwc2IvNnRiWU5wNkVLY1BEK1R0SXI0M1dkRStmbGs2QzFKK2ZWdXFx?=
 =?utf-8?B?UzNOcmdnNjNUYXExSkpCb01pcDN0UitGLzJJcDl6V3p0SlJGWFdCZXdPUVZG?=
 =?utf-8?B?N2g5SFhEeW9EYUg1MmthMHdSQ1RDOHllUUZOMkMxY0xWdWN3Z2NCQUxpYlhR?=
 =?utf-8?B?dmVuUFkxSUkyYVI3SVhVb3c5SjBDc3BSK250N1l1aHN0ZXU3c2ZKQklpY3JC?=
 =?utf-8?B?dWFZdGIvRWljbFNiZjRaWTAzSWE5S3pXWTRKY3V6Qy9MNS9xOXZBM3ZBdmlH?=
 =?utf-8?B?SXBFT3QvTmdtdG9aMnZuUHl6bU5yTnRYeFczUWRMV00rL1FGdXYwWVBJOGNE?=
 =?utf-8?B?VW5Zbk5JUXkzQ0hFRllVOGxRN3R1N2dRbWpTTmxUL2IzL1ZTN1ZCaEI5QTlt?=
 =?utf-8?B?a20yWVBnT3ZQbDBjMkN1OWtpeW51K1Y3Nk1KaDlPNjBvVTQxU0UzUmxic05P?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd53309-13f7-4215-8c37-08dac9105c14
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:55:32.7544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWe2pKpsZgvyKCVcZvUVWXJPfMZ5o/StnMu3GeYJ6rSiNikiHVVqizgf93wMsirqRXiiPRxxzzMzPCw3Wv4r5U1uA33J6okr15L1UVRENZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2F0aHlhbmFyYXlhbmFuIEt1cHB1c3dhbXkgPHNhdGh5YW5hcmF5YW5hbi5rdXBwdXN3
YW15QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IE9uIDExLzE2LzIyIDEwOjQxIEFNLCBNaWNoYWVs
IEtlbGxleSB3cm90ZToNCj4gPiBDdXJyZW50IGNvZGUgaW4gc21lX3Bvc3Rwcm9jZXNzX3N0YXJ0
dXAoKSBkZWNyeXB0cyB0aGUgYnNzX2RlY3J5cHRlZA0KPiA+IHNlY3Rpb24gd2hlbiBzbWVfbWVf
bWFzayBpcyBub24temVyby4gIEJ1dCBjb2RlIGluDQo+ID4gbWVtX2VuY3J5cHRfZnJlZV9kZWNy
eXRwZWRfbWVtKCkgcmUtZW5jcnlwdHMgdGhlIHVudXNlZCBwb3J0aW9uIGJhc2VkDQo+ID4gb24g
Q0NfQVRUUl9NRU1fRU5DUllQVC4gIEluIGEgSHlwZXItViBndWVzdCBWTSB1c2luZyB2VE9NLCB0
aGVzZQ0KPiA+IGNvbmRpdGlvbnMgYXJlIG5vdCBlcXVpdmFsZW50IGFzIHNtZV9tZV9tYXNrIGlz
IGFsd2F5cyB6ZXJvIHdoZW4NCj4gPiB1c2luZyB2VE9NLiAgQ29uc2VxdWVudGx5LCBtZW1fZW5j
cnlwdF9mcmVlX2RlY3J5cHRlZF9tZW0oKSBhdHRlbXB0cw0KPiA+IHRvIHJlLWVuY3J5cHQgbWVt
b3J5IHRoYXQgd2FzIG5ldmVyIGRlY3J5cHRlZC4NCj4gPg0KPiA+IEZpeCB0aGlzIGluIG1lbV9l
bmNyeXB0X2ZyZWVfZGVjcnlwdGVkX21lbSgpIGJ5IGNvbmRpdGlvbmluZyB0aGUNCj4gPiByZS1l
bmNyeXB0aW9uIG9uIHRoZSBzYW1lIHRlc3QgZm9yIG5vbi16ZXJvIHNtZV9tZV9tYXNrLiAgSHlw
ZXItVg0KPiA+IGd1ZXN0cyB1c2luZyB2VE9NIGRvbid0IG5lZWQgdGhlIGJzc19kZWNyeXB0ZWQg
c2VjdGlvbiB0byBiZQ0KPiA+IGRlY3J5cHRlZCwgc28gc2tpcHBpbmcgdGhlIGRlY3J5cHRpb24v
cmUtZW5jcnlwdGlvbiBkb2Vzbid0IGNhdXNlDQo+ID4gYSBwcm9ibGVtLg0KPiA+DQo+IA0KPiBE
byB5b3UgdGhpbmsgaXQgbmVlZHMgRml4ZXMgdGFnPw0KPiANCg0KQXQgbGVhc3QgZm9yIG15IHB1
cnBvc2VzLCBpdCBkb2Vzbid0LiAgVGhlIG9yaWdpbmFsIGFzc3VtcHRpb24gdGhhdCBub24temVy
bw0Kc21lX21lX21hc2sgYW5kIENDX0FUVFJfTUVNX0VOQ1JZUFQgYXJlIGVxdWl2YWxlbnQgd2Fz
IHZhbGlkIHVudGlsDQp0aGlzIHBhdGNoIHNlcmllcyB3aGVyZSBIeXBlci1WIGd1ZXN0cyBhcmUg
cmVwb3J0aW5nIENDX0FUVFJfTUVNX0VOQ1JZUFQNCmFzICJ0cnVlIiBidXQgc21lX21lX21hc2sg
aXMgemVyby4gIFRoaXMgcGF0Y2ggc2VyaWVzIHdvbid0IGJlIGJhY2twb3J0ZWQsDQpzbyB0aGUg
b2xkIGFzc3VtcHRpb24gcmVtYWlucyB2YWxpZCBmb3Igb2xkZXIga2VybmVscy4gIFRoZXJlJ3Mg
bm8gYmVuZWZpdCBpbg0KYmFja3BvcnRpbmcgdGhlIGNoYW5nZS4NCg0KQnV0IEkgaGFkIG5vdCB0
aG91Z2h0IGFib3V0IFREWC4gIEluIHRoZSBURFggY2FzZSwgaXQgYXBwZWFycyB0aGF0DQpzbWVf
cG9zdHByb2Nlc3Nfc3RhcnR1cCgpIHdpbGwgbm90IGRlY3J5cHQgdGhlIGJzc19kZWNyeXB0ZWQg
c2VjdGlvbi4NClRoZSBjb3JyZXNwb25kaW5nIG1lbV9lbmNyeXB0X2ZyZWVfZGVjcnlwdGVkX21l
bSgpIGlzIGEgbm8tb3AgdW5sZXNzDQpDT05GSUdfQU1EX01FTV9FTkNSWVBUIGlzIHNldC4gIEJ1
dCBtYXliZSBpZiBzb21lb25lIGJ1aWxkcyBhDQprZXJuZWwgaW1hZ2UgdGhhdCBzdXBwb3J0cyBi
b3RoIFREWCBhbmQgQU1EIGVuY3J5cHRpb24sIGl0IGNvdWxkIGJyZWFrDQphdCBydW50aW1lIG9u
IGEgVERYIHN5c3RlbS4gIEkgd291bGQgYWxzbyBub3RlIHRoYXQgb24gYSBURFggc3lzdGVtDQp3
aXRob3V0IENPTkZJR19BTURfTUVNX0VOQ1JZUFQsIHRoZSB1bnVzZWQgbWVtb3J5IGluIHRoZQ0K
YnNzX2RlY3J5cHRlZCBzZWN0aW9uIG5ldmVyIGdldHMgZnJlZWQuDQoNCkJ1dCBjaGVjayBteSBs
b2dpYy4gOi0pICAgSSdtIG5vdCBhdmVyc2UgdG8gYWRkaW5nIHRoZSBGaXhlczogdGFnIGlmIHRo
ZXJlJ3MgYQ0Kc2NlbmFyaW8gZm9yIFREWCB3aGVyZSBkb2luZyB0aGUgYmFja3BvcnQgd2lsbCBz
b2x2ZSBhIHJlYWwgcHJvYmxlbS4NCg0KQW5kIHRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoZSBjb2Rl
IQ0KDQpNaWNoYWVsDQo=
