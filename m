Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D674B3013
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353939AbiBKWG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:06:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345929AbiBKWG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:06:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857F4C72
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34576B82D52
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 22:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44BEC340E9;
        Fri, 11 Feb 2022 22:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644617182;
        bh=D/UWRmBDshnau0YzsQQy3oUUCb5K6vLPGdmjyJLYADA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4qiBtGsQHAwytLpISXSR0D7fTTqTo7+ed0ZHFLz3OrlcxaA2a3d1H7HSwvANLB6Z
         3AXq1xS8Itih5ZOSoWuPS5c+KEV0P6MklCNK7b9nptJuPViz8TIy4ws6XNbCa7ctbh
         MDT5sUWxryl6N6QzDDoryhQZdThCqcTQyyt/DlFXoD+7fcZjBmy3f1E8OEVoiW08Q3
         88qUWcamboTKLmC1l1aGKMTDP+H7UkksdZIDxGo5lCL/uCGNSlh5SVKC2SGuWeqe/e
         hr/7/aAUSmwlTaJdxQSXaiE6t+HgB1P5jbv7xSddBSEFRTn7XMMVl4j+cKYgRMKcyz
         2ly803mGb0MrA==
Date:   Fri, 11 Feb 2022 14:06:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
Message-ID: <20220211140620.6a4fc338@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADvbK_f-Zk9X7M87yUi8msAykA9z+5-te3hNXg3TRE+bfpfmBg@mail.gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
        <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
        <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
        <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
        <20220209215943.71ee15f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_f-Zk9X7M87yUi8msAykA9z+5-te3hNXg3TRE+bfpfmBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 15:58:56 +0800 Xin Long wrote:
> On Thu, Feb 10, 2022 at 1:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > This is doable, and risky ;)
> > >
> > > BTW, I have the plan of generalizing blackhole_netdev for IPv6,
> > > meaning that we could perhaps get rid of the dependency
> > > about loopback dev, being the last device in a netns being dismantled.  
> >
> > Oh, I see..
> >
> > I have no great ideas then, we may need to go back to zeroing
> > vlan->real_dev and making sure the caller can deal with that.
> > At least for the time being. Xin this was discussed at some
> > length in response to the patch under Fixes.  
> 
> What if dev->real_dev is freed and zeroed *after* vlan_dev_real_dev()
> is called? This issue can still be triggered, right? I don't see any lock
> protecting this.

Maybe the suggestion in the old thread was to NULL the pointer out
before unregister is called. Which seems like a bad idea, as the 
netdev would already be impaired when unregister is called.

> > Feels like sooner or later we'll run into a scenario when reversing will
> > cause a problem. Or some data structure will stop preserving the order.  
> I was checking a few places doing such batch devices freeing, and noticed that:
> In rtnl_group_dellink() and __rtnl_kill_links(), it's using for_each_netdev(),
> while in default_device_exit_batch(), it's using for_each_netdev_reverse().
> 
> shouldn't be in the same order all these places? If yes, which one is the
> right one to use?

I don't know. Maybe this will work maybe it will cause a circular
dependency with something else.

Honestly, I don't have a simple solutions to offer. Jann Horn pointed
out recently that our per-CPU netdev refs are themselves racy...
