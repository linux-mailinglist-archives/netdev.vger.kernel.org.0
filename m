Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B1D52E8AE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiETJW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347583AbiETJWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:22:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548E091574
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6oNwoq9H0CrMBv55sESU1KPDkiYYDt8RMb9ywc2hongcnSwGrZpKzLe2qZqSJR+QEoQwbmkZUlva11mhTzbT+0xbczbd0/B+ZYHfOWZLCmsKVSrIrz5/PYNo0uUwp0Dgr849KqHGCoZfWTizj/87+QSEcO4mxyR2zju7iUD0/OcDwAjhuo5FSs9hZ48vMEnZa9u2hJGNEh16o9GIcWYx2y4vKlqkq6SGt5NIELv5cPcMYNye6ju080upkA7b0PoMNCFbhBii/awdrOsCBVeGI3qQWpWFk/XYejrHV6tsc3INoV5k1yMtwzJ7oWJBCMgF13nO96rAu41R/wyWxjnRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meGxfpoc5GpzGlfbDA+PDpidg8Bg+lh12FvB3BMNHx8=;
 b=KXLq3rVTRKZpuRipmyUhqK48aCoTbhU6AJCkWP+RI0a9d95MjTtaQJSHG0V1E82sPTe/7ma4Qsjz2EOLIdPEyW6C8KaJj8uo9tg1YL3Ph58bmx0T2POhX9m1/RqEqEF+ms0UWxuYIBr4JaCSCw2cP6jOJkKUhOPZUPZaxFSGzOIHjF5Fj9of0P+PkU8zDL2svA0Zi3aUWtlc+cXukcc6DL1q9MZKDPR7pmk6jE/WdbXHFBkPqbOf/iXQOxaBqMBj8Ayaj/HZ1cBjz6vKqHiT9dtiXkJCLueurALNqj5DEOSJ3n93DLWmKYvYZctbRxZFMVBiL8Srr/hi64FdBkZmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meGxfpoc5GpzGlfbDA+PDpidg8Bg+lh12FvB3BMNHx8=;
 b=r9udHgOwUrQ1oWFuCuxoDzVQBLa7XI6wvyK8U8zOJKngB14bsjeOUo8k675Vn3YCuZMK8MhVDJNJP0ksIjaxIOiV69kiDtuH0ReTbcEfGOt8AoLp2XCbXJLxWpDFXhQ8VhqRBT6/wF0Hpb1y4Y7hwEO8JcYI6XhwhmywVKlS5O0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3437.eurprd04.prod.outlook.com (2603:10a6:803:7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 09:22:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 20 May 2022
 09:22:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 08/11] igc: Add support for setting frame
 preemption configuration
Thread-Topic: [PATCH net-next v5 08/11] igc: Add support for setting frame
 preemption configuration
