Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C7A58747F
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiHAXjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbiHAXjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:39:04 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00068.outbound.protection.outlook.com [40.107.0.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6A04330C
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRj/RLinHbiHLuCWr8waeP3MAnmO7bGSaAtbJ/Jk9nHvsX1nGr/yzs4poKOk9Mv0pFaEfhMBenl5FP8LZhGTqAhoonsE0pg5fkTxRc9DiXpG60dq7MZPn4R/aJxvTvtBtmyJ2WWv4YM0/efAl4r4Y+kpz8SCvDNtDuQOuSjfpHj2xfPTV1T2r8qTlZnZIu2HVNOyYQDnO4W9uiyx09XgAWDAXLz8cN7CJmA1N5qTFt9a6bwMZgclXC3zFbbq1idYFHF0YvQRiFjEUy1lb2+k3xRw5Ghx+2CTy26LKCFNziupkNi0mseLKCxDlJN/bgsRQZMT5ATCO1uMOlkhgEM7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSBP82ZaXSzH1Ty1IsnPK/40bGUly42eWOOUZ23xI98=;
 b=M+Pu8vbiLQg59pLuAG0hVmVQXLekLrTAqf3CZsVqoKA1+oEz2BqcQegzGwPnlgXb2VFwHmtt/yiRndwbnbJ3Gx1JvqPKI8qTlzsLfeeCjX6o0M/e9xoUkTWmTQDQawixgy44Y2AS/X63BBP2SGYuX3zOSfLs67DW3IGuOiHS3KYDEe5YnzYVlPuOUHfWhC9PGhrKVOS1zJ3rGqRikJWSeg3SKUyVhTiMJxH/yiTulFV4SmWx/o9SL4enlXNKQR4iTaOri4TAae4po9K6RhaGGgcFkcMJE7tWIjVytm5ppWo7SynLB8oox0z+gmayPDZUMQXGANIQkL4bvSU+o+eyDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSBP82ZaXSzH1Ty1IsnPK/40bGUly42eWOOUZ23xI98=;
 b=iNvAEIastxaEF0rnc/pyrVRaZW/fbcIvj201i8h+PVUT53jGeZY5XKJ7wYdy95cdJ4PC3C1XWfkRf9p4xIjyJ0v2pFK0kAVdCgVb5zGqkUWg+YKRAVQ7px1IB+kPmaa8/R9IsNO9z/uxJxC2+q2K6i7pTz+w056ZVlJ9KsyzG7c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 23:39:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:39:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 0/4] Make DSA work with bonding's ARP monitor
Thread-Topic: [PATCH v3 net 0/4] Make DSA work with bonding's ARP monitor
Thread-Index: AQHYpNrVAUzimVAxe0KegKE9l61F4K2aVwOAgABfBwA=
Date:   Mon, 1 Aug 2022 23:39:00 +0000
Message-ID: <20220801233900.bihsq42svp4gkkxx@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
 <20220801105853.282543dd@kernel.org>
