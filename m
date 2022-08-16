Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8DF5952EE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiHPGsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiHPGrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:47:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCD3158370
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 18:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C467AB815AA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA7EC433D6;
        Tue, 16 Aug 2022 01:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660614690;
        bh=3mFnwHIvUy6rD9B33NVUSCpQ5GwS3yI1cfhuFz5SH9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bjjSCuBBegNpz6Q8VWgie33p6BxYv7FMLfiAvCLNwvwyfHFMsvFIYixQtglLpuP3G
         qzffc0OYy4v/K+H6899m7MJljA/A9mpGrdAXuB55mjhh1POq0aDR4+8agVlDaB1KGj
         2q85Q1xrAv0w9KeHPC0ml8DTh32gGfV6+grNLLFoK/hNljiErBekxYT7PUHVSRvDm+
         Z7MyUK1gmh0QjkBYGwtvWRodzmgOAqXlB7yXwmJQWhKcwVyf4NMRvi/CJb0RXBafBx
         +UXYPtqfNYHRvWP7kALz+OvnfY2tdRoyzNJAFxbGYcyfk89Wvq0EhsZV4Pt+H9Tnr3
         axc6cHtVjEJoQ==
Date:   Mon, 15 Aug 2022 18:51:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rafael Soares <rafaelmendsr@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes.berg@intel.com,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: genl: fix error path memory leak in policy
 dumping
Message-ID: <20220815185129.04e4c703@kernel.org>
In-Reply-To: <Yvq16sC3Pytaf04k@macondo>
References: <20220815182021.48925-1-kuba@kernel.org>
        <Yvq16sC3Pytaf04k@macondo>
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

On Mon, 15 Aug 2022 18:08:58 -0300 Rafael Soares wrote:
> On Mon, Aug 15, 2022 at 11:20:21AM -0700, Jakub Kicinski wrote:
> > If construction of the array of policies fails when recording
> > non-first policy we need to unwind.
> > 
> > Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
> > Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/netlink/genetlink.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> > index 1afca2a6c2ac..57010927e20a 100644
> > --- a/net/netlink/genetlink.c
> > +++ b/net/netlink/genetlink.c
> > @@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
> >  							     op.policy,
> >  							     op.maxattr);
> >  			if (err)
> > -				return err;
> > +				goto err_free_state;  
> 
> There's another call to netlink_policy_dump_add_policy() right above
> this one. The patch I posted to syzkaller frees the memory inside
> netlink_policy_dump_add_policy() and the result was OK.

Oh, sorry, I didn't see this reply. Every single time after the merge
window is over the stable folks bombard the mailing systems with their
backported patches and bring the mailing lists to their knees :/

Do you see your posting on lore.kernel.org? I presume not. You really
need to use ./scripts/get_maintainer and CC relevant folks directly.

This is v2 of my fix I submitted to syzbot for testing:

https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=genl-fix&id=66f01a660c4439fc78a6fc68413f895b8fd07474

The earlier call to netlink_policy_dump_add_policy() should not be 
a problem if the function unwound its state properly.
