Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58B5F4B03
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 23:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJDVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJDVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 17:36:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2529254CA2
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 14:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYL64iFVc4EC2Wkf3NfUmxVnjcUjDsVP1YnTj2+UtGgSUPEj7ugjk3DlBJpdUXCXFNgTysrG5bD1kWibd55qcLgI8njjxppWgCdbKCrtOG5OdInWIF9o4RbjOKkXIKj/+9MHYe3RCS1LawRJUExFyHRyfG3I3Q5b+AtqCkgtaqC8qzKvCFg3DvL/wFPvXmpRefmJXNAWIKQn+tOANs4mR/OqCqq3aEktENRnNZIxyCubPIuwEWn5vqpHPy7WtdiF08f9+MV4vxeuN8lJEu8njZml7hVPPpvvULjLw/Z+QDjbR4tT+G5qDV0v+V+aMM1cOVSyWuBVXy20qbpeCWPn1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5g5QvUqudIGbTL8RXK3SGUvTK/mGe2XMyKkhpI6TSfY=;
 b=XZAfesaXYtHpp6s4UC9UUyFZG9pgQ990yCK+AzNzsX+1uDtEVDCAu+GvF1oezgXd2SbT57HgM+IIXqtNXY3bZTLdR88Cy6MxAcTCAnYbO3duheqcoW9KcAQGMh7ByRKuK/VBy4F8w4fso5vIPWnu1NUjmT7OqljtxdvY5a6jCa3oDSW76VGgpkFXAg9FLiLwmkh8R/M3HuWFj/krQd7vr4ePFUcFR62XoegODq7c53H95XDF/WHoh/di0qw5qBe62OBq7sG2Q6cFtjXxwd8dL73+XCmnV+bcuneA7V8vusmtSsgLxtQmb2s/r2iBzl81I9tSEfdoHKy8WwgWMSSHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5g5QvUqudIGbTL8RXK3SGUvTK/mGe2XMyKkhpI6TSfY=;
 b=T3Ln/AgtG0Gd1RXWeq9D2DZcefV6f5Ht6I4RwslpJMzJUodsK93hVki1KJV82U8l1I4pCZedXHqBSmKqOSvSmR964BryhEd1Hv8J6pSpUdQuYyW0oaR1F/jUkzwm5PjDSlgM+gPWnYjmY9yFcaXDVayeR5Walb8ESU9Z8h+um2E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7879.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Tue, 4 Oct
 2022 21:36:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 21:36:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yannick.vignon@nxp.com" <yannick.vignon@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Topic: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Index: AQHY1RxOd1dFmi5dEk+opmYKbXniaq34lZOAgARaWYCAAdiGgA==
Date:   Tue, 4 Oct 2022 21:36:18 +0000
Message-ID: <20221004213617.7qodtbsr37wkyavj@skbuf>
References: <20220930223042.351022-1-vinicius.gomes@intel.com>
 <20220930225639.q4hr4vcqhy7zyomk@skbuf> <87v8p04y6o.fsf@intel.com>
