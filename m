Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8E25E6FBE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIVWc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVWby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:31:54 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130084.outbound.protection.outlook.com [40.107.13.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2128EEEAA;
        Thu, 22 Sep 2022 15:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHqy+Yd8Y2eCwUVg9uUwGdCW8WVbprO3QC6hA0nbVh8TeeuD3Ov6xMiwRalEMNTA+gBiCD6vYKM27U4OuZvzumqzyAjGybG2bibQqtMGZBJ9QECDBVnf+QBmFD1TgOcn8Gwg/6K0HN1P+ldbIA5d0ZwS0pI78h52E3w3JDVEVwx8P956F97ymUmzXiDICVjDJk7SxVv3dxGnNo7arySW7H0u5e4LqrStplXzNrkmEmrWk9pY3XmsdVWpFz4wAw48809Xz/SEdnDkFBUJL36GfP3kI5na0NhOLFHHaNOeCnPbckrOe+yZfynOApnRstSd08saLWNvQ+3n7eZ6aeNTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwlVToC4b9u/PgGd7faJz8L+zRzwRMilEPArAuvznKU=;
 b=B68/d39YCXrQwM1qzzKg8bywqTNE6bdSNylfPBUBothnm8MsOmwFpV+RxoWzU0yZyb2b0EU+lgB+HT9JDPzcYvro4eKlXLwuDM712bsI2nMXSoEW6twvk7JryWh37EA7i7bBzzGRir2P2Ag2hmLrQCDfRMmrvhThlbTJ6HIh4FmrM9je7CcZGp8go5VGfaJyOZvJmKiNkLczpnYaAtfMmxQq1GOehvgybl6Chw+nGr+/ZyczroG5g10fiHVar3Xe/a9kiEvb5tMhgbLAiaUK+ztt+sOiLkE+X6j9MX6oXYQXP9StSoVv1AImr1M/kGeEoaXn8UyKGAGPn95aiu0kdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwlVToC4b9u/PgGd7faJz8L+zRzwRMilEPArAuvznKU=;
 b=k5p2ALFoAKXb/K2DzvvppOo6Zsfilaqm3VN3KpfgGKGtWsW7GjdOggEnFK8bz0ed21Q2GG9djmO1G1loYGkAvEE4A3MilJPEwAbVfY5ShF5wmpTufsGhsPuGtEsnvef7LnbDHoDlbLtcJweD1fRcLREtP5kiGDaqo6Y4/HiR8D8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8921.eurprd04.prod.outlook.com (2603:10a6:20b:408::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 22:31:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 22:31:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/sched: taprio: remove unnecessary
 taprio_list_lock
Thread-Topic: [PATCH net-next] net/sched: taprio: remove unnecessary
 taprio_list_lock
Thread-Index: AQHYzaB0GzTHTKtug0m2XE/i2+C6E63qg0SAgAGHsIA=
Date:   Thu, 22 Sep 2022 22:31:50 +0000
Message-ID: <20220922223149.aietnbdpqojsuibk@skbuf>
References: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
 <87sfkkfhoc.fsf@intel.com>
In-Reply-To: <87sfkkfhoc.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB8921:EE_
x-ms-office365-filtering-correlation-id: 8384e09f-0b64-44e8-015b-08da9cea3df5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ybe9xFCe87EvMenPHj4Ko+XV0iRYrLlWRgI2dkb7TlEjT+Mtz64dJAQzNrUcIVdjIlOr2sarnYYDcvh59CmmakQhQHWIc9eicq4g35OpJMH9hbO1CeF7D2cebiF1JyBAoG/Njz+969+bGc2OI2J3hBqf6MHiIjYj7HkF4CgC2gQtRBf9f3ONxQ1L8YDPO0K+/6Rk9uZBrelbWXTjPIa6Ou/cozumK7UvaYc1nD4E/neqafdWfoK49lOhCKx9Yj80m34Pc74yhvBA4eA8U/byN2MLGz2wcG7fs7YKTjvQSjgH6xwbblB7onKnPAj7RWfrJmzAu2tEeqfB0fnrTIrLV5/GN6BdxbJKbtgtqTbPThFCDlSxx2CafWIgvbEjYTXuNLHlmKsF655RQUQBnSnI9i5UpSywjkVpjZ+DNSF4O9VJ4i7TvvyoxFfqJE49zw+trJivJzWQ+o/xe67drsXOd8EsYhxOstjeBauLl+QSVBRNxtSW8nHTqjbQ2h/RReWn4Brj9v6mJud/ID73gunAmwyWm0wJZY5KziV8CNzqVACJIfFzRspVlYGqiEMVAWIA4jw1KYiliGrMO/5Jj9slUJVRsydEsnOzZajVYw+7LTpe2pQW0gz3jztuQM93A0HmuLGJ1VWttDUNJWpnVBRDUjr4evKdOA8wn0cMYKy01Fg7hm+qPrzRVRcwllhlHbD6WADFZdFgWKT/vznrc260EtMjC1lcihJhNKbINfyT9Mhc2+sJQ5js6iY+rqqj7fwqzHZWp8HniaG0onw+kD33vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199015)(4326008)(91956017)(66476007)(64756008)(66446008)(316002)(26005)(76116006)(41300700001)(66556008)(44832011)(3716004)(478600001)(6512007)(6506007)(9686003)(5660300002)(2906002)(7416002)(558084003)(8936002)(66946007)(38070700005)(33716001)(38100700002)(122000001)(1076003)(8676002)(186003)(86362001)(6486002)(6916009)(71200400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g4tYjyOPWXM/t5vhAkcg9bdf2MvagVp7e5r8nttRxKZlSyd2MmUATryXWbIr?=
 =?us-ascii?Q?ZpfbohPyIMsX4wJrONG7JpXAVCyMsprdAhs9CzSUZzvgjTYT0m/KSrMRi9sd?=
 =?us-ascii?Q?BMn3ENsWh8c+Xj6Wg3QJMFjlke9lZoCCsdkfPnXgYV+EjRCW6cuz52cR0TAe?=
 =?us-ascii?Q?wOCQ+TjSy4Wucwd7Uc1aymFWTChjGmUfwdrTuGQSQmUluffuplOT+222uQSl?=
 =?us-ascii?Q?La2m4HkaW5q6Ci70Pe40fC8/R9LTpQREHnA9qwWBmdIdYAEPJ8PSIiOcKet6?=
 =?us-ascii?Q?CjE3rwd7HjDbyqb015qlpeUM6TL1Pi2YwH6HYqICbDVcRjyFCBoMnQ1OUNlh?=
 =?us-ascii?Q?oyAb4pzmpw+o/xMqCj0BBVYrWU9a+uASHqYlYWJkWNcKZZAqDifYyMqUb7qp?=
 =?us-ascii?Q?0uXk5i5s/Hi3zXsczqmd3FsDmAodtTjbJJswwz6drgMDyi223+Q3nkAizNRW?=
 =?us-ascii?Q?CE94N+BwAxjfBxSr1YgCNCKFwN7mFNlDAwd6unPuTmeohgVyMGQ1b9JFYstH?=
 =?us-ascii?Q?ziWLgfA0ejmQudkysRrGbH00SjalKmg637edLa95NX17/b888RU9c9UIakP7?=
 =?us-ascii?Q?1N082zRWYBeM12HaEoxesOHysGqYRjt6Va4Ul79Eww5cVetcN9mlDNdGJSGi?=
 =?us-ascii?Q?hYs7flF7anPSks5KZzLnbMBhCZOVDn89rYd0gmEHo6uoHE2kNJ7CGnDrTbLg?=
 =?us-ascii?Q?LWWOF5qvUl0I3hU783VN6dvwydZNuYVxzLIKTo9Yb4RDhz9wwt6BRkqMFpA3?=
 =?us-ascii?Q?CuZDrQDhSnkpAIpi3roEbI07OF618tkPZzTTeQzTD93XvAcg+sbSEozJbIHq?=
 =?us-ascii?Q?WVaz5TjUlr+2eDR3JosL9m6kFdm+ex9IX29OaxaxTY4bKbPpQbscC3s4wNL0?=
 =?us-ascii?Q?Goi3rks8fhtMuJeoZNgCKfmA5WuSlXy/1Nr0YX33AX68iVt97j9JuqB2pCiM?=
 =?us-ascii?Q?+3/+34JJ1RGrirQQ67NL7/Rn9A3cKT4PtWMgcVfTaprAiHv/HaCz7Vjazj3f?=
 =?us-ascii?Q?+ew7BTxMnrh2O8ZQLPneB97x10Fp6Uhp++T9eriF+Q7sQAs3rtCSoHvoqrJe?=
 =?us-ascii?Q?gaiM/9DfriVoSDDElPUzAb54q4aX/Dxj8E9SAx9B5RgiZ3CurgBdHLGYQOMd?=
 =?us-ascii?Q?T/Hi4H+3VEa0+2k9QUcmoEFh1qkKPsRN1r8cVgFr34MrY1WiMVy0EaknZTYk?=
 =?us-ascii?Q?/p06MP3gvLEjLQ59J39DCMwkoZDj7n8utDi3GhoqNtbHelHVHSudnnJdD1vN?=
 =?us-ascii?Q?Mxw4rWL0D5gyZ166xLMtr7D4J8xsM95oF9nN0lmQrVgj/9DYGHEongrNJyl3?=
 =?us-ascii?Q?YsIVDjVogW482hHJH/ShYpziNT9hIRkZJOrx7ir2Jg7gNKexJo45Ft6TmfdO?=
 =?us-ascii?Q?yJrMxAqRv47vDS0hWB38sMm7f/sV/8b6NN+erOqZUikIsiSfbBHMKuEzSxMX?=
 =?us-ascii?Q?iVx/INRMlOXaM6Yvi8PqgY5uPwsYesGLKLt5mHWCx7W5bbKQUKfsyNFeZNb/?=
 =?us-ascii?Q?+Ejny6zemM6epjB8kOMJ4dSYyJcONaA3nsfG3lqMRVmR2UDm7t3U6YiyzQVa?=
 =?us-ascii?Q?NnkzWFihNrQ5QsPfkoA6ylXiqVTaayDGV4p3z+HCn7yiIGxeit+UlLGfrbYL?=
 =?us-ascii?Q?2Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <779D30A39FCC4E47B706F9937F1B609F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8384e09f-0b64-44e8-015b-08da9cea3df5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 22:31:50.1468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxhXHagw3QP+sok39m5oyFw1M1+cgEkfxnqhVrcypCQMIP/Lat9QjtoVDs2y3mKfjjvRNM1+sNwyJtmruEaVaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8921
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 04:09:55PM -0700, Vinicius Costa Gomes wrote:
> Optional simplification: do you mind removing 'found' and moving the
> call to taprio_set_picos_per_byte() here?

Yes, I can do that (in a follow-up patch).

> Anyway,
>=20
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Thanks.=
