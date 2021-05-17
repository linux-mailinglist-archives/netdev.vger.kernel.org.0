Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2FE3831E4
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbhEQOls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:41:48 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:31585
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241117AbhEQOji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 10:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yspnn08ZiCn71FE507kWigX5tW85Ui+f4KeFBGR5czautYVRdeRuyxzURus1AYogfroSke6if8QKK9qSJSR+Ip/ZVyHb/2eStiQ31NgSGaoZdlZv//7cItrjEUZA7i2vweBvWPMjG3ZCbbjQrFZkGQHf74AYRBUzJwhupcB0dbcVJ3e/Wo8oLqC2KCvF2g9N5BT09u9yPRyaJg1uo1wcJGJf7rBdkBdSQxCUwx4hS6PAPyu68BdNckFYMZfgD/56GR9GGwTFHKkB4sKGIrIn5cvh+UJP2pWxcYkq+mOJmfXSnRY0LBH0nSKeWhgrp3UzLbaPVwmMTI03hyGDzyg45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAv5OidakU7sfarQbQ2XG402JEvaS6K2WY6wBsH7fSQ=;
 b=mMigTxBLOlgWCGRXXun9RpN0CKqMsCV48ZmXxPFOuho7m7PhQpathPz6Xb/zREu1PmYVIGvI3RxZhhMj06m/DTexCnBpsh1BG3R4+e9K2tTPKIX3l8kbcI+FKUz+RMtm0NwAsEHl6lokqJF8mawKus1Kjvr37Ohb8iocYcyIsp8eAADX0zuYk6uKW/wRZCaZXqRDlqKkI9urqETTgwKYoFosAWjE7tArlxeqJEUXntt/3qXvGccjARHeHyBXwn1dirHQ7rgh50O5QOD9JXnTq03gGlVmtV8tMqjLIXxWNF8a3J6mhIDPNU0r5Oyxj7gEoHUH+bNx37b4HZNB7D0BPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAv5OidakU7sfarQbQ2XG402JEvaS6K2WY6wBsH7fSQ=;
 b=HvKGQnxkSUjOaRqUJWkk0LOZxcuK/txkcPKKCcFQF6PNDuvPHGWzuVG+gEHUgZ/RXMq7g2mRGX6wPoBB+OW1DwatKfuwjiTO7QIyp2XqClfkF6hML6nz1RLuq+5v72Xwr2bp12Rk0qwcyt19NcWKatskvba3FpX3gOWL/EAgAtM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM5PR1101MB2172.namprd11.prod.outlook.com (2603:10b6:4:50::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 14:38:10 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea%3]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 14:38:10 +0000
