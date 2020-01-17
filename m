Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBCB14103A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgAQRvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:51:54 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43610 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQRvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:51:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so10133459pli.10
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogZZw9cGP43NAH71MduMBMD2Lu6DygRhtQl+NTZ7djc=;
        b=EFkLCw8TrJAaes2D1C8nBgOBqQejvK1P0UbJg1bHFnr6j17TAsd1QBmebS7t6ZCvTO
         Ij7EovLFYaUnYIJDUWxeH1LlAw5rCFkm0H9mPgNGU/IUn7WIT/hUkmJgiml6FXtkXP17
         6qiGwB8F5nJM7YURrJ+5QHqnr4tFztt32mfNRjE4r1Xd5U0yngLBuaddnXJvYFLfAkD7
         NMEDIDcsUPyTSJ/Q7lygjb0XNN5B2vUhu+/lqD10HlRT9ft9u11N8WT5GPTPyo2OPMFy
         3MscKtnKokjMKfDCwOUX8MM4U3VfSOEHSbfaALwhPjg6iLcAbqnnVpQ+f0T6i6MBWzTB
         zR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogZZw9cGP43NAH71MduMBMD2Lu6DygRhtQl+NTZ7djc=;
        b=AJTuuQ+r9H0+RtpciooSgvjZ43F6R7Gjq/PT3dpDXVxDHZKHh2tAy2+ZTx54MV89hZ
         oawzfH/M54kgeAfKpcC5MORiPTrI0Z5Be090PcUVovSaAm4P6n+XcI8ZmGwqumTrUkUq
         UxDuyXs+RI/R32c0gMxJu1wMKLEVuhWpEe/u/Evq9PHF1bLsoxJTVX13GF6/1nnxZQaK
         zwbbG1b1xSqgko84u/WuT0chzD/ecufMOU/Zp6jFW6lRdLz0U18aEdj+4W0F+P3u3rEq
         g/jNEwjAGiPpmimrBEiYpR46uCy8+QydmzQ75DoR1ibUHSCnPRqSBnwyAEdbsvvxkJTQ
         DSHg==
X-Gm-Message-State: APjAAAVC7J2/CPExjYQvBZ1Z11ZH/pZO7LXPN2FV0vKHU8WsTalz5YoJ
        rXmPbU6NskcSER7FbqpkPLhDqGaG
X-Google-Smtp-Source: APXvYqzps3xdDAL5ZlSLRiSYAd6LE+EfHnzCOo18UA01LjRzXuQBUsWM5IMt57oHeJ+sjMfclPOIAQ==
X-Received: by 2002:a17:902:aa45:: with SMTP id c5mr182943plr.305.1579283513191;
        Fri, 17 Jan 2020 09:51:53 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l21sm30062123pff.100.2020.01.17.09.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 09:51:52 -0800 (PST)
Subject: Re: [PATCH net 3/3] udp: avoid bulk memory scheduling on memory
 pressure.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1579281705.git.pabeni@redhat.com>
 <749f8a12b2caf634249e7590597f0c53e5b37c7a.1579281705.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e1417ad9-8c2f-7640-4bed-96aa753f28f3@gmail.com>
Date:   Fri, 17 Jan 2020 09:51:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <749f8a12b2caf634249e7590597f0c53e5b37c7a.1579281705.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 9:27 AM, Paolo Abeni wrote:
> Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
> free even if the rx sk queue is empty") the memory allocated by
> an almost idle system with many UDP sockets can grow a lot.
> 
> This change addresses the issue enabling memory pressure tracking
> for UDP and flushing the fwd allocated memory on dequeue if the
> UDP protocol is under memory pressure.
> 
> Note that with this patch applied, the system allocates more
> liberally memory for UDP sockets while the total memory usage is
> below udp_mem[1], while the vanilla kernel would allow at most a
> single page per socket when UDP memory usage goes above udp_mem[0]
> - see __sk_mem_raise_allocated().
> 
> Reported-and-diagnosed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Fixes: commit 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")

Not a proper Fixes: tag

Frankly I would rather revert this patch, unless you show how much things were improved.

Where in the UDP code the forward allocations will be released while udp_memory_pressure
is hit ?

TCP has many calls to sk_mem_reclaim() and sk_mem_reclaim_partial() to try
to gracefully exit memory pressure.

