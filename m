Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D18C6BA133
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCNVJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCNVJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:09:47 -0400
Received: from MW2PR02CU002-vft-obe.outbound.protection.outlook.com (mail-westus2azon11013003.outbound.protection.outlook.com [52.101.49.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564B11E1EF;
        Tue, 14 Mar 2023 14:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2zoVF+wzVZc16CKxhxnENxzEMfOa+YNeJkTldS35qYR7aL573iPSKxekqr1VLW6K1nQ62e5dV00bozDp4SgtCIHulpVyWfhQO+HjMarbaENG2minwR4zPk6y7gleNAKYL6fM6nXb8DLymiaqXPvJPWVOcuPx4kR2MHXWvwSSrPjS39Bm70e0dVtekNjDiCI0HlcfFRicI7M7HtnyeocaTxW3vjllNvASKNBARKH8cjv4+iLwohK0bzObicFKQmlUmcX4Fy7YgitNTlJnIwWufZCdwI38Ui/cxnaWBiXqvdqhC7pHxvyuzyJMvKp5PxC9Jb9+pwPd7HsWmU8KUvxoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BW9aprnDKMMhRtwgMrBJau8akBbkQLv3v2nH4p1rdUE=;
 b=LfhyPGCQaHkU14a3+0khp/KIUimt3y19QPErz9GvwvLwE3QJOrMO/PgQz1gorXTBNEsFzqZmFMkvA86mUiOCQF/i6qZWITSNiicJ1QbnxijCr4kpDZ1Efy1oSYG6tLksNARBVABa2IPOuOGf47P4Vzsd87iMJaCMEYviVQka/CSBbcZM54rDhUE8+pGhK6FSC0nJSRAMimkYnNz+/kLGOH7UtPnwnljsTojuOOFSRb5BTaCUXyTekn89eFIKwIbmavfxG/4Q7asxLZCHj+OXRhE9kuwErRcR8smLF0wcJNyXFbyyvtxlAvkURnZxoaILrlwWN0/hegQ72N+WWuXg4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BW9aprnDKMMhRtwgMrBJau8akBbkQLv3v2nH4p1rdUE=;
 b=JMhATCvqh78DGfuTWajHRXAqNBQNXmfOQuN5EtBvvkz2sWSSoPc76f5QmL47ueHa1em4y3rdL7oHsMB6dA36Wc5KMCn/EBKxh/t8eWMhpsRjUZOQJIgEIs17/OfvkfP/WXbNNqOMBOqve7Wa3mASRrymc/EOWcB6vXeBm7YXPV0=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by CO6PR05MB7650.namprd05.prod.outlook.com (2603:10b6:5:34f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 21:09:20 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 21:09:19 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAA
Date:   Tue, 14 Mar 2023 21:09:19 +0000
Message-ID: <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
In-Reply-To: <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|CO6PR05MB7650:EE_
x-ms-office365-filtering-correlation-id: d1c930bb-46f0-4a70-7752-08db24d060bd
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6qjDdaV9yM4Lze3UNXYL+iqezsk0Ru5CcbqvzrjA1lCFKfVnlyaVJ+kquIiwj0hssLcH1jmwnhKvkHajdQWYu76WVXDNdZcd6N9fGIWgAWf2Cl5f0GZM3IP3O3YhYvUoIM9M7wBerhJNJWsJOUKuJZiO40FRIssTWIb4aw2P19qxY6agemNdElywbstQCp0YXRL3PEMAjhORCPPkMcN20XsJ2g91L+9Yq9XOBaLAj340Y4Cqgibbd/Zd+scMmvTXHOVnaaTX0h8bQo3Uemefmw6mcLtKnIMyhdTPceg/dJIRQsf7ri/aFsXtztW9xrpsGFoTKS2MUfXaB5kVHh4N5fxq2viPHUKOS5MgEiJOvPprNyPnzfg/e7P+JIlD90AH+URfKXAc3hhevx1kOv20JRVTkShW02PpkF28UhNlfEeuL24/fnWKfIwVibl21oRViC0ZhiHhdQ/c/1UwYYhALzazJyHDVr9eK2suxdkz3xuUijSd7AzIl8X85ixDBEan6XApL93KRb/VrfrbLRKywu+hF8By+sYGnycLyy7+wAnlPBA80hqFwGjaAH+tu7eg9hlrWPpmqxDq9tJafQ+RsUFWvxF5hffp3MUCdhR6ERmxlTbfIiXxPzzWjHX+NwLVA08s8zovhTJilkJVHoeifdYY37leMLnd1xBRGBIUm9d7YvO/EsX4Ur2TQhfe+0hg7x8UAJnGcosUE4NOLO6AAk5wdqH6O6lAaYDm3iWjSMZPm+uxrQb0C53Vu0BkyzlLDaeIGoVTxq2Hg5JswIOEeS5Hga48teW4EWzYkx96ivQmf4FvdteZ4SbLBRih+UYXfYxWohi0hdKUlSsXxR6WZ7AOep7Lli3A/zC7N5ez9RM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199018)(5660300002)(2906002)(122000001)(86362001)(36756003)(33656002)(38100700002)(38070700005)(186003)(66946007)(53546011)(6512007)(6506007)(2616005)(76116006)(45080400002)(54906003)(8936002)(41300700001)(110136005)(316002)(6486002)(71200400001)(966005)(64756008)(66446008)(66556008)(66476007)(8676002)(478600001)(4326008)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2tzcFNHQnVLSzBING1KUm03K0lDUlVkSUJJaEY3VlQ0aEhrSEpXMjFUeHBs?=
 =?utf-8?B?NldNZXhhbCtyVTJHdk9mYjV1cDRmdStZMWRVakt1QnNKV3VYa1hGRnplOFZm?=
 =?utf-8?B?dTB2OFVOaW52eURwTzRkZVAwU3hWRlpWZTBlUmZPYkNwVk5MbGx6MndsbFdj?=
 =?utf-8?B?b3pKWWlHT3VscG15Qnh3bXRHY0lIU3JxekZpVTZlbTNkUE1ONlBLNFNvRVpX?=
 =?utf-8?B?eCsxbjcyV3Zsb1Y3bHh0SWV1bmZSdjFpamt1RlJFZ3kwdHhZTGNUQjVBQ2d2?=
 =?utf-8?B?SWRiQ1V1a0V0N091Mm9xSEE1cEQwc3h1RXArZVI4dlZjckNJYURpL3A4RWtu?=
 =?utf-8?B?NXFrNEZmMjRlbjdPQVBBYkZ4TytYaGhzdXcxYzN0SGxGcGFNM1pva1F3WEJm?=
 =?utf-8?B?VEgrMG5HRUJ4QTU3L1AxajdYSEtYbG5HeURxN2xPRE9Nd0IrOEw3bWg3SGZI?=
 =?utf-8?B?bVdWUzgvOGdkSlBkMHlwbDZsb1NGSU5raGdpSkVjMDZiQ0FPdDAwOENDTVNZ?=
 =?utf-8?B?SlVrTzF1RkVDVGN3WU9LSUxwd1pFdGlEeno0aGRlWnNneVR6VjV5dWpHNy9K?=
 =?utf-8?B?UnVTQzBxam8yVzRWcTYwZ1Z1Nzd3eUJueHRaOTJXWTk1aW9lZ29hcy9KME44?=
 =?utf-8?B?RXo0Vm5zY1FQNW5VU2lBUmIwOEJvZThhSFZRR2Z4Skh5QXVBWFdwcGl3RTQz?=
 =?utf-8?B?SmtzaTN0cHdhTElzU2Z3VXRTNWxYUnR3SnM0ZmtlbGZTcGZmQlQxaTZ3em14?=
 =?utf-8?B?L3N2ajdyQ2kyN0s0d2RKbFB0cGFpZFNnTTFhMTQ5aHM5NndDQ1pVM2hiSG5s?=
 =?utf-8?B?RFhJTFRpY0lrUnJjdEV4djVzN3BMeE9DaFlXVnQ0TTJYMmtaU2had2dFUUVp?=
 =?utf-8?B?TngwNENkcHF1QnJwQk1HZDBjYjZ4V0tCSllOeFVRaVJYZGl1a1p0bzN0SlBj?=
 =?utf-8?B?QmtaclRDNlpvOVhIN3JTNjVIUGdkS3VnRndXQk9TcVRRb3VTSi9uMi9OTkg3?=
 =?utf-8?B?NTdYYWdsVytRakZINE9UODBpUkhQR1YrWUJybGF2b2RvZ2pHUWY3NEp5aWhx?=
 =?utf-8?B?aHpIbWNoLzc2Q2JOWTI5bXZnbWhXc0tIM0tPVFVCdUZaTk1yajBaMnN3enRZ?=
 =?utf-8?B?cFJWY3ZpckJTQmtncTlhVktoRUJWVlZaY2VYMWljd0JNdlJ4U2I2RTFvVC96?=
 =?utf-8?B?NEVlOW5oaUs1ZGdpOUtWMmZGa0NHZUVwdGs4WWlvOFg1QkFib1k5TlRpUjl2?=
 =?utf-8?B?bzk2Q3I0WU9PZEg2Ry9kQXVBS2dEb3dOSHg2QjREUGNtTkY3WmgvZEMxSnVO?=
 =?utf-8?B?YVBCYTBoS0FyM3VsUEJTS2QyalRvT3BkQVphOFhyNkJCZmdVMDZiK2FJK2xO?=
 =?utf-8?B?bUxiOTgwMUZiK3hkMm02N1NKL1pEendheFhYMkk2bTRiMVJGK0h3N2NQcVA4?=
 =?utf-8?B?RzVEak1semZPZis1aEhBc0FDanBRT2tSdXU3UWN2UHVmWkFFOVcyOHVYQkp5?=
 =?utf-8?B?RlhtVmJOZWlvMkpEdkdKQkVPdTljZm1ZT3F5N0pwVzQzSmdORXRHWGtzWG9X?=
 =?utf-8?B?YlB5dGlpQ0taMndIc2g0YjVJYlpMYWpFMzgzK1BjOHdLa01vVHhadFZOdk40?=
 =?utf-8?B?WTFKd0lUN2t4NXR5aDlLU1hCcCtzQnU4N3A2UVdoVzgzdVFQR29UU0Nmcldo?=
 =?utf-8?B?OEUvSis4S3BONnFYUEhta3FQazFGbTRJZFBXKzNnNDRwQ2RDN1RxSU5mMm1t?=
 =?utf-8?B?anJBcmpaUFhIZldSZ3dTK0JWMmFmQVFXMGM0L2xSUEk2Q25EeEkvWEVxQk9H?=
 =?utf-8?B?MVNrUmJJZ1hTNEptMTVFZUR5WG0rL3RDbDU0TDJiN0VpTURvV0pScnRUbzZU?=
 =?utf-8?B?ZXpMUlZ5cUxCT2x5dmE4WnNkTnNyR2RZLzNjR095akZlblJteVkzbzRsRjJ5?=
 =?utf-8?B?YWp1S04va2ZKUXhwRDdqaDJwY2gvV2xsb2x1QXZkVVAyZnlPcFV2OTJ4a1Y0?=
 =?utf-8?B?Q0pJVEdmNWZYQVMwc3RMTmtvSE53bE9NTHJJR0NiTGFETXNEMFdyRkduZHJK?=
 =?utf-8?B?dTVMUGZwem8vRDhKL21KMHBMZkRzbXlIT3JKWVozcEFpZHQ5WXJZbTREZ25K?=
 =?utf-8?B?Wk93cGNJVTR1YXJvbi9TNkQvVjNGUzdhREFLdTE0OXBLNmpaOEZMWWdra3hh?=
 =?utf-8?Q?1S8+mt8vqpu0ojERmfzRMmLtubqO61HXKbrzyVm67Sf2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E87C16DB18485F42B0F130AA4040EA58@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c930bb-46f0-4a70-7752-08db24d060bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 21:09:19.7415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iOuq9UPYNI/LhAjEVsPKoLGQCoQOySXZRwVp6lI7EsJgcW6bOGqcybhNW5hBnPG4S5Ne2FzOBpgm0o+ujzU8dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR05MB7650
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu78+IE9uIDMvOS8yMywgNTowMiBQTSwgIll1bnNoZW5nIExpbiIgPGxpbnl1bnNoZW5nQGh1
YXdlaS5jb20gPG1haWx0bzpsaW55dW5zaGVuZ0BodWF3ZWkuY29tPj4gd3JvdGU6DQo+DQo+IFNv
IGl0IGlzIGEgcnVuIHRpbWUgdGhpbmc/IFdoYXQgaGFwcGVucyBpZiBzb21lIExSTydlZCBwYWNr
ZXQgaXMgcHV0IGluIHRoZSByeCBxdWV1ZSwNCj4gYW5kIHRoZSB0aGUgdm5pYyBzd2l0Y2hlcyB0
aGUgbW9kZSB0byBVUFQsIGlzIGl0IG9rIGZvciB0aG9zZSBMUk8nZWQgcGFja2V0cyB0byBnbyB0
aHJvdWdoDQo+IHRoZSBzb2Z0d2FyZSBHU08gcHJvY2Vzc2luZz8NClllcywgaXQgc2hvdWxkIGJl
IGZpbmUuDQoNCj4gSWYgeWVzLCB3aHkgbm90IGp1c3QgY2FsbCBuYXBpX2dyb19yZWNlaXZlKCkg
Zm9yIExSTyBjYXNlIHRvbz8NCj4NCldlIGhhZCBkb25lIHBlcmYgbWVhc3VyZW1lbnRzIGluIHRo
ZSBwYXN0IGFuZCBpdCB0dXJuZWQgb3V0IHRoaXMgcmVzdWx0cyBpbiBwZXJmIHBlbmFsdHkuDQpT
ZWUgaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wcm9qZWN0L25ldGRldi9wYXRjaC8xMzA4
OTQ3NjA1LTQzMDAtMS1naXQtc2VuZC1lbWFpbC1qZXNzZUBuaWNpcmEuY29tLw0KDQpJbiBmYWN0
LCBpbnRlcm5hbGx5IHJlY2VudGx5IHdlIGRpZCBzb21lIHBlcmYgbWVhc3VyZW1lbnRzIG9uIFJI
RUwgOS4wLCBhbmQgaXQgc3RpbGwgc2hvd2VkIHNvbWUgcGVuYWx0eS4NCg0KPiBMb29raW5nIGNs
b3NlciwgaXQgc2VlbXMgdm5pYyBpcyBpbXBsZW1lbnRpbmcgaHcgR1JPIGZyb20gZHJpdmVyJyB2
aWV3LCBhcyB0aGUgZHJpdmVyIGlzDQo+IHNldHRpbmcgc2tiX3NoaW5mbyhza2IpLT5nc29fKiBh
Y2NvcmRpbmdseToNCj4NCj4NCj4gaHR0cHM6Ly9uYW0wNC5zYWZlbGlua3MucHJvdGVjdGlvbi5v
dXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZWxpeGlyLmJvb3RsaW4uY29tJTJGbGludXgl
MkZsYXRlc3QlMkZzb3VyY2UlMkZkcml2ZXJzJTJGbmV0JTJGdm14bmV0MyUyRnZteG5ldDNfZHJ2
LmMlMjNMMTY2NSZkYXRhPTA1JTdDMDElN0Nkb3NoaXIlNDB2bXdhcmUuY29tJTdDNjhlNGIzZGJk
N2Q5NDg4ODdmMDgwOGRiMjEwMzFlMmMlPjdDYjM5MTM4Y2EzY2VlNGI0YWE0ZDZjZDgzZDlkZDYy
ZjAlN0MwJTdDMCU3QzYzODE0MDA2OTU2NTQ0OTA1NCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhl
eUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZD
STZNbjAlM0QlN0MzMDAwJTdDJTdDJTdDJnNkYXRhPUxBdzZvQ0cyTWdZSDRUUFFBbldVeTI1RTJ1
JTJGRE1TVzJhU0o3T1kyJTJGT3U4JTNEJnJlc2VydmVkPTAgPGh0dHBzOi8vbmFtMDQuc2FmZWxp
bmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmVsaXhpci5ib290
bGluLmNvbSUyRmxpbnV4JTJGbGF0ZXN0JTJGc291cmNlJTJGZHJpdmVycyUyRm5ldCUyRnZteG5l
dDMlMkZ2bXhuZXQzX2Rydi5jJTIzTDE2NjUmYW1wO2RhdGE9MDUlN0MwMSU3Q2Rvc2hpciU0MHZt
d2FyZS5jb20lN0M2OGU0YjNkYmQ3ZDk0ODg4N2YwODA4ZGIyMTAzMWUyYyU3Q2IzOTEzOGNhM2Nl
ZTRiNGFhNGQ2Y2Q4M2Q5ZGQ2MmYwJTdDMCU3QzAlN0M2MzgxNDAwNjk1NjU0NDkwNTQlN0NVbmtu
b3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENK
QlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9TEF3
Nm9DRzJNZ1lINFRQUUFuV1V5MjVFMnUlMkZETVNXMmFTSjdPWTIlMkZPdTglM0QmYW1wO3Jlc2Vy
dmVkPTA+DQo+DQo+DQo+IEluIHRoYXQgY2FzZSwgeW91IG1heSBjYWxsIG5hcGlfZ3JvX3JlY2Vp
dmUoKSBmb3IgdGhvc2UgR1JPJ2VkIHNrYiB0b28sIHNlZToNCj4NCg0KSSBzZWUuIFNlZW1zIHRo
aXMgZ290IGFkZGVkIHJlY2VudGx5LiBUaGlzIHdpbGwgbmVlZCByZS1ldmFsdWF0aW9uIGJ5IHRo
ZSB0ZWFtIGJhc2VkIG9uIFRvVCBMaW51eC4NCkJ1dCB0aGlzIGNhbiBiZSBkb25lIGluIG5lYXIg
ZnV0dXJlIGFuZCBhcyB0aGlzIG1pZ2h0IHRha2UgdGltZSwgZm9yIG5vdyB0aGlzIHBhdGNoIHNo
b3VsZCBiZSBhcHBsaWVkIGFzDQpVUFQgcGF0Y2hlcyBhcmUgYWxyZWFkeSB1cC1zdHJlYW1lZC4N
Cg0KVGhhbmtzLCANClJvbmFrIA0KDQoNCg==
