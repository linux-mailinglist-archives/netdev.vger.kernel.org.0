Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4D598A64
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344934AbiHRRV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243624AbiHRRVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:21:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9C7F5B6;
        Thu, 18 Aug 2022 10:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyPKSEPOd8P+0ah2ybgVxkUBe5R/UMQpfzD6GDSSZX4OEdl9uRM5eIwi7DIxlDVU4zligjcY+qvukOsZdq1ztzvL+KWZ0MSSzsiWXFiijOBQZUkff+qwLxma1+pmlA8GkFp3j0ym32NmztpCbRh2erFB86bkH/bgJds9wPN+oYbesiJbygAoHCG0n0vQNpcusRcfOmQ1hYM3b6PiInrndkX/f7gcCrZPirJQjJjWY2Z1jQNfJxEsPuPKjTcaM9rFvmJvh2UhClLrUMg5/TYmlVMj3rjspBJIhjIWQ/osTD0rtgGpuru28a6vGU3kRQbBjOtFQogRH7R7mgbiS3C/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywvDlvLoezYkYa206bWfG9+c9zkWobAk+DeNRI8N5qM=;
 b=iuj5SGPRTNo4VskbvAgwS3+mL/f+roH7e6OrWYPxdZMSFfbiojWqfE0TFkFKtnQbKDaqsEHit5xr4uC0eKZg+elPRHOrfpr99RzFUDXnUBi8btEwy7v9gbe93xsrgodZT3G/VSEHwzkZdzKjpdQrMm3SPpFjPqHYlEb64HoHjXBgZ6wPLCvWRycFxn54XEdYZv8VpgeBry0G6hSf0b5GO1tP2+08mV12zY0fo8Y6EKSIe2+YiZiwk4bQAdBGqhBkp8kS4bnoBQOThebtdSvLkYGiIyEepVVLiDzTFjqt0X4CFngMtYt7x9OEBQMehIf9ehrUu2JecxP9SlUI2OPAcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywvDlvLoezYkYa206bWfG9+c9zkWobAk+DeNRI8N5qM=;
 b=UL1ykofNQs04YKp40hVwj/UQVTVaDlIjuhKuZYbvTyk7j/QI7HGeO0Vj4zz+c4NlYbPYE0Hi0q3HBWfv9AqZwMVtxWNBkIBbQYS/Mh0O9PirPjgvyUc3etOmqunAyoedA8EKP5SLAosKwyJWeHSb5i8dUmwcoOS65w9WyIxP5IyNfmH6oVtdy/JuteAcuWULL8SPlZLDg8bQU8EibhBE7twqF9yFeVBd2vbLrlcSTscKkNymcewR2Vb3beiUyRkddqw/AivDFR+muNG4p9NKIK/zXD+xUehc9GrqAwpuOGb3/honsIgf/sOnccT5J4N7VvOCtcM5KTV2k/fDj4VGTQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BYAPR12MB3399.namprd12.prod.outlook.com (2603:10b6:a03:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 17:20:05 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%5]) with mapi id 15.20.5525.019; Thu, 18 Aug 2022
 17:20:05 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Topic: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Index: AQHYsIpJtq9YpvWt2kmNOt5VAnquUK2wzXWggAAf+YCAARYlwIAABGeAgABR/ICAAbgvAIAA2d4g
Date:   Thu, 18 Aug 2022 17:20:05 +0000
Message-ID: <PH0PR12MB5481EE0FE7CE17892E426EB4DC6D9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
 <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220816170753-mutt-send-email-mst@kernel.org>
 <352e9533-8ab1-cec0-0141-ce0735ee39f5@intel.com>
 <df2bab2d-2bc1-c3c2-f87c-dcc6bdc5737d@redhat.com>
