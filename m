Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E975167C7B6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 10:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbjAZJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 04:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZJrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 04:47:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C44C17B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 01:47:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqKUmJsNUL5xZt4yfJu9Tm9El/4gikM4YlHE3sQQODO1f6NyDwWfyC9fEhkgr6vTVp/A1PL2UKFgcnvp+TCbdb+6O0nu/sjt9mj5hMqejofmHNaPKMOVzQoY3bADdaMaVl8vGgPh44rSrhKwkGT81WAYYzVSfBJ5zmiji+CTW4kUaBpPgnbm08YuLDMnKRT8i5iLcbcX5FZxchRkESVisUZM1Ag/vf5IhxlPVs1iqJMID784GCMOIEfCnA7dtUfhw/cZ/mOrKno2ePPyEotXdz9m3FHzJsjC4InkM6kIMS1zZubFOufsMhTxIK3rENbT9K96TbKGX2+aKw3aD7xJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/qLPNl9eBay1FBG1/2vIcyHaU+TL5gkSrZ9ml/OSzQ=;
 b=YrMajXHwfrnHw/XZ5MJ91MuhqfvkIsF+01OucjvvGe2oTE05rY+FqNSurzyArdBKdD/9I4n1MS8mFd9IQPWiqIadKacWcWikMOdoZTh3NCaNCvii0RfHGNXR/X3vmW/bNvLWIySeZnCs9J7/nDfpl4uvmG6EPg/18A5gXFfSus7TDMdcaD9NXlBB4keHHVgd6UeAlhN4gDF82NJtC/fHhk2oQ2lIW/zEaax2/hYCIemDTWj56PTElq+3pig9kqJSWfyKXFLz4yEcmUQ4KLsvLcdN9MEWY1IZmkS3oGB45SkcdiYZcFVeV7yJBneuSSLfQBshgQPwSdIMeRsjRAyljg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/qLPNl9eBay1FBG1/2vIcyHaU+TL5gkSrZ9ml/OSzQ=;
 b=jaTlIvLWR/lHUHC5bUiz0D8co1vd53Y4EMSg3qhW3t4jUk4YQ+OK/CSfvTo/8OFFXmEblhvCwx4WZ3S7nSL+hBDbC9w3SbAyE0lbFTpqd1ULoT0FSmQ3kPHhO0gNKvB7kir0w/HNU3C9UmcGQk4bvf0cFK7TWDniQ1y7Co4UtIIejapI/GPYvRyeoDmlwqoV5NUke82RrWDPOOZQg+uie1Wr+/r5jtH3Hl30w845kGVA6txeCiN0TaHQTF5od3LF/tmSTEJiQjHBUhkCCL6F0WMNSSYED2DUmkJ+a42ZUb97FjyhIerDMhBTD6Rf06rMLm31Me5LXXcPua89W5QZqg==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 09:47:30 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::5a75:6949:e897:bf85]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::5a75:6949:e897:bf85%5]) with mapi id 15.20.6002.024; Thu, 26 Jan 2023
 09:47:30 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Aurelien Aptel <aaptel@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>
Subject: RE: [PATCH v9 01/25] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v9 01/25] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHZKolphh+eXtwjPESkoIPQ0zMX2q6nBAAAgAf0J4A=
Date:   Thu, 26 Jan 2023 09:47:30 +0000
Message-ID: <DM6PR12MB3564D7C8E60D51464F00A5F1BCCF9@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
         <20230117153535.1945554-2-aaptel@nvidia.com>
 <e279ebf025b62b8ce8878d16d1a77afb2e59ca7e.camel@redhat.com>
