Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1461B5EDC0E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiI1LyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbiI1LyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0405E56F;
        Wed, 28 Sep 2022 04:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E38FB82056;
        Wed, 28 Sep 2022 11:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB66AC433C1;
        Wed, 28 Sep 2022 11:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664366048;
        bh=hulhezLqRBKK8E1gjp7vWO38O+DMT/KxUVnBXOBSOQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ciZbc4xklNIJ97bZwBY5d7bmodICuHbMRWrgm8tempqdCWxWdya+TI6BcT5FCDlVb
         83spigJLPisO/aER9kNRqrXLyGJY7q1tKoxORHltsXfb/JjO6EC/8zdQXRYUviXJhA
         lKgb3UJjuBtBGGNb1mjDWlVU/co4yEAVssSepnumbGj5qYHzA172ZKI2iVtnvyHzd5
         vlIAE0ginJ3c2F7mJ0ZTI/0CzkiwkIYSZfuGwDPZkS/eVMkd7Zq3Z1co8eP/egAzGd
         dR8AubT7rWigPqSLxaxuwgjBP7IFL1z0eV9U2gF/VFYnk9ocCPk3uap3XbTCATHap0
         ZdXVmuBB8RiuA==
Date:   Wed, 28 Sep 2022 14:54:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     asmadeus@codewreck.org
Cc:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzQ12+jtARpwS5bw@unreal>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQc2yaDufjp+rHc@unreal>
 <YzQlWq9EOi9jpy46@codewreck.org>
 <YzQmr8LVTmUj9+zB@unreal>
 <YzQuoqyGsooyDfId@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzQuoqyGsooyDfId@codewreck.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 08:23:14PM +0900, asmadeus@codewreck.org wrote:
> Leon Romanovsky wrote on Wed, Sep 28, 2022 at 01:49:19PM +0300:
> > > But I agree I did get that wrong: trans_mod->close() wasn't called if
> > > create failed.
> > > We do want the idr_for_each_entry() that is in p9_client_destroy so
> > > rather than revert the commit (fix a bug, create a new one..) I'd rather
> > > split it out in an internal function that takes a 'bool close' or
> > > something to not duplicate the rest.
> > > (Bit of a nitpick, sure)
> > 
> > Please do proper unwind without extra variable.
> > 
> > Proper unwind means that you will call to symmetrical functions in
> > destroy as you used in create:
> > alloc -> free
> > create -> close
> > e.t.c
> > 
> > When you use some global function like you did, there is huge chance
> > to see unwind bugs.
> 
> No.

Let's agree to disagree.

> 
> Duplicating complicated cleanup code leads to leaks like we used to
> have; that destroy function already frees up things in the right order.

It is pretty straightforward code, nothing complex there.

Just pause for a minute, and ask yourself how totally random guy who
looked on this syzbot bug just because RDMA name in it, found the issue
so quickly.

I will give a hint, I saw not symmetrical error unwind in call trace.

Thanks
