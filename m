Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1095254BE94
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 02:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiFOAKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 20:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFOAKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 20:10:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362A2CDCF;
        Tue, 14 Jun 2022 17:10:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljD9lo1huaF65N3ri5J9ousWDLOoQT864SisuMHYEiqohn+14/t8gmB+ZxwUt2OC6xS0OrTuuwLjJ4AKu0w/+6AtUZ7SkfFVws12dH1nMbSNroDLQjrgV08LGQgyPmXxRmmg9P9X4jd0o081idFsxozQXGmUlkGmA+/1vj1nh9/+nzJufq7SGCWkaSjZOTC0TS5FKBNItfUbmkOTtVtmHMO33uVM20M5XmnwcOrq2CHVovu8NiFW0PO7Vvv8fLd1TID17FVWmJ9mzwUE4omGHSv6tMNmxzh2yg2bmwTF64Bsf1AVyTnrJmuKteJFktSRH2UtviXbYAt2c/vd2Bn6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrQ/N03EJByYWySwcZQWizOfnr0zAj5MSvOnJI8m6Cw=;
 b=YNQB7unYGznrScSAMYSXnVwMUSqJRf843qTVlAxNuNioH6cdMOYykEPWipRmOxVBl48/rJ30iZOsWntw/jpWeD2Gta04OrOPwuNQVqn+3kmMZ33J/DunvdK8AOLvXS0UqnCcc0UbqTLv4iWtEP3AetVW84ZPoMC7IkQPytfZ18ganEKOiDCL+fAltV+0FvQ69st9OakXcMSOADM+SLtWk00TQSiSfB+MvP5ONpl6P1E+aT7ZeCgaT+jeKb4VcQcIlsxKYeYAT2DSQMpwgRw/fGBvzH0blan+V3/6+857YnIfXzb0zOfCNiiqlDrNNMXnjooTgbDA0mU3b92P4Syvmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrQ/N03EJByYWySwcZQWizOfnr0zAj5MSvOnJI8m6Cw=;
 b=d6AYduUPKU02ib1NjoKWHrArBDY7Az+fIjDyyNQBtXjCDUq7M90UMcqSH/OxGNwGxDkJ4tdGtK0/iPiFba0eMsVdJ3/a0EUGS06EGKqvvEZNBY8LJqRO/e+Kl+DHPpRDVNjXSCmR5354d89BmD/RfwKfQW+/7OF3S4harL2/QuYLcUolyR4zGzkS63zC43virQmmP2QFugHfxclrmviynsT2P/RotWxNn9QycLdLVKwuLrRNb3sjzHqmmePVpOs8FbqM6aBEpJ4aNnwWMSaDPsLcHch2qowBKmAqDf0HcX4H21Hm4OK5Q2G0HjANVf2U5b16Ogu3qW7RQKPXxaUh7w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Wed, 15 Jun
 2022 00:10:06 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e%3]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 00:10:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Topic: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Index: AQHYcP5BrBz66eonZEeOxjwIzt98aa0xHKkwgAFx+gCABD0SgIACqRJggABroACAAQ+R4IAAdxYAgAAMy4CAABLZgIAULSmg
Date:   Wed, 15 Jun 2022 00:10:06 +0000
Message-ID: <PH0PR12MB5481994AF05D3B4999EC1F0EDCAD9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org>
 <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
 <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsJJL34iUYQMxHguOV2cQ7rts+hRG5Gp3XKCGuqNdnNQg@mail.gmail.com>
 <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEueG76L8H+F70D=T5kjK_+J68ARNQmQQo51rq3CfcOdRA@mail.gmail.com>
