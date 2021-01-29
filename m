Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1228F308D4C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhA2TXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhA2TU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:20:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5937DC061574;
        Fri, 29 Jan 2021 11:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=jSLNkuwVyP0xMPMS8CoO3sG/fvBZxEmfqtCSE6BL8r8=; b=RkqY7tOELZ3YXz96GOBYLOMRxb
        gyDC11ihSqDqrXe9dn7YJrpLiAXF0dKQwjBEF3whjWKmMj7DMtLkRhoJ59Dj7+uWNUxuaSPfIjVeX
        eKatA6T+ulDwPknAWMVTKOO46pzQ5jPkM4Bvh6BcKK8gAsy2OaVygfOyo3e0CJbXmqiDQ1E2fEYq0
        njxiLoYS268wXQNP437Uq3mC8D5snWgl5PiRxfCmOWobUKNqOxqtvcCWzN7rYHPRpZw7OrXXqxOFr
        h587GQFLaFbgUSwgHrrXAFuDObMVW6KgdpdUN7SRln+5dUNsz8/Le7/tp7fu8uIPi6pakFf93YkcQ
        bDI8isRA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5ZIx-00ADI7-3p; Fri, 29 Jan 2021 19:19:40 +0000
Date:   Fri, 29 Jan 2021 19:19:39 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129191939.GB308988@casper.infradead.org>
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 09:56:48AM -0800, Shoaib Rao wrote:
> On 1/25/21 3:36 PM, Jakub Kicinski wrote:
> > On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
> > > From: Rao Shoaib <rao.shoaib@oracle.com>
> > > 
> > > TCP sockets allow SIGURG to be sent to the process holding the other
> > > end of the socket.  Extend Unix sockets to have the same ability.
> > > 
> > > The API is the same in that the sender uses sendmsg() with MSG_OOB to
> > > raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
> > > SO_OOBINLINE set.
> > Noob question, if we only want to support the inline mode, why don't we
> > require SO_OOBINLINE to have been called on @other? Wouldn't that
> > provide more consistent behavior across address families?
> > 
> > With the current implementation the receiver will also not see MSG_OOB
> > set in msg->msg_flags, right?
> 
> SO_OOBINLINE does not control the delivery of signal, It controls how
> OOB Byte is delivered. It may not be obvious but this change does not
> deliver any Byte, just a signal. So, as long as sendmsg flag contains
> MSG_OOB, signal will be delivered just like it happens for TCP.

I don't think that's the question Jakub is asking.  As I understand it,
if you send a MSG_OOB on a TCP socket and the receiver calls recvmsg(),
it will see MSG_OOB set, even if SO_OOBINLINE is set.  That wouldn't
happen with Unix sockets.  I'm OK with that difference in behaviour,
because MSG_OOB on Unix sockets _is not_ for sending out of band data.
It's just for sending an urgent signal.

As you say, MSG_OOB does not require data to be sent for unix sockets
(unlike TCP which always requires at least one byte), but one can
choose to send data as part of a message which has MSG_OOB set.  It
won't be tagged in any special way.

To Jakub's other question, we could require SO_OOBINLINE to be set.
That'd provide another layer of insurance against applications being
surprised by a SIGURG they weren't expecting.  I don't know that it's
really worth it though.

One thing I wasn't clear about, and maybe you know, if we send a MSG_OOB,
does this patch cause this part of the tcp(7) manpage to be true for
unix sockets too?

       When out-of-band data is present, select(2) indicates the file descrip‐
       tor as having an exceptional condition and poll (2) indicates a POLLPRI
       event.

