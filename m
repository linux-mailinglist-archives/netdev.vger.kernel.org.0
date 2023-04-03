Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8AE6D45FE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjDCNmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbjDCNmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:42:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA110E5;
        Mon,  3 Apr 2023 06:42:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GljRLKNtT3a9EL4gTklbhg/NdtglF5mD24m7j7YWjb9fk+m3m8tM8k8XM5KR1+mKeN9cSk1qljSFL/gEsPU7myYoSXlzXW5X/i40lBt9dyCjZT85nX1+z0VEeIjYnDwGoDAKSm2MzOzkQMwCEhFmtr+CsDLJX+YfdEprNpoZAmWQYEYexs9UN6OFFLlOo8kz03WGWxlBLDrXl23GdA877MFZVHFOGIS/gFd7tro8mD8BIiZti2jJTkmI0wIkSkVFKdCxkg9Dupr71vdjw9HVaKSutlse2N8sbKv8Z0n8uUSlgYNppQtIEs0cPsof6RtmwxzwvWjiIVFR/qSY/BV7Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8O7C9O7AmVEOulm+gPHjnsqHPyLfI6OX1K4vD4ScnKg=;
 b=XnkJY/MsqdglOrKhsy3Y6cPlThYuJJaw3GkdrZphOAYU50PpUSwtXiORCMOqCAaM/1LQpQXE54qWHGCF8vhURv+POPJlTaEjh6K8RSTZRtogOT5LEJ1WtL7ur7ylpHBFSXiC6jdYN6I3URmbaxZGGK1srMZU2y7kDm9Qi2W1PzA0Y6wrDrBEAeAZYF18zV6a9/W6nwrgQHIo8/yOSvsihFRiK1BxB8cjOut5GSFxHibdmT5qmBlo/9QIm0dZN5GlZB86uZrNak/VnwMI6N5E5/JXDiKwS410jGScPnCOhOu4RSWalwRTmo+WuyO+plGVHokh2tmzQngurq+ciNDixA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O7C9O7AmVEOulm+gPHjnsqHPyLfI6OX1K4vD4ScnKg=;
 b=WcNFelzwRsMWt4aytPPBHDHwtIPzCgxAdTmdEYHw27hXBO0tppwWCD+l6nQpDG0UlBViX7qpa3A7dTfwbCrMLy+H82ogBWKW0oT/TRZ2+yFA21saTxadeCv3gWbFUtq18xtLCEghjuvabScaGy+UQkKTT5e9nEv5IjtukYZnftc=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 13:42:01 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6254.028; Mon, 3 Apr 2023
 13:42:01 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sean Wang <sean.wang@kernel.org>
CC:     "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "ryder.lee@mediatek.com" <ryder.lee@mediatek.com>,
        "shayne.chen@mediatek.com" <shayne.chen@mediatek.com>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Tsao, Anson" <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: RE: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Thread-Topic: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
Thread-Index: AQHZYnjQPLoBKmQf60SUwPkU6s+yCa8SZi8AgAD4g4CABj/v8A==
Date:   Mon, 3 Apr 2023 13:42:00 +0000
Message-ID: <MN0PR12MB61012EEFC07D4FAE534C1323E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230329195758.7384-1-mario.limonciello@amd.com>
 <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
 <cdf612bf-96f6-9b4e-a32c-50007892083c@amd.com>
