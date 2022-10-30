Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9B612AC3
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 14:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJ3NiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 09:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3NiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 09:38:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA4DBA
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 06:38:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jot28GBMqBEQVagXV6zVwbFVpmc2b1SNAYsJS/I7NgPWWUxiBA7/Trtee5Q6fXVFpx92m5LHOdtDzrQ6Kmu3iMRtTusSeXDF5YsYL3bSz4t790Yrq9HsQCR28PI1KQWojv8inTF4//ZeCA0mGuRebUYSHCvi8BUq9cIf3N7Ht5zaPMAeviHHydDMv6Yebz+xNn1gz9BuiHAGwdfc3rvrR2kUkKAXdLHK2UwD0MurzHR+V4m/9fAVtICNIBQLXf6uR04LzNp3474OHG1eN1a0+SPRWeovmoNfvpTZfPvkjZMYBKXircUBDQohEgdnO/y5OCSDf6ssR0N+/Eifw43leg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1D9cM9onAz54YzDsbRFfESljIIGyiSsd4tW9sP3DBXY=;
 b=mx8iEHIHNwY5MBWDdYrXhdE8PZg5C7CDDrHGKnkX4shJ5KR3gMb/opuWUz7cSmCh7yLaAStCT8V7G/D8HcC2img28OOS5IoTC6QJzhHeAuHa3o1lgl1ZKS9JOFFmgLxdspzHTTihxlZptnPCWH6MeGYda8migeOk4ymlh/otxZUPw1J4TrSlgnlkjT83Z2XhQxlsVRXX4Hj6WF6DxYidoYeHUOT92dWmIlLZPhvr4rcEY64So2F8uDOzSjn8tzd4swQEbQ5wLZMmHdt1Za14LL+L8DN0DIzUkvF8//ub1IHfNGBDLdRIc4tCg/4C3Vn5kPbs4WeBuNKIjtc4ELKF9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1D9cM9onAz54YzDsbRFfESljIIGyiSsd4tW9sP3DBXY=;
 b=LHefKPwydWT5hBUcQiN873swL2y+zEHqqv4s5P2FpZdj8/ywl3XGtr7VlSa/9o4fMrVKZYkrikmA2Pw0z6lAZJp0uQm/DeDLMbHamxSmaRqRQJRPHVe+o5sJ5iVkbC4prQB2tDMUUxuc5fZMgIStrTGkneQiNz8ynVukI7Y4stvuLfwxcyKoIXXhLOBgsA6gX+nk6RpETW8tZXPIY1UgujlLmKPd30g9krhBL7tDzgCngkZN8eSSazxtO/76p3mRQ/cEAvxcmsqExFx+ok3r8NiZgF4O/TPjUbzKAcUvIM6mRRfetAuT5+JMFLFWPOM/X9ANiRmwod5sSyROGJm4YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Sun, 30 Oct
 2022 13:38:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 13:38:06 +0000
Date:   Sun, 30 Oct 2022 15:38:00 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 04/16] bridge: switchdev: Allow device
 drivers to install locked FDB entries
Message-ID: <Y15+ODGOuyFYxO2B@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
 <20221027232748.cpvpw53pcx7dx2mp@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027232748.cpvpw53pcx7dx2mp@skbuf>
