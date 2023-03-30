Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFED6CF945
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjC3Cw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3Cw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:52:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2110.outbound.protection.outlook.com [40.107.220.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BE44EEA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:52:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdg+c1vasXZrk6uDyZCEN6n48QJtO3tSTSse93LhGVCeCtJDihe2nK8BcfTXaYxgVUvBYgC3VNnr92oZPXgJDSxDs2HBm240wtTndFHGB8IORPmayXmgkBayqLF0itvratBdzdmYo4XFZpVkAJ/z6slJUXHHqpzAmXGUNwr3vAqfgOinHbFPyFHJtc7Cd/T/UUHjjz5YehzQAeOYoyNh21/+X8rG6JDqZgizMLngNXDIxAxQ+l63ORsBGDxerIF6fuKDEOGD3wJhNC358Xa2ErHhez3+xr/wfcYxDMoAiIVTNzn2f7pXFJ62MjsqJ0kPjXf1TKJ5l0E6XSp5sRYphg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJqCqsML5PdNxXsZXuEdeQibNT4nxkGUmIgLcQDGzGs=;
 b=OuSJ4RM1gaadoNgGLnXYGgygrMksb8u5cfBMqyBwr8Bq8ZnGKXnydnCkIfC3HMu44PhiNFI6J8Kll0ZANOgqOYvAWSuqcgBqI0qoilfu0yEOm8nrMXLUny2v9RtWCSHypsG2hAQ3p327jpXqUss85Mga9s9n4ufCYYD3pPkTTBbCg/JPSRmOKj5/uxVdLk9+4rAWSyQfxmrTeIKho4MqnSNO3mV+ykVNjXCRncudty/yn/lwkVvs7anjVAMQQOvEXcYQtFT+VVhC0kKgGdtCZJxcJkX3MPyKfYPtnFiTNOMDxUZeVj4gWWEUb6uBRhnUFTauxo7fuqTAP5RcWdQtWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJqCqsML5PdNxXsZXuEdeQibNT4nxkGUmIgLcQDGzGs=;
 b=f7r16PQExWpz3NgyVNUDUqD2v6miJ0Z6GasaHEJmfk0OJ8mWZ59IVe+72ssNKT4HGJOT0q0qt060wc3mNWwHgfdrjTIHGcRU2t1bvaAJBby4hmzEl8RqbnfQOCi5LTWJznbBPwqe6cyTFS/0RVYV5/t0RaSInl09AkD02jDppX4=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DM6PR13MB3660.namprd13.prod.outlook.com (2603:10b6:5:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 02:52:22 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 02:52:22 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Topic: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Thread-Index: AQHZYk04vPXGemGWL06stjs7wjJi768SIv2AgABoL/CAABGngIAAAw9w
Date:   Thu, 30 Mar 2023 02:52:22 +0000
Message-ID: <DM6PR13MB3705DBC0A077D7BC80929AA8FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
        <20230329122227.1d662169@kernel.org>
        <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20230329193831.2eb48e3c@kernel.org>
In-Reply-To: <20230329193831.2eb48e3c@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|DM6PR13MB3660:EE_
x-ms-office365-filtering-correlation-id: 9a7a7987-91de-4150-b574-08db30c9c8f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6bFDIYhJd/tV3IsxmVd+O8oAxZAi0eVYTSpzHhNsdlm0WAFRumR0BAr8QEGv0+G2Hn3HmWbDVvO+4gc1sKJxM2G1ImtqLdbCsjFPDtBUZ1+OPW8KPshY1l+E2k+4BDG1OxhVKs0zwEFO0lw33CTf9n2Nz/IACxfckIguuUMC9GhBEZHGQoOfAG2dzxcaa5tgYNrleCUs59Wh+4QoNETp2fWvVcK1Yq1/dfdvGxCZjEOILgalPzFzBqGzrjDw0YNsZauzgfHj4fHdkzij9N5NDSrCx0oarwZYVnU4Sdoo0PvqmdcF3nq7WXiw9O5Phzg6LfVsTRrm08/t4RdHF1AIe6XIL2iyVUgtDP2zMl60MNTMBiyg4c5ByImulLwLxn3xyz4XPWL/LVXQesmKYdpWJxf3NBd/5D/Fy6NeO18u+m7QIhru01Y5dwYfV66VvkQloAiln9M/0gXZmo6Ctfxdx+BpEojJe2dTOtR6ssTqa9fWXGShXhNAAtxUHLJGiM9xxfWbLk4FOje9Kd5oKzebrCx4jgzWTFUqmXIO+jepO1xqy8BI8GQu+xHx1+7y1oFMVBrE5iU7V6H3fjTBGmjJR4aKgU44Zr7xHuYIsmfxuPSTr4P7Cz6RVxdLCA1tRHz0nBcGdHrg6V4RNxTtHVcI/8x9akWZLcnvxRmwZ/MENuE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(346002)(396003)(136003)(376002)(451199021)(44832011)(5660300002)(8936002)(52536014)(2906002)(41300700001)(86362001)(76116006)(66556008)(66476007)(6916009)(8676002)(66946007)(66446008)(64756008)(4326008)(316002)(478600001)(54906003)(71200400001)(7696005)(9686003)(107886003)(6506007)(26005)(186003)(122000001)(33656002)(38100700002)(38070700005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qVTPc8hYFlV/18jakUKXhIbuXeB+VBEmJURGuz1LhYjxbhFnBDvq2g32sjSR?=
 =?us-ascii?Q?0h5xlc56S5uujXNSqtfreoSsDcGZdUYC5vF/BYxZTVcVIyPoUH1IUOoAEPUL?=
 =?us-ascii?Q?JIMqv80POU/3T95jtJL84b6Ys1hM81DATv+fa28DkuUEDvt7R8GHyukUElpv?=
 =?us-ascii?Q?iv/CBhg/jCUk6Xu6nRnCflB6JU9V79C1Omn9luG1xi8sZhxtPMDwz2et9oTC?=
 =?us-ascii?Q?PvwfjkcUobT1A2VBPhiRDsOwUBjASXUsK4O50bnsJ9EF02QhFs5TUc31G6yO?=
 =?us-ascii?Q?YU9RbQgeqzJM7+QG+m64sIU0tAfORg9W8TKf65j9sGhSo1EfZ48TbObc9tI8?=
 =?us-ascii?Q?mII0EBtyvtkxX49w2/bhEK0n3UGq1AAawBLBsIpTvWW0P/o2tKrC/3xcqlAU?=
 =?us-ascii?Q?PQdEG7fqtoECvfLVf0OtzdmSBF5U5GLeXiKBaF9LT1OxtzBgYqiC2MZeVCjS?=
 =?us-ascii?Q?W/huo78urh5c7mylJhL7CB5P9M6XwK1ddNJlPcVpWBIPkJAwZQ64ingVz3W8?=
 =?us-ascii?Q?/HHPhILpY8cdTshcwBnJ3Vj6ekM1JRe7OHREN83ZPiOAVJGPHc72suKyx5PZ?=
 =?us-ascii?Q?OtXBQtXnq3u++i6eDaLwapqf7VgTG1X6NapsVrh3E6bLY0/0L6Oor7bc6jfe?=
 =?us-ascii?Q?wHQcvpX0aZpvwlMKypAkj7Qiw8M2OW5eIYhbB/g2FN6wElg15mLzCZmdiOtK?=
 =?us-ascii?Q?CeBoQxTT2l3oBJZSajMuZIj7vOePZo46y22Ea/c+QSSNn+RQc4l2U36xTcWC?=
 =?us-ascii?Q?2Olt4sw6fB8ljofX4nEvbhWdK0YOrji9jqiDfVot2wYBG3m9DEEZ66Z//BSt?=
 =?us-ascii?Q?vra8bZwlM04Zn3PRtdhtZhg0avm/Q3aGcjWcFEtLuyb4U9+/iD1/K8Tz/LEj?=
 =?us-ascii?Q?G7Oc2E3Ssd3ZfRbvGOPAg/7kW50eWxjpKYRG5ATkuSZjM5P5P5lHfKj++IAk?=
 =?us-ascii?Q?iRANVqU1aBACVxyKOTSLkbJAWhvxeBg+4wmrUNEZQltiuUxCNLf+E2/SoOzx?=
 =?us-ascii?Q?75DaZKZd0dM0Y7qTLdN/TcNjnAgk9LkgQ+uYia19Ca3WP2NXxLk5m9xkrWsX?=
 =?us-ascii?Q?50Y6bOIJiMD4xngGGOyHSM7pFpm6WNy6pzngy5yeoR2w1+jaS2aiDF6X5tzm?=
 =?us-ascii?Q?kgfcPvpa5tcwgjo9W2GO89jT7+aWUL9pHg2+z7A684E3aH1cpAr4Jx6kslqr?=
 =?us-ascii?Q?/01M1wmGll9c9GcsONcYmMYz9cgo3Uhc1Ksc0aiwMJCImlgyzvoi5srjcno9?=
 =?us-ascii?Q?NyFCsApurFp2P3d7Oft22Rzs4yxtQUVFb1gWZDli9tTGVHOZVhoOr18YK33N?=
 =?us-ascii?Q?6KbYHwvtoTAIWZNHWABF4PwSWUaFv6NO/VSjBbY4oZqKox6oOoMCmBvU86IJ?=
 =?us-ascii?Q?j8iDsnQwug4HRw6l2y2iu1RTfCH2iT81YhzlBA6Yf+YDnnAmOBKJcUGM2cz7?=
 =?us-ascii?Q?lWvz1xCBZ8QhOwrv2fJHE3rU0+U1oWG4RYT/FtOOMZEoxqGuDtyymXYRN4HF?=
 =?us-ascii?Q?lKTn45rq8WUtNulBVxUzGDEW+Cv7RhossucJkxJy0zUd+WUCQhgTHJezT1Kd?=
 =?us-ascii?Q?0Gs5magQiEmgE6cRkAejYTi5j/FvW6S8mifYRX5A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7a7987-91de-4150-b574-08db30c9c8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 02:52:22.0620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gybFBOSzcAzleG6iKfQe/EEAsnRQT+eJD7RghitJwjjaol1qZ/mcoYIQLSTWWPNe5mDMVqRXP9C/aDxcWxKIjuiDfzt6C0uodkw90jVsfnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3660
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 19:38:31 -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 01:40:30 +0000 Yinjun Zhang wrote:
> > On Wed, 29 Mar 2023 12:22:27 -0700, Jakub Kicinski wrote:
> > > On Wed, 29 Mar 2023 16:45:47 +0200 Louis Peens wrote:
> > > > In some customized scenario, `dev_port` is used to rename netdev
> > > > instead of `phys_port_name`, which requires to initialize it
> > > > correctly to get expected netdev name.
> > >
> > > What do you mean by "which requires to initialize it correctly to get
> > > expected netdev name." ?
> >
> > I mean it cannot be renamed by udev rules as expected if `dev_port`
> > is not correctly initialized, because the second port doesn't match
> > 'ATTR{dev_port}=3D=3D"1"'.
>=20
> Yes, but phys_port_name is still there, and can be used, right?
> So why add another attr?

Yes, phys_port_name is still there. But some users prefer to use dev_port.
I don't add this new attr, it's already existed since=20
3f85944fe207 ("net: Add sysfs file for port number").
I just make the attr's value correct.
