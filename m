Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4DF453E4E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhKQCUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:20:45 -0500
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:22240
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229910AbhKQCUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 21:20:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4YofAnF4eSIIyUHDVoWqvuxeta9DBaLEt7yWLNM0pFf8T4iZbBsZGUG5bCh7S68sfRmM7MbkmYMpekHsFd8yynxu1S1huZpKC7rIAU/SatD9HNPrFBYp1u5InMjcHpkbP513WSFJj+GAVbPnZ0yxwOtLSz9PP9KaQkwbzIwfaHVy+0B60OXys6Bv1xO70JgRrs6QQaPQitnl7jiqky0T/RmZ6W6uwS8kOUcQjAT61Drv00AANIRkQWyczFNhGc3vBZEbTbMVc9GBgsMTffqrpI6wijaEza93Z1V5dUEAzChW8wSv/nqyS9ZSFL3ruydtP7BE9UHXmYXY1EovtbCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8JNqI5fPVPygsOUum8tZJfpF8L43Cxn5mSJBJ/wrYQ=;
 b=ihew3l8Sii1pQMKJ70epCPGd7IJNMK1Aqe7ta7lXOdBkIIqfZQGQECzgHT4jUzQ8pq1tVhAlnZnf0JEEEBMseEjbyjx86HAjT8GkIEw95FJimbcQz6OcJqqb/X3hsm2jvi9nEBLvVNhTiwf1rECfN44VmtlMYZ2Df5cTidL1OVN4ECiSSHlr9Diktqu2mlT9S0DlFYsI4ZJlRTlvvlaZXo5/BIDXq071xLNwoIB1ZlFjeFVRJP8uuSkNlqZhAW0HT4Rp3qZGBhe7JEmmzKEJpjFWNHtbQja1FtZ40We1c+46sdY3oJ/BL3LPF8020xfMiU7NW0dCItwRbEYXF/gD6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8JNqI5fPVPygsOUum8tZJfpF8L43Cxn5mSJBJ/wrYQ=;
 b=rxtGd3BQ0I7541QyvRMcWx8hMFBy70+JcERwc6qPdGzWeF3zGwF7UP8Ridnbh/YLProNBIokOCcxaY3obsmJsPdaVw4ljWocvFa5tsteFiJynN4v0qDTP0yhoLioF/E6q7L1DnZAFXW6xTvg0YcXeXNERkL4EpVnOi67tMkiqQo=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by MN2PR05MB6174.namprd05.prod.outlook.com (2603:10b6:208:c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.15; Wed, 17 Nov
 2021 02:17:44 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::4975:27e1:d774:269c]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::4975:27e1:d774:269c%3]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 02:17:44 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>
