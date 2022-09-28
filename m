Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA055EDA6E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiI1Kto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiI1Kt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:49:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558FAE86B;
        Wed, 28 Sep 2022 03:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E5A7B82023;
        Wed, 28 Sep 2022 10:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CBDC433D6;
        Wed, 28 Sep 2022 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664362164;
        bh=3bIQetYYgSam2FLQHAYrxvXLhb/+Gd5oeD+JuaALYZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o3p4PK+9QhzFzE+LWKF+cJkA+lJhnXOMfmpMqpDeZ04ojFR90Vgfw5Xe2cwMBfPwW
         bbMUUzAKPqdklWtE0/VtBCB+h6xtq7K0ISh0AbsyYjS0GzZFF70+9ufcPYYsE4ZEdx
         3Tt0dOqXGWFAtzh+vf+6GHFq+Xa+AOAZqX0nUg3T8pvng9GrHvnscywnsqpwVmpmlz
         vNMrta0SRo/4BNaDZS+vTaSlyrf05szizxotRVM1jFCDr36reTvRtb6WbQdonySEp6
         gP+dxV+jaJPUXVcSR4W70RNuasT+biVizlfb3L/m2fpLAhCny+Z3rsmSfp7AfXLh4/
         edPRNjPfm8hpg==
Date:   Wed, 28 Sep 2022 13:49:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     asmadeus@codewreck.org
Cc:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzQmr8LVTmUj9+zB@unreal>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQc2yaDufjp+rHc@unreal>
 <YzQlWq9EOi9jpy46@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzQlWq9EOi9jpy46@codewreck.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 07:43:38PM +0900, asmadeus@codewreck.org wrote:
> Leon Romanovsky wrote on Wed, Sep 28, 2022 at 01:07:23PM +0300:
> > The bug is in commit 3ff51294a055 ("9p: p9_client_create: use p9_client_destroy on failure").
> 
> Thanks for looking
> 
> > It is wrong to call to p9_client_destroy() if clnt->trans_mod->create fails.
> 
> hmm that's a bit broad :)
> 
> But I agree I did get that wrong: trans_mod->close() wasn't called if
> create failed.
> We do want the idr_for_each_entry() that is in p9_client_destroy so
> rather than revert the commit (fix a bug, create a new one..) I'd rather
> split it out in an internal function that takes a 'bool close' or
> something to not duplicate the rest.
> (Bit of a nitpick, sure)

Please do proper unwind without extra variable.

Proper unwind means that you will call to symmetrical functions in
destroy as you used in create:
alloc -> free
create -> close
e.t.c

When you use some global function like you did, there is huge chance
to see unwind bugs.

> 
> I'll send a patch and credit you in Reported-by unless you don't want
> to.
> 
> -- 
> Dominique
