Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78C75F2091
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 01:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJAXMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 19:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiJAXL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 19:11:57 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7EA56BA4;
        Sat,  1 Oct 2022 16:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X1NTRgt/LLeKiPRnMSo1K9lxaCir7yfIpyfoUeYt+C8=; b=nCNdgnHb9Q+82nLR89/7S+X+eU
        UtxEO0hpTW6p33qTPW5dXY8sOX3wjs3+KW4QyELPlHp6Zg6JTZG01RUv/RLy/Qgt7P2uena8oaeB2
        P8R+JlR/gKLvqYlp6b5DmuAVEPJAW4SCA7vsiy1HwgUUx/29lA7K5z5eHJLoSPsFrmko/9iL7QsNW
        25GAzUarHQCCV3C77xoYPfB9XQx4PCKhC6t54b64AzbL4ewmMi3oaMb6YC6NWFuI6u097qzc5kVLA
        KqOrsYTCYPQfQMmXaFF9Db+NXsxpINomUba0+PBlYORHWitkfstWvo/QXLTgFTEjh0qAkAYdMk7hB
        atD5OAUg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oeleA-005njp-2y;
        Sat, 01 Oct 2022 23:11:51 +0000
Date:   Sun, 2 Oct 2022 00:11:50 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Message-ID: <YzjJNnzRTiSpwXHV@ZenIV>
References: <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
 <YzYK7k3tgZy3Pwht@ZenIV>
 <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
 <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
 <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
 <87a66g25wm.fsf@email.froward.int.ebiederm.org>
 <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 09:28:31PM +0000, David Laight wrote:
> > > FWIW I'm pretty sure there a sequence involving unshare() that
> > > can get you out of a chroot - but I've not found it yet.
> > 
> > Out of a chroot is essentially just:
> > 	chdir("/");
> >         chroot("/somedir");
> >         chdir("../../../../../../../../../../../../../../../..");
> 
> A chdir() inside a chroot anchors at the base of the chroot.
> fchdir() will get you out if you have an open fd to a directory
> outside the chroot.
> The 'usual' way out requires a process outside the chroot to
> just use mvdir().
> But there isn't supposed to be a way to get out.

In order of original claims:

* chdir inside a chroot does *NOT* "anchor at the base of the chroot".
What it does is (a) start at the base if the pathname is absolute and
(b) treats .. in the base as ., same as any other syscall.

* correct.

* WTF is "mvdir()"?  Some Unices used to have mvdir(1), but it had never
been a function...  And mv(1) (or rename(2)) is far from being the only
way for assistant outside of jail to let the chrooted process out.

* ability to chroot(2) had always been equivalent to ability to undo
chroot(2).  If you want to prevent getting out of there, you need
(among other things) to prevent the processes to be confined from
further chroot(2).