Thread-Index: AQHYa+cusP5YXeof1E6yfxxHE3NAka0nfmSA
Date:   Fri, 20 May 2022 09:22:18 +0000
Message-ID: <20220520092217.w4bw3pl6b5hum75g@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520011538.1098888-9-vinicius.gomes@intel.com>
In-Reply-To: <20220520011538.1098888-9-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b26d4ba-e260-42d9-7641-08da3a423c7c
x-ms-traffictypediagnostic: VI1PR0402MB3437:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB343751763275EA48A3D6BE2BE0D39@VI1PR0402MB3437.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HVDf1MEQ9C9xVRVdKe93rJFULQFyVP3x2rmYfn2gskSb3SEnxnfdXCwhjzgbr6FaEO7WX9egSLzWqM6GwUMf0wjNdlG7d4SaGccAiysY6jRTjLOB9iW+lOjHwLxFGZewyTIHkSEqlLs/pRTHvuHXQy7ktB09indjuU/ATuHVEfA708CwtJnn5wENzvL5NZcIjN7Apwd8fMJIygnHO6/BIkxiOf2SkJK6MYa/2B55emSR+PJDndTr3/+FXOHYZfQON97d5mCfce8oyAxXHbx3PWGuQbgPVb38lA0OqyZQdV5fWm7YxXbZDbHZbHhq09a3teIn0xutGh1PVzpqMGrTMJdu6P22/rB36khNm4udjgMH/LboOrTumRgpVuWBC5Dc0zcOaJfXWq3tcSVNLpPGnEJb3NVXLTDMcgt1SGfCR42O1DFc1w5wfkrBvvgBWqFEOOIpNc0KL+bwQwb7BUMaS0//Bs82kjRntv/11Qb9II7ez2QpqP1If8I74isVNx/nq8hzmaIpxeoYjPmRXxkx3Duh7NBr4V0vf5+oJ4a57Hd+/0293VSD7NB7DnnjQ76EC0163z8uWGnKby8m1FaZ0AeZzJCiVv+cNiWAeoJz0TwppZ4/PUOVqRAYQ4scJ5yyntK/7/+u5CakHkGFJgUFKWmWDoLIzr9ru+vJWnvTrsoEjQ9RkjSV6utQZOOvQuQK4MCWUOM6hOJYS18/pMJCnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(44832011)(6506007)(26005)(1076003)(508600001)(186003)(4744005)(8936002)(5660300002)(2906002)(6486002)(9686003)(6512007)(71200400001)(86362001)(76116006)(122000001)(91956017)(66446008)(66556008)(54906003)(6916009)(316002)(4326008)(64756008)(66946007)(66476007)(38100700002)(33716001)(38070700005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I0+T5HZ1WOhHvHVzqdi/aIhlG8PuwaMsRobkDyc/4+yMzCLEMGzKKpvDykNs?=
 =?us-ascii?Q?1YxUYJFKjJhnNbtkFyCmQfH83a6DUMZ7mwT4p9MiPi6SCMYKatrcq2y7XUGb?=
 =?us-ascii?Q?tId2GK1gqlJhe45UIrh+FzdnRmBhiGpPXqgn6MoM5DymkTw4+jAzmUjT/57p?=
 =?us-ascii?Q?+k8I3l7cMBtY6bRN/ffn93a1Xpa4qkJFLE7U4b1wwNNQF05iCE5C5Ryy7LvC?=
 =?us-ascii?Q?vx37ukoZuZxB/6Jwb8kRh6W209LtO/7G2GMV7u3D9XyKoGO7JwjpKCUZuZny?=
 =?us-ascii?Q?nOkEOD4FnxfgZ+YKjbYvM09ST5498sT5jt8qmrW+sCB35xiZFJEoIY4yC5/a?=
 =?us-ascii?Q?fcm7IXjQfLMx/7esPoFkd/K+37+p0W+KHiSX3nlaLZzONEoGvKyxknpOhIc5?=
 =?us-ascii?Q?K9rb0JyN2Ycv/9cc6tf+BsftM0/0hYR0dgZnfM//3/pW/g0i62auzTuU+jTj?=
 =?us-ascii?Q?3XwB6+L6fW4EFGKrcRNXiyaOsSl3wvru8x0ilSQ75WFj7jyoJqA9qFNNoGVc?=
 =?us-ascii?Q?EozUQRMN7jiqzDB7QuBZOhNQijT0gsrGchNQswR7b98ovi/kJgrTe2wIOfhd?=
 =?us-ascii?Q?FCFFyfDRrcz2m2dlkXBY1iUVNw5VTW9g3JoERSjOn4L/2Twa34v/C4F0GQbn?=
 =?us-ascii?Q?tK1kxrZIhNzbCAN9JowxygHZvkPBJn2H5Tu9MYcaPlSmtnYWe8NYvf9zkDMX?=
 =?us-ascii?Q?yzrqQgY9IEdvfarETULWdFXcuk1R0yqF0AoxxjBGhYJ2PfVYkZCLcZEYFc0Y?=
 =?us-ascii?Q?H0JwCHIfvPiB5eMzN5uXKv6l+F1OYNqt3dNlxURZAlm+r6safR16QJ/5qI6G?=
 =?us-ascii?Q?X157Grn2OEQsD0V8UEwbLQz/fHvnNGWb4LDbAvxrsX8E0APXi/qqq+3nMFQm?=
 =?us-ascii?Q?Mxlwz4zi9b+WIArehrhp48GLd0pxEppcH3Y/tHW4QWsfp0CY2U6iC+Dt8jci?=
 =?us-ascii?Q?Tv9RLDW3D/xBZ0YOF1earI4cqORUG2+n23/3eplMiqzkpzfX701zauHUmoYl?=
 =?us-ascii?Q?IseLJEmBqXhGpWSFnVi9MpRFMJ2CARq26eb3UGGmhhrUEyGJ/yTGJ5EK+KvG?=
 =?us-ascii?Q?jwkW3J2KCoX0v1al66cHt8yHIpzjuXQCAV7GlT6/wDlb7BWj7XzIQxIaYamZ?=
 =?us-ascii?Q?dssA4S5P2ZhltDRvaE14m7iHzzJvAYm0QurQfyTDQjTGpD500VKI9zsfEgAu?=
 =?us-ascii?Q?VHrZu+FLppvYOQ6TFk1e+fgKw/vzAwo3o6QP8+Lwu5XurflMk+03PhgeU+qH?=
 =?us-ascii?Q?FjH4BSF7zN7sERtWsA9uIjQnQbcQiDtQ3aJEFWcaKlBdkamufmyBLmg0CuOr?=
 =?us-ascii?Q?z7HjeK51x84/4Kpz4mycSp3hERyrMnl+UvvlLekxrV0S5Vjklk8NvPD584Nv?=
 =?us-ascii?Q?afQ3pYTxof+osu7OQGkyyk+xIuTnR7W9iQl8CcEzUgBG0RZJdE4DHvsZkLFe?=
 =?us-ascii?Q?AgxNYvxsFZiIxWw13GB/Djv6/zKfwR9zhHQZqFQa/jSOQH0Kda5f4NuXduiD?=
 =?us-ascii?Q?f6HhR9WV7kxtb053sJgVCOzx+pDXcL0lastd0uRImA/88pXs9/l+XWMxMLHR?=
 =?us-ascii?Q?hpAne8p+uJp1Bil9EreiJGpeY/WcptKOX38UrA10nwg/SxrXTzjHIjF7hSyI?=
 =?us-ascii?Q?n/hXSqk6VqBttwkvnRC3zKl5YfmzVm2mhLQ6A4X3akSidTxHgtaQfM/84NPK?=
 =?us-ascii?Q?vm1StNof7qP9PZ/q0Q3Bg5ocaWNFcP0896AiDkcSjRwHMwcTFTMiKkOyAK8N?=
 =?us-ascii?Q?sRb4gZbSRJ3mCA7ukLAASx9v9G66jbQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF28E7ED995DB645A4C02B61A2884799@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b26d4ba-e260-42d9-7641-08da3a423c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 09:22:18.2920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 30WEhumLX9mlVGHUp7YzjofQCjizG8A4R/A7HHf9Q/3ocD+KYs4Z5YWjwTuQ9zKO9stiD8jipIt0d+IT1EsNoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3437
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 06:15:35PM -0700, Vinicius Costa Gomes wrote:
> Set the hardware register that enables the frame preemption feature.
>=20
> Some code is moved around because the PREEMPT_ENA bit in the
> IGC_TQAVCTRL register is recommended to be set after the individual
> queue registers (IGC_TXQCTL[i]) are set.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

Could you please squash this patch with the previous one, which just
copies the settings from ethtool into the adapter but doesn't do
anything with them?=