CC:     "jgross@suse.com" <jgross@suse.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH v4 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
Thread-Topic: [PATCH v4 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
Thread-Index: AQHX2zqYqFtbOHqV2kyNKuj91cnaBKwG/CIA
Date:   Wed, 17 Nov 2021 02:17:44 +0000
Message-ID: <A5154685-6AE4-46DC-9EE1-A9CFF1BD096C@vmware.com>
References: <163710239472.123451.5004514369130059881.stgit@csail.mit.edu>
 <163710245724.123451.10205809430483374831.stgit@csail.mit.edu>
In-Reply-To: <163710245724.123451.10205809430483374831.stgit@csail.mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5685153f-d0a3-4dc9-003c-08d9a970711f
x-ms-traffictypediagnostic: MN2PR05MB6174:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR05MB6174E3D0AC9C1ABE493E8C40CE9A9@MN2PR05MB6174.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dKEKp8zYEH66uygQMkYnCXndjBCxtXggSnRAwjUHOSzCeByCwVpfnec6oPVHWnh2YA2NkR11aZWpt+HrVXReInJot01Xq2qiQ/TuPt9fJnKkqD9qt9t1ZxoIBnle95e+xeF1zo/CtlalITK+TXLBo5UaEoQJPUfC5Gc+B+CoDDAano+7LGt8unFCKfBtT2/Yac9Y6f69+NZ7pxa7MxwrTAVlRdcGKYYVw8yr2I6mwG3jfF8EaozQq/UmhjR+tP8hVoSWU6/fFYVXfHHCNIX1wTUUIf6MGdcnhIiOsPFyLf42oforBoH+GHlHMF8ToCbeAs/PgR0wCgs6XpsB0ysYp5puUNFxs9vudlNkROllG2QQOMuy25ijtRuykEeoWC7gRa4Lt+blHQgM3ww6prO1ANdsFEbXMS6pGjOgq8vH5pKfeaH3oznw7L6CKS4KAEOP7GIbhR23lUNiGLgrygyYgUtATPoZFfVSgvdu8WSZ0UTFqLlr4GSSZ5Bb1kijgm6gpgj14Ku/Rm9dQYdWBESK0Ub8LelQd5yBj/qzRItzZvuvnpmJpaB5Hqky0hGH25jH99siPWD7szaWT/n1Ll8XM+B9ilfs1S92UEHusVy9HW/fFUTcQJZ1C3lwbfsB4pNttgOSbSB7KBlkd2kTQQxe2fV9Be8iiY0AoIkffHMwO8aYv+6nPDi8bistiUTlXkADlC96QNKtZUvTxWkfeTz4FJ4ziDpyoF69HzaUxcChKCY36/7LW7uRfpixn9ZDeRcmF0zbwBJWYSY5sh2qKBp/zwiXKt4Lw+NbA7RzAFInsYA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(7416002)(6486002)(33656002)(2616005)(316002)(6916009)(38070700005)(76116006)(8936002)(83380400001)(26005)(86362001)(36756003)(2906002)(66556008)(71200400001)(6506007)(53546011)(508600001)(5660300002)(122000001)(38100700002)(4326008)(64756008)(66446008)(54906003)(66946007)(66476007)(8676002)(186003)(45980500001)(223123001)(130980200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G25Z+2HWP9EjL8dJOmaKT+fv6U5I3Pqx0mnMx6LhhyXMbKCxuU07Fbn3Gxpt?=
 =?us-ascii?Q?G7OBvMT9dqFxDBbS/hZy/yjfHdZPDE62lVQ/G3zCtZt9iEuIHpsQ/pMdvTxh?=
 =?us-ascii?Q?2XMuY3DRkC3vKKspJ3vpubH3wrBxG0CY9yhRYsrEMx2kEvSCBwvJlmemllDZ?=
 =?us-ascii?Q?hiAH+sthklIYKF+NkJiWfQTfWm+ysYJDDViSU0karpJAagdJb7KWeyq/1/cp?=
 =?us-ascii?Q?dM3R8rC9Po9SQlLRZBpyBaE64CX3QL82STdLgkYLoCMoRp1BTsad0DQfn6UF?=
 =?us-ascii?Q?Pl9G7fTCBynSyhnSm7yBg1Du88CXkHSLQkGK00AIYoh+PPh9zmiPsCVbRNMV?=
 =?us-ascii?Q?TSaUzBj38oxnPKGlSKq/wnTs424TYAc/7h1Bge4K/UKFRHYHTUqsCYvV2Jp1?=
 =?us-ascii?Q?vHK4gUzzrZjid5c70DNibHNxIkP/IaGb3BMV4x53Pyhc6G55AOBv2lpy5oGV?=
 =?us-ascii?Q?Jl7fal92aHonZbWf0NwvNbWUKPdxZBvJno4aeavGCWyTuCZ58VX8bP+lPeSA?=
 =?us-ascii?Q?UIGc5V4en7ynv5Vrca1pExDR55aCuK70WGWR6+oa8lipS2QCyGHoNUSqCrYP?=
 =?us-ascii?Q?dya7NW+kT2pU5k/4+qv6bf1KLBDdVm9ZkbHh/B9tJgolEc/Hbe8ERRgWWT7J?=
 =?us-ascii?Q?fT0/5P/SVJawHu6Ytqo0pfoL/MJnda3s/+00pXGZC5oI6YKLsUWd0GqeJ1wY?=
 =?us-ascii?Q?JdicAdPxnQ2XIK3wQ3OkNbhAGCrTncQ4MaiwvtMlSvmafnRIbGu6cQ/idAgi?=
 =?us-ascii?Q?T2f5QB5FMRshli5o7wNX3ZrYOvr+9XY7+qdbKWzKssE+2JpPcjr1sPQuU1m1?=
 =?us-ascii?Q?tPl4pdVRYHhjy1ZN4nUVahamZ9HP3ebU/Razey5z4CLFepCr0jwegjLhKcMW?=
 =?us-ascii?Q?3eCsUblE4mRU5iOk5v8FEcM5g68SpfLY3MbSmG4g6fk1/J2oetUxcw1FTe20?=
 =?us-ascii?Q?R6Gw6gBi0RMWwzAPP9QyG3ryEUMZRLX0r5o09pw5UVljcHUUTa3BpzBp4IRv?=
 =?us-ascii?Q?rDg3AQ7ZoKgqmg1FzxbRf1u0lVhSCAZ3y+5pRNKYKycuxML/uKkDoiTmvtxf?=
 =?us-ascii?Q?kWKthqgAgsEizNm4ZA+x8g+b2eH1Z+zrqV2nRPFi/xcaOQ1ida0Dm5KWjIaV?=
 =?us-ascii?Q?bdtKeBIP78zGkKrXgk0NXlJfXhIAYQf5RzYZHjnNZ+o+IY1vyiy5QJ43y3VY?=
 =?us-ascii?Q?GRWZ0kl50ltmEaTGGL9WmBucL9cDXRoKw2ImQzYzH0UYrhhLxtCO1jvwhYvo?=
 =?us-ascii?Q?sfryKb+pJxKfGRZVMURjL5R9YM0m9nbTPM476c3/uhxZWFsbVpw8UXtsMFOS?=
 =?us-ascii?Q?2uWSdcFC8gA8YRPNgUrv+/Xgc8xHX7UqRhmzNotWQgjaWW4u07HIfUrS3MCK?=
 =?us-ascii?Q?l3GGjTt/AC+zjsfsx7PG1DKUur+J+H7yZF96BbRkFcSG8gXcb80MB0c07akb?=
 =?us-ascii?Q?9YDJmWrs5xco7KSKMNszeUc5YWYvunxTsICXd6r+UCyezKPyNh6rpU5lkMJG?=
 =?us-ascii?Q?izkCrI+meAcmvnOHuQSj6azbTCyiUTCnJw6kJM5NxTTMGlakquzzB3NNLqCJ?=
 =?us-ascii?Q?1ezvOKEHu6AlhT6yBpECydWtR5TZ+Qi2q22xZJ62fZ93mF6UhwthDqdIO3Pt?=
 =?us-ascii?Q?p3tzcNF8nLDwgfrumpXZ0Ig=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60C24D22FDBA4F4BAADDAB0ABFA96A5E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5685153f-d0a3-4dc9-003c-08d9a970711f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 02:17:44.7185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PN1tdk8GUCjY3YIrkLyxEs5Ub8Pr2RwbMee38i/3YPuC9w4umqNCi9aZzUmvYIwGIy/mY9p4R67Z/Zym4ZQmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 16, 2021, at 17:41, Srivatsa S. Bhat <srivatsa@csail.mit.edu> wrot=
e:
>=20
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
>=20
> VMware mailing lists in the MAINTAINERS file are private lists meant
> for VMware-internal review/notification for patches to the respective
> subsystems. Anyone can post to these addresses, but there is no public
> read access like open mailing lists, which makes them more like email
> aliases instead (to reach out to reviewers).
>=20
> So update all the VMware mailing list references in the MAINTAINERS
> file to mark them as such, using "R: email-alias@vmware.com".
>=20
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Cc: Zack Rusin <zackr@vmware.com>
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Vivek Thampi <vithampi@vmware.com>
> Cc: Vishal Bhakta <vbhakta@vmware.com>
> Cc: Ronak Doshi <doshir@vmware.com>
> Cc: pv-drivers@vmware.com
> Cc: linux-graphics-maintainer@vmware.com
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Acked-by: Juergen Gross <jgross@suse.com>
> ---
>=20
> MAINTAINERS |   22 +++++++++++-----------
> 1 file changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 01c7d1498c56..9b18fca73371 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6223,8 +6223,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
> F:	drivers/gpu/drm/vboxvideo/
>=20
> DRM DRIVER FOR VMWARE VIRTUAL GPU
> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> M:	Zack Rusin <zackr@vmware.com>
> +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
> L:	dri-devel@lists.freedesktop.org
> S:	Supported
> T:	git git://anongit.freedesktop.org/drm/drm-misc


Acked-by: Zack Rusin <zackr@vmware.com>

z
