Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ACB5B0D16
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIGTSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIGTSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:18:09 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECA0275FB
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:18:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AA2x4fI3pbZYjhE4Gn8MKPhZtNUazhRCKKubpZPyXNyNi2WYe3BQSqRjbd/iQqv5nU75CDXx7GWjwZ++NT6plw+BPwirI1ZYJ3sx6RmZ5AU3Dff3FDiJWhSSEqxFWnGRS5WucLeJljPkj2XjRfkaBg7V6c0Yl8A7zzsFO+WFNYTxq8D7LDSyjY6lMjBAwqbVriTYz3kpa38nFjHgcvFII05ExeCc76zqNbBAWpX2VEzgpmzLr3GdpxgwKNcUyab6Ok2kE95Wu7L8VHxdu0VTPQoG66oRYp1a0kJB+hXtf/0FMZ9EhfLf8bw/6eu5KVAS4oeHJ7RYTZzS8Yrkz3B3Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8E5uKyIAz61UDoyDfvmKExIAv8/JEa+zKEGFQpYiuA=;
 b=m/khs4tVYlbWScyuLpultw1d2dVa6KiG9Vg00co6vthkOQqTd3Qu7ehzqaBLLJ8L3DpfbWo7SKSAViws5Uha1YZdMeRpKTbceQt2Us0hgIbEqNtv4QIOXY34QOx3i81oXeo5wbHHH2VQ6QDvNCmCSJrVSLqMhkJ40GYuKqk+SM1NlvC6CPbuTP6R31rynXdzXPdQ92zYaglf+VmQMrz3N7Srwxioct/v1L9heQ9cKhDNVkHzdQWNiFA38L0v4VcH0t1FGINDZNdSiIIQTO+yfa+VxW8uPDcEcNq/fknCkU4fRzf9/IZYf7wXugmB23cro2oNBQJF0Ryvr069YEGLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8E5uKyIAz61UDoyDfvmKExIAv8/JEa+zKEGFQpYiuA=;
 b=uZdzighVu95IVYEQK9xHefWvIK8AnJ3HnPiyMABNunWDbofuBSYBAYmFK5rnTv1ptUW0RvCKMZ/ceRrrbHdls9zBPU2OhBrnnTC7GYvNgOE9UZxp8Yf4Pp4iXSGBvRloWNEw6PGNOZkE8q2lMx2nRx/LmWZ6iR41aRnkupdq3nR/S5n0Uf38hUGwfTDTp8s3CBhn/WKrD84eE484ZOIcVAe6tNmlPoFiGIuZbnQajZucmmgQ29S3zNTOVR3hlro+eNCsIRteJSUGnsWD2/0XfQ2b85pbpkZx611B92rmqyQz4A5AwzAxD653X84XATUrURHbQSaEEZGMTWeC28fJDA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY5PR12MB6576.namprd12.prod.outlook.com (2603:10b6:930:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 19:18:06 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 19:18:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaACAAAQwAIAAAFDQ
Date:   Wed, 7 Sep 2022 19:18:06 +0000
Message-ID: <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220907151026-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CY5PR12MB6576:EE_
x-ms-office365-filtering-correlation-id: bfb14625-a4eb-4f63-3276-08da9105b183
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKoBePRFZWiMs0O+4FAjRzCyd2SHolK1F6InMGGJSDiEEdmlKRwwcnTKoubqOaK5Hww6xBvvDc1KtHDl1Ln63UPlzDjw+7Q9GNCllEJiNAGZDQhvHvtFgqrG8GUddsi/PAD4VlHOpAFDEsKuCIYzDCDRk+uks8yWh3yiIhp6Hly179u41xQg+9ZpPMTQzU6qmsrGMvdIzc4sUAG8f95kB5hd9ttoM95/fCdh8oZdU5MeJbnpxhCjDdKTq9lvhRWBR/Mxtmp4eulEdjSpobZdf8QXo+2IE9bA6WVckM1UF8Bf58o/TSlFIKIX1REqxTBRuPdTNQJtNPBaUrCadGpy/vqKgQXABEa1Jmy+pYNPrIKPp4RYb1iNYmzWUtu5bs8t6vaDLoHsAtE7AnV8A/3aKHr+NSyli0KVUh4f0z9l6drRU8hb2FH4mHZZQwjC6S9TLocrnEvyTlXdOrD9peTMLVKT6BL32/nXLhOP1zOGC99UOuGU2QELZkTH4o3CbhnddNReRdAGhVfH6K15UGF/5e4jZPGCj1O5+F+7coPxWezL/+sy/hsTUJPhSefrFaaZYxqjYCj+a5zuOSVeWcsePcytjhWzxqiWqZes6NloYUVWDaXqn1MPcdmDsCP5qgAIX634n9gdKMlPda08y8+2M07PTVCmrlEClUahZZJYeQ5XnQUcivxVb8ikx6l11XzQITOlyewVvhEnfo2RSTMSsdLREK++3ygmxDA6nSop0y7AyPPpCuNaR95fRy09ypJvGK2ng7UW62J1jkyd8Vk0VrVB6TKzfNlHuLZA+KM9k7XRO3Drc2+LBqxEuO6Oh6VPDjUyradpck5Cyy+gWvdAQYatdU6N2mEoR+IdOWddYtY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(83380400001)(33656002)(6506007)(2906002)(26005)(7696005)(9686003)(55016003)(86362001)(186003)(38070700005)(38100700002)(66446008)(66476007)(45080400002)(122000001)(5660300002)(8676002)(966005)(64756008)(52536014)(41300700001)(4326008)(316002)(66946007)(6916009)(54906003)(478600001)(76116006)(71200400001)(66556008)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4JkppBkeaRWTfnfVVYPiBIKTLwy+Ya6VJ+SI9pK68YLWpC/Z3F4KskyKKCtO?=
 =?us-ascii?Q?ofRz2rSh/brQi+wZKwS9qoZZotgusMitRPPcrg7RwzKTM4CdJ2rTmB4r0CXY?=
 =?us-ascii?Q?EPaUY2kEqAmaIPSjWiORw42EVkldPAHP2B/GkQFiHxSjBKLlsW8BkVpWqwZm?=
 =?us-ascii?Q?nuCL43PhG0vbONj0/pojQ/iBZIBaEBDYXvnkWHn23DtxgFZWNinZwSdAOoer?=
 =?us-ascii?Q?Zge9BJWR38biM3z+zJUhPH+8JUpImIqHJRWXHmY1ET/+ST+HgvrMpCH1y0g/?=
 =?us-ascii?Q?mZValuWx/ts4NT8Funeb6HzkNMdr69O3q9UaIDbVLFqzQsyah7bErE5NwJUo?=
 =?us-ascii?Q?ekTYqIX6ovzIOJRVEaIJzz8gkrheVXRdB9PRX3qJElheFJXRA8+eEE+zcVPA?=
 =?us-ascii?Q?ku9zy3UKNqb2NJ9tWlP/nLJeg/IZUeK5OoEil4mSdezPwN4jOpF0KLW+E7N5?=
 =?us-ascii?Q?CBbTkU0Wy9dqQu1nPaNl3iZYbSdnr6P0tQpRxttzy87fIX3PK8wN41L2XANY?=
 =?us-ascii?Q?JrIwIFklvy6jCW4y2n/JqtiqGfXqzleh0g9pFPt/4e1N6HkEAqG30+k+6tD8?=
 =?us-ascii?Q?Jq/MO0ABJmOYL8GKIjJqZwmtu1Jmy/X7ZCmeeTGYlWX3GgSwJoqW+xV1wP+7?=
 =?us-ascii?Q?sKVFcV8Qc/bJ5t2/Kaeb7UE40rZI0hN9M1s53WswoHioykcs9FqUcefpuxH4?=
 =?us-ascii?Q?l3zX2l1/E2icT5uGkPydgia6V2wIZ8a+uohM0NSApr1K5bRqgVRTj52iySgm?=
 =?us-ascii?Q?qz17jN3HjtHa5LWhbSxdZiexF1M1xZ4jxugjADotu1bcZaxjBb8a5e/sy5RA?=
 =?us-ascii?Q?6xjKYIXB3d5ld4bjeIemBpbhO3Du3w+3Pt5j3C5j8gHrnERytUNZfieDBWkt?=
 =?us-ascii?Q?mH4zkwHtJAhxGFov7odBAdZA+rUrsTyBnnqhrzutpsdEQ0UhbRv4HjmghhL+?=
 =?us-ascii?Q?/MK0N4tLQp/MFBS4gf3e3KkOLMyz4+Qq6LN1ADnFH/iwcB4SXozVznr1m6v1?=
 =?us-ascii?Q?R+Epde4hKNwIhuN9YoRt5r8w7mDL4ehUVuWg63gG0YLVA6NwidOBPJx4rSMJ?=
 =?us-ascii?Q?VyZc8Trb4jhFiMfOJ7YJcGoZkK/KVDBn435W6nqo9LuRIsrY7zIGk7rmZtYd?=
 =?us-ascii?Q?SdczZNNebJMB2cs0tF9qIKz1JQnNkPe0I+oKiLqn8GvY1Dzu74SVdJqs4Qa8?=
 =?us-ascii?Q?F8PUScyFSkHKFVFG42U2XBp+JwBITDVR0TGlMuhkHuS6VJWc1vxElRJ9bjJ9?=
 =?us-ascii?Q?Sbcg1Do1h+rJH9oPvVfpXvwtrVEQH3RQMTKaQGQ9aYiZ5bDKYlPJDNq9pqoG?=
 =?us-ascii?Q?5GxDvJ9YFKHiGr46luhxsc2r0mS7i8WVRScxwVYqns+aJXR7BBKTSrBY8G2+?=
 =?us-ascii?Q?dx+kPIg7MsiuDAqYbBg/OduBezp+ef0rLD6fyTmjhFjGTaCmvd53cBUlrRmq?=
 =?us-ascii?Q?sE8+bL15Efhg0P3KFReL+V1yvudsPsxPQdhtiJdAkD00kt9jI0d0Y88aAeaj?=
 =?us-ascii?Q?Gcnx6fZxLhiS6TUm1Fsukg3phJjbn/wJE68II4EZiPpk6cUvI3VvjQx2qzrM?=
 =?us-ascii?Q?TQiwFTGX8WNOUtSsL6w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb14625-a4eb-4f63-3276-08da9105b183
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:18:06.5063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYGSiMzEDIRqayZDOOw/18lZJz+KGRrydLXE5oZVM9U0c56Cz1Gs2PTu6xXpuXejFfRqiBwVWsD8UlfWWjK9mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6576
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Wednesday, September 7, 2022 3:12 PM

> > Because of shallow queue of 16 entries deep.
>=20
> but why is the queue just 16 entries?
I explained the calculation in [1] about 16 entries.

[1] https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC419@P=
H0PR12MB5481.namprd12.prod.outlook.com/

> does the device not support indirect?
>
Yes, indirect feature bit is disabled on the device.
=20
> because with indirect you get 256 entries, with 16 s/g each.
>=20
Sure. I explained below that indirect comes with 7x memory cost that is not=
 desired.
(Ignored the table memory allocation cost and extra latency).

Hence don't want to enable indirect in this scenario.
This optimization also works with indirect with smaller indirect table.

>=20
> > With driver turn around time to repost buffers, device is idle without =
any
> RQ buffers.
> > With this improvement, device has 85 buffers instead of 16 to receive
> packets.
> >
> > Enabling indirect in device can help at cost of 7x higher memory per VQ=
 in
> the guest VM.

