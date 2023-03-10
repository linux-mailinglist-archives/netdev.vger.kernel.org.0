Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB276B37D2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCJHzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCJHzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:55:06 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2120.outbound.protection.outlook.com [40.107.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CC6CF0C5
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:55:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwPcr0P2JcFD1pOMYpOV3hhNryb0+ZIYbfO7xz8xyyyHdnIwqgCKj/nxreeRm/wAgFcSEcBi67Ibojy4a5ug9z+gdSLnhAiMl1OjvFH1OOTlfnLn7gKK+4okXkFUVwN2BJ3fInFu8M1Ycr5S2VYFCd0AMqX5ZlsQbd6BX/ZfwQfh/+8M5fOKduYwtgHLGM6QdI3bqlHfRAh0nOCdAg5VbG5vY4kwHCKjKYfFDS8pbnVIfiUCzN+TRKlrqs5J/EwF5ov3eIhZ7wZ6nu0C8ZY4r0qAoEjdTVyBP/hvIDfX5vzQKpozex8rcVLQorP+P65TtE4YYMWPAS/RoYZl5liVsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNxqmImQpM4ABm/3lU7hLg9+mWLcrGYlqQojE9VgKno=;
 b=YXxnKv5sRV9ji6HTztBDnYRtuOuBVS41GE5hDFZTR7qn+D/XtCuNQTKx2iB42qM+E1Qgu0uES14rebmrf8ibhiAKKGNBxzZm/Obgr3hIGot6ak3NWJhxGmt4Ljy92TuYJUcQduUYtuhX6xFG8FHPNx6XN130ArLXYEA28b+hNtQd75ZxfRTaMe/6eq/MwFdtp38hET+Gswbxs6RtHLzkMrrMFdySrZOF7R8VMaHhwW9iIi/kdJisGTDSCiYddVsstAQq9a5HIcc6tnxshY23z205WG+EXF9hFY/lIlzMSFGUsqG6LWKWWparNEgKlT12KMdxD2eMvg/TvofdirWv/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNxqmImQpM4ABm/3lU7hLg9+mWLcrGYlqQojE9VgKno=;
 b=OMHY3k3yGDNYsETgHUSooAvK72CDPagIBnOOwfc8oN5Sp9knBsmv5y/9TzKT6rMbjOlVICVuLDRdCcB8KQ/takeGDU275nx91WaFNQfiDEzV37JiNXF8s24ZGY+UoQRqbeIroY+tYu/JWm3SkKmy8EIBvYOTAo2f94UbSvH/dLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5960.namprd13.prod.outlook.com (2603:10b6:510:15e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 07:55:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 07:55:00 +0000
Date:   Fri, 10 Mar 2023 08:54:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, robh+dt@kernel.org, krzk+dt@kernel.org,
        arinc.unal@arinc9.com, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add change_mtu
Message-ID: <ZAriTMR/NIk00/ja@corigine.com>
References: <20230307210245.542-1-luizluca@gmail.com>
 <ZAh5ocHELAK9PSux@corigine.com>
 <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
 <20230308224529.10674df1@kernel.org>
 <CAJq09z6ZG4bw_fiLM_-1NfzyE6LDnko1uehzSWCN9RLu_48Ffg@mail.gmail.com>
 <20230309222956.112261a1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309222956.112261a1@kernel.org>
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 787e98a6-4e28-45ab-48a8-08db213cbfc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ho8/RdVxdFbq7qYhcwphcW7XGD3ZTh6GJt1VBKJdYYqeRIh3x9bnsHPMmnqBI2KEzosBr8VAR7URpSj117tRxrpEGZGF2okU33uPCl1ZI2tL5w8r6D8J0ryJoMcib1yjYl4F3t46LV4sAz1TaDGav5SA+LRPl+ACux+T3K7RW8tS7TKJ3kVWoTPSQ6S3OzLUBjo1BoENhv/2/twq51rIDa2UkKf/isrcuT46vJ5lebDrOkI49BSIpwEKhO45giBFJDtfpfszZmwMQNVxLblWhYEJ9EenrQjpBRGmz9R+uZ+6LNjg9NBPrEMmfJxVFeESG7nti1K8eNy7aL0tzvxY9IbU/gjgPf0rc6tsdPKC9c/WiW3MP5ksG1OZBD/p4yN228TPBdUJqaoVoNUkMu0wtULvoGD4b9pi4val/PEvXOJNdh26oasLuM8iPG7dP+G+/XYesWUXGxz6V6/hheBMeQf7ZjeMfysIenk1FFHg2OOUaKGqL+N91yjtCbOs9keEmmeBCcjhuAwTUFsWjUdAIoWUwcMgCwx+C4GrvowJtLEb1NQX/Wpv3TuVsi12Gr+/9FJLMizOwKCwJp27/MjilNQkdsZYYpgmUyCDQLWWehmtTFtcV46cSJrnKvcjfvuPH4jGyFhxyqdjNTY3lKsRCCtAq9uICy/zZtmSFh1z8S156nFU43SaVXsk01XwoyVj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(366004)(376002)(346002)(451199018)(316002)(54906003)(36756003)(558084003)(38100700002)(86362001)(6512007)(6506007)(6666004)(186003)(2616005)(5660300002)(7416002)(6486002)(478600001)(8936002)(41300700001)(44832011)(2906002)(66946007)(66556008)(66476007)(8676002)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bv0stTKssvFD2OtiDaHTM1VlMuekJ4cAP1NWO0KMxEmEl9muQkOmwdQnjocI?=
 =?us-ascii?Q?z9R/LevzbdbiuCDaC1BQ15T4t5aXi3E9vWS9bg91pfAqplBJP+gbP6ZSsn2j?=
 =?us-ascii?Q?RaQPOQwQ6OO9FiUGfNX8/O1L4WV/HZrlych2ZJ5OQT6lV6NjfqTaiBMCd2vC?=
 =?us-ascii?Q?o4Sy6HzgJqElAD7SxJOsDZdoqLgcZQGBAyAyocGa0pdh4yZ8HTyWT1eFxkV/?=
 =?us-ascii?Q?wbdFAjg/VD6sef85fg/Ztq38VoJcsAgy4YZhf7xoj/cFfFeYaehG8cfOSVQd?=
 =?us-ascii?Q?ASwIETLqoVH8gyagfOTsD9l8imYTUl1+fWT84/7W04DgorfcJUMSAlAlmAhl?=
 =?us-ascii?Q?XFrjf/Y3rkJ3EFpEiF2HNNPe5Mp8TdRuG4Uf/tmTJdDU1/Z02Fc9aq4lHy2H?=
 =?us-ascii?Q?PUauosewUNrbpsDqn3Ylb0mhTEGl36P4sGD+C8r+atTgpwhYK9ie5Et/Bszo?=
 =?us-ascii?Q?Lmaokslnzh+mujC3XXpMgUXCht6Cr+VDZH52sNpqvd8PJgKBwZy2e1IvQJbR?=
 =?us-ascii?Q?S3XtLkfkDVntTeBS17lKhZ7Phhhgq/2MvtbmkwoJS8r8AcKg5zBiYyXF/N3J?=
 =?us-ascii?Q?ON3xVPEpwRn7FldMvn0MGfilhoxKUI1EEw/DpKNqJAALerb9+gLXA29hqrRv?=
 =?us-ascii?Q?NMabFHzY1jezRU24tB/AXltq90wQqYEdIzPftbAx01bWKLZ+gfo5hSeh8DUP?=
 =?us-ascii?Q?lDSmcPilnpOdwymRGzuaUiaUQIu3nRwosHLfjBHsc/AsgP+RU4whhRnvjRKN?=
 =?us-ascii?Q?kvKViY9qRZFLrkBBNrxc9tp5EdUr+0r27q4a9Hg/j5nsVJ2oZC4pCdw39iN3?=
 =?us-ascii?Q?xsmx6BnG7hODH3kUpO6rv7a5OBktJ5QLBisHfM1G/bAtnESASnavtVtxvSkb?=
 =?us-ascii?Q?DHixpSb8xHvCtpNEMuKBod8UUai0975TMxsQlBnWfvKRxzOMrf8vL9ucgf/A?=
 =?us-ascii?Q?tz3Igvvm3O0Y5XRyLYOAd7qGz1vVjebHenVklksv/k4Y6yRIzGkJq98Dy0hn?=
 =?us-ascii?Q?i4htY+wTPAAmLtlL8k2X7Of6B61MlbybqGkgdBSbVGgguH3u+DxG99+rD2V3?=
 =?us-ascii?Q?4s79Z/jANO7ag3HlMlntx6tNePDHvngjyi3rZx3+lFqV/pwwr0+bQqwE8qGM?=
 =?us-ascii?Q?yRaYI7Lx0GLf6v062MLiIluHd016mp8K1VwP5gTETmjS99JBT3r37i+my28M?=
 =?us-ascii?Q?Qks9sbcaB/uwZXvJVOU/L7Tfps2HdeABphuOMCRj82UG7FC8IGW8dcrcfbgB?=
 =?us-ascii?Q?/zqCnwMAr/XNcfTHmkKjtNeCIOJjYXi/sxDb6ZEe2oJf4CNSoeE9YSGvrBJf?=
 =?us-ascii?Q?C5S3SWosiMHpOyE9qPjsS3P6o1mB54XnJlHE5C61j0/B2MsjSe0oxM/lMNXT?=
 =?us-ascii?Q?g4MWG7f4OkeUCP0QjkaOCSLiXZAC8gfjA9XvE7QiTlWyKgMQ7YjRZNz5Gx6x?=
 =?us-ascii?Q?pNIwlzBzXuHzJeI/1QnfsOnSYWHa/dJjK/4mbN0Ov6K7fneKq53/9h7jSaqp?=
 =?us-ascii?Q?cWjFyuTXATOzO0NUhl6zPDxsZSH2iGnz0oEcQWSWICF7xsVnKwVTUg4pV+vX?=
 =?us-ascii?Q?rZmK9wpIxk9drqCWQoARftchMRBuo8CNug/0V32hGSXdTja8mhd8cxhkRO4P?=
 =?us-ascii?Q?Zite7JBG5Olt+L/aXZiPMgvqPI4ZZbVLOAu/NSKzgWwtMBa4tJ5avFgn0p/8?=
 =?us-ascii?Q?bAtCog=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787e98a6-4e28-45ab-48a8-08db213cbfc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 07:55:00.4154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBbhQ2LnGDoWKxBP9V/fxtY8hf4JaO/YLZXu2sHl/PGmVvwwXjCQVUhf9Q/WrAaVsj5SiA4hvEDz7IUrS7Q72KOrVNxbRWdnM1xrgqffTwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5960
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 10:29:56PM -0800, Jakub Kicinski wrote:
> On Thu, 9 Mar 2023 23:55:46 -0300 Luiz Angelo Daros de Luca wrote:
> > Let me know if I'm still not clear or missed some important topic.
> 
> LGTM, thanks!

Thanks, this is crystal clear to me now.
