Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48689697D18
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjBONYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbjBONYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:24:13 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6242310DB;
        Wed, 15 Feb 2023 05:24:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W66uOjqkp73P3z0+8iQv69UD/xPzFbidDU99809JxpF8B+jNtwefR++dgeEtF94Lq+fEJcWM9Df2cpaS1GWE6Es2B8cOSFCjI/owvADVsmrkMyMxGN6B3K0y+bAdFOmvNOlTgH+zt2nlOl5te3GD+QpmRtPt0a9XpPt31ybbREa+D2N6jaHxgLqKs72KSrPVj3jjLqX9h+EdHBOfL66jIUqnqu2K2zr/GKLSMLAQ3in/oLfz1y2UOW9TGRwjx8D26HJ7EP6keM068TGJIAlqSdVouvLwvIcfOj3Cbs+KHpW9mPcNYEfBEfJxgwVNThHQDXHYm5c2Spl6REiNL1z9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSjsgqYuoPtHYkqnjRI3BvwB/iWW1xZeSo78kO4HiTY=;
 b=J6+5QC0ng8um9xeiok4ltr1w256j5hN7CmmWEO5iyoXUd7Veib8f+Im5mMeTzpiVyR15jYPUGYm29v0HHV6AylVL3WhmGEgTF0yOfBLlh3QDBE1zuoZGYEnU9nnomuAYvw2QspmCjceYNH4Pp1mIAw3On7LOcHYvb5DmUkB9IWnWPKxCacULAda1sNYPN0DjvRy+BqBD3BQvgkA3xV8E33PsOIk0W9vi4EtV2XYjCQYRRfAWAkO/Fcs3ZG1H/QSj9Xy9E9q/jD9fjFFS0Zg3jbx0sWc9UEGkokydj4pU069BAb8Yw8/5AWwNp5ShSEVCGEyuzMDRtt8QE0pPZErNQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSjsgqYuoPtHYkqnjRI3BvwB/iWW1xZeSo78kO4HiTY=;
 b=boWs9ZatAZWQxAGZURjlHU58cC9etACz1+Lv54zLeoRwp8dXK1659t9XCSJrRpGIDGhFnDGojjGPmiXmXQHB0ORgZWenNusdn6Cc90UUQ7bFFgzPKd/oaI0O61EUakzT4S4dvnRjDAeqrBxRdKhsk2eOS8CWUlhkloMrtL/to8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 SJ0PR11MB7156.namprd11.prod.outlook.com (2603:10b6:a03:48d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 13:24:04 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119%9]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 13:24:04 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: wfx: Remove some dead code
