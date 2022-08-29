Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15E25A44CD
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiH2IQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2IQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F91C13E32
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 01:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 368CC60BD6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A149C433D7;
        Mon, 29 Aug 2022 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661760997;
        bh=ddsvlm5uix9WdTqZZUfUm4ae/TUa8Ac9HgZ4vXlgitw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyTLiLJwI53BGou1Q4bYu2E/sJUkEa8MPRjeT4rtU+sj7S5UBwIAtQy9yvwvaQ2rW
         /BJ02Hc6Lm9Lpkzzq34E34z8VA9R5LMQQKkLk1E2Mi/Z1VNyDHqdpjkLuz+Cig7jyA
         KSFkerTmZ0nFEgFl89dMi4BMpecgIKYc9ItWYtZxrtHukTi/VBYCXe4CQVV/WPjwG1
         1dOpqaudAscibiH/qa6krsptGXJSQhFyecNbklmkha22asT7qWoYjReYVelqPV2d74
         +5tvXjQOkvHJiafZTB7SxGmtJEbKEF0ObmyPOBCY0qfandis++r+kYL4k9nEYx/s/S
         JCIAJ/vOxdv7A==
From:   James Hogan <jhogan@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: Re: [WIP v2] igc: fix deadlock caused by taking RTNL in RPM resume path
Date:   Mon, 29 Aug 2022 09:16:33 +0100
Message-ID: <3186253.aeNJFYEL58@saruman>
In-Reply-To: <2301866.ElGaqSPkdT@saruman>
References: <20220811151342.19059-1-vinicius.gomes@intel.com> <87o7wpxb1m.fsf@intel.com> <2301866.ElGaqSPkdT@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, 13 August 2022 18:18:25 BST James Hogan wrote:
> On Saturday, 13 August 2022 01:05:41 BST Vinicius Costa Gomes wrote:
> > James Hogan <jhogan@kernel.org> writes:
> > > On Thursday, 11 August 2022 21:25:24 BST Vinicius Costa Gomes wrote:
> > >> It was reported a RTNL deadlock in the igc driver that was causing
> > >> problems during suspend/resume.
> > >> 
> > >> The solution is similar to commit ac8c58f5b535 ("igb: fix deadlock
> > >> caused by taking RTNL in RPM resume path").
> > >> 
> > >> Reported-by: James Hogan <jhogan@kernel.org>
> > >> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > >> ---
> > >> Sorry for the noise earlier, my kernel config didn't have runtime PM
> > >> enabled.
> > > 
> > > Thanks for looking into this.
> > > 
> > > This is identical to the patch I've been running for the last week. The
> > > deadlock is avoided, however I now occasionally see an assertion from
> > > netif_set_real_num_tx_queues due to the lock not being taken in some
> > > cases
> > > via the runtime_resume path, and a suspicious
> > > rcu_dereference_protected()
> > > warning (presumably due to the same issue of the lock not being taken).
> > > See here for details:
> > > https://lore.kernel.org/netdev/4765029.31r3eYUQgx@saruman/
> > 
> > Oh, sorry. I missed the part that the rtnl assert splat was already
> > using similar/identical code to what I got/copied from igb.
> > 
> > So what this seems to be telling us is that the "fix" from igb is only
> > hiding the issue,
> 
> I suppose the patch just changes the assumption from "lock will never be
> held on runtime resume path" (incorrect, deadlock) to "lock will always be
> held on runtime resume path" (also incorrect, probably racy).
> 
> > and we would need to remove the need for taking the
> > RTNL for the suspend/resume paths in igc and igb? (as someone else said
> > in that igb thread, iirc)
> 
> (I'll defer to others on this. I'm pretty unfamiliar with networking code
> and this particular lock.)

I'd be great to have this longstanding issue properly fixed rather than having 
to carry a patch locally that may not be lock safe.

Also, any tips for diagnosing the issue of the network link not coming back up 
after resume? I sometimes have to unload and reload the driver module to get 
it back again.

Cheers
James


