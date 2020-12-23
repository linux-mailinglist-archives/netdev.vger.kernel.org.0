Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6262E1F9B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 17:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLWQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 11:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgLWQv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 11:51:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120EF221FC;
        Wed, 23 Dec 2020 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608742248;
        bh=uaZzfzvqXSE7/Ab1qNRkWa1GvuQzqlzwAZ/AM1dE424=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J4ioa06ySoAJ0AgEf1hKkq8GBAk9TQULI6BbXkG5Er8bk0uoZxJMVPcm2svZxuVEB
         nJSDUl6eFzDcIRAG25ZrZWyGyXnlI4cEuSPJi6/at39sxBgOrx5EZU/Og+zOGa2bNW
         aFNS8HbE99ZIcyx/cQvXQbfMD76H9e2/TLl30lLgVbRlX3eUBDkXxqgF+921F5m3eZ
         830ArJ+N00V3P4Jwoyz0BPkKdT4S/WaeyjZGL5UTkqhNwXZs0XQtAR0JrzTsK117jd
         U9uwftHJBc4pzufRHLxZ1ZECV8EHnxrOkG/qQvHCaxo48jhwjk6mWRpFqogSZuug8H
         oioM1ne0rgU8w==
Date:   Wed, 23 Dec 2020 08:50:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: continue fatal error reset after passive
 init
Message-ID: <20201223085047.402fa916@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOhMmr6c2M68fj0Mec=vhHr7krYkB8Bih-koC9o9F=0CJOCQgQ@mail.gmail.com>
References: <20201219214034.21123-1-ljp@linux.ibm.com>
        <20201222184615.13ba9cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOhMmr6c2M68fj0Mec=vhHr7krYkB8Bih-koC9o9F=0CJOCQgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 02:21:09 -0600 Lijun Pan wrote:
> On Tue, Dec 22, 2020 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sat, 19 Dec 2020 15:40:34 -0600 Lijun Pan wrote:  
> > > Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
> > > says "If the passive
> > > CRQ initialization occurs before the FATAL reset task is processed,
> > > the FATAL error reset task would try to access a CRQ message queue
> > > that was freed, causing an oops. The problem may be most likely to
> > > occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
> > > process will automatically issue a change MTU request.
> > > Fix this by not processing fatal error reset if CRQ is passively
> > > initialized after client-driven CRQ initialization fails."
> > >
> > > Even with this commit, we still see similar kernel crashes. In order
> > > to completely solve this problem, we'd better continue the fatal error
> > > reset, capture the kernel crash, and try to fix it from that end.  
> >
> > This basically reverts the quoted fix. Does the quoted fix make things
> > worse? Otherwise we should leave the code be until proper fix is found.  
> 
> Yes, I think the quoted commit makes things worse. It skips the specific
> reset condition, but that does not fix the problem it claims to fix.

Okay, let's make sure the commit message explains how it makes things
worse.

> The effective fix is upstream SHA 0e435befaea4 and a0faaa27c716. So I
> think reverting it to the original "else" condition is the right thing to do.

Hm. So the problem is fixed? But the commit message says "we still see
similar kernel crashes", that's present tense suggesting that crashes 
are seen on current net/master. Are you saying that's not the case and
after 0e435befaea4 and a0faaa27c716 there are no more crashes?
