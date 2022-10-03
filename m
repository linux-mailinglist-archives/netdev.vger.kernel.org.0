Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295635F35DB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJCStz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJCStw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:49:52 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEE411C2E;
        Mon,  3 Oct 2022 11:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IAvqa5x9nRr4IxkadbeJkMJoDAJK9hkHOonDIrpKsm4=; b=oMJgotqgdOpZdI31QpLNbFK5xd
        Z0BddkVUPxM6xEueI6LuXJENmAeoNA+L1hR+JYk0TbydBSV3cNDFhmaRD6VGBAC8z650gpgWB3mq3
        kXNiIzsbinI/e/EtPbEhgpmnG9/9AojV3ewL8d2Jr0hexjNsNdIRZyf5T0v/mqN55aCUPdhC4yem5
        QnlGTGQLo3xiX1TOHDXRnGVNMv9q0nuniIhSh1fUCbejld0VEszSp3IDvGk0N8cBoOBHZA8HeFqSm
        jcyTG5F/PVrFf6MAzHCIZ+ZC0X5xiC4cfXAIEXHgDN/DbGhKo5yVbAZaBVi2kLjenDjZ4WssKKMZJ
        SiqKDDEQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ofQVX-006YU5-39;
        Mon, 03 Oct 2022 18:49:40 +0000
Date:   Mon, 3 Oct 2022 19:49:39 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Message-ID: <Yzsuw9OvF22d5sDx@ZenIV>
References: <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
 <YzYK7k3tgZy3Pwht@ZenIV>
 <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
 <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
 <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
 <87a66g25wm.fsf@email.froward.int.ebiederm.org>
 <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
 <87fsg4ygxc.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsg4ygxc.fsf@email.froward.int.ebiederm.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,URIBL_ABUSE_SURBL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 12:07:27PM -0500, Eric W. Biederman wrote:

> > fchdir() will get you out if you have an open fd to a directory
> > outside the chroot.
> > The 'usual' way out requires a process outside the chroot to
> > just use mvdir().
> > But there isn't supposed to be a way to get out.
> 
> As I recall the history chroot was a quick hack to allow building a
> building against a different version of the binaries than were currently
> installed.  It was not built as a security feature.

A last-moment prerelease hack in v7, by the look of it; at that point it
hadn't even tried to modify ".." behaviour in the directory you'd been
chrooted into - just modified the starting point for resolving absolute pathnames.

Not even token attempts of confinement until 1982 commit by Bill Joy,
during one of the namei rewrites.  No idea how when non-BSD branches
had picked that.

At no point did chroot(2) switch the current directory.  fchdir(2) doesn't
add anything to the situation when
	chdir("/");
	chroot("some_directory");
	chdir("../../../../../../../..");
	chroot(".");
will break you out of it nicely.

Again, chroot(2) had never been intended to be root-resistant; there's
a reason why "drop elevated priveleges right after chrooting" is
in all kinds of UNIX FAQs (very likely in Stevens et.al. as well -
I don't have the relevant volume in front of me, but it's certainly
something covered in textbooks).

chroot(2) can be useful in confining processes, but you need to be
really careful about the ways you use it.