In-Reply-To: <cdf612bf-96f6-9b4e-a32c-50007892083c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-03T13:41:59Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=9d8f2552-91a1-4619-92b8-f8d98d700911;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-03T13:41:59Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 0a82f632-be65-455d-86dc-6c94d11a1a74
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL1PR12MB5779:EE_
x-ms-office365-filtering-correlation-id: 33e954c2-00b2-4575-2824-08db344933cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7mqVgPaY7hxsBeqnZaHeK7rVfFjcx7rec4vryH6Re51RftYOPWNWfowNf3tUG7oIxAozanLOB83o95Q9NJ2RUxKXD4v9gh279eMDtqgOLKaYfGmXwFnb+iyAM4apwxvPSWl0qHq92fCzvmwLujRmRk3cK3Oey74vw7m9R4bXpiJClf5SrGJzN0axWr6SXsbnkeF0Eqzn36kI4gXL4PFkCSl4LVjGkKxumZ5OzXxvZHhFL9vuteHPTS3JCfJwCzBpIIlm/L3TR7f/3UV5WrzC53vxwohz6c1PkpIm3C5+BlIB2C6uRaSX8hlJdvUWCvJXqiku50TbaKcDaxl8xfPZd+ZHxs+pNsv70KYyGq2+jKdnbHkKA/mKSXefkJIMKLJAzN0hSwrJ9nkiendfDL4q0BmKJhq3Q84HY6LCoYzq7UdvLarYmnivu6sWvkdXS+RWnoajOOC+/Vb+5+ogEPpoHN7R6gcXRK/X9O6CP53v+hSKWziWi17xWoVfUp4CIZLk4sMjAjz5GZoKtrALmmCjvkgE8sHPGM5WadW4FzJTs4+o2vod2xnzgG+D/ezZHsXWjS7oWUYEHKB9XJpfHor+SJv0T14goPNZcWlfy076E8s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(38100700002)(5660300002)(122000001)(7416002)(83380400001)(54906003)(316002)(71200400001)(55016003)(7696005)(9686003)(478600001)(966005)(33656002)(186003)(86362001)(53546011)(6506007)(26005)(41300700001)(6916009)(8676002)(4326008)(52536014)(76116006)(8936002)(38070700005)(66476007)(66446008)(64756008)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVVsZnJhN0ZRNC9HV1hiSENjdWREemhHbW0rTUZ4ZzZ5T291ZUxFVTFxbUF6?=
 =?utf-8?B?dDExdzJ2NHZNV2pseHNiTjJkZzg4OTVucDVMOC9tY01NM3hrU3VYNDYzaXdH?=
 =?utf-8?B?THdiV1FmZm40c3hKajdBdnhRZStCRGJwNHE3dlBTWDFMVHc4MWI4L3RQY2xv?=
 =?utf-8?B?Mi8zN0RTcCtBZjArSU9MblpvZEZocmM5N0NqV0xqUGpOT0E4b2dVZnNVZ1JH?=
 =?utf-8?B?cHpuOHhMS0VWSGNIZWI1b1pBYWxmdmM2UWE2MzdWb3NWMEJJR0pSbmhsVkgv?=
 =?utf-8?B?bkNPRHpuSk1wV2tsdXhWL2N5ZjYvUDBWWFNpemxIWDZCV0xBM0N4QjR6ZmVx?=
 =?utf-8?B?cVoxK3NCZzladlhFeEZsSVhITlNrTS9Ha0pEdmRxVUdiQklRVzZHSmtldW5x?=
 =?utf-8?B?dm5Ib05KUTN5akNXbVFpMWFsRTdQSUJVVVBMNnhKN1JheTFaL3liWDY0ZHJq?=
 =?utf-8?B?eFZUU0Z6K3pCZkt3OUtJV210VDl6cjN4Y2NZZXFMdlVnMEdrdFR1enVrbXRX?=
 =?utf-8?B?OUlRM1JXeG1VRVpyRys5V0xBTUliOVVQT3JXdkZpak1sejdlZ1RrU1lSSkFH?=
 =?utf-8?B?bFVZYVRpYTNkUHllUlpXVVRNNHBST251TWZwREx3QkM3SmdnNmlHYTh1WUlE?=
 =?utf-8?B?RUJRWDFnSVkzbEZRWDRJUjZFdlBrajE0c3BaNHlEQ0pvTk9TWUNKcTY0QmlU?=
 =?utf-8?B?cXlTVHdwcmZEQUs3OVE4bzBhVzVGd1UyQS9LR0k1RktzOUhjZUFzRkFuMmFt?=
 =?utf-8?B?NUZJMGpoVk9ka05qd3pNQ1JSYlhkcXluYjdKaXNQUXVFdEJQM1UvSGkrTGFn?=
 =?utf-8?B?dEZvUFdOV2lubUgyNHNhSUY0KzAvZVRUQU1vRXFpbCsyaG5zeDZjanN5b010?=
 =?utf-8?B?TFJVeXJ5V2pldXpqUnJQdTRKMk10eXlmZldtOUFlc2FEZ2hXQXBzRVlDdFB0?=
 =?utf-8?B?aHBNWDNzL2JQZHRYTVF1OG8xaHRORVp2MzR1SFF3UVlKdDN4ZzdxSFlWMUtN?=
 =?utf-8?B?eDRoSzJZRE0yeGp2SVZsZzhPek1XU0JQSTFIMFl3Sk9VVDNzcVhFV01SaWs3?=
 =?utf-8?B?WGVTbFRIZnpWUVRwQk10L1JwQVR2cHN4Yjh4cUFkOVpwc0VvS2hNMmVnZmpR?=
 =?utf-8?B?QXYvN3dma1RoTmVuMFpFRlZYUGFNdW43QkYrYmJhWk4xVGdCSW9jc0F0RE1F?=
 =?utf-8?B?OTZoc3hUVXBKY05RS3EwNmhOQWlwUm9PQVpCSGU0K2hQZ3BtR3hFREJoNXUw?=
 =?utf-8?B?Z05pUWlZVk5GNXZ5K0ltS3NpejBlazZrMmk1cVZLNkhPby9JaTFPcTFaRUwx?=
 =?utf-8?B?aDJkejY0K0E3WE5oZE5XS1l4RE8rb1VDNkFPQmhrL2I4dVlnSHVlK2VxOTRu?=
 =?utf-8?B?VXE2ajZZbHNodnBHVzJtaHZYVW1hcFJKMk0vWktkMklVbGVRZngzdEJMbWRQ?=
 =?utf-8?B?aTgxZWtycVFHZERMWFdockZMcEpHaEhUOVIwMUx6L0MrbmpkMTFqSWZNYWJx?=
 =?utf-8?B?QmVlRHFMUEZhNm52dUQwMDJmcHpTRWVneVZQMmM2RlRjNUMzcHpNemJXNUUy?=
 =?utf-8?B?Y01TTjdlOERLRVlObjQwRWx0K3NJV2FxcjZQZUV5Szg0bi9POTJ2RU9SbVZ3?=
 =?utf-8?B?c1k5S2kyYno5UWdyZ0RoMkhNN3h5bmM0U0pHZlhCbUxpYVJQS0RIQk5kcGZU?=
 =?utf-8?B?U29NQkg0azlKVnZmc2VzeXN5SHlrWFdzY0xXYW1sbjRmS1BtbEs1VGVyZm5w?=
 =?utf-8?B?YWRCbTIzck4xRzdaa2xKWVNwZVk5YmMxeXNaTW1JUGMvWnJOYXlBUjhNRkw4?=
 =?utf-8?B?OWNTbFI3L000Vmg5L2tTeVRsVzZaWEYzUVJ4UTdkNkxRWjA2T1RKcTljZ21U?=
 =?utf-8?B?cldiaVhRZVFqOVE5eEt1M2VncTY0S2xLeHN3aVk2dEtSUzVaYjBHNit3ZWpK?=
 =?utf-8?B?UjNhL0l6VHJrWVExeXZsYk8yQS9udlF2MGhFbHhaV2Z6N0VzdG1nbzNUU0F5?=
 =?utf-8?B?WmxNSFVadUJlOGJ5eWJsZDBpWkFNMy9wZHcyR1RoUyt2ZUR0N3BMUjNiaWVk?=
 =?utf-8?B?NGJhNHd5K3h6WTQxbVNIMFpNMVhoeDZZN0lLOE54SEtmejlIa0NRd3lLaG5w?=
 =?utf-8?Q?fklA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e954c2-00b2-4575-2824-08db344933cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 13:42:00.8728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6EBeNOHRZ9jzrGvGyfSNQ/hmJRG+Y4F8IdCQL3oQfwtnZLA92qlo9pssM9siBQZeUjnqghWg6tm5j+VhuaU8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W1B1YmxpY10NCg0KPiBPbiAzLzI5LzIwMjMgMTg6MjQsIFNlYW4gV2FuZyB3cm90ZToNCj4gPiBI
