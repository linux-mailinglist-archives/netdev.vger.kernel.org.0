Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F35324E273
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHUVLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUVLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:11:44 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C37C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:11:44 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f75so2276050ilh.3
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E7viQb8SsdCEZN4Lzu32OyQl36wwsE1UOqB+X+mkkRQ=;
        b=kR09GGNLz7xfMADwn2P+8ulWsSxTC4HCWzkKfFlfQUk54oVKG2VNKPymnsfBKNNVYn
         ifMqV55Qs4eiC8+SZX6YFYOIz34XZL2QMHSF312evkfztSdCRD9XNFDkt9ht5XsBVXlD
         0Ehwep5gaS2VCeVsyT33fVpAn6L4wr31o4ih3VKvFXVj8u9/ypvAX8D3ujpC68ABHLHw
         DfbNmkPPHLYQdJ1wPA2+JK75vNqsFTxFBzLWlGZGCWZ49a88ZK/RFn+rto+nGAt9x3cX
         b3wSplohnPQaqmPFHez9LTxaIzjMD6NUK3VlguS84lbED5Yise72PGhtaEqc76/lRRZ2
         p4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7viQb8SsdCEZN4Lzu32OyQl36wwsE1UOqB+X+mkkRQ=;
        b=JPxbvUJJlUBS0KKOvL+rtyBp94kHrisu9CczU4GIlnp7sIzfsU1YIeBKJjIjNFYkzm
         /NE36WodZrJKxsFh0NwMqWLfiLlc2PCzF0sc5imsm30uvXikPmUENrZOr+m23CE7ROrk
         fMGZC+5TvsJR8djKZXfW7P700GOQbbx5e0R8lwySrv9WzG0wWr1EePODp0BsQukVvIVU
         jlxo/Cux+yLJ6yNVRD4d/qxdF63T9y8/SqRIDws0G5P+P6OgEjylMFNkE/9XHTqsMjFP
         Y0NucwdyIVGbagklp69bYoTJvFkNBMvh2y+y5PS8di7i2v4aP+DtbGW+lA69S2pWyLlB
         NhbQ==
X-Gm-Message-State: AOAM5328/aeHJ9whTlyQB+f1UR+7PTq+Tq+eyZvdPgTDgrGDsNzrcnEc
        bpd1+a2pq5CczMREhcBU2YuYPA==
X-Google-Smtp-Source: ABdhPJzREuVz0nmVeYlDVpPruUVlOs6SKECbx3O1OsSS1yKc1ggs1EiJO+UOLjeyi2HzEEfxlVw+7Q==
X-Received: by 2002:a92:1b84:: with SMTP id f4mr4025017ill.180.1598044303659;
        Fri, 21 Aug 2020 14:11:43 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w9sm1855510iop.2.2020.08.21.14.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 14:11:43 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
To:     Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <luke.w.hsiao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
 <20200820234954.1784522-3-luke.w.hsiao@gmail.com>
 <20200821134144.642f6fbb@kicinski-fedora-PC1C0HJN>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0819955-6466-9c11-880d-ae607f033b84@kernel.dk>
Date:   Fri, 21 Aug 2020 15:11:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821134144.642f6fbb@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 2:41 PM, Jakub Kicinski wrote:
> On Thu, 20 Aug 2020 16:49:54 -0700 Luke Hsiao wrote:
>> +	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
>> +	if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
>> +		mask &= ~(POLLIN);
> 
> FWIW this adds another W=1 C=1 warnings to this code:
> 
> fs/io_uring.c:4940:22: warning: invalid assignment: &=
> fs/io_uring.c:4940:22:    left side has type restricted __poll_t
> fs/io_uring.c:4940:22:    right side has type int

Well, 8 or 9 of them don't really matter... This is something that should
be cleaned up separately at some point.

> And obviously the brackets around POLLIN are not necessary.

Agree, would be cleaner without!

Luke, with that:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