In-Reply-To: <df2bab2d-2bc1-c3c2-f87c-dcc6bdc5737d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a91ebca8-853a-4cd7-36ce-08da813de494
x-ms-traffictypediagnostic: BYAPR12MB3399:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: esIm7NDw9dPoU/VSdi4WmrBQoULK9kmBJ/mZK/7aZcBlXUCAc1iDc58/3R0ccoMCBbUzciihnryZNcmZeMIAvlfIrSyXbqU4yQ4Ak7p6fzkVQpNQyKZTlYVgR1tpWqAQ1jSr2MYPTn35qaQg8zo6+OR71ziYZY0yJUqv+zA2iaGOjD18fZdSFmSXJ/zlhpCORMklpxLQ7p1EUlJ5vxTUMeNKN/8PzE8IUtLD6jdWvqGSqfzXnkE1LKztINZBy2Ii0WCgcwqhIK4tBC03LA4Wr03YiDn7vzx5opI18vFAuLVdfTFqMWI7r1zx/KwFR4DFX8/kkb0gKLsjH7QSbCrK5kYfhRTTx2DaWQcvQxR4psMrsnfgmcFtE6rkWZ8GG6HkCuIKzYgVIvock021JY+a3TGhFJ8F7IYlI1cOvGmbf3ZXgrbgApcFg2JilCDVBo4mbw4f31K1aLcx4rwjMmgDWEITKRuqni7U7JexZzw25w7o36w+pEEMeCknJqOPbMM3MR9l0YQ03P9qrAHPfb+XcB45NTrHNeZecBZjYyudQyv0HKrKd8S4BecrltyZJD34WcmW+5DlvMM+ly1ahKOPFTa7yYfer7MzDv4GAM2voY1rgtubNUyRKL5MKCJdrYaRKozqMRTi8tJMPSA2HFCTPKra99YJ5JldFzxa0mZO+3KFPn1/ai7LQfj/8a8yGQq2DkJdGh9IURuQsXi6Y/9vw5sNmXDBoQITvspaLVtBiNVlmNEgKHIoYMBxxGULZLzGKDpmcvODbsGLlGPNHthxBAAbYmQkchl9HpqWr7+D7c3V73k7tZsML+5BF+Pf6B1kUbugHMoYZlRAF6kLR7V9KG0k3SjXTEwWHhSm7R1zQ4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(8936002)(16799955002)(54906003)(83380400001)(66446008)(110136005)(55016003)(8676002)(4326008)(64756008)(71200400001)(76116006)(66556008)(66476007)(316002)(66946007)(5660300002)(41300700001)(86362001)(6506007)(52536014)(2906002)(966005)(186003)(38070700005)(53546011)(38100700002)(7696005)(122000001)(478600001)(9686003)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHQyZm9uQ08vdHYwS3dOMXROUE1SRnh1MlV2MFJYOTFhVmsraFZ1bWVabVZJ?=
 =?utf-8?B?VExwQit5S3RrWHJsUHdJWlB2MXBQVGdiaEM5RnE2WmZKOWMwNVYrZGRKZWx4?=
 =?utf-8?B?UE10SnlVMTFOaXZFd1hkY0tsUjlmVC96alduc1BYcG83c09JdHFIaTJuZWZZ?=
 =?utf-8?B?eWJiSG9nVGtiTC9PRTF3cmZlU3pWSEVLd0JrUkFBQkMzMk1lc3FHY0phd0tO?=
 =?utf-8?B?NlZZNlBtSmVJMW9nR3lzMWYyenJVMmhmMElGNjJSOThUQ0FpNFVlamdZMjgz?=
 =?utf-8?B?ZlpvT1Y5WmtBVXVDd0sxQSt6V2VuUFdkVDJFbG5RSHRQVDQzS2pjMUxURzVT?=
 =?utf-8?B?cWt0ckl2S2NBcTRZdkN4ZXR1c1FKZkYySnBlVXZmaW9yQUlaZXFVTHRTL3oz?=
 =?utf-8?B?NWhtN2VkeU5uc2NIMWNqSlYrbGM1MkZqajV6VEROYkZTWWpENkI5amZZSFVE?=
 =?utf-8?B?cy9FOHI4UFViWVpIc2Vld0swZEZFbmtOOS9icVdwYTEvdUNiRjlQTlQ2Yjgx?=
 =?utf-8?B?cm9Kb3hKQldvSUc5OHBQcmlLSDMzUTJUZm0wdEtIYVFNWnoyd1J5Skt2VjFB?=
 =?utf-8?B?QlZ6TnVZbG14eGtBQkRPaWdRS3Y0U0QzUjBIaFd3ZnhpTWVDQUhlaGZ6ZmVU?=
 =?utf-8?B?L2hPeXAxcGY5eENiU0Z6YlZhcmRpNnB4cDN1VkNSY0R4dHR5WnlsUXorL1lY?=
 =?utf-8?B?VThIeVRFNy9wMC9NR1JBWG5sK0J0TTdLTHFVM3lKcTdqV20wVWhPblgyeDlE?=
 =?utf-8?B?dG41NXUrVmg3QW5vR3FyUjBDOW1SNXh2T29ETU41UG9qVmxWVFpKa2FMLzlw?=
 =?utf-8?B?QnZROFFsOGdPV0FXeHRuSXRORURadGNRbTd0ZHBLNUJCQUplV1MzdGl6QWlh?=
 =?utf-8?B?UzU5dlV3ZDNTa0hTa0g2eTZpWm9CZFdiL2tuODJnc2Q2aS9UcUpVRmEvTzYy?=
 =?utf-8?B?VFFqTHBCMHZwb3F4ZU1FYVNqTEwyWkNSYkVaejhUaHJIVGJWSy95a0ZHWkxW?=
 =?utf-8?B?T0UvbFhaV1NhbDdJZVgxMTYzaFllZDdEL0N2YStXcXN3a29mUUo4SmFnUEdF?=
 =?utf-8?B?WmhZd0RxbGRkT3dsMFFRWHFZY1ZCRHhDRmxCajdHTnpaZkJZa3c3eE5HUXlU?=
 =?utf-8?B?ajVWR29TRzFQQjRCdmtKVU54RFVnbXFtWUtVT0J5WlFUNXhiRVBFaWJzbmJ5?=
 =?utf-8?B?L21OUStaNWZiUElWVkgweTdwKzJZdHRHcDBzaDNrcVB4RDhoY2dOU1dWc3Ay?=
 =?utf-8?B?RXpQa2I1NkhsUHF2TnpNSmh4ZWlOeHJsZjBTditSb3RqL3JuZmMwcDJmbkM2?=
 =?utf-8?B?MGxDS1A3cTJXdWpvRTFZSSt3SkkvcG1Ga2FlYWNoazJ5eTlETTdwU3cvbTdT?=
 =?utf-8?B?ZmRESEpZc1JIWk9HcU1KcThUZzZDMk1UdlV3UEZhdjVIYjJRb2xocmZzSHdO?=
 =?utf-8?B?TjFmL3B0eTVwamw1ZGVMR3RGak4xclRNcXBvNjNlaXdnMys0ZXY5VC8xSVhl?=
 =?utf-8?B?blptRWxXRnViRGJHcEFZS1o0QkdvczRLVndSTkJaN1RIMk42ZXd5dEIyU2lK?=
 =?utf-8?B?L2FSb2ltMDlkYWtBdE5nY2FWUVptaHB0ZmVQWjVqZE0zeU4zV2Y2azFSOVJP?=
 =?utf-8?B?dVl1TVUrSEFQMVlIbGU1QnJTYU5TTnlEenNlMnBaaHNiWGJPdThldlA3UzJG?=
 =?utf-8?B?MFRiOXNGUXl6enNXaE9PdnZIbGRQQW9HYnpEMmF5UXVKZFJPR0tQVXkvaW1o?=
 =?utf-8?B?RGg5UWxGOGFEWTVBTGZOSFJ4TzlTbTE3cE5OWUFCRDU0SHVtRDhqcnhpSUlh?=
 =?utf-8?B?eXpZN3pBVlpXSmRrM0VCZDFUQ3AzZE5rcmlsL09HUHlUeFlTS3owWFdyV3Bp?=
 =?utf-8?B?Nk8zOVJ3bzRoZmJoTkZYZ1JZalRScmdjcGtGQTVsN3VvT2VONENrR2xPTUc4?=
 =?utf-8?B?OE9wQ2huNzkvdGR4TThMa0tjZDgxT1haZTM5dzROT0JKUEt6WWNJbkRjV0hh?=
 =?utf-8?B?UGp2cVhPVmxBZDRrVkxuM255c0h0U08rUGswM3Nkc3BvOEF3TXJvR3N0ZE1J?=
 =?utf-8?B?SFdhdEhpRTRhQllwWGFKWUVGQnlSQmJXcmpFVkowVnhoRER0M2xaWFA0c3pv?=
 =?utf-8?Q?Hk48=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a91ebca8-853a-4cd7-36ce-08da813de494
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 17:20:05.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfTucXGHiXnU/4D6Htp7tGmZdWZaAVNneaM5e2cflO9MAwVlOABrgYJvsswjtfV4OHu9ELqLLaa5KegSOWaJlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3399
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBBdWd1c3QgMTgsIDIwMjIgMTI6MTkgQU0NCg0KPiA+Pj4+IE9uIDgvMTYvMjAyMiAxMDoz
MiBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+Pj4+Pj4gRnJvbTogWmh1IExpbmdzaGFuIDxs
aW5nc2hhbi56aHVAaW50ZWwuY29tPg0KPiA+Pj4+Pj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMTUs
IDIwMjIgNToyNyBBTQ0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IFNvbWUgZmllbGRzIG9mIHZpcnRpby1u
ZXQgZGV2aWNlIGNvbmZpZyBzcGFjZSBhcmUgY29uZGl0aW9uYWwgb24NCj4gPj4+Pj4+IHRoZSBm
ZWF0dXJlIGJpdHMsIHRoZSBzcGVjIHNheXM6DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gIlRoZSBtYWMg
YWRkcmVzcyBmaWVsZCBhbHdheXMgZXhpc3RzICh0aG91Z2ggaXMgb25seSB2YWxpZCBpZg0KPiA+
Pj4+Pj4gVklSVElPX05FVF9GX01BQyBpcyBzZXQpIg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+ICJtYXhf
dmlydHF1ZXVlX3BhaXJzIG9ubHkgZXhpc3RzIGlmIFZJUlRJT19ORVRfRl9NUSBvcg0KPiA+Pj4+
Pj4gVklSVElPX05FVF9GX1JTUyBpcyBzZXQiDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gIm10dSBvbmx5
IGV4aXN0cyBpZiBWSVJUSU9fTkVUX0ZfTVRVIGlzIHNldCINCj4gPj4+Pj4+DQo+ID4+Pj4+PiBz
byB3ZSBzaG91bGQgcmVhZCBNVFUsIE1BQyBhbmQgTVEgaW4gdGhlIGRldmljZSBjb25maWcgc3Bh
Y2UNCj4gb25seQ0KPiA+Pj4+Pj4gd2hlbiB0aGVzZSBmZWF0dXJlIGJpdHMgYXJlIG9mZmVyZWQu
DQo+ID4+Pj4+IFllcy4NCj4gPj4+Pj4NCj4gPj4+Pj4+IEZvciBNUSwgaWYgYm90aCBWSVJUSU9f
TkVUX0ZfTVEgYW5kIFZJUlRJT19ORVRfRl9SU1MgYXJlIG5vdA0KPiBzZXQsDQo+ID4+Pj4gdGhl
DQo+ID4+Pj4+PiB2aXJ0aW8gZGV2aWNlIHNob3VsZCBoYXZlIG9uZSBxdWV1ZSBwYWlyIGFzIGRl
ZmF1bHQgdmFsdWUsIHNvDQo+ID4+Pj4+PiB3aGVuIHVzZXJzcGFjZSBxdWVyeWluZyBxdWV1ZSBw
YWlyIG51bWJlcnMsIGl0IHNob3VsZCByZXR1cm4NCj4gbXE9MQ0KPiA+Pj4+Pj4gdGhhbiB6ZXJv
Lg0KPiA+Pj4+PiBOby4NCj4gPj4+Pj4gTm8gbmVlZCB0byB0cmVhdCBtYWMgYW5kIG1heF9xcHMg
ZGlmZmVyZW50bHkuDQo+ID4+Pj4+IEl0IGlzIG1lYW5pbmdsZXNzIHRvIGRpZmZlcmVudGlhdGUg
d2hlbiBmaWVsZCBleGlzdC9ub3QtZXhpc3RzIHZzDQo+ID4+Pj4+IHZhbHVlDQo+ID4+Pj4gdmFs
aWQvbm90IHZhbGlkLg0KPiA+Pj4+IGFzIHdlIGRpc2N1c3NlZCBiZWZvcmUsIE1RIGhhcyBhIGRl
ZmF1bHQgdmFsdWUgMSwgdG8gYmUgYQ0KPiA+Pj4+IGZ1bmN0aW9uYWwgdmlydGlvLSBuZXQgZGV2
aWNlLCB3aGlsZSBNQUMgaGFzIG5vIGRlZmF1bHQgdmFsdWUsIGlmDQo+ID4+Pj4gbm8gVklSVElP
X05FVF9GX01BQyBzZXQsIHRoZSBkcml2ZXIgc2hvdWxkIGdlbmVyYXRlIGEgcmFuZG9tDQo+IE1B
Qy4NCj4gPj4+Pj4+IEZvciBNVFUsIGlmIFZJUlRJT19ORVRfRl9NVFUgaXMgbm90IHNldCwgd2Ug
c2hvdWxkIG5vdCByZWFkIE1UVQ0KPiA+Pj4+Pj4gZnJvbSB0aGUgZGV2aWNlIGNvbmZpZyBzYXBj
ZS4NCj4gPj4+Pj4+IFJGQzg5NCA8QSBTdGFuZGFyZCBmb3IgdGhlIFRyYW5zbWlzc2lvbiBvZiBJ
UCBEYXRhZ3JhbXMgb3Zlcg0KPiA+Pj4+Pj4gRXRoZXJuZXQNCj4gPj4+Pj4+IE5ldHdvcmtzPiBz
YXlzOiJUaGUgbWluaW11bSBsZW5ndGggb2YgdGhlIGRhdGEgZmllbGQgb2YgYSBwYWNrZXQNCj4g
Pj4+Pj4+IHNlbnQNCj4gPj4+Pj4+IE5ldHdvcmtzPiBvdmVyDQo+ID4+Pj4+PiBhbiBFdGhlcm5l
dCBpcyAxNTAwIG9jdGV0cywgdGh1cyB0aGUgbWF4aW11bSBsZW5ndGggb2YgYW4gSVANCj4gPj4+
Pj4+IGRhdGFncmFtIHNlbnQgb3ZlciBhbiBFdGhlcm5ldCBpcyAxNTAwIG9jdGV0cy7CoCBJbXBs
ZW1lbnRhdGlvbnMNCj4gPj4+Pj4+IGFyZSBlbmNvdXJhZ2VkIHRvIHN1cHBvcnQgZnVsbC1sZW5n
dGggcGFja2V0cyINCj4gPj4+Pj4gVGhpcyBsaW5lIGluIHRoZSBSRkMgODk0IG9mIDE5ODQgaXMg
d3JvbmcuDQo+ID4+Pj4+IEVycmF0YSBhbHJlYWR5IGV4aXN0cyBmb3IgaXQgYXQgWzFdLg0KPiA+
Pj4+Pg0KPiA+Pj4+PiBbMV0NCj4gPj4+Pj4gaHR0cHM6Ly93d3cucmZjLWVkaXRvci5vcmcvZXJy
YXRhX3NlYXJjaC5waHA/cmZjPTg5NCZyZWNfc3RhdHVzPTANCj4gPj4+PiBPSywgc28gSSB0aGlu
ayB3ZSBzaG91bGQgcmV0dXJuIG5vdGhpbmcgaWYgX0ZfTVRVIG5vdCBzZXQsIGxpa2UNCj4gPj4+
PiBoYW5kbGluZyB0aGUgTUFDDQo+ID4+Pj4+PiB2aXJ0aW8gc3BlYyBzYXlzOiJUaGUgdmlydGlv
IG5ldHdvcmsgZGV2aWNlIGlzIGEgdmlydHVhbCBldGhlcm5ldA0KPiA+Pj4+Pj4gY2FyZCIsIHNv
IHRoZSBkZWZhdWx0IE1UVSB2YWx1ZSBzaG91bGQgYmUgMTUwMCBmb3IgdmlydGlvLW5ldC4NCj4g
Pj4+Pj4+DQo+ID4+Pj4+IFByYWN0aWNhbGx5IEkgaGF2ZSBzZWVuIDE1MDAgYW5kIGhpZ2hlIG10
dS4NCj4gPj4+Pj4gQW5kIHRoaXMgZGVyaXZhdGlvbiBpcyBub3QgZ29vZCBvZiB3aGF0IHNob3Vs
ZCBiZSB0aGUgZGVmYXVsdCBtdHUNCj4gPj4+Pj4gYXMgYWJvdmUNCj4gPj4+PiBlcnJhdGEgZXhp
c3RzLg0KPiA+Pj4+PiBBbmQgSSBzZWUgdGhlIGNvZGUgYmVsb3cgd2h5IHlvdSBuZWVkIHRvIHdv
cmsgc28gaGFyZCB0byBkZWZpbmUgYQ0KPiA+Pj4+PiBkZWZhdWx0DQo+ID4+Pj4gdmFsdWUgc28g
dGhhdCBfTVEgYW5kIF9NVFUgY2FuIHJlcG9ydCBkZWZhdWx0IHZhbHVlcy4NCj4gPj4+Pj4gVGhl
cmUgaXMgcmVhbGx5IG5vIG5lZWQgZm9yIHRoaXMgY29tcGxleGl0eSBhbmQgc3VjaCBhIGxvbmcg
Y29tbWl0DQo+ID4+Pj4gbWVzc2FnZS4NCj4gPj4+Pj4gQ2FuIHdlIHBsZWFzZSBleHBvc2UgZmVh
dHVyZSBiaXRzIGFzLWlzIGFuZCByZXBvcnQgY29uZmlnIHNwYWNlDQo+ID4+Pj4+IGZpZWxkIHdo
aWNoDQo+ID4+Pj4gYXJlIHZhbGlkPw0KPiA+Pj4+PiBVc2VyIHNwYWNlIHdpbGwgYmUgcXVlcnlp
bmcgYm90aC4NCj4gPj4+PiBJIHRoaW5rIE1BQyBhbmQgTVRVIGRvbid0IGhhdmUgZGVmYXVsdCB2
YWx1ZXMsIHNvIHJldHVybiBub3RoaW5nIGlmDQo+ID4+Pj4gdGhlIGZlYXR1cmUgYml0cyBub3Qg
c2V0LCBmb3IgTVEsIGl0IGlzIHN0aWxsIG1heF92cV9wYXJpcyA9PSAxIGJ5DQo+ID4+Pj4gZGVm
YXVsdC4NCj4gPj4+IEkgaGF2ZSBzdHJlc3NlZCBlbm91Z2ggdG8gaGlnaGxpZ2h0IHRoZSBmYWN0
IHRoYXQgd2UgZG9u4oCZdCB3YW50IHRvDQo+ID4+PiBzdGFydCBkaWdnaW5nIGRlZmF1bHQvbm8g
ZGVmYXVsdCwgdmFsaWQvbm8tdmFsaWQgcGFydCBvZiB0aGUgc3BlYy4NCj4gPj4+IEkgcHJlZmVy
IGtlcm5lbCB0byByZXBvcnRpbmcgZmllbGRzIHRoYXQgX2V4aXN0c18gaW4gdGhlIGNvbmZpZw0K
PiA+Pj4gc3BhY2UgYW5kIGFyZSB2YWxpZC4NCj4gPj4+IEkgd2lsbCBsZXQgTVNUIHRvIGhhbmRs
ZSB0aGUgbWFpbnRlbmFuY2UgbmlnaHRtYXJlIHRoYXQgdGhpcyBraW5kIG9mDQo+ID4+PiBwYXRj
aCBicmluZ3MgaW4gd2l0aG91dCBhbnkgdmlzaWJsZSBnYWluIHRvIHVzZXIgc3BhY2Uvb3JjaGVz
dHJhdGlvbg0KPiA+Pj4gYXBwcy4NCj4gPj4+DQo+ID4+PiBBIGxvZ2ljIHRoYXQgY2FuIGJlIGVh
c2lseSBidWlsZCBpbiB1c2VyIHNwYWNlLCBzaG91bGQgYmUgd3JpdHRlbiBpbg0KPiA+Pj4gdXNl
ciBzcGFjZS4NCj4gPj4+IEkgY29uY2x1ZGUgbXkgdGhvdWdodHMgaGVyZSBmb3IgdGhpcyBkaXNj
dXNzaW9uLg0KPiA+Pj4NCj4gPj4+IEkgd2lsbCBsZXQgTVNUIHRvIGRlY2lkZSBob3cgaGUgcHJl
ZmVycyB0byBwcm9jZWVkLg0KPiA+Pj4NCj4gPj4+Pj4+ICvCoMKgwqAgaWYgKChmZWF0dXJlcyAm
IEJJVF9VTEwoVklSVElPX05FVF9GX01UVSkpID09IDApDQo+ID4+Pj4+PiArwqDCoMKgwqDCoMKg
wqAgdmFsX3UxNiA9IDE1MDA7DQo+ID4+Pj4+PiArwqDCoMKgIGVsc2UNCj4gPj4+Pj4+ICvCoMKg
wqDCoMKgwqDCoCB2YWxfdTE2ID0gX192aXJ0aW8xNl90b19jcHUodHJ1ZSwgY29uZmlnLT5tdHUp
Ow0KPiA+Pj4+Pj4gKw0KPiA+Pj4+PiBOZWVkIHRvIHdvcmsgaGFyZCB0byBmaW5kIGRlZmF1bHQg
dmFsdWVzIGFuZCB0aGF0IHRvbyB0dXJuZWQgb3V0DQo+ID4+Pj4+IGhhZA0KPiA+Pj4+IGVycmF0
YS4NCj4gPj4+Pj4gVGhlcmUgYXJlIG1vcmUgZmllbGRzIHRoYXQgZG9lc27igJl0IGhhdmUgZGVm
YXVsdCB2YWx1ZXMuDQo+ID4+Pj4+DQo+ID4+Pj4+IFRoZXJlIGlzIG5vIHBvaW50IGluIGtlcm5l
bCBkb2luZyB0aGlzIGd1ZXNzIHdvcmssIHRoYXQgdXNlciBzcGFjZQ0KPiA+Pj4+PiBjYW4gZmln
dXJlDQo+ID4+Pj4gb3V0IG9mIHdoYXQgaXMgdmFsaWQvaW52YWxpZC4NCj4gPj4+PiBJdCdzIG5v
dCBndWVzdCB3b3JrLCB3aGVuIGd1ZXN0IGZpbmRzIG5vIGZlYXR1cmUgYml0cyBzZXQsIGl0IGNh
bg0KPiA+Pj4+IGRlY2lkZSB3aGF0IHRvIGRvLg0KPiA+Pj4gQWJvdmUgY29kZSBvZiBkb2luZyAx
NTAwIHdhcyBwcm9iYWJseSBhbiBob25lc3QgYXR0ZW1wdCB0byBmaW5kIGENCj4gPj4+IGxlZ2l0
aW1hdGUgZGVmYXVsdCB2YWx1ZSwgYW5kIHdlIHNhdyB0aGF0IGl0IGRvZXNu4oCZdCB3b3JrLg0K
PiA+Pj4gVGhpcyBpcyBzZWNvbmQgZXhhbXBsZSBhZnRlciBfTVEgdGhhdCB3ZSBib3RoIGFncmVl
IHNob3VsZCBub3QNCj4gPj4+IHJldHVybiBkZWZhdWx0Lg0KPiA+Pj4NCj4gPj4+IEFuZCB0aGVy
ZSBhcmUgbW9yZSBmaWVsZHMgY29taW5nIGluIHRoaXMgYXJlYS4NCj4gPj4+IEhlbmNlLCBJIHBy
ZWZlciB0byBub3QgYXZvaWQgcmV0dXJuaW5nIHN1Y2ggZGVmYXVsdHMgZm9yIE1BQywgTVRVLA0K
PiA+Pj4gTVEgYW5kIHJlc3QgYWxsIGZpZWxkcyB3aGljaCBkb2VzbuKAmXQgX2V4aXN0c18uDQo+
ID4+Pg0KPiA+Pj4gSSB3aWxsIGxldCBNU1QgdG8gZGVjaWRlIGhvdyBoZSBwcmVmZXJzIHRvIHBy
b2NlZWQgZm9yIGV2ZXJ5IGZpZWxkDQo+ID4+PiB0byBjb21lIG5leHQuDQo+ID4+PiBUaGFua3Mu
DQo+ID4+Pg0KPiA+Pg0KPiA+PiBJZiBNVFUgZG9lcyBub3QgcmV0dXJuIGEgdmFsdWUgd2l0aG91
dCBfRl9NVFUsIGFuZCBNQUMgZG9lcyBub3QNCj4gPj4gcmV0dXJuIGEgdmFsdWUgd2l0aG91dCBf
Rl9NQUMgdGhlbiBJTU8geWVzLCBudW1iZXIgb2YgcXVldWVzIHNob3VsZA0KPiA+PiBub3QgcmV0
dXJuIGEgdmFsdWUgd2l0aG91dCBfRl9NUS4NCj4gPiBzdXJlIEkgY2FuIGRvIHRoaXMsIGJ1dCBt
YXkgSSBhc2sgd2hldGhlciBpdCBpcyBhIGZpbmFsIGRlY2lzaW9uLCBJDQo+ID4gcmVtZW1iZXIg
eW91IHN1cHBvcnRlZCBtYXhfcXVldWVfcGFyaXMgPSAxIHdpdGhvdXQgX0ZfTVEgYmVmb3JlDQo+
IA0KPiANCj4gSSB0aGluayB3ZSBqdXN0IG5lZWQgdG8gYmUgY29uc2lzdGVudDoNCj4gDQo+IEVp
dGhlcg0KPiANCj4gMSkgbWFrZSBmaWVsZCBjb25kaXRpb25hbCB0byBhbGlnbiB3aXRoIHNwZWMN
Cj4gDQo+IG9yDQo+IA0KPiAyKSBhbHdheXMgcmV0dXJuIGEgdmFsdWUgZXZlbiBpZiB0aGUgZmVh
dHVyZSBpcyBub3Qgc2V0DQo+IA0KPiBJdCBzZWVtcyB0byBtZSAxKSBpcyBlYXNpZXIuDQo+IA0K
KzENCg==
