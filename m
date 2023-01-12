Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CD9667EBA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjALTIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240330AbjALTIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:08:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE22EE32
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:50:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvXKoEhgciNroEGNSCa/CYi/m06LRIetCS7hlQr328uZ5AuI3xGDegIhy2CTPISHqGJ1mC+8pFdRnyiyExazskzPJc0oRHuS8qXt+Z+uVzSjFMICx3+vW4ejoEQI3Kph4HGh4H8VOKusSg3Z75B/BL2rocJyls6r79xIsCpqAJiH3l1fuQOBQm5aLyHmbOkYUaZm+pQmCVxPZ9+GvvC3wh1tKPz3PgCHFzepyxtUemgJDiMO3H1fzad361SL3oTfjf8TejFXkQDWbFI8j8y0QlJFViTD/8TF8BlA54IAPBaIHMRt+VHhEBxf1r1r94vHH/9mef4AbNJdAXpTRGW21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKTwK8f8+d4x7NaG7yP0TkGR265XJkPFk/lboMu2CuI=;
 b=J/cFm+N50B5WzQD41hDdNQiECuJGaYbzamilMXhcYVSe1js2OfY6sS3rJJtgufarsYXOKR1yI+DLCzH1bYXM/wfwELmG2LrYy3Ie2r6qVokIPTwCy1xz3uektXNvsu1j0qTHOXTV4BM5ybPv6F/SbEuwABLDoSBLI6i+zwt0INQDaqhCERQoIFALZEju75YjTgRNW+MBEK+hb9BfVj4rqHUTz9J40olM2TcFHtS1FdbVO7xxWicQvMD2RXR1KoG1XKJqW+EDyyw/aNHN8+B+01un/VR+X7cQ9vow9IxgPZ+r9d/Ms7O2gUPSLisF10r0izQZPqzFMSBZJ/UaDfy86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKTwK8f8+d4x7NaG7yP0TkGR265XJkPFk/lboMu2CuI=;
 b=ksvzmH+3BLeuVVQA+x39X+lYbx/jWSATnPFiSnGaBzw1+fD3vlFD51Dk0sbByYt7575WKBFhsO5k9hdxurEMepkQe+/t50FkpdsB44koD67yeQhYwVW6elKzocFWDzWlmkUptTT6TntiFOtCJHWWOVT+kY7a52B3Wc42GZE3yMHFDlw+24Qs/v4Usuz+ba6uZ+WExSaTVYWemdHZs6MMeukGLPtDC9WYW5pN86KYWEy2rTrF8YOLgLszueUi+30jJxj3wSY6C6imAC8KVw7w03KIO/4JTlgbLDEP9MhsQ7UN+VC7Jj522kja3mN9Hsq8cjeLjCnXBx8UW8RASf24Yw==
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 18:50:17 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 18:50:17 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        Shai Malin <smalin@nvidia.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: RE: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Thread-Topic: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Thread-Index: AQHZJC65sT0M8JNDqUCZB0yc3h0c2K6aOV8AgADrGdA=
Date:   Thu, 12 Jan 2023 18:50:16 +0000
Message-ID: <SJ1PR12MB6075B6ACD47B7707087522AAA5FD9@SJ1PR12MB6075.namprd12.prod.outlook.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
        <20230109133116.20801-4-aaptel@nvidia.com>
 <20230111204644.040d0a9d@kernel.org>