In-Reply-To: <CACGkMEueG76L8H+F70D=T5kjK_+J68ARNQmQQo51rq3CfcOdRA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 674c09fa-493d-47b7-518f-08da4e636742
x-ms-traffictypediagnostic: SJ1PR12MB6289:EE_
x-microsoft-antispam-prvs: <SJ1PR12MB6289FF3A69D6B127716D77EBDCAD9@SJ1PR12MB6289.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2nSvmL8ZcwEI5HnqEa6bqBazlHdxcihYZ4ZUUZi7jViztx0PO+LmbZtKpPRt2tKtBEbuGyUp686c/Ojx8S7puAAm6selEaOHK46hVIjgF87wcr99ZeatfUMIr5BVDHNqAeCtg9Wpp9+xzt03w0FHLM6m7VuteZWyzooe6aJstv1ObrnZJeLUUbpWW71/G2z0/bMcx4/wRGWRrA+I8TaptBUE6i5cr+SDpZHGF84xTGlDVL6LLoygxybPIAdgz4a6ReWCk/4D2xJDNENvbt1WxVQsQ+OWRhR3WrYaUkeNGBNf0k5eJVkzSbHTbm+979VaUPDiXwKPHWMyYsxBXFaE5I/PhNm60rT+WSM+8NBPP2x8q1kui/s2QReUKWLq6oHze5JYrp4MNhqkPqVn0pU4sA4ai1pG837qc6V9bax/EBsK+T722hzaUiNbu4ASldhdAIra9s1/QvuMYYHSZQZ93LGTWfj5lGYZE5J7ej3w8VJ5tstf9AGWP12Gxp3W2vmdLm2DBB8zzavUyi8KHeYZkDumePg4WMcMHGspF46ePM7325uwpOXJd2oLR9SjLh4e9a54OyRgRqWf+TTiDBiT5TqSHCVyymb/QdxEOIwhBw3+QIcW1EnABDdEgFJ9a0kVP8d1KYUE5dIxwWX9TmUd38Q471Jqtqa6Myx1gUE9kb0nqvvf65AKX8TImYMR5psz4fkraGJEHrCmNp9hbNg7rA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(5660300002)(7416002)(2906002)(83380400001)(38100700002)(71200400001)(54906003)(6916009)(508600001)(38070700005)(53546011)(64756008)(66946007)(9686003)(26005)(4326008)(6506007)(122000001)(33656002)(8936002)(7696005)(66476007)(76116006)(66556008)(52536014)(8676002)(316002)(55016003)(86362001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDlWZGRBY0kwL1lHemtBZGV4NG55R1RFU24yTS94WWorTlpFdE1RaUt5REFs?=
 =?utf-8?B?cEltZXYvcEM5K2NPVzY2MHFPeHZISmtTVE1aVG5saFo1Q0crVmJHby9TSENX?=
 =?utf-8?B?c0JycUxHblJJZ2VrMlhIOG40aTkyZ0FqRFRlM2lHS1VlYmw2TDU3Q29ua2hX?=
 =?utf-8?B?UDRqRmdwUGZZV0VScnFHaWtDRHdaRlg4UDJXZ2E4VXpnaXNOaE56SFRUMEhk?=
 =?utf-8?B?d2QvV1VvOVpnU21kVlJKVG1NNzNpKzhxVm1naTRkN0FjeVJ4dkd5M0d0Q2pu?=
 =?utf-8?B?b1hrNlQydzVCdnBTT2I4YnlRUUZ4V3hveUg2ZGorOEN5NnYwbnhaTkVxVzl6?=
 =?utf-8?B?WkppYlVTK0FablpuV1BTbzdLaW8vYXIrbFU1VkY0UlE5SUlEZjJiUVlUU1Jm?=
 =?utf-8?B?RUtCanBDZ256UlhXYlU3NG15LzVjMzlFWWEzZitaTUllNW0xOEV1akw0dE9H?=
 =?utf-8?B?VG5FWndrUzFkUnh1YnBodEZyRzRUbkxDd0d3Q3hTN2h5M1k5Z0RvNDJtMnkw?=
 =?utf-8?B?NGVJVTErTUQ3NmVOb2YySFFvNXBid08zNnRXQW1icEpTZkNpZXlzZWYrMHF1?=
 =?utf-8?B?cXZOMHFBSFBzNzdIS0E4aG4rK1NxVXE3RXNYMGExMjBJT2xqZzBOTkJRZjhB?=
 =?utf-8?B?ZFozckxaUExzMHB4UFprczZQRmgvNHg5QjBJeFRQQlBXYk50bmxBd214bUlU?=
 =?utf-8?B?QlNrVUttcmI3TTVZU09BdjJleWlRMmdRc2ZmV21DV0gySXVLdWxyZWRKRlh5?=
 =?utf-8?B?ejkwRnZ0Qmp6MUQvdzUvZjdMYmpEZWlaaU9QWFVqMTB2VjFLN3liWjB3d1VB?=
 =?utf-8?B?QUlHemEyTTRyTkFXellyOERrQ2pXd0h3OFlsbVFJLzlZWWJ1QVBQQVB4TTRN?=
 =?utf-8?B?bzZWYmV3RU56bUNjK0xobjlIRFBQZ1BEZ095bzAzWW5SQUFWSDJWMmY3S2Y2?=
 =?utf-8?B?aWdub1Q5dnhpQ2I2TGJNQytoSHlZRGNBaUpJb0VsL3JRblROVTRwTXV5L3Iz?=
 =?utf-8?B?bzM5ZlQ4UHlSSWQzcWJ0Q1BBTHdNTzBOMnpBWHUxbjBOWHh5RlZKOUJKVEZN?=
 =?utf-8?B?WGZmTlFIOStIQkRRTjN2N3lNMjdHTm1rQ1p0N2UyNFRRalN0ekh3QXRjT3VU?=
 =?utf-8?B?a0FsL1Q0bEw5MmtPVU5GNUt1bExrUjk3WWRTUzF0c3lxKzFzcy9UanN2N0Zs?=
 =?utf-8?B?Mzh5b3ZaRU5rbk0wQUN0V24zckJjTDFTWWF2NzJLdE02YzRoZ2FTVlNwZXI0?=
 =?utf-8?B?c2xaM1doRitaaTBkaVJUdzNmWkptQldFaFRlQ3ZoeDBQOTQ2bmZ2Smd3QkRx?=
 =?utf-8?B?NDZZdHpEZlpuekorT09EN2pGbzlxMitIdy9wOTIyMEVmU2pjUWNTb2xmZWhZ?=
 =?utf-8?B?cE01L1hKTFpGZzdIQWh3MEZ6Uy92YXM1ZDd6OU1FN0E3M2EvUWhHTHVxR0Zh?=
 =?utf-8?B?OEZkUHVKMnFMUldYZ0JXZEtiSHo3cFM1T0ZER1Z4RzlwNmIzU2hVL3ZjT1FD?=
 =?utf-8?B?ay9BaDhwcFZRZnNWRElzQzUzWXVmQmQ4ZDUzRW9sSjhLN0VvSEp2WTFDMENj?=
 =?utf-8?B?bnpOanR4L2ZIZkJwbi8xdldrK1RCY2VSOFFaVjI0NjhrNG8rTDN0R1hubWxY?=
 =?utf-8?B?ajl5NUJJTmU0VllMWWYyNmg1RWxaeVhndDB3b2ZZSjNTcTlIMkl5S3JzbGdC?=
 =?utf-8?B?N2xaT1dNQjVhWDJoMXZTWndiMWg1cGlrMXNSVUdab2hvN1Q4U2E4SXNiS21p?=
 =?utf-8?B?bkVvWGNYMTM0T2NuazdxYzMxSVJqRmxhR21zS0syNDJ3bTRJUHdWQ2pWeFh3?=
 =?utf-8?B?TUQweS9vakw5cmd6RmtPTnU2YytyUUs1NURIaVp5MWtHMW5TUU9YbTdBN2NN?=
 =?utf-8?B?YkdOdGlNOURUNkR0RGNtQlFDZ3BEeGllekNtMDBCWjFuRk9kU29WRUpxSUJT?=
 =?utf-8?B?eVJ0OEJjQnJuZStqSnBXa0w4Qy9mdThkOVh6dTY3MStPQzBMdGx0cjNOQU9T?=
 =?utf-8?B?Z0ZkTUVqaU9uTVI3ZENualM0M3JjVzRJdUtTUEk0WkxHQ0RJazVQUFRPV1Ri?=
 =?utf-8?B?cFdtbE1WeGJ3bUFBNndBTm1RZWZvYWhWS0tvM1FYa08zYndJSjZUR1BjQ0U4?=
 =?utf-8?B?VThwWnpKUitBRnFWT3RhK0dCdmYrNzIvTDZoTzg1Tk5CcEYrOEFkN2NOdkRE?=
 =?utf-8?B?eEtCWk1uVm9zaEIxcXk0S09LMHNJeWtaWmFSVXFzaWZlRUtFTGd0bzBza1Vz?=
 =?utf-8?B?MHF3dTMxRlpZZ2IvMW9EbWl0d2pLV245Q29ZbWpwUEdvcTRtWFc0Y2dwUmxX?=
 =?utf-8?Q?tPuAQphHCd2n8EP6Jz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 674c09fa-493d-47b7-518f-08da4e636742
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 00:10:06.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OrTax0bw821yBX1AHfoOnZC5UsKC+VAXnba0LsX/UdSYqDgFzxOipwNZMAT/elqto28CDwjuDnEs5sAPVR22+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6289
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBKdW5lIDEsIDIwMjIgMTE6NTQgUE0NCj4gDQo+IE9uIFRodSwgSnVuIDIsIDIwMjIg
YXQgMTA6NTkgQU0gUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPiB3cm90ZToNCj4gPg0K
PiA+DQo+ID4gPiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiA+ID4g
U2VudDogV2VkbmVzZGF5LCBKdW5lIDEsIDIwMjIgMTA6MDAgUE0NCj4gPiA+DQo+ID4gPiBPbiBU
aHUsIEp1biAyLCAyMDIyIGF0IDI6NTggQU0gUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29t
PiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gPiBGcm9tOiBKYXNvbiBXYW5nIDxq
YXNvd2FuZ0ByZWRoYXQuY29tPg0KPiA+ID4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1heSAzMSwgMjAy
MiAxMDo0MiBQTQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2VsbCwgdGhlIGFiaWxpdHkgdG8gcXVl
cnkgdGhlIHZpcnRxdWV1ZSBzdGF0ZSB3YXMgcHJvcG9zZWQgYXMNCj4gPiA+ID4gPiBhbm90aGVy
IGZlYXR1cmUgKEV1Z2VuaW8sIHBsZWFzZSBjb3JyZWN0IG1lKS4gVGhpcyBzaG91bGQgYmUNCj4g
PiA+ID4gPiBzdWZmaWNpZW50IGZvciBtYWtpbmcgdmlydGlvLW5ldCB0byBiZSBsaXZlIG1pZ3Jh
dGVkLg0KPiA+ID4gPiA+DQo+ID4gPiA+IFRoZSBkZXZpY2UgaXMgc3RvcHBlZCwgaXQgd29uJ3Qg
YW5zd2VyIHRvIHRoaXMgc3BlY2lhbCB2cSBjb25maWcgZG9uZQ0KPiBoZXJlLg0KPiA+ID4NCj4g
PiA+IFRoaXMgZGVwZW5kcyBvbiB0aGUgZGVmaW5pdGlvbiBvZiB0aGUgc3RvcC4gQW55IHF1ZXJ5
IHRvIHRoZSBkZXZpY2UNCj4gPiA+IHN0YXRlIHNob3VsZCBiZSBhbGxvd2VkIG90aGVyd2lzZSBp
dCdzIG1lYW5pbmdsZXNzIGZvciB1cy4NCj4gPiA+DQo+ID4gPiA+IFByb2dyYW1taW5nIGFsbCBv
ZiB0aGVzZSB1c2luZyBjZmcgcmVnaXN0ZXJzIGRvZXNuJ3Qgc2NhbGUgZm9yDQo+ID4gPiA+IG9u
LWNoaXANCj4gPiA+IG1lbW9yeSBhbmQgZm9yIHRoZSBzcGVlZC4NCj4gPiA+DQo+ID4gPiBXZWxs
LCB0aGV5IGFyZSBvcnRob2dvbmFsIGFuZCB3aGF0IEkgd2FudCB0byBzYXkgaXMsIHdlIHNob3Vs
ZCBmaXJzdA0KPiA+ID4gZGVmaW5lIHRoZSBzZW1hbnRpY3Mgb2Ygc3RvcCBhbmQgc3RhdGUgb2Yg
dGhlIHZpcnRxdWV1ZS4NCj4gPiA+DQo+ID4gPiBTdWNoIGEgZmFjaWxpdHkgY291bGQgYmUgYWNj
ZXNzZWQgYnkgZWl0aGVyIHRyYW5zcG9ydCBzcGVjaWZpYw0KPiA+ID4gbWV0aG9kIG9yIGFkbWlu
IHZpcnRxdWV1ZSwgaXQgdG90YWxseSBkZXBlbmRzIG9uIHRoZSBoYXJkd2FyZQ0KPiBhcmNoaXRl
Y3R1cmUgb2YgdGhlIHZlbmRvci4NCj4gPiA+DQo+ID4gSSBmaW5kIGl0IGhhcmQgdG8gYmVsaWV2
ZSB0aGF0IGEgdmVuZG9yIGNhbiBpbXBsZW1lbnQgYSBDVlEgYnV0IG5vdCBBUSBhbmQNCj4gY2hv
c2UgdG8gZXhwb3NlIHRlbnMgb2YgaHVuZHJlZHMgb2YgcmVnaXN0ZXJzLg0KPiA+IEJ1dCBtYXli
ZSwgaXQgZml0cyBzb21lIHNwZWNpZmljIGh3Lg0KPiANCj4gWW91IGNhbiBoYXZlIGEgbG9vayBh
dCB0aGUgaWZjdmYgZHBkayBkcml2ZXIgYXMgYW4gZXhhbXBsZS4NCj4gDQpJZmN2ZiBpcyBhbiBl
eGFtcGxlIG9mIHVzaW5nIHJlZ2lzdGVycy4NCkl0IGlzIG5vdCBhbiBhbnN3ZXIgd2h5IEFRIGlz
IGhhcmQgZm9yIGl0LiA6KQ0KdmlydGlvIHNwZWMgaGFzIGRlZmluaXRpb24gb2YgcXVldWUgbm93
IGFuZCBpbXBsZW1lbnRpbmcgeWV0IGFub3RoZXIgcXVldWUgc2hvdWxkbid0IGJlIGEgcHJvYmxl
bS4NCg0KU28gZmFyIG5vIG9uZSBzZWVtIHRvIGhhdmUgcHJvYmxlbSB3aXRoIHRoZSBhZGRpdGlv
bmFsIHF1ZXVlLg0KU28gSSB0YWtlIGl0IGFzIEFRIGlzIG9rLg0KDQo+IEJ1dCBhbm90aGVyIHRo
aW5nIHRoYXQgaXMgdW5yZWxhdGVkIHRvIGhhcmR3YXJlIGFyY2hpdGVjdHVyZSBpcyB0aGUgbmVz
dGluZw0KPiBzdXBwb3J0LiBIYXZpbmcgYWRtaW4gdmlydHF1ZXVlIGluIGEgbmVzdGluZyBlbnZp
cm9ubWVudCBsb29rcyBsaWtlIGFuDQo+IG92ZXJraWxsLiBQcmVzZW50aW5nIGEgcmVnaXN0ZXIg
aW4gTDEgYW5kIG1hcCBpdCB0byBMMCdzIGFkbWluIHNob3VsZCBiZSBnb29kDQo+IGVub3VnaC4N
ClNvIG1heSBiZSBhIG9wdGltaXplZCBpbnRlcmZhY2UgY2FuIGJlIGFkZGVkIHRoYXQgZml0cyBu
ZXN0ZWQgZW52Lg0KQXQgdGhpcyBwb2ludCBpbiB0aW1lIHJlYWwgdXNlcnMgdGhhdCB3ZSBoZWFy
ZCBhcmUgaW50ZXJlc3RlZCBpbiBub24tbmVzdGVkIHVzZSBjYXNlcy4gTGV0J3MgZW5hYmxlIHRo
ZW0gZmlyc3QuDQoNCg0KPiANCj4gPg0KPiA+IEkgbGlrZSB0byBsZWFybiB0aGUgYWR2YW50YWdl
cyBvZiBzdWNoIG1ldGhvZCBvdGhlciB0aGFuIHNpbXBsaWNpdHkuDQo+ID4NCj4gPiBXZSBjYW4g
Y2xlYXJseSB0aGF0IHdlIGFyZSBzaGlmdGluZyBhd2F5IGZyb20gc3VjaCBQQ0kgcmVnaXN0ZXJz
IHdpdGggU0lPViwNCj4gSU1TIGFuZCBvdGhlciBzY2FsYWJsZSBzb2x1dGlvbnMuDQo+ID4gdmly
dGlvIGRyaWZ0aW5nIGluIHJldmVyc2UgZGlyZWN0aW9uIGJ5IGludHJvZHVjaW5nIG1vcmUgcmVn
aXN0ZXJzIGFzDQo+IHRyYW5zcG9ydC4NCj4gPiBJIGV4cGVjdCBpdCB0byBhbiBvcHRpb25hbCB0
cmFuc3BvcnQgbGlrZSBBUS4NCj4gDQo+IEFjdHVhbGx5LCBJIGhhZCBhIHByb3Bvc2FsIG9mIHVz
aW5nIGFkbWluIHZpcnRxdWV1ZSBhcyBhIHRyYW5zcG9ydCwgaXQncw0KPiBkZXNpZ25lZCB0byBi
ZSBTSU9WL0lNUyBjYXBhYmxlLiBBbmQgaXQncyBub3QgaGFyZCB0byBleHRlbmQgaXQgd2l0aCB0
aGUNCj4gc3RhdGUvc3RvcCBzdXBwb3J0IGV0Yy4NCj4gDQo+ID4NCj4gPiA+ID4NCj4gPiA+ID4g
TmV4dCB3b3VsZCBiZSB0byBwcm9ncmFtIGh1bmRyZWRzIG9mIHN0YXRpc3RpY3Mgb2YgdGhlIDY0
IFZRcw0KPiA+ID4gPiB0aHJvdWdoIGENCj4gPiA+IGdpYW50IFBDSSBjb25maWcgc3BhY2UgcmVn
aXN0ZXIgaW4gc29tZSBidXN5IHBvbGxpbmcgc2NoZW1lLg0KPiA+ID4NCj4gPiA+IFdlIGRvbid0
IG5lZWQgZ2lhbnQgY29uZmlnIHNwYWNlLCBhbmQgdGhpcyBtZXRob2QgaGFzIGJlZW4NCj4gPiA+
IGltcGxlbWVudGVkIGJ5IHNvbWUgdkRQQSB2ZW5kb3JzLg0KPiA+ID4NCj4gPiBUaGVyZSBhcmUg
dGVucyBvZiA2NC1iaXQgY291bnRlcnMgcGVyIFZRcy4gVGhlc2UgbmVlZHMgdG8gcHJvZ3JhbW1l
ZCBvbg0KPiBkZXN0aW5hdGlvbiBzaWRlLg0KPiA+IFByb2dyYW1taW5nIHRoZXNlIHZpYSByZWdp
c3RlcnMgcmVxdWlyZXMgZXhwb3NpbmcgdGhlbSBvbiB0aGUgcmVnaXN0ZXJzLg0KPiA+IEluIG9u
ZSBvZiB0aGUgcHJvcG9zYWxzLCBJIHNlZSB0aGVtIGJlaW5nIHF1ZXJpZWQgdmlhIENWUSBmcm9t
IHRoZSBkZXZpY2UuDQo+IA0KPiBJIGRpZG4ndCBzZWUgYSBwcm9wb3NhbCBsaWtlIHRoaXMuIEFu
ZCBJIGRvbid0IHRoaW5rIHF1ZXJ5aW5nIGdlbmVyYWwgdmlydGlvIHN0YXRlDQo+IGxpa2UgaWR4
IHdpdGggYSBkZXZpY2Ugc3BlY2lmaWMgQ1ZRIGlzIGEgZ29vZCBkZXNpZ24uDQo+IA0KTXkgZXhh
bXBsZSB3YXMgbm90IGZvciB0aGUgaWR4LiBCdXQgZm9yIFZRIHN0YXRpc3RpY3MgdGhhdCBpcyBx
dWVyaWVkIHZpYSBDVlEuDQoNCj4gPg0KPiA+IFByb2dyYW1taW5nIHRoZW0gdmlhIGNmZyByZWdp
c3RlcnMgcmVxdWlyZXMgbGFyZ2UgY2ZnIHNwYWNlIG9yIHN5bmNocm9ub3VzDQo+IHByb2dyYW1t
aW5nIHVudGlsIHJlY2VpdmluZyBBQ0sgZnJvbSBpdC4NCj4gPiBUaGlzIG1lYW5zIG9uZSBlbnRy
eSBhdCBhIHRpbWUuLi4NCj4gPg0KPiA+IFByb2dyYW1taW5nIHRoZW0gdmlhIENWUSBuZWVkcyBy
ZXBsaWNhdGUgYW5kIGFsaWduIGNtZCB2YWx1ZXMgZXRjIG9uIGFsbA0KPiBkZXZpY2UgdHlwZXMu
IEFsbCBkdXBsaWNhdGUgYW5kIGhhcmQgdG8gbWFpbnRhaW4uDQo+ID4NCj4gPg0KPiA+ID4gPg0K
PiA+ID4gPiBJIGNhbiBjbGVhcmx5IHNlZSBob3cgYWxsIHRoZXNlIGFyZSBpbmVmZmljaWVudCBm
b3IgZmFzdGVyIExNLg0KPiA+ID4gPiBXZSBuZWVkIGFuIGVmZmljaWVudCBBUSB0byBwcm9jZWVk
IHdpdGggYXQgbWluaW11bS4NCj4gPiA+DQo+ID4gPiBJJ20gZmluZSB3aXRoIGFkbWluIHZpcnRx
dWV1ZSwgYnV0IHRoZSBzdG9wIGFuZCBzdGF0ZSBhcmUgb3J0aG9nb25hbCB0bw0KPiB0aGF0Lg0K
PiA+ID4gQW5kIHVzaW5nIGFkbWluIHZpcnRxdWV1ZSBmb3Igc3RvcC9zdGF0ZSB3aWxsIGJlIG1v
cmUgbmF0dXJhbCBpZiB3ZQ0KPiA+ID4gdXNlIGFkbWluIHZpcnRxdWV1ZSBhcyBhIHRyYW5zcG9y
dC4NCj4gPiBPay4NCj4gPiBXZSBzaG91bGQgaGF2ZSBkZWZpbmVkIGl0IGJpdCBlYXJsaWVyIHRo
YXQgYWxsIHZlbmRvcnMgY2FuIHVzZS4gOigNCj4gDQo+IEkgYWdyZWUuDQoNCkkgcmVtZW1iZXIg
ZmV3IG1vbnRocyBiYWNrLCB5b3UgYWNrZWQgaW4gdGhlIHdlZWtseSBtZWV0aW5nIHRoYXQgVEMg
aGFzIGFwcHJvdmVkIHRoZSBBUSBkaXJlY3Rpb24uDQpBbmQgd2UgYXJlIHN0aWxsIGluIHRoaXMg
Y2lyY2xlIG9mIGRlYmF0aW5nIHRoZSBBUS4NCg==
