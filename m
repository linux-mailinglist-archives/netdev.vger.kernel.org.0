Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9865876D7
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 07:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiHBFm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 01:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHBFm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 01:42:26 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33A541D0F;
        Mon,  1 Aug 2022 22:42:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PikBb6Vbe+nMZ4OAGxh1SkV4DV9NiWlNxo0lSX01hl2uuSn8N8LweaMrTNJtheC5iGsuOwsFUTyzqIDzil/uojYZn6l71+ebFKGYvYqoDVRPQ9i8h1jVe+/1GtsmEMDWChSXjhOdSyNiErET2u6gFlp+7Sg6u94wqXcL9HnsYKWmqVl5TA0RP8U0Pso14PectTYpWEMnGjZXfnw2iCJxAEHTzu5wGeceBrfBmxlLf7+tc9uIr6M0+Uh7ovilkAgJRZ+jftP5bHib94mebj3F6587stKgSE7Ie1wcnOVN7J6vkJY/f2vWDN7IIXHVIWkpgNUQjXl8aUu1ACxRd11P/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwjNnhwIpH/RQOBK1rxGwe8JSsiosp0gnGYjKCFjeYM=;
 b=iAD2AfF86M1qbXW+1qPbmKLsPcLbGdz4Ec+VnAWmDZktUhzd+XIfUy1f7ygqKj/d8OmP9Zmnkf0ugoXFlMd/P3omOQ5G4vjTAostLwLYP8sXWNoFm6bNJzo7B6YV4ws/kFhzW9iN4Yv2pdUgXUPKrjH/k3Y2NviCSp56nrvYLGsTHdsJ26PodLF3cXPXJa8jRPJBS4TX/gj5kMf2dtIBd8HaX4j1eGlyKuRgTcCJVQSvS57TkG+5RjAKjYASQrZdD44KWbTu57B1ECrmfi9h/Ir5M63sA1S1YMCmHpqC82eiqiMUNWslwzIdqrSY9NxkQ9QuGTGukNMw8EPDrO4zDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwjNnhwIpH/RQOBK1rxGwe8JSsiosp0gnGYjKCFjeYM=;
 b=FICnso1DOEah08h0Y7DGFJKjIWdQ+iWpilqgqgzlY3DO8tYHUBod0aejf9sjc9GmD5Yy3WueFSb70E8FqemOKCtJZOXQyXL5ZECCRTsgTylAjCzL+StS8gTyD+bM28ZzNWyWl+v87kEbylQaJaPQ2QflZ0GDSZnKZB2LNOtbx7g=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by BYAPR21MB1334.namprd21.prod.outlook.com (2603:10b6:a03:115::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.3; Tue, 2 Aug
 2022 05:42:23 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::cc4e:56fd:18c1:5059]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::cc4e:56fd:18c1:5059%6]) with mapi id 15.20.5504.014; Tue, 2 Aug 2022
 05:42:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: RE: [RFC PATCH v2 6/9] hv_sock: disable SO_RCVLOWAT support
