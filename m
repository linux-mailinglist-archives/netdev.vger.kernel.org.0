Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8CD1DE8B4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgEVOWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:22:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55729 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729399AbgEVOWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 10:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590157327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71BWtppdcXwebCN5Ch0Z8YRSm7XfIWVqPau3AvAbOvc=;
        b=cXt0E/05IjlPWftcet2odO6nCpJggPWzQOKDqPdqLuBpX47T7/CzHb0MuceBY+d13yE9Bz
        NIzKrb7H7qcr+E52T9x3XIN4Y17BwpgbG1jWoQmJzKAoVconZ6VZqKf4I7TH9MV/MdWrC5
        3JXQnXj8njuXLutrV6+qF8pB4vTTVM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-jf96Mwg5OgOS-432do0GAg-1; Fri, 22 May 2020 10:22:05 -0400
X-MC-Unique: jf96Mwg5OgOS-432do0GAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 668B71005512;
        Fri, 22 May 2020 14:22:04 +0000 (UTC)
Received: from ovpn-112-173.ams2.redhat.com (ovpn-112-173.ams2.redhat.com [10.36.112.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1CD3473A6;
        Fri, 22 May 2020 14:22:02 +0000 (UTC)
Message-ID: <c0f4e88f0a1b5449b341f2f7747a4aa7994089e7.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: adjust tcp rcvspace after moving skbs
 from ssk to sk queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com
Date:   Fri, 22 May 2020 16:22:01 +0200
In-Reply-To: <20200522124350.47615-1-fw@strlen.de>
References: <20200522124350.47615-1-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2020-05-22 at 14:43 +0200, Florian Westphal wrote:
> TCP does tcp rcvbuf tuning when copying packets to userspace, e.g. in
> tcp_read_sock().  In case of mptcp, that function is only rarely used
> (when discarding retransmitted duplicate data).
> 
> Instead, skbs are moved from the tcp rx queue to the mptcp socket rx
> queue.
> Adjust subflow rcvbuf when we do so, its the last spot where we can
> adjust the ssk rcvbuf -- later we only have the mptcp-level socket.
> 
> This greatly improves performance on mptcp bulk transfers.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/mptcp/protocol.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index ba9d3d5c625f..dbb86cbb9e77 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -248,6 +248,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
>  
>  	*bytes = moved;
>  
> +	if (moved)
> +		tcp_rcv_space_adjust(ssk);
> +
>  	return done;
>  }

It looks like this way ssk rcvbuf will grow up to tcp_rmem[2] even if
there is no user-space reader - assuming the link is fast enough.

Don't we need to somehow cap that? e.g. moving mptcp rcvbuf update in
mptcp_revmsg()?

Thanks,

Paolo


