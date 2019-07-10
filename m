Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4178C64CBA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfGJT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:26:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34359 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfGJT0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:26:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so3689221wrm.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 12:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=egu4M3na24tJeXq4zegAC2KmIwgpLCQBLIdlTINTg5o=;
        b=glPCl7JNU4VwKzbq/4tmE0gUiHYQ80vqmkL1jiTpjpaFEZb+DAusu7+OSU40FoCCPa
         6sFXJmkpVxaj6sxG7rJZUB4oAQh1dxt8ya+cH/RHlGq0Iit52+q52NYidShDiizjLvoo
         WfAOlGs3AMg4Nvw54zexUkL/u3HltbZ6DgJev3PXdBwoxxyY2gcNZE0rSv+IAcP2qvFP
         xS/dZi8qQcCZvoUw+Yqi0r7wWCiRrvioAk5gMm86nfehc0MRz8nbUtX07/2uDm0j+yC2
         p1hz5AatCAo4LDfGsa0picAjvWPCTq1jG+NVkf8Fru3hfSHKg5NmMKPEeYu9vaFspxrs
         gpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=egu4M3na24tJeXq4zegAC2KmIwgpLCQBLIdlTINTg5o=;
        b=XK9NOvOBLItAKOnOQWUXMeV6K/QDU0jC/GdR1/bmteO85LJ80eFNgUA3QagMfjCgs2
         UwwkIahCl+e2XxhCN/T+m0jbkojLsDfaI3Vw/ws/aGnW/LcpaJpry04J6uuobb+CdEM4
         jCE0KYWV7BZNpXdKtuW9Mu9aCkEzb10/HF/dWZq/Y2dZhaRrHkMUxGEbeTWRObT10iTd
         Ow9P/sB+0a5CuWQHCWwRsQ9crkKJ5Dbx87yDiedRLQs6P2J/KTRnmGuIpMi0K/h+UHIp
         duTlEjbmHtuvyKJzeE4WV5zIRL7Iz7H5w+c5TwctF8w6tO/tTLDKBJHG65Gw6uStBvJI
         4a7A==
X-Gm-Message-State: APjAAAVa7OwiNfFbNriDiuPaVR9kK9PlxVflIN+BXNNeXWQAqvOHP0jv
        Hj9LSHdSSHe1jJFYv36Sgim9yZh+
X-Google-Smtp-Source: APXvYqxQz+DDD7FuuALCd5psEOlQ/Bhfkv4Px/+O6WwV8kZv69Q9kbcu39g92TERg+q7gsBFX1kJow==
X-Received: by 2002:a5d:6182:: with SMTP id j2mr30804588wru.275.1562786803641;
        Wed, 10 Jul 2019 12:26:43 -0700 (PDT)
Received: from [192.168.8.147] (31.172.185.81.rev.sfr.net. [81.185.172.31])
        by smtp.gmail.com with ESMTPSA id c14sm1810832wrr.56.2019.07.10.12.26.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 12:26:42 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
Date:   Wed, 10 Jul 2019 21:26:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/19 8:53 PM, Prout, Andrew - LLSC - MITLL wrote:
> 
> Our initial rollout was v4.14.130, but I reproduced it with v4.14.132 as well, reliably for the samba test and once (not reliably) with synthetic test I was trying. A patched v4.14.132 with this patch partially reverted (just the four lines from tcp_fragment deleted) passed the samba test.
> 
> The synthetic test was a pair of simple send/recv test programs under the following conditions:
> -The send socket was non-blocking
> -SO_SNDBUF set to 128KiB
> -The receiver NIC was being flooded with traffic from multiple hosts (to induce packet loss/retransmits)
> -Load was on both systems: a while(1) program spinning on each CPU core
> -The receiver was on an older unaffected kernel
> 

SO_SNDBUF to 128KB does not permit to recover from heavy losses,
since skbs needs to be allocated for retransmits.

The bug we fixed allowed remote attackers to crash all linux hosts,

I am afraid we have to enforce the real SO_SNDBUF limit, finally.

Even a cushion of 128KB per socket is dangerous, for servers with millions of TCP sockets.

You will either have to set SO_SNDBUF to higher values, or let autotuning in place.
Or revert the patches and allow attackers hit you badly.

