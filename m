Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E2581B4F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiGZUtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiGZUts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:49:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683831AD93
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXqakIgeu9cIvHg+wGYsposVOmkFtgQv8UIRPFRFKdkwfXF80R6801I1O+Q/XKAl7TwdOpyDMurQREhjYsDlLkic7LLeEnLZP3REETRsSkj+hvTikHq6zPCJy3YJkYRv7cG1aH0uNkgl8B+jU9bDMyWDx2RYAyGpLTjMTVHpslUogRx9eFaKiCR0vpOE7/Ggol7EaefhH+/RlLLsvDEuL8LvTgA/uDI4iy8RsGL4AmK0C7+vYYHkd20K+BxiOP9HgGMM/K8kDLJmjXL3DThnVRMJEC5pzN06l1DpBHmBHA9cQPgEGFUwJXJYdzbsI/8WY2I5woEI1gs8ZELJlXoYFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5X9tZaUjaV+fP5ADO/KLeJFPPHHNcbmGVkj05sgLsWI=;
 b=TJqSeBXzJNkKw/VFewAWYF/iIkuv8J5RIa1kEHEuBKadog3VeLV8Z3/O2DJKTrKtYnTiFLAiKnm/JPUdMBb+S7JGDeLbfj0Mfsi7nVfYUtzoP7K8aN6WyGqsizp5WwmFyWvq6YZmp0HqjpBdR1lbi3c6HvoCXD5JJi7a0PSFHzkEkRtc7R19Gqjtef4931SKs7b0g3WaXlq/KXccz9odEV2iaG9vEFtflOMH31OM0A5DKDS2iUtLZ4Hk9/yHAC1yIVT7n6/8kHBmnlkOujAFn9HCR5foWWPlqlEh4cIV/UMeYw1AFnQkzcTF3tb3+a4cnm3ulBA05DV73/12JApVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5X9tZaUjaV+fP5ADO/KLeJFPPHHNcbmGVkj05sgLsWI=;
 b=S8Wc4baEO4OsDJoj7jWfAotjX8b/a62kmBZuhI2GaOjnBJ+NhvC9H/Os5Bb03vuXk6ogsYCmBPFsRF1ZtSWrQvsZaX1uHrabbdUqPZs9XSGWn86nrvyUE8Zja38qS0xCj24onupfCx1e09ofXrJvtPly866OGUANC1QLHO8KfD1fmNJsegKSa2xdaEMqzhb4Cv22+1eHJDCJNaxWD3/PzynId9WYZpeBdDuqZhwrOAKmz852XnKmhaNEDpmmo8kgM8316xmcm20qpkY5/J4a6O12gu/HCIJqXpLsoLW/sFPhlsx+bBqrO5PA0VnAOJkjF9Ak3Vd8n88HLySLODDQaw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB5262.namprd12.prod.outlook.com (2603:10b6:5:399::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 20:49:46 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 20:49:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYjU+OpP/4aLhN20eCCMO4rbOEoq1qEloggAn4zwCAAKXGEIAD0JkAgAJ/vUCAAK5SAIAAADPwgAALqACAFTnxEIAAQlWAgAAPxmA=
Date:   Tue, 26 Jul 2022 20:49:45 +0000
Message-ID: <PH0PR12MB5481167F0B47A83A2E2E86D4DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220726154930-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220726154930-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01952675-d748-4b24-eb57-08da6f485f9a
x-ms-traffictypediagnostic: DM4PR12MB5262:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HkXXHEMp+yU69JTcKpGLE40aurEEYOKpfeF6yM59N4/wGamyTmHWapCpK3dPjF1/qsYK03aKdfL0Coex7A6HXB0a5IaG7gWoQQQf6vVndiJRNwFTDMWfvWVmjggJgXIU+xGWne+HeFUrSr1bO3DU2M8lOQvVDU6vmWy0A7Yt8Ml3h4fSO8elKDASp34+hYNxwd0PZlA4my3H3ucljv1/hdPYUfhaeIK8m/ZUzwWZ6ukfkrNufOaeshkRmv0SdR+isOqg0WhYVW5T3guUgLrbmYY7dhBBoor/xFMZ42SovSWn1cxN+/xoulfhcLkZMySjjO4ym7quytFOx0zDDym3H0fM5yISRf79LI8mZHcWqNwPqZT3C3qW2IPWCfGOxZBPnsxyn9QxCIoJaJKvY1zahyJGZiJ8TGamQxp8C5Ly8lEmBhcsYaclN4lnoISl0LIVzSzeAl+90gPbr0e5w+qLQfXFPMBhptuGMMp0QN4vwP5A3v7tMBeH0YU7zQKKg713pMBQK543Ulz1xSzwUOiMphWH4gKUbfza0uQy9n5XlqkdZe1IO6lHeVKZhTxrvvmcMhtnqH/Kkw0128VQKDqaT507KCpTaTEWQm2LjQzl23vleuYeDhE+s2sP5bLaUDSwEod5FpQVOr9INVhzuLvEdtfIr4FQbGHfQg0D7b+GDtVRx2ZEXZGqIwXV7pqAEfQo0nHPFmI9iuK+F/dONDnHLETMdE97NhRCrLWHoMfYGDJGXNlEmRqkm4QsYq5wzhixotpdIMNgcV0pBmTaMnTbAWml5MXGyELxTvuW9jrxzoc7x4muP1NVHckrXC9Oz+yTotFTVKonJKBtI0CsBdZ71Jo4vbgUP3qHLJqYtn2PJb0GLs9AlIpAN9LaoyK3r955+f7VONRI26I1QioZcuECAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(2906002)(86362001)(7696005)(6916009)(122000001)(6506007)(54906003)(8676002)(66476007)(64756008)(66446008)(71200400001)(38100700002)(66556008)(33656002)(41300700001)(66946007)(316002)(4326008)(76116006)(9686003)(966005)(83380400001)(26005)(38070700005)(52536014)(478600001)(186003)(8936002)(5660300002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VExHL2srbkErK3pLQWdXd3N6RnZTaStLdEtLSkZUSmV4SXNoL2V1RWQ4ZFJM?=
 =?utf-8?B?cVY2WWpiNVhGOG1aNkhSM1RwWTZVeVprS295d2dLZXpyeTU0N0hFeWJsbkRR?=
 =?utf-8?B?V3VSSlFSVGRuMXpUalFwdmp1YnhiWVlBbmlPN0NObmpHU0Q0ajAwZmxLUE5M?=
 =?utf-8?B?Z2VVZUJERUpUN0U5cnY5V1JQVDNGOW1jaGp5cHJ6bk11ak1rdnBxdU9RUTBt?=
 =?utf-8?B?VWN4cUNqYUpWN0lZWEdTUEZjWm5FeEhkbFh5SmZtenI5ckdyNHczeTZVWlJU?=
 =?utf-8?B?VjAxRzdIVDhQQXhUWGdFbzI2MVJMOTd6OWN5L0VwSTFuR0VmdzUvMDNIcnNP?=
 =?utf-8?B?OU5TOFhEMmFqZHNkcEZvM1lJTElNN0lXZUUwZVN4dlc2Z1NCQ2o2YTdRQXZm?=
 =?utf-8?B?M3VQR0xuVEFOeVY1RjBqUmRoU3FWc1FScXNWZW11SEhpNWl1VCtCVnRadHVB?=
 =?utf-8?B?S3Z0YlZBTXpKdW5nVjV4OXREeWFPbWdPN1pIby91UndhaFBJZWE5bFI0akc5?=
 =?utf-8?B?d0VadjZMS2lvYXJ2VHd2ZlBDV1dqYUJhZHBWTGw2Qmt0TFZHOHQ0SXZXVUtO?=
 =?utf-8?B?UC96K0VwZ1BMUkx4UXZNZVVFUTBpSVhsMTVsMFZ2SEtVOG9HNUlSVW9mZFBZ?=
 =?utf-8?B?akx1Qmsxelpkb0F3WG5VcFVNWUk5NTNXVVRZSlNUZEhOODBlbHNpL3BLcXdX?=
 =?utf-8?B?bVNVbDFGMjZxaWgxMkpDMXRiVkwvSlMrZmdKN3Z6aXQrTEt4TzZmWWNNK3B3?=
 =?utf-8?B?cDVZMkh4RStuTjQ1ekkwdUc4UThuV1NjN1d3NVRvWktGS3lUcDBHUzNNeE1R?=
 =?utf-8?B?ZTRNaWNhVUswK0crT3BEQ2w2b0RwdHp5eHhqcjBuWXQra2xGUWVNNHJUQUow?=
 =?utf-8?B?RG9SVnl1OGl3dUY1dnFvNkNiM29aQzl2aExlTlM1MVJBbG83Wm01eXptN29B?=
 =?utf-8?B?UGw1NkdNN1VnaGZmMHVWVkhka3Z0eUFCUzJhMzlMVWNCSkJFc0dsNllHTDBx?=
 =?utf-8?B?V3Z3UG1PenpLMnBFanhNdE9jN2pVUmRuR0x4TndwNTRTRzR0T3g5RkVWWTBU?=
 =?utf-8?B?dUJUUExIbXpqVHNXY2J6OHJmNkVmNGcwNXlJOG84Q0pkbGNhVGRGMGhXWjZw?=
 =?utf-8?B?MEgxNVZFRkUzRllDVHkzS3hUQ2ljWStHa21sSlV5c1ZZWGcvNnlPRzk4NDhC?=
 =?utf-8?B?NXJsTlc2QmowUlZqN1ZBd2s3cjZhTGFuR25JNFhXelQ4Y3U1L3YxbTUreG0y?=
 =?utf-8?B?OFRta0E1UGQwQnBsNkFlS1RZWjVDSVZWajJpdmhDQXhxN0JmRWdIb3pRbm5E?=
 =?utf-8?B?bHcreFdBNkZLVE12Y01HVU9icy8wWVBjaEF0ME1ybTZWUWJCd3dYSG9saHJu?=
 =?utf-8?B?YWdvQWRpSW03VkU2YjEvVFdCa0tGNzJTa01lbHYycFdOVzhudG4vS2oxcXdi?=
 =?utf-8?B?Sm0vcTkwY2F5QnRvYVNSakcrRmpodGlxUGQ1TXZ4WFRCVkRPZm1oWnZjQzJt?=
 =?utf-8?B?V3Zvd29tblZWamllN0o4NlVKNzhiTmphbVBCaHhpSmJhenVDNmFvT1U1b0hn?=
 =?utf-8?B?Sk9FM04yUWlNMVJhUk9veGhIYmZ5aTZ4b3NUVlpOcWtSN0hEZHJ6SStqQktH?=
 =?utf-8?B?UWVjQUdudzkyaEp6WDliVUZUaTY3TmlEazJhSENpL2hvdlgwMlJaTkQyS3Qx?=
 =?utf-8?B?U3FGNncxRnlSM0ZRZ0tvSjlKM2RwUmsyVFkwd1RWZzVocWVpa3BqNFI5ZWhL?=
 =?utf-8?B?VDZ4L2VEaklYM28xMlJKNERhSXJ3dVltWEIzeFdmbVVrWGFHNitZZHVWQjk2?=
 =?utf-8?B?VFIzQ3pQQnJTeUpxTS8zOURkUzc5dlBzcjNuaDlmNEx2OWZ5ZXlEUFVCaVF5?=
 =?utf-8?B?NzF4MzhCaElYVldILytjRGlpQkRKRlVMVlJueDVualNTc3hCSzBlV3pwQ09H?=
 =?utf-8?B?UVFNRkxKdmtpUENvQ1ZkSFgvQmlmYTlhTmh5bS81ejV2ak1ycHNvaU9DcUxk?=
 =?utf-8?B?ZWxPME1hcTJTdkp4M1BUTk5xNlZsNzA3QkUzcXdnbzVDcS9hT1IxTGZRWUpT?=
 =?utf-8?B?S1lsVk9OL3gxUXFDU254NjJnZ1QvRlQ4THR1TEFDK2ZXTzAvM05hdmNlL1VJ?=
 =?utf-8?Q?GEeQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01952675-d748-4b24-eb57-08da6f485f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 20:49:45.8350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SGN//D7E6iXDXK+D1B0o7vKWNBx/Vy2gN/rfMnbxPGM6HWEbH9a+9PP6BTpVTVjvWkCWc7m57od714Sl7L7S5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5262
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1
ZXNkYXksIEp1bHkgMjYsIDIwMjIgMzo1MiBQTQ0KPiANCj4gT24gVHVlLCBKdWwgMjYsIDIwMjIg
YXQgMDM6NTY6MzJQTSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4gPiBGcm9t
OiBaaHUsIExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPg0KPiA+ID4gU2VudDogVHVl
c2RheSwgSnVseSAxMiwgMjAyMiAxMTo0NiBQTQ0KPiA+ID4gPiBXaGVuIHRoZSB1c2VyIHNwYWNl
IHdoaWNoIGludm9rZXMgbmV0bGluayBjb21tYW5kcywgZGV0ZWN0cyB0aGF0DQo+ID4gPiA+IF9N
UQ0KPiA+ID4gaXMgbm90IHN1cHBvcnRlZCwgaGVuY2UgaXQgdGFrZXMgbWF4X3F1ZXVlX3BhaXIg
PSAxIGJ5IGl0c2VsZi4NCj4gPiA+IEkgdGhpbmsgdGhlIGtlcm5lbCBtb2R1bGUgaGF2ZSBhbGwg
bmVjZXNzYXJ5IGluZm9ybWF0aW9uIGFuZCBpdCBpcw0KPiA+ID4gdGhlIG9ubHkgb25lIHdoaWNo
IGhhdmUgcHJlY2lzZSBpbmZvcm1hdGlvbiBvZiBhIGRldmljZSwgc28gaXQNCj4gPiA+IHNob3Vs
ZCBhbnN3ZXIgcHJlY2lzZWx5IHRoYW4gbGV0IHRoZSB1c2VyIHNwYWNlIGd1ZXNzLiBUaGUga2Vy
bmVsDQo+ID4gPiBtb2R1bGUgc2hvdWxkIGJlIHJlbGlhYmxlIHRoYW4gc3RheSBzaWxlbnQsIGxl
YXZlIHRoZSBxdWVzdGlvbiB0byB0aGUgdXNlcg0KPiBzcGFjZSB0b29sLg0KPiA+IEtlcm5lbCBp
cyByZWxpYWJsZS4gSXQgZG9lc27igJl0IGV4cG9zZSBhIGNvbmZpZyBzcGFjZSBmaWVsZCBpZiB0
aGUgZmllbGQgZG9lc27igJl0IGV4aXN0DQo+IHJlZ2FyZGxlc3Mgb2YgZmllbGQgc2hvdWxkIGhh
dmUgZGVmYXVsdCBvciBubyBkZWZhdWx0Lg0KPiA+IFVzZXIgc3BhY2Ugc2hvdWxkIG5vdCBndWVz
cyBlaXRoZXIuIFVzZXIgc3BhY2UgZ2V0cyB0byBzZWUgaWYgX01RIHByZXNlbnQvbm90DQo+IHBy
ZXNlbnQuIElmIF9NUSBwcmVzZW50IHRoYW4gZ2V0IHJlbGlhYmxlIGRhdGEgZnJvbSBrZXJuZWwu
DQo+ID4gSWYgX01RIG5vdCBwcmVzZW50LCBpdCBtZWFucyB0aGlzIGRldmljZSBoYXMgb25lIFZR
IHBhaXIuDQo+IA0KPiBZZXMgdGhhdCdzIGZpbmUuIEFuZCBpZiB3ZSBqdXN0IGRpZG4ndCByZXR1
cm4gYW55dGhpbmcgd2l0aG91dCBNUSB0aGF0IHdvdWxkIGJlDQo+IGZpbmUuICBCdXQgSUlVQyBu
ZXRsaW5rIHJlcG9ydHMgdGhlICMgb2YgcGFpcnMgcmVnYXJkbGVzcywgaXQganVzdCBwdXRzIDAg
dGhlcmUuDQpJIHJlYWQgaXQgZGlmZmVyZW50bHkgYXQgWzFdIHdoaWNoIGNoZWNrcyBmb3IgdGhl
IE1RIGZlYXR1cmUgYml0Lg0KDQpbMV0gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgv
bGF0ZXN0L3NvdXJjZS9kcml2ZXJzL3ZkcGEvdmRwYS5jI0w4MjUNCg0KPiANCj4gLS0NCj4gTVNU
DQoNCg==
