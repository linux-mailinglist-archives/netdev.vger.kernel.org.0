Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE66E5139
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDQTxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDQTxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:53:13 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B7B55A9;
        Mon, 17 Apr 2023 12:52:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHITPRutTfYfWp8F+tJ3Bt8Y3023NQ0t7rDZcvZGegh9jQkPtOHG0xdM2bzGikRwNs4kY+6l14lqYPvC3YJnJ6lRi6GVX9Bo0ShabyQhMxHVXh0AgTFzC1TsX/tekqywijCk7vEhCY7RzpbJWDRxjEEx/mSF1hhOWK03p0E9+7C2V21MW2H9C8/8U7drY0TWTKWbAQLKUxE4Pgu/9a6bcbleEXX2oAof52e98gWVh7OnJuuV5QFm8LeME5QHVdySodbZp6qedgy9diPEo6M7YJ3Qmk1ZqKeyPDzw2z/A6ntEHbJGEfkL+dFUoWVp81HaNBqhefLTYosluMug8fGopg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZimGEVFIx/tYaoWs7Kin6h/Z2X5RFLg/tR8Yn4GU00=;
 b=MKrwKOyPu4txLE93fie0K7F/fmmzcOyjBF7xLJwSOjpJ4etfmlu6ri9YCW7UmBNWmewOeahmAo6cULPe1unZaZ0vQIE75Jub+iGvgflCYO6TEC0DOVJB6uLGb8JGn6QnI4NABUFUL/tDuI187jsde+26TxOzFleUvN3IH2mIAe1dLeV531kmOsadkrJgH38HkztNi6XMXI2UtwYIl+DqCmkrx7zd6ZQOXmrqOen6K3XTqW94p4W0qPdUnX39Iq9Q9byIZaQ0O/KIxWk0GgiK/erPrfudEOs/xGymEQW7LDDmqnwuEg8NyNPF+/kJNzJxwXo6HzFv06Mr6IeKXbyPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZimGEVFIx/tYaoWs7Kin6h/Z2X5RFLg/tR8Yn4GU00=;
 b=GwI9Op+DVfAOKDNvX2VblPqQ3t+Dn+qE+XyGUqs2cymZe2Aptrjv0zSDQdxFzKlgsiIISnjhBYcVbs0AfkfnYAQK4Wkj1Z/nDW1ZM5j2UvYW9sVkrwZCWNww/uK1xtTG03AYz0GP/IzrRn28BSpTG/661q1Qcd/g+DiToy28m9I=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by IA0PR21MB4007.namprd21.prod.outlook.com (2603:10b6:208:490::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.1; Mon, 17 Apr
 2023 19:52:01 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65%6]) with mapi id 15.20.6340.001; Mon, 17 Apr 2023
 19:52:01 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Topic: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Index: AQHZbYQwnFQeBoPFWkmXBOV6OTjsn68roqYAgADK5ICAA2IugIAAIG2g
Date:   Mon, 17 Apr 2023 19:52:01 +0000
Message-ID: <PH7PR21MB311608F7EF4F951C82DDF3ADCA9C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
        <20230414190608.3c21f44f@kernel.org>
        <PH7PR21MB3116023068CFA8D600FA5B18CA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230417105229.7d1eb988@kernel.org>
