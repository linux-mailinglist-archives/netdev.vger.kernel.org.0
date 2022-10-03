Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4316F5F31B7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJCODj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:03:23 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F12F399D1;
        Mon,  3 Oct 2022 07:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uSZcwHHC6vjA/JyLw1ieYhy+3+qGRvP1/Cpnuvh2KUw=; b=HTJrCHO0kLrNeqZ3agxibv0uu6
        CtDzpwSrDn6lnTO2V8gH5zfamvSkoz6Q0t8EK8HFs9mnRPWPj7Z9D6BPvkrFDVUc5/AqGCJtjDRBq
        d7kv484xDaYotRrMsjaKEq6wGVFbiwUaZeURRmhctrSJ9fW1otINEw/tcV/Fsh2QhXn8zQJ2XgJMA
        uNoCxvWvziPFq1CIBAy1PasUeLboiljKCG93UO7RWaOZSRuT9yKKJeC2kRpAJIoxKVpvkWVEW8Ueb
        lQDv4ezy4mbfYzlwaJR98gWrsntqLzlnoBYFIaTPmHRpMkeIAxET6yXHoRnBPZTBVMDsPmsAPat6S
        M8CkWAog==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ofM2B-006SjX-0S;
        Mon, 03 Oct 2022 14:03:03 +0000
Date:   Mon, 3 Oct 2022 15:03:03 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Message-ID: <Yzrrl4MkM+xRysYd@ZenIV>
References: <YzXzXNAgcJeJ3M0d@ZenIV>
 <YzYK7k3tgZy3Pwht@ZenIV>
 <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
 <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
 <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
 <87a66g25wm.fsf@email.froward.int.ebiederm.org>
 <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
 <YzjJNnzRTiSpwXHV@ZenIV>
 <592405fa149247f58d05a213b8c6f711@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592405fa149247f58d05a213b8c6f711@AcuMS.aculab.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 09:36:46AM +0000, David Laight wrote:
> ...
> > * ability to chroot(2) had always been equivalent to ability to undo
> > chroot(2).  If you want to prevent getting out of there, you need
> > (among other things) to prevent the processes to be confined from
> > further chroot(2).
> 
> Not always, certainly not historically.

Factually incorrect.

> chroot() inside a chroot() just constrained you further.

What it did was change your root directory.  Yes, deeper.
And leave your current directory where it had been.

Now, recall that chroot does *NOT* affect the
interpretation of .. other than in the current root.

Which means that attacker doing
	chdir("/");
	chroot(some_existing_directory);
	chdir("..");
will end up outside of the original chroot environment.

This is POSIX-mandated behaviour.  Moreover, that is behaviour of
historical Unices.  Any Unix programmer who tries to use chroot(2)
should be aware of that.  Ability of making chroot(2) calls
means the ability to break out of any chroot you are currently in.

> If fchdir() and openat() have broken that it is a serious
> problem.

Have you even read the mail you'd been replying to?  Where had anything
in the example given (OK sketched out) to you upthread involve fchdir()
or openat()?
