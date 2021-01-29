Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C979308F30
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhA2VTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhA2VTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:19:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA6164E0B;
        Fri, 29 Jan 2021 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611955101;
        bh=VHlHzRIH5EHIi27EabMwPDUg0ky01z7bFjUdLYOlRts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mh81FSIvRcM6XDwtp5CiWYaOZJvZPndY44Z2EuiqXStNvajkC/B7ORppkwzKzI2hM
         H3vuhdDZXJ6grTm+qUIUZPL0nkqgCCd+29Sjk/W7sO88m69i02AVjRURwFfc/e7xY9
         CUTjHI4Ad5rH4DTAf9hkXurEoEPJMS5t7yZnZzSsIGO8CmnOnTbopyjRJOLItT5WfL
         uw/FXOK14T9e3m2JXxPB6PaiYzMSrE5Ylaizz261ru9zwI48+5DVY2ZNgqCabNi4ii
         SJ6R0w/GIl79fW0REleto8reG3GESVTwPCAzW+jB6vWEpnfdhPW1AfOYQqLO4/Eqax
         m+sZyOXM/bFZQ==
Date:   Fri, 29 Jan 2021 13:18:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
References: <20210122150638.210444-1-willy@infradead.org>
        <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
        <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
        <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
        <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 12:44:44 -0800 Shoaib Rao wrote:
> On 1/29/21 12:18 PM, Jakub Kicinski wrote:
> > On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:  
> >> The code does not care about the size of data -- All it does is that if
> >> MSG_OOB is set it will deliver the signal to the peer process
> >> irrespective of the length of the data (which can be zero length). Let's
> >> look at the code of unix_stream_sendmsg() It does the following (sent is
> >> initialized to zero)  
> > Okay. Let me try again. AFAICS your code makes it so that data sent
> > with MSG_OOB is treated like any other data. It just sends a signal.  
> Correct.
> > So you're hijacking the MSG_OOB to send a signal, because OOB also
> > sends a signal.  
> Correct.
> >   But there is nothing OOB about the data itself.  
> Correct.
> >   So
> > I'm asking you to make sure that there is no data in the message.  
> Yes I can do that.
> > That way when someone wants _actual_ OOB data on UNIX sockets they
> > can implement it without breaking backwards compatibility of the
> > kernel uAPI.  
> 
> I see what you are trying to achieve. However it may not work.
> 
> Let's assume that __actual__ OOB data has been implemented. An 
> application sends a zero length message with MSG_OOB, after that it 
> sends some data (not suppose to be OOB data). How is the receiver going 
> to differentiate if the data an OOB or not.

THB I've never written any application which would use OOB, so in
practice IDK. But from kernel code and looking at man pages when
OOBINLINE is not set for OOB data to be received MSG_OOB has to be 
set in the recv syscall.

> We could use a different flag (MSG_SIGURG) or implement the _actual_ OOB 
> data semantics (If anyone is interested in it). MSG_SIGURG could be a 
> generic flag that just sends SIGURG irrespective of the length of the data.

No idea on the SIGURG parts :)
