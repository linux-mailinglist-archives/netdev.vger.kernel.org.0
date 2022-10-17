Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B506012BE
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiJQP07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJQP05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:26:57 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11023020.outbound.protection.outlook.com [52.101.64.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2634461111;
        Mon, 17 Oct 2022 08:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apMbr/HRc/D2gw2UTBlpH/gauR4Kt/MtiwXjZweBnr78cvPQYxcyoNqavkmFv0Lzs3LKKM3xPjuIV/cQzo+EaOR4N4B1kMmeGYyVjwrsXl4IsLDQelKAWs3rYteXpqfmo8sSOyxGiOaaXTyAdNo7Z+XwtPPydhV3BzC3QvSVAFWhSI+rQPEs9/csIpnP0WvbCVAZbaCpP6QBN5z0WVht4byPiVVyknehhHL4a4YGJTdTe4e+erc45RlGoiBm+8/oWYp4xjXueDVUo8rzsb0y0gvonFheaI6DqtizAWk16DTH5tfKc9PucQM/GaaHvjrj7EdoQSXaCT1PPe3C5AMrIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUw14eKzEA/cofZwcCifwXCEI/fELko2CAfniKYxjS4=;
 b=R+zY7mEEuF3RWiugtZz/RRP65dSsNW0Fd6GvPFCnuPuyBQDJXEznqaG1HF+yNafo3wybbZjbMUjrzSv4Lk6Kjq6H/ywF6MWVycDNDYI3bR0CHlaNqABE1TyoczEVPWRYByHoMPYxhABL/yx+T3Xjyw4dGSRsXAyQo5239VhphLjPTU2wvtsz8SD2S8oFXh8+KYn/P++SoaWo3d4P/d8KBodORJLNS/tkwtVeH7tTinLxo6EWvW2K41glWm998rxFZX0v5WuNkovcbZQ66y7iHk1RcjTNnOSDs/6MqGs4odPG0li+/pPd+U9bnFY0kXPiOgmOQgQ5l4pTUIWxSZQsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUw14eKzEA/cofZwcCifwXCEI/fELko2CAfniKYxjS4=;
 b=T1XNIiVODYzdmwhraaDRyP0QUdvtDSE2qGuQZFno32XbDVy20tU4WPacHVBkKb6f8mpMNd1LWWXs/cr3go4+EGkM1yMpWMj3tVsa29hPizaFZQVE93C75Hzy7MbWTKxfPtVIN4K8CcGV9Jok7x5ylK508ti1+OOkC91AuYc7otY=
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 (2603:10b6:805:55::19) by DM4PR21MB3512.namprd21.prod.outlook.com
 (2603:10b6:8:a4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.1; Mon, 17 Oct
 2022 15:26:52 +0000
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::af9b:5444:77eb:448d]) by SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::af9b:5444:77eb:448d%7]) with mapi id 15.20.5746.009; Mon, 17 Oct 2022
 15:26:51 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Wei Liu <wei.liu@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "halves@canonical.com" <halves@canonical.com>,
        "fabiomirmar@gmail.com" <fabiomirmar@gmail.com>,
        "alejandro.j.jimenez@oracle.com" <alejandro.j.jimenez@oracle.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "feng.tang@intel.com" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "xuqiang36@huawei.com" <xuqiang36@huawei.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: RE: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Topic: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Thread-Index: AQHYtBrLfXqegDojNkO+rF0jYYkCGq3+sWWQgAARgQCAFE3LMA==
Date:   Mon, 17 Oct 2022 15:26:51 +0000
Message-ID: <SN6PR2101MB1693BC627B22432BA42EEBC2D7299@SN6PR2101MB1693.namprd21.prod.outlook.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-11-gpiccoli@igalia.com>
 <BYAPR21MB16880251FC59B60542D2D996D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <ae0a1017-7ec6-9615-7154-ea34c7bd2248@igalia.com>