aSwNCj4gPg0KPiA+IE9uIFdlZCwgTWFyIDI5LCAyMDIzIGF0IDE6MTjigK9QTSBNYXJpbyBMaW1v
bmNpZWxsbw0KPiA+IDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPiB3cm90ZToNCj4gPj4NCj4g
Pj4gV2hlbiB0aGUgQklPUyBoYXMgYmVlbiBjb25maWd1cmVkIGZvciBGYXN0IEJvb3QsIHN5c3Rl
bXMgd2l0aCBtdDc5MjFlDQo+ID4+IGhhdmUgbm9uLWZ1bmN0aW9uYWwgd2lmaS4gIFR1cm5pbmcg
b24gRmFzdCBib290IGNhdXNlZCBib3RoIGJ1cyBtYXN0ZXINCj4gPj4gZW5hYmxlIGFuZCBtZW1v
cnkgc3BhY2UgZW5hYmxlIGJpdHMgaW4gUENJX0NPTU1BTkQgbm90IHRvIGdldA0KPiBjb25maWd1
cmVkLg0KPiA+Pg0KPiA+PiBUaGUgbXQ3OTIxIGRyaXZlciBhbHJlYWR5IHNldHMgYnVzIG1hc3Rl
ciBlbmFibGUsIGJ1dCBleHBsaWNpdGx5IGNoZWNrDQo+ID4+IGFuZCBzZXQgbWVtb3J5IGFjY2Vz
cyBlbmFibGUgYXMgd2VsbCB0byBmaXggdGhpcyBwcm9ibGVtLg0KPiA+Pg0KPiA+PiBUZXN0ZWQt
Ynk6IEFuc29uIFRzYW8gPGFuc29uLnRzYW9AYW1kLmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTog
TWFyaW8gTGltb25jaWVsbG8gPG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20+DQo+ID4+IC0tLQ0K
PiA+PiBPcmlnaW5hbCBwYXRjaCB3YXMgc3VibWl0dGVkIH4zIHdlZWtzIGFnbyB3aXRoIG5vIGNv
bW1lbnRzLg0KPiA+PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzAzMTAx
NzAwMDIuMjAwLTEtDQo+IG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20vDQo+ID4+IC0tLQ0KPiA+
PiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3OTIxL3BjaS5jIHwgNiAr
KysrKysNCj4gPj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+ID4+DQo+ID4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkyMS9w
Y2kuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3OTIxL3BjaS5j
DQo+ID4+IGluZGV4IGNiNzJkZWQzNzI1Ni4uYWExYTQyN2IxNmMyIDEwMDY0NA0KPiA+PiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkyMS9wY2kuYw0KPiA+PiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkyMS9wY2kuYw0KPiA+
PiBAQCAtMjYzLDYgKzI2Myw3IEBAIHN0YXRpYyBpbnQgbXQ3OTIxX3BjaV9wcm9iZShzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwNCj4gPj4gICAgICAgICAgc3RydWN0IG10NzZfZGV2ICptZGV2Ow0KPiA+
PiAgICAgICAgICB1OCBmZWF0dXJlczsNCj4gPj4gICAgICAgICAgaW50IHJldDsNCj4gPj4gKyAg
ICAgICB1MTYgY21kOw0KPiA+Pg0KPiA+PiAgICAgICAgICByZXQgPSBwY2ltX2VuYWJsZV9kZXZp
Y2UocGRldik7DQo+ID4+ICAgICAgICAgIGlmIChyZXQpDQo+ID4+IEBAIC0yNzIsNiArMjczLDEx
IEBAIHN0YXRpYyBpbnQgbXQ3OTIxX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2Rldg0KPiAqcGRldiwN
Cj4gPj4gICAgICAgICAgaWYgKHJldCkNCj4gPj4gICAgICAgICAgICAgICAgICByZXR1cm4gcmV0
Ow0KPiA+Pg0KPiA+PiArICAgICAgIHBjaV9yZWFkX2NvbmZpZ193b3JkKHBkZXYsIFBDSV9DT01N
QU5ELCAmY21kKTsNCj4gPj4gKyAgICAgICBpZiAoIShjbWQgJiBQQ0lfQ09NTUFORF9NRU1PUlkp
KSB7DQo+ID4+ICsgICAgICAgICAgICAgICBjbWQgfD0gUENJX0NPTU1BTkRfTUVNT1JZOw0KPiA+
PiArICAgICAgICAgICAgICAgcGNpX3dyaXRlX2NvbmZpZ193b3JkKHBkZXYsIFBDSV9DT01NQU5E
LCBjbWQpOw0KPiA+PiArICAgICAgIH0NCj4gPg0KPiA+IElmIFBDSV9DT01NQU5EX01FTU9SWSBp
cyByZXF1aXJlZCBpbiBhbnkgY2lyY3Vtc3RhbmNlLCB0aGVuIHdlDQo+IGRvbid0DQo+ID4gbmVl
ZCB0byBhZGQgYSBjb25kaXRpb25hbCBjaGVjayBhbmQgT1IgaXQgd2l0aCBQQ0lfQ09NTUFORF9N
RU1PUlkuDQo+IA0KPiBHZW5lcmFsbHkgaXQgc2VlbWVkIGFkdmFudGFnZW91cyB0byBhdm9pZCBh
biBleHRyYSBQQ0kgd3JpdGUgaWYgaXQncyBub3QNCj4gbmVlZGVkLiAgRm9yIGV4YW1wbGUgdGhh
dCdzIGhvdyBidXMgbWFzdGVyaW5nIHdvcmtzIHRvbyAoc2VlDQo+IF9fcGNpX3NldF9tYXN0ZXIp
Lg0KPiANCj4gDQo+ID4gQWxzbywgSSB3aWxsIHRyeSB0aGUgcGF0Y2ggb24gYW5vdGhlciBJbnRl
bCBtYWNoaW5lIHRvIHNlZSBpZiBpdCB3b3JrZWQuDQo+IA0KPiBUaGFua3MuDQoNCkRpZCB5b3Ug
Z2V0IGEgY2hhbmNlIHRvIHRyeSB0aGlzIG9uIGFuIEludGVsIHN5c3RlbT8NCg0KPiANCj4gPg0K
PiA+ICAgICAgIFNlYW4NCj4gPg0KPiA+PiAgICAgICAgICBwY2lfc2V0X21hc3RlcihwZGV2KTsN
Cj4gPj4NCj4gPj4gICAgICAgICAgcmV0ID0gcGNpX2FsbG9jX2lycV92ZWN0b3JzKHBkZXYsIDEs
IDEsIFBDSV9JUlFfQUxMX1RZUEVTKTsNCj4gPj4gLS0NCj4gPj4gMi4zNC4xDQo+ID4+DQo=
