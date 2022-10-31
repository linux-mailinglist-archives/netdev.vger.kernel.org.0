Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842796134F3
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiJaLyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiJaLxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:53:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6B2D6A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 04:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+/OAepSwpFb/MUaO+Nb1NqNyFtqjk0My1bCPTyInSk8ZtYXdVCJAzKuyDVoi3lM1VaNVWWM7YKPgekR0NxQWNlfOathV7RvAO/0k+Kao4K1u+sliAV8J3SJoc4phmUL23FPwMBb1hYj2uNT25MeViVedaC7cnDXrRfZkWvb5ERhzYp3qfyX843dNPDxzk2h6a/WWqzGk+tAxbNImiQ2VlV9NHV1maF7p0xgerGa5occupQs4y11Jn0FUUB0Rxaq0rja7Dc9zfBWUAd2Cuh6Iu0KRlFDxfgSUO3JKQsDIJbA20r4FXr/f1NERZv0/LomGY+HgYh+xVx8amvf2hT9oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgsERkS8wdkLWrQQN67CaOBT+z87ao/Crp7argQkU+w=;
 b=Q4HDIRq4s/wxN24qwZRQSQxTuD8/kB1/MR/k0ENxnAbG5cnfNclx9Os0kFXD6JDKS7gBwykOxlVT0x6zFIbIvXTM+It2aGmhiHAF8tKXTo2WV1nPp8Pftuf4OqK3O7PuvyhhUdS4YCkjPIQefGHfPwBfejpFrsHX+twqJIBLPSe4Lk48ZwLD69wAxhnvDSDBPvKOZgMItwodR3Pu96iryIqx3IjqHOKFdVrzhtVPMCNjkwm2GSH8j148e0nc4ytJeY9wpcYy/96pgXVI+3I5ohrNZotrGh8jLfORuSM9VM3hTXayGukS98PWonxVYYBScWclAeyhoAJZdiXUKYmPGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgsERkS8wdkLWrQQN67CaOBT+z87ao/Crp7argQkU+w=;
 b=IM1yUwnV8zDIMX68nHStzn1L2eGYZAGweVbUhQ5oTkYIuKPfXFe7tVb3E7EA3B6TT0KkaEFbB3Ylz2CQKZZGGb/odN2H4Tlbi4qd8iT7UtdIHizmj+59shXu2MZmxc1oXSVybAJycTpizTaqN2K/VlMdEDV6uall+Z2fpNwMyqKJCmc7tRPtLp2lLfG1utt+kG/Axyw6zMGoqTxjEZLUzbs8J1IO32Bvl4wJY3qHOz528fxF8XPNbv0ywy+mtWhlsM0nwcbwGKQQO7nBuSWYIZVcHE7RqqQ/L0IqAJEWVna13ffsbtPQ8d/mK5LNgV12isSlDyQUA6PJ1y1FtU7M8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6655.namprd12.prod.outlook.com (2603:10b6:8:d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Mon, 31 Oct
 2022 11:53:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 11:53:50 +0000
Date:   Mon, 31 Oct 2022 13:53:44 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next] rocker: Explicitly mark learned FDB entries as
 offloaded
Message-ID: <Y1+3SP1I3+HZSMG1@shredder>
References: <20221031075922.1717163-1-idosch@nvidia.com>
 <Y1+IBAoSHj3kLQIA@shredder>
 <20221031090822.q4zux45vrqr2wqi5@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031090822.q4zux45vrqr2wqi5@skbuf>