In-Reply-To: <20230111204644.040d0a9d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6075:EE_|PH7PR12MB5902:EE_
x-ms-office365-filtering-correlation-id: cc1b95e7-bb92-483b-6665-08daf4cdd8e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x9u99VCte6CspB1wY56pgzMtY5BGi1DwpLgOmiqJCIoGmXLH6eEUVLzEaVYBhxJsqE9d3n/U6wFHkwW9rBCWaUTzILZtn+r+i4v7+KA8P0lbPd260q2mwwJxWArDO1NZ1d4oxNh6SkzeWSpGhOIxLKV/VACVZixfsY8R0rh6pz29rJ4Hg8xgJnn38fTFp7K1x//mzDXdLPspoRzAeuOk8Tm+xx48jWfku4gyI1WsCF/JH9fmW6Bb+1YcEmrw3UIiVdyamFXgPp7Zi8MH4eU4v9aBqA0IhiWh04+87C066hKjnWXnOeRhj5Ag5gww5+gXC9zxZaecCQNfC0leaIZ9JH62+27KnjiTgrVnykrjmX+8HSGIapzjlWoQPs1WhUxqLEB4lhU88qyKAeRR26wrzOEx0baCSavk9b2DACfaVBXZn5IejJrwzgEvQtxVZVVqu6H7qAb5D/e+VXhlZ4beCx53DoTQ1VogRAJlNOzj/tL3c4hEFCbdstFoowX0wqE9s10npK8csRz073Qs1e6lx3/YFCNOSdq57xA6sX8CZit9mpAahMrrF+qipIcTe845x32iiHhLboGZ+O0WBY1IiJQ8SJw54p5ynAWrgD/+XXqD1f7yTwGOB+NEsuBJU19Bsy9NWu5k7pwSGLdRdBRWgmxDIwIGB6jn1DKnW/WHb9YVhflR+pPV6nHzETnH+39cbDmvwywtXVmcMB1FpJKZWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(6916009)(38100700002)(122000001)(33656002)(38070700005)(86362001)(8676002)(54906003)(66476007)(41300700001)(83380400001)(66446008)(66946007)(4326008)(66556008)(107886003)(76116006)(2906002)(478600001)(4744005)(7696005)(55016003)(52536014)(7416002)(8936002)(316002)(5660300002)(9686003)(186003)(6506007)(26005)(55236004)(71200400001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHUxcmJhZDZmcURXSDhVQUxUUDJOQVBqbm1RWGJZaWVjaFZicEtmOWhjMExm?=
 =?utf-8?B?VTJiT2ZUbXZLSW9uQVdlcUFxemg2UU9kRTdoZEFZVEg1d1Z6MFZqdU1UalN4?=
 =?utf-8?B?b1B2c3ZFU2F3c2QyckhFRVJ6MkRybWdTRnRSU3l2MHAzbzB6LytJNUVTRTZV?=
 =?utf-8?B?K2IrT0R4a3Y1WExFZlN6YnpmYTNIMWltUkZ4VnhzSmZTSEFnaTdNUFYwUmJx?=
 =?utf-8?B?bGt4ZXBWcmhDSjc4QTR2QzBpRHFWdzhFWk15bngyS2VPMlYxVHVrckExcXdq?=
 =?utf-8?B?U3hXSE1EdUJyZHRrOWNUZUkzVGJ2cWNER1VBK01FcjhGQ0VxM1JlcWNTbmFy?=
 =?utf-8?B?ZzYzb0VDd2pxVkN3dHgxUDRoUzVnNWNqSFBLc1RxeFkwNWFKZDcwVzdrR3lE?=
 =?utf-8?B?TFEvMVRrV0VRUkdyK21qMlNtWWUxUk91ZFpmUDVxYjBPNVlNZ3BTZ1k3c1h3?=
 =?utf-8?B?dTdFdlFCOVlQS3hFVGJiVUptTURjSjJNb1RoUmlERXRYekpCaVc4UzVzR09O?=
 =?utf-8?B?cWYxYzV3blM3UTNLRVg3SkUxVFVxdVpHSmhMVGtOcE8xMGk1dkpJekdmamk0?=
 =?utf-8?B?ZDJYeStLb0pGNUZHend6RWVtZW9LWFY1dG9FcEpRTkx0bVlIMFh6cXNIeDhq?=
 =?utf-8?B?VWFxSG42VHdDeWVOd0xDaXJtOGRLYWRKZUU0QlhZS1RLeTM4enIyVWpmQ0xH?=
 =?utf-8?B?QkZRc3F5VDhORDQ1K2ttYnRBT2pydDNZcDVhcm8yQU0wUENZcFlqbnU1N2w5?=
 =?utf-8?B?MitseHhyTW9GQ1ZQU3BnTDI5ZDB1RlVLQ1I4RFd1bDFZQlkzYWRZV3MycGdP?=
 =?utf-8?B?cGhHZGFmY3pkakRVVStqM0ZiQmlyMGUralFGTzUxa29Ga25KOGdwRE5uQWM0?=
 =?utf-8?B?Yng2SmFjMUlPTVhWZ084eUtKQk5BUEZVcHpjY1pkbTBRMFV3OEdqQ1Q4Wnlp?=
 =?utf-8?B?NjhDR3g4VmdJeEZ4NWFYVTdlNVphOVhhY2lZdmQwU3pObWpTMjM1ZG5icXI5?=
 =?utf-8?B?Sk5VanBNZTdQTFk5WU1LZTZMbjdmbHdpNzZOaXRzSDZGS1JhT2RRYXBGZzZ4?=
 =?utf-8?B?YjhQNkttZlorQ0NtMGxVYlVpbUZNQmo4a0xQdnFtUFVjeGpQVkc4ZURrbVNu?=
 =?utf-8?B?UkZ0NHEzNmVQbUNuVTMzSmk2YXo2aEFwa0pJbFFIMkdtMUh2RVBMSXc3VXlH?=
 =?utf-8?B?aUpQMEdDVjVIUWZWamUzREJDM041a3BRTUYwUVQ2akVtaG0vbjNITWpDcXEy?=
 =?utf-8?B?OUNHV1M1YjZGK2lNUVlNdG9SaDhEZERTeCtnaHMzUHRTakNoNDg5N2RKSGQ5?=
 =?utf-8?B?eG5Sa0hrYllLei9XYWVkRkhXNEpHS1MvV1Mxc05FdGhrQlZNMms4ZzkxNzdm?=
 =?utf-8?B?UG5YNXlwMEhDK3czaWxtcVo2SmxmMG9qWkVQaXdxWEpWeHN4SFd5SiswYWNz?=
 =?utf-8?B?R09NSGl2a2UxYzFJdm9DSXpzWGJPWVhud1U2SGI4YVlJMHVnOGx4R0NHeUxX?=
 =?utf-8?B?dEp0VDcvakd1SUNWendFYVlkdlRnRnNpS2VjWUJPblBJcEFQMUFTdnVYcU85?=
 =?utf-8?B?T241N2ZDT2tjWHl6OUpGenpIZlp1WHh1dDMvd2RUU2VSbUw3Z3RjNEFlUTdX?=
 =?utf-8?B?VEJBRUNZTTR1S1ljRlp4dnl5cElQTlF4U3JlaFp6QjZvWnNLa3BSb0t6SDJN?=
 =?utf-8?B?aFlpbU1MUitmZmkxektQUXZGRllHRWhadWlEY29YUFJUTkp6VlptV0Z3OWs0?=
 =?utf-8?B?MnZOakM1TDM4aVV2d3B4b0Jnd2h4RGZNWGRHUnRJdlhJZXJTYzlmLzJna05B?=
 =?utf-8?B?MjlZUjBhNWZtZC9PRnI4NzRkTkxXRVNOY1YvbmZKVHYvc2ZSZmRVNnNIUCsr?=
 =?utf-8?B?RWRqbzZPVVhQTmttMThuZjhLcUFHWTlraitIV1VMeURqYmRaS1lFZlR5eHNG?=
 =?utf-8?B?ODlqWjBDYnVHMXZHTmFJRkR1N1d5LzdoNU1qamxrOGllUkFwdWxHRzlSQVJY?=
 =?utf-8?B?a2syVFZMNzROc1NTYi82Q1hoRXl4clU5aG5qVFBIWXBsT01RbEkyWXNQcm5t?=
 =?utf-8?B?Ynh0UklYYXFJT3IvVG9hMVZ6UDNXSGUybTl2ZkZsaDZjb3FXSlRGTFZXWWZW?=
 =?utf-8?Q?fX2WvymNsoDnyMCn3+y1UAM7j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1b95e7-bb92-483b-6665-08daf4cdd8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 18:50:17.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fi28qlEc6NY28JKvEtJpLkZu2uVQcYxTPZ1HRKUIFPmM3PO/Qm89DgZInV9+U8b0Kj1ygRVXBH7bXVCVvo2nDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gVGhlIGltcGxlbWVu
