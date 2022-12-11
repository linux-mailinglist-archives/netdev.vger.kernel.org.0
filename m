Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55357649357
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 10:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiLKJjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 04:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLKJjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 04:39:07 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148DB63B0;
        Sun, 11 Dec 2022 01:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b8eECkmSUe5QTUW/M80U06khZU8RQ+xH7KebZuSN7LU=; b=NsLBxfw6ojIVZnnZslmW2n5RAG
        h8qGPxAooBg/HjQIkxs20LTzfOySQXS9qAANRH+2U4M4ADsCZy7RaQIpEPNRzcLHSzYkErTYr9N+l
        wAR+Ks5rUgLx5wDQjilDgOzx5ULVuF89RlFb1EmpoKkb2V7toprHQFBFzmI27jkZ5HbD0xul0zuDJ
        3J8+RUDjk+sa4lqM8iSJLk1M0ozwa7FXXu7Dusj7RQ03AOlRiIfPOM8f83uuSNo3heO2IahL7msh3
        LLKBPsmexM8uZix2U0o60Wpnp3Xif0bvVfRrz7buHI9q7pyDfq06ABc7gpY6oTSMt8BsRlOWzDmvy
        bJ3il9MQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1p4InO-00B0H9-1q;
        Sun, 11 Dec 2022 09:38:54 +0000
Date:   Sun, 11 Dec 2022 09:38:54 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>,
        davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Subject: Re: [syzbot] WARNING in _copy_from_iter
Message-ID: <Y5WlLoCBcHbfKBD5@ZenIV>
References: <000000000000bc5b5a05ef56276d@google.com>
 <CANn89i+ov7yr_aKNnXdGekZaCT8RW1ijRhPj4BXkKK2hJ0OH3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+ov7yr_aKNnXdGekZaCT8RW1ijRhPj4BXkKK2hJ0OH3A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 08:38:14PM +0100, Eric Dumazet wrote:

> Exposes an old bug in tipc ?
> 
> Seems a new check added by Al in :
> 
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Sep 15 20:11:15 2022 -0400
> 
>     iov_iter: saner checks for attempt to copy to/from iterator
> 
>     instead of "don't do it to ITER_PIPE" check for ->data_source being
>     false on copying from iterator.  Check for !->data_source for
>     copying to iterator, while we are at it.
> 
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Lovely...  zero-length sendmsg with uninitialized ->msg_data...

	I would probably argue that it's a bug in tipc_connect(),
fixed by iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
in there.  Depends - if that kind of uninitialized msg_iter used
as zero length source or zero length destination is a frequent pattern,
might as well make zero-byte copy_...iter() succeed quietly;
I hope it isn't, but that's definitely something I'd missed
when doing that series.

	I'll take a look tomorrow^Win the morning, after I get
some sleep...
