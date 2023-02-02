Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1623168847C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBBQd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBBQd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:33:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1932130EAE;
        Thu,  2 Feb 2023 08:33:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RicvLdrYgYUKTJoMggd0MOt99JR7P1MYEnqPa0+EtWyPhBrhGQQaH43lL5TRnfx8MbZW1Oyu5Hh2G0SHpiVWXmxki/Cmod1sx43XpH9Knhhiuhg2vFImZfDsDSasob0sg7jmLoVmxawZv0rpg4835QF1YNyh0jNkhPMkMA0h8jYTPyCnA/gWYdOf0SgySzrPsDTsSJRfYDqqJp7bsIJr93srIpKx82L1cOkzISW3w6zX3cHCeP4v1eDSVzUXwqVShUD49jmZCx5TQsNZkwFKFLsi+ZM0/yhmaOBlDzw9vLHtzLNYyOVtzchTwvGJCoRYUtmc6Te9qx6kESJg/V1Gew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ha8j796OoobE2thJXlS+G5NE86llZjUZ01Naf3gJdzo=;
 b=ITZy52OujPtlfcv0KKWNYNeG3sWedvZmWioWTJXgCfKWLZNbT8fBWuZgegrsxOGn588ShYi62pClMmTxrMexPqHYusVtcmrmC3DOWC50B8mxaCM1McohkpYBBAQiRfHQA2A3swIycHMUZmAmCr+/cg5IeKn+LyBy1z29vn8Epg/2aoM5O4Ls0tBeW+cU1fODlM2rp7Hx3Mn88qeXGy7aBKraAJL3etbbx4Jx7GZ2uFjQKAwmUqI16gB8/TVt6LTut29IR7jpetd/SF+TFZhbzGeEcbo4g5HpodeKttaQB+MZY5xht7mNUEoPCXLb8f6OaPn5lpdNJ52qgcUADaLzrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha8j796OoobE2thJXlS+G5NE86llZjUZ01Naf3gJdzo=;
 b=DDeJ/jCKoHBAJ/y1p5qhh8e3r7l1JxhigYzrrfYkTjJPDqBGYtx9+A+X3c0MCpLtPvigUfx06JY7ULRDItuc4By5KhRMoiuzuNPiKAQdr/7Qhybyq1MZA4SIfrqtCXx8yrjgOjR7JaAtnJUOq9s5kNAT24J6AiwX/+/eCcX9eR3oBd/hZAHt439pqEt3S6hqnbsK1i0zykAFDrb7LTfXNMyMjMh2s1ciH+bsv+vU4nTEIhIgVvnb32zmtxjwIfGHFPNj8/3rjk0ZYGo3qFxzf28VITPaw0WVvfOqHxp04VWs46+6C1sYRR9KBfnVuICkQWinsgn3DYa9krCTz3E51g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 16:33:22 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0%4]) with mapi id 15.20.6064.025; Thu, 2 Feb 2023
 16:33:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH 2/2] virtio-net: Maintain reverse cleanup order
Thread-Topic: [PATCH 2/2] virtio-net: Maintain reverse cleanup order
Thread-Index: AQHZNsNmqB1HoihArUa+/kiDXzADNK67lZ4AgAAtS/CAAAqjgIAADMvw
Date:   Thu, 2 Feb 2023 16:33:21 +0000
Message-ID: <PH0PR12MB5481F75D8D5D5B5DD9010798DCD69@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230202050038.3187-1-parav@nvidia.com>
 <20230202050038.3187-3-parav@nvidia.com> <Y9ur9B6CDIwThMN6@nanopsycho>
 <PH0PR12MB5481C0C7E46B5DFF85178792DCD69@PH0PR12MB5481.namprd12.prod.outlook.com>
 <Y9va33VLJ/eRPUbW@nanopsycho>