In-Reply-To: <ae0a1017-7ec6-9615-7154-ea34c7bd2248@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e185b1e3-8c76-4d54-aa80-99a5ae5c01ee;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-17T15:23:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR2101MB1693:EE_|DM4PR21MB3512:EE_
x-ms-office365-filtering-correlation-id: 91ca88d6-a29a-475c-9dd6-08dab05403fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Zmo4qAcsIITUsjZBn/mOn5dYY5OIEvgGCCeFavBVvHBv1INIBtjgd+Lyz1K+/xvGUj5nx8GgHmGUNVdUWaMcxnBWMn5y/mY3ubBJegy/4IMyECoZ1/DBDTXTcfD3zvdWQ7gSBzJDPZ4GMcY3nPokdYZ63WakQCShVafKUT0MHQLaGLB2DAmF9oKDY/TBC/fgSQUwuAUlD3yOBvplKRmq0gwvZkGKLo9G7PMxADCbrjz4hfQdMk1Y+6BfPl5HRgI5E5178BQ/EX8NBFAY/cuCekci1y5uzO5BO68IsUEHEwHTPWsfZXS3cWpp4FAK2HkPj18mGTQd5TlyUgcsxQgEZKIYPNOVtqDFVf28pIoYsmmHd6+WZLuRpIbqd9X9QZn8A6Xcav7+5pH5LftTAu7GO1HFMjrlOAk9Gea14RI9/bTuHQrrKaGwxuRQyNoafsw8OI5cH9qYJQG2YhzDPkGE/0hIALEOfB0gf1pNfNyHL967oK9tq3wku4MqX9Y39DJxz+5gWqdpkBGaAzEkB9Y60H4xiuFLedoQe8jjvHS57+gdlK6TI6zfXbsTYuOpY1sd+rGGLVvlnvWe6hwc/zROCdDzvj9/EoD6SUiBQDMtqovz+i5geKCsRV9+fXzq/daErT4ltSA789W2a7SZPmOmQR4oFzOIjCfHNh76y4wK6V9XbM1B0fKc+Ts72HvWkDTk362u1dueoNG/UG6rst56osRgoMYJbKCJUoeWDoTqDdsM4HAlunHC7isjpgKfaNHamR8Yel6QhsIsXtDq41tsxYViilGX6V33QSVE0wKYYb2GN/5L9MCSIMtfFBSMXc0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1693.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(6506007)(55016003)(71200400001)(26005)(82960400001)(107886003)(82950400001)(7696005)(38100700002)(33656002)(86362001)(53546011)(38070700005)(478600001)(186003)(83380400001)(4326008)(66476007)(66446008)(8936002)(9686003)(41300700001)(122000001)(54906003)(76116006)(316002)(66556008)(7406005)(7416002)(5660300002)(52536014)(8676002)(4744005)(2906002)(66946007)(64756008)(10290500003)(8990500004)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1IxaEphNjR5YnVXcDZqTkFXYmpTWUNxSVVKYXdyeEtrSlAwWi9kZUwzTUFG?=
 =?utf-8?B?M0IvU055U3B0eFNWSjVudDkyR0ZMQTJUTWV2dUJrZ1dRUHFqNnZWRlpoanpj?=
 =?utf-8?B?UWFBbHh5RTF3VGhjNjZPdmx1MjRaR2tkdWZLRXlGdTFnVmJ4RzM2S01wckpQ?=
 =?utf-8?B?N01md1VrWVlEWXBoRWZvQlNEbDNrZnNIRHFSVDlYUTR6bFJMTnFUbWhJOFcx?=
 =?utf-8?B?bnY4RWVncUloNUNKWWJkRis0bXl5QW5TallEc1hoeUE1T2dTVEFWWVptZVUx?=
 =?utf-8?B?SVNUSU8wS2l0Y2drdUFjcWpwMS9pRERxSXJwUzFqSDV3N1VJSUJ5NXd2L3BS?=
 =?utf-8?B?R21XQ2d2Y3ZnSG14Sk9JWGNGT0s0S1FveEdvQ2xvTHBiZHBCRzNrLy80ZVF3?=
 =?utf-8?B?MklxSnUwUlUwOS9YbHQraHdJT3VCRVV0MVdlUlQvU2ZmWWNJRytlckxIcVox?=
 =?utf-8?B?VDVHdHVVUzVyLzJDREwyNGFZUTdsbHp3OWRZUlluV29MbWc3eEEzRm9ta01T?=
 =?utf-8?B?djNZbVFLcS9rMmV2T1h4dU9NRlphZVEwWkhBelBrSkhuRmVHK0E2M1owSkw5?=
 =?utf-8?B?N1V1S3V3M2gvMXR4a0ZKMDJwY3NaRFlzeEVmSDZoVmwwSS9GaW1tb1BZOXpj?=
 =?utf-8?B?czBnU3I1M053S1hvS1lCTWdOSzBBUml1UlR0VDNUbUZvMHc1S0tBYkhiU0VW?=
 =?utf-8?B?Z2w4VGZ2aGJIRlNIT0pFazRhRjkxTVRWcm4vNDkwK1NFaDFYZzJicFZpZkt1?=
 =?utf-8?B?dVF0dHVyWUFnbmYvUGRUKzdyN3BWc3F0dW9QbjRZazF3QTJueUVTTjhSM2pS?=
 =?utf-8?B?bXc1cVhQV244V2VJVDg1UE9waG9VL3IvSlFmRU81eTNuWWg3MjVMWm80b2pj?=
 =?utf-8?B?ZDJoS0U3SktKa1BNWFlhNXJQVVNva3dQZnd2TkxYZWRWc3VlaGZqamZ0VFFK?=
 =?utf-8?B?L29VN3VLTFNFclNZa3V1ZDRMMkxHbC9yN3FVNFBnQXN4MGU4VlJVaURMZmZ6?=
 =?utf-8?B?MXdKUzd6K25SVTA1eGhMZWlrS3EzdUluVVhPUlZ4NkNtOHRTVkJJY3F0Zmta?=
 =?utf-8?B?U0dMb1p5Q05UeFBMcUtmNEJBb0ZIMC9ZTlhlMHBrNDU1SUZRL1U3cGZ6WnBr?=
 =?utf-8?B?MXNsaDA3MXpodmYxTUJJSHJ4U284bDZVYWd2NU5Uc3ZPQXE3K0hTYXhBQTM4?=
 =?utf-8?B?Q3F5cjNISnUvSmZjZnIvRU55c3dKMkUzUmpIM3JBNXlDMkpPVGI5THpIZFpL?=
 =?utf-8?B?UWQrSFhwbW9oTlNZeCtVUXlNdHAya2k2ZGpYMGdncDlWbTdIRk45TjNGOTh0?=
 =?utf-8?B?WllyVURZLzY1Tm1NWnRpeUIxQ1RkdUs4LzZpeXdiVEgyK1NuQkRETjJ5MnRT?=
 =?utf-8?B?RGltcTVucVQwdlpLdmdmMDdjWVJGdHdHaXB3QmNQci9Fc2U1TVpyNjdKMWg5?=
 =?utf-8?B?a2JrQ1ZhcWY0RXBhcUhiZEU2US9mWk5LM244TlJaZXBPN3FFZ3hvcEluTTZB?=
 =?utf-8?B?bTg1T2JvazhXL0R3RkdCVkV4TStSMnVUM0kxTTJHaUo5WHpsay9JdmFlNWh4?=
 =?utf-8?B?WFNEbHBYZ1NqekkwSEdyWVYrM3BPNU82bWFOSlNOTSs3QUhzd05GMDIvNTFa?=
 =?utf-8?B?Z0NHSWZyaFNiTXVYYVVJK3FlYTgrazJnSnRuN01LR0JWTU52SlZyVnd5RnFZ?=
 =?utf-8?B?KzFKWFdDUW5pTzFhTTNsaXp0Sk5ia0xMV0xQKzJFeFM0T3RGVkYrUEd2RE16?=
 =?utf-8?B?VzhlZVJpTFlpS05GT3BvMjdFV0NEakJDdmdhWVZzQnhpUXNyejRvVXRBelJk?=
 =?utf-8?B?SmpGZVFMc2Q3SUFueElFZHZ2MzhvWlNsb281cENoWnVVeGxVMlZMNVhzNFg3?=
 =?utf-8?B?ODZsc29pZXZLa3hWSmRHb005RkEvZFBYSlg5anlyam9ZQ245QWxKS3UvYVBr?=
 =?utf-8?B?RUtlRThJc21HRWNQTzNpczFneVIvQnZxckcxZTJJeHNaZTBZYnJCYStxUVZU?=
 =?utf-8?B?bHBWcjdQQUhBa0F6YnJZOUpPeFhHcW9hcm5TMURVMnJxNWk0SmNOc3hheUxr?=
 =?utf-8?B?bEY0dTU2R2JrdkN4T1ZkbVhuUjRXbTF4TXZYSHg2UjZrSS9ST3NIQzR6ZHdh?=
 =?utf-8?B?K2JGQzJPU2U2bWxQUjNhRnZnek9aZ3IxRnI0SGxlYUV4NlhETXFOWHE0UWZj?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1693.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ca88d6-a29a-475c-9dd6-08dab05403fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 15:26:51.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uA5bPirbgalH784f3GIasFM1zhHRCFOdQG/RJYf8LMIZarrTgih4FAfroJqHOIXtkJTR2wxo//7oQpqlO5fI8XSuE4BfMCjZzrWW6GDWQp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3512
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3VpbGhlcm1lIEcuIFBpY2NvbGkgPGdwaWNjb2xpQGlnYWxpYS5jb20+IFNlbnQ6IFR1
ZXNkYXksIE9jdG9iZXIgNCwgMjAyMiAxMDoyMCBBTQ0KPiANCj4gT24gMDQvMTAvMjAyMiAxMzoy
NCwgTWljaGFlbCBLZWxsZXkgKExJTlVYKSB3cm90ZToNCj4gPiBbLi4uXQ0KPiA+DQo+ID4gVGVz
dGVkIHRoaXMgcGF0Y2ggaW4gY29tYmluYXRpb24gd2l0aCBQYXRjaCA5IGluIHRoaXMgc2VyaWVz
LiAgVmVyaWZpZWQNCj4gPiB0aGF0IGJvdGggdGhlIHBhbmljIGFuZCBkaWUgcGF0aHMgd29yayBj
b3JyZWN0bHkgd2l0aCBub3RpZmljYXRpb24gdG8NCj4gPiBIeXBlci1WIHZpYSBoeXBlcnZfcmVw
b3J0X3BhbmljKCkgb3IgdmlhIGh2X2ttc2dfZHVtcCgpLiAgSHlwZXItVg0KPiA+IGZyYW1lYnVm
ZmVyIGlzIHVwZGF0ZWQgYXMgZXhwZWN0ZWQsIHRob3VnaCBJIGRpZCBub3QgcmVwcm9kdWNlDQo+
ID4gYSBjYXNlIHdoZXJlIHRoZSByaW5nIGJ1ZmZlciBsb2NrIGlzIGhlbGQuICB2bWJ1c19pbml0
aWF0ZV91bmxvYWQoKSBydW5zDQo+ID4gYXMgZXhwZWN0ZWQuDQo+ID4NCj4gPiBUZXN0ZWQtYnk6
IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0KPiA+DQo+IA0KPiBUaGFu
a3MgYSBsb3QgZm9yIHRoZSB0ZXN0cy9yZXZpZXcgTWljaGFlbCENCj4gDQo+IERvIHlvdSB0aGlu
ayBIeXBlci1WIGZvbGtzIGNvdWxkIGFkZCBib3RoIHBhdGNoZXMgaW4gaHYgdHJlZT8gSWYgeW91
DQo+IHByZWZlciwgSSBjYW4gcmUtc2VuZCB0aGVtIGluZGl2aWR1YWxseS4NCj4gDQoNCldlaSBM
aXU6ICBDb3VsZCB5b3UgcGljayB1cCBQYXRjaCA5IGFuZCBQYXRjaCAxMCBmcm9tIHRoaXMgc2Vy
aWVzIGluIHRoZQ0KaHlwZXJ2LW5leHQgdHJlZT8NCg0KTWljaGFlbA0KDQo=
