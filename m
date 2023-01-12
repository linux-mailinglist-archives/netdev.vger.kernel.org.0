Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBF2666BA9
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbjALHfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbjALHfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:35:48 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2092.outbound.protection.outlook.com [40.107.113.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACAABF5A;
        Wed, 11 Jan 2023 23:35:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+YGhsVWrrZ/8UFb4SBr0jp25CqhFQNXlVYW26qp0CJQXsGBjxk6cUYis1MMruKILTZXHkmaTcAVXaO6b3VGL67o+O2FTFiANZrm0Tpg1FW6oXaqnhkB3p3kqfOVpjI+PPx4gtb7zjjZiBpfkcAYFIChNMPBypMRlxm4yOxH/Hr8X3T+IP3JL2o9ZEUyYD2KXFI0AAjMt8o6g8XNgq/4mtYy7F+VdnWDFzNpBbPHLxhaTUl88mQy9R1xqnH9WQIbQvigpP6fPvfRsRXiHWYdbU9+ZygYhZMug5K/LpRGRm6WuozjjM07swMASItieua7CwGsInAtwGt15o87k71ZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hcz1tQeI+NoqDW44qtx02CDnKl3oOAd5jv4+zOKERdE=;
 b=kbqnKCr8ml5aCtAberm1kCT2u/vsfIlNjX4xJHtM+QQPq20EVpLN+3VQ6CcOzpF7VVfnmtjffdnwpItWWxKJQtS7M7Is8acT+edBVGOeaXY/tjfJafiP98wIvaPx9GEgAhwH15xbGV3W2yJ5GhR5V59EgN/+bNVELDfqZFzA7S3WaWw7Gsg64yZSEH49qitKCpUe20vMpzXFimW7O1tvpqpC2Dy0lEaW5xk9lx3sdSHrrRxxu2Ry2faVKiizz8ZIq+mixIFv1E0OsdVGB2wqjRVSP2C0yAn0W+8VoihsvspmUQXFKYgbJhHUng+RA4pgbiIqPMfIzYe9pRoDOKs+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcz1tQeI+NoqDW44qtx02CDnKl3oOAd5jv4+zOKERdE=;
 b=TteKaQmPW78ZBxu4AMkEdJCqdBBGPU9XQNfHNLc11qM65G7hPJsq70cqszCpHG0yssfaAr+ie/vbSxlUwDCo7uzWtkn8gbEwSfKJrbD7XCD66e9Ey7SE/5YyW/o2a2gbnTMUNkO+C3omGFzVAAAP5/HRJ2vt/qm31yFFePJnBxw=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8518.jpnprd01.prod.outlook.com
 (2603:1096:400:154::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 07:35:41 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 07:35:41 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net] net: ethernet: renesas: rswitch: Fix ethernet-ports
 handling
Thread-Topic: [PATCH net] net: ethernet: renesas: rswitch: Fix ethernet-ports
 handling
Thread-Index: AQHZJNnOfF0xTxt32kmVf898Yj5Tz66aMEaAgAA2S8A=
Date:   Thu, 12 Jan 2023 07:35:41 +0000
Message-ID: <TYBPR01MB534114015F5BF595A533A031D8FD9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230110095559.314429-1-yoshihiro.shimoda.uh@renesas.com>
 <20230111201857.6610f412@kernel.org>
In-Reply-To: <20230111201857.6610f412@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8518:EE_
x-ms-office365-filtering-correlation-id: 6786ac35-914f-4ad1-4c7d-08daf46f9bba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TaZ8vrfx+0UyV04KKiJTQprfTnH1MwdO3PoyAMIrsUZOJXs70bhh7s7zNYMyp2odz5XImdqIzo09Qpuw5PDj8mbg70iF6Z+qXbgEWbRf5rQru1GrNs4LsM/luzMoj+dwtJYvhMq+cHfNZDuNoc+HALNm2a9Jfc3OtPG+artuBu//CoBxqQlOdOGKOovDpXDrcu3XqRspv9/mAcp6eR2zNeWuhAN6L32o8dFvqOTtxWp4GfrMR4vaCyAQvjEA5jSGOibAOWWh79Vh8NyTtkUkkHbDurJWRMzX+5S6FivYgMApKxT/PqmkvVrQHIZEfs1i/JAs39+n9DHHacwt2m8hTsQ17PtPyuYnL1SA/xiGvRBqizVTsURfclMRJzHDk3d6BPGIVBQ9EiFOL+mDecj3rQsMHwz2XiA5929PfFAfv+JblZq+rKjPNADwWCwVQioz9NCh2bB8QGp3TX7DGmZjZZR5tKnNp0MiYbhpgdnUH9d4B9084dKSTrq+Tw8cz1BegKpf0WHuWm5rfHKjdl/cHrwITAN/sOsBa+XEv+qfUqdjloWFprhtwepCWLVhiEX6cJN81BqRQv4aFawSGL+ayQ9r+Q4ErvxHvF4HG2xB6+Jlaa+RmuQuC/a5ontTD2XyvZBB0I6b97clJizJ9Bcf68zgrEEN0fEFrwXUMlIHXTrWIm3scH+zGTIDO4ZOIgfKhnEdu4KEG+jl6+TTWbljA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(71200400001)(7696005)(2906002)(38100700002)(86362001)(33656002)(83380400001)(9686003)(55016003)(6506007)(186003)(26005)(6916009)(66476007)(122000001)(5660300002)(64756008)(66446008)(8676002)(66946007)(52536014)(4326008)(4744005)(76116006)(41300700001)(66556008)(316002)(8936002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QK1mMQ3wu3h+arD2ztupoB0PWsDm9TBppVUNqg+stm/kNgIr6i7tKg4FGvSq?=
 =?us-ascii?Q?8FHLe4xUipKdx01kNTU6xPZN4CDtORVmmSOfs7xEjUN2+0oIzjlW9LDPGAzB?=
 =?us-ascii?Q?sq7wakBctpClq1cgUsDFrFRHdj7dbTG+jdGT79NXugvvTEoyiCE1N9ZAKziN?=
 =?us-ascii?Q?M0LgkOFfYUqjhLR3hJhflCDAxCEGEYONNzLR8/K2njdM4Zai8vwrm4Oamos4?=
 =?us-ascii?Q?HeZIk/gt+3oneeaC4awh7wVhDgdcZNjqU3WSkFH7TazZ2nkjnGFTmVIP8u9h?=
 =?us-ascii?Q?x0cmcpTisWAldIo3pFWp/3XRiI7Cx+5UWiQiMfxAIqZjjZFMoU0wn/BqRUgy?=
 =?us-ascii?Q?W1thLU6VV2cZ8BfUE7NDFbxQjwvXveItpkeqvFHjwFi9QQjd0P0H0HxKsNt5?=
 =?us-ascii?Q?myJXoOcMOPP/OYrs2kzzjFacE+srdOclIzzG7850mhOo8DrBaiP/o591MfKW?=
 =?us-ascii?Q?hrdU+Dgwj96tJ5o/YXPhraXZndLxpuOqnOBhceGWDNKfA9lmgwpnbuddvITQ?=
 =?us-ascii?Q?qPhsgA6A/gd2xJoLHqWqu0GxzXogkMxjhoU5hD/7H8kWG6GteKI0lg4De9os?=
 =?us-ascii?Q?O2dPjuospibP/4JSz1n4aeCGLcFXasEFzP6jHt5Y2cL8x1p/C03y/wshnbPj?=
 =?us-ascii?Q?if5GCz4yFZLI/o6AhNBL9u2CSojFaNSadm4us5AAYjD/iIhLk1JnaGYOXprE?=
 =?us-ascii?Q?2DtW7g+/FfqoZ5HXR3P4W4yH3d7blKm21ASo8w8rjXc0nv8taGd+HvhzPrsy?=
 =?us-ascii?Q?uALf/aNV4sY1GgeJCszGBB/fck789sWYoWBXbyzJ5XoLvULcox7kTaw7KMZt?=
 =?us-ascii?Q?uEEyLeLqZ3kerSJAZjwqXeKYNG1GvY5ki3FE35sDsKjZw5ZtNwHzzInxqyEo?=
 =?us-ascii?Q?yk16GvLokN6Pg5G9ERz9FUjZqQjkPuQRuJh63j6motwSHph+lFAgtkgQ+hfs?=
 =?us-ascii?Q?rADLXT0PcTFRXZ03kbZdb4sOYNN2tvMC/VNied1Zg4pYSOZupJfqmdsdVI06?=
 =?us-ascii?Q?atQ4IxY7zm7CViPq3kFwWiItVc85D+cyHfY/fOr0VzqdFJ28NPPYRrNKRKyI?=
 =?us-ascii?Q?t4IF1I6uKEwIuC0SopaIoT26LYycSAbvg/s/gsdte5ajWSOa6TfJVPzAtuHZ?=
 =?us-ascii?Q?IkfDulT0q8XAx8eGKOT/lRBx1LKOItH9y60hOEUUC4HQa7ahw+kNTTZaEweQ?=
 =?us-ascii?Q?iGzAXoNBxU+wM4qBKeLfq9RByHnLhsGp5Mg/94ocrJvZx1M5FbUg6O0aa7r6?=
 =?us-ascii?Q?sCW0HtO3leh6nWgb/KmU5CKBogoSMnnyCvA2to1HekNWAJ3gdJj8f3NgDv+u?=
 =?us-ascii?Q?K/vqRvEcjgMor10nBaS3KpukpeRIfxO6ApnHANPOtnBeMFmmty80OlzuVi4b?=
 =?us-ascii?Q?rVTseNdCNR6b1ZbybzlXtQl94/63HA9zdxtV8pn8U2MwkEsEwCZlLUSq6pDp?=
 =?us-ascii?Q?qnbGN0xpXkhXuOJyaNPOgsEyvtrioXHeQJSqk2RwxfrO6QIZDTYHEL7Q2+n4?=
 =?us-ascii?Q?G/rtl/P5HjdAgBSXH1VkAModS+1LOcs6JwJhK+OA2d3YN8DFW4qMbh7aaYaR?=
 =?us-ascii?Q?I4ZqtlhOfk+Wp3oD3Awc0c1WuJWXEyalVtrQLUaOou1M5GDMkB97SSRe3AX2?=
 =?us-ascii?Q?OQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6786ac35-914f-4ad1-4c7d-08daf46f9bba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 07:35:41.7415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NvH1mP/lt5TxC1D2MTvv8q0v5yLG1lVXT24U6si9/FIkw6oaj2eIrnq9+2Jr8PMfDG0przLXZXSNy1pDv3z5XmE5oCSYg+CYOnTm1SxsWO1dAMNdoGrsaZu6ZU/nUSH3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8518
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski, Sent: Thursday, January 12, 2023 1:19 PM
>=20
> On Tue, 10 Jan 2023 18:55:59 +0900 Yoshihiro Shimoda wrote:
> > +#define rswitch_for_each_enabled_port_reverse(priv, i)	\
> > +	for (i--; i >=3D 0; i--)				\
>=20
> nit: the typical name suffix for this sort of macro in Linux would
> be _continue_reverse - because it doesn't initialize the iterator.
> It's specifically targeting error paths.
>=20
> That's what list.h uses, on a quick grep I can see the same convention
> is used for netdevice.h and dsa.h. Do you have counter examples?
> I reckon we should throw "_continue" into the name.

Thank you for your comments! I didn't know suffix "__continue_" on macros.
So, I will rename this macro name with rswitch_for_each_enabled_port_contin=
ue_reverse().

Best regards,
Yoshihiro Shimoda