Date:   Mon, 17 May 2021 10:38:05 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
Message-ID: <20210517143805.GQ258772@windriver.com>
References: <20210515221320.1255291-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
X-Originating-IP: [128.224.252.2]
X-ClientProxiedBy: YT1PR01CA0093.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::32) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from windriver.com (128.224.252.2) by YT1PR01CA0093.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30 via Frontend Transport; Mon, 17 May 2021 14:38:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36d731ac-5d45-4765-3fd9-08d919416492
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2172:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2172FE71859836873997914B832D9@DM5PR1101MB2172.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PlKuYyC/AhVYGaQxXJ3eOjdDacBjhr9J3i3uFvmW6pKDrfxPCxso8AdJ4dodxFLSexeDYFuqxcmYSoDUWvWgj+ITjD6SUInjxc3gwgQAyuqMAPrsuMEZg5v+cN/sSTIngsoY34fo1wFpJ2Qm3fwBTbLT+YVdCIjeGKz979KgVYbWkMFsM2gN5XC8DLUy9iSVwlxIueiS0zEUNdn1UHAcppBmDIWKN5Xij8nWwQ2ogUH7n9o1lWvr+PfKB2vjsGu2vFC4pWeoMyafFTDfb+Uo8MBc4VUbdTjz4I+djt+AVvz5rom7TxaDu6lcX90kn7Xs3U9FHVcJFTLC1QwOWHVDkAPIib1lX966mZQx+atRSCh2CVSyNQ6xyaH+0Lq8hKh1rXUrVv42+par/er3FGmwyNwbt5VzSlPDZJCFmwl+e/ldIFEnK7SCFW24F71Fox/muxDZGHrBZdce3gFv4clFzLpwk+UoNVzMbh83nIo3lGV4PeTEGkKoc7GtbW5wsFajyiDbWkgza/+9sGdDd/9loaUApbPaSJxmygBFYtVplj3bXw66bCYYOVaij1ZjIdQtnwAhL1DCOUi3IJ8/Vu4NTP2mH4jum5OhxQ6ljnKiabFGa6vKSR4C15h7kF9weVO7oEhWhChiXxZKByTegRPLZwEmgSRQoA/EzzdzSBaLylpOWPdLKANc7oSER7XELiacLaTQiy6HZ/km0EspUxK6c8+SYaj0ub3drvNhiEMFoxrsPmqs8J4Gubrhf/SV7Bm1TztPoqYlviZ06Afkm1Dw3ybEd2RJ+F3fi9pxydc5DaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39840400004)(346002)(966005)(33656002)(66476007)(66556008)(86362001)(38350700002)(2906002)(52116002)(83380400001)(7416002)(2616005)(5660300002)(7696005)(478600001)(8886007)(54906003)(66946007)(316002)(38100700002)(186003)(4326008)(36756003)(1076003)(6916009)(8676002)(6666004)(956004)(26005)(16526019)(55016002)(8936002)(44832011)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tFOI1/DcpjRlhRfayIduw/cMM/VYXWCrWf2hujdrKkouAGKeuWFCRoaP539M?=
 =?us-ascii?Q?eIuwAo68FdTDiFS2UIFpAQZB/53Q0u2A/5W3gCkUTPh5vU5UW+9ghzua5h7a?=
 =?us-ascii?Q?YlyXBGq3QrGlzY4oFVAc/lNx2smhrSvgWYJFAaGxlUMH0r+o3rVEy6DCDdi4?=
 =?us-ascii?Q?UYPMAMierY5ysdpl8sJYq10RfVEJ0Yu8KLJ+6TyDewcItZwhDBZj8PnP58w0?=
 =?us-ascii?Q?29Dp+QWY8T7F7SEih4zmWtYAQkezxdm5hd8Ovq80sy0IvSWX1L6J2/QigdhK?=
 =?us-ascii?Q?2I6elllEvRI8W09GhpRmuad3VuGyob9ZsHmkdZPc+OAqkDlRxH2wo5viLszU?=
 =?us-ascii?Q?fvrioIIJnsUSBqC9BYQym7BsrnzIZeguAlnY+bDMYXb/jE+NzsY0e2APZgnf?=
 =?us-ascii?Q?LP4Rrdo9M8MM38buRDus0fv33rpmhEuRN2BXniZ47KL2mTcC/c+E6lOXtVmS?=
 =?us-ascii?Q?MAP1rKl9zZ+D9Jnw6EAwMccQbkhbA37c4ERzfvmXZKP+z+7PKe9ZCrQau7/V?=
 =?us-ascii?Q?7qsf+HPpIAPYxxlxArxisEe3KWxlsdOMqpBhxTYicdBWX5p7ulK0idgYpKXy?=
 =?us-ascii?Q?NuCeuS5oFSPdlQFNEubT7bjnYHPYqHsK31g+JVYZbFRuqkKYzbciFqNXJSxV?=
 =?us-ascii?Q?cNp2536olcKqeC+rxqpbxRX7agZFAECW8oZdfC4hCInqDggzYalmEZwe6RlU?=
 =?us-ascii?Q?x3jG6wXsHvURBRD5NQNoZOCPRGMecT7iMZfwtY457oAIw/xsvXzlIXbLK5Cq?=
 =?us-ascii?Q?Rg57dq/574iD2pS5A2vTmBSL/bQQzOJ3PvOmUglxv+l4InIm+hW8fg4Cjns+?=
 =?us-ascii?Q?T8WXBAu+tzZu5zFYebWqfvaAJ/s9RdBIUk349QgRZjIFyPE9uStqSotlFAqJ?=
 =?us-ascii?Q?XeeyhPu4rwQciTp71VboGi85t7Otdw3QxIU3Fgnf2/jHdT9gDutgDHFPCzH7?=
 =?us-ascii?Q?LvFPhTFRrS8fiZ7YFJAkOFiGAd4a/aGqXq6GwoIItJqNKeQEC6m9rGXaiIcr?=
 =?us-ascii?Q?pzox9LqrTpQTDKrJB7DhHCU2Z8/mlx6aNwamL9XZPdF7OvAmHiFIz1L75h7G?=
 =?us-ascii?Q?SOiYYhAUjk6mkkLy2IQvbJYuqjA5qhygyNKRaMrQk6QiHQdmWfxSQ7+zP527?=
 =?us-ascii?Q?2caGcbOBCb3Mjzuzkj9mX0hrQfGwRzKmRXbLQOk1Gen6H4umy8slOVcU6PA8?=
 =?us-ascii?Q?4PpB7fnEaVWhXqa1Z88o2UiN/qq3hc3y6ktTWsg3McIIBnJUY8b/FzCgr8tB?=
 =?us-ascii?Q?xC7CJWF4f4aHO1knFdBfmVDwGc/unyLXtytQqIabO5euAF57Yg3wMlhQO7dX?=
 =?us-ascii?Q?BjHzTudvabQZLkwNqtS/27zk?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d731ac-5d45-4765-3fd9-08d919416492
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 14:38:10.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM//oyIxS73C3RPI2nd+3aLNaI5JPxWw0weEEbuPSwxlCE7Byoyotv2evy7VlwKDOj0RdMKiuzpJbVwDNzcX+mUJo8Co2xXwPhFD+z7YWlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[[RFC 00/13] [net-next] drivers/net/Space.c cleanup] On 16/05/2021 (Sun 00:13) Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>

