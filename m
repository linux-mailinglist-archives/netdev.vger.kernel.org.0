Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A5426D669
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgIQIZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbgIQIZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:25:06 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:25:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600331104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFY7qj1OtOuWH1kXQsk8o2OCWIS0PKs8JFyGNsmlxe8=;
        b=EeTHCJj/0PyiKb8AYjLcZmjR8qZ+fZc1n/Kz5u7IWIKMcT0kwwp09YlJ5M8ouEInfQzUj1
        xwnUABgDlQuPtKTxSlg1G+MKSCOrDR+wGdT46Ke8ZFMWfvx+4Hon1wOZw02cw8ehcKYyjg
        BLaW42JRzSiqFRqGPUT5uaYB+2Laq9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-S5aZK6EoPYKG4ON_PHN-Cg-1; Thu, 17 Sep 2020 04:18:56 -0400
X-MC-Unique: S5aZK6EoPYKG4ON_PHN-Cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71867ADC33;
        Thu, 17 Sep 2020 08:18:54 +0000 (UTC)
Received: from ovpn-114-192.ams2.redhat.com (ovpn-114-192.ams2.redhat.com [10.36.114.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C948268D60;
        Thu, 17 Sep 2020 08:18:52 +0000 (UTC)
Message-ID: <cea6d18e823ed89270a5bb2cad9c65377b520678.camel@redhat.com>
Subject: Re: [PATCH v3] mptcp: Fix unsigned 'max_seq' compared with zero in
 mptcp_data_queue_ofo
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ye Bin <yebin10@huawei.com>, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev@vger.kernel.org
Cc:     Hulk Robot <hulkci@huawei.com>
Date:   Thu, 17 Sep 2020 10:18:51 +0200
In-Reply-To: <20200917011233.2948595-1-yebin10@huawei.com>
References: <20200917011233.2948595-1-yebin10@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 09:12 +0800, Ye Bin wrote:
> Fixes coccicheck warnig:
> net/mptcp/protocol.c:164:11-18: WARNING: Unsigned expression compared with zero: max_seq > 0
> 
> Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  net/mptcp/protocol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index ef0dd2f23482..386cd4e60250 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -157,11 +157,12 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
>  	struct rb_node **p, *parent;
>  	u64 seq, end_seq, max_seq;
>  	struct sk_buff *skb1;
> +	int space;
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

Thank you for addressing our feedback!

Acked-by: Paolo Abeni <pabeni@redhat.com>

