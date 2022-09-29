Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434065EFF35
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiI2VVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiI2VVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:21:08 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D50792DA;
        Thu, 29 Sep 2022 14:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=82CVBJMMg98pUNlHUvfZc77iRO0SkRHuyncOXZOobb0=; b=gNmVA9qql9f+jgH9jCCrya+yQ9
        iPMje2hMZ1ZSzQr8S2Ien0bIoiMdJCUAi7nOfsPyYCZ83wCWoCBXlR7gZFEHLM15XWGdWHtkcp1ZH
        ZzQ7iAMDAqU8MyYl23SGseHPoZl/lSnOycCO4PneM5k9ZDWwuYlX3Uo/7dhpX7F1K28PhZHOaRpPh
        C6i4et6apdoYHo/rbilXZz5lVFtuwRHVKbjLCZY+EKJxWaNT4qK+gRG8bvw2rc096AFjclk4brjxW
        JkOuxbko4XUznNtchVGgJ9Sx0JJuU9vLLEjjfnxU5ykSWez+ZEdM1nw2KRRqjfsaT6IosmeE7Qcew
        zv+qkzLg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oe0xs-00562S-0g;
        Thu, 29 Sep 2022 21:21:04 +0000
Date:   Thu, 29 Sep 2022 22:21:04 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzYMQDTAYCCax0WZ@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
 <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
 <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 02:13:57PM -0700, Linus Torvalds wrote:
> On Thu, Sep 29, 2022 at 12:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Apparmor takes mount+dentry and turns that into pathname.  Then acts
> > upon the resulting string.  *AFTER* the original had been resolved.
> 
> Ok. So it would have to act like a bind mount.
> 
> Which is probably not too bad.
> 
> In fact, maybe it would be ok for this to act like a hardlink and just
> fill in the inode - not safe for a filesystem in general due to the
> whole rename loop issue, but for /proc it might be fine?

_Which_ hardlink?

Linus, where in dentry tree would you want it to be seen?  Because
apparmor profile wants /proc/net/dev to land at /proc/<pid>/net/dev
and will fail with anything else.

Do you really want multiple dentries with the same name in the same
parent, refering to different directory inodes with different contents?

And that's different inodes with different contents - David's complaint
is precisely about seeing the same thing for all threads and apparmor
issue is with *NOT* seeing each of those things at the same location.
