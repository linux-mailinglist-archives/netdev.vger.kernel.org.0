Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA8E64D5C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 22:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfGJUP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 16:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfGJUP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 16:15:56 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DEC2064A;
        Wed, 10 Jul 2019 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562789755;
        bh=d8p0JYHfjRjXCVvf33vPI8tBHS7ZguMC3ng9NlE0nYY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=B79NOjOoFHWoAh1IFHtmv0W/AdIVfj3yAtV1dT439vAJ5XjuCayhazs+9diiDL84k
         BQDDmFpO8yiQ6FndhE4UI+gljpIgpr1BP9qH4K3fMPU3Pr/wGzHtlz+rrEzBZcz1n9
         X0eFfUq+iOLf9NETlrEVBNDhiQdaILJjx7y5cU7I=
Date:   Wed, 10 Jul 2019 13:15:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
Message-ID: <20190710201552.GB83443@gmail.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
References: <28477.1562362239@warthog.procyon.org.uk>
 <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
 <20190710194620.GA83443@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710194620.GA83443@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 12:46:22PM -0700, Eric Biggers wrote:
> On Wed, Jul 10, 2019 at 11:35:07AM -0700, Linus Torvalds wrote:
> > On Fri, Jul 5, 2019 at 2:30 PM David Howells <dhowells@redhat.com> wrote:
> > >
> > > Here's my fourth block of keyrings changes for the next merge window.  They
> > > change the permissions model used by keys and keyrings to be based on an
> > > internal ACL by the following means:
> > 
> > It turns out that this is broken, and I'll probably have to revert the
> > merge entirely.
> > 
> > With this merge in place, I can't boot any of the machines that have
> > an encrypted disk setup. The boot just stops at
> > 
> >   systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
> >   systemd[1]: Reached target Paths.
> > 
> > and never gets any further. I never get the prompt for a passphrase
> > for the disk encryption.
> > 
> > Apparently not a lot of developers are using encrypted volumes for
> > their development machines.
> > 
> > I'm not sure if the only requirement is an encrypted volume, or if
> > this is also particular to a F30 install in case you need to be able
> > to reproduce. But considering that you have a redhat email address,
> > I'm sure you can find a F30 install somewhere with an encrypted disk.
> > 
> > David, if you can fix this quickly, I'll hold off on the revert of it
> > all, but I can wait only so long. I've stopped merging stuff since I
> > noticed my machines don't work (this merge window has not been
> > pleasant so far - in addition to this issue I had another entirely
> > unrelated boot failure which made bisecting this one even more fun).
> > 
> > So if I don't see a quick fix, I'll just revert in order to then
> > continue to do pull requests later today. Because I do not want to do
> > further pulls with something that I can't boot as a base.
> > 
> >                  Linus
> 
> This also broke 'keyctl new_session' and hence all the fscrypt tests
> (https://lkml.kernel.org/lkml/20190710011559.GA7973@sol.localdomain/), and it
> also broke loading in-kernel X.509 certificates
> (https://lore.kernel.org/lkml/27671.1562384658@turing-police/T/#u).
> 
> I'm *guessing* these are all some underlying issue where keyrings aren't being
> given all the needed permissions anymore.
> 
> But just FYI, David had said he's on vacation with no laptop or email access for
> 2 weeks starting from Sunday (3 days ago).  So I don't think you can expect a
> quick fix from him.
> 
> I was planning to look into this to fix the fscrypt tests, but it might be a few
> days before I get to it.  And while I'm *guessing* it will be a simple fix, it
> might not be.  So I can't speak for David, but personally I'm fine with the
> commits being reverted for now.
> 
> I'm also unhappy that the new keyctl KEYCTL_GRANT_PERMISSION doesn't have any
> documentation or tests.  (Which seems to be a common problem with David's
> work...  None of the new mount syscalls in v5.2 have any tests, for example, and
> the man pages are still work-in-progress and last sent out for review a year
> ago, despite API changes that occurred before the syscalls were merged.)
> 

Also worth noting that the key ACL patches were only in linux-next for 9 days
before the pull request was sent.  The X.509 certificate loading bug (which
might be the same underlying bug) was reported on July 6 by someone testing
linux-next, but the pull request had already been sent on July 5.  I suspect
these bug(s) would have been fixed if they had been in linux-next for longer.

- Eric