In-Reply-To: <87v8p04y6o.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7879:EE_
x-ms-office365-filtering-correlation-id: b46f2c1d-7ebe-4c19-b068-08daa6507930
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOgTKDC84wKSFuYAPA0E2E7NbxKMdCRKkKCiUU3CBNOnnEJpxfv9CmzwzqbUmcmh/Xf24CyAWnuGoPFdMVC6LkweiI4XXiwX5ecWLGvxNxVK1uod5xxP7kZpZh1gMzpXvh3xS2AGFP18hKHfk1qQJAM5icv2GQKLzFm/RH4u55ygQo25jZA51vCUps0GByUYcskOSbLPbbu3UNpKpBUYaJBiSL5SiIo8TixlSOvRTucAjpOlbQ4HF60K6XM3IMXHbKOjNanKbSETDtrzYEcb+xuq70QZ/qb1mQoQnMukD1E1MzEZ8vXgR00bQMZFT2IfaYxrcbOEgAlwIEDjolhgyuHLaRS2VnITSlWpkRK0bRzXTHzBVMJv6Bg/iJUxfYuYvlKV5EAn5ZPDHItjsfLhRH/SKpKUMfY4Gv9RbRxn3gCYwS4hg3IKmAFCtRMNy1qv1sKeVG0nuAdukjPf7umV3Ss/5b2DFu3Wvqtq1GqkMxh7MOqELj8w6cA6rq2veEnpDh4InOOHObbPT1aVEW8MUSiuKX0pHovVF7nApuqu5WI+3qKMa0qyGUst9y/ooBa6wOdWhLSeXwPxe4D70kS8qQTbwmSLxgSFOrDwLUZT7LbxHNdSgf8dwxEkxIbzk5PW2ik7kkOL9n9h3RvP6jmr4Do/ByYJwbkPrVOFBaCXT5QT5GU17Y+tOCyX3ebP/Zne5UH0totBlqnD6Ue6GjJTNCL34ue11FKJUPqDH0bDYYvPaeePP9otoQnaM+UPWvyO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(1076003)(186003)(83380400001)(38100700002)(38070700005)(122000001)(9686003)(5660300002)(44832011)(2906002)(33716001)(8936002)(41300700001)(6486002)(478600001)(26005)(6512007)(6506007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(76116006)(45080400002)(71200400001)(316002)(66946007)(6916009)(54906003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O5gcHRkRWvCBFLEQyt7FVVTGYiiQsq/fzoyywAG5l8aN4rQkez06evTBpIg6?=
 =?us-ascii?Q?frXomE62GnklPGJBBI1BvsBtgOihMXyIj7WVA3vPgOaYtyQYOFBH2U0WYe7V?=
 =?us-ascii?Q?k5GUzxwy+7K7H0i9RRmCjx8v2OIEQP0AzgBDjBtIjzNTKYxs9L6r0UaYnNH0?=
 =?us-ascii?Q?KLSbwX6B3kuOBsUIQz3WeQOymD4vuZS9775hAgJGBvkSM61eKsx6qFewgI5y?=
 =?us-ascii?Q?pQPm7EMgYDyDXHk2lsOD4GKC62k/ckE/0U59hROwdm8lUP0tooTgYogycOrV?=
 =?us-ascii?Q?4yKda7cxbSIwa6ZcRT5umzOqSmU+nEo8boLvQaILB7XdFXfr14z2L8SFco3M?=
 =?us-ascii?Q?Vza4kiYtyyCyn4UZG8vJPBCb5en/EMLgpPeo4URqoWUYoaESoWBUXACx5j9Z?=
 =?us-ascii?Q?wFqgvudfwG9doEsQVRmPDkaK1hyIW/1255iTlkCzHgnkTRcqsekRRbxwKxa+?=
 =?us-ascii?Q?IWU34nW3/WostdRvVRQ785OMfvOxym0ojLiYH/T0LMvjrTBIKsI+8/AZuqAe?=
 =?us-ascii?Q?plXMr2QpZax7AX7pMu+7kWVn/bOZBWOT6uKpxTqPHoWutJkbhlHNQpX/60kY?=
 =?us-ascii?Q?qkkWUOa2csV5Z7n9kKVoy2blO4FvoqSMyRIoKe5ZoJCiyqwGQLZMdhxcmGiK?=
 =?us-ascii?Q?iIl4Ap9VpBQm38nZUifvunYAiNtUbMF88nV4WOrV903NBcv1Cf6hiRAImrJL?=
 =?us-ascii?Q?/gL8v1LPm6OQmlem/hvoYLtCw43q3+b0TiKm6TRU7MRU9JuW+Veo5iWd5NTz?=
 =?us-ascii?Q?WodpXGikUJSpkDXcd3019QdDIlTbWsQpux8bgcU0efNB93f7C8NK+HChCqzQ?=
 =?us-ascii?Q?BMVt/whENGSbpXba1sEYtKOb+u2zHaT1YOvVTI6lxn/7wwjaR1QeoWlh/2Hx?=
 =?us-ascii?Q?9aRONgbeG+rZYQoHMbTIHSvmzm4UG4HGwAimsnFVIRWhT4jyyUzN41CYCaZx?=
 =?us-ascii?Q?HCSEXrmKxd8l/vp7oggNgWpD5NRAsteZmfPjM6b22gFDq4oZhGEovbzjO+do?=
 =?us-ascii?Q?cNBvre9nQADLhnYUnIry9wxkqwjMxtMkHpT/BWUCEb6qTBKE7EUXqjXmQYT8?=
 =?us-ascii?Q?XPQ97Y+qQ8Gf+OZVDyh8BNGFctJf2rdFIFNhPp4CK2Xe6o8k9oCGq/+1KscM?=
 =?us-ascii?Q?8PBKKebZIIbQbj2/U5d1eZHsMGaQIPUJvH10K56C+U93PifhzSWiZF/Z8Iw/?=
 =?us-ascii?Q?iEnsscKR2ERMgYz2P2EW3VRAtpRgmilmySw+6R9BLSbiMGze05uQfAFlZGB8?=
 =?us-ascii?Q?ikVn0UzSniYfRJYn76/4/Vvc8ONiGfRNPPK8EXzRFyItbisRqUWuQC+xYwRN?=
 =?us-ascii?Q?8EgJDJrf7lkLJO9ovE0jV21zBpRU7qMZ9j7+WX6TQUrStt4F1WZlFFoPVFef?=
 =?us-ascii?Q?mF4EzkvJs+ybWsQ9jBeS+diYT62Ta3NTrjzT4nT2chmfca6tEX/lhrJuXhXX?=
 =?us-ascii?Q?zji6kjAk75uw1gvAZvvHyh+EwMcCbVUEhvqfNOQQAPWiZU99xHqyhDgDBdDd?=
 =?us-ascii?Q?TrrhVFTDdqfcyG9HxgrxSunz2DtZsG5JQpe8XuQmLpuIWtNqRrE7F0Hul2c/?=
 =?us-ascii?Q?O4X5ON0m8EDoFUh8QPY3ccMHHOAn+SuN0KcBjax6q6HcZaYIW7PT0mcGMdSC?=
 =?us-ascii?Q?Qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9515CB93C1E3B49A6B7DED8DEF9F482@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46f2c1d-7ebe-4c19-b068-08daa6507930
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 21:36:18.6550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DYzwiiQlKnRMX5TVxk+Vq8zw2Obt3+qRj61SNhvkqGR19L/q3YnMLkSrqsFOQYzVkeQpmzprAMq5XRXsVKjCGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 10:25:03AM -0700, Vinicius Costa Gomes wrote:
> Something like this:
>=20
> [   73.174189] refcount_t: underflow; use-after-free.
> [   73.174197] WARNING: CPU: 10 PID: 878 at lib/refcount.c:28 refcount_wa=
rn_saturate+0xd8/0xe0
> [   73.174204] Modules linked in: sch_taprio(E) snd_hda_codec_hdmi(E) snd=
_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_int=
el(E) snd_intel_dspcfg(E) snd_hda_codec(E) snd_hda_core(E) snd_pcm(E) igc(E=
) snd_timer(E) intel_pch_thermal(E) joydev(E) usbhid(E) efivarfs(E)
> [   73.174226] CPU: 10 PID: 878 Comm: tc Tainted: G            E      6.0=
.0-rc7+ #13
> [   73.174229] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS UL=
TRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
> [   73.174232] RIP: 0010:refcount_warn_saturate+0xd8/0xe0
> [   73.174246] Code: ff 48 c7 c7 58 4d 61 a4 c6 05 39 59 ac 01 01 e8 36 9=
2 71 00 0f 0b c3 48 c7 c7 00 4d 61 a4 c6 05 25 59 ac 01 01 e8 20 92 71 00 <=
0f> 0b c3 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13
> [   73.174250] RSP: 0018:ffffa24c8336b9b8 EFLAGS: 00010296
> [   73.174254] RAX: 0000000000000026 RBX: 0000000000000001 RCX: 000000000=
0000027
> [   73.174257] RDX: ffff9ebfae49c868 RSI: 0000000000000001 RDI: ffff9ebfa=
e49c860
> [   73.174260] RBP: ffff9ebc0a4eb000 R08: 0000000000000000 R09: ffffffffa=
4e72f40
> [   73.174262] R10: ffffa24c8336b870 R11: ffffffffa4ee2f88 R12: ffff9ebc1=
0bfc000
> [   73.174265] R13: 0000000000000000 R14: ffff9ebc0a4eb000 R15: 000000000=
0000000
> [   73.174268] FS:  00007f4b546f5c40(0000) GS:ffff9ebfae480000(0000) knlG=
S:0000000000000000
> [   73.174271] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   73.174273] CR2: 00005587d1ad02c1 CR3: 0000000128460005 CR4: 000000000=
03706e0
> [   73.174276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [   73.174278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [   73.174281] Call Trace:
> [   73.174284]  <TASK>
> [   73.174287]  taprio_destroy+0xa4/0x110 [sch_taprio]
> [   73.174295]  qdisc_destroy+0x48/0x180
> [   73.174300]  qdisc_graft+0x573/0x6b0
> [   73.174308]  tc_get_qdisc+0x157/0x3d0
> [   73.174323]  rtnetlink_rcv_msg+0x155/0x520
> [   73.174328]  ? netlink_deliver_tap+0x78/0x3f0
> [   73.174334]  ? rtnl_getlink+0x3d0/0x3d0
> [   73.174339]  netlink_rcv_skb+0x4e/0xf0
> [   73.174348]  netlink_unicast+0x15e/0x230
> [   73.174354]  netlink_sendmsg+0x234/0x490
> [   73.174363]  sock_sendmsg+0x30/0x40
> [   73.174368]  ____sys_sendmsg+0x214/0x230
> [   73.174373]  ? import_iovec+0x17/0x20
> [   73.174377]  ? copy_msghdr_from_user+0x5d/0x80
> [   73.174384]  ___sys_sendmsg+0x86/0xd0
> [   73.174400]  ? lock_is_held_type+0x9b/0x100
> [   73.174405]  ? find_held_lock+0x2b/0x80
> [   73.174413]  __sys_sendmsg+0x47/0x80
> [   73.174423]  do_syscall_64+0x34/0x80
> [   73.174428]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   73.174432] RIP: 0033:0x7f4b54817ab7
> [   73.174435] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1=
f 00 f3 0f 1e fa 80 3d 2d 9b 0d 00 00 74 13 b8 2e 00 00 00 c5 fc 77 0f 05 <=
48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [   73.174438] RSP: 002b:00007fff996ecf18 EFLAGS: 00000202 ORIG_RAX: 0000=
00000000002e
> [   73.174442] RAX: ffffffffffffffda RBX: 00005587d1af6f60 RCX: 00007f4b5=
4817ab7
> [   73.174444] RDX: 0000000000000000 RSI: 00007fff996ecf68 RDI: 000000000=
0000003
> [   73.174447] RBP: 00000000633b1a29 R08: 0000000000000001 R09: 00007fff9=
96ecc98
> [   73.174450] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000=
0000000
> [   73.174452] R13: 00007fff996ed060 R14: 0000000000000001 R15: 00005587d=
1ad219a
> [   73.174464]  </TASK>
> [   73.174466] irq event stamp: 7453
> [   73.174468] hardirqs last  enabled at (7461): [<ffffffffa30fa962>] __u=
p_console_sem+0x52/0x60
> [   73.174473] hardirqs last disabled at (7468): [<ffffffffa30fa947>] __u=
p_console_sem+0x37/0x60
> [   73.174476] softirqs last  enabled at (7094): [<ffffffffa3079d3f>] __i=
rq_exit_rcu+0xbf/0xf0
> [   73.174481] softirqs last disabled at (7089): [<ffffffffa3079d3f>] __i=
rq_exit_rcu+0xbf/0xf0
> [   73.174484] ---[ end trace 0000000000000000 ]---

I studied the problem a bit and unfortunately your fix is not correct.
It is not sufficient to call qdisc_refcount_inc() on the child qdiscs
grafted in taprio_graft(), there are still other sources of use-after-free.

I will send a revert of my patch soon, and explain there in more detail
what the problem is. Sorry for the trouble and thanks for reporting the
problem and proposing a solution.=