dGF0aW9uIG9mIHN0YXRzIGlzIG5vdCB3aGF0IEkgaGFkIGluIG1pbmQuDQo+IE5vbmUgb2YgdGhl
IHN0YXRzIHlvdSBsaXN0ZWQgdW5kZXIgIlN0YXRpc3RpY3MiIGluIHRoZSBkb2N1bWVudGF0aW9u
IGxvb2sgblZpZGlhDQo+IHNwZWNpZmljLiBUaGUgaW1wbGVtZW50YXRpb24gc2hvdWxkIGxvb2sg
c29tZXRoaW5nIGxpa2UgdGhlIHBhdXNlIGZyYW1lIHN0YXRzDQo+IChzdHJ1Y3QgZXRodG9vbF9w
YXVzZV9zdGF0cyBldGMpIGJ1dCB5b3UgY2FuIGFkZCB0aGUgZHluYW1pYyBzdHJpbmcgc2V0IGlm
IHlvdQ0KPiBsaWtlLg0KPiANCj4gSWYgZ2l2ZW4gaW1wbGVtZW50YXRpb24gZG9lcyBub3Qgc3Vw
cG9ydCBvbmUgb2YgdGhlIHN0YXRzIGl0IHdpbGwgbm90IGZpbGwgaW4gdGhlDQo+IHZhbHVlIGFu
ZCBuZXRsaW5rIHdpbGwgc2tpcCBvdmVyIGl0LiBUaGUgdHJ1bHkgdmVuZG9yLSAtc3BlY2lmaWMg
c3RhdHMgKGlmIGFueSkgY2FuIGdvDQo+IHRvIHRoZSBvbGQgZXRodG9vbCAtUy4NCg0KRG8geW91
IG1lYW4gdGhhdCB3ZSBjb3VsZCB1c2UgdGhlIGR5bmFtaWMgc3RyaW5nIGFwcHJvYWNoIGFuZCBq
dXN0IGRlZmluZSB0aGUgY291bnRlcnMgbmFtZXMgaW4gbmV0bGluaz8NCk91ciBjb25jZXJuIGlz
IHRoYXQgaXQgd2lsbCBub3QgYWxsb3cgdXMgdG8gaGF2ZSB0aG9zZSBzdGF0cyBwZXIgcXVldWUg
KGFzIHdlIGRvIGluIHRoZSBtbHggcGF0Y2hlcyksIGluDQp0aGF0IGNhc2Ugd2UgY2FuIHN1Z2dl
c3QgcmV1c2luZyBldGh0b29sIC1RIG9wdGlvbiB0byByZXF1ZXN0IHBlci1xdWV1ZSBzdGF0cy4N
CldoYXQgZG8geW91IHRoaW5rPw0KDQpUaGFua3MsDQoNCg==
