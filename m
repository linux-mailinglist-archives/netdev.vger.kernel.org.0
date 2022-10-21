Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6236081EF
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJUXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJUXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 19:01:33 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020017.outbound.protection.outlook.com [52.101.51.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321C929F670;
        Fri, 21 Oct 2022 16:01:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgLEVi1Bu08pJrKDW58mdl3SDZcoqyP0Jd0kZ2Yg3whSyhKTO5tW4HsonS1bNpAi6OOPtsgk9InFaeSyDlWzaykvnvIl9O3IU79zA1nW3ANY87qFLCOV3EE9Gnt01Foactb0n4/HAcPNtRchXE0M2LKBLDaLaqxbNFP3EHiTDZqXOm8XjgZkx6G/VauaQS3DHVUUO6ij6ORPu3QerPm+zZWffhxSgeSq7EwB1AwcekfycdH8A7IMajKNu3DxD5dlZNEVIpMMpgXQTqSTaK2Wt26/6neZF4cWZ3pp9SwDOXXgBHbpknJmBDqULakfervt8n/79fw+P9e9Ad2YIvX+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvefUcBipVUYZAq2PDSRMbyjbPT9fmIiddSiOlzVnZI=;
 b=JDZNjYGMf6/+MbTNgrZs2StzI+0vHaPVKdDqjBVRE7JlIE1U+yR9XHgeC3dALeVJ/TSKyGUCFw3t6UrJf74FyAM+nIPg8Vh/0VO8qwyx1x1fHvihWU8EEax1oyYKiUVgfnc87J+IBbyaCK4fGobJXqgRv+PjA/lSZR7jYYJEuW8J3MHSQgrL6TqoDjpJsgOKnuHNYkwxGaP5aZ0iGCeFNs6BKF+ugdIrWPv/tYJFixEWEgRLu/phatkTWeLsxBQNh9XEhf0GubXH0i+s9v8b7sZLwgSFvE1eVGf9eGmh/Ur2MjvuYEFYXlFaJFvSgxWNErCsgI6zlMHXeltEJLiPPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvefUcBipVUYZAq2PDSRMbyjbPT9fmIiddSiOlzVnZI=;
 b=Bt9WWJGZteUuNAGcomLkX0wSaEsZao13Ig9IstmZmt0X2YiGGP+1ZcmJ3+TyePHmvXq89ICrZzo2q6/tFsA0jypwukyR3jSCKa68xEZjNfKzrKLsj1Cwveln3CuttMWiCHuEbcoCCNo/mOWQ6vCjvylSWQCl0+RQDFcymO9MEpQ=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by IA1PR21MB3402.namprd21.prod.outlook.com (2603:10b6:208:3e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Fri, 21 Oct
 2022 23:01:28 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c376:127c:aa44:f3c8%7]) with mapi id 15.20.5769.006; Fri, 21 Oct 2022
 23:01:28 +0000
