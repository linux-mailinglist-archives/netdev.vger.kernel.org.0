Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E8616A3A7
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 11:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgBXKPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 05:15:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726838AbgBXKPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 05:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582539309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uq/BjiAx9rln5X749vVgGEokQDXDHL0V/ipX5La29U4=;
        b=TrOFy+gPL/KrLHDqA0GxSfEKFtjrOG5gf6LSlF0XtwC8mYTUfU+1JWblfWHUJXkXT95Zfy
        2yAX0vF3ZXbxkg0xhg6Nw37Oj/L+qIf9k4vRaBK4EDDMAcdC/cs1akuJPPcCVO10afZmVG
        nzTzAYjU57j9UxBBf/zryfw2LnbBqgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-_PEoqoY_PZOpOSGQDtqRVQ-1; Mon, 24 Feb 2020 05:15:05 -0500
X-MC-Unique: _PEoqoY_PZOpOSGQDtqRVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EB7418A5502;
        Mon, 24 Feb 2020 10:15:04 +0000 (UTC)
Received: from ovpn-117-199.ams2.redhat.com (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A991909EA;
        Mon, 24 Feb 2020 10:15:03 +0000 (UTC)
Message-ID: <2c18fad07d0e303557185aa760ba37688191eaa3.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] unix: Show number of pending scm files
 of receive queue in fdinfo
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Feb 2020 11:15:02 +0100
In-Reply-To: <157588582628.223723.6787992203555637280.stgit () localhost ! localdomain>
References: <157588582628.223723.6787992203555637280.stgit () localhost ! localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2019-12-09 at 10:03 +0000, Kirill Tkhai wrote:
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 3426d6dacc45..17e10fba2152 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -41,6 +41,10 @@ struct unix_skb_parms {
>  	u32			consumed;
>  } __randomize_layout;
>  
> +struct scm_stat {
> +	u32 nr_fds;
> +};
> +

I'd like to drop the 'destructor' argument from
__skb_try_recv_datagram() and friends - that will both clean-up the
datagram code a bit and will avoid an indirect call in fast-path.

unix_dgram_recvmsg() needs special care: with the proposed change
scm_stat_del() will be called explicitly after _skb_try_recv_datagram()
while 'nr_fds' must to be updated under the receive queue lock.

Any of the following should work:
- change 'nr_fds' to an atomic type, and drop all lockdep stuff
- acquire again the receive queue spinlock before calling
scm_stat_del(), ev doing that only 'if UNIXCB(skb).fp'
- open code a variant of __skb_try_recv_datagram() which will take care
of scm_stat_del() under the receive queue lock.

Do you have any preferences? If you don't plan to add more fields to
'struct scm_stat' I would go for the first option.

Thanks!

Paolo

