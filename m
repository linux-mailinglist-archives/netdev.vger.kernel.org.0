Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E565F6B62
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiJFQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 12:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiJFQTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 12:19:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B858ACA30;
        Thu,  6 Oct 2022 09:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3766D619EC;
        Thu,  6 Oct 2022 16:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB7DC433D6;
        Thu,  6 Oct 2022 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665073153;
        bh=ZgXM77/CXlz1KembRPwUCZZrHGoZx+VZ1yM34EffbDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gEShlUmDsmrXFXkkL6VV7Tkd4KDRKAAj4NZuGie4VsVXHZydPqgc8prwovsqfWB6L
         MCElEH85luzIXRFjWFJ6ZX07qiAqTRF5oyrMiPWvWWI7Js2zPfWkBEMMr267knlXEV
         fgNiLhGl/45LlWkH1k/InWUQsgzNCeNWTCeP+GMXMctcoP+BZf7gXsfLoglwyqzi1s
         uO/wUhFVDCKYJTxxe0r/aSDasdXzJvWsi+FFu60VRt2eTJUfDoOtFowcNfgSQeLAop
         hGhR/v6A/Ig5JTp/YU4IYN1Sa4hW8LR/oSHXNzQvjgCamlxAcFC0wuxl/IPgFpljev
         vMno992AvkUxw==
Date:   Thu, 6 Oct 2022 19:19:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        v9fs-developer@lists.sourceforge.net, linux_oss@crudebyte.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "9p: p9_client_create: use p9_client_destroy
 on failure"
Message-ID: <Yz7//EA4mfR7KL3D@unreal>
References: <cover.1664442592.git.leonro@nvidia.com>
 <024537aa138893c838d9cacc2e24f311c1e83d25.1664442592.git.leonro@nvidia.com>
 <Yzww1LRLIE+It6J8@kadam>
 <YzyfM1rJrmT1Qe4N@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzyfM1rJrmT1Qe4N@codewreck.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 06:01:39AM +0900, Dominique Martinet wrote:
> Dan Carpenter wrote on Tue, Oct 04, 2022 at 04:10:44PM +0300:
> > On Thu, Sep 29, 2022 at 12:37:55PM +0300, Leon Romanovsky wrote:
> > > Rely on proper unwind order.
> > > 
> > > This reverts commit 3ff51294a05529d0baf6d4b2517e561d12efb9f9.
> > > 
> > > Reported-by: syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com
> > > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > 
> > The commit message doesn't really say what the problem is to the user.
> > Is this just to make the next patch easier?
> 
> Yes (and perhaps a bit of spite from the previous discussion), and the
> next patch was not useable so I am not applying this as is.
> 
> The next patch was meant as an alternative implementation to this fix:
> https://lore.kernel.org/all/20220928221923.1751130-1-asmadeus@codewreck.org/T/#u
> 
> At this point I have the original fix in my -next branch but it hasn't
> had any positive review (and well, I myself agree it's ugly), so unless
> Leon sends a v2 I'll need to think of a better way of tracking if
> clnt->trans_mod->create has been successfully called.
> I'm starting to think that since we don't have so many clnt I can
> probably just fit a bool/bitfield in one of the holes of the struct
> and just keep track of it; that'll be less error-prone than relying on
> clnt->trans (which -is- initialized in create() most of the time, but
> not in a way we can rely on) or reworking create() to return it as I
> originally wanted to do (rdma still needs to populate clnt->trans behind
> the scenees before create() returns, so the abstraction is also quite
> ugly)
> 
> The current breakage is actually quite bad so I'll try to send that
> today or tomorrow for merging next week unless Leon resends something we
> can work with... Conceptually won't be different than the patch
> currently in next so hopefully can pretend it's had a couple of weeks of
> testing...

I can't resend anything in near future and most of the time have very
limited access to computer due to holidays here.

Thanks

> -- 
> Dominique