From:   Long Li <longli@microsoft.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5AmQQ427gtVraEOIJ5+rCERFPa4XHQ2AgACeAYCAAUfPAIAAdaGg
Date:   Fri, 21 Oct 2022 23:01:28 +0000
Message-ID: <PH7PR21MB3263BFE218601536B937F59FCE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <SA0PR15MB39190FF40EE305671D1C061D992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
In-Reply-To: <SA0PR15MB39190FF40EE305671D1C061D992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a6ec0a47-7bbb-450e-ab60-f48358a86509;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-20T20:21:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|IA1PR21MB3402:EE_
x-ms-office365-filtering-correlation-id: ab793d9d-6e42-43c0-5b3f-08dab3b8300e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CnHNKrYHNzH3iIDxWcKtBTELMgO/AXyrXJ3r6ptbxhkStXY2JNYx9YqhgusGU3qqCbbzVaHCpLRvOeIWyFIwlyJGTtmkY+rGZz2NesUZt4028heH/T0hh2En56CJd2BxB+j9zevgEB/38fCbo7G8pKSaL4O4RePLTMUgYNqwwDEaQ7Tcu6mt9mj3ev0JLNfVgyuzX5i+t3yBg79IIJIAbgJ0kf3BeFfrKbwpS4S5bCeOzRHpww8ycBDTDkqQEqy/vyBi18pTKOh0HOCrM747dcRuA1OMEs8ChjQD2bb50wTxRGdR+jw7KbxK/FHIvX+yebqnm5URvfXT5/iThDXvnLb8MqwT6SO2NLwt0/4uKfuv/iAenuF/Ju5+nibP1cUCbgS+bPO6H51sLxzi3NcJo/xEKiGVeBhP/94Dx0Xi4xz5sqhV0CIotAVc1JZf2F/veUf2eAnEbWDmm+ziMsYuq+2nIUOWkI9LbLDGdHM8wEKMe9o87GTzFhtVj15/HBTK7cvPer5sZ+pc/MUTFgvD0S7QXP2YtdGZV6i2kv9w03Lmq1uHLREWRsJHpZ60o9oq8Rvttl1hz/s/AJkMlb9iiML5uSDFeXeUbC5WpjMUt/FKy621J6sOhCxOte+i0T1TKIQFq46AUcB4Onm12qm+W996c1YdIo1JCZOdCdD2XeyN2g287+INQigie5tHDwXtxKT9xbdQP/EVV9W+ffVP2GE9mjU9Qw21pkTxrLyiZeJwct2V+Ir+NtvxdgRQQgSWHnXVUiNkXiQqEa8S6rjsaExbcCP5UeCd/tBm7/w9NaNrK2LbznbS7221+s6q60V01eS+Fffyid/iB2kDeQfdrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(47530400004)(451199015)(4744005)(38100700002)(7416002)(8990500004)(33656002)(86362001)(82950400001)(41300700001)(66946007)(8936002)(82960400001)(66476007)(52536014)(66446008)(8676002)(64756008)(38070700005)(6636002)(316002)(71200400001)(54906003)(6506007)(76116006)(4326008)(921005)(26005)(122000001)(478600001)(10290500003)(7696005)(5660300002)(9686003)(186003)(55016003)(110136005)(2906002)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3i2e5Ekv2Jv+iIiTZtjVZnFYKwVNkB9VVW/iYVS0D03PcAdXq97VOH8ebKsx?=
 =?us-ascii?Q?aBMsFl242jEbkEEH0vpJ4N9Yya5/7vFonkOBZmhGpBoclHln7/7g4TdaUAwP?=
 =?us-ascii?Q?X56DR8xmGMKSH3Ru9mNFHRKVEo0z4+dCoQNzypwjG6Eul3S9OXxj9ITgoG9t?=
 =?us-ascii?Q?uegC9zVJVJIvm9eUdxfBRGWr8928SjRfVVXnfSDV/jlc356dm2k7vqP15BQA?=
 =?us-ascii?Q?SF2QEkLxzs0Zk55rjy5BnldRhb8kD/Z9HyKfNToKCKxRY/yBxiVUzlg8jJjX?=
 =?us-ascii?Q?FfXb3+KYN0jv6smGjTcyE/+laUta6ArbmYovBvh0iTqrU9gLa22UWZW0ghUQ?=
 =?us-ascii?Q?H8nJh9Pe/82hHseoN1sPwWBi6uGc19eHJ5/3LDK5z3LU9U2DQ8+KIqIsLe9C?=
 =?us-ascii?Q?te2MM249JXbIIUpCcZkoQ5Yw2QaOOTSYEFMR2e46OlXVq/4wM/D8j03NudAh?=
 =?us-ascii?Q?CriN4SlTvK00R1XZJV9FTfLf7nsO7Jy/+rbfd6mvOoev5aSeTxTNV5CgOBvz?=
 =?us-ascii?Q?mM6+jwqn4DTST7jCW+OxpPNDCrndoID+t9NJ1xZnSTjcQmMT3M4vzZlArbmH?=
 =?us-ascii?Q?Mwx4tlt5CsNCLhyKB1P0NxYGFktq6IVwbZCtCM7KFtopCoDzZC3ty/dpI3Gq?=
 =?us-ascii?Q?4I4DB9+5/K4WrsWcjU+9nu78uGwVXyOE1L/UY6nLjycpsXxres1YOwVWOp1d?=
 =?us-ascii?Q?yFrKLe6i96h348NmXxB0QS2YAndnrfM5MnzwsuuRiMsRgWPZwbyodJD86Dql?=
 =?us-ascii?Q?NgWZEM9PH8E2UpP2LcydTvDymsY03wuZhWOA9M8/ZBc7lTGYzpfQ0mwl2oyb?=
 =?us-ascii?Q?Rpgz8jP8kppZ7qIWS4eUgYPguI16EmA+oWSb0u5QV1ifNjIVC59zuT9a2eLY?=
 =?us-ascii?Q?3MegtW2nivtSmFmCxK6Bq4ioeJr3r/4ysQKsQ2vmsgr9Tj6l0Drp2ZfeVKgd?=
 =?us-ascii?Q?ntU+jEEuVG/IPiZ3pVD9nnCFc86uM31toHVEO2zazGb8W59xczOsgVf8jRt8?=
 =?us-ascii?Q?V9OwD5SiirttbjxjmwiegcRMhjntsyhIT9BVYxrrEvMaq2HgAdWcwgqe0WZ3?=
 =?us-ascii?Q?PBF34rdkhNMZSDvVBO5rryxhAcHY9D6dgmTMuJaWVR/vP9WpfWpET0C7zs7G?=
 =?us-ascii?Q?QxK0PmnyvX5BinCCELsJFVrfb1N0q1s/S3+sHjcInIrJ10JkEAg7efPPZkGB?=
 =?us-ascii?Q?28grrfl99TD3pwcl+BEzVVcw/KymZaG0lCrZpVXRizNmkiKbywD+YNIrQUxn?=
 =?us-ascii?Q?/GhB03RzBTV8gCve2dcgN3FySErAvrOZEBlIb9NpQCK2qmARjdjS/4+L6DNo?=
 =?us-ascii?Q?pYmAdEpwPaFVLQthe/Inuj7hb7iyu51tXwrwAJi5hVrbW/Gt/u+N/7kPYKKj?=
 =?us-ascii?Q?zSUataX0Ufu0yIeHHoBH+BfqHaBXpG1TrQPj29IWhLgCtPEq6UhqxDI4pUrW?=
 =?us-ascii?Q?UGaB/3/lrREIHBR67yP+Cmp9IjXGzbOGIH0A/h8cmk2uNYtw1lcq3VZHcy/0?=
 =?us-ascii?Q?v+zKYieDhoJ5DuzNq8PpZ+Ir/cGDTRqmByMGjIo512Zhs948+ep6oweYVvmR?=
 =?us-ascii?Q?+mpSuIK+Q4vZNQn+8ABNXDV3Zj8Ngs7D4BFjvfho?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab793d9d-6e42-43c0-5b3f-08dab3b8300e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 23:01:28.7322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qxHuiIqNIaPgqLDiOjodZRuglg1M7wnogsXJXoe790PkunW99s6u4qX+GfJKlk01rzLsaY4hlfJk2NdNU06IFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=20
> For good reasons there are no abstract interface specifications in Linux =
kernel.
> I was just wondering if it is good to leave concrete attributes which are=
 not
> (yet?) reported at random. It is obviously working okay today for your
> environment.
> But memset zero everything you don't care about today might be just safe =
to
> detect an unexpected interpretation of those fields in the future?
>=20
>=20
> Thanks,
> Bernard.

Thank you for the pointer.

I'm making the changes as you suggested.

Long
