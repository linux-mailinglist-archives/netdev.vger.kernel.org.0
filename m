Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4745EFD80
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiI2TAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiI2TAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:00:12 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291D03B728;
        Thu, 29 Sep 2022 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QMuAN0wsOUSzkfO4ifudVZve/T+9KNGC8XhksyjvE7c=; b=akp2WwC12AkifHDHPS9bJr/bCc
        6web6xRg/Ku30vuzb/wyQnnu5HJecmukqMzdJASkno7uzDEUcsLl8cRH2Hu8xmyWjLij9B4aW/V2I
        Ne45O0Iyiq0NLPeL6Y5JxO8AIfo8MOd6s5yK2qGKLhiYdfnZRhw6H241vU30dUJJSGw0/4q7Ax1bS
        gdEn90KYqhTIQKC/+xriXOGro36sX7125JI687roWBrGym800N8qx5Nwqv64XqFPXtirv7bCoiJH3
        dAfE8+J7BtFvznMbbAGTqDY/GD951rFx9JnQNXoyjIZS5xae94ze/+wuHxR3PdeFhdWky2/EDwd06
        CEQqmYIQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1odylU-0054Ja-1B;
        Thu, 29 Sep 2022 19:00:08 +0000
Date:   Thu, 29 Sep 2022 20:00:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzXrOFpPStEwZH/O@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzXo/DIwq65ypHNH@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:50:36PM +0100, Al Viro wrote:
> >   https://lore.kernel.org/all/CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com/
> > 
> > in case anybody cares.
> > 
> > I wonder if the fix is to replace the symlink with a hardcoded lookup
> > (ie basically make it *act* like a hardlink - we don't really support
> > hardlinked directories, but we could basically fake the lookup in
> > proc). Since the problem was AppArmor reacting to the name in the
> > symlink.
> > 
> > Al added the participants so that he can say "hell no".
> 
> What do you mean?  Lookup on "net" in /proc returning what, exactly?
> What would that dentry have for ->d_parent?

Looking at that thread, it seems that <censored> "policy" would not be
satisfied with anything other than /proc/*/task/*/net being seen
as /proc/<something>/net.  As in "cd there and /bin/pwd will tell you
tha you are in /proc/<some number>/net".

Which is insane, especially since the entire problem is due to wanting
that directory to be different for different threads...