Thread-Topic: [RFC PATCH v2 6/9] hv_sock: disable SO_RCVLOWAT support
Thread-Index: AQHYn/2PdDRRTeWJ4EqSAxbUzqz6wq2bJPaQ
Date:   Tue, 2 Aug 2022 05:42:22 +0000
Message-ID: <SA1PR21MB1335DDBD5034FE07B0D609A9BF9D9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <6ee85279-df24-7de1-d62d-7a8249fc8fc3@sberdevices.ru>
In-Reply-To: <6ee85279-df24-7de1-d62d-7a8249fc8fc3@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3f5ca8f-4847-44a6-a807-8d17f3a6a605;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-08-02T05:41:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 337d6a14-260a-414d-6ccb-08da7449c5e9
x-ms-traffictypediagnostic: BYAPR21MB1334:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X9xtO69wmtebnHJDkGF7GpWUlHOSUYKO8KZoUUC2euA5BiObRgSkL6PgGL7pQSnJSMVES+O+pngbasAkQAOrFTWdes3I+RwpEtF/mby9jf7/d4WDH85JqQmRtDJw6R/+7/cpxggYKJZRo5F2YbLWWt1ULzsqeIgdRCpeeMpWzOrlLezFkqBpBWpZDzRwL2VXH/Hf0Al4riL9ko77Aei6TWzWDoJJV14FEcEJSJgGwjboyHiwzW7WE3r3ZsgvOM8sfQ/jke3EFsIm5J86OCDbPZNYhsy3G4CUU9uwCtyZfxTn86dhJCnXeTCSh8DeIBqMYaZejyCXkfbpOiKC5R26JiHxcq3vo7TDaBs9shbTxUP/bqT9N1zQ3ByAJt/9b/nHIiPZl/cxSaXLJiGz7v/PkUm/J7a9MEQoGxG37tXyhsc5DmoR9axCfg82n2zwxhwpHSYNcFAlMImokEXdDRXldIt08cokeNUjQkylX58luDti57fM3J1uBrKvl3ujBlcRM7rkIzziQ1RQCpNoYlIH0Mace4R482mUVh1orZbQ/ejLuenX7AnvLKdNN1Dbs8WC6aUhooRuxuV1ujfMf3j9vqIXmdhFGhujyW+ACI+3igK3qoZhOhiwKFlC2t8oFkuG5y6QIglXN5AOt99395tElmT5cemo6tmVge/afJCy45Jxg8F1W8y9Z3+w89NhLE3/pjl5q4n0ZWDojoKJWboioPDTpP8hWd9HNnUOw3jgp35zywB26glAqSVqHJ3XHtTFXBorcf9UcTS1/vA+qPlGv54lVy5pt4XQr/3ucKQsBNX3lqFjC+QXkQJEYSAVEAQZy5CHbP0nfhuBYHJPmU7aMI9OqObWV8derv2AqjnqiRdDTzpy0aohApTVLUbvY74m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199009)(53546011)(26005)(8990500004)(7696005)(6506007)(41300700001)(83380400001)(9686003)(2906002)(38100700002)(55016003)(4744005)(122000001)(38070700005)(66556008)(5660300002)(33656002)(82960400001)(82950400001)(8676002)(64756008)(66446008)(66476007)(66946007)(76116006)(8936002)(54906003)(52536014)(110136005)(921005)(7416002)(478600001)(10290500003)(186003)(71200400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bENNbmt6bTQ4bzNjTG5odURpT3pUVlViMzZUTXdVWjNKWkFJTk42V1hjZWxo?=
 =?utf-8?B?a0JMN3NXM21GTWt2eHBzZFV1STFXb3hFTzFSUHEzcUNjWUJlL0dSY1FxRnFD?=
 =?utf-8?B?UXhwa0NacUpiYTRHYkQrSGNmMmRHcjNXcEVmYjZHVTZ4WDFqYWQ1NFVHeGY4?=
 =?utf-8?B?MGYzU3QzTUdGbU52c1F3d0NxTG45eTlkWXJmTDhJYk4yMDI3N0kybzFOb0pW?=
 =?utf-8?B?ZUdBaWZTR2d5REx1a3lZMUdxRmJUY0RsVHV5aktyaGczUDEzMjZ0bnRlTGRH?=
 =?utf-8?B?c1lDb3BnKzlTdzg2SWp4SktEdE5STzJzMlVQZlh4VmdoVFpoK2xiNWVJNVNB?=
 =?utf-8?B?cWdtQjQrL056RjZpM1lhdUdCVk5GNUxlWGs0dmVmR3VmendOb0ZjN2VmdExR?=
 =?utf-8?B?aXpwR3RoaU1nU1lFNC8wOHBTM01UUVhBcjhaY2EvSjBwM2o1eXdKN0JaMjJF?=
 =?utf-8?B?dHVFK3ZDSHpOOVZuL2MxRjM2QVROYkpmZjJ2b3BXN0g0ZTIrODB1T21vTjl3?=
 =?utf-8?B?aW8wU2pBWjdwcmY0Uy8rSzVKYldnV1hrQWJSSzQzQklaL3FWblNRcU9PVFF4?=
 =?utf-8?B?VDROcFBsN0J1OWQreTUwUnh0dHdpMHE2RHZJSFNYNXVpZ1BURldzYWdCaDVT?=
 =?utf-8?B?Zk1ReTZjZy9BNWVvM2lxSVgxd2Z0eU40ZitkZ2JwZDY2T081eVA4TzlhNXdC?=
 =?utf-8?B?dHdETENQUTM0a3RQSW9KQXBSc1QzS1pVMm94Y2RjRlhkMkFaZVdwSzY4OVB4?=
 =?utf-8?B?NjRyOTEwY2hHZUd1SEhzcnRhQUt1T0lQVDJEeDQzSGthbGtPR1kxSjR1bTAr?=
 =?utf-8?B?OFZBbjkvbEdoaUFubXdqMFV6SWhIK1pWWk5xZlljV2c0bk1WeDFJVldUYUUx?=
 =?utf-8?B?S2ZGZVgyWmU0QUNJNFc4a2ozc082ejgrb21DaWM4QWpXdVRiSXJ3RWM5UFMx?=
 =?utf-8?B?T3pYUUg5bkt5VVl0RnhnL1k4QXRFRnY2ekhpbVd6U2dzazhwYjA0Q3JKNld3?=
 =?utf-8?B?UXphNldqNllQckJVQ3dUVHllSk9xS3hLNnBub3lYUGlobHlMSmJuT01IMHdY?=
 =?utf-8?B?ZmUreG10SnV4cE51QThJalFRSjBTWU1pL3VKZ2dPTXh4L2QyYlB0ZDJaNHph?=
 =?utf-8?B?VjlkSjN0b054OFRCYm9yNG5NMmpQNlRwZy9DTS8yOVVEVVFLM0V2cjNNajJp?=
 =?utf-8?B?Z2RjbXB6TlRyTVFNTkkxNDk2MUZ2SEJRT1ZvaGRHQy9sR0lHR2NBRkJUMGsv?=
 =?utf-8?B?cTFCQXdtQmd2VVBMRHdqUFdVUDY1c0pMbDBpeGJaa0doblo4dVV3dTNkOWtW?=
 =?utf-8?B?SGIzY2w4VFpJcm52UDdXNVBVZ3J0NEMyQ1RWMXRBR09haXlnUnNlSTVSdHFI?=
 =?utf-8?B?YjRNK1dHeTYxOS83L0Zjd1NWamt2T2pUZ3lYYmh3YUN4K2hwaTBya0NuN0ZN?=
 =?utf-8?B?VzJMZ2VtUWVwSTBmcFoyeW9iWUU1eU9HMU90SGtKdXBnNXFWYXh6NDZ2YThp?=
 =?utf-8?B?a2FITFRwQ1B5NXFGdVZ6aEZsa2RTaTFDbTRhd2ZDZ3AvSXVVK2cvOG01M01t?=
 =?utf-8?B?ak14ZThVVklpdlFCZHZqd3VMbmFXSDJ6cWFSTE56WWVYWlF5VG5HN2hJMVhW?=
 =?utf-8?B?RVp0alFEUmVUbzBVaHdUSTZLZnZYaUQ4ajk3dzRKOUdKQWlNcTBIbmpGeFd5?=
 =?utf-8?B?ZFU0RXhpb2pGR3MrUVZFMmtBZkJmVVA4b2lRdFNjT3pkVWZMUWFmNUorbzlk?=
 =?utf-8?B?UEd3ajFtUlNsbFlER3FHOTZuODEyYXNiMFpKQnFEWldBVnpEemtsdm1SaFdv?=
 =?utf-8?B?L3puL2FCMVp6aXFBdVgrRG5weHkySnVBS0o1QjUvK2tsNU1hWUJUL0owN0xu?=
 =?utf-8?B?VGRVUVdxZzlNTkxFbm9Ja0xPenRtWEZLV0xTTUtFM2ZudGRyU0p0Z3RQY29v?=
 =?utf-8?B?RWlZQlByMUQxU2g2R2tmU0doRXZmM25vMXpyUTNWUXhreTJoczlMazVQTDBE?=
 =?utf-8?B?WUZwQk9SaVhydjlPNVZUaDIvMFl0Y3lJQWtIemI1ZWNoOW5VbkNlNlZBS0xX?=
 =?utf-8?B?eFl6eTllRXhJN3lxcGVGZDFuUEJGYnBkK012ZzlVZ1JnVGFPQTBlcXhCSk1q?=
 =?utf-8?Q?Bom3hH+RwznxMFAIi0yM5Lb0+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337d6a14-260a-414d-6ccb-08da7449c5e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 05:42:22.7553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vIKqcc4OUwdiLpuOisWYHCGWThchgwoUa4VmYNrnUs6Mu0v7T/W68EUP3fAmfUnpYk/Uidd/XBU1hmJUMH2LIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1334
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCj4gU2Vu
dDogTW9uZGF5LCBKdWx5IDI1LCAyMDIyIDE6MDcgQU0NCj4gLi4uDQo+IFN1YmplY3Q6IFtSRkMg
UEFUQ0ggdjIgNi85XSBodl9zb2NrOiBkaXNhYmxlIFNPX1JDVkxPV0FUIHN1cHBvcnQNCj4gDQo+
IEZvciBIeXBlci1WIGl0IGlzIHF1aWV0IGRpZmZpY3VsdCB0byBzdXBwb3J0IHRoaXMgc29ja2V0
IG9wdGlvbixkdWUgdG8NCj4gdHJhbnNwb3J0IGludGVybmFscywgc28gZGlzYWJsZSBpdC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2Vz
LnJ1Pg0KDQpUaGFua3MsIEFyc2VuaXkhIFRoaXMgbG9va3MgZ29vZCB0byBtZS4NCg0KUmV2aWV3
ZWQtYnk6IERleHVhbiBDdWkgPGRlY3VpQG1pY3Jvc29mdC5jb20+DQoNCg0K
