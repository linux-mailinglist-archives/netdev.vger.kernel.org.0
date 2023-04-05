Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BFE6D8897
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbjDEUcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDEUcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:32:23 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B558A50
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 13:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD4/dK+B1dx0QqYSw9kWuqr7XtPCyfmFroWHZkeEMU6lR8b0aHs2BaI76kEdznra2vH15qi5nXLqZo0/7wq8P3JH2y+q50+oX21/vypAfsf3/QN1LJuuh2ikXtF/Tbw6J7jF7g3skJXX3heJw4cIB05zId4mbBTKikcGfNOcKHdmNx0m+NrqKwNjjFjL1brtfiLvJSzE17fxnsTYnJDfmBxVZPw3PypLf2tUAyqKOi2piOrkB4SDbwfGXQ2myuBVVyGK5h8wMvZHmPngADEsFMcVT/ANj2tCGSO4Cn8a+GMHPXcXbApiSypLj3PUApq7H+Ckh0gMMgIUdwv7sTjn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbvZTc7wdJzFTvvMZHLksstngxa439cWpBrIAgUvNrE=;
 b=kvChTesiPNBmXT+/WnYKNEhBOkDVMUZ14awyyeopFKGgpRJGhpBPyaKJlQdfp2UTqt6mcxIscqf8IhfsOpkNhoUv7R1PCUzgCuwYlmzto1SFAUnx38K7/aj3KEPf5wHN/ICYaR3iMRjE+ZVpKa3SsWQUFZs9CIBnnywpUllRncRxIhEr+7K2qJw3xGjD1BKJUNwqEtsTaoKt30rAzmcd4+DsWIG6sa1PNZdhQsvMQRgp99aSz9ub5mWZNzI5roMDS+VPEKgiXU2BOlFPMfg02Dx++E6yzXG1dax3cFebxvp/pjJZOHIWv4dlcGjDoT/s6IyOGHJfyzuMMfX4DbwSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbvZTc7wdJzFTvvMZHLksstngxa439cWpBrIAgUvNrE=;
 b=qedqXWWkaaadvzum7uPkzl2LkPJ6+l0CldSQq8NoD59JvLD4rEXIJgrCyWNQqlVblMOjb9BMxvc4EACkYQd4QxLgbv2lUbBdYivjPzGH8nBbpoS+vf6CStCqUyI3yAlNz0Yn/7Mu12D4VVkknds4qvXPbP4eRDXqkjdGfbd2wp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8958.eurprd04.prod.outlook.com (2603:10a6:102:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 20:31:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 20:31:11 +0000
Date:   Wed, 5 Apr 2023 23:31:07 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230405203107.lsz53fbu257d3pmc@skbuf>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC3Ue5i/zjZkvMGy@corigine.com>
X-ClientProxiedBy: VE1PR08CA0032.eurprd08.prod.outlook.com
 (2603:10a6:803:104::45) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8958:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f78710-5eab-4c64-1e4c-08db3614b15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Frcy0W6rJZ4OCPL1qT/UGo2tHst/v9nH8ntUMickNW5n/kd4lAF5rQ3JiwvpMtttORyY6J0vkxw12afDLSGr5UCz9vw3RLpxOvzhE5tUHCWr7M+7VgBdJ/RYlhDYu5oNXr5M2BwdfoeeYtQDVlfTc9UrLet3B1NQZpxMzE9l9jRWMX40PquOxWIfAmcQwJa1EhP8uJIlS51kFHq4feWCG5Oxdj65ygC8YyYzhFUWMa+LD1nLrDrWseT1ec9ecJcdUAlM569Yc5gNXu/3wfhyRgi8ID+o+KQlRsuh6WUaaNcjOrLArGjKWhdqR6RFXrg6eGGIdS2h7EhduBD4sHLhtBF9mmWnSSzY1qUc1ag9nc5APYN5TuoBDBYF4L6cLL2dadHjDAjo0aGzI+G0zlCdr83CXdoMH/9QzC7lKn3hrobkD3C9XiXF5iXnJeZJecK5RrNXE6TYiAaZYNKHHCVCz6BUeNvzGkRjTwJiFDobnlV3QDwdbJ0IMZ6JmALSSCWHhVwCFcTsG8RQtRN+sqNGM+vWVcYpKiBEGyLv+pWP5zfP3Ss8rlSZ1tGJTKyL50j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(41300700001)(66556008)(6916009)(66946007)(66476007)(316002)(54906003)(38100700002)(44832011)(5660300002)(8676002)(8936002)(4326008)(186003)(6666004)(478600001)(6486002)(6512007)(1076003)(6506007)(26005)(9686003)(86362001)(33716001)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XyNgpVou4dWTGUjABqg3ewwQ2KvuwMRb3Avfj+3GhpN1X31L5OOgiS6YG04t?=
 =?us-ascii?Q?HARdWN67PyH6J+8fsN8hqIghMQFlNovBVzgWPLW6HjxtuSEvkGAlS6c2QJGL?=
 =?us-ascii?Q?KbYKJ44oB2k1gcoIUnObx6SVDjX53zWzKwVgR2rLtfX0nmVvUFFVBGv9ZlTB?=
 =?us-ascii?Q?e4ny1f+sZoOeC5Nz/FJp69yqoPKYAxWtr7BUZUt3EtiYukx1FB8PiNKu8+/u?=
 =?us-ascii?Q?RXDzCabt9zzjbCkbhfInIOnUyX+A/k1Q7m2j17g+RqJqkrJ2jRgs0F3mE1v8?=
 =?us-ascii?Q?Afo6sSZTbYVDIPI9L0bBJyieur1s2HvhL2ciCIS8f3vim5zihZxKmQEA/2Ac?=
 =?us-ascii?Q?5oOnMiIyl2z8fL5FYR94JGxxiE8OPLJf2vAqr2Q7kwZ/mec9iNGAzrpMTO5u?=
 =?us-ascii?Q?yMMqE93o5030wYYDH0JmSU6+O0536VuJQfOILh2A9acePcINcCvpCwOWmplw?=
 =?us-ascii?Q?C4r896R3UD6fMrcOlMjMKoEkmmpMhDV1X294BZ08+rZsldLEssc0o64V4za3?=
 =?us-ascii?Q?s1MxJTTxaPPl70HKxEi9H9578Fm6xD0AsTdQMJB+Sa+jkpRu/KAkD7f87GUS?=
 =?us-ascii?Q?dv4uvkqFpOS7zEVqToTLx3tpY+DwtX1+UlMICI0YEsQw2QjLNl5DL2KcVdmS?=
 =?us-ascii?Q?H3EzOJCi5JgJlNrZmIcgKPMY5kPbxZ5Q2KA0DFIGt3XzupNIzwddwA0Pvsyv?=
 =?us-ascii?Q?wt6cHdHOx7PEFFVHBlZfAQEOUCjbfb2bKMn+tk6Atf5xVOaC1pgqc5TBU6vA?=
 =?us-ascii?Q?xfmNJ7AFrp1wgPhRTz3iZGvoFOUq9FX676ynOaB/1Zsjsu6bdB3Y6H+dbq1I?=
 =?us-ascii?Q?bryoa6nMGL0ISOmYKxCxTV0l2Akm8Po4QGPgtJ53Z0eruVVVZtNxU1j19KqI?=
 =?us-ascii?Q?+FsAelxHxsb5AEvqc1buBCHjFXBtQd0FkpMA77pAon2NQUDVgEV4y04nG5La?=
 =?us-ascii?Q?HUlVJaLCUCibbMs3eK6257u/uSx8cPYrGnUHF4qjNTpnvN/W89q/ELSl2rVQ?=
 =?us-ascii?Q?JcxQBT+FMIPpd/yZ5Alz9YW3OvzfolsvDLroX+oAph2FBPG8mG4FBb9IQRtN?=
 =?us-ascii?Q?gbyEEeNqC82bP7GJHiSqKXxCn/jhCB6UZKKPloRwc5kXkEY6i5I1BqgOUvAV?=
 =?us-ascii?Q?FcBdTAjQ8w9yidPAqqy05I5Bhj1qIbwBN33GnMq/HaxsP2O1uqenGIP6GleS?=
 =?us-ascii?Q?5MJ2BSL3fsd/uVoOlk7J96TuonR+lTOpTv+mjcJXsEBqhTto3OIjNtx7dCn9?=
 =?us-ascii?Q?n5m3xxlzLOntE7cxpE7NiIyHFdreArYc/aDxt7vOayfrpg9Q2S7d3CEbnNjc?=
 =?us-ascii?Q?4V7k79jXFWiHQR3KVsBcJfhsvSG5GxLKc6mXIbX15chiWWmtqGPK7vbwy0F0?=
 =?us-ascii?Q?ELCCCmxlFfgLvcYkb+GzuLtdCz2zcuDQLdYhzh4bcY/Fcvu+wpNeKMMh08Yw?=
 =?us-ascii?Q?w7LWpTltw1oMwW5WKqr/RM1DM+5DndcoDEdcNY+DVsvF6JFXpij50srhpUB5?=
 =?us-ascii?Q?8p/N7i5JIhvfJXEWnqhoBUaHI7469Phy7VzJGIXgBeAxFCb7nrQvIzDZCEjT?=
 =?us-ascii?Q?Xz6cpEhLRUPW0G2AYzDuIf4a9C172SlRJCTsuDbK6dqg3WABwuxVHNlomsB7?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f78710-5eab-4c64-1e4c-08db3614b15c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 20:31:11.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vRoAWRbzMVcuK55sxRqnWQ6JNVeGGNZaH9sOi8RFWug0FYstz/vtT6P1gGqU53alsh2950F5yaRB+eLpL+P/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8958
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> > +static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
> > +					       const struct kernel_hwtstamp_config *config,
> > +					       struct netlink_ext_ack *extack)
> > +{
> > +	int err;
> > +
> > +	if (!netdev_uses_dsa(dev))
> > +		return 0;
> > +
> > +	mutex_lock(&dsa_stubs_lock);
> > +
> > +	if (dsa_stubs)
> > +		err = dsa_stubs->master_hwtstamp_validate(dev, config, extack);
> > +
> > +	mutex_unlock(&dsa_stubs_lock);
> 
> nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.

In fact, clang-16 is saying something much smarter than that, because I
did test this code path and it did work reliably (not like an uninitialized
return value would).

It's saying that when netdev_uses_dsa() returns true, the DSA module has
surely been loaded, so the stubs have surely been registered, so the
mutex_lock() and the check for the NULL quality of dsa_stubs are
completely redundant and can be removed.

> > +
> > +	return err;
> > +}
> > +
> > +#else
