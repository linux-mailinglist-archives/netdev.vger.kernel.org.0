Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88E343CDD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhCVJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:29:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhCVJ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 05:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616405371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ZaGnE5KS4xwBu7jMSi2JEwn46rVmxazAk+HP7D3LaQ=;
        b=Hpb3c3eC8bFKGleFtYLRyG+70ZaOz+vodM+S4Hw+fNZu+QjJ7uhljT+hFsvAh1O8b7XTZU
        co58HfsJgbrhzJUQHD8HJiIgg68emZKy/y0uOIBxAhyrA6cFoZi58+o1tTX/Fsk+ggLu5b
        EJJxqgBq1uFvWtuTwGPK9zv77wc8EGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ac9IBUVVOSGaqNwj96WVzQ-1; Mon, 22 Mar 2021 05:29:24 -0400
X-MC-Unique: ac9IBUVVOSGaqNwj96WVzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B9C9A0CA3;
        Mon, 22 Mar 2021 09:29:21 +0000 (UTC)
Received: from [169.254.144.253] (ovpn-114-52.ams2.redhat.com [10.36.114.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EEA060C04;
        Mon, 22 Mar 2021 09:29:11 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "David Ahern" <dsahern@gmail.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: Re: [PATCH v7 bpf-next 10/14] bpf: add new frame_length field to the
 XDP ctx
Date:   Mon, 22 Mar 2021 10:29:10 +0100
Message-ID: <E467B3B1-4BDD-4366-A218-A60EC45C2C67@redhat.com>
In-Reply-To: <a5ff68f0-00a1-2933-f863-7e861e78cd60@gmail.com>
References: <cover.1616179034.git.lorenzo@kernel.org>
 <a31b2599948c8d8679c6454b9191e70c1c732c32.1616179034.git.lorenzo@kernel.org>
 <a5ff68f0-00a1-2933-f863-7e861e78cd60@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Mar 2021, at 4:42, David Ahern wrote:

> On 3/19/21 3:47 PM, Lorenzo Bianconi wrote:
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 19cd6642e087..e47d9e8da547 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -75,6 +75,10 @@ struct xdp_buff {
>>  	struct xdp_txq_info *txq;
>>  	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved 
>> tailroom*/
>>  	u32 mb:1; /* xdp non-linear buffer */
>> +	u32 frame_length; /* Total frame length across all buffers. Only 
>> needs
>> +			   * to be updated by helper functions, as it will be
>> +			   * initialized at XDP program start.
>> +			   */
>>  };
>>
>>  static __always_inline void
>
> If you do another version of this set ...
>
> I think you only need 17-bits for the frame length (size is always <=
> 128kB). It would be helpful for extensions to xdp if you annotated how
> many bits are really needed here.

Guess this can be done, but I did not too avoid the use of constants to 
do the BPF extraction.
Here is an example of what might need to be added, as adding them before 
made people unhappy ;)

https://elixir.bootlin.com/linux/v5.12-rc4/source/include/linux/skbuff.h#L801