X-ClientProxiedBy: AM5PR0502CA0021.eurprd05.prod.outlook.com
 (2603:10a6:203:91::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB6655:EE_
X-MS-Office365-Filtering-Correlation-Id: 99083420-3c87-412c-a16b-08dabb36938b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PT44nWalsxig72sJeOhiI8f//67yMNoKoMNp374pRLHoQHjMjRlb2lcgDw6bbPx/umOnx1e+zH6f/E6jqW8Nib5euIZx4KPz9JoVp8Dy5rxmtwoW7wx3c2FyAvW6WLp9UWVInQQLoECjlCJpiHIoWnB7zKQQ5EqNTBemBC+qdlmMezJOkednG/2Iz0/AbQwmu49u/yanvlXPqtIyNm1Icvb4y1oJkhhEwMf3IWWU8sv/Jdq1vbQsNe0ZNUcmQiZRYreGw+iOIueY+YyD5qd84YY8WVocw+DjIciK5sfn/43wrE9mzwC5wxoFeAGiBN7d3RGA/vm7opdFca1OfMF/5Z+OqGnkRLzyERVuNAbt14A0Ttk+pUixlq6ouzj5TPGih7mQrenMi4z9LjxJt7KdFNntty3meD3ZG3OqiC+VHVUeBWuoAm68WDe/N0k5kYqb8UPSqabzZoWJp+kPZra6RSt9UPbImoiHU7C7btIP56K3DZH+SlTU5I9eYh+bC0wzdEMAe73+7PrZGQuGyB7seWug483mW8JHA6DLkPVIKIxbnstoXbraHnXcVXgWgCLaeXe+5dpgQ1KLAkfcpEY6RdmNM94biT4sCJj/wjjILsCfWKX58PArjADVZCX/0JTZmE17W6IQCn6ZMyP35nKNMwZgxQS5r1eIs92F+yELbgQ2Ca0VuTMuInXCQduVJJlDV/xGbGvpAVGGe7/QD+ATtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199015)(478600001)(107886003)(54906003)(316002)(6916009)(6666004)(33656002)(4326008)(6506007)(66476007)(66946007)(66556008)(8676002)(83380400001)(33716001)(38100700002)(8936002)(26005)(6512007)(9686003)(41300700001)(86362001)(2906002)(5660300002)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2hRGkEE3eM6/fb8EjQ9VMo0NKuX00+cUxYiMOqyeFf7vdImJHDvCJ+ZfvQ9r?=
 =?us-ascii?Q?Zmvarc3h0Z7yng0d/WZvu4pTyrVz8cV8aYvW5mucYI+rtqm5WEDMmE6pD+/x?=
 =?us-ascii?Q?oXI/9ni7Aa5u3AzEsID4f/uy9rZ0TgB0xj0nFJ7psoQBGICGoLhbXNqF3du4?=
 =?us-ascii?Q?3lQvVUZ+TUDesAVYUtXfSczHmfbMdyjxTdXrgVf7FaakceKtfNT+4/N/aZzd?=
 =?us-ascii?Q?qjI1nRmCZlJKoSCFNPFOIJa7rvWIIteUAp3ZmMP5NY7eqLCm6a5cfW4bxPPm?=
 =?us-ascii?Q?trkw/BKOUghZM4Jd7hQz5yn8W9+Dry0g9PCZug1dP19/1A20cyCJ2d6zLe0+?=
 =?us-ascii?Q?60Y5/I7TV6e75zI97XV/AvuUFePewYODROppYC/JHHZme9RHc3qQtcU26DKa?=
 =?us-ascii?Q?iS5yk1aw5mm1eIh1nJMOQ14mw1gbhjFg/nNKPlMLoj4UCULHgtAeCvLUmWvv?=
 =?us-ascii?Q?GxT+QyYTGUu3pEhAmiWPTvwNvWvrKSBfjYqom/Nwwf3rCHTYMVmSupEdXqNI?=
 =?us-ascii?Q?W25fg/tottPiABK1x9VZNiX8Q6WFP775ZjnirFhLSRHCrH7nS37+bBTGgMo/?=
 =?us-ascii?Q?OCi+GSm1VUoD7/CWUXthzJDy/O6ptXnq+7EhITvkPK14Nk4zI3sBoEfzKrMC?=
 =?us-ascii?Q?f2SZWjNxbHQ8CJF3Gm8jrhOFW4+JG8onR/sxIfRo0TrhaKda7Jb4eRKhXSNF?=
 =?us-ascii?Q?ng3VTHlbZi00nQ6/9kRyr4oVTH+f1dkbguZobHghAyVEhZvoOAJ1oVpcL98y?=
 =?us-ascii?Q?nggudqdV+yBhKtBaBivsy+f1s9DJwJ4PsigJd6uuqeESf4grpCRXSAY3Z628?=
 =?us-ascii?Q?mj1IbKebQaJSNdi3m91hDJkGvuQW6cJFcEEzC+sDZ9cyvtmWPPphNo3wQvq6?=
 =?us-ascii?Q?OX2GrRlWorUIkMpKkS35gf1fg6DqVCT1s4Ka8IYhBQr2gBpTgBSQcMupPqLf?=
 =?us-ascii?Q?jio5hSrzx9V4MpBd7tVf/vxdzuw9XIE5Ff9jrYLpfoMC9iPeZQG5EAHytb7y?=
 =?us-ascii?Q?Ng3LfFhddJJJFIKTkc3PeEDzX6LqSgw6Zo+LATSnhGkR7JFwXMtJ3BsQnmKJ?=
 =?us-ascii?Q?ZW/XyQJ5W4qzk9mon0jcZvKt10Y9DDWolL7gXdb4hi1CZfKnbP9fSs/V0KZv?=
 =?us-ascii?Q?Ax4Y1NRgEDNeaOR9wF4HH71yX6F8iUoVvXTOaFUWA4UtVCX3pi7h81AQrzvv?=
 =?us-ascii?Q?Y6xVNepGzFFVO/jh25eimfH/JuIQCXQQSiM+ZVPS3wbpkD6XkAUZAd/2Tg6l?=
 =?us-ascii?Q?Kp1V/XswJMVq+WMRsRdwTHFQHY0n/bEhUwppRt40qi6k1ozRJkqbUJliWtLv?=
 =?us-ascii?Q?G9YiXHoKKvDngDAbPpRWaEiN66iWGhuvihBHkIn0dMNsJ0WhsNIubN3CWGVg?=
 =?us-ascii?Q?CiCtICwxahOVb8k1tkBWpNyx8PSq19ln4R2Q/3kq3VqRAlQt83Ujo5SX2r6A?=
 =?us-ascii?Q?27bEq6M+b5vtFJbhuaDA2dpwZdus6nxU95wd+NK8XW1FfaSpnmvSiBQ3LHCt?=
 =?us-ascii?Q?AgYa6/uNeNSBknycCFuOzZ4IYPBAgZoq/qPJ2u2vMo3d7hETUuG5ofBb5nb9?=
 =?us-ascii?Q?MOPTOPQOFw7Hg0cnPCxK0aDT/LYf/7l/BwCf2W+P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99083420-3c87-412c-a16b-08dabb36938b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 11:53:50.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJVfZXHUy8adYw1SCvB2vPKL2vaNyOPL3lVOdgSmt4WTjhZjt/vWe2uunm37DSNK9IN/Fll0c7I1cuDDATNa3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6655
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 09:08:23AM +0000, Vladimir Oltean wrote:
> On Mon, Oct 31, 2022 at 10:32:04AM +0200, Ido Schimmel wrote:
> > On Mon, Oct 31, 2022 at 09:59:22AM +0200, Ido Schimmel wrote:
> > > diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > > index 58cf7cc54f40..f5880d0053da 100644
> > > --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > > +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > > @@ -1828,12 +1828,14 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
> > >  	info.vid = lw->vid;
> > >  
> > >  	rtnl_lock();
> > > -	if (learned && removing)
> > > +	if (learned && removing) {
> > >  		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
> > >  					 lw->ofdpa_port->dev, &info.info, NULL);
> > > -	else if (learned && !removing)
> > > +	} else if (learned && !removing) {
> > > +		info.offloaded = true;
> > >  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> > >  					 lw->ofdpa_port->dev, &info.info, NULL);
> > > +	}
> > >  	rtnl_unlock();
> > >  
> > >  	kfree(work);
> > 
> > Looking at it again, this is better:
> > 
> > diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > index 58cf7cc54f40..4d17ae18ea61 100644
> > --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > @@ -1826,6 +1826,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
> >  
> >         info.addr = lw->addr;
> >         info.vid = lw->vid;
> > +       info.offloaded = learned && !removing;
> >  
> >         rtnl_lock();
> >         if (learned && removing)
> > 
> > Will send another version tomorrow assuming no other comments.
> 
> It may also be an opportunity to not take rtnl_lock() if (!learned), and
> this will in turn simplify the condition to just "info.offloaded = !removing"?
> 
> Actually this elimination of useless work should be done at the level of
> ofdpa_port_fdb_learn(), if "flags" does not contain OFDPA_OP_FLAG_LEARNED.

