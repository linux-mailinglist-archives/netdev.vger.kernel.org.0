Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C324969E576
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbjBURDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjBURCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:02:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D22E0F9;
        Tue, 21 Feb 2023 09:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8NeRBMcvDQE7+iqrZowpSi6cs+Y1vxPMvP5sro8mxCjU6SJ50y072N/PvkKBmEBERemeOKbjdV64/FU9c1m1rs/wBIx3EJP2ILfts+BZigW1k9NQqMLxgUwkbP6GPxNxwSlX8FnTPOgX/luATbd/7jE34sBAC0sr4b3V0EJWHCvPxrnrTlzW9BX50S0oAvHhxAnDGIU7tKRhYTVDdDJgirC7INHi+jq3AtxDuhguCwAmfXTBfq+Yh1yfqIu8auzI9IkDeJOdKCPVNyDdafRsxMn9FrsdUApj06f7x9nfEBtxnZFF58Ic129UO8Y+4CA7UMW2e9L7x+SV+3jIUcakQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCBxswXpfvkBMPcOhL8fcu28fl2cfFoPWpofjnT2XvM=;
 b=ShB9pudpeFp83qLSrpdHIO5UnydnwtHNWi3sb7zjbKaNYnxtrKS50SoJoARq/obS+nk+ug3ZTsNSKxKq8hQFcOtsm3f1EDU6XHMr2lcit2DksFwwHCLsGKzt4nKzUEfj9kry5pGPA0iODmOjpXn3PvBIP/Mq9RoxgxA6zzcs9Dzmd5yuWsOhfBUVtkkVkDKGc43HzfYIXnW2553a1Q0qaJjgxEqqzbeNfdDDZfqiCb+jxfx9lF1J7e9uGhJy0o4IakxVUiOAQIRel0e7X2flr38/ZlTzJMEuXScfmb2JxmH9XP0ocTpiWcNiYUlXFb/sT+Y3B3R1Vzc9Hq/CmG3Uzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCBxswXpfvkBMPcOhL8fcu28fl2cfFoPWpofjnT2XvM=;
 b=cSqNBQnRypOgGsS2c3pSE/gj73u1XZgc7blFqeKFiCxkMSQa6w5zKnp6IQtjYdYsRFcR2ZHaGPOW7ix/5W26Fszn9O5kFsuQfc9NB092LQxwxJU/f3h1jEm3r4rzAFv/a4jXMh3nTAJDbccb7oIbCK10w0HK5Cj0cHwQJbHuBOY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 PH7PR11MB6908.namprd11.prod.outlook.com (2603:10b6:510:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 17:02:37 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119%9]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 17:02:37 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: wfx: Remove some dead code
