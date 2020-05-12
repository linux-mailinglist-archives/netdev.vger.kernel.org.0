Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1ED1CF89D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgELPJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:09:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgELPJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589296179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0o05ftdfGi3jgvgFz4aRikpwOB4tUo1/ABEAcO3TpF8=;
        b=SqW08O8jbIjgg8LRJ2rvhDzd7X9RHljek217hhW5fqmSLMjr1J/W3F7mJsTMZ5ExAcESZF
        jod0+Y9KEkeK5qvkp/HGPPlgcqZin6JB/0GfoXW0K3QDhg664SrYXL8SJ8UXK353a7nkDX
        UTuAlqineXZObqLrKF7+xvIFAjlS7e4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-qSGcD_pjNKyYlwhv_ukplg-1; Tue, 12 May 2020 11:09:35 -0400
X-MC-Unique: qSGcD_pjNKyYlwhv_ukplg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 949B61841920;
        Tue, 12 May 2020 15:09:34 +0000 (UTC)
Received: from ovpn-115-10.ams2.redhat.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5738D60BF1;
        Tue, 12 May 2020 15:09:33 +0000 (UTC)
Message-ID: <abd13fe18a4c74f5d8fbdc1508dd42818ff3bd33.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] mptcp: add new sock flag to deal with join
 subflows
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Date:   Tue, 12 May 2020 17:09:32 +0200
In-Reply-To: <CANn89iLyoaduBmtVWo4bSxebGwBOQFbfYbnRAmVzCTQ3Lx-PsQ@mail.gmail.com>
References: <cover.1589280857.git.pabeni@redhat.com>
         <81c3f2f857c2e68e22f8e8b077410ffd2960a29f.1589280857.git.pabeni@redhat.com>
         <CANn89iLyoaduBmtVWo4bSxebGwBOQFbfYbnRAmVzCTQ3Lx-PsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2020-05-12 at 07:46 -0700, Eric Dumazet wrote:
> On Tue, May 12, 2020 at 7:11 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > MP_JOIN subflows must not land into the accept queue.
> > Currently tcp_check_req() calls an mptcp specific helper
> > to detect such scenario.
> > 
> > Such helper leverages the subflow context to check for
> > MP_JOIN subflows. We need to deal also with MP JOIN
> > failures, even when the subflow context is not available
> > due to allocation failure.
> > 
> > A possible solution would be changing the syn_recv_sock()
> > signature to allow returning a more descriptive action/
> > error code and deal with that in tcp_check_req().
> > 
> > Since the above need is MPTCP specific, this patch instead
> > uses a TCP socket hole to add an MPTCP specific flag.
> > Such flag is used by the MPTCP syn_recv_sock() to tell
> > tcp_check_req() how to deal with the request socket.
> > 
> > This change is a no-op for !MPTCP build, and makes the
> > MPTCP code simpler. It allows also the next patch to deal
> > correctly with MP JOIN failure.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/linux/tcp.h      |  1 +
> >  include/net/mptcp.h      | 17 ++++++++++-------
> >  net/ipv4/tcp_minisocks.c |  2 +-
> >  net/mptcp/protocol.c     |  7 -------
> >  net/mptcp/subflow.c      |  2 ++
> >  5 files changed, 14 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index e60db06ec28d..dc12c59db41e 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -385,6 +385,7 @@ struct tcp_sock {
> >                            */
> >  #if IS_ENABLED(CONFIG_MPTCP)
> >         bool    is_mptcp;
> > +       bool    drop_req;
> >  #endif
> 
> This looks like this should only be needed in struct tcp_request_sock ?
> 
> Does this information need to be kept in the TCP socket after accept() ?

Thank you for the feedback, indeed you are right! this should be moved
inside tcp_request_sock. We still have 2 bytes hole there. I will keep
the flag under a CONFIG_MPTCP conditional.

Would you be ok with such approach, or do you think we should look for
some other schema (like the alternative mentioned in the cover letter)?

Cheers,

Paolo