Date:   Wed, 15 Feb 2023 14:23:56 +0100
Message-ID: <5176724.BZd2XUeKfp@pc-42>
Organization: Silicon Labs
In-Reply-To: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
References: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: MRXP264CA0009.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::21) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|SJ0PR11MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: 9781838d-8510-4950-2dda-08db0f57e839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RA7rX5rNDZr5pbSmi2bPJRqp4oo83LgjTCj+t04StztCNAv5v6R331J2WXx3JXvnJyX6xXxs3hErzeKsnv4/aQnpz/6HjE394oIuKXlDbUzGZY4ZSgBG/4yK7aydo9dOciOgZrZog4TeBRNw3fN7hvvLBLg26u3L9D3IXaXZ3epFMuxFe07x2HifcLci1NZZ2pW7pPc55bxxOZ7JDnTq1rE+iknWQ+NW0fohpbJtEEVSMUayaxTggzIVLAwm7Ais8SN+vkn1UgN4hiqxkpbNF5gcWgGqCkSH7xyRpcIGST7y9GbOKycupW09PatyltExhWJtTIN+Qo/o0B9nKg7fyCETp6DIpNuodZ4xArbGlneRRYo5ivUcvD77lrt1HiqXHJeDWgUU0ykwClUMbFooXv6i27tbvowhm7yZTf6+fmDjzuDrwCOrbxr3CLY6Op2SKK/uxxFi0PpnE/CcAeie8InQeFk1ok4mee2gWPK8uDyBBn1AoMB88sYp2eXEMMAoLqkJtxjkEOeKXJsKpYdpiyEFUfauNAN52NvdZt2zHoarUIesTY2UTtBvFePyVe1byO7RWgoOiZBLn6adqQcNuFj11g28Z3ElZjcP1rtNomif0M3PA1nAM4Ooi+7L1p+K+HNtFsygqEUcyAFkHtu2d1I889L5gGnxWtuA78IKTiXLhFFrS/XkbgZi47IBDr8NTmQdo0pJLWYyv/aDgrOVkYDjxRkKpJ169RbiP9LK4vY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199018)(33716001)(2906002)(86362001)(83380400001)(52116002)(6486002)(478600001)(110136005)(36916002)(6512007)(6506007)(26005)(6666004)(316002)(9686003)(4326008)(7416002)(186003)(8936002)(41300700001)(5660300002)(66476007)(66556008)(38100700002)(66946007)(38350700002)(8676002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?qijHo0vpbB+kYZy1OoFGEopKfwQUN5VVlI6JWf/Mdc9XsCKNn64Xt6m3uN?=
 =?iso-8859-1?Q?h116YqKpmN4oJkJoGoWqvhr/I8d4tEHb06Plk5ioV9tX0yfq3MYAPXQh1G?=
 =?iso-8859-1?Q?YvV2BDvq+lWpEmRh3jDSJxiZcjRCcdAwO9D6gJBlDgX1lWkRImYA7MDwOW?=
 =?iso-8859-1?Q?4b9Nz53Qtcwzz8T+EWKM69j/ZCW6cWxXXhIOeKInXXqiSAdwfRRdy9DlkF?=
 =?iso-8859-1?Q?VXp4vEMd5hQR+PL5kw6KgdVFI6lLpw/BpZ2hFlkg/wUvWMOTfE0+kmHlJV?=
 =?iso-8859-1?Q?2mc0VxsHcC0Bxi/Ylv/bPaomVixlvrmU7WS6x0gHqXl5IjcbKlEOLz5tuW?=
 =?iso-8859-1?Q?PjLiYJGOamB68eUVjF2OO+J7ZMnwviyAvt0Z6if1cmQr4y9aZ742icMip5?=
 =?iso-8859-1?Q?rKjLX+5hc30WRzx4LMHxmZn9MZrJp+95QwEeZ6JElOfodbibQjup2gUtzS?=
 =?iso-8859-1?Q?w9QFEP945zOucpoPrwC0e2S+0lPyMC2mD9LsyDbcqziuI/JRDX+NTsfMI7?=
 =?iso-8859-1?Q?FOBN9qIEN+r3mJ8tYQ5RCMp/VxdKHTB3b0pDWKB+twkgPQpN0gkFkfmKP5?=
 =?iso-8859-1?Q?6vxDVcdKeKealiX9ylrredSSWq66FJON3OPK5YgAbot15SrU64AwTHHsj7?=
 =?iso-8859-1?Q?OmOmyCG0Z4mJtx2NwkPu1OyglDlSfJqlTPUTNipUvDFdkfpPr4Lbj/isJm?=
 =?iso-8859-1?Q?8lw9c82knegKfDpLRRergJI4F/KYAhI6FoRaPgeTN+V2W/5+GhmRJJ1pJY?=
 =?iso-8859-1?Q?h6x11tBVXxXozkEfhVjJE1jD34LlkHR6iS9BMfvjHB3cssq3Dz41Bxzh7K?=
 =?iso-8859-1?Q?ENq7mvLAoR4MpH52W98yRzc7SFFiFO/Ol9fY5Is+eSgxnGfr3h+qxjvVTz?=
 =?iso-8859-1?Q?cd0h/Zz3ibzFqzRsMqzxmcfwHvB4NS/bV6c64fuN+yfCXVoM/MtuGt4d8E?=
 =?iso-8859-1?Q?fEWn5gxgYnLEeZiZt2p+4JjBa8pf7l25Z89z4KWCSTgnIVKKzB1snMuvho?=
 =?iso-8859-1?Q?KmfyKAeyzz7jMYA3+o4PvGnnl3gmut2qR8v8Z/umI3k4AqUis4GggBYm5q?=
 =?iso-8859-1?Q?NDrYuw/S1uxzWr9M17kDLfGPZstaeQysRyhn1ApODkP9rk30VvH7oXMxX+?=
 =?iso-8859-1?Q?A6Z8g13OW1EmyjSRr3hB0EIzjD/7q/eKk8D1+riAr3RFur4UeGsQ8R/xlk?=
 =?iso-8859-1?Q?3nKvlBsqoBdecbYC1Xv+w3UR4HACjGbk3D4ASmhPkNLXkaeXQMO/JjJMMi?=
 =?iso-8859-1?Q?RlADyVsS5OCcShA9PEZFk/yj7UUCLbL2d+EUMQOfjKSFIqUMPS0jF+8SgQ?=
 =?iso-8859-1?Q?0S8mBI2umbZD/maLY7twqzuZ+KYxyV7zCUOvY/P/HSMNTZaSasaBJIR3Ur?=
 =?iso-8859-1?Q?lCFkqjGfsZHCMv4ca/OoZx5HiW7y6jIMfCDcMRzkCmFN0QlEiDCUMe+ye+?=
 =?iso-8859-1?Q?PiZtnUoICY/eE3LM1NO2FMRL3TarLBA/Mm1P7pbU04zqDONDY8rqdKIoWH?=
 =?iso-8859-1?Q?OKcOnlelQzUyPm/HaKuR8AJDQrtfqhNdZwSNRypRXsxVfJSnF40E41qd5c?=
 =?iso-8859-1?Q?xmXON5UxGuj59ceVR15Je7jYOjwF7bg4aJ1cWdOqo3zRysMxqiGsjm5UAK?=
 =?iso-8859-1?Q?f2oAgaqFTVPpsRKhYBF7I7MbTruVaQ9mqw?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9781838d-8510-4950-2dda-08db0f57e839
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 13:24:04.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jy/A/xZcpT1hCU9qPzkKIGwjcsHjJ155QpCtdeeGw9uZiCAKeABhDsL0/OLepCfg14oJWGOaG4WLRhGxBBjLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7156
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christophe,

On Wednesday 15 February 2023 13:34:37 CET Christophe JAILLET wrote:
>=20
> wait_for_completion_timeout() can not return a <0 value.
> So simplify the logic and remove dead code.
>=20
> -ERESTARTSYS can not be returned by do_wait_for_common() for tasks with
> TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeout()
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/wireless/silabs/wfx/main.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireles=
s/silabs/wfx/main.c
> index 6b9864e478ac..0b50f7058bbb 100644
> --- a/drivers/net/wireless/silabs/wfx/main.c
> +++ b/drivers/net/wireless/silabs/wfx/main.c
> @@ -358,13 +358,9 @@ int wfx_probe(struct wfx_dev *wdev)
>=20
>         wfx_bh_poll_irq(wdev);
>         err =3D wait_for_completion_timeout(&wdev->firmware_ready, 1 * HZ=
);
> -       if (err <=3D 0) {
> -               if (err =3D=3D 0) {
> -                       dev_err(wdev->dev, "timeout while waiting for sta=
rtup indication\n");
> -                       err =3D -ETIMEDOUT;
> -               } else if (err =3D=3D -ERESTARTSYS) {
> -                       dev_info(wdev->dev, "probe interrupted by user\n"=
);

This code is ran during modprobe/insmod. We would like to allow the user
to interrupt (Ctrl+C) the probing if something is going wrong with the
device.

So, the real issue is wait_for_completion_interruptible_timeout() should
be used instead of wait_for_completion_timeout().

(By reading this code again, it also seems the test "if (err <=3D 0)" is
useless)


--=20
J=E9r=F4me Pouiller