In-Reply-To: <e279ebf025b62b8ce8878d16d1a77afb2e59ca7e.camel@redhat.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|CH0PR12MB5027:EE_
x-ms-office365-filtering-correlation-id: 2fc9cdaa-389a-4f2c-1c28-08daff825765
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDfygdalyJVaE+4SdY0f/+7p92MOqUM0TpPqH5Qg3ZV62Rbza8NjLL8BEZqvpd2HtpSTtsRA9YPsnHUnC0ZybV/D18cPxYeBT5oqQXsyeYRjkv2FpC+xVZc8fgpEBl1cEPPr3UiTBIGx5gNXliaUHSo+QgSaGfexR/ZOFLNnAEqdawPDB3LoxI8BlfyMV4aqgt+LjMdStVcQEXvrt3zIRleQ8sBpTArlqSeIsuGBKB6uCpFPqewOZgDuBTFt2YlMNNvPHJV0UaVovSwFWM/OG5r6aCndU7lkXh0CDy7qkME8Am++s/GPShhQzVA1kt+xXFwgI/hWyLXFO2wT/TVlJqgcCpilahUOy/iGHagp+Ziv4CCG10p+POBM2ZHbQ9f3zvPwEKKc+gwNWyF72jehJIpXpbqmW3u0M7jt6dqPwZYqnUiScwPySWJj2T6jQEpyinQIdJTpFIEf4wL7tINDt/66rSEzhuRaXz4OXHZ0qUi2WhAqjCaC+0rapmgN1ZxnZeuJ2F5ZCTURBrriukTygdnN52NAbZGHo70LrPBqaiVhru8w5UFALFgF1dwTG/odhICQEFuCGJCJJFl1OQ+x+s8wf2rso1g69GqoUl7jfaw4tHTEa6XvvMzJtI94pCdLxwKVJxcQmd9KDzOOO+ywO6sDU3DwQlJf9l2acQs7M9gUuzpM9sX3A7ehRSckITLsawB3FWMUdb7IBg/rCU5QWfV6L9Jwxo+MBplGi61OLHw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(38070700005)(38100700002)(921005)(122000001)(2906002)(478600001)(71200400001)(110136005)(316002)(54906003)(8936002)(41300700001)(33656002)(7696005)(55016003)(86362001)(83380400001)(9686003)(186003)(26005)(6506007)(107886003)(4326008)(76116006)(66946007)(7416002)(5660300002)(52536014)(8676002)(64756008)(66556008)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NW5xcXAxTGQvVnRyc0o3bTd6RDdPWjBIZ3pNZkZwMlN5cEMrbVBOZEdpTDlD?=
 =?utf-8?B?aHRZUm5sbTdZMHJ3TFkxN0MwbDJxMlBPSTg3c1gxQXFqRHlFcnVHUFVVaE5E?=
 =?utf-8?B?WXBSTDUwSHFwd3NjY3JLTm11SmErRDdQMGdiVWRQRHEyUnFUM1lhd0o0cWJr?=
 =?utf-8?B?cXNiMnNkMkNjcndBaGI2TW5ZazNUNU9FY0ZMUkR1bThLREhrZHFjQVhpMFEr?=
 =?utf-8?B?dHBFb3liUjZUZkFrZGI1UVBEMEZveDE1WG80QUZiMVhtTzErdkxXR3czRnhP?=
 =?utf-8?B?elpwZFFheG1ENjAvY2Y5a2JiZmtpUk5EMGpFakF3TjJKR29hYThOellXTmVK?=
 =?utf-8?B?ODN1RVpzN3c4d3JnNS90b2hEbzBRdjgraDUwYTNCRW9MUDQ0bUhWY2JpUzB1?=
 =?utf-8?B?V3VPZVdEM1VSclE1M3E2aFNsd2RzY2lOb1hLeitJNnp3RkNHM2ZEMHluTFVp?=
 =?utf-8?B?TjFiS0xxVWpQdnVKM3YrOXhYQlZzcXZnN2RvaERZcTV0UnRhRzEvdCtIRWVi?=
 =?utf-8?B?SXhTVVJnbktoT2Iyd3E4VHFrcmJrdnUvbWZKeUVvWVRyT0xOZXQ0ZnllY3B4?=
 =?utf-8?B?djJQWUJBeVQ1UWVEZ2VaWDVnRGhoU0ZDazhZc0FNQmJBZFJLZXJGUnlrV3Z5?=
 =?utf-8?B?aVVkalRYNFo5ckptZ0liNFJtMG9hNDUwaldwaHpneUhGZlUxSkM2TERZeU1u?=
 =?utf-8?B?UWhtbmtMWnUvUnppUHFaMDBhMEZ5U21WbnZaNVpET25MelNUOU1HciszUHFV?=
 =?utf-8?B?NE9pS3dvZVVBR013NVFwQmVzZzlWSXRrdm9sRTZ4UTZZck1QaVZRYy9Ncis4?=
 =?utf-8?B?cDRaUDFFZlRncklQWkd2YmFZbzkyWERnemFEWWRxV3ZwR0tMQnpTVDM1R0ly?=
 =?utf-8?B?amFGcGVSWEVpRDdiMWR4a29ORzRMUGFObW9LTXNJblVBdTJURHZSUXFuenJ2?=
 =?utf-8?B?R2IvWHp4Sk1VTi92bktTUjdXQWRkUmt1dFhHYXVRdHMvRVluSVBHVER1cGZD?=
 =?utf-8?B?OW5rYStjcFlCK210RlNvT2pMb0l4U2FYNzRZbitxVHkxR3MxUUlodGFQOG4y?=
 =?utf-8?B?YnZ5NWZiTFNQZFprdWdNQWt5eThUNkhrTXlqL2l0R244eklFNThSRWtiNGFG?=
 =?utf-8?B?QkdQNTRlbU96aUdHL2RSVW5SNjljM0RtNkprektSZ213ekI1QW5xc3RJNEZl?=
 =?utf-8?B?aHEySUNUeDFSVUFNNExDWXZidkxTMlFjS2Vpd0tlZVB1UzlVM01EWS9FNytx?=
 =?utf-8?B?dVgzZXdmbkhYeUhLd0ZXYU1qUWNnNTFxUTc4U20yamRFTzZzZG1JR0I5eGZo?=
 =?utf-8?B?Z1RWR0dpZnJGMkdsV1pTdmVYNXhWbGlpMGZHMnF4K3dMTlcrQmV5TmZkaUds?=
 =?utf-8?B?T1puRzd4bXdJUVhjcFkrUzhaOFFQNXFGRTJJMC9NMVdJOGk3M2RtRVlMWS9l?=
 =?utf-8?B?ZDk4R2RCTHQrRkh5OUE0b2JOLy9OWTE4KzRFRGRVcUxPL29ndUxabDVpQjlx?=
 =?utf-8?B?dEliUDRMTzIxVFdUS29LZXFJVkJOQkhYekNBQXdJekUwYm1nUzZnclE1dWc0?=
 =?utf-8?B?NzlybWlPdm96ZWE0TllnTEZUajVFVTRQVWpIYmJZTGVjZE9WT0xCcnBkMy8v?=
 =?utf-8?B?Zis5UDd2VXkyTitlbE9YSm1ib21XZjR6WFNQRzdXZVE3QnAwZDQrZFByWURL?=
 =?utf-8?B?YmE2R1ZRUWxsR08rZ1BnN3JMUkZreVBjdTgwMEYxQ1JIWHI0ZVpJRFhFYk0w?=
 =?utf-8?B?RHk5WERiNWF2Qk1tajNMTFFScTdHNG0yWnQ3SU5uTjRGdjV5TWlRdmdzMVNW?=
 =?utf-8?B?UkdzVHBJR0RWRUVwa3V3bCt4ZnlScS8yTDdnT3RFeEptSHY1bUZ3UVpNYTUz?=
 =?utf-8?B?Q1FiaW5QRXEvTldWQ3kvTHBZaFlIMHlGaEJ2VUpOdUhXNFJRZEpGQW9RVTZB?=
 =?utf-8?B?RnNIVVp3d0pMenpaTGs3S2hEdnVKelFPZUxvQWlBYWJzSVM4cytWRDAzYkF2?=
 =?utf-8?B?REJ5NFc3T01JVVZwL3FhSnRXdjNlanRDM3o0TUpsUnRzWVBzQ214U3JPaEVs?=
 =?utf-8?B?dE00OVdHRHZ6ZlFxbWRjaEo1VW8vZC9qS3pOT1o4bFJ5VGwwaEFudEJKM2hh?=
 =?utf-8?Q?nUr702qmbGopQEFPYW7O25oZb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc9cdaa-389a-4f2c-1c28-08daff825765
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 09:47:30.2953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xeTO3uFuY+E2cubiazTcTVB1qEbmfpjhNn4WmDmPfYUCN26RHc3C/69/fzngZd3MgXqk7YhJ3jFQoHgGeSoX5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBGcmksIDIwIEphbiAyMDIzIGF0IDEwOjUyLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4gT24g
VHVlLCAyMDIzLTAxLTE3IGF0IDE3OjM1ICswMjAwLCBBdXJlbGllbiBBcHRlbCB3cm90ZToNCj4g
PiBGcm9tOiBCb3JpcyBQaXNtZW5ueSA8Ym9yaXNwQG52aWRpYS5jb20+DQo+ID4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbmV0L2luZXRfY29ubmVjdGlvbl9zb2NrLmgNCj4gYi9pbmNsdWRlL25ldC9p
bmV0X2Nvbm5lY3Rpb25fc29jay5oDQo+ID4gaW5kZXggYzJiMTVmN2U1NTE2Li4yYmE3MzE2N2Iz
YmIgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9uZXQvaW5ldF9jb25uZWN0aW9uX3NvY2suaA0K
PiA+ICsrKyBiL2luY2x1ZGUvbmV0L2luZXRfY29ubmVjdGlvbl9zb2NrLmgNCj4gPiBAQCAtNjgs
NiArNjgsOCBAQCBzdHJ1Y3QgaW5ldF9jb25uZWN0aW9uX3NvY2tfYWZfb3BzIHsNCj4gPiAgICog
QGljc2tfdWxwX29wcyAgICAgICAgUGx1Z2dhYmxlIFVMUCBjb250cm9sIGhvb2sNCj4gPiAgICog
QGljc2tfdWxwX2RhdGEgICAgICAgVUxQIHByaXZhdGUgZGF0YQ0KPiA+ICAgKiBAaWNza19jbGVh
bl9hY2tlZCAgICBDbGVhbiBhY2tlZCBkYXRhIGhvb2sNCj4gPiArICogQGljc2tfdWxwX2RkcF9v
cHMgICAgUGx1Z2dhYmxlIFVMUCBkaXJlY3QgZGF0YSBwbGFjZW1lbnQgY29udHJvbA0KPiBob29r
DQo+ID4gKyAqIEBpY3NrX3VscF9kZHBfZGF0YSAgICAgICAgICAgVUxQIGRpcmVjdCBkYXRhIHBs
YWNlbWVudCBwcml2YXRlIGRhdGENCj4gPiAgICogQGljc2tfY2Ffc3RhdGU6ICAgICAgQ29uZ2Vz
dGlvbiBjb250cm9sIHN0YXRlDQo+ID4gICAqIEBpY3NrX3JldHJhbnNtaXRzOiAgICAgICAgICAg
TnVtYmVyIG9mIHVucmVjb3ZlcmVkIFtSVE9dIHRpbWVvdXRzDQo+ID4gICAqIEBpY3NrX3BlbmRp
bmc6ICAgICAgIFNjaGVkdWxlZCB0aW1lciBldmVudA0KPiA+IEBAIC05OCw2ICsxMDAsOCBAQCBz
dHJ1Y3QgaW5ldF9jb25uZWN0aW9uX3NvY2sgew0KPiA+ICAgICAgIGNvbnN0IHN0cnVjdCB0Y3Bf
dWxwX29wcyAgKmljc2tfdWxwX29wczsNCj4gPiAgICAgICB2b2lkIF9fcmN1ICAgICAgICAgICAg
ICAgICppY3NrX3VscF9kYXRhOw0KPiA+ICAgICAgIHZvaWQgKCppY3NrX2NsZWFuX2Fja2VkKShz
dHJ1Y3Qgc29jayAqc2ssIHUzMiBhY2tlZF9zZXEpOw0KPiA+ICsgICAgIGNvbnN0IHN0cnVjdCB1
bHBfZGRwX3VscF9vcHMgICppY3NrX3VscF9kZHBfb3BzOw0KPiA+ICsgICAgIHZvaWQgX19yY3Ug
ICAgICAgICAgICAgICAgKmljc2tfdWxwX2RkcF9kYXRhOw0KPiANCj4gVGhlIGFib3ZlIHByb2Jh
Ymx5IG5lZWQgYQ0KPiANCj4gI2lmIElTX0VOQUJMRUQoQ09ORklHX1VMUF9ERFApDQo+IA0KPiBj
b21waWxlciBndWFyZC4NCg0KVGhhbmtzLCB3aWxsIGJlIGFkZGVkLg0KDQo+IA0KPiBIYXZlIHlv
dSBjb25zaWRlcmVkIGF2b2lkaW5nIGFkZGluZyB0aGUgYWJvdmUgZmllbGRzIGhlcmUsIGFuZCBp
bnN0ZWFkDQo+IHBhc3MgdGhlbSBhcyBhcmd1bWVudCBmb3IgdGhlIHNldHVwKCkgSC9XIG9mZmxv
YWQgb3BlcmF0aW9uPw0KDQpBZnRlciByZXNlYXJjaGluZyB0aGUgaW1wbGljYXRpb24gb2Ygc3Vj
aCBhIGNoYW5nZSwgd2UgZG9u4oCZdCBiZWxpZXZlIGl0J3MgcmlnaHQuDQpUaGlzIGVudGlyZSB3
b3JrIHdhcyBkZXNpZ25lZCB0byBiZSBiYXNlZCBvbiB0aGUgc29jayBzdHJ1Y3R1cmUsIGFuZCB0
aGlzIGFwcHJvYWNoDQp3aWxsIGJlIG5lZWRlZCBhbHNvIGZvciB0aGUgbmV4dCBwYXJ0IG9mIG91
ciB3b3JrIChUeCksIGluIHdoaWNoIHdlIHdpbGwgdXNlIHRoZSANCm9wcyBhbmQgdGhlIHF1ZXVl
IGFsc28gZnJvbSB0aGUgc29ja2V0Lg0KDQpXZSBkZWZpbmVkIHRoZSBVTERfRERQIGFzIGEgZ2Vu
ZXJpYyBsYXllciB0aGF0IGNhbiBzdXBwb3J0IGRpZmZlcmVudCANCnZlbmRvcnMvZGV2aWNlcyBh
bmQgZGlmZmVyZW50IFVMUHMgc28gdXNpbmcgb25seSBvbmUgb3BzIHdpbGwgbWFrZSBpdCANCm1v
cmUgZGlmZmljdWx0IHRvIG1haW50YWluIGZyb20gb3VyIHBvaW50IG9mIHZpZXcuDQoNCkkgd2ls
bCBhbHNvIGFkZCB0aGF0IHdlIGFyZSBhZGRyZXNzaW5nIHJldmlldyBjb21tZW50cyBmb3IgMS41
IHllYXJzIGluIG9yZGVyIA0KdG8gZmluZSB0dW5lIHRoaXMgZGVzaWduLCBhbmQgc3VjaCBhIGNo
YW5nZSB3aWxsIG9wZW4gdGhlIGZ1bmRhbWVudGFscy4NCg0KPiANCj4gSSBmZWVsIGxpa2Ugc3Vj
aCBmaWVsZHMgYmVsb25nIG1vcmUgbmF0dXJhbGx5IHRvIHRoZSBERFAgb2ZmbG9hZA0KPiBjb250
ZXh0L3F1ZXVlIGFuZCBjdXJyZW50bHkgdGhlIGljc2sgRERQIG9wcyBhcmUgb25seSB1c2VkIGJ5
IHRoZQ0KPiBvZmZsb2FkaW5nIGRyaXZlci4gQWRkaXRpb25hbGx5IGl0IGxvb2tzIHN0cmFuZ2Ug
dG8gbWUgMiBjb25zZWN1dGl2ZQ0KPiBkaWZmZXJlbnQgc2V0IG9mIFVMUHMgaW5zaWRlIHRoZSBz
YW1lIG9iamVjdCAoc29jaykuDQoNClRoaXMgaXMgYnkgZGVzaWduLCBib3RoIGljc2tfdWxwX2Rk
cF9vcHMgYW5kIGljc2tfdWxwX29wcyBhcmUgbmVlZGVkDQppbiBvcmRlciB0byBhbGxvdyB0aGUg
ZnV0dXJlIGltcGxlbWVudGF0aW9uIG9mIE5WTWVUQ1Agb2ZmbG9hZCANCm9uIHRvcCBvZiBUTFMg
KGFuZCBhbnkgZnV0dXJlIGNvbWJpbmF0aW9uIG9mIFVMUCBwcm90b2NvbCBvbiB0b3Agb2YgdGxz
LA0KbXB0Y3AuLi4pLg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBQYW9sbw0KDQo=
