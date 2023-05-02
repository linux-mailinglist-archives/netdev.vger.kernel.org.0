Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6326F4287
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjEBLTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjEBLTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC944EC8
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 04:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A30906233E
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 11:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C37C433D2;
        Tue,  2 May 2023 11:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683026358;
        bh=QtxtKwvM/g6BcGd1ea9E0H+9xGAUMpjaYH1EgO7neh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0qUoq0e+1rJBX4tfJlGP292vOCKZLuoJscFoTs3qLPYzc5k5JHZ+SfrdL9IkCD28
         elqnMbG7K0QylPLF/vGpVRkqW2mlx5NT4iNPbtgY7ErLfhq3q/3XP4518kfWvRAmyn
         VnaCpdYmIf291naEECpovxDCtDxRu54nFJvLKYRvrS8xPzlTUYvRO4gVLX4RhuYuJq
         Joizn73EPvUxxwWtAKfPxp7G3ViKxGxJbB2J0fRksIj0VZcbc/MYTMXDEgKpzQLn1e
         qujnglqh8KY9JD5hLwUU3g/ecANRGzmFTJT13Kn0k/GR0yxPPlPX9nGUJNxDCXKE0u
         HOxqUCU+di+Jw==
Date:   Tue, 2 May 2023 14:19:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [EXT] Re: [PATCH net] qed/qede: Fix scheduling while atomic
Message-ID: <20230502111913.GA525452@unreal>
References: <20230425122548.32691-1-manishc@marvell.com>
 <20230426063607.GD27649@unreal>
 <BY3PR18MB46127EC56DF88024DEC65488AB659@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB46127EC56DF88024DEC65488AB659@BY3PR18MB4612.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 08:11:04AM +0000, Manish Chopra wrote:
> Hi Leon,
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, April 26, 2023 12:06 PM
> > To: Manish Chopra <manishc@marvell.com>
> > Cc: kuba@kernel.org; netdev@vger.kernel.org; Ariel Elior
> > <aelior@marvell.com>; Alok Prasad <palok@marvell.com>; Sudarsana Reddy
> > Kalluru <skalluru@marvell.com>; David S . Miller <davem@davemloft.net>
> > Subject: [EXT] Re: [PATCH net] qed/qede: Fix scheduling while atomic
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Tue, Apr 25, 2023 at 05:25:48AM -0700, Manish Chopra wrote:
> > > Bonding module collects the statistics while holding the spinlock,
> > > beneath that qede->qed driver statistics flow gets scheduled out due
> > > to usleep_range() used in PTT acquire logic which results into below
> > > bug and traces -
> > >
> > > [ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant
> > > DL365 Gen10 Plus, BIOS A42 10/29/2021 [ 3673.988878] Call Trace:
> > > [ 3673.988891]  dump_stack_lvl+0x34/0x44 [ 3673.988908]
> > > __schedule_bug.cold+0x47/0x53 [ 3673.988918]  __schedule+0x3fb/0x560 [
> > > 3673.988929]  schedule+0x43/0xb0 [ 3673.988932]
> > > schedule_hrtimeout_range_clock+0xbf/0x1b0
> > > [ 3673.988937]  ? __hrtimer_init+0xc0/0xc0 [ 3673.988950]
> > > usleep_range+0x5e/0x80 [ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
> > > [ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed] [ 3673.989001]
> > > qed_get_vport_stats+0x18/0x80 [qed] [ 3673.989016]
> > > qede_fill_by_demand_stats+0x37/0x400 [qede] [ 3673.989028]
> > > qede_get_stats64+0x19/0xe0 [qede] [ 3673.989034]
> > > dev_get_stats+0x5c/0xc0 [ 3673.989045]
> > > netstat_show.constprop.0+0x52/0xb0
> > > [ 3673.989055]  dev_attr_show+0x19/0x40 [ 3673.989065]
> > > sysfs_kf_seq_show+0x9b/0xf0 [ 3673.989076]  seq_read_iter+0x120/0x4b0
> > > [ 3673.989087]  new_sync_read+0x118/0x1a0 [ 3673.989095]
> > > vfs_read+0xf3/0x180 [ 3673.989099]  ksys_read+0x5f/0xe0 [ 3673.989102]
> > > do_syscall_64+0x3b/0x90 [ 3673.989109]
> > > entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [ 3673.989115] RIP: 0033:0x7f8467d0b082 [ 3673.989119] Code: c0 e9 b2
> > > fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f
> > > 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77
> > > 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24 [ 3673.989121] RSP:
> > > 002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000 [
> > > 3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX:
> > > 00007f8467d0b082 [ 3673.989128] RDX: 00000000000003ff RSI:
> > > 00007ffffb21fdc0 RDI: 0000000000000003 [ 3673.989130] RBP:
> > 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00 [
> > 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12:
> > 00000000000000f0 [ 3673.989134] R13: 0000000000000003 R14:
> > 00007f8467b92000 R15: 0000000000045a05
> > > [ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded
> > Tainted: G        W  OE
> > >
> > > Fix this by having caller (QEDE driver flows) to provide the context
> > > whether it could be in atomic context flow or not when getting the
> > > vport stats from QED driver. QED driver based on the context provided
> > > decide to schedule out or not when acquiring the PTT BAR window.
> > 
> > And why don't you implement qed_ptt_acquire() to be atomic only?
> > 
> > It will be much easier to do so instead of adding is_atomic in all the places.
> 
> qed_ptt_acquire() is quite crucial and delicate for HW access, throughout the driver it is used at many places and
> from various different flows. Changing/Making it atomic completely for all the flows (even for the flows which are
> non-atomic which is mostly 99.9% of all the flows except the .ndo_get_stats64() flow which could be atomic in bonding
> configuration) sounds aggressive and I am afraid if it could introduce any sort of regressions in the driver as the impact
> would be throughout all the driver flows. Currently there is only single functional flow (getting vport stats) which seems
> to be demanding for qed_ptt_acquire() to be atomic so that's why it is done exclusively and keeping all other flows intact
> in the driver from functional regression POV.

Sorry, but I don't understand about which regression you are talking.
Your change to support atomic was change from usleep_range to be udelay.

+               if (is_atomic)
+                       udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
+               else
+                       usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
+                                    QED_BAR_ACQUIRE_TIMEOUT_USLEEP * 2);

Also in documentation, there is a section about it.
Documentation/networking/statistics.rst:
  200 The `.ndo_get_stats64` callback can not sleep because of accesses
  201 via `/proc/net/dev`. If driver may sleep when retrieving the statistics
  202 from the device it should do so periodically asynchronously and only return
  203 a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
  204 allows setting the frequency of refreshing statistics, if needed.

Thanks
