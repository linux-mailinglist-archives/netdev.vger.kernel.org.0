Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8526BF27
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgIPIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:25:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIPIZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600244749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SciDp7vow7Osmi2JbFd8Ljpt7Ueze55tLv9AQ9bbklI=;
        b=Z8iGj86n+IRmml15GPDfD1U41w5bUXKZkW9vjlkPeweTGwMELdh1eWS1Xb0EzKOGV6I7wY
        i23Dc9FcKXbtBEgUfaU3QFaShByIaGXF5zzdc7e4OpCyyR5vyIzcSAiZxkv84fjlBrYiU2
        yZFgzLMt63hjYkzmuxQPCyoInY+fCDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-4e6vjzvRNDef2aTCXru_-w-1; Wed, 16 Sep 2020 04:25:47 -0400
X-MC-Unique: 4e6vjzvRNDef2aTCXru_-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F7741084C81;
        Wed, 16 Sep 2020 08:25:46 +0000 (UTC)
Received: from ovpn-114-223.ams2.redhat.com (ovpn-114-223.ams2.redhat.com [10.36.114.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 559D75D9CA;
        Wed, 16 Sep 2020 08:25:43 +0000 (UTC)
Message-ID: <5f5aa2608856865a8b3e4dfd4195e2de31ba9762.camel@redhat.com>
Subject: Re: [PATCH] mptcp: Fix unsigned 'max_seq' compared with zero in
 mptcp_data_queue_ofo
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ye Bin <yebin10@huawei.com>, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        mptcp@lists.01.org
Cc:     Hulk Robot <hulkci@huawei.com>
Date:   Wed, 16 Sep 2020 10:25:42 +0200
In-Reply-To: <20200916033003.1186727-1-yebin10@huawei.com>
References: <20200916033003.1186727-1-yebin10@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2020-09-16 at 11:30 +0800, Ye Bin wrote:
> Fixes make coccicheck warnig:
> net/mptcp/protocol.c:164:11-18: WARNING: Unsigned expression compared with zero: max_seq > 0
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  net/mptcp/protocol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index ef0dd2f23482..3b71f6202524 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -155,13 +155,14 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
>  {
>  	struct sock *sk = (struct sock *)msk;
>  	struct rb_node **p, *parent;
> +	int space;
>  	u64 seq, end_seq, max_seq;
>  	struct sk_buff *skb1;
>  
>  	seq = MPTCP_SKB_CB(skb)->map_seq;
>  	end_seq = MPTCP_SKB_CB(skb)->end_seq;
> -	max_seq = tcp_space(sk);
> -	max_seq = max_seq > 0 ? max_seq + msk->ack_seq : msk->ack_seq;
> +	space = tcp_space(sk);
> +	max_seq = space > 0 ? space + msk->ack_seq : msk->ack_seq;
>  
>  	pr_debug("msk=%p seq=%llx limit=%llx empty=%d", msk, seq, max_seq,
>  		 RB_EMPTY_ROOT(&msk->out_of_order_queue));

The patch looks correct, but could you please add an appropriate
'Fixes' tag, and also preserve the reverse x-mas tree order for
variables declaration?

Also, this patch should likely target the net-next tree, the MPTCP OoO
queue is present only there.

Thanks!

Paolo

