Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A342264C4CB
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiLNINq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiLNIMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3963A186D7;
        Wed, 14 Dec 2022 00:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAC0F61868;
        Wed, 14 Dec 2022 08:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2878C433D2;
        Wed, 14 Dec 2022 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671005552;
        bh=DSvWrNDJTYbQq+O/3wlRisDYux8vErJvCnu+Bs8Cbzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhglH7A3iFJu0QSud6fZT8phDahPJxxULULh/7blE8lPx9J9dcizr6fg1wVtEt8zA
         WAlvE9hRP2PVQAoabsqi0mdZHFcYZk+bt7VSwicG9BTu7PGgCs07/PCSagDzdRWQvJ
         x7YVLc9WihXvYEGP+UQh6IiEDIySX1LcKlq8Ip7Fl9I6vKInjdwMisZ/nwOdd9l1q/
         oVPWAz/KguXjLgbp0/wqZEDH02h1T48+v5vxEXHh+3+/jpkntIaxUF7rKFM4EDP7X1
         cpj7etWWE9Wn6eWqCPh7ib4V6fvz/Hb1LoL4iAnTW8aWEYmQ3xfp2fY5e/McK/08k6
         flDOneRbIehJg==
Date:   Wed, 14 Dec 2022 10:12:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Masaru Nagai <masaru.nagai.vx@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Message-ID: <Y5mFa2CgDcm2k6fh@unreal>
References: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
 <Y5l2Ix2W8yPLycIB@unreal>
 <OS0PR01MB5922BB03158ED90DD2B82DBE86E09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922BB03158ED90DD2B82DBE86E09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 08:07:55AM +0000, Biju Das wrote:
> Hi Leon Romanovsky,
> 
> Thanks for the feedback.
> 
> > Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to config
> > mode" message during unbind
> > 
> > On Tue, Dec 13, 2022 at 09:59:38AM +0000, Biju Das wrote:
> > > This patch fixes the error "ravb 11c20000.ethernet eth0: failed to
> > > switch device to config mode" during unbind.
> > >
> > > We are doing register access after pm_runtime_put_sync().
> > >
> > > We usually do cleanup in reverse order of init. Currently in remove(),
> > > the "pm_runtime_put_sync" is not in reverse order.
> > >
> > > Probe
> > > 	reset_control_deassert(rstc);
> > > 	pm_runtime_enable(&pdev->dev);
> > > 	pm_runtime_get_sync(&pdev->dev);
> > >
> > > remove
> > > 	pm_runtime_put_sync(&pdev->dev);
> > > 	unregister_netdev(ndev);
> > > 	..
> > > 	ravb_mdio_release(priv);
> > > 	pm_runtime_disable(&pdev->dev);
> > >
> > > Consider the call to unregister_netdev()
> > > unregister_netdev->unregister_netdevice_queue->rollback_registered_man
> > > y that calls the below functions which access the registers after
> > > pm_runtime_put_sync()
> > >  1) ravb_get_stats
> > >  2) ravb_close
> > >
> > > Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
> > 
> > I don't know how you came to this fixes line, but the more correct one is
> > c156633f1353 ("Renesas Ethernet AVB driver proper")
> 
> I got the details from [1]. The file name is renamed immediately after c156633f1353.
> 
> So from Stable backporting point I feel [1] is better.

No, you should use correct tag from the beginning, @stable will figure it.

Thanks