Date:   Tue, 21 Feb 2023 18:02:27 +0100
Message-ID: <4462570.LvFx2qVVIh@pc-42>
Organization: Silicon Labs
In-Reply-To: <af667999-c465-2814-3ca2-cdccfce72754@wanadoo.fr>
References: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
 <5176724.BZd2XUeKfp@pc-42> <af667999-c465-2814-3ca2-cdccfce72754@wanadoo.fr>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: MR2P264CA0034.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::22)
 To DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|PH7PR11MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cfd885d-e46f-4a0d-0763-08db142d6ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEBhzB+JF9en4Qsnm0jKS/zVsIDIfEI5a4YaADM8Z4hwFEYXaZsVJ5XNjxFWzHrBviFTGWxE+5mCAVgWItyVr3nWBSSSukJRCIXh9edhiMEU4o+3QEB0ouzsoY8d2OEuJVB4e/uQUHPCt8gzkcxYDb2/gyyFRMRJCgK7rgV1X8MbrNIHgbYUxniXyzV0ZAiovYX3XkEu5RhtZQMURj1q6Ps1JnE0rtSduhE2XQQGd/L1jcnaMXOX/yFiMxEARzZpRi7bTFgNclOVbkwnOnuLL0UKNSRky69iWNIlngK/8zddqFaGvKPBsJBhvZI2LgqFqYZLyORjWkE1aiGPYzIXI9xWdgggCsVppisXOcM5YZC9BQ++JmQ71PPXoJ8eN/T9wPF3tQ+wcYCCxoK+FJdTIgl/SL3FYoBeJZGpC+4hz81gsH/f98ddvdTLwBVOML5TbOTkkyLihIz9xyGmOFEphtfhCACjKRr6alSxNMfUMi00XS2v9j0KECbmEQm9j7JQKNE/3uun+JidKta3b3BZSKIqmgUUWeeJAed6xfxi3ZiH/Bt6QS3wMiqHPvF0jdwMfsG/03E4bQaHlraESYK3ti97ms3xJaSv18hNxpHFSOPy350FIFbkGIHOLyV7KfIabKE3HBQTp25WK5Ys37U+75nN/5uBJNRMAT84wnxHRnYnCAtMEE+c7YKjdG4wqO7YJquDYwWZOGbt/aWyNtLXvk8O6GncrI3m4XJGtRm+nqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(136003)(376002)(39850400004)(396003)(451199018)(9686003)(186003)(26005)(7416002)(5660300002)(6486002)(8936002)(4326008)(6512007)(6506007)(38100700002)(83380400001)(33716001)(6666004)(478600001)(52116002)(38350700002)(8676002)(36916002)(41300700001)(66556008)(66946007)(66476007)(2906002)(86362001)(316002)(110136005)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?9fUoEkOXkxttThgsZyoIdqsSk1c01DcpDz5MLa97hnvJeHSx74j/eyfHhv?=
 =?iso-8859-1?Q?Dj4Ksgfb49RIsiWRmz0tTlJoqrYmdMOoXHQGNHym+y8CmI/TNzBqr5ANH0?=
 =?iso-8859-1?Q?4QiCSKAM4KVhASDp4WvK3yvKxgCcYsxGRru1mj2D+RxRSsSLC9cg/4xPBF?=
 =?iso-8859-1?Q?52UZ/pXI8NKufJ8BXo4PxQi+yM3QupQYzXHqK5qBmJo3L6Vto20oC+H+yN?=
 =?iso-8859-1?Q?3yrVd1uxdK5MsewmgS5RjfPIkGXc9ziBtqbUG1s3ilEhzGwgHcgPc1u5K8?=
 =?iso-8859-1?Q?XF5EjrB5+IrwrhVR4Qs2f6W/HfGI69J2LM0nHKpaY9CMKQWg+yurWjAGyh?=
 =?iso-8859-1?Q?e9/4V5lWezlm3ydysgrqVbKebtmdZu3Pnn3L06Y7yLP6SL9tNRHKipl3eH?=
 =?iso-8859-1?Q?elkPENJNRbOY1etdTj/gdPAHKju9NpVIYK/3GT4pSa6AMt2iLLyJHOo/hI?=
 =?iso-8859-1?Q?/gGUQu7igEr+WlUV3Z5t5EmVUSgF+7bjKE4euDYTlBHQGagDYNBFAS5i17?=
 =?iso-8859-1?Q?zD85zxQRxYugevznXinGN9dZgR+uyvJZT2LOI9QkRlhsbjQcW3LiuUK92W?=
 =?iso-8859-1?Q?VxXMHYVUDFp2XSEB66zURxEDMLSrubysVWZlDtwBb0USvYA72d1Ws/XVK4?=
 =?iso-8859-1?Q?eqcuqMqtn9PFeiIdzB88VTkCG0JmxcuC2Hqf39Fz8E+B6g9kCBb/f4dSX8?=
 =?iso-8859-1?Q?lObg8kNqUiPxku894l5KMvyVBynZy0EbjirZt1EcYfluP4OY5vuR0VHiPN?=
 =?iso-8859-1?Q?HQsuwIjC0TyxBaxyZDMfs24jb4UzI+4tV+UzPurOaeqDrR24WM/gMzGYYv?=
 =?iso-8859-1?Q?64kqqgDmOYldyqYFCC4VI8d3MQvx40qhePWNEQIohy9Zs7NcP54MBOPglS?=
 =?iso-8859-1?Q?K3V6Ss426ABAjhrqiNfVCbUej1oSRqbfIxYS+2NesjvvP0TH9FtIrouInY?=
 =?iso-8859-1?Q?2Us+dAa5BmxGyEbVDF4t0RJGCMCpbXYLis/46oeSIRIKmu6hCud/52kNWw?=
 =?iso-8859-1?Q?lZYGk+qV/G65bJ3MpNVkolP/NDutgo8qJ/dAm66uef8Dx2vg+yLyQRLryL?=
 =?iso-8859-1?Q?q/ApvUyBSOkfizzBIu3DgFIm9KCvni2f1OYZ9hoZ4sEXYPlgZMrKDE1YwB?=
 =?iso-8859-1?Q?DByIwuiSNMljAmDj8EJtSp40NsGUHI5HbIWWLAOmN90o/f7ZmQhnO7nP3U?=
 =?iso-8859-1?Q?ecbfwT3luc8r3cFJmS2ViWijxKKqXMKxG3Amq7pVDrVC6KlTWu3QSzl0qv?=
 =?iso-8859-1?Q?RIKCyIttWFxP37trdzJWNyy/v0ptrMqLcLrTzBsOcairxCHo17LPdLXldi?=
 =?iso-8859-1?Q?FF+1mX8dhiBNKOAuYasIyjq1aaC0BIC7DjaG/wnjYU9GozF/BfSDPFVjpc?=
 =?iso-8859-1?Q?dVlvjksxPVOl4FMy/pqAR/snuxXcpiXi/MCjbFXqsxwMPQgQUzAhcGcsOW?=
 =?iso-8859-1?Q?AgWUTRWC1fA9QYy3VHoQcv4VQnnFR8tsKqm0RRrTNd+PPGCPjTXprfJLeP?=
 =?iso-8859-1?Q?TUYX7RpbJlmyF7a9Nb6oggd4YlhaWNrvV2u9sEj3eA8ATXexfnQgVwKOi9?=
 =?iso-8859-1?Q?LvwXMbtI2QCBCf/z34OyKeF/yL47k2U3rTq0xLPBjjSfXn+Eawdb1LkgOW?=
 =?iso-8859-1?Q?azmmDYPQtXouDFFMh7HgfjRCOpK5s57pn2?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cfd885d-e46f-4a0d-0763-08db142d6ed8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 17:02:37.2385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3BUPdpBmSRutiuTFe+WV9uY9CyYSD+B0K7s0IE96o7v3eoqr+hqQ2VurhsNSpzMlu7qnCpr3q9thsesBh7dlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6908
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 17 February 2023 20:51:24 CET Christophe JAILLET wrote:
> Le 15/02/2023 =E0 14:23, J=E9r=F4me Pouiller a =E9crit :
> > On Wednesday 15 February 2023 13:34:37 CET Christophe JAILLET wrote:
> >>
> >> wait_for_completion_timeout() can not return a <0 value.
> >> So simplify the logic and remove dead code.
> >>
> >> -ERESTARTSYS can not be returned by do_wait_for_common() for tasks wit=
h
> >> TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeou=
t()
> >>
> >> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >> ---
> >>   drivers/net/wireless/silabs/wfx/main.c | 10 +++-------
> >>   1 file changed, 3 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wire=
less/silabs/wfx/main.c
> >> index 6b9864e478ac..0b50f7058bbb 100644
> >> --- a/drivers/net/wireless/silabs/wfx/main.c
> >> +++ b/drivers/net/wireless/silabs/wfx/main.c
> >> @@ -358,13 +358,9 @@ int wfx_probe(struct wfx_dev *wdev)
> >>
> >>          wfx_bh_poll_irq(wdev);
> >>          err =3D wait_for_completion_timeout(&wdev->firmware_ready, 1 =
* HZ);
> >> -       if (err <=3D 0) {
> >> -               if (err =3D=3D 0) {
> >> -                       dev_err(wdev->dev, "timeout while waiting for =
startup indication\n");
> >> -                       err =3D -ETIMEDOUT;
> >> -               } else if (err =3D=3D -ERESTARTSYS) {
> >> -                       dev_info(wdev->dev, "probe interrupted by user=
\n");
> >
> > This code is ran during modprobe/insmod. We would like to allow the use=
r
> > to interrupt (Ctrl+C) the probing if something is going wrong with the
> > device.
> >
> > So, the real issue is wait_for_completion_interruptible_timeout() shoul=
d
> > be used instead of wait_for_completion_timeout().
>=20
> Hmmm, not that clear.
>=20
> See commit 01088cd143a9.
>=20
> Let me know if you prefer this patch as-is or if 01088cd143a9 should be
> reverted.

Good catch. So this patch is correct.

Reviewed-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>


--=20
J=E9r=F4me Pouiller