In-Reply-To: <20230417105229.7d1eb988@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8428b3ff-8c01-415a-9bf7-4dc54196b284;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-17T19:48:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|IA0PR21MB4007:EE_
x-ms-office365-filtering-correlation-id: 9dd3090a-fd3b-42a6-b00e-08db3f7d3632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rn2LkaupBohnkPqJUvE5M/qzO8hUGJSfTiy3HOzPIW4VkPnJOYxB31fRSFRVh2GlEDBCLACzViJpODITl1+RCjEpqaItrA+fTGP6QVt5MJVkp/CZOe5Jc+pnqGxue3VeMPKaAMFcAdOs9D7TdXTmY7wZnysaskQMbjRv4lL6yX1vyT7UZl/XvLvUa5a34TpbojODbfPidQm1qM75/GbTIWdz2L8cSZTMNqa/F9BC2wSIF9AabPam1JhI4ZVBLbgXVMHcxxRE1Ie8iu8Mk21ji0uahJEY7UJ6yoWrRgSpp6Qlt7LL+Z7Y9iAPAR7uGRPRPzuitxhf5BGGiX+KeFnBko36MdJzvuA/2k2NNHp5zdFlHjw5aG9j12kI8V30IcXDPz8zUZkBBQ/OQj2IobAtfDM7Ml3P5Pf0A8aCYd0Dgexzksl5Wt1iQ1fL/ZCK4l2feDJxvDLTKg7cMUdOsoBij1DDel9kA7/zjzzTYEEi281jwrrc/cXEUZCihF3yAiTE1fuKAvbzOTyjeQnvwLFmtLZoh8zYW1tGVQdX1SwYBadVlV8I9TWz8uqdwms6h4jc9rM6aTNw5iFL2w9qlaqc3z+VnekUKTlMj92/BILBIEPH8lzGR4GpziD9i+7EBdVNZg4l84HJV9BpRMSEduORKkIFO5qtvsS9ZrHdo5iVOC8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199021)(33656002)(6916009)(54906003)(4326008)(786003)(316002)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(966005)(71200400001)(7696005)(10290500003)(478600001)(41300700001)(55016003)(5660300002)(8990500004)(8936002)(8676002)(7416002)(2906002)(52536014)(38070700005)(86362001)(82950400001)(82960400001)(122000001)(38100700002)(6506007)(9686003)(26005)(186003)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzFtKy9FMmhSZDgvYVBweTFzQm9ZeHZXaGZTTllHNlliRFYwZy9HWDA1RlZW?=
 =?utf-8?B?enRVdHhBSmNLOHlBN2l0RGx1S1RvMkI5TlhSN0hVVHVDamt2Q2tKMmpBK3hu?=
 =?utf-8?B?eE41S0JtVFZGYWlSTzZoRkJYWnN3UVZCU1E3UmlmQjBPK3JNTDFaYzdVVlhk?=
 =?utf-8?B?MGI2OExNMEViSm9YOXBIVkRNVjNqeENsdFR0bG1ZdzRHN3dXTmFCc1Rwbkt2?=
 =?utf-8?B?SjFNTklwZlhNYzRtR1NFTlVTei9wMjZzU0xEdm44OE5zOXlqZ1JhSGhoMXl5?=
 =?utf-8?B?UkxaU0hhU283bEhXVEdhQnJSNVdMeGk5UGhKcXJjWlVFMUh1cnpEcndva3pN?=
 =?utf-8?B?Z3dZM2ZONHFzNEIzS3VENUpzTTgvYVhzNWRLWDFBZnF2Sk9sRkdWUUU4eUEw?=
 =?utf-8?B?cUtTY1ljSFlRZS9BTm1kaWxuRFVCR3hpZXVNN09iN0ZjK1BaZWp0bmVCdHRC?=
 =?utf-8?B?RHN5R0Vvbjk5VXFWWkNCRzM5QkhwNndPZXQ2QWVYU2hYWlh2WHJ0MVNKY05w?=
 =?utf-8?B?N0FFVlp2dTN4SE00UytJQjFrc2lhNG9FQ2lJVE5tWUFYUE1BUUpSUUErclh5?=
 =?utf-8?B?YjhyeUw1QXQrSEJYTlpBd2ZSSUVadzRVZEFONDFnV1lKYlFNOU5GaVM1STZm?=
 =?utf-8?B?aWlJN0FWYW1YcjY1UTA5L3RHNjRtZWFNVHFCa0sycVAxbE11MXcvYXdaOFVo?=
 =?utf-8?B?cElNN3c4OHhuQlNZK1lyaXBtN2tuQzFmaVE3M29iN1gyZ0pBY1BBNDVVQzll?=
 =?utf-8?B?WWx1MEhtUUp3SUZLWEVFSXV5SDF6WUNWeDhvaEFXQmpxRDVhTDdSN3k3d0x2?=
 =?utf-8?B?WnVRTmxMNVZXckttYS80Sk05UXYxN3N2bnc0dis3U2ZHallVYjNseUwrZTN0?=
 =?utf-8?B?V29KaFcvQXhsYkFlRllMdE9kZTJWSnNCTU5mcmZDNUI4T0RBZFV2dXJzN1BV?=
 =?utf-8?B?bkM1NFgyMENrcmsrTExucE1nazQ2QW8veEE1Uys2ZXZJZ28vVEJYQVNrMUVh?=
 =?utf-8?B?Smtyay9YU1N2ZjdzTFRmalBGQTVmY2hCMURyamdlelhVZkhRbzNoZU9NWk5n?=
 =?utf-8?B?UzR6bjJWbGtOZWpuTDNCMmVod2ZLbTJ1b0NzYk1uQlRmaWN1c2FnU29naDhY?=
 =?utf-8?B?YTh4dGtKTXhXbzdYQTltT1lDVVhzSzRjQjdUT3RWeVZheWljSCt2WWl0YURT?=
 =?utf-8?B?YThMM2tYZXR3UlRqaGRCaUhWb2o4VnlETlliVUVQQzZnR05jK0NaeHpxNlpI?=
 =?utf-8?B?d1F2djgwR3Q3MFJUOVFSejkzU0Q5dG8yUlhaMi9Fd1NYYW8reFdxUldQbzBS?=
 =?utf-8?B?V1ozMXVRa3JYZHZ5WmFSS1ltNUFFdVAvbUVBVnJwNXh6dXA1OHh5S1p3cnd2?=
 =?utf-8?B?V04xMWFEYmpyam9vb1ZFL3YyakRtQlZMbEphRjZ2U0x6L054UTNOOWxCRk9V?=
 =?utf-8?B?VHNFSnpLd0tXREMzR283QXpPNWdkS2NTTzhFS3MyM01PVE1VTERHOUdMTGZq?=
 =?utf-8?B?WmNpVzlFejIvaWY4YjhUU1VYUFJPbm56TmRCM2JOcVZybnJYM29DOUMzR0Fz?=
 =?utf-8?B?UmJGTXNUaGRaVDQzT0txeUlESHBKME5ZVVRvVjBhc2o5YnZFbjZtSnFvRW94?=
 =?utf-8?B?M3lpbk1HaWFZOEFVWm9PQVdzVklaL0s1TWlPK2xBN2JORXVKY0YxcHpSUnNE?=
 =?utf-8?B?VDRqS0Ewa054TTBUS2xrMGZObnFLZmRHS1FrNFNXcHFrYkJzL1VFNWltaDRC?=
 =?utf-8?B?ckFyZndNUGRpMzA4ZDc5Z2NObkk3QkE5VXBpekRzQVd4b1hjTmkzYW1tUWdn?=
 =?utf-8?B?UUQvczlCNllIZlJBeWJDaWdKL0FyVUh0WUNaQkpsclp2eTJGMGlzcCtkR2Z2?=
 =?utf-8?B?ZUdKdW9jVStvcjR2QlhjaXBxeC9wT0h0Q0lOdmhiT0pMNDhPZ2JBK04yMXEw?=
 =?utf-8?B?R1B4SGJkU2UwU1hONUlObmhxYzZ1bzVEMVhnKy94d2NwZnVTMEFCeUdIOFRU?=
 =?utf-8?B?T0plVGVEbzNOb2l0ZlpGaU1nVkNTZ0xibFYyUFVla3hSYjlwY1lJSzh4NmNP?=
 =?utf-8?B?WHdORXd6MlFiRVdMQjNLY0xOYy96eEplVURBd3F0K28zMFhNdzM0V1FmaXl1?=
 =?utf-8?Q?OJu0oqHgdj7V7VBgwLsOoDJs9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd3090a-fd3b-42a6-b00e-08db3f7d3632
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 19:52:01.5746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V8qy69CBcwOqSE6N1DYFtUIqDyrRXU8eVqmfTGToXFvm9SfvwLSTntV6MDH9e10vzUx3+MJ3ZfIGoY1N7+dirQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR21MB4007
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBBcHJpbCAxNywgMjAyMyAxOjUyIFBN
DQo+IFRvOiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPg0KPiBDYzogbGlu
dXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRGV4dWFu
IEN1aQ0KPiA8ZGVjdWlAbWljcm9zb2Z0LmNvbT47IEtZIFNyaW5pdmFzYW4gPGt5c0BtaWNyb3Nv
ZnQuY29tPjsgUGF1bCBSb3Nzd3VybQ0KPiA8cGF1bHJvc0BtaWNyb3NvZnQuY29tPjsgb2xhZkBh
ZXBmbGUuZGU7IHZrdXpuZXRzQHJlZGhhdC5jb207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IHdl
aS5saXVAa2VybmVsLm9yZzsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4gcGFiZW5pQHJlZGhhdC5j
b207IGxlb25Aa2VybmVsLm9yZzsgTG9uZyBMaSA8bG9uZ2xpQG1pY3Jvc29mdC5jb20+Ow0KPiBz
c2VuZ2FyQGxpbnV4Lm1pY3Jvc29mdC5jb207IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0K
PiBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgam9obi5mYXN0YWJlbmRAZ21haWwuY29tOyBicGZAdmdl
ci5rZXJuZWwub3JnOw0KPiBhc3RAa2VybmVsLm9yZzsgQWpheSBTaGFybWEgPHNoYXJtYWFqYXlA
bWljcm9zb2Z0LmNvbT47DQo+IGhhd2tAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzLG5ldC1uZXh0LCAzLzRdIG5ldDogbWFu
YTogRW5hYmxlIFJYIHBhdGggdG8gaGFuZGxlDQo+IHZhcmlvdXMgTVRVIHNpemVzDQo+IA0KPiBP
biBTYXQsIDE1IEFwciAyMDIzIDE0OjI1OjI5ICswMDAwIEhhaXlhbmcgWmhhbmcgd3JvdGU6DQo+
ID4gPiBBbGxvY2F0aW5nIGZyYWcgbGFyZ2VyIHRoYW4gYSBwYWdlIGlzIG5vdCBzYWZlLg0KPiA+
DQo+ID4gIEkgc2F3IG90aGVyIGRyaXZlcnMgZG9pbmcgdGhpcyAtIHVzZSBuYXBpX2FsbG9jX2Zy
YWcgZm9yIHNpemUgYmlnZ2VyIHRoYW4gYQ0KPiBwYWdlLg0KPiA+IEFuZCBpdCByZXR1cm5zIGNv
bXBvdW5kIHBhZ2UuIFdoeSBpdCdzIG5vdCBzYWZlPyBTaG91bGQgd2UgdXNlIG90aGVyDQo+IGFs
bG9jYXRvcg0KPiA+IHdoZW4gbmVlZCBjb21wb3VuZCBwYWdlcz8NCj4gDQo+IEkgYmVsaWV2ZSBz
by4gVGhlcmUgd2FzIGEgdGhyZWFkIGFib3V0IHRoaXMgd2l0aGluIHRoZSBsYXN0IHllYXIuDQo+
IFNvbWVvbmUgd2FzIHRyeWluZyB0byBmaXggdGhlIHBhZ2UgZnJhZyBhbGxvY2F0b3IgdG8gbm90
IGZhbGwgYmFjaw0KPiB0byBvcmRlciAwIHBhZ2VzIGluIGNhc2Ugb2YgZmFpbHVyZSBpZiByZXF1
ZXN0ZWQgc2l6ZSBpcyA+IFBBR0VfU0laRS4NCj4gQnV0IHRoZXJlIHdhcyBwdXNoIGJhY2sgYW5k
IGZvbGtzIHdlcmUgc2F5aW5nIHRoYXQgaXQncyBzaW1wbHkgbm90DQo+IGEgY2FzZSBzdXBwb3J0
ZWQgYnkgdGhlIGZyYWcgYWxsb2NhdG9yLiDwn6S377iPDQoNClRoYW5rcywgSSB3aWxsIHVzZSBv
dGhlciBhbGxvY2F0b3IgZm9yIGNvbXBvdW5kIHBhZ2VzLg0KDQo+IA0KPiA+ID4gRnJhZyBhbGxv
Y2F0b3IgZmFsbHMgYmFjayB0byBhbGxvY2F0aW5nIHNpbmdsZSBwYWdlcywgZG9lc24ndCBpdD8N
Cj4gPg0KPiA+IEFjdHVhbGx5IEkgY2hlY2tlZCBpdC4gQ29tcG91bmQgcGFnZSBpcyBzdGlsbCBy
ZXR1cm5lZCBmb3Igc2l6ZSBzbWFsbGVyIHRoYW4NCj4gUEFHRV9TSVpFLA0KPiA+IHNvIEkgdXNl
ZCBzaW5nbGUgcGFnZSBhbGxvY2F0aW9uIGZvciB0aGF0Lg0KPiANCj4gaHR0cHM6Ly9uYW0wNi5z
YWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZWxpeGly
DQo+IC5ib290bGluLmNvbSUyRmxpbnV4JTJGdjYuMy0NCj4gcmM2JTJGc291cmNlJTJGbW0lMkZw
YWdlX2FsbG9jLmMlMjNMNTcyMyZkYXRhPTA1JTdDMDElN0NoYWl5YW4NCj4gZ3olNDBtaWNyb3Nv
ZnQuY29tJTdDMDBjYTlmMTVhZTMxNGE0YWEyZWUwOGRiM2Y2Yzg2OTklN0M3MmY5ODgNCj4gYmY4
NmYxNDFhZjkxYWIyZDdjZDAxMWRiNDclN0MxJTdDMCU3QzYzODE3MzUwNzYwODcyNDY3MCU3Qw0K
PiBVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVN
eklpTENKQg0KPiBUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMwMDAlN0MlN0MlN0Mmc2Rh
dGE9ODdRcUZiV3J4VQ0KPiBCTXRxWXBDMzk3bmxReE9KZlU3bGt0MiUyRktBT0dVanpqdyUzRCZy
ZXNlcnZlZD0wDQo+IA0KPiBKdW1ibyBmcmFtZXMgc2hvdWxkIHJlYWxseSBiZSBzdXBwb3J0ZWQg
YXMgc2NhdHRlciB0cmFuc2ZlcnMsDQo+IGlmIHBvc3NpYmxlLg0KDQpPdXIgSFcgaGFzIG11Y2gg
YmlnZ2VyIG92ZXJoZWFkIGZvciBzY2F0dGVyIHRyYW5zZmVyIG9uIFJYLCBzbyBJIHVzZSBjb21w
b3VuZA0KUGFnZS4NCg0KVGhhbmtzLA0KLSBIYWl5YW5nDQo=
