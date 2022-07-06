Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62DD567BD8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 04:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiGFC2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 22:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGFC2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 22:28:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D0F17058
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 19:28:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKAc8HmYOIxkqf4PWmR1UvQVaASPUH+xf6xL03yiHlI3PC/WhApBK3YYXis1Xcl2II3/UsCRlW9f4KJsMQJsp0l3dpI39vmp46p7hD6O90AT/slqc/n9ZIAAwZ0jXF4vJC+K9dOPN2yONvyi6K2GaN4uLIIcSqcwyQfnpf2vu9MX552MDa6NFHfYtbKobzTphFmvEIgQjNpnjuHI/WEVCKNDIiEMxG3CQES7Rv7LhCz3stF+DpC6w4O0vk9vaFQoYBRw50xUK56zitYOkKiwHxBQ3HzvjQxaD/PGaX1o4NRm929nBqtn3HhEmdYn1Zs561/hdTaudfP5ZJu8hKBiVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSOfD0BO/gmQfVVpLlit2CRO9ldtrJH8+8S+AvbAh4I=;
 b=ihSMTcEc7JqNTMcE351/C9XWQ148DMApn/fjUjPsuijuM4VyZBCDMRs5akyGfzpSOkVq+qMGMm86FeKk/FvfhCjaRMzxV5V/amNpvmfgn6ifzYOHM53SaFtxygz3E+VDKxgXyl8PNnds4PTswpXeRIrVqwPKWgq8Vp88golOPBaekznDdqijaCeyv+gvFqFBGe/PpwGeeDk3vxuqT6RStjuR6yD3SFYl/Wmt5kQYlviFEAltAjJZESo1vkejaAUGT4E6j4BAu2xWwf0ZbJaPmePTYhXMR+gVAXitBZ/Cg420J9Wta+arCoIBUZgO8FAEN7gn9t4l4Jg96qxq3lvs4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSOfD0BO/gmQfVVpLlit2CRO9ldtrJH8+8S+AvbAh4I=;
 b=MnleI975XgixbpNrYpMBk5BwgoU9tHgyLqWQJ5hfufaIQJ0SBinRz07LLT/PcLIMEFlVOwScyaxrnboq41QrppKSQfzRU6+6s1vStPWZ/QNmVx7ef9GKz0bgFkguPe001Faf75TT1xEH+syJ6wyz2S2QlwYWEeMHtTE4BlLwsotIFji0jIhtukRNJ5uU3sROL0WmJIxde2f0otUCx763JCcLmkr7gCHJm5VmjxVMs/cM0rtpKGovOOMBh662rmN8qUGk6EotsuCNfa9sqyI7bYy5XAeiIOA3aGrB5LwKH1MA8gYW8M0+0pGa7jozW/oI+YaezK5HO7v6aRBs/8ju2Q==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN9PR12MB5049.namprd12.prod.outlook.com (2603:10b6:408:132::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 02:28:04 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 02:28:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQggAOY1gCAAIePkIABQJ6AgABBuVCAAFRBAIAAAK0QgACeU4CAAAB4AA==
Date:   Wed, 6 Jul 2022 02:28:04 +0000
Message-ID: <PH0PR12MB548117A197FF9E692543974FDC809@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
 <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a59209f3-9005-b9f6-6f27-e136443aa3e1@intel.com>
 <PH0PR12MB54816A1864BADD420A2674E8DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
In-Reply-To: <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50ec7b2a-9874-4d6a-a0b0-08da5ef727bc
x-ms-traffictypediagnostic: BN9PR12MB5049:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHMntdfJePMJ1o2nLAdPy4qqq/W61/81SDzMrcXrOyMaP9cgYHQKOc1ovW6gjGaHUK5LatoOQBxDDaaMbq7VyREz4VqCxYrcFa4ZcQYH2XNclwHth0KPdfucrDOB1zETViLLysHBJ4uZyzl2Y/kx03VdVMXQ6P3X2YyqxW3rsUQddZ8E2ePuPJ/hFAqAD0bpkt5aHtVK4WfHbCSUhwm8FNe9P3rR7/QnxRfOi+C6YSOSwq+cdijfA+7DbsOADWCIGzWVp5Jnwl8r7I3kqFMdN1XygFchnTOr/wfUFW4Q6MQzKqsi43R0zZ0Rk+mbUTyOaSk8dXg8pljuN2c2hyVdbrVoAHz0CWTSPZTgAl5yZW6dFfT9DDd2qVjq0Eyp/m8YIAWPZZqLyKBlb/Dzg6URhCZ2vYosa848RImLosvAW4ZrXVpBF9wSD6E8jWS+xbOazGbsH7AD7iN2SZ51OpT0yMvOlC82ZsqXyU/HQPQGRNjg4UnL4NgiEOxNRpwmRew4d8oG+Do6nAFUYjtmbBKfDY1KvIUEFzllMc9viWBKCi1gwClZ7RXcbXd2p2U5hJOUtLGL+jeezpB3OnqETTZUbS/B4KdA3LHA/58lApkjz4oR2tS1lGmBs6IzLZJM5Bn1D/TYFVSp4onyRAzdi+Gp8e0wrMWHT2YkPlHQ47lWnITv+s7z+qwHX/MXAKrxqLEFbmrIto+kPOg7vO5HiQD5LEJDmXXcAobIGVYo5cOMdx0lVIoQPQZk6WNOJYV5sKde/spEobJWME9oIAFOHtlGurLHrMSn1ZGjUsiWH4GtamqC7sQQXU3FJzRrTjtQjX4W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(4326008)(26005)(9686003)(2906002)(41300700001)(4744005)(38070700005)(52536014)(54906003)(8936002)(316002)(110136005)(6506007)(7696005)(33656002)(86362001)(55016003)(5660300002)(76116006)(66946007)(66556008)(66476007)(71200400001)(38100700002)(122000001)(186003)(8676002)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elptSWZSZU02clpRY0F2aTFpaVNYcTVrVmdycEwwVWZhbHNnaE9vaUhocDR5?=
 =?utf-8?B?dzJBc1VPSjF0dWluM1JSR1ROTzVHMDVlSW5YR3R5N3BYNXF6dUJEcUhyUXRU?=
 =?utf-8?B?SG5CaVdRQlFOd2s5RUNralN3aU1OOHg2TFpleThpdExORWxoZHY0elFTelV6?=
 =?utf-8?B?OXhYcW9qcEJjcVI0anEwY01DZVZHeEc1cG9hUWtDeGlWamdmc2pBaHJ1OThR?=
 =?utf-8?B?b09zdzZMQTdlcTRHeTlvVENveHdTeTB2VUZuZmxEdHRZS0JMdjVvWUpOTWpF?=
 =?utf-8?B?TVJUYUk2Qmh5UURZOUJOY001RVVXVmFWYksyS04rRk5hYkk3U1FobWk2SFBi?=
 =?utf-8?B?QzhGaHZwN3lWZ2pROGZvTWNWa3NIMHVpSnhieU8zYXdLeGJpcGhJbWFtZXpR?=
 =?utf-8?B?VHVaeUR3d0piMFo3ZVZRYzd3a054VjlodTJ1WEk4K0JYajJLWlBFNmdqOHVM?=
 =?utf-8?B?Mk1aLzBFZ2VXclQ2Vmh2T3duWXNPR0JPdGxvNGxwZEp5SENnSk43M2JnUERu?=
 =?utf-8?B?VXJyWUtVb1hFeGZMSTV4VlZQQjZZY3N5L0Fwd0ZIV0VRSkpjYU1HZHZZZWVI?=
 =?utf-8?B?TVlmbDdGVlEwbTlXdlo3Z1FJMC96UDVrZnhsVWIrZjZ6ODNmOXVPZVFscjZT?=
 =?utf-8?B?akVYVHlFTUpCSExYOWdvVlZPZ3UzY1dzNWxvb1lJU1RHaklVN1VRVzNsUWJJ?=
 =?utf-8?B?RzA3aGNwWlcvV05GOUpGdXJCUzcxWkJrQUY1Z2g0V3p1aWp4emRER1BWQ1R1?=
 =?utf-8?B?ZWhUd3d4N3licUZxWEpxSCtNaTFBMzU0clcxL0hqTXRac2s2bWcvUVV5Rlp2?=
 =?utf-8?B?TmFBS2kvNWNFbFY3VDdwYXg5OFkvOXJKc0tvNXF0TmYveTBxckNrYUVjd2Vk?=
 =?utf-8?B?V3ROVnBzNEhNRFY3ME5iUkJGdVBJSkJBSkRWRGtEeEc5cnp3MW9SNDNMM2JR?=
 =?utf-8?B?b1hOM08wZlZyYmpxSjFCN2xQZFhndXQwSi9qS1dUTFhOM3FLY2FTME14WFZH?=
 =?utf-8?B?TnBLTHJHdlNHaWx4RytsVDJwUm50QlZDR1hPaHNjbmxNNGVQVVBkOFRHZzNs?=
 =?utf-8?B?Y01pRCt1Tk8zWTRYQUYxTmxVS3BOT3ljRkh4eW1FMS9zbVFpdjdiS0ZlK3N0?=
 =?utf-8?B?MWsvTnZsT0kwc0RMcHcxWmhzMngxYnlwMHJQcGw5ZTVoSG9CelRUMDgwb2ZG?=
 =?utf-8?B?QWtQSjg1SVRlTjRYeWVLSXBUWFkzNHhEYWovdGVTREFlZjBhTFFibTArNUlr?=
 =?utf-8?B?VElFclhaeVBqUXROVm5iRWNOa1M1V2dVNzM3NDYrenhMK3VQZ3RvSW5rcmpw?=
 =?utf-8?B?VURZNFl5WnJvc1pNSTNwL2tjRWdKRG05SnNCSzlsS292OUp6c1RMMjBqSkxV?=
 =?utf-8?B?RkZidXlSaFZlS2doY1FvQVVDam16elFoUUEvOGYxTDdxTEJ5RjBRQUczWU5P?=
 =?utf-8?B?Q1FzVEhQRGRMOUJCbUVSU2tKck5pRWdQRW9NUFFjazNMamdoK2VOQXpSenZw?=
 =?utf-8?B?NklZS2x5ZzRuRmNsUUg2WHlHNW9kSWhrazJ0amZyeStMZURLTFVnUDNxWm9N?=
 =?utf-8?B?OTIzMHhBRjRNYncrQmcwTzFFZ241LzA3K016cFJ5Y1g2OGNHSTd2b0ZtcmNa?=
 =?utf-8?B?a1h0akgzZm9ubTlmZW5kdnI1U1NSVXFiM1JrUm1GTEpLN1RxejkxSmkrUVFS?=
 =?utf-8?B?dFNpN3RZUEc1TkZ6YTRpTDNsRUIrd2hMMi80UWVNK21mKzlwSVRrSGZNSXJH?=
 =?utf-8?B?UVE2VEowNlRLYXBTYmVJbnhFN3I4QU5ObDhEV2pBY1FDSk5DQkdyengwSUtV?=
 =?utf-8?B?elNyTU9sTFZoZGhsOUlTRXptRi9oWFhDZXEwTGlqcVJYSGRrZW9OMERXTENo?=
 =?utf-8?B?SjNTQTE5ai93REZjUkRoU2M4c2JDUW9rYzByd1RoekpFSEt5QVF6QUpuSEZu?=
 =?utf-8?B?RDZSaHlOZ2lQZ0RzaTNwc1g1RmgxOEpXVnV6Sy9iTXZ3eEIvTTlkaVhoMHB2?=
 =?utf-8?B?V0VPM1U2c25yVitKNjBMcDhmbnI0SC9VZ1VwUzBybmFwWitoQVhFNG5uR2Vv?=
 =?utf-8?B?Y1oyZENIY3hFRkxvMmpvK1NheTVib0VycGZudS9meWYvU1FON0RVNnhzdC80?=
 =?utf-8?Q?7+Cs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ec7b2a-9874-4d6a-a0b0-08da5ef727bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 02:28:04.2483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNre0TzQTLzVKQyV2Dob40VQ0o9P9Hwj/LicYqge+Q2IEpRzjD/WWdjHduocjDUdbJiA0HQwNRaYoWKoM5a5aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5049
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgNSwgMjAyMiAxMDoyNSBQTQ0KPiAxLiBXaGVuIG1pZ3JhdGUgdGhlIFZN
IHRvIGEgbm9kZSB3aGljaCBoYXMgYSBtb3JlIHJlc291cmNlZnVsIGRldmljZS4gSWYNCj4gdGhl
IHNvdXJjZSBzaWRlIGRldmljZSBkb2VzIG5vdCBoYXZlIE1RLCBSU1Mgb3IgVFNPIGZlYXR1cmUs
IHRoZSB2RFBBDQo+IGRldmljZSBhc3NpZ25lZCB0byB0aGUgVk0gZG9lcyBub3QgaGF2ZSBNUSwg
UlNTIG9yIFRTTyBhcyB3ZWxsLiBXaGVuDQo+IG1pZ3JhdGluZyB0byBhIG5vZGUgd2hpY2ggaGFz
IGEgZGV2aWNlIHdpdGggTVEsIFJTUyBvciBUU08sIHRvIHByb3ZpZGUgYQ0KPiBjb25zaXN0ZW50
IG5ldHdvcmsgZGV2aWNlIHRvIHRoZSBndWVzdCwgdG8gYmUgdHJhbnNwYXJlbnQgdG8gdGhlIGd1
ZXN0LCB3ZQ0KPiBuZWVkIHRvIG1hc2sgb3V0IE1RLCBSU1Mgb3IgVFNPIGluIHRoZSB2RFBBIGRl
dmljZSB3aGVuIHByb3Zpc2lvbmluZy4NCj4gVGhpcyBpcyBhbiBleGFtcGxlIHRoYXQgbWFuYWdl
bWVudCBkZXZpY2UgbWF5IGhhdmUgZGlmZmVyZW50IGZlYXR1cmUgYml0cw0KPiB0aGFuIHRoZSB2
RFBBIGRldmljZS4NClllcy4gUmlnaHQuIA0K
