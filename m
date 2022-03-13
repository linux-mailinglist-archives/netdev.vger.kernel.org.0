Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3254D75CA
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 15:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiCMOTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 10:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCMOTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 10:19:36 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10052.outbound.protection.outlook.com [40.107.1.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74F427B20;
        Sun, 13 Mar 2022 07:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOI80TMIJ2xwP1YhlJd2KsC7blmy1YOWYwUTY+E9Mi6YMhmyPEMlxu0Mm86TLGm6PsxaaYOo4jh+AkfdFzXSzMnhXQFmENfSNi3bn2sIKX+JdSNj7qA0+8KebHdQrnytstHEREH7Ri4g4Jig5+Wq9cK95N16qKUKD5UDHI5Bw+kjDD42bodAFMsFrjayarrkNsocibSapH/njpLvY06KhLaM0akpItF+MTGz2+2kJb6YiE4smOA4wfV1nSK70clvmHGENQOMHGdAkZcEFEValdnMGY462TTS0aST2mG9udvGN8WWFY8cUUFZHiDYnyMaxUDra6xt/LQ1PufdZiKxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPY6XH+LZYKQgi+272a9FJ654uCreRbVqred6vdHrlg=;
 b=YIKYapTK48mm5NBkMmhG0EkNz26SpOxSDncvHLX11IYSDca4Gp9TQBOyLy82B6VwU7jxQIYM5dSIUh5dxsH9/GI4sUK4ff8Rv6oFQpf+pyewl57Xw2pXjkdNyZrPn32kdWu2za90xU6KTGwDryD/D7egZKTATOL4vc/S3Ipxx+9JAxy2Cw13KYl0yrDkuzXS24cddGBY/DFg737/5VDMvak8Us7HTO6uIB4Ovd2n4NYyOqSb0Nd8eSavt/fCPmKVR5Ir2K4lNVBJ7uSbU5c6YoXlq8rXCGXfXnMy7KmMgT87nIl569FwZhazTmeYMv8EFoRr4EPHY3qKaEGEMVtaxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPY6XH+LZYKQgi+272a9FJ654uCreRbVqred6vdHrlg=;
 b=rI+LsjqCpsmgbQ6gQ2Qu+a5ED4Ty7ExneokJxpUS8kFLp+FPjTuYd3DhIkkQ8CY0vQmhpiOmK593U122N//U1RvPXkUeMyDPpecI9f1uoeu5qU9BQrhDbBFo5MYdJ2yPvOnRxVXRvSCwCY+8d+L9w5hF9flbqOmjNWfIQ6gr3+0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3798.eurprd04.prod.outlook.com (2603:10a6:209:1a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Sun, 13 Mar
 2022 14:18:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Sun, 13 Mar 2022
 14:18:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Daniel Suchy <danny@danysek.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "rafael.richter@gin.de" <rafael.richter@gin.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Topic: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Index: AQHYNuMUe6nsPJS+gkWlndMnOWNLUqy9WmoAgAACMIA=
Date:   Sun, 13 Mar 2022 14:18:20 +0000
Message-ID: <20220313141819.ffnconknknqxd5kn@skbuf>
References: <ccf51795-5821-203d-348e-295aabbdc735@danysek.cz>
 <20220313141030.ztwhuhfwxjfzi5nb@skbuf>
In-Reply-To: <20220313141030.ztwhuhfwxjfzi5nb@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44d295ec-42e6-4db9-f547-08da04fc536f
x-ms-traffictypediagnostic: AM6PR0402MB3798:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3798468957DEADF64CB2D5D3E00E9@AM6PR0402MB3798.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GL6xC35bA3jQufWTL90jJdHj8RtZdSaI2ab1/56MU+zc4/OprkXJmwZg8KYCaaj5SsIEQ086fuuyNTp0/YAblMWOJJd8sBTctKzq1YjD0H9HgxylvOOzrfXcT0g7umjBLZvVtK8FnLX25LI39veOXLxL8cXj7FBxLQgdwO+jgk+Pva96CJLEywZvQ9zIOIuUPqoziQ9t82W6h4abePs4/+sBGBNVRdJT+FHXluucoVSR4azqT+8qTfO22ocGRcdKF3o9ZC7GlLlN3GimjArx5zGUvn8itYsuivQSArxC/xO8HljEmYcOEOHf3hcP+OMCyPLG8u/NpOIe8idvUiI696RHmTc6THxddjlQY17FDbyQCE3nfrFn/O66ccVQjcmk6RNtxElWAarbFgZW6qhfI0xqpmvdvuYyGSHjS/nzK4RRsYrn/oCCapvV0na0yHGUPpIbY1xq9BWO9D/t+dC4d/3Xfzh7a5ovgtb8ZF9UoZEGBkA9tiT+HyJ0fw0aYj4h0PrlqNt2YWQDTcJMkOf5ZEfxX+Qz9JwBSLR0HUq3md9oZr2BG3vW5gzZCBTc0QhZ0P+8O4bxkSQoVU/aVtMxKnlofQwU5D4fvqthIOVMYdPWQfXw576gzzQBb0s021bwlfUtQeUO5yEQmebbpjPydd6SKOklIuqLtH+gra4kKPqfEzddYLOPq1QxUBRp6kkD8dzqwZb7evwc/xYfkIPjmIyHUCFZE79EQu/9EBD28/YOmgL7Llpes2WugEwLb/CaUUPgELzt7jBGpFtB7Vm3hAfhjQDGWeuQ01P6c2+DYxY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(122000001)(71200400001)(966005)(6486002)(26005)(186003)(38100700002)(498600001)(83380400001)(6916009)(9686003)(6512007)(54906003)(2906002)(86362001)(6506007)(44832011)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(33716001)(8676002)(91956017)(38070700005)(5660300002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FoHB88K6L2ID1q8UdQ1Va90XNnXC3eJre8CuTrGuKZmwbjd7Izz3kJOPffUp?=
 =?us-ascii?Q?CHu8SXl2yZwMaaSh5GJbOwrXsz4KcmKX9u8GUccURlOYN5PEZU/2k5JNnOhE?=
 =?us-ascii?Q?bQNz36upc66ylu5RGq9lhIZ37ZBdFjNlliYmkDacByJMeGjZQLMuZ6wT++5K?=
 =?us-ascii?Q?KqDJCrRPxdiJKQrXaSyvbOrB1fcAs+ijS0/KOgjE80Va8PEyPt96T2MhahDa?=
 =?us-ascii?Q?m5CIWW2W3uAyCD9OYiH05KDrVV1AuAMoIvT3djvas8qR3tB4njiZb9QdAeL3?=
 =?us-ascii?Q?avHR4OOZnYONHknkrNXChY3qAST9LUFbBpAIfYjB4G1Aj1TTgpqNELcJziGU?=
 =?us-ascii?Q?Ik/NG/EYXW/Jsmj7oyBTyWk64maFcMfTo4U6K6MKIWRvJLIMVyq9opGBoJDJ?=
 =?us-ascii?Q?3bia4twvaI/ypNFCzkbMnIsI0OUdYwR2+IZAsmvY0PUvv+36YcVr8cT8DQKG?=
 =?us-ascii?Q?z/WRUd4NJ1zD5YWaKCUMRFZY/97A65+cOMi7e3yIg4lk/cniNN0W7NK8Fyg3?=
 =?us-ascii?Q?SrAZeQLaqYkdQI4MNIBf/gKJyRAHDUKBAYKV3VjKK3Bf6fTsX0749Q03piTE?=
 =?us-ascii?Q?Zk1oCzQg2gnfYD+49JO7WjXcqj5dn9LkbSP3DjtFQ34JyX7r28dDbrkr2b8Y?=
 =?us-ascii?Q?qYk+KBbGCn1eRe6euesf345xcGEvuWhh0jQsxR3KZHdqn9L8iRbFudbZtgv0?=
 =?us-ascii?Q?vSJUk+qGTt2vkZBdnvfPK7KTl4nHxuziwyQ9Yj6J9GuoCOH0Xto/aFPNotPY?=
 =?us-ascii?Q?/jR89VsJyjgy8g5cE3no46VsikduLvTOv+DQ4d+xnNhERgmEqOEPSMrRWfoj?=
 =?us-ascii?Q?FaZpV9C4xfTQTMH53g6zDRNp72LGqq4HuMtvFal1rillJyPWZaEo7sMNp+dA?=
 =?us-ascii?Q?s1DQKQoqbsANmDygF1jUAHxPYjIgxnMQprP4bu7wpGIZ8oU6I6M0BLHmN4Nb?=
 =?us-ascii?Q?avq0UvnTtTs3A0VusEk9Y7047PVnqpZ+8wpT/lkG9QBYZds2tCUSi9YoRLr5?=
 =?us-ascii?Q?45a3M/D7BV04MDR2Cv7Y5JCNeRWMv+G5JaG2BhCe0bU7Tbt7f0cPUbi6GVtv?=
 =?us-ascii?Q?/uKRBkpqbjToPFoblbdG2o7qAl7y6ym+X9tIA/cJ5KFQZiziSvQlqMwE9d6R?=
 =?us-ascii?Q?s0uhKbt15UZAhOKh+iDh/kMFDXYIKqlC+ZMLSxwF3kCD/ado6ySRRpUaL5E5?=
 =?us-ascii?Q?5ASmIdKn5ETfwneXYiA4nfhXJ4aLISW0U2YYceLvBGvo7SQWbW9MEu5synne?=
 =?us-ascii?Q?CYmAZTXUsdc2Yip9NPwS3wKS+bumXc+DwCMVn4qDDF82HoFoUS86sWjAPfC6?=
 =?us-ascii?Q?jPZXQ+BIWFDL33r59Xgk0WGwFwibeaD6lj91r5FqHbMZqvavEbQa8h5iPCz4?=
 =?us-ascii?Q?r8vY9cyyZB1raMafB1Y+x0m2jFR+yTajXfzUIA3MFv8ww/y7kWsE2ITDMxOI?=
 =?us-ascii?Q?xcx41bxQkhYMlPUJg6uKmYqgy5y6ufGcG0qji4briWt0fDUDEg8QeA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9367EAC43EF504DB55B0469BBF6E928@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d295ec-42e6-4db9-f547-08da04fc536f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2022 14:18:20.3524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bzUT+w/Rt1u+KKybBZv6f3rW0BD1q/dH7zZCdZetTX2RlzAcCNTxx/ATvo/Bvho0dHiRqmAAtD9NatkjTynBHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3798
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 04:10:30PM +0200, Vladimir Oltean wrote:
> Hi Daniel,
>=20
> On Sun, Mar 13, 2022 at 03:03:07PM +0100, Daniel Suchy wrote:
> > Hello,
> >=20
> > I noticed boot problems on my Turris Omnia (with Marvell 88E6176 switch
> > chip) after "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> > removing VLAN" commit https://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux.git/commit/?id=3D2566a89b9e163b2fcd104d6005e0149f197b8a48
> >=20
> > Within logs I catched hung kernel tasks (see below), at least first is
> > related to DSA subsystem.
> >=20
> > When I revert this patch, everything works as expected and without any
> > issues.
> >=20
> > In my setup, I have few vlans on affected switch (i'm using ifupdown2 v=
3.0
> > with iproute2 5.16 for configuration).
> >=20
> > It seems your this patch introduces some new problem (at least for 5.15
> > kernels). I suggest revert this patch.
> >=20
> > - Daniel
>=20
> Oh wow, I'm terribly sorry. Yes, this patch shouldn't have been
> backported to kernel 5.15 and below, but I guess I missed the
> backport notification email and forgot to tell Greg about this.
> Patch "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> removing VLAN" needs to be immediately reverted from these trees.
>=20
> Greg, to avoid this from happening in the future, would something like
> this work? Is this parsed in some way?
>=20
> Depends-on: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switch=
dev_event_work") # which first appeared in v5.16

Looks like only 5.15 is affected. I re-checked the backport notification
emails, and the patch failed to apply on 5.10, 5.4, 4.19 and 4.14, as
intended.=
