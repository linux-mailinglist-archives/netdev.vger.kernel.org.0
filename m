Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C813012065C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfLPMwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:52:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22735 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727553AbfLPMwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576500740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zPVhi8m4az+66WjE69dbm65uff7xS22TNy+E1MZ9t4o=;
        b=JYFgAbDpOHobqcGzmseZ7Mm5/haai9RkzfJCUDobZ9cEI5TTWYeU8gX+2qhas1FPj8tc7G
        q0eBDdDU0EBbYkAkQYhqcRxp24BMdEjaNUJqOoca59Ba5O0RrNUOUtA28kuFK4FV+tmTm0
        qcpLk5dJhlk2+wFtRUqRelyRZ9EPGA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-vkdXEzJ0N42gvEsbQRRYeQ-1; Mon, 16 Dec 2019 07:52:15 -0500
X-MC-Unique: vkdXEzJ0N42gvEsbQRRYeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 736C5107ACCD;
        Mon, 16 Dec 2019 12:52:14 +0000 (UTC)
Received: from ovpn-118-91.ams2.redhat.com (unknown [10.36.118.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6174E6046C;
        Mon, 16 Dec 2019 12:52:13 +0000 (UTC)
Message-ID: <b9833b748f61c043a2827daee060d4ad4171996e.camel@redhat.com>
Subject: Re: [MPTCP] Re: [PATCH net-next 09/11] tcp: Check for filled TCP
 option space before SACK
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Mon, 16 Dec 2019 13:52:12 +0100
In-Reply-To: <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
         <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
         <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2019-12-13 at 15:22 -0800, Eric Dumazet wrote:
> 
> On 12/13/19 3:00 PM, Mat Martineau wrote:
> > The SACK code would potentially add four bytes to the expected
> > TCP option size even if all option space was already used.
> > 
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> >  net/ipv4/tcp_output.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 9e04d45bc0e4..710ab45badfa 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -748,6 +748,9 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
> >  		size += TCPOLEN_TSTAMP_ALIGNED;
> >  	}
> >  
> > +	if (size + TCPOLEN_SACK_BASE_ALIGNED >= MAX_TCP_OPTION_SPACE)
> > +		return size;
> > +
> >  	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
> >  	if (unlikely(eff_sacks)) {
> >  		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> > 
> 
> Hmmm... I thought I already fixed this issue ?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9424e2e7ad93ffffa88f882c9bc5023570904b55
> 
> Please do not mix fixes (targeting net tree) in a patch series targeting net-next

Thank you for the feedback!

Unfortunatelly, the above commit is not enough when MPTCP is enabled,
as, without this patch, we can reach the following code:

		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
		opts->num_sack_blocks =
			min_t(unsigned int, eff_sacks,
			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
			      TCPOLEN_SACK_PERBLOCK);

with 'size == MAX_TCP_OPTION_SPACE' and num_sack_blocks will be
miscalculated. So we need 'fix' but only for MPTCP/when MPTCP is
enabled. Still ok for a -net commit?

Additionally we can clean-up the fix a bit, using something alike the
following, so that it will never add an additional branching
istruction.

---
+               if (unlikely(remaining < TCPOLEN_SACK_BASE_ALIGNED +
+                                        TCPOLEN_SACK_PERBLOCK))
+                       return size;
+
                opts->num_sack_blocks =
                        min_t(unsigned int, eff_sacks,
                              (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
                              TCPOLEN_SACK_PERBLOCK);
-               if (likely(opts->num_sack_blocks))
-                       size += TCPOLEN_SACK_BASE_ALIGNED +
-                               opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+
+               size += TCPOLEN_SACK_BASE_ALIGNED +
+                       opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
---

Thank you!

Paolo

