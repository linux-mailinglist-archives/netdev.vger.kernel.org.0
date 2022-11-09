Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3A622B20
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKIMJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKIMJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:09:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2128.outbound.protection.outlook.com [40.107.220.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAC010FC0
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:09:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGdAj8yT8kjo4YFS6qKKXDChAGlA51E5E7MA11JCHG8rugE0MRFYsiyXqYMpNIV2oe17xbvA0kW0MqPuXB5RDKjRgqSLN3PIRt20GinH4uUJLWDf/Ziphdlj3WV2QBfORQ3Zo4OLdRuBYBRHz/Bkf2hkXxHqPWR2y0YxKvr+xuRMVcKBHiGvOHJDGakkzWGIuF3iAfFNbnxlzb8o0cqhmD4sxwtdfuZS1ZxseqYnU375xcqy1zpY+dqEMab6npuojVCJkmbjw1Zv3XbGnk2rv/sUdQMvXX8WLMTo316FeTXqs2bBdM4j5IK+YBCNziCGdPhUsMJHb9LERBLjmgzXiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2k+2Iki2iBviTjv/Z82gpeu3xsQvamxSE+Xk8nZCcRE=;
 b=eZaSABRGRbmO1XppcBWRvidAiokeX1fFO6NsKGRrnlxBLE+V9F4Z8HCpnHJck17mwuig3PGba4ZacR3wguFuIuK1gZO6+LObuAJ9A4Ikm3HogioT0KywqWPkbsviZe042F2otRKLJKmA+14mmOljwulfe6jEHP4JLc7kAmwNtpXrmB+MEuz7T8FEZL1gu0Fr8UtptUELT7DMJ9PdwaPnBb8MQuM5JorT5ihHeqtwOquqEz6j1zvHxgXRYJQquFvaxNAT54JCEsjGWMRIyeOHL7Ky9Xjs6U1Der7RXFCEPX2EjAf4TAEodEYvPTdqkuxAoYUdpQMIAxtMhX+fXdRCmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2k+2Iki2iBviTjv/Z82gpeu3xsQvamxSE+Xk8nZCcRE=;
 b=hR5Mkr9brEje1/VbZeKo+3JqdcqSFfBCQJ6CKvf/pU5a9R35u2+Xqm+iazmCrwGGi862xAfiMgxW4SpAwrm0i+jQc6t6fC24jbn6o05pSPpj0S14vLzPZw75oNJQuArG6IAkVaP/KcXXbYdtND+0vQ2M/YZVWGx+cluP3wRnulg=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MW3PR13MB3946.namprd13.prod.outlook.com (2603:10b6:303:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 12:09:17 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 12:09:17 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4zBIsAgAMvYMCAABouAIAAPQuQ
Date:   Wed, 9 Nov 2022 12:09:17 +0000
Message-ID: <DM6PR13MB37051AD84E651BA6EC296A94FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705F170F1EB28EE34F0C503FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y2tkJjdLLSWyTO3l@unreal>
In-Reply-To: <Y2tkJjdLLSWyTO3l@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|MW3PR13MB3946:EE_
x-ms-office365-filtering-correlation-id: 5e380c05-19b2-4c19-2f19-08dac24b3a09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPtXubbRa89dWdbkCK7XUlxzEw+smkxypyqklcm7ai4F5PSE1wHJnMrKzf4UM1dyipSPUkdlqdr9ZeROviF1FoPg4A+bWZnertjcq1mbSKhAHzX5HXfSDGr57igiW1yJO963nskXEgNGc7Qdd6srw1cvumORHBp8ZnEyzboBGwid+wXyx60Oon7MoIjhuy2Ks6eFJbVXngGhH73xlR/5jeccRlRcvg73+gzT72Kb5/d8B5DMFv+SoYmns/kZmTJseIUjjnnBP1mXYnHhMTOiJKIr1bVG9tbR5/l/QPLA5brlb/Kme7Ohwx5rEhBFbayGiw7klxg4PwEbQ7cwqKv3/Mody3nbdNltr62ZfcM/g61MgkdAB9tJdmZSF8hrcAq+9jJ4uW/HGpve7XiRryOj2kNSEGiPYgyFQUk84pg/clIHvhaHFDgtVWplB3b//0tUA29oX5cbOVLJiNX0s74PpMnP9hBcPgBxJw3bFcS6IKx19wke9dIfFPafDafhcDsH5r7BUXpPvYAhzzQKzCs9/9OGIAAH1gKFvvhzYPa6ev3aJs+XicWJxQfXyVEMFhpNq7OAomOA1iNZuQiFCgEZRJiPd+EH4LBZZGr+LrqDup6tGG7ikv5e0oZX0+oewOJ4yhwo2SybLtRgvYgbfil0ftgf3qXRhksr/RsJoRCX3BpudMfwz/0X72psNLancOYT29NqAKMnzfsUXdOJxEl7rAidP1UAN5rLLA88SiXigWQl1vHg8RlO2X+NXXBAfPdawdBoqSlegmaBpLHSFcVPiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(366004)(39840400004)(451199015)(38100700002)(478600001)(122000001)(71200400001)(33656002)(6506007)(44832011)(186003)(5660300002)(7696005)(107886003)(86362001)(55016003)(66476007)(38070700005)(8936002)(4326008)(8676002)(66446008)(52536014)(76116006)(66946007)(9686003)(26005)(66556008)(41300700001)(316002)(6916009)(54906003)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Raq5WjvvldocmBOBxwDKlW75tWmazYRvERIiDq2vJhpR4PXwHHvTdvmldJB2?=
 =?us-ascii?Q?0nTK5ZmK20BuJPw6268mxvG5zj7zUY/0raf+MH8HTqwZjQwPqtrBdicQlvTH?=
 =?us-ascii?Q?zzBszdNb8AVKWJpaXeg0ERIP3vKI4a1dzqi/HC3QCDwagHsDq6XpHYBmmROZ?=
 =?us-ascii?Q?JCljpbqJsPz016eNWYROWLTuPOcUMy+TwDFY7s6SOv8DOr8u7/hV6cNV6wEE?=
 =?us-ascii?Q?7MB3w1VCAjIiRsYYupKRIQhPFD+Su9Yt0WOOrNlPFz8hwrBURlWi9Qn3I4FY?=
 =?us-ascii?Q?z7FN3VhBS+fP8e1MC75OWWGUvuOO5LnHclY5gUPfsHFlGfjefRcGhjuJXPB8?=
 =?us-ascii?Q?ZGjcUjYH5p3sk7OhchXXi9bPO4dt5wTFYaeTkz0LxHU7OgLrIbONKwynaxuc?=
 =?us-ascii?Q?9xRmXWIqXPl7+R3NK57E3o6PHzHE1oKdWOkr+kkf3Mq2UxJ6KE8Rv3rmhp2d?=
 =?us-ascii?Q?+q/1IN5lBZxJKG0WHmj1Mq8Nd+xf0n/7eJ9FDVIkEowl29j8D75UCaQa2aqq?=
 =?us-ascii?Q?hGAVFb8z+mX2gr6XyCcSwtDjLkMI8H25mLNO2UXyBPvI85LvNDYE8BSnjBMZ?=
 =?us-ascii?Q?DIR6T1T/JRysqDhQWso/NZ9YE97yKzsVguz2XqiRPGN0UWiZ48n7cQoenv4G?=
 =?us-ascii?Q?SkbL0Ol/op+N7/FPG9kh4EDNfWU90+43beYmc/taAqjymGtHLur9ukTKwQG6?=
 =?us-ascii?Q?4F9aTw91PnBUBR2Ud8EzcF914NOrPRuXbOJYJ7Fy8H1yfM6vpFoW89XzYLLy?=
 =?us-ascii?Q?tcJCcnbwIuXfbCVJl4LE40VbJYrLIrcoKKGc+ewvqdPc5UxPnN82ArdauWF2?=
 =?us-ascii?Q?RBfdM7MPxWAHbNzzhd1++9XZedUWzAlUzDzudt/mWLoKP+v1dTDzM6OmM2b3?=
 =?us-ascii?Q?b+HLmB6WkouVUUIZ1QUWSbhiAnIrGSwK8FDA0ltMZIbnoZYn/7Bn0FtBMMRe?=
 =?us-ascii?Q?Tly/u4HI8QauyRGoU1u/757Ohlopkcmr8YlcY5gO4w+WYsLOtUWHLc5wewQS?=
 =?us-ascii?Q?aZbv9BfCcjd8wacB86pRDYPOJxbGWWIxq0io0CgN8uK3mELJd7c9Abv0c+5r?=
 =?us-ascii?Q?2lPl1nZX0JNFEY26h2cZgEswiyg4TjSET+p80TRwH5bdFzyUhX0yNflA6YYq?=
 =?us-ascii?Q?qORBOI9aYuB67e84URtsA4f5MGO94A6OZgRfnm7LJexjSC21xzFxD7tRPIKg?=
 =?us-ascii?Q?WzJqEfrL1cv0YZJQhow69lf/U3IQeTzrNsssF3Tc8oxSfl77q+lVNOQCTetQ?=
 =?us-ascii?Q?atxIO/eCKXUhkQu80zbJI8tl/l5h2jfYx4BtGwTcC8sGLjpnm2EjSn6+oRqX?=
 =?us-ascii?Q?rwEV5AGHENfiu7ljXw5U/xRlYOasz8x5rgs2VUjBz2tIAvSG9fQhwsobxrf6?=
 =?us-ascii?Q?RHDUZIHcMwRvQcSYbs6CV24Dj4YrqpWxDOHfyyTUCG1xs+RXGT7uHY8+5YMA?=
 =?us-ascii?Q?oeUGXeiQ8ace8xka6TzOtpO8f80+H/JhU6CO1amICCnKusANTCNLWx3Hnclz?=
 =?us-ascii?Q?pBQH57g+XE0P6oN20Lp7HnI1hzMJeLYg5EOy3jsjOogemKXGJgFKzjZGe8o6?=
 =?us-ascii?Q?e4/IzqqIsZRwbPwu+kCdGRcfZeqSeyvKubOO1b/r?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e380c05-19b2-4c19-2f19-08dac24b3a09
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 12:09:17.7894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mxW97m295W013PLNihfQtiE8LaFj8fyr7LpSwIDhMWayMs++IpKsnq58fmnTnfblPIMS19tlNhKXSK/jcxZIVNIZZ390lYr1q4hJYQAbpY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3946
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Nov 2022 10:26:14 +0200, Leon Romanovsky wrote:
> On Wed, Nov 09, 2022 at 06:58:44AM +0000, Yinjun Zhang wrote:
> > On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 01, 2022 at 12:02:48PM +0100, Simon Horman wrote:
> > <...>
> > > > +
> > > > +	/* General */
> > > > +	switch (x->props.mode) {
> > > > +	case XFRM_MODE_TUNNEL:
> > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TUNNEL;
> > > > +		break;
> > > > +	case XFRM_MODE_TRANSPORT:
> > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TRANSPORT;
> > > > +		break;
> > > > +	default:
> > > > +		nn_err(nn, "Unsupported mode for xfrm offload\n");
> > >
> > > There are no other modes.
> >
> > Sorry this comment was neglected, but I have to say this is a good prac=
tice to avoid
> > newly introduced mode in future sneaking into HW while it's not support=
ed.
>=20
> There is a subtitle difference between not-existent flows and
> not-supported ones. Good practice is to rely on upper level API to do
> the right thing from the beginning.

I don't see any restriction in upper level API that other modes cannot be o=
ffloaded,
would you please double check it?

>=20
> Thanks
