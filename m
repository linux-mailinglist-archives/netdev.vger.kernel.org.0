Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74766081DF
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 00:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJUW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 18:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJUW4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 18:56:08 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020019.outbound.protection.outlook.com [52.101.51.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56B325E0A0;
        Fri, 21 Oct 2022 15:55:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnamNShl5W7Cwrbp+T121CUJ0d8sNubVTizurCL1WtcxV7OL61lmR4I03auO90svhQgFK7XgbWZgeG4O0e0BdQO9LvO1tPWjeJp/5+uAIydjYsMs3pXmB7jegBiuhOOrGLqZ7TCrJwski7DUZdIknaf0GizX9Wc99YL+jpCedWwlu3GvLUsIqJAD00drsKTPG12eHZsQ+3EQ3/2wXy8fv5li2qjjhfSgsdm0lLUoCdeDT7QrPy0850JNprNAoamEChWACHln4wXdatvuY5rYG2t2qiwuMGvs3iwZ0xA8aK6kOhFDgv9uAxwQA6EiyEOSLGtqBI2IsjMsl86rdkT0eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+Is4lSVZsFEteOtvBd3YIty6Xw0pJ1xSnPUCbyisGI=;
 b=Qzhzre57qxwCwvRA+2DrAAunvJiqhsr6aDOlAeZdOa2lT7AA6qAFmI3vb11ZxDEmXtxhQG8ULxnxSXyLpEhMLHKXW6w+FQnQUQyHdAusTXTefkNiBqCFYfblrw2G8vzDePCYMvkTJdZfps6Z+PIMhoXDfiLPir8RkK227UEncPT+K+XzS9cvM8G0LCwrqbvXL7GRsUh/antMb2ldb3hmgcDmzJX9RdX7XGRkbfUrT1ApBncr/XI+uTJaZfCC4oqvORtoIhgkbXLVIuoGwpQP6lzarBolCHtmZfxiQLVUP/TxQbIEDUXa5f9OOqItuxGsghwef/oHPL1Gf3ePSoYHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+Is4lSVZsFEteOtvBd3YIty6Xw0pJ1xSnPUCbyisGI=;
 b=Vsh2ZxnA0ndezsJ7dfZfvyYu7ElqobAm+S1KAwMZ2Oek4875d1tbW2nyutIOuZ8WFuGNoywQJiYyh74uxoAaYDhGYKY8zyerpXlGHQa1ieboHmqQRN9pR8jsWJftpi0wTX+bRq6HCYHC/t2gkYoBQYR+D/BOztWvEofETjnQ98A=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by IA1PR21MB3402.namprd21.prod.outlook.com (2603:10b6:208:3e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Fri, 21 Oct
 2022 22:55:54 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Fri, 21 Oct 2022
 22:55:53 +0000
From:   Long Li <longli@microsoft.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>, tom <tom@talpey.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5AmQQ427gtVraEOIJ5+rCERFPa4XHQ2AgACeAYCAATEdAIAAAKcAgACKjjA=
Date:   Fri, 21 Oct 2022 22:55:53 +0000
Message-ID: <PH7PR21MB3263A40A380B9D7F00F02529CE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
 <SA0PR15MB3919DE8DE2C407D8E8A07E1F992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
In-Reply-To: <SA0PR15MB3919DE8DE2C407D8E8A07E1F992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=266bb13f-4e91-409b-a8a0-a180da70baf2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-21T22:51:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|IA1PR21MB3402:EE_
x-ms-office365-filtering-correlation-id: f399286d-928d-4634-5ce8-08dab3b7686a
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZEwQox/9F56GU4R2sAhjZzV/5vP7lbFoeOOp2eKPf6B0F50cZEDS/2vPeyfvDE7ZsuVZweUQCxeTt+FU4ojKzo61+SQuTvOgra/dqMlXGaU/7wyHFHK/BlayL64biFz8bN4F+QQytfxsUN+Q9TjS5OCsTRgL7aL2MHszostRw1HtNzMqvoUzYIEZ6G5q5CdVQYOL0rrkshG4RrCu5XSqJWk6mMXDfGY9jXSCDZiXOKlEY9zHqADLKzo3k9pcnL1poXYRt54vNJwBHAc1kZTBE9HfEHh/tUWfentJ3Ul5K1C1Bu8UfKY1xuaeWvn+LdbXYK/q0jhNvbPkKfCYDvzyv4bygJd5hz+aA32TiLVcHM/10q4X2wgtx1k9ztbpPNaQ8+4fUtMaC+m7o9plMaPm4y5pnG+G/N7ozO5kS2ayCgXJiifRsbHD114ANRAySFcoVRDiiHfN4wznJRLZsSslS1bnoKYRkFhLUD49xBpDwbvwHv8AQqgOl82qBbxJW3zfsVSlisucjgyC31SStu+XP+YIA0CYHtM34i/GPBJWeKB9qs4Js1uerTaJjX+nED8SZHuEJ9K1cMJ5uIgZS6MnGPwDC1NKuwh5fkR+hV8zCXyLTlbyA2PrCZ00NsE27JZMksf6y/tkDDb6VBtvFM3PDb10Nv6KvkRtFjId8Ro1GJ02Sy6JQ7chV30G3ZM8TUo3vpeVQZHHEF70ycnxZrtEzuIv2dXclXsI3oQrrMVNhy/pGi3WQOciL5qWncWWDQDP6TiyjYB73zX+oyxDWvg1yCJHTEQ1rYPWG0/GZLBQsqwM8x4qoqTZHRkzru5aIEBqzkxrchDkYv7+XRq4pgoNwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(47530400004)(451199015)(4744005)(38100700002)(7416002)(8990500004)(33656002)(86362001)(82950400001)(41300700001)(66946007)(8936002)(82960400001)(66476007)(52536014)(66446008)(8676002)(64756008)(38070700005)(6636002)(316002)(71200400001)(54906003)(6506007)(76116006)(4326008)(921005)(26005)(122000001)(478600001)(10290500003)(7696005)(5660300002)(9686003)(186003)(55016003)(110136005)(2906002)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3dhUk5Ca0x1amQvY3RoNG0ySDVKcGdxNWtNUzM5a0h2Mm03d1R5TFA2VERy?=
 =?utf-8?B?UER2NkNSUkVLeEFxR213S2wrU0dtR014RGFlRkRvVnp4NXFPYnFSbmN0Rlls?=
 =?utf-8?B?RUovUHpuT09rTkhDVnFhcURkdHVjSmpXNk9MaDh0TERCSUU3djV1WHh2N012?=
 =?utf-8?B?V2ZscUJhanZCeTBKUnZoY3B3dnYvWGtyYXhzdFRvSXQ5VE9qUjhRVkV1Q2VI?=
 =?utf-8?B?cC9tbm44aS9uNG1ScDdZb043Zys2TkxTM3ZHd20wZ2NCcU5pTHZoS1plWnFz?=
 =?utf-8?B?UHd3bWZsRG8xbXhQdS95cW1jV3JmZlNnbDZIWncwRFV5NDNLRXpBdkx0TE5y?=
 =?utf-8?B?UHNiUjVxcDdYa29lZER0N0ZSRC9QVS9yWGZJY0dnaXNhL0NuUnJCVVlsN3VM?=
 =?utf-8?B?Q2lNcHloeSsxOHFoOUtTQXIvQnJEUFU3YnZMMUkrNHY2WmZhYUVnMTY1OTZ6?=
 =?utf-8?B?TEhvbHRpRWxUZUQ1SFhRM1lnR240N0tDTzVTclphZTcyeG12ZlM1NE4rZzh5?=
 =?utf-8?B?ejRiWm5yUTB0Z0ZYV01wSkNBdWNRTU9HTHJvWkErbUlTaUFqTkVBcGxQRzJW?=
 =?utf-8?B?dENFbm9Zc0xjZGxIdUpEUU9uTXI3YnZlSFFET2tFakZOZUY4d0FmeUcwY2oy?=
 =?utf-8?B?ZEdBbW5zcmVXZWxrYUYrYXZQNVd0TGRTZ2JnRzdLNDdGRlRsY0o4RGJ5WHpX?=
 =?utf-8?B?eTlJYnNGNTU5RjlRV1I2VGp0VlBZZmNLMUo0Ky9INlBYaE5HRmRudTVpY0xE?=
 =?utf-8?B?SW1XUUVtUy9JTERzcmJNRkxsR2JqdjI1QlZyTHlPQTltUUk4OG85QjJIVGI5?=
 =?utf-8?B?RGgwRHYxREpTQTBjRmUxT2pRSGs4UVBqc0VscmRtc1dVS3kvZDA4Wnc0VDF4?=
 =?utf-8?B?SjUyUHhqZDBUUWhpUDdhRlZTMVJzUVVlbDNpanZNc0dhTHI4MXZaM00rNzdB?=
 =?utf-8?B?WGdQSWd3N1BoenFFZENmK1BvNkdmYkVLejlWeXMxYXFLUzhOOUlYemNZc0dv?=
 =?utf-8?B?SE5hNUZHRG4yK2x5Y1hkMGc1TXl2ZkM2SnpUN2xkT2JSbTMvMjRIZDVzZUpU?=
 =?utf-8?B?Ky9NalZ6TEl0UVFoUVI5RzVwRmlRMVBBa284Wi9RS09KWEs1M3VyUGdwUWEx?=
 =?utf-8?B?R054YzU1cnU2eWZXTXgvNjdQSzA0OHdzOHRDdTA0Yk15VVYzRHVlMVpBdjdk?=
 =?utf-8?B?cW9lWnc0YUNEMHhTV0Nnc1dnQnE4RWVWTzZUZnJMZDVsNDJQQzcxWElxMllh?=
 =?utf-8?B?VllXTThRb3A5QW45RHJ6K3Q0OGQ2SUsvQWxiOUNZa1U3M1NSTXd2WlVwL1Fk?=
 =?utf-8?B?ZTJxbXpnNTFtWUJqc25YR2VwamdIWUkwak5yT1VabFNzZEphNG5LQTYvT3I0?=
 =?utf-8?B?RU9RaVNCeXJpKzV5N0F4M0lxT1F0SVhRWk9iZ2VKbXBWV3VYdmFkb2hsMS8v?=
 =?utf-8?B?cDFXdTFVYzIvQlhKNXpzZWRsTlptMGNFZkJwTjhHRU9wTUFTenVpcHpwRjdB?=
 =?utf-8?B?Q3VxM0VPT21ueEpNSjBKMTBuMVNBSjFrYVdlTzlxQ0dpdXg0MHFNYUo4RUta?=
 =?utf-8?B?UWdERytoMVZrZnpEdnJXSm9QOUFGSFk1UW0zVHNpNjNudEJOY0Y4Q1hiOEJi?=
 =?utf-8?B?cEZ2SmE5OTllam1wQlJ1ZXJZdmJRL3VGdGxYTUJDdEs5OW94OENBMHdTcnlG?=
 =?utf-8?B?UnMwM1I5YlF1T3hzaU1HQkpxZlZHQVVvYXBqeXBZaFJGVmN3Qk5LckhPYVdZ?=
 =?utf-8?B?VmdmTm1KZnhiSWJVME9VWE5SaHpFaHpCamFXZWRwYkJweTVKYmx1ZGFQU05o?=
 =?utf-8?B?aDhrZVpncVVUV09IQ1pYRWJiMXg1ZjJHdGNmYmErOVdvUTFXVkd0R2FmNFQ0?=
 =?utf-8?B?eUxSdm9kT21XWjFJbmoxa3g3R2ova0J5VHhKTjJiNnNJNk0rZWpEOU5nZzdJ?=
 =?utf-8?B?dllZZi9KTi9ENE9sRHA0M1pIcHhHZ3N2V0hSZ2svUGJyalNpZTFNbVpqbDNJ?=
 =?utf-8?B?Z3pMNElZTlBnVThjaThvRndPOXBMUWZpdk03TVFhV3JnMHQ2YUlqNG5hbXNj?=
 =?utf-8?B?YXg2TUxYSlFPSmNiRWtiVldnQVlidHlLM3R0QVdUQnArakxFa1R3dVpTOVRH?=
 =?utf-8?Q?zUUPLNRcigyYOc7ZOfGm80scI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f399286d-928d-4634-5ce8-08dab3b7686a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 22:55:53.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DsW9nma91iKiV3XE+QF4JBkPRFpvO8VqpcfvrFRB//TVzB0JrLOdKpKKmpaCpaMdcM8sJ/q7Aohaab5jCcMhLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IFRoZSB1cHBlciA4IGJpdHMgb2YgYW4gaWJfbXIgcmVtb3RlIHRva2VuIGFyZSByZXNlcnZl
ZCBmb3IgdXNlIGFzIGENCj4gPiByb3RhdGluZyBrZXksIHRoaXMgYWxsb3dzIGEgY29uc3VtZXIg
dG8gbW9yZSBzYWZlbHkgcmV1c2UgYW4gaWJfbXINCj4gPiB3aXRob3V0IGhhdmluZyB0byBvdmVy
YWxsb2NhdGUgbGFyZ2UgcmVnaW9uIHBvb2xzLg0KPiA+DQo+ID4gVG9tLg0KPiANCj4gUmlnaHQs
IG15IHBvaW50IHdhcyB0aGF0IG9uZSBjYW5ub3QgZW5jb2RlIElOVF9NQVggZGlmZmVyZW50IE1S
DQo+IGlkZW50aWZpZXJzIGludG8gMzIgLSA4ID0gMjQgYml0cy4NCj4gDQo+IEJlc3QsDQo+IEJl
cm5hcmQuDQoNClRoZSBoYXJkd2FyZSBleHBvc2VzIHRoZSBudW1iZXIgb2YgTVJzIHRoYXQgZXhj
ZWVkcyBVSU5UMzJfTUFYLg0KVGhlcmUgaXMgbm8gc29mdHdhcmUgc3RhY2sgbGltaXQgZnJvbSBo
YXJkd2FyZSBwZXJzcGVjdGl2ZS4NCg0KSW4gdGhpcyBjYXNlLCBtYXliZSBpdCdzIGEgZ29vZCBp
ZGVhIHRvIHNldCBpdCB0byAweEZGRkZGRi4gSSdtIG1ha2luZyB0aGUgY2hhbmdlLg0KDQpUaGFu
a3MsDQpMb25nDQo=