In-Reply-To: <Y9va33VLJ/eRPUbW@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|PH8PR12MB7277:EE_
x-ms-office365-filtering-correlation-id: 5d2772a0-e414-44d4-80a0-08db053b3309
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W3lBCh6AfOe+DZZrTB9IK2LhWyQiKPypx1NoUBSTWOlF803Rv+zHFr9qNeaeXnC0p8h6oDYTXNMVfIFZjWufrjwyWil8i9Y4qCy0MZVlfPyj/qJRwXPkWJrPSYNUnZBy+GmTPyRSrfx/HFt/iO5FWZ49hdtR2THTrUDkqCdZPvNkf2J/GvATZJz2zUA57bADESPdLGdtBB9CVxD92hKTmmVeFPLeCpI28vdzGOTBLy6tF0edkjw7o/+d3mOqqcK4McH8dLmYxBwK2XKGlkynlceHvZq8IoBv3btnGD1IEJQtPH8CnhYibbqDTp8s+bsyodUq+c2CHjPIc+WxCCX6QbN8P2mDBAF0BTd0CdvQE92MJU1G26a7jfd2mwIJbvSOBRP1IcwjCa1vmH0wdjebUcGg5E2xuAkFuyCB99zC0eC1/WBBX2Wlf3/RklmijeqwSBV5TMtqUCncwcBOWJmc2cBnz1c6/ZVDUuML1TOEEU6sJwEViKoIsF4c35g7KHV1PPz5C/Jou6L5tlJXbPBm4tLIwnOEFuNK5eMLagKPtBjnIX7plt/yRm0LrZOnJWyoMMEqne1JbmEsHJtEd9Lcb6J7Qsjjz2Ci/ELnPEc4eXDBz6SY7+Jb778mSLdnG7ttHu+zMlU2pSpxKouJ0717tA4MN2asI/6jxAA3S5LFZ8Xo7XhkfV5SjbieKS/NxBXnp2x5HaC0uGW8+iIkjPK7MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199018)(26005)(186003)(86362001)(9686003)(6506007)(38070700005)(33656002)(478600001)(38100700002)(7696005)(122000001)(71200400001)(2906002)(7416002)(55016003)(5660300002)(52536014)(8936002)(41300700001)(66446008)(66556008)(66476007)(66946007)(76116006)(8676002)(6916009)(4326008)(64756008)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RZvFtBnBpSMmYgwlvm0xzICBnjDd0a9+DW8iIH2nQxiWuAxx/xbWzvxhVAVW?=
 =?us-ascii?Q?M/WPqjuKIG2/+yLbEQCDBmdgNFe8g1ghm7OnbP9zAHHhlb+Tqns5ed9UWoUD?=
 =?us-ascii?Q?9pC1zHBtUfW5q4Wdq0ywuHrb0sCSZegHOpGGRVFaklW70gAfatPLSZqBMh1I?=
 =?us-ascii?Q?wloR32X3zaGmRuge/De9MZdFSXijylMvA41FRIYnN23Js9q7OQI9x8d82kGh?=
 =?us-ascii?Q?cp4CQoMiRjq76FQtxw0qe4czz1MQrCKDQec8V3ZdR1UDe8RhYKCeTFpve0oD?=
 =?us-ascii?Q?kUtn7ZfDCOFkFZVMKAMaxX5goJwO/CtGrCLGqhxWPq/rfemWbenFzc4hykvc?=
 =?us-ascii?Q?6uVudZKd5B5M8bd/zdXfPzMg9ANx+j1tHoRHeL+JL6faMecEjb/Lh7CbpYT9?=
 =?us-ascii?Q?U6Uao14/6bKWzcEeLBegXqQbb3z+SDcW+RVgPZc5pWw8V9L1ULyms68W8IXP?=
 =?us-ascii?Q?eK3afmiZzb1eXfX/cmmPznUsRzL9B5Z2VxfxajxpgZoBK/epe0H+QNjAdK43?=
 =?us-ascii?Q?7NuSxL0Vgr7WiQy905IYRt60P61pRmUKJy24xkqk9vIHuKrHCtctlreILSwN?=
 =?us-ascii?Q?YFGeCojPXXbyzPaibrVuJULFMLKgSVLw8zqJpkZ7C8b+WmfbFiXmwDMen7Sw?=
 =?us-ascii?Q?djFyI7kKBzQgrUTHu7LgWDwicVOtbKVM748OBTWNCcKfYT4T5vmG6+iOq+Pe?=
 =?us-ascii?Q?op8yDJ5TcJ7D1X7bP9eS4pyaPDFo6wxqzM7WlZUR4GkFxwQfqYh+8oB0K9s7?=
 =?us-ascii?Q?OSUBifs/IbXIsDX+0dLgITwA9GIH9EoznF/r13NMfZxJlDl/r2PaKiQJtHP5?=
 =?us-ascii?Q?XtFhU9KzKwIMJFT+PHE4IvrROYU1D1vMDOD0naTNeHF1cs0CPSPLIIyOJgoY?=
 =?us-ascii?Q?9+FhvMdCit4QPWfHIKhc5Q5ufd149tPXdmiHI0cCOtwM7Nd87NDbRXqY2g8z?=
 =?us-ascii?Q?npg7jhrjO2/hk1dgdKnq2hZb+vf+w/YyX3urSKokhlCkkqRm78Q7ukJGg8Si?=
 =?us-ascii?Q?MiP8obiFrPcWJS9EV2voBhAIfQZpGe1ksHgzD9iIM4bpNNrLXu3cGH+etka/?=
 =?us-ascii?Q?ThKeKqHwevgtPXGiHA7C/z2u4oBRiG9H77ueyW0sDLiorIt4lTFgU5qZZvMa?=
 =?us-ascii?Q?DvKsCOIVKxy1PPktkRCN9coAD6OK6un6Yqf2yxioA8f9s/PRAVdPQbEz/uGV?=
 =?us-ascii?Q?HLnF1ju2Dr2MbvMIOYpqEmZ5VKla/wI3HaflEErpKf9OZhah68v3xPEn+pOm?=
 =?us-ascii?Q?HyfBMh/ebdZtqwNlCyJBGPkpWGwnOslf6Zc/9SzG3/THWAJ51C8mFO666y5H?=
 =?us-ascii?Q?ijn0sDckFguQHpEPc0t5yNhbenNI1d39iMt0QuM3K4CgB+6xxpbBOHwGwuBE?=
 =?us-ascii?Q?KDHowXHC0TqVb/Oq7I5Ke7PH4dCKs8rak1MSFQn2zrCTKg4rkBAy+T/+F3xq?=
 =?us-ascii?Q?nLVVNfl2npac1jxXTRBMvyFuesfpZS3w9MgEUvNZnKxUefbjoAK+4/iNdfqD?=
 =?us-ascii?Q?3lvUyT7V0zgw34ctHy1s/zPggNm2F8qSVOKxOUcZcX+C8+Oi4DY7cpyXeFYB?=
 =?us-ascii?Q?s4k2cLQ548yZuKINH/M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2772a0-e414-44d4-80a0-08db053b3309
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 16:33:22.0058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O0Y8gj3eDZ8EfIS+pN8jZSs9epHDcGNNGOC7v3UDckqDCFXt1Z8dhwvB88q3zLMnKspuBj7HOGkhge28OiAKzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, February 2, 2023 10:47 AM
>=20
> Thu, Feb 02, 2023 at 04:10:56PM CET, parav@nvidia.com wrote:
> >
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Thursday, February 2, 2023 7:26 AM
> >>
> >> Thu, Feb 02, 2023 at 06:00:38AM CET, parav@nvidia.com wrote:
> >> >To easily audit the code, better to keep the device stop() sequence
> >> >to be mirror of the device open() sequence.
> >> >
> >> >Signed-off-by: Parav Pandit <parav@nvidia.com>
> >>
> >> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> >>
> >> If this is not fixing bug (which I believe is the case), you should
> >> target it to net- next ([patch net-next] ..).
> >>
> >Yes. Right. First one was fix for net-rc, second was for net-next. And 2=
nd
> depends on the first to avoid merge conflicts.
> >So, I was unsure how to handle it.
> >Can you please suggest?
>=20
> 1) Send the fix to -net
> 2) Wait until -net is merged into -net-next
> 3) Send the second patch to -net-next

Got it. Thanks.

Dave, Jakub,
Please drop this series.
I am sending one by one to net and net-next.