[...]

> * Alternatively, the fact that the ISA drivers have never been cleaned
>   up can be seen as an indication that there isn't really much remaining
>   interest in them. We could move them to drivers/staging along with the
>   consolidated contents of drivers/net/Space.c and see if anyone still
>   uses them and eventually remove the ones that nobody has.
>   I can see that Paul Gortmaker removed a number of less common ISA
>   ethernet drivers in 2013, but at the time left these because they
>   were possibly still relevant.

It was a thin/remote possibility, even then:  From v3.9-rc1~139^2~288

  In theory, it is possible that someone could still be running one of these
  12+ year old P3 machines and want 3.9+ bleeding edge kernels (but unlikely).
  In light of the above (remote) possibility, we can defer the removal of some
  ISA network drivers that were highly popular and well tested.  Typically
  that means the stuff more from the mid to late '90s, some with ISA PnP
  support, like the 3c509, the wd/SMC 8390 based stuff, PCnet/lance etc.

Now those 12y old machines are 20y old, and bleeding edge for this discussion
will be the the v5.14+ kernel.

Leaving the more popular cards was a concession to making progress vs.
having the whole cleanup blocked by individuals who haven't yet realized
that using ancient hardware is best done (only done?) with ancient kernels.

Maybe things are better now; people are putting more consideration to
the future of the kernel, rather than clinging to times long past?
We've since managed to delete several complete old arch dirs; which I
had previously thought impossible.  I couldn't even git rid of the x86
EISA support code six years ago.[1]

I'd be willing to do a "Phase 2" of 930d52c012b8 ISA net delete;  I'm
not sure the bounce through stable on the way out does much other than
muddy the git history.  I'd be tempted to just propose the individual
deletes and see where that goes....

Paul.
--

[1] https://lwn.net/Articles/630115/

