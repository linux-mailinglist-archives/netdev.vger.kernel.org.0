Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0E308F7E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhA2VdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhA2VdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 16:33:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A75C061573;
        Fri, 29 Jan 2021 13:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K3MnR5Heh//yU4kSv2PTGpHsEI35EZwif/E8uQMQaZQ=; b=L4h9RGksrAdq8tWhBPl70ELcS3
        JVNO4Dp1ZxZ81ljkDQVgl+shIWM4IwnzUMd50Eq8+59QbfPXzQaR27qzFrezt2hFJseaBipDfgWi6
        7/YREy2gWQ/9GD4Czf4bOOn0qeSDqrEMDmTJDrDo50gdDudUA4bGh9oPwR9HAAbDwREgYTHRrcwsr
        949a5pAIuOrO2IDV+Chdd58/tXAgT0rgRT4BjI8LrGdTPxXJ/cmgs+JCLbWAr9f8csjJgVnLVTAiz
        pSZLD9UbS78EcIZ0mO87x6jRFvEx/MZyS8lW2EKZMpCEGGrQTnNeo0UW5w6xqS7jlbTqR8UHdNU/k
        b4uQ7sFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5bNJ-00AMNp-9h; Fri, 29 Jan 2021 21:32:17 +0000
Date:   Fri, 29 Jan 2021 21:32:17 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shoaib Rao <rao.shoaib@oracle.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129213217.GD308988@casper.infradead.org>
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
 <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
 <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
 <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 01:18:20PM -0800, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 12:44:44 -0800 Shoaib Rao wrote:
> > On 1/29/21 12:18 PM, Jakub Kicinski wrote:
> > > On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:  
> > >> The code does not care about the size of data -- All it does is that if
> > >> MSG_OOB is set it will deliver the signal to the peer process
> > >> irrespective of the length of the data (which can be zero length). Let's
> > >> look at the code of unix_stream_sendmsg() It does the following (sent is
> > >> initialized to zero)  
> > > Okay. Let me try again. AFAICS your code makes it so that data sent
> > > with MSG_OOB is treated like any other data. It just sends a signal.  
> > Correct.
> > > So you're hijacking the MSG_OOB to send a signal, because OOB also
> > > sends a signal.  
> > Correct.
> > >   But there is nothing OOB about the data itself.  
> > Correct.
> > >   So
> > > I'm asking you to make sure that there is no data in the message.  
> > Yes I can do that.
> > > That way when someone wants _actual_ OOB data on UNIX sockets they
> > > can implement it without breaking backwards compatibility of the
> > > kernel uAPI.  
> > 
> > I see what you are trying to achieve. However it may not work.
> > 
> > Let's assume that __actual__ OOB data has been implemented. An 
> > application sends a zero length message with MSG_OOB, after that it 
> > sends some data (not suppose to be OOB data). How is the receiver going 
> > to differentiate if the data an OOB or not.
> 
> THB I've never written any application which would use OOB, so in
> practice IDK. But from kernel code and looking at man pages when
> OOBINLINE is not set for OOB data to be received MSG_OOB has to be 
> set in the recv syscall.

I'd encourage anyone thinking about "using OOB" to read
https://tools.ietf.org/html/rfc6093 first.  Basically, TCP does not
actually provide an OOB mechanism, and frankly Unix sockets shouldn't
try either.

As an aside, we should probably remove the net.ipv4.tcp_stdurg sysctl
since it's broken.

   Some operating systems provide a system-wide toggle to override this
   behavior and interpret the semantics of the Urgent Pointer as
   clarified in RFC 1122.  However, this system-wide toggle has been
   found to be inconsistent.  For example, Linux provides the sysctl
   "tcp_stdurg" (i.e., net.ipv4.tcp_stdurg) that, when set, supposedly
   changes the system behavior to interpret the semantics of the TCP
   Urgent Pointer as specified in RFC 1122. However, this sysctl changes
   the semantics of the Urgent Pointer only for incoming segments (i.e.,
   not for outgoing segments).  This means that if this sysctl is set,
   an application might be unable to interoperate with itself if both
   the TCP sender and the TCP receiver are running on the same host.

> > We could use a different flag (MSG_SIGURG) or implement the _actual_ OOB 
> > data semantics (If anyone is interested in it). MSG_SIGURG could be a 
> > generic flag that just sends SIGURG irrespective of the length of the data.
> 
> No idea on the SIGURG parts :)

If we were going to do something different from TCP sockets to generate
a remote SIGURG, then it would ideally be an entirely different mechanism
(eg a fcntl()) that could also be implemented by pipes.

But I think it's worth just saying "MSG_OOB on Unix sockets generates a
signal on the remote end, just like it does on TCP sockets.  Unix sockets
do not actually support OOB data and behave like TCP sockets with
SO_OOBINLINE set as recommended in RFC 6093".
