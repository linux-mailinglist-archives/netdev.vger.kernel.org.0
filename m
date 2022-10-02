Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCE5F22C9
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 12:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiJBK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 06:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJBK4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 06:56:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1B84B0D5
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 03:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FBEB80D24
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 10:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F60C433D6;
        Sun,  2 Oct 2022 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664708192;
        bh=fb9Xn9fC5RTn47FZjAgyFHsnb5kIGpvDJyPJccDp3bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVuG+UsjF3z1rHSUNbNjke65t6Oz01hqxesN1Gsu2PKqu8ldSQQ+41PBNJ2CVAyNl
         wPFByM8RMzqSq0hI5RjsUl4Bngvle7I2inGo5bjWOQ4Ga5TrhCoW79UCO2KR7Zpuon
         9Gwy60lik0EOXeeNf7dD3MoWhACgN9MNv7Zy1mk8WZQQnBK9ATeacAcg2hNdmjCDIp
         4R68KfWqg5wQYZ81gZur7ayh4Ex3EXSUO5yLUGgt7uPgzX/f6YWYCBlVLWUXGyADFL
         Z5ag4uI6s/mxVXyRbql9ONAWzeDsYrhZvDfK37qdb3bg68fjVN9fE7yQ52HiKZhrFf
         gzV+g4l7GSNvA==
From:   James Hogan <jhogan@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: Re: [WIP v2] igc: fix deadlock caused by taking RTNL in RPM resume path
Date:   Sun, 02 Oct 2022 11:56:28 +0100
Message-ID: <3329047.e9J7NaK4W3@saruman>
In-Reply-To: <3186253.aeNJFYEL58@saruman>
References: <20220811151342.19059-1-vinicius.gomes@intel.com> <2301866.ElGaqSPkdT@saruman> <3186253.aeNJFYEL58@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 29 August 2022 09:16:33 BST James Hogan wrote:
> On Saturday, 13 August 2022 18:18:25 BST James Hogan wrote:
> > On Saturday, 13 August 2022 01:05:41 BST Vinicius Costa Gomes wrote:
> > > James Hogan <jhogan@kernel.org> writes:
> > > > On Thursday, 11 August 2022 21:25:24 BST Vinicius Costa Gomes wrote:
> > > >> It was reported a RTNL deadlock in the igc driver that was causing
> > > >> problems during suspend/resume.
> > > >> 
> > > >> The solution is similar to commit ac8c58f5b535 ("igb: fix deadlock
> > > >> caused by taking RTNL in RPM resume path").
> > > >> 
> > > >> Reported-by: James Hogan <jhogan@kernel.org>
> > > >> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > > >> ---
> > > >> Sorry for the noise earlier, my kernel config didn't have runtime PM
> > > >> enabled.
> > > > 
> > > > Thanks for looking into this.
> > > > 
> > > > This is identical to the patch I've been running for the last week.
> > > > The
> > > > deadlock is avoided, however I now occasionally see an assertion from
> > > > netif_set_real_num_tx_queues due to the lock not being taken in some
> > > > cases
> > > > via the runtime_resume path, and a suspicious
> > > > rcu_dereference_protected()
> > > > warning (presumably due to the same issue of the lock not being
> > > > taken).
> > > > See here for details:
> > > > https://lore.kernel.org/netdev/4765029.31r3eYUQgx@saruman/
> > > 
> > > Oh, sorry. I missed the part that the rtnl assert splat was already
> > > using similar/identical code to what I got/copied from igb.
> > > 
> > > So what this seems to be telling us is that the "fix" from igb is only
> > > hiding the issue,
> > 
> > I suppose the patch just changes the assumption from "lock will never be
> > held on runtime resume path" (incorrect, deadlock) to "lock will always be
> > held on runtime resume path" (also incorrect, probably racy).
> > 
> > > and we would need to remove the need for taking the
> > > RTNL for the suspend/resume paths in igc and igb? (as someone else said
> > > in that igb thread, iirc)
> > 
> > (I'll defer to others on this. I'm pretty unfamiliar with networking code
> > and this particular lock.)
> 
> I'd be great to have this longstanding issue properly fixed rather than
> having to carry a patch locally that may not be lock safe.
> 
> Also, any tips for diagnosing the issue of the network link not coming back
> up after resume? I sometimes have to unload and reload the driver module to
> get it back again.

Any thoughts on this from anybody?

Cheers
James


