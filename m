Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86E2860F3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgJGOJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728177AbgJGOJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602079748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSxnr5oZSxw62d/FMZ0Ql+J7Qi8sNVNsY4/Mdm8m/Eg=;
        b=EZWvSEayN/ExsYrvpdns0WCxcVHjTscOaj6+hf6KK7cnnAp7lnZdaHhBiEf7Um4li70mpr
        fu8DKBNYV25mLZz/xt63gLYifjf7CErntsoy3V2ejMVs5Ml+LOWdjenOJ3DmJbAZo6apv6
        jMbgHXXKNEQDE3U+ZUI0AJvKXR+um0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-qOZfnn6lN6ODH8wQj6L-SQ-1; Wed, 07 Oct 2020 10:09:04 -0400
X-MC-Unique: qOZfnn6lN6ODH8wQj6L-SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C75518A0776;
        Wed,  7 Oct 2020 14:09:03 +0000 (UTC)
Received: from ovpn-112-245.ams2.redhat.com (ovpn-112-245.ams2.redhat.com [10.36.112.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D1D55786;
        Wed,  7 Oct 2020 14:09:01 +0000 (UTC)
Message-ID: <4544483dd904540cdda04db3d2e2e70bad84efda.camel@redhat.com>
Subject: Re: [PATCH net] macsec: avoid use-after-free in
 macsec_handle_frame()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Wed, 07 Oct 2020 16:09:00 +0200
In-Reply-To: <20201007084246.4068317-1-eric.dumazet@gmail.com>
References: <20201007084246.4068317-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2020-10-07 at 01:42 -0700, Eric Dumazet wrote:
> @@ -1232,9 +1233,10 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
>  	macsec_rxsc_put(rx_sc);
>  
>  	skb_orphan(skb);
> +	len = skb->len;
>  	ret = gro_cells_receive(&macsec->gro_cells, skb);
>  	if (ret == NET_RX_SUCCESS)
> -		count_rx(dev, skb->len);
> +		count_rx(dev, len);
>  	else
>  		macsec->secy.netdev->stats.rx_dropped++;

I'm sorry I'm low on coffee, but I can't see the race?!? here we are in
a BH section, and the above code dereference the skb only if it's has
been enqueued into the gro_cells napi. It could be dequeued/dropped
only after we leave this section ?!?

Thanks,

Paolo

