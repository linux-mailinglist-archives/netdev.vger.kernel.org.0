Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0841D581E59
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiG0Drj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiG0Dri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:47:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF997192B2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:47:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIc9yKEmjYsfyU+hysQ4oIQBJGZch1BiDxodfQpjRRZxF+RfUnM3D3Xoe0SiVY15/smmr06zEkn06yBIIWqidtqMQBaQ/ms5OsZB+zTI0d1dN6aGRQO9Qhrl21xulfe2VQgLAcTmKxTfK1SWyPviWOF00nP1M47DZmCBiQ/dAamSce+zi8HoPhLiDN2KNwdhCZshSfEH/odZHTMiREztSKDncbTcj8UfJKSH63/6lOW0funlLwPO4BwueKZoaTcxFKQJMg5eyCxt7Lyy4Py8l9EtNz4br59qc3VvnHowcZ7vnqq8Zcins9A8NKG60wSO5z33DvxIkPyzcpXDJY1E5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKEX0xEmFZcywHIJLDMeVtRKZRQvU//vZUVDz7Lf+dY=;
 b=ks/EPn3vASjrvyNgzDkBGhSyh9bOlXUx6A+bQbBQ4L6UggnWjKjP/fRPYpOKDKq4sVGvFhvR6GkzPbH0xbnNG9iwxxpvn4kyNGCObjZYlvTdzbUyG27VRS0ZHUk3HKw4Lk+Tx3yZ1wQLUAjGH7WcgG+Rd6/b2lhmDwpUtCys4BGEy2kLo11mgg8tIYZTJsDjAbz847TI/RO4e/Ap2IJ3tUfT/fkIWU/AA8ve9XTtHx2adcU6LHPgbTk6UpDpP1/jLbf0pLTJ9gnhjNMY6lUUZMXKKt82EUuZpBc7Hi9aAJJVoY1NZKgF5bkxKl6bFWXfWDtgXz0EDpGPCivculU7qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKEX0xEmFZcywHIJLDMeVtRKZRQvU//vZUVDz7Lf+dY=;
 b=QBzlgCEnLOjPdEH0o/6Huh7SujZ+0zK3Yl3gV6KY89k2nLjqkoHrNlDgTCSoFon6dEhkx0uCNAj64lkxmRLsG5rBUzWrH78BqJEhHn3Njt4xUXOF6gfMhNMnYam5MiEmrunaBfN8ttUNXspTN/f5Ucj/vA5XKE3d3EUn+5EhD6EUK5t7LgCqMbYLguipB3yW0kCd3HcpQT9OHDNPTdJ0bIEzZeEB8Mp1srMO+HjnFck6wwbboSbwTdpw485QZicmaetP4WRM8x7anz5iy1Vl5p4GG1bcUJksoU1kBWMHMNzBulG0NVGhVwLMFGor74DkWCQmHrUtG99Vz4w5RAdGYA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA1PR12MB6436.namprd12.prod.outlook.com (2603:10b6:208:3ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 03:47:35 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 03:47:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Topic: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Thread-Index: AQHYjU+OpP/4aLhN20eCCMO4rbOEoq1qEloggAn4zwCAAKXGEIAD0JkAgAJ/vUCAAK5SAIAAADPwgAALqACAFTnxEIAArU6AgAAAQ5CAAApmAIAADr7g
Date:   Wed, 27 Jul 2022 03:47:35 +0000
Message-ID: <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
In-Reply-To: <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd85f80b-6d51-4940-39dd-08da6f82be80
x-ms-traffictypediagnostic: IA1PR12MB6436:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vP2eTAyHvcMcqG4y514Nfe3V1SLGFOlQQytcN2GQ6qjuGgVGC5RRUaJM+U5NuSrOhex2q4yFwGAk3tYvCFD0aT6uXRXPw1RKTI3z9KdxkPOEJLKCris20opwqs5CAYsznIA4NKNCYD3g1Fb7IxZhCir8/eUkmOo3MqK/MpKRPJzOX4xszuvMc/EAp4bOmnJNFAeoNknyNr/cqRPWE0YHeWsBBsygQshlZV0J3WfJsVpykdvCFvvM765PlpEwQMbnUFegOvd3f2si4TWHqEr9qFUGgU9mAcMuveGeY2zzI8ZO0/VcT+hLLiP+QQKhvR+POcHrc4NWVWM0YUCka9sR/tufSHb24nz9SVciuGfvzf3tvgmjX0wxN/yIsPtkffEcmCEv3EAJ9BA5a9JpE/dpokAQ3igdTei9zouBrqlDReshvX7XebW8H0YO51oxJl8SQiixYVArlHx9JlGAVecBxTfXDxJnAbi7BI/wXqZrlNzwMD89zza+BmaXTQ/6GLMg/ouVkx4nqeqewwOdlMtahkeq3IvsPNlei/5/+Ppd25iVLYF9wnzK80LtpjmD08PhJpm64DjsLMhKOeiR8tdV17cw5zlw7K28Py9a/79V966sYYKtcVNlyS6PNyDqdv+ENLjBedQjN6CSf2SgUcapD5f89KqO0x6WHt4sw1snO/AXbf0f2ZhjF5QgDVC9M6benZ9RnqriRFuV0Ty9QwupzmKbVLNL+0j7RSWY1+YLYCFYifowGsfFvh5UPbrN5MUs5+biSaTXTj/cuLTJ8d55ho70hBggE1/PaPoSW8/u+TsKg4H0jA3Tq2G0Je+teOoQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(478600001)(71200400001)(53546011)(41300700001)(7696005)(6506007)(9686003)(186003)(38100700002)(122000001)(83380400001)(110136005)(38070700005)(8936002)(5660300002)(52536014)(55016003)(33656002)(66556008)(2906002)(66476007)(316002)(54906003)(86362001)(64756008)(76116006)(4326008)(66446008)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUhFWXI4MllNTnpoYUwzK240U0FIK0dFRUZCUWdoU2xvR1o5UHBjNGhLcXpO?=
 =?utf-8?B?QjNJc0p1b0QyWDhqaEY1TTJ5ZlVaU09icGF2dHZGWjRxd3lsU09PZmdFbDFy?=
 =?utf-8?B?c0N5NE55bXpTTTRlZlpJSGxQRXRaLzJINElHMWRzQ0Q2UU5aUExScDFZeDhh?=
 =?utf-8?B?RFpyRTcwSE9kWWUwTzk1dXhURTBMekxmU1VLMUllWlZMN09XdHBYaEh0ODFK?=
 =?utf-8?B?RVlRNWw1blY0M1hIYS9SNUgrQWQ0eU01dGVsQ05wSkpKeHNHNi85S21SUmdi?=
 =?utf-8?B?cHliMG9JaDM3bEIyejVUanMzWmFyb3BoVkdvcW05bnBmL1NCNXVIUUlQVXlM?=
 =?utf-8?B?UlBCenJIaFQ2N0JqYW9PdlJDenFuTmdqOHFJM3U0cE9wTTNOMVR5OFIxTGl6?=
 =?utf-8?B?VkdvNlh0d0haUHZLcHR6TXQwUzh3RWE4WndhZVh4ODNqQ245MHFXRzEwQ3pC?=
 =?utf-8?B?WlhUckJXTUFQaXBxWnN1L0QwVHpRSGlWY3oxNDFlQjVMM1ZSbFpDL0NIT3Fh?=
 =?utf-8?B?T1Eva3pwVmtocWpxdFBOQTBQem14SmZhdytBMFNxR1k5WWJxMHNMVG51ZTln?=
 =?utf-8?B?TE9SZmdXeXdWaEhGR1dYUGM4K0Nxb0NNckxiVnJLMzJheGVwL2ZyZ3VkSGRk?=
 =?utf-8?B?MWpHdEpkZFN3ZXdYN3JrUm5QTmlOSTdHZEI1QW1QVVk1Z0NlT1hRd2NJRHBW?=
 =?utf-8?B?T1FTRmJvc1NXWjJmWHdoY2pjbnB2cnBrSXRFcnlxRFNVdFBaMnpYNjlGMDZl?=
 =?utf-8?B?YXhwQ2hpV0N3a1pacXJyZm54aW1MSDBNaEtoWFJ3UExEcWlTU08xcm9mK1pR?=
 =?utf-8?B?bXZnbGZlTkV2aXBvRTJMM0tqNnFmVGtnV1VyZDRjWjZxZHB4elNlbUFzVm83?=
 =?utf-8?B?M0d0WVRYRTNGNlFZdmpXampOamdUT01TM2w0T2VLcjV0cjh1Z1JwN0lxRVBO?=
 =?utf-8?B?c09rYTFDTTg4OElGK0JXYTFjVTUydXZCdFp6N2k0WE5OKzBYTzhSc3pWYi85?=
 =?utf-8?B?d2xHTWh0eStCOWRvUkxoYU5iU1B3a0d3cTg4N0FMV1hyY0pTV0dja0kvQUxY?=
 =?utf-8?B?V1pvTUdHVkp3RmlSTi9KczgxTU5QUjhnb3Y1RnNOY040cFI4ckYxanJnR2dp?=
 =?utf-8?B?WXlLNFJrZmV5dFdvYkpFbUFSb3E1TUU5TjdqWm9aTDdaN29HeHdIdlh0Q0Qw?=
 =?utf-8?B?TVlnZ1kyL1hZTkU2RjJ1bVhLZFhxUXptT0lOSzRpK0M4Z1JFa1pxbTdXakhU?=
 =?utf-8?B?RXMwMStPZWE2RzZnMVIvWGdFZU5ublVmYTBnQUhhOEROS3VsWkt4Zm5ieVFK?=
 =?utf-8?B?RXhOaUszOHRYbHFFL1hsRG85cUNla2tQb25MdU5oZ1hKbHFtSkh0dEdtQVlP?=
 =?utf-8?B?QS9LZk0rOUVmcmdlbWd6NWFhbk1FR1RRbnljOWZ4ZFZMcm9uWDRNTzhPTldJ?=
 =?utf-8?B?a2I3UmE5R3kydWg3RnVzQjQxRkVDUTV4Skt2alk1ZXRxTkdWWTZmWnFSUzhE?=
 =?utf-8?B?MWJkNmhvcC9XOTNBaFoxZmd2c1QrRTRPamNJNnpIcjI4Qjc4ZnRSWmpseThW?=
 =?utf-8?B?ZUExNHVaTUV1dU5pUlBnbE1IcGt3ZlNBTmltNDh0TUJpc0crOXRzVG11cGlF?=
 =?utf-8?B?dG1XQW44MVZpSXdJakJvdlg3dkpURlBIeTI0L293dFhGazY5cnJKdHJBbFpW?=
 =?utf-8?B?b3plbG4zU2dNaEJ3Wm1rMUpQNmxXc0VwZmRnSERnbmdpbVhUUWJvYmNoOERT?=
 =?utf-8?B?R1Q3N1BuQi93dGNpdk8yNnlpcXdtYkxLMno4ZGt1VERpaEZqZ2JWRVlPdVZ6?=
 =?utf-8?B?amovc2pQSkt2RGFyMXhCRnY2YTFLZU4vNnZwWjIzNDQ2Wk00bTJ1UjBxVnRN?=
 =?utf-8?B?THlFZWlsNjFQdUpEOW44R3J4cEhVcElobksvRnZ1NXU3YThHcXZyYkNlTjRY?=
 =?utf-8?B?ZE1NUElhSlNrYmxNNStGSW5RRGdxVjB3Vk5QR2VKWDluVVVLNFV2K2dKOHpu?=
 =?utf-8?B?aFptdDF5TmkvdHpidEg5U0g4Yk5pa0RRMzdZeXdTamlUaGlFSjgyZVl4VVBq?=
 =?utf-8?B?dnlNUkVVWDJPMXMxUWcvN29xZlBBdnpGc1pTdm5Zd2RzdFJFVmhyUXpyTFA5?=
 =?utf-8?B?am1VWERDbzNZV1BNN21iQkRxSDEvL3VyYzdBZzN5aStLaDZxUHpENVNKZzZ6?=
 =?utf-8?Q?od8ebZ2JBZFRtwdXvntc0Uo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd85f80b-6d51-4940-39dd-08da6f82be80
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 03:47:35.8383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T30+zmTTE6/nbEFGpRAxIIy9B/ORSNdfUUGV1TrM92t7Jpa/WOugRG+k5ZTgolwVKfjvPCePQzGKz7hR1CaEEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6436
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgMTA6NTMgUE0NCj4gDQo+IE9uIDcvMjcvMjAyMiAxMDox
NyBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBaaHUsIExpbmdzaGFuIDxsaW5n
c2hhbi56aHVAaW50ZWwuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKdWx5IDI2LCAyMDIyIDEw
OjE1IFBNDQo+ID4+DQo+ID4+IE9uIDcvMjYvMjAyMiAxMTo1NiBQTSwgUGFyYXYgUGFuZGl0IHdy
b3RlOg0KPiA+Pj4+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+
DQo+ID4+Pj4gU2VudDogVHVlc2RheSwgSnVseSAxMiwgMjAyMiAxMTo0NiBQTQ0KPiA+Pj4+PiBX
aGVuIHRoZSB1c2VyIHNwYWNlIHdoaWNoIGludm9rZXMgbmV0bGluayBjb21tYW5kcywgZGV0ZWN0
cyB0aGF0DQo+ID4+IF9NUQ0KPiA+Pj4+IGlzIG5vdCBzdXBwb3J0ZWQsIGhlbmNlIGl0IHRha2Vz
IG1heF9xdWV1ZV9wYWlyID0gMSBieSBpdHNlbGYuDQo+ID4+Pj4gSSB0aGluayB0aGUga2VybmVs
IG1vZHVsZSBoYXZlIGFsbCBuZWNlc3NhcnkgaW5mb3JtYXRpb24gYW5kIGl0IGlzDQo+ID4+Pj4g
dGhlIG9ubHkgb25lIHdoaWNoIGhhdmUgcHJlY2lzZSBpbmZvcm1hdGlvbiBvZiBhIGRldmljZSwg
c28gaXQNCj4gPj4+PiBzaG91bGQgYW5zd2VyIHByZWNpc2VseSB0aGFuIGxldCB0aGUgdXNlciBz
cGFjZSBndWVzcy4gVGhlIGtlcm5lbA0KPiA+Pj4+IG1vZHVsZSBzaG91bGQgYmUgcmVsaWFibGUg
dGhhbiBzdGF5IHNpbGVudCwgbGVhdmUgdGhlIHF1ZXN0aW9uIHRvDQo+ID4+Pj4gdGhlIHVzZXIg
c3BhY2UNCj4gPj4gdG9vbC4NCj4gPj4+IEtlcm5lbCBpcyByZWxpYWJsZS4gSXQgZG9lc27igJl0
IGV4cG9zZSBhIGNvbmZpZyBzcGFjZSBmaWVsZCBpZiB0aGUNCj4gPj4+IGZpZWxkIGRvZXNu4oCZ
dA0KPiA+PiBleGlzdCByZWdhcmRsZXNzIG9mIGZpZWxkIHNob3VsZCBoYXZlIGRlZmF1bHQgb3Ig
bm8gZGVmYXVsdC4NCj4gPj4gc28gd2hlbiB5b3Uga25vdyBpdCBpcyBvbmUgcXVldWUgcGFpciwg
eW91IHNob3VsZCBhbnN3ZXIgb25lLCBub3QgdHJ5DQo+ID4+IHRvIGd1ZXNzLg0KPiA+Pj4gVXNl
ciBzcGFjZSBzaG91bGQgbm90IGd1ZXNzIGVpdGhlci4gVXNlciBzcGFjZSBnZXRzIHRvIHNlZSBp
ZiBfTVENCj4gPj4gcHJlc2VudC9ub3QgcHJlc2VudC4gSWYgX01RIHByZXNlbnQgdGhhbiBnZXQg
cmVsaWFibGUgZGF0YSBmcm9tIGtlcm5lbC4NCj4gPj4+IElmIF9NUSBub3QgcHJlc2VudCwgaXQg
bWVhbnMgdGhpcyBkZXZpY2UgaGFzIG9uZSBWUSBwYWlyLg0KPiA+PiBpdCBpcyBzdGlsbCBhIGd1
ZXNzLCByaWdodD8gQW5kIGFsbCB1c2VyIHNwYWNlIHRvb2xzIGltcGxlbWVudGVkIHRoaXMNCj4g
Pj4gZmVhdHVyZSBuZWVkIHRvIGd1ZXNzDQo+ID4gTm8uIGl0IGlzIG5vdCBhIGd1ZXNzLg0KPiA+
IEl0IGlzIGV4cGxpY2l0bHkgY2hlY2tpbmcgdGhlIF9NUSBmZWF0dXJlIGFuZCBkZXJpdmluZyB0
aGUgdmFsdWUuDQo+ID4gVGhlIGNvZGUgeW91IHByb3Bvc2VkIHdpbGwgYmUgcHJlc2VudCBpbiB0
aGUgdXNlciBzcGFjZS4NCj4gPiBJdCB3aWxsIGJlIHVuaWZvcm0gZm9yIF9NUSBhbmQgMTAgb3Ro
ZXIgZmVhdHVyZXMgdGhhdCBhcmUgcHJlc2VudCBub3cgYW5kDQo+IGluIHRoZSBmdXR1cmUuDQo+
IE1RIGFuZCBvdGhlciBmZWF0dXJlcyBsaWtlIFJTUyBhcmUgZGlmZmVyZW50LiBJZiB0aGVyZSBp
cyBubyBfUlNTX1hYLCB0aGVyZQ0KPiBhcmUgbm8gYXR0cmlidXRlcyBsaWtlIG1heF9yc3Nfa2V5
X3NpemUsIGFuZCB0aGVyZSBpcyBub3QgYSBkZWZhdWx0IHZhbHVlLg0KPiBCdXQgZm9yIE1RLCB3
ZSBrbm93IGl0IGhhcyB0byBiZSAxIHdpaHRvdXQgX01RLg0KIndlIiA9IHVzZXIgc3BhY2UuDQpU
byBrZWVwIHRoZSBjb25zaXN0ZW5jeSBhbW9uZyBhbGwgdGhlIGNvbmZpZyBzcGFjZSBmaWVsZHMu
DQoNCj4gPiBGb3IgZmVhdHVyZSBYLCBrZXJuZWwgcmVwb3J0cyBkZWZhdWx0IGFuZCBmb3IgZmVh
dHVyZSBZLCBrZXJuZWwgc2tpcA0KPiByZXBvcnRpbmcgaXQsIGJlY2F1c2UgdGhlcmUgaXMgbm8g
ZGVmYXVsdC4gPC0gVGhpcyBpcyB3aGF0IHdlIGFyZSB0cnlpbmcgdG8NCj4gYXZvaWQgaGVyZS4N
Cj4gS2VybmVsIHJlcG9ydHMgb25lIHF1ZXVlIHBhaXIgYmVjYXVzZSB0aGVyZSBpcyBhY3R1YWxs
eSBvbmUuDQo+ID4NCg0K