> 
> * If we end up moving the cops localtalk driver to staging, support
>   for localtalk devices (though probably not appletalk over ethernet)
>   can arguably meet the same fate.
> 
> If someone wants to work on those follow-ups or thinks they are a
> good idea, let me know, otherwise I'd leave it at this cleanup.
> 
>        Arnd
> 
> Arnd Bergmann (13):
>   [net-next] bcmgenet: remove call to netdev_boot_setup_check
>   [net-next] natsemi: sonic: stop calling netdev_boot_setup_check
>   [net-next] appletalk: ltpc: remove static probing
>   [net-next] 3c509: stop calling netdev_boot_setup_check
>   [net-next] cs89x0: rework driver configuration
>   [net-next] m68k: remove legacy probing
>   [net-next] move netdev_boot_setup into Space.c
>   [net-next] make legacy ISA probe optional
>   [net-next] wan: remove stale Kconfig entries
>   [net-next] wan: remove sbni/granch driver
>   [net-next] wan: hostess_sv11: use module_init/module_exit helpers
>   [net-next] ethernet: isa: convert to module_init/module_exit
>   [net-next] 8390: xsurf100: avoid including lib8390.c
> 
>  .../admin-guide/kernel-parameters.txt         |    2 -
>  drivers/net/Kconfig                           |    7 +
>  drivers/net/Makefile                          |    3 +-
>  drivers/net/Space.c                           |  178 +-
>  drivers/net/appletalk/Kconfig                 |    4 +-
>  drivers/net/appletalk/ltpc.c                  |    7 +-
>  drivers/net/ethernet/3com/3c509.c             |    3 -
>  drivers/net/ethernet/3com/3c515.c             |    3 +-
>  drivers/net/ethernet/3com/Kconfig             |    1 +
>  drivers/net/ethernet/8390/Kconfig             |    3 +
>  drivers/net/ethernet/8390/Makefile            |    2 +-
>  drivers/net/ethernet/8390/apne.c              |   11 +-
>  drivers/net/ethernet/8390/ne.c                |    5 +-
>  drivers/net/ethernet/8390/smc-ultra.c         |    9 +-
>  drivers/net/ethernet/8390/wd.c                |    7 +-
>  drivers/net/ethernet/8390/xsurf100.c          |    7 +-
>  drivers/net/ethernet/amd/Kconfig              |    2 +
>  drivers/net/ethernet/amd/atarilance.c         |   11 +-
>  drivers/net/ethernet/amd/lance.c              |    6 +-
>  drivers/net/ethernet/amd/mvme147.c            |   16 +-
>  drivers/net/ethernet/amd/ni65.c               |    6 +-
>  drivers/net/ethernet/amd/sun3lance.c          |   19 +-
>  .../net/ethernet/broadcom/genet/bcmgenet.c    |    2 -
>  drivers/net/ethernet/cirrus/Kconfig           |   27 +-
>  drivers/net/ethernet/cirrus/cs89x0.c          |   31 +-
>  drivers/net/ethernet/i825xx/82596.c           |   24 +-
>  drivers/net/ethernet/i825xx/sun3_82586.c      |   17 +-
>  drivers/net/ethernet/natsemi/jazzsonic.c      |    2 -
>  drivers/net/ethernet/natsemi/xtsonic.c        |    1 -
>  drivers/net/ethernet/smsc/Kconfig             |    1 +
>  drivers/net/ethernet/smsc/smc9194.c           |    6 +-
>  drivers/net/wan/Kconfig                       |   51 -
>  drivers/net/wan/Makefile                      |    1 -
>  drivers/net/wan/hostess_sv11.c                |    6 +-
>  drivers/net/wan/sbni.c                        | 1638 -----------------
>  drivers/net/wan/sbni.h                        |  147 --
>  include/linux/netdevice.h                     |   13 -
>  include/net/Space.h                           |   10 -
>  net/core/dev.c                                |  125 --
>  net/ethernet/eth.c                            |    2 -
>  40 files changed, 259 insertions(+), 2157 deletions(-)
>  delete mode 100644 drivers/net/wan/sbni.c
>  delete mode 100644 drivers/net/wan/sbni.h
> 
> -- 
> 2.29.2
> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Doug Berger <opendmb@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Sam Creasey <sammy@sammy.net>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: bcm-kernel-feedback-list@broadcom.com
