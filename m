Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A026B581D84
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiG0CRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiG0CRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:17:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A8E3C8C3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 19:17:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQ2tTixCpQ2wh0HFuzKcpal+ZGAN0KCnNJmMyxhG3uFgIdvnx9ODeWW7SyUz5UqvHlbAzxJyMUqg0y6+KS6IJFJrJ5VpGltwWJMAJsblkKuESPvbMML5Z24c4jDvlNjWiFT1+tnqtY4feJ4r9i6T6f9XswzO8VQftXF5Dl3JPl1TUQXlHnfILFaz0p7nfHarPVrdEFeGL4Sfc98cFZp5FAvHkPfdSH1sLJNms8gRYaRiV+dxExsKqvKA4ZZOP7Cl5p/NWTtuGqMGlOdJ4Ku6bu9bYIHdL1swizkhACkem5fu6KAPdkU5ZH65vecUMA8xWpNFZtZXCTh8QXNnQSyO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QiCA7KKSU6BKkGocB+9ZUg07MYnb7HaREDceSTYlV8=;
 b=epsTioztbOkcU0YLWHKnLtU1uLyksl3FhdRjgYe6ykKDaFcyByWZoZMmZj3Y1wiPylItNGkGkscmaAkW8+aVCScEoIFDbJXbMj+vcpAaRQ2DXAL0fOFbEZvVmHIhjzr4pDsL7NtArFGdh7fpWko1QFZ22ocnmi893U1qg11PrWR7xqQ44n/I+GhO+z+MBokAELrVf0MJNEV+oJO9S8cAAzs3d/74dtjugd5FwyPQqKT3nGzhZoD8+RwMn/THBsx7V7A+AS3DTbZPxuNRJYea6z//Qy97icSUe0cu26FjIdEoD5cky2R63JiMs01K7dLMlV6xL0YXI2UGUwHmX0ekdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QiCA7KKSU6BKkGocB+9ZUg07MYnb7HaREDceSTYlV8=;
 b=E9bycvS/o3x2kEeN17L6rawT+1yGPxktPVsXoOAjyGMb5Ystd0Mg98chLj2EhifDD5dBguGaLkBlOTe+aWDsp1o00ki71X/fw0VD33czln5uZ5vQDAg4jweOmzKmWp411u/pBBBPIQ69PlIss+8c3iPP2qSaXbxCxCMctBZ/ztR+/+FTH+yoyT314PE22zNAysfVf3Stw7lzZi6o511nxP75ppqCsc1Va0nPUt3959wO6yjo4FIzJJ1CR4Ns5MC/Rgom2RGymW2remWKXsj13AB6CHPfONCvjxKSDNWcmCGOhqfseFgubzWPm3qsC+XieiXMqBTVhcCZAA4j2eD2ug==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MWHPR12MB1135.namprd12.prod.outlook.com (2603:10b6:300:e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Wed, 27 Jul
 2022 02:17:42 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 02:17:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYjU+OpP/4aLhN20eCCMO4rbOEoq1qEloggAn4zwCAAKXGEIAD0JkAgAJ/vUCAAK5SAIAAADPwgAALqACAFTnxEIAArU6AgAAAQ5A=
Date:   Wed, 27 Jul 2022 02:17:41 +0000
Message-ID: <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
In-Reply-To: <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd959ac-b2e0-42dd-222a-08da6f762f7c
x-ms-traffictypediagnostic: MWHPR12MB1135:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +J54qxqCrfXhIheVMcWx5NP6Kp252yYG0NCyQ7rrVjAV8XGHe84UouHZ6BO5qdrQLr37BjoctVmTQL5O2OHOwlMA23HqykyRhiNXP8l+2HUJTydFWkETXvH2+iI0a/BLcedl5E4sdJ0wDDqS4G1q/yMfOD8/gsAMVTmKvvFF74h+LU7Q0wymka8sEsLl0B5dgoMrYS2Oyo01rIADllNEDAwPbhtDrzPMYtAn2MfjlUmdyE+Ss52i/bKTWJ2S21lt/aJT4EtyDLfnr5CMaX73zQgENCh4/5JysMszKx4T+T4hpsnMGoxVwWxo657kyE3azyM9YMFyZ8Ettenyz27m9KIKsY6Y4AkFgSSz+RyYEEG1MxZ8E62v1na5BNYKU6s8k5hHOxLXdct/AqYmJysSXREssIGcD6zOp0yukeR/eJMzKHxNKli+oMBqUjq9dXr8ibtHaWXJ/p6UpLZDv6jyPdNq2j3P2mJ64TgV/tEXxNFloEGv5wtqB/hF/Gh00tEvdiJq+To8MTqvyazGJ0cPvVNq3scStkVZtoPrJ9mUoA+EklC5cvqNVtSMISpCDVI+60qKnM33OX6cr2W6iYWGhy8OqFo4zSLiZL975xndcPdUiQQaZOb+YpkjiaI/jTXxFVbZqelj9LTKAR99g8/luARrL5KIExpni+h9NfbkSi4ize60R3QH/HrDOWwW/vmzIuvytFPS7U95HImo6Dm6SR/+Xl4+SfsacA1MEPl8CYjSdDgM5XjtRiekp72/Z7iEQI1zFW1oufxwuhidjd6Cz+GfPAOAEM4dmSq2qMjZrIXs+JWxqx8/7ZDMX3OvUlE3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(71200400001)(8676002)(76116006)(478600001)(64756008)(5660300002)(66946007)(26005)(66556008)(8936002)(4326008)(186003)(2906002)(86362001)(53546011)(66446008)(122000001)(66476007)(9686003)(55016003)(83380400001)(54906003)(33656002)(38100700002)(110136005)(6506007)(52536014)(7696005)(38070700005)(316002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXR6Vk90MURVSVNqOVovemZYMVV1NW5PY1pNQkZQZ01BeTJ6NVNQTEs0VlFG?=
 =?utf-8?B?aDUySkV2eXFTeHJLYkFHWDA2NmFCbDdrdmxUNXRDQm1lUDlQRWt0VzJrZDRN?=
 =?utf-8?B?aXMyVVNaOVdxVHJIT3NGUlo0UVdQeEdMNjZGNWtVUzIyZWh3aVIrY2RRd2Zi?=
 =?utf-8?B?UzZsRFdDejZBUllrelU3UXV0aGVtWjF2amNpUDJVSmJLYUk4ajdQV2swTHZX?=
 =?utf-8?B?cGNMV05Za3h1eng5WG1EVWdITHMyNFlQZUtlOERKWmllejFUUXlIRjNvdlZB?=
 =?utf-8?B?MWVVMjJCc0NWU0ZMdDU2by8rd3F4elpUWFc3bURrTnkyODNLVWk0Q0dCMm9k?=
 =?utf-8?B?LzZZMVowSVRWWXV2NmVmYjhRY1NBZjhQQ1RLRjVrdnN5NVNCdGsvTlBxazNr?=
 =?utf-8?B?bDJheWR3UW1tTlo1MDJsREpMQnRZOXkydTRiVnE4T0xia0JzNjBEVWJjeWFn?=
 =?utf-8?B?Q09TQmN0TmNUaEZKd1BSaTMraFdLd29Lb3JYWEtVNU5xajZJYnp1OUI1T0V5?=
 =?utf-8?B?bjkzTXF4MExRR3ZPdEZFTWRLVm1oMlk0Nml6MEZVaDBFVlVwa0psN05oRDZ3?=
 =?utf-8?B?SE10N2hUKzRNS0JpeG5VVHBTdkIyVHNVVTgzQXdGSUVDc2EybzBSNDhpczhi?=
 =?utf-8?B?QTZFTVNvWlpvYUhFOHNYVzd3VTBlOGFpM0RtT2NWMkdhTU9LMEtNb0xwNlRM?=
 =?utf-8?B?cjBvZWE2dGQ5Nyt5aXhWaCt3ZVduaWhzL2Jjd3VydjZWcTZxbEF4ZUdpdXdw?=
 =?utf-8?B?NGc3WkFvbE5sTG9VdkdkNmlZdEZUdUxiY1ZFckJ6MGZIQlc5TzZxNmNnWmJP?=
 =?utf-8?B?Mkx1cW9MQmtKMU8zdk5ybFBiWnREcWc2bHNreVBCdXcvS0JCUkZJeFVydE54?=
 =?utf-8?B?UGJ2N3J3Ny9PRjJCRzF5cVVWcEM4bmtBOWw0SVN4NHZkMVNuUGFvTnh6Z1g1?=
 =?utf-8?B?bDR1SW96eXJqT3dPbnpwcW9XbFoyTmU0aGd3emE3N2RlN2VkOFZDR2I0aHBL?=
 =?utf-8?B?d0hwQTlmSjRoMGVQbXUzMmZIckRWMFBzVERubFR6eDdyUThlWElPYTFHeDF1?=
 =?utf-8?B?SndFS05RcG1QcnlwQTlYcGl2anprd2lMbS9yTHlJSXVtL0RMSVJyZUZrUWk0?=
 =?utf-8?B?b3dtM0VEKzFXSCtIckRudUhRVis4bThqQVVCOUtrM2ZYQUxQVDZZY1JsM3Ey?=
 =?utf-8?B?T3VaMEZTaDMxRG5IMFJnaUJQdWxJVVVWVjNJRENYR2xQOTBKbWE4enZHM3hQ?=
 =?utf-8?B?RVZhZHhZaWJxQVpFeWFFdVpLTW00TFRKQUJJVzYvY2NKWDNMTkJBUjlDSG9v?=
 =?utf-8?B?cTN4RWF3d0RDV2FIV3pPSFFxOWNtR0tzR3JzcmJOdUpQYmVpMXRrZThzeFFM?=
 =?utf-8?B?N1EyemhOV01IZ0huUE82S0hkbVhWSDBscGg4UUt5VEg5ZHpDM2hSa0pTRlpY?=
 =?utf-8?B?TTczZFQzZDI3bk90UHFzc3FrT3M5VVQvQWoyTjVYS1RsQUJqNHE3RWxUMGg3?=
 =?utf-8?B?UWJjczdQdDdBcENyRERMaUU2VVRlMm9TWjJnbTIyWDEzT3dWMEd2MEY2eVdR?=
 =?utf-8?B?amhLUzhFOUVpWVdyalJLMTlsVlNzMU9ueWxrVjkvRUtRN1ZiY1Z5YUgrYlU3?=
 =?utf-8?B?WmVJeXNveGh6MXBrdHc4aEhyKzJFWWs5TXBlcGNBMDQzRVluQittR25xdEds?=
 =?utf-8?B?WEl1TTcrN1NrK2xLTFNjYW14Q05HQk15WHkwUDF4Mk8xcGdNdTVSMkEwN3FE?=
 =?utf-8?B?TWNKTHZyUVZkb1lPc09lci95MjVVVFJkWS9Mb3c5Uk9MeTdTcW9acmd4bmhQ?=
 =?utf-8?B?MitLdGNhRDJoR01nV2lYZjF6SE05SUVyL01jV2taMWROYzlheGh3aUVUZFZ4?=
 =?utf-8?B?MDVLWU55ZFhObStzOWpZUlV3eVMveGRTbzA0M1FIcWxLS2RHQWZzWVlVcVUz?=
 =?utf-8?B?TmprektJTEJYcmdGNWVUU3liY3dtYzBrQnpBN2QvRll2RkczellaWXdId21j?=
 =?utf-8?B?R0NjaDJranZTZnBGQlA2MndOU01FaTJmT0ZTQ0IzWGh3a29OR243dDlWVTR2?=
 =?utf-8?B?VS8rblhCaGtzSVJmdHRyVFpQZjdwaFR1dDRhcFd0TDZZTURFMkk1V1hpbjQv?=
 =?utf-8?Q?87Eo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd959ac-b2e0-42dd-222a-08da6f762f7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 02:17:41.9522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLr3R6thHx4hD/g44DFJGZK+OqVqlUBmkXWuAfkAEAd/RBHVw3bvaiTs1dviyZ2MFUxhJySWUUuuvnZjwTqWHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1135
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgMTA6MTUgUE0NCj4gDQo+IE9uIDcvMjYvMjAyMiAxMTo1
NiBQTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBaaHUsIExpbmdzaGFuIDxsaW5n
c2hhbi56aHVAaW50ZWwuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKdWx5IDEyLCAyMDIyIDEx
OjQ2IFBNDQo+ID4+PiBXaGVuIHRoZSB1c2VyIHNwYWNlIHdoaWNoIGludm9rZXMgbmV0bGluayBj
b21tYW5kcywgZGV0ZWN0cyB0aGF0DQo+IF9NUQ0KPiA+PiBpcyBub3Qgc3VwcG9ydGVkLCBoZW5j
ZSBpdCB0YWtlcyBtYXhfcXVldWVfcGFpciA9IDEgYnkgaXRzZWxmLg0KPiA+PiBJIHRoaW5rIHRo
ZSBrZXJuZWwgbW9kdWxlIGhhdmUgYWxsIG5lY2Vzc2FyeSBpbmZvcm1hdGlvbiBhbmQgaXQgaXMN
Cj4gPj4gdGhlIG9ubHkgb25lIHdoaWNoIGhhdmUgcHJlY2lzZSBpbmZvcm1hdGlvbiBvZiBhIGRl
dmljZSwgc28gaXQgc2hvdWxkDQo+ID4+IGFuc3dlciBwcmVjaXNlbHkgdGhhbiBsZXQgdGhlIHVz
ZXIgc3BhY2UgZ3Vlc3MuIFRoZSBrZXJuZWwgbW9kdWxlDQo+ID4+IHNob3VsZCBiZSByZWxpYWJs
ZSB0aGFuIHN0YXkgc2lsZW50LCBsZWF2ZSB0aGUgcXVlc3Rpb24gdG8gdGhlIHVzZXIgc3BhY2UN
Cj4gdG9vbC4NCj4gPiBLZXJuZWwgaXMgcmVsaWFibGUuIEl0IGRvZXNu4oCZdCBleHBvc2UgYSBj
b25maWcgc3BhY2UgZmllbGQgaWYgdGhlIGZpZWxkIGRvZXNu4oCZdA0KPiBleGlzdCByZWdhcmRs
ZXNzIG9mIGZpZWxkIHNob3VsZCBoYXZlIGRlZmF1bHQgb3Igbm8gZGVmYXVsdC4NCj4gc28gd2hl
biB5b3Uga25vdyBpdCBpcyBvbmUgcXVldWUgcGFpciwgeW91IHNob3VsZCBhbnN3ZXIgb25lLCBu
b3QgdHJ5IHRvDQo+IGd1ZXNzLg0KPiA+IFVzZXIgc3BhY2Ugc2hvdWxkIG5vdCBndWVzcyBlaXRo
ZXIuIFVzZXIgc3BhY2UgZ2V0cyB0byBzZWUgaWYgX01RDQo+IHByZXNlbnQvbm90IHByZXNlbnQu
IElmIF9NUSBwcmVzZW50IHRoYW4gZ2V0IHJlbGlhYmxlIGRhdGEgZnJvbSBrZXJuZWwuDQo+ID4g
SWYgX01RIG5vdCBwcmVzZW50LCBpdCBtZWFucyB0aGlzIGRldmljZSBoYXMgb25lIFZRIHBhaXIu
DQo+IGl0IGlzIHN0aWxsIGEgZ3Vlc3MsIHJpZ2h0PyBBbmQgYWxsIHVzZXIgc3BhY2UgdG9vbHMg
aW1wbGVtZW50ZWQgdGhpcyBmZWF0dXJlDQo+IG5lZWQgdG8gZ3Vlc3MNCk5vLiBpdCBpcyBub3Qg
YSBndWVzcy4NCkl0IGlzIGV4cGxpY2l0bHkgY2hlY2tpbmcgdGhlIF9NUSBmZWF0dXJlIGFuZCBk
ZXJpdmluZyB0aGUgdmFsdWUuDQpUaGUgY29kZSB5b3UgcHJvcG9zZWQgd2lsbCBiZSBwcmVzZW50
IGluIHRoZSB1c2VyIHNwYWNlLg0KSXQgd2lsbCBiZSB1bmlmb3JtIGZvciBfTVEgYW5kIDEwIG90
aGVyIGZlYXR1cmVzIHRoYXQgYXJlIHByZXNlbnQgbm93IGFuZCBpbiB0aGUgZnV0dXJlLg0KDQpG
b3IgZmVhdHVyZSBYLCBrZXJuZWwgcmVwb3J0cyBkZWZhdWx0IGFuZCBmb3IgZmVhdHVyZSBZLCBr
ZXJuZWwgc2tpcCByZXBvcnRpbmcgaXQsIGJlY2F1c2UgdGhlcmUgaXMgbm8gZGVmYXVsdC4gPC0g
VGhpcyBpcyB3aGF0IHdlIGFyZSB0cnlpbmcgdG8gYXZvaWQgaGVyZS4NCg0K