X-ClientProxiedBy: FR0P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: f584be06-16eb-4c4e-e967-08daba7bf9b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8c6BRiTG9yot6rwqnIzUzMSKQz8BiyAC4LgW4QIEmdpYMn3UONgbj4xvKwjHrAhCW0liunPyet5MIfxcIU9BSs+ogxDOVr8Y8MzR/ioYkYHJ2tgcPnHvV6+LfEaOTqFlZoPhPUx0EWqN2tn/6jjgFf1VcKh18ld0ESXR2yyhvBM1AIXO9zfoSTJG4WoYptsIGAeLTRt0yg9hQ/Imih0TS0PqfFFtU6g8RiMWiFe9T9gyV7dTd18GDqtdEtIWeqmy68SHIcK1m/74TKRGbsXuaSy/hTd8eyPFM1C/OUFYwdsYDLCIvRHNEa/an33gNIlB86fbUvbax5q4f5u9Zs5LWK66wAUGeYZPjUqMvyabDDfG7TwF+qPYpwUvthqvBb2vz35Bc8kQf56SG/mt+6ZOVJKR7sS1kqd97k3ZcNAzo/7J2WtCYa7kuk+fqz21Prn5GmT1y9nGiRWWYwg15UXy3KqhbnpxxDQ98EFcHCCECQlIv0D6Chnli7ddow6cr/gGDKhOAiOqSxVZ8AqKGv34Ushky07VJ9VfH9duDyjpSPj7IKr7BNBQc4RanedDAZMC5mz1PlpWipQi2xyE9ynIE5HvQ2XZPK60BzloLpVJdBUwd9l0GrX2eUIqphnPqY8gAZ2aKbZX08qc0jKjlrYYngGQMztjJSxZge+L5gfx+iEB5Oc0AZO+RM++Y6cAw+A7CA4d6cph/h9iZ1OyMMfGO/XsvtNKIET8/lEiavoL6GDeAJONrGruObTfH0v30JgKD2cBE+mxqKyXiPodzYG5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(6486002)(38100700002)(478600001)(86362001)(54906003)(6916009)(5660300002)(7416002)(66556008)(66476007)(8676002)(83380400001)(4326008)(6512007)(66946007)(6666004)(8936002)(186003)(316002)(2906002)(33716001)(41300700001)(9686003)(6506007)(26005)(107886003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y1KpNTMybkqzs6DcKyUaH8pLhUK2hPrWeujgbF+WnPFe2+7+K4EuS/H8O/7Q?=
 =?us-ascii?Q?RQwOk9bmP0llEtiysJqO+u6FQHkRdCOvrx3DCnpckzRS3Ujfx/JksmGjyj4c?=
 =?us-ascii?Q?J/Qm5Vjx4klkxlDeDdZeogqob6F47x3PkHDl1bmOzoBxqTASHQmHVDYAz5jL?=
 =?us-ascii?Q?bCh+gZZlarG9Q1lJMgSDg6pNX1jNMhcu2JoQKhrG/0UhK9xKL5SC/AXgLLyy?=
 =?us-ascii?Q?sBUr2hRF59GD3CtKo5b0b8ltTs9CwotmI7AdNPLqGILcwJDI6E9+I+8Lfl87?=
 =?us-ascii?Q?GAQEg9EusqmgBVDgFJIWTFMSwrxU8tOpyAVQNp2dCbw4n8RQwk+qd6RB6vhf?=
 =?us-ascii?Q?jXSu2GiA2IiKJCYKrnK9n4DfdHtXHK7xbqcYpxILDt0McbSBuzHr54zKla7A?=
 =?us-ascii?Q?jMriNAGl6iJWL0mINqJY7+RRD/Beoke0dfmjvZMk3uQEs5eWh7yOLy9Pjquw?=
 =?us-ascii?Q?yYijhuIrkN/k/infMVQ/qBkzm6xvXPBTak4Ih0oGwbrLMheowRGCidi1eVMV?=
 =?us-ascii?Q?18BHalDar4ads8mT1F1K60Fd5sQ+CRKU3X8qeB+jBBou8Hd0z0abVdOV/uzZ?=
 =?us-ascii?Q?5dVPMdNGQdETohGHEpeH6hPT/B9XdK7hu9JbgAPApE2nreOI9MRJJ2Hhg79c?=
 =?us-ascii?Q?yIw4Mo/SdDsuSM6OVCXGPkEJnbFrbNPCBx4YLYVa7nXAnvYbyhgfBzT339cr?=
 =?us-ascii?Q?EgHZATtecHZowovV+KkduM1o5myVVOwI/dVuALzk5IwRdZlRBfFD0T8g4E0x?=
 =?us-ascii?Q?Iqeq8We8sBGyCU611beHjYyTxnujOzvU13fpk6sf3eAXGHEuYbCze9Z0hyDg?=
 =?us-ascii?Q?Jx42tYWa+WsrpfcqpaVdnYZ2Oc3F6w/B8NLT/TMScYcZIODMxRQJPGN4y+K+?=
 =?us-ascii?Q?pBdPTUN4haDDohX2lN8j0dUCYFNtI3b8yBoOlalSLHYa0cWk8g8alsv2zX+8?=
 =?us-ascii?Q?bo28e9lA9dSc2OAMWelvWnunTEfnNo9nJB7Dhhi2nT3uGJMt+ERC/Q2LSV++?=
 =?us-ascii?Q?sil1oXsxTmlUYgG+c2e5c050naB/6SucXjWjXxOb2UCTUMtWzRtI0qaUbwO+?=
 =?us-ascii?Q?o4shHUTjbECkWM74u880xGZOSRvE//Aq4QtfkgInBRYBFvwvJrij7GHjyGzQ?=
 =?us-ascii?Q?YESK8xeYvlQfI5/SVDJ/4pqjn44S3KwDqeB+DMkdUv+W+vWC74syugMlQaYJ?=
 =?us-ascii?Q?xtOUjAknpzbUbssKi4cOl3hR7vZVj4pCm3B3IVyoEQFS6xwl9h7Sd5Op+B+g?=
 =?us-ascii?Q?M8r3Km2yta0D1JcAWG257NN6fA1FLJk+QZWgK1C3zO8vm9+OhStxSWno/Okl?=
 =?us-ascii?Q?ObwVYxZPiDFMpA4GLvdmGcPMp6ZPlnM7BD1iX30ywLbFcrHDAHeNqN5/cJFF?=
 =?us-ascii?Q?J8Zxk2lbFgCLtaQcwyyiQ9dj+uQ3tzL3QNjFvtn5RcQW8RgFR42O+W1+SE9I?=
 =?us-ascii?Q?oFtdKtZmhc8b08uxuwa6STLLYyuTRhk51UPo4GzALF3gGSKO5EMIjUTa+f8b?=
 =?us-ascii?Q?5wEcDM1bLy0zlATtHi4bNVpRH/LZmBmra11SPc7n3zqqeLJ1Biheh1QhrV/i?=
 =?us-ascii?Q?U658BZtAZ07Xpyk9fuvmN7BmtY3wgYaBeyQHigiJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f584be06-16eb-4c4e-e967-08daba7bf9b9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 13:38:06.1988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDSM8g9tk4sNwHoiz1x6/+JCr/AJgo3x/n6tclGpH73o7CAFAzeXBx/1bRGEvffyZqDVWhXaEiTBBX/xm6PS5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7106
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 11:27:48PM +0000, Vladimir Oltean wrote:
> On Tue, Oct 25, 2022 at 01:00:12PM +0300, Ido Schimmel wrote:
> > From: "Hans J. Schultz" <netdev@kapio-technology.com>
> > 
> > When the bridge is offloaded to hardware, FDB entries are learned and
> > aged-out by the hardware. Some device drivers synchronize the hardware
> > and software FDBs by generating switchdev events towards the bridge.
> > 
> > When a port is locked, the hardware must not learn autonomously, as
> > otherwise any host will blindly gain authorization. Instead, the
> > hardware should generate events regarding hosts that are trying to gain
> > authorization and their MAC addresses should be notified by the device
> > driver as locked FDB entries towards the bridge driver.
> > 
> > Allow device drivers to notify the bridge driver about such entries by
> > extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
> > bit. The bit can only be set by device drivers and not by the bridge
> > driver.
> 
> What prevents a BR_FDB_LOCKED entry learned by the software bridge in
> br_handle_frame_finish() from being notified to switchdev (as non-BR_FDB_LOCKED,
> since this is what br_switchdev_fdb_notify() currently hardcodes)?
> 
> I think it would be good to reinstate some of the checks in
> br_switchdev_fdb_notify() like the one removed in commit 2c4eca3ef716
> ("net: bridge: switchdev: include local flag in FDB notifications"):
> 
> 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
> 		return;
> 
> at least until we need something more complex and somebody on the
> switchdev chain wants to snoop these addresses for some incredibly odd
> reason.

Good idea, will add a check in br_switchdev_fdb_notify().

> 
> > Prevent a locked entry from being installed if MAB is not enabled on the
> > bridge port. By placing this check in the bridge driver we avoid the
> > need to reflect the 'BR_PORT_MAB' flag to device drivers.
> 
> So how does the device driver know whether to emit the SWITCHDEV_FDB_ADD_TO_BRIDGE
> or not, if we don't pass the BR_PORT_MAB bit to it?

At least for Spectrum, no special configuration is required for MAB
compared to a locked port with learning enabled. Learning notifications
will always be generated by the device and the driver will report them
as "locked" entries to the bridge driver, which will decide whether to
install them or not based on the 'BR_PORT_MAB' flag.

Once we have a driver that needs to differentiate between a locked port
with learning enabled and a port with MAB enabled, we can start passing
'BR_PORT_MAB' to drivers. Should be an easy change.

> 
> > If an entry already exists in the bridge driver, reject the locked entry
> > if the current entry does not have the "locked" flag set or if it points
> > to a different port. The same semantics are implemented in the software
> > data path.
> > 
> > Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 4ce8b8e5ae0b..4c4fda930068 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -811,7 +811,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
> >  void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
> >  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
> >  			      const unsigned char *addr, u16 vid,
> > -			      bool swdev_notify);
> > +			      bool locked, bool swdev_notify);
> >  int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
> >  			      const unsigned char *addr, u16 vid,
> >  			      bool swdev_notify);
> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > index 8f3d76c751dd..6afd4f241474 100644
> > --- a/net/bridge/br_switchdev.c
> > +++ b/net/bridge/br_switchdev.c
> > @@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
> >  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> >  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
> >  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> > +	item->locked = 0;
> 
> 0 or false? A matter of preference, I presume. Anyway, this will only be
> correct with the extra check mentioned above. Otherwise, a LOCKED entry
> may be presented as non-LOCKED to switchdev, with potentially unforeseen
> consequences.

Will change to false.

> 
> >  	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
> >  	item->info.ctx = ctx;
> >  }
> > -- 
> > 2.37.3
> >