In-Reply-To: <20220801105853.282543dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 300bb648-9245-4e67-e138-08da74170317
x-ms-traffictypediagnostic: AM0PR04MB4931:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a3BSe5JiZKgApRsR1BO+dvdpgvcrwdXkHyUtGSTYaBBVxMKt2cVauLTrgEQYh9ECD5I70OO9Ga7BNrVviBvm08xB7JLDzDHJ3TymwZX6ReDtRSZCWO8x3km1VCMknkzhXkyswZ5tVT2xJJnQHYnjlhJNBNFGhfPCtcIHRnS3ljQYm7sp/fQnWzhvrgT0EodyJG/3IR5Y/lc3rCxUatBFS/K+rS0M814WZJo5BuD6ghVjf8But7RPFYyrUiuQSzdCqqKcVPOxEiiJ9j4fXAnHaUatFufsmPH33gQkJ0FS9V/tQLx5O40A4MgzmqsfRHSAERwgKAtuDCzM1WOpwAFrq2Se4Aym5Tejy84/S68ZzgShRgo/bBmW4oB5qxrilcF1/2jmltUP8zaVrTOebzjlSj/14vjNWcIEvd/aI1QS4EZDSIXBGCouYlmu+stW5XjfaMFS5eJY4g+MnQIbWkpkWXCcKUvbbFoRYxzb1wiz8/3A7qrCIKxjzXZT3QDXueSZHwBRtzwOehnNh1rQSoRTuKyHB6PEnEK7Byp7a13rjhvL3X94cTkQYJghPxg8p+dEwkw+gxU+t5DaXmlTe148pdoZR1E7fNJqxiZ2oI8VzRaHJxgSpjwgap93uhDl7+gpS6889xji5VCiR3qMOGJsCgyrwGvEli5q8N0PQ7c3hGd/P07XjInNyksmBaTR3FMPRj6hLQvWIe3OBEk3JB1ZB0Qg2tgtp/ieQazdXvCVs8tLVcc5cxgfE8PnkCay17ZTC9T9WxviCFKnVNBnAobfo67ij6o2T6A7TjktZ1OGzcc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(396003)(376002)(346002)(39860400002)(122000001)(316002)(6916009)(54906003)(38070700005)(38100700002)(33716001)(66946007)(8676002)(9686003)(66556008)(64756008)(41300700001)(66446008)(4326008)(6486002)(83380400001)(71200400001)(76116006)(66476007)(91956017)(26005)(6512007)(1076003)(186003)(478600001)(8936002)(5660300002)(7416002)(44832011)(4744005)(86362001)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nKB0lT+fY6m22TBHg7hfOCwEys6/8IQX4CUXzRq1YdikpnMVKu/a1gxptj34?=
 =?us-ascii?Q?VBMkGN9tbnEQS8u+AhJfjQLW1M9TYFnQxZCoSSkz9yGZE4qb0h7wA43OpppL?=
 =?us-ascii?Q?nw0Vhq0zZdWNCNujML6mTvLMNa0vVPbReut8bsO+V5DLa5lFdjIzd8lQISUw?=
 =?us-ascii?Q?vu4LvTv4BKJiOcS7xnDN+QL+ITdej0xZrad3l/xb0Wjp/p3Dzvh7hgvSQC+p?=
 =?us-ascii?Q?+BDQyePxyrqO/NHz5e5uCuuyUy88ZedqsDyEc8fLL8ahZb+JT4Ln+0JGSBDm?=
 =?us-ascii?Q?LF/onOhspZQ3hWEuSowFCb9fyqSWIXrG5CYb98+sYziMMl301mgo+t2nVZje?=
 =?us-ascii?Q?OBZ6NiLiBuuroqBFZedMcte+4zwUKJlaLsSjo+YRnY5ryc+Fu49izcdN8Zur?=
 =?us-ascii?Q?193Ah/1Pwk7bUcaDHWAaT3w7fBcI6FBH5t7UWit7PJ10u2V4RVEwejRkUr/a?=
 =?us-ascii?Q?QrqAH6wWeXEezUi6uVTSXNraPcErwW7gDI75uFjL0oH+fKNrmeIBYm2alagb?=
 =?us-ascii?Q?7xHOYYfLx8aEnor1r+RBumtZPI79B3F8rvytfVRZgyznhTUoCmRwIuCbHQe2?=
 =?us-ascii?Q?q2t8YHgoIRler8nKIr6+mN4GX5M1z63oZrkYkMy0Ts1Yabhv22Fspd4HCJBk?=
 =?us-ascii?Q?zBVV6ujS6iBctCQyscq19tW8ZbJkLeVA40tYrVvtf9SNMMDJEH6ZEqoustNf?=
 =?us-ascii?Q?zUTmhdB6/pAhwEOAlMfs1frO9vZLFLcqAPyGUc3hNNWf34AMpYnTVGTZHqwk?=
 =?us-ascii?Q?de3rD6TQ1x7ZvQc6Bf87qXW2wPBYQaj82Ho6G2zdrFBqYpVMBdTuDaIgjDYk?=
 =?us-ascii?Q?Fn84WtLiZdSlcu1l2KMSZPThi47HYu9wArcrFB5+FvEsPFJffdOMh3HtTmhT?=
 =?us-ascii?Q?dng1sDx6IjXwC9zF5WreDRVJ7BuwsaPxPSKpMHOP5UZ9/NwBiiGAbn+29mrA?=
 =?us-ascii?Q?g3cK2mWX0dV7E9l7ZH4YZ6d9alLANk4zP+G/wlgv7fQ+br4+Ibw4QbLbZ6pb?=
 =?us-ascii?Q?aD/agTu+YPX3gWh5vf0eo79GKPyu/4PC9SZ/fVikfemHOk0HfXBsUMz6Zw73?=
 =?us-ascii?Q?EDp+EhNYqmfri2tOmLSLY4sovlBxHPuwhP4lVrOXo3EGEoGWLb6J4UVCWnSp?=
 =?us-ascii?Q?BOoQmb5675iVeHQBWti15t3oPIj11/a2b/rUkeXFWNgPkVBRtu9bUZL7I35a?=
 =?us-ascii?Q?DbXUx7PFFQFoaAbFUFdmdADEedLxJ9Pr2VXYCvtoBZ8QHkeNfYFXpIR/aApI?=
 =?us-ascii?Q?aK6SBSURmyh1DOjXarUR/Hwnry5GbzxQZGUbavvFrXgGNOJdXSBUucTcE6mF?=
 =?us-ascii?Q?5N1j/N6R8AL7tkH34o0+W/gwK5zKIgOk1YnijPx6mQ2QjUGAUzuNxuDIpUrh?=
 =?us-ascii?Q?6nwGG3Lf+mqv70d60FXH1Rw9RKGvNHe4y3LEPNwGXybMbLeVeuR7+n1NHvRr?=
 =?us-ascii?Q?92TCIqfvF4SCvEyZSSoiEGk0fbnkP1blld4AtxM8N6ODd2vP3/2CocSxigdE?=
 =?us-ascii?Q?C5iBo00tl7g1+/PlfwpATMdK2MWe9UM0a8LJqfRgT5hrMqTecmpW3ohkhT+6?=
 =?us-ascii?Q?/j6Di023B0T+7yz4wQn913MXnqRQcmYnbbWGj4oPimr49UMof+lMDNsI/I6v?=
 =?us-ascii?Q?pQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <899B5898EF06C3419DCD4A4B5DD2B33E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300bb648-9245-4e67-e138-08da74170317
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 23:39:01.0688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vy4d1BCH/voU6yJTtAO85hyruUBpPMGky7Iv3EHd4/olNoIyOJ85VpyIfzL/JXBb2A12vJegwIvzDj8RjXYjCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 10:58:53AM -0700, Jakub Kicinski wrote:
> We can just tell Greg to pull them in after the patches appear in
> Linus's tree, right? Or are there extra acrobatics required I missed?

I forget what I was thinking of with the request for help. We can tell
Greg, but I'll have to prepare adapted patches for linux-5.15.y and
linux-5.10.y anyway, since these ones won't apply.

> BTW we could potentially also revert a31d27fbed5d ("tun: fix bonding
> active backup with arp monitoring") given we revert veth.

We could; though as I didn't notice that and as it doesn't bother
anybody we could also do it separately in net (skipping backports).=
