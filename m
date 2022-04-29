Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E335514184
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 06:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiD2Esd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 00:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiD2Esb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 00:48:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84FC6436;
        Thu, 28 Apr 2022 21:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGr43tkdmFRhcSeTAbYAJkoJgPzqFA9KifhmRu0SzoludYKEVGWKTDJpzEvupvGoPZvhA5CjiclBcADZC9rHeN+rS4aTihdOylObsmTnSzcAnfj5A7Dp6xH81WqhFSs3SK1GL4KnDe6ofCBfKQX43xhA1nS6qZt1O7Mbn6MFdvL22MwJThTK6Cbvjf5oENw7xYGZwI4rWw5GR32W5Pxp8MOmwqNU9BYsa4VmgvgcljK+TxQlZ2+9gGoc4FFaTVpLB2x7D+CtUzAEXOOFS/hVdMtZPvZl9yrJIVzNQXy8SUpJKgTuAlCFIcDhvMgzG0Iqnr+xLBLOwVJCeU8ARvIapQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBiblxFJyjMoDJnQA2qqvnY+y7IXZa10h4o7VJgnUAE=;
 b=UJrncXLL+A3p+6ppNh/2JD7DpYJMFShXgHx7WgRZR4AsVoLmudcHFZ1O6ANsliKdoZ8SAFM11YHK7phePLkEtWVoyBbdmxXL4pOcfHFf6HpFbSoxJNyDsvTFYNMRmx5osX1WKAWmhNBw8He2KBPsYSKcZ/rq5Pinnq83Dbg5Mu/sCdXS57JtJZlfs2/agRQsX6kyopkLPv7rNVRS+MPey0AGX0myF1VXXvgywBM4l9gkIngViJAQRvBymp82iRsipH3GvUBK6/j/cCIt3oiGMtqcdvjbNW9GkU4hR+JjfOIF5jpdddqcbwX4tvzT+HGvYlPvvb73KlELrb5EP9N85Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBiblxFJyjMoDJnQA2qqvnY+y7IXZa10h4o7VJgnUAE=;
 b=sw8EKL39kVruQD0Z/Xv2icyjepIpwMKnm5ajTCeNZXIHtv/x0SqijOZuiKJ6YCUvyOaPH4J02ycGA1E5y912Q1eo5YGUdVi8mXt8aLjdWL5dJtM3FOJe67iExDTf8ofy+yk4WIH/+iAFVwdjPyFh9qSrTKCYD5bvXTpyJevHXIA=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by DM5PR02MB3292.namprd02.prod.outlook.com (2603:10b6:4:64::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 04:44:52 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f8bc:753c:d997:24de]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f8bc:753c:d997:24de%3]) with mapi id 15.20.5186.025; Fri, 29 Apr 2022
 04:44:51 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Subject: RE: [PATCH 0/2] emaclite: improve error handling and minor cleanup