OK, I have this as the first patch:

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 58cf7cc54f40..77ad09ad8304 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1821,19 +1821,16 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
        const struct ofdpa_fdb_learn_work *lw =
                container_of(work, struct ofdpa_fdb_learn_work, work);
        bool removing = (lw->flags & OFDPA_OP_FLAG_REMOVE);
-       bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
        struct switchdev_notifier_fdb_info info = {};
+       enum switchdev_notifier_type event;
 
        info.addr = lw->addr;
        info.vid = lw->vid;
+       event = removing ? SWITCHDEV_FDB_DEL_TO_BRIDGE :
+                          SWITCHDEV_FDB_ADD_TO_BRIDGE;
 
        rtnl_lock();
-       if (learned && removing)
-               call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
-                                        lw->ofdpa_port->dev, &info.info, NULL);
-       else if (learned && !removing)
-               call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
-                                        lw->ofdpa_port->dev, &info.info, NULL);
+       call_switchdev_notifiers(event, lw->ofdpa_port->dev, &info.info, NULL);
        rtnl_unlock();
 
        kfree(work);
@@ -1865,6 +1862,9 @@ static int ofdpa_port_fdb_learn(struct ofdpa_port *ofdpa_port,
        if (!ofdpa_port_is_bridged(ofdpa_port))
                return 0;
 
+       if (!(flags & OFDPA_OP_FLAG_LEARNED))
+               return 0;
+
        lw = kzalloc(sizeof(*lw), GFP_ATOMIC);
        if (!lw)
                return -ENOMEM;

