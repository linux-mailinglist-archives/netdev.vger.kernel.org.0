Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD6C62244C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 07:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKIG6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 01:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKIG6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 01:58:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D69FD2EE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 22:58:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CseezsLLa/lfnvfl06zgJhMfOFLSD/kT3OS5XrupVYIu4a12+nfT0hLlh01QlRxv6mJuMxDPOffrcQG9NNu0q3OtrV3eZPX6WQcCVdW0P0u8F0S912GS2ONdedqR6ameghuG3zlSAehrKEdNc+y2qMkdVjsziTAg/oxxi2BCac3tq1siKgf5Ky8RbO7jRorFZLh1P1HB8RpDg4299y8kIVpA2WSgeix1VUSNubQKplnfHZAQ656F4w+jgKPre4eQ61jr6v2eaW7bjAVcRnzl4iRFc1PGALFcpqqzkXv4n727VHZygP5V4csay7qR/h+EwKH6KUoipY6CRNmhszQdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VVOwZqfwSm2InEWWYcQ+NikY6uzlg7umZNNRS/6C6Q=;
 b=RjfVbzznl3yhfYBPqvYdSRuiJE0g2dCaOv9EAAfmSaB94ubLF79cL0/Ep4lyxco5zkGVWkDE7RedmPmNHvyuuSQPfMWU7melQVjgBgfYKBZZq+R2joIxGA4OtGkJg7eSwa6tKneoO5MRJMQm2RNKAt31yciz9EIIIsK8wsB9hcs+duR9hd/fEiefBEUkcIGXeNcZ9q9QAgABKBat5sKbvPX0mNz2HZfdWRbrV34UFxInYy6SOGQ6/xDedoo0p+dYHB5EDBIGs6FqixQ6/O7xf5gDtQEJ8+NqA/z4IqS3fYc8Z2OUmfJglrtZvYRrp/NDJjV6/i7hqm58rqGHWwRyTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VVOwZqfwSm2InEWWYcQ+NikY6uzlg7umZNNRS/6C6Q=;
 b=bZ0tzjhHlYeTQoB90CFa8Q63irMfgSh1dJsyekZ609NrG1wFqb9FaM/HhyAqgGnf5w5fGEqyxjq9tWRJQ4hg49bdrNC1yKdimG8BtCmcfNLkxQrJGVmamZKvNSsByaYng2LECjTDIDTmycZyzu2/OFbJsganBETTlwxBcMU/6Qo=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB5793.namprd13.prod.outlook.com (2603:10b6:510:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.17; Wed, 9 Nov
 2022 06:58:44 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 06:58:44 +0000
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
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4zBIsAgAMvYMA=
Date:   Wed, 9 Nov 2022 06:58:44 +0000
Message-ID: <DM6PR13MB3705F170F1EB28EE34F0C503FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2iiNMxr3IeDgIaA@unreal>
In-Reply-To: <Y2iiNMxr3IeDgIaA@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH0PR13MB5793:EE_
x-ms-office365-filtering-correlation-id: c20effc9-15b5-4279-7573-08dac21fd7a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0sBh64tH5ck7kL0DEL21o90QOIOSVx3RfB4yYqHBrSalyRYVBMtl5HCGMGZNhegnaxX8h8GWqQrm/zGd6C7QPX4WbzQiEkan/eWxlmAWOqKpM2Lri9mmpIP9t7USXRGWOkfhwarMQWoNzOZltll9JlBstaGS+MQ4tWR8OMJZplFo22peLSgnDCAKuDB6tJG19bRy7cSxzOLzBhfCUAnULxTkeqauw85718fsNWjNgbS8ps/KEBDEaKueMDAVVnnufJbTzXcl0y2LV9OyLcySQpDVBWTlw1/N3XsGzZpxSk6haBugnHc5lmryB8O9TqA1yzOBjADYo//AL5vNiGeasT3onF3kLHep5D6vhR0LfZ/PDgu7Zf5QV6OMUeYta8BCxfvCALjMuxvOdVZDk9QqLIoRYoDSdmZKf7qMAsDldsnXZug3bLE2BvWdkFiMH+wxGea8RLBl8Ot431Br38rmt9PPztCFim3seQFhMAt+1ModuhLRjDjblnO2oSWnwKJYFZE5GOcbIDgMcdtfMBsiAcgM4JkXuShheZG6hK2cl7vj6G+srLjBLIEIozESw7bmJQojQ4cnwxKKuwT16Z/kHoNg5TyHW69TrTt5NuxulUUXWarV0O9YuqFWfRPw2Z1/rUQ8Jf4F5TxP964wnq8x6AHtyIF+gV0259rqmSPimnms88UILljmkMQmM/qkBiue/+iTrrqw3XMqYtqA0RKDQpaDEPMDYv/ZWWCkCzzyr27/7VEBBKZy8Zm7LQowr0Exf2fM2ExL+QUdjQbeALFYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(376002)(366004)(396003)(346002)(451199015)(4744005)(66946007)(478600001)(71200400001)(6506007)(122000001)(33656002)(38100700002)(186003)(66446008)(107886003)(2906002)(38070700005)(44832011)(6916009)(9686003)(54906003)(55016003)(52536014)(8936002)(41300700001)(5660300002)(86362001)(8676002)(7696005)(66556008)(66476007)(26005)(316002)(4326008)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mn/v2sRCyA4s9O56MkSeQz0CHwKRfN1nJT4nL5BcB1iboI+BgePvNxLZaYXA?=
 =?us-ascii?Q?1JKowKuRj+6yB14CKi3N+Nkvuy/8NIX/j5S0gcVkv+s5nJIWVAK5q8rbBC2o?=
 =?us-ascii?Q?cJZl7uQo/u7AKCEt24PBSn2UyEuZK4qpRm29PWXWI8xMrq08tdV6PETRkXzm?=
 =?us-ascii?Q?imAsBn/oG0djOjRipzNlc9QUwpqOFrUjdanxbwugLJ42pFteQmHm96epYDT+?=
 =?us-ascii?Q?NEHnVthR0VwLg53hSdbnOHGoGrQ7Ts6j0G0l6tX3f84/oDvwuIg/7Y8zjpZs?=
 =?us-ascii?Q?K2BdgdhncaCDnOPQZa6xIvaIhFJmL8qLBstadVwM7tRcgPpQOd+yLvWrY/cb?=
 =?us-ascii?Q?b9faSYEzlPc7RZAtL/L2ls1TT0Ul5WqAtFyJtSuzF2bH5RVkCuwT8FlFzYW5?=
 =?us-ascii?Q?2eJfX7Tm31z9rch8/jIcUuE4WiIe8DpQfK+oQ1V08hKIIlb+hzHXFtpd+Nah?=
 =?us-ascii?Q?PqwLwsia+RVwRvOBtYFVyQn18qeWeeb0xoKeI/8jz+IIKJ0veShgfmJy8ksv?=
 =?us-ascii?Q?jJEua9BO4rcfjdlradnPJZKPvmbjVpbVlXir6mejp8trypxHlQ5vcm7bUMlK?=
 =?us-ascii?Q?RgJV3nOf4E9GZrT3Uu+C9lJZP5LROZyoT7N1q6W1s4nRdy5FX5A/k7fWtc7b?=
 =?us-ascii?Q?mEmklhPr/pPqXdPDAMDoCyJWgEipgS2ZWz6GjqkKfYYtVUnPGSpdV/vxrgnt?=
 =?us-ascii?Q?1EIrCObCQr5TD0EPpdRj/EGuEU5zmTloEYVi0sXRUHDYtwDZQVVipDchWG8S?=
 =?us-ascii?Q?fZvOH5UTkh6d60doCP4pIcWB6Q2/NEQb5hQkbsx1KSw38hCdK1MslVBJQRbs?=
 =?us-ascii?Q?eDrGb7nNwz38d2f8Va1doR+K6fFmB5zN5IcBc5J3BQ5r0sbUBuCFWumjqgST?=
 =?us-ascii?Q?D/UILyBOloMsckRsA7QHLhUTLnGd0gk1wNlLVdbGtbID+BOqpq7werJu5Z8D?=
 =?us-ascii?Q?nqaaqm4txvVHCTMbv81sqtlgnys+j/u5jzP2uh9jlKp/M0XTN5WoU9Hosxeu?=
 =?us-ascii?Q?m5ExRvkuOnHZ+3UeSSpjt89sQbzl6y8vsaivniRA0ZAhFTVUQxkgoihG097S?=
 =?us-ascii?Q?lhDjkoqktXe5hwBU9v0W2Y0gHEEUC1j8Xi/onYGbFoxZgphiaba+tai1L+0I?=
 =?us-ascii?Q?3r2vAepxfIS/eI1srh5fgykgquF/GlPjF2shuw5K84ApSWKEr7joEtNMwZRG?=
 =?us-ascii?Q?QPAvfCqBc4m63MJzvJeRLSLpQja9u3enTlWPJWZ1b5moOvBz1I0fVIGKYLPd?=
 =?us-ascii?Q?g6WVp/sgHLCyN18hq9AW1shzro1UokUwDV0ijU3cIttLMBiSg6q+Ou4pcULW?=
 =?us-ascii?Q?WjOYBh2Hm4jJ/68Ll6C3EuQpYg5DJ2mtCZMBYOV7H4e+Uq1raCb6D5rNPJaN?=
 =?us-ascii?Q?MLTMVQ1xvh8T3LwP+xQQ79LD3BpaSUhBpQW29OpIgGyAxTcpRVwrUrMUpdws?=
 =?us-ascii?Q?MRMGnPLIwlnszyTsT3M4m7Sd1YqNFI0fJhzFwAdovO+gL/Q/3et9izS3bWmq?=
 =?us-ascii?Q?8Uk61bNIXVUemH0VTnPGMp7l9GIarFVZVwFZb01klWDqYYm19nmoMzR8K6Km?=
 =?us-ascii?Q?SdSyN2DRpxc4+6InOhPgoWT66BsRgDmkIMHTjN2H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20effc9-15b5-4279-7573-08dac21fd7a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 06:58:44.4015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CXguuWZrnPoKyUUTN73nQbUZin0uVWfsYzIhSAGto63+cHJ1KdPkmwRG5TsbIRkDvMGw43zm1BPl12SD/t/84Xw6aM8GH1wTyReOCGcl2lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5793
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> On Tue, Nov 01, 2022 at 12:02:48PM +0100, Simon Horman wrote:
<...>
> > +
> > +	/* General */
> > +	switch (x->props.mode) {
> > +	case XFRM_MODE_TUNNEL:
> > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TUNNEL;
> > +		break;
> > +	case XFRM_MODE_TRANSPORT:
> > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TRANSPORT;
> > +		break;
> > +	default:
> > +		nn_err(nn, "Unsupported mode for xfrm offload\n");
>=20
> There are no other modes.

Sorry this comment was neglected, but I have to say this is a good practice=
 to avoid
newly introduced mode in future sneaking into HW while it's not supported.
