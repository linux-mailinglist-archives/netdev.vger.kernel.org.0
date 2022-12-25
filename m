Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DBE655CCD
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLYJru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 04:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYJrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 04:47:49 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 421BD62C8;
        Sun, 25 Dec 2022 01:47:47 -0800 (PST)
Received: from localhost.localdomain (unknown [10.81.81.211])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gw.red-soft.ru (Postfix) with ESMTPSA id 0FCA53E0DB1;
        Sun, 25 Dec 2022 12:47:44 +0300 (MSK)
Date:   Sun, 25 Dec 2022 12:47:42 +0300
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [PATCH] batman-adv: Check return value
Message-ID: <Y6gcPlvR18j17zlm@localhost.localdomain>
References: <20221224233311.48678-1-artem.chernyshev@red-soft.ru>
 <2038034.tdWV9SEqCh@sven-l14>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2038034.tdWV9SEqCh@sven-l14>
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174384 [Dec 24 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lists.open-mesh.org:7.1.1;127.0.0.199:7.1.2;patchwork.open-mesh.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;red-soft.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/25 09:24:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/25 06:19:00 #20705928
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Sun, Dec 25, 2022 at 07:37:28AM +0100, Sven Eckelmann wrote:
> Subject is missing something like ..." after calling rtnl_link_register()" or
> ..."s during module initialization".
> 
> On Sunday, 25 December 2022 00:33:11 CET Artem Chernyshev wrote:
> [...]
> > diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
> > index e8a449915566..04cd9682bd29 100644kwin
> > @@ -113,7 +113,11 @@ static int __init batadv_init(void)
> >  		goto err_create_wq;
> >  
> >  	register_netdevice_notifier(&batadv_hard_if_notifier);
> > -	rtnl_link_register(&batadv_link_ops);
> > +	ret = rtnl_link_register(&batadv_link_ops);
> > +	if (ret) {
> > +		pr_err("Can't register link_ops\n");
> > +		goto err_create_wq;
> > +	}
> >  	batadv_netlink_register();
> >  
> >  	pr_info("B.A.T.M.A.N. advanced %s (compatibility version %i) loaded\n",
> > 
> 
> This looks wrong to me. You missed to destroy the batadv_hard_if_notifier in 
> this case.
> 
> And if you want to start adding the checks, you should also have added it for 
> batadv_v_init, batadv_iv_init, batadv_nc_init, batadv_tp_meter_init and 
> register_netdevice_notifier. You can use the unfinished patch from Markus 
> Pargmann as starting point.
> 
> Kind regards,
> 	Sven
> 
> [1] https://patchwork.open-mesh.org/project/b.a.t.m.a.n./patch/1419594103-10928-6-git-send-email-mpa@pengutronix.de/
>     https://lists.open-mesh.org/mailman3/hyperkitty/list/b.a.t.m.a.n@lists.open-mesh.org/thread/QDX46YARWUC4R7OBFHR5OJKWQIXDQWRR/#QDX46YARWUC4R7OBFHR5OJKWQIXDQWRR

Thanks for review, I'll try to fix the errors in v2

Best,
Artem