Thread-Topic: [PATCH 0/2] emaclite: improve error handling and minor cleanup
Thread-Index: AQHYWxz39QEwEZHRlku830aUv51lha0GFOOAgAA7NGA=
Date:   Fri, 29 Apr 2022 04:44:50 +0000
Message-ID: <SA1PR02MB8560130205812054F354254CC7FC9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <Yms6a3GODF6Lmf4l@lunn.ch>
In-Reply-To: <Yms6a3GODF6Lmf4l@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07801808-29d5-4427-47d7-08da299aff42
x-ms-traffictypediagnostic: DM5PR02MB3292:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <DM5PR02MB3292A0A138B694E010505587C7FC9@DM5PR02MB3292.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zQHfRPVsp3FLIyl8/iHLzbSC7xgct2I34xsHuVO0RfZtWGRE7Sj2BgcyY0wm7BFw5jHoU65U60T2RrNZxMBhIhvZL1Mnfly3KSO4zCg350RZLZB+PV0Nyhjh7DcDYCjvdRNOrHgLGv+YfrH4Sd/MpQIEd5WRBGVb0NmRt18L8s+z6lUoeUKORLQeNHGVP6Hldx/DnDd6D/xUygQUXjz7OXvvJLZMKQp7b7TBBJ0xFFv6G5VvL90c3J2heZ21q+X1fhXgfrWKrvq7uiknpYWGmFbxhJlk/AQsjj137ni8TQXuQ+s0zwL7yAgWuyBlopGeb3cO3Sm+i8wUZiM3NeE8o9WetkPD6ak4q/uE+NU2z8bYqYop7QWaDNMTX2REVKq+W4UWs7z97i7qxJ9sD8V4HgY8I0usVdDb8iAZp+S6uatQUkJcXWweEszYvAyA9++/2l6hor33zlq7dLtiqmijp7R28UQlGIEAz6r0yjMe1uhaCq67oEVkC5G1ksaFUAxEvQCmpzWoY8qJ/O4mYhm1S+84/8+yQy23E4hCuu6YqPoTHOrwOUP+F6g8/p/BcUewIEXpeOzdUiIVVDq/1/9Fe+cnoy5YVvBcEm4JU/FM6Gi0iP38RWW+TK/JKMmk9meePyEOix3A6VsIobGuh/LKwpMPP39zAIXKPUVpX3FjJwqszC9KqR2FZqHBuhfTNF+hlHYM/CO86hQl+zR86h6EEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(122000001)(8936002)(71200400001)(54906003)(316002)(6916009)(38070700005)(5660300002)(7696005)(38100700002)(508600001)(86362001)(6506007)(52536014)(53546011)(66476007)(66556008)(66446008)(64756008)(8676002)(4326008)(76116006)(66946007)(4744005)(107886003)(186003)(83380400001)(55016003)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b5W+eFjBOSNxm6agaGkRXnrGKTyRLlThwk5yeegSvYK1wcTz9I5TxlhJMddm?=
 =?us-ascii?Q?Ps3QnYVs0p8PLHbJPUrNBDrmmU/adaCKA7HHPzNErFxiK813X1r8dqkj34Zi?=
 =?us-ascii?Q?3jWHhtUj3Bd0Ojm4QBCcu/ujCwmED584LuBeXzNOPS9RCqRUJABpDk6zzdxs?=
 =?us-ascii?Q?d2PMFDUXQWA3Y5TltUJXRrktLXFBVlMNuFIjrn7j6TRCqUQRC91WTupdt6wQ?=
 =?us-ascii?Q?Mfi5Zs2MopHCn3jzwZWtaxyVwhczyB9RjONCWzXRP3afa66CfCXQnTuYIlHc?=
 =?us-ascii?Q?ge1oe4/AnS0ELbhOu1AtG24IrgJdmV3Mjg9pOCyoBkF3xHpvD0/rCpPpcIv5?=
 =?us-ascii?Q?uWlk4fYulyLR0CAPkzc93asj6IZW4n9s0ZpGTbz3RCL8QKCLRqyS/5zt17ql?=
 =?us-ascii?Q?ysr0TFEsYBc3UeUwM16qitIxIsaBkvOeXg+mm7gbtKP6Ypg3CLwcyzg+m1ZV?=
 =?us-ascii?Q?M04m3T4GuRDhBsH/jbXB4xKFouGzdrU0vcNaKUMvbOQVNHrRhT1ZDe9+JHw/?=
 =?us-ascii?Q?vOj5ubFieDx1J66o4T3TQTkQxQ2NjdoDc7FT23tXq7asLDDAnICrw3MV6+es?=
 =?us-ascii?Q?hZphCWYtdCWAQQWv7PTPzA0B7+ER2AjB1D2+rLDJwlP1go08oLTDSQ2QqGUd?=
 =?us-ascii?Q?PzHvxo5qXlFKICSjoFwWQGeXmXLudL7AebjcaF5r/bNLl3rxbRTHjoZcBkX6?=
 =?us-ascii?Q?g2AR94mjt3lccfgph4TfYPgwJUcxxBkp/ljzCtHWD0SH4VbsGLO6OhiHMoDe?=
 =?us-ascii?Q?MPRIG7qnsQefyL/dZfjGRzCVC0M49DabNB+4CCpugE88/Dy6DDt8c0QgLSx0?=
 =?us-ascii?Q?234m9/QXXCkCKaaEBLpYk4z+bd6vymekpjiURDY6688Jx2nk8lqwjm1g0TRo?=
 =?us-ascii?Q?DvPGsBFLm1iU8a/WIVOArlDeKI9pDJvkYND1Xqfym9oQsECbN6uKUkn5tSrU?=
 =?us-ascii?Q?fa30cPVdI5ZU+gZsMtEaL2LgpWoAPzz9oFAwmY95SSdeUDAUv8ObqVBGSQyO?=
 =?us-ascii?Q?FZ6f4b/zzileS5ugh0sIBRfNfUPrK9ia35vhofDbg8o+KuHOU8pO/RUx+Rct?=
 =?us-ascii?Q?rOMMiBNQoOD07KnnftHKh3TKd0Gs1FOrgBa07t9RqNNe8lXQiPG86jY/oAad?=
 =?us-ascii?Q?zfsU4c9xnhcjo9x9dVY3coodL49o/a9uNA3plB/zVALJqn1HiwwKXy0aDDnP?=
 =?us-ascii?Q?ea9O6MmTyUKfPWRGwuH920PDgCqVhcgAW2MyLaoNnXQwkxOcQkRNTwKwZmqi?=
 =?us-ascii?Q?hl03UJ2x426rgx/6et5n56eNCouFemOCI48YycbLqnZseXhM1Gg/oVD9zGGc?=
 =?us-ascii?Q?xkeW0XTfpHNK7bv0/kCofSGF7Sbofm3UTlDCcaY0DmuOUMle0wdApPh4hGax?=
 =?us-ascii?Q?UBJuCbX1wv9uzzVTbCRHnq980DFAuR+Rc8pDPVF49HLmfDrw8AbSRw5WJa9l?=
 =?us-ascii?Q?hy6ja2WuIohYQqfuy7w0t+Nb+HY6jxOJzgVoK5Qw0XEndqfZ7vuBmO0abY8f?=
 =?us-ascii?Q?6vYM8SRZHgmz4gJ6YGlhJO+8VRabQhJVMnJg25LwXCjch+U6tMRSQDq1QqU7?=
 =?us-ascii?Q?4DdZOnVmiBfPAhpyYfkmRKXAfyXz6nCVrjR195+CZAAm8NTDjwuBTb6o+BiT?=
 =?us-ascii?Q?eCdkNPRhsH2y6zlVuF53HVQZDHmWDDpsQ4C+0U8Tejts/QO7mTxr0oC9Hlbc?=
 =?us-ascii?Q?oY39Bn3UXQxq0jFRSbrpIymZJR1J+yh5DLhOINJ/KAdwW6Stt7Er25czWco7?=
 =?us-ascii?Q?F0bCvNsX70C7o4iISgtmF4ePnt/wj1idykoU5VPJyXE7eEazE1zbAGA1J9Sn?=
x-ms-exchange-antispam-messagedata-1: cf06bPi9jWluug==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07801808-29d5-4427-47d7-08da299aff42
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 04:44:51.0426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iLilyAmrs8XlqOqzRxGk8EhWLinPvMdFCi8DFpOuZdUb9unzARLd+ZWdN8YFzvPbb0274J7yLqH9fJDcTNC6EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3292
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, April 29, 2022 6:38 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com; Michal
> Simek <michals@xilinx.com>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git <git@xilinx=
.com>
> Subject: Re: [PATCH 0/2] emaclite: improve error handling and minor clean=
up
>=20
> On Thu, Apr 28, 2022 at 09:57:56PM +0530, Radhey Shyam Pandey wrote:
> > It patchset does error handling for of_address_to_resource() and also
> > removes "Don't advertise 1000BASE-T" and auto negotiation.
> >
> > TREE: net-next
>=20
> Please read the netdev FAQ. It tells you how to specify the tree a patchs=
et
> should be applied to.

Thanks. As one of a patch is a bug fix will target for net. Will update it =
in v2.

>=20
> 	 Andrew
>=20

