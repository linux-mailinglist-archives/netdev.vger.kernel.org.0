Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660646F4307
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjEBLsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjEBLs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:48:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2090.outbound.protection.outlook.com [40.107.93.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A10B5260;
        Tue,  2 May 2023 04:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKWbeayv6aAp+lizteJwVywEPVM4IlghwZhv4O1TCGG9e/5+lZ9JPXgf3H7hANmYnB3QCS6vI1Urh7mv61qK65kFpZrXah5R1pwWNfW241AcgON8Sr0yATt4XkzIc97oMJ/2tsHsGMTwBHpqVh9iJPvW6Jqxo2bh5pJKut5ASVW6TriYzCI/zK1iPqW9WmYaXoKdsLt9pLDgt94Tjk6odoTmKdz6G7Xx/S4GDKAxGmwuxYkE23gojAUkIctYJCcu37dZ5tddYDAm/lIBMZoQx/fBa7JoP6n4x0KibEAFXi9zekr0QIOhG19FQrsHwScRQIi3z7WX5iA6zBykfWQ/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dicO62inzHtDKMcnz3u8DP4nWLy949Ej23cWl98UQD4=;
 b=g0pxS506l89gpBQ0Tdv3UIq7LXGxE5jwiRlIOLOPNXs5wakUa+etkiyj4aiRPJJAX70y9SNY66z5YkEDZkqfM1HRsC7womZs8zL25xahG9jnSW0z6WET2JVupiCPLaW48bi/FwOn72mfu0AA3GA2kmN15hEAZQ66isGb+7Kem4TBhbPAaiHwD8HM+ZAxrXQMD55fXdYlv5hEmLxTIUkaIOV/8VFTcAYGHdflj78eHNLLbf/Wm7CBgT6Vjeup0ocmUR17HPlkDW0kR16vrHyx+xJuhiGvn0QF9nPDz3+3kygLSJR/3Rg2gq57giiQ0rT/YY+rbXPVG5l22L4rgYZOYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dicO62inzHtDKMcnz3u8DP4nWLy949Ej23cWl98UQD4=;
 b=WEwvNEy91yE98dll1REiD8LEp9nokkDkiaoTtaU99iwLzJw+pU03ylZT523YI8rZazdLij4+LaFbHvfSrUg9tLE6A7atKqx669zNToIKoGAW+uomN7IK3M3x7LthXRrT4j2JAUbJfAYdReU6F6U+imtkRSNQYTD3Ig+APoGFrUo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3898.namprd13.prod.outlook.com (2603:10b6:5:248::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 11:48:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 11:48:21 +0000
Date:   Tue, 2 May 2023 13:48:15 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <ZFD4fw4FXWlAjNgK@corigine.com>
References: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
X-ClientProxiedBy: AM0PR02CA0142.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3898:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e724009-5166-415d-94ee-08db4b0320ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7JBYPKNu38VCuhU3PLo0I4zI0hdG9ooY+76RcsGmDSqXoRAVFmcOg5HJfgxEmNe8q+o4ZVamAn3W0yBIOk6zK3w14+rIdpLZI2dm8IvCXqgCGrkjtPzQ5Y8PhxFBbpktbPoa+SuktM30uCD0o04XIiyvb1i8trwXBXz0rH4f9wAFMa9Gl5z6BdZqqV4Mfmxu9BPYq+mWnl7/yUaDl6rL/sHvsIPQbI8HM/vQWch2GV5gCGFPq2EsMFo3zBT2KOrb69DZnaJTDtPemGNid3RvOTKl5moL3/RFl/vPn2wS7xPxtvn9UjCou6fXsA1uC2w8+kKOxYZZC+8K0F9W1hmr2MRHK72LQCXTi+MzW5bTbkZl7OZ7vR1BbX13CHmBb2CWO/wf3Z9P845ZVMw1Cou3ESX4l842SaeVOIcGa2roRfKy3PgUyIBnz1Lfsn3Za724XdZHvSxn+OWx7HVBm4pumh/XpPyivm5XEYhoL8HW7hEZgx9jlkXEJ4SG8ILT4qf8jneFWCwNl/0Aw5jqlc59vK8fQJgc46HBQgIPdIWGYxgBKbrVYEox1hU70zh343z1zVtGu3s2/zunslj0xbETnvZMu8ipyNDH97EBfRGUjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(66476007)(66556008)(4326008)(316002)(6486002)(6666004)(38100700002)(6916009)(186003)(6506007)(6512007)(66946007)(478600001)(36756003)(54906003)(86362001)(5660300002)(83380400001)(41300700001)(44832011)(7416002)(8676002)(8936002)(2906002)(4744005)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FxndpVfVcc2duwZId/Lp1QxhY34m04BhWD58GoXEWHor8ttq13ild/jEBNMK?=
 =?us-ascii?Q?JE0Rfg2iHkzR0swyTstoHD7i5MAEdXiSCSqCMwJ97fle1FEixEkc3UgbuEwJ?=
 =?us-ascii?Q?AwGIGfnw2KvN4CmTjlTx0w/iX9lWTQqUzEvdgaicPqOMLmTEV9NjdFn7cWVm?=
 =?us-ascii?Q?R80SodtmxtYxqEPbnrL1flJaWyDR+O+B48pHUFIovxsdqFSov36R6Qn6ph0s?=
 =?us-ascii?Q?VSpH6PlKcpUzJmgro/aj8NgLVKUNb8bhEEYqMHAWwWhZn6rBpQTflzuCgTRK?=
 =?us-ascii?Q?Az+wXheNiGtLOz4ZBKuUeqRvcohaGqZpojRtLYxowuN2Pdd4T9pBIqMd2ip4?=
 =?us-ascii?Q?VwqF4UbKo3FFd8g2YQRWMn8GogN4LS1ylALIQg3/IlnH+/wMZvBxbPbjsDIt?=
 =?us-ascii?Q?RMqg4Cy/CkNZiXYMR7Y0a2mp3IQ6qp1SD+W/FqjCqF8lBRIQhvAVx9yT+VaI?=
 =?us-ascii?Q?LPx0BDroulafwo/DUgbzh6TjMMiO/5/NVS37pJKbw6H2uk6NXrgfjLo+ObTt?=
 =?us-ascii?Q?AgRDMWlWtJYRuxOzy9lyvfK5eahU6MuhrudOtAnuB65+P7TdOb4HwzoQFaeB?=
 =?us-ascii?Q?B30AuumpeG9xp9GO0Bh3Di8s7DyE2XIdSmhOXjs0/7Etm5Eq7COVdHDjUC1Z?=
 =?us-ascii?Q?BnLIudDXTUN5khswaKKjr/NZzfKiRC2Z4EiQxaB9p03rXOpyZlPFFY4hQ/+6?=
 =?us-ascii?Q?kXF6U/hyoUsjPdaXxIuXdCP1ELY5Mhy6AEJScAAXkvUlHTOmGk+RJ9JL5NeU?=
 =?us-ascii?Q?lRihtyHIzvjlJqW387gTWwW0BPxKR00ViIfTFn0d/lnm94+fX0JZ3jTooI4I?=
 =?us-ascii?Q?POZVYbRxQyIP0upuJ29+2FiShLU54euC5CqW6DTDHhMlTH0N1ZgnQAmJR9W1?=
 =?us-ascii?Q?LtZd/Ilz7o4WqMTIN6/euiz994BNuhVhNUI/mET5xtctiMvaWPYbWO8HgiO+?=
 =?us-ascii?Q?XgMNWA8pxHL/Atpu7EU6DhBySzwip/1Xmg2c0v9qLEZkngVbBSfzBiYfsDll?=
 =?us-ascii?Q?x2DRjoPG4jlQy813ziGlytsgW+pEMdmHiG28FZQFf6pEjclmlS//glNJ/ZHq?=
 =?us-ascii?Q?4tNrvR1xOJCWpvzOOIYeHlYGUH9CSrRBqea2SETEfqM1A8tsase9zzRJwfri?=
 =?us-ascii?Q?yuu2Ae1cBMdd09BBBqIeYZC4F7N14+z0gc1RsqO2iiXkQIiQcFh9aqIwVlUl?=
 =?us-ascii?Q?UwiP8a8/bqjYmQ/9p+zHxRqxUvx+qa9+i1dF5XKOIhp085XcY7J6//zhv3m7?=
 =?us-ascii?Q?nT5VOtpcNsQ5tFPmUT97fz3gs1/Ldc73n4AESQxi/bWSG/UTSZgMrEkADfIN?=
 =?us-ascii?Q?3j+veWoRuV/9i3b7pl0rBtVaXkQ5Ovxqyy4j5I4f/J8gyp6vUUDudSIRx/CK?=
 =?us-ascii?Q?ijh7tjj2kthT18BBo0tUHIE6Dt9+XG0bo66FEEaNCMMcCtGcqj/ErLCnmPpv?=
 =?us-ascii?Q?fcEl9b/JozbPQ6PafbiVyPMa/eTo94+8K55DF0CMvX6cBdI7RqjwgVrNEMPU?=
 =?us-ascii?Q?AI1CAPKR/hwbtRQPWGiuyIEFUZt1KmOnK66dWPnMH9IhWwKxaD9SE47reSCX?=
 =?us-ascii?Q?RI/intsq7C2LHnHFSjZfXHSB/c8AausUUhFylETfVGf6hOc6rF8360uU0wCK?=
 =?us-ascii?Q?2RVPJ2z8O2fa5dKGEqV8/MY8aw6HsJQ9PJsgjIRgxTGjrsMz5/rKCkhcdbcJ?=
 =?us-ascii?Q?pAZ5RQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e724009-5166-415d-94ee-08db4b0320ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 11:48:21.3956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRwT0B3Ub9kgVBc593uIWnNwt/HZ7QLyHTk10/TlAzUGJ2TWnFk1iKuuO3cR7KQbarXZR0g/agk41MDJT7TJ0bPpZzWIuHW11yqfbvV0C38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3898
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 08:26:30AM +0000, Gavrilov Ilia wrote:
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.
> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

