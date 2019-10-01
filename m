Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A8C3FEB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfJASeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:34:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38503 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfJASeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:34:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so8666912pfe.5
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oS5PW+4QnzLVAvwWJ/ZARTfHIbAcu6zQYLL5Cfd0X+c=;
        b=DKfHvNc5dvmwx+BzC8PdJnMdYttIzyqjhfpbeE/1YDPBCr+uqGHclt29bb4e2fzQPB
         UY7mtfWB8eizlf7wwHcIFz3TxIztCqYqyCLyjdtpqGiBQ5/VHjTnpjCRe/VHLgTBGIDC
         qK2OVydwf6RK5Yk+SrK6AhN4/+ige68KlUeLZGAEGopYHU3Jf82BlkXQB/Jy6ClyXNyW
         mAl8To9i06UXmbdu8SmrbnFvhr9tXJPpJLXM3+VjpnJhtZpXrjEXeW5jhMcv8YbEtQyq
         bvFMQjjV+MVfjegYk6hXszBIlBdtKSYv3Cdzw9w45fSNaX9He7zyRvfnqrjtNNHQhtMA
         jo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oS5PW+4QnzLVAvwWJ/ZARTfHIbAcu6zQYLL5Cfd0X+c=;
        b=ianu36qOYwyPJFLOqOCdMedMAEbq8vL29I0CAHM4OAXFsggtQ/BJga9o+i1tA7XfNI
         NzsFHFKhAS5+ebFJOHUUap1KqyMgS/u3il+6UthllBhsQv5ClWVXaZKAGw4IkgWBLsIG
         i2VtVeVMu0OSB8lOEPVk+3DpAzq3gUygj33ASJGYlihzqwwyli+JSg/4zBZy189wy8OM
         bhOzVYyTLGCJ4o6UrsFZQzfCcVaYUH8DwY7cQIOQq/jlpdZ9tlc++7EMba0KTkNNJ483
         Os+hCRklYty6qZjq5aQvJ4n+XH1NI88G82eNpxC3ic2iS8Nayffpfg5YQH6WEHJ9NfC4
         3KYw==
X-Gm-Message-State: APjAAAUGRTkYa4IWYCxfxnBu6SxIJW8Ox5T9aKoGmj2Tu0jrlzPzZb7/
        uc5UP2vsmvA72FP4YfU7OpCeIdML
X-Google-Smtp-Source: APXvYqzhQt3cSfpcT8X6r3zR2sAEZBjLs1gtaRpPmmXXhNjeD7g8VI0+VDyucU6fzBgiohWoLST1lw==
X-Received: by 2002:aa7:858c:: with SMTP id w12mr29580788pfn.113.1569954858082;
        Tue, 01 Oct 2019 11:34:18 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id f74sm20499901pfa.34.2019.10.01.11.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:34:17 -0700 (PDT)
Subject: Re: BUG: sk_backlog.len can overestimate
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     netdev@vger.kernel.org
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
 <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
 <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
 <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com>
 <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <47fef079-635d-483e-b530-943b2a55fc22@gmail.com>
Date:   Tue, 1 Oct 2019 11:34:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 10:25 AM, John Ousterhout wrote:
> On Tue, Oct 1, 2019 at 9:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> ...
>> Sorry, I have no idea what is the problem you see.
> 
> OK, let me try again from the start. Consider two values:
> * sk->sk_backlog.len
> * The actual number of bytes in buffers in the current backlog list
> 
> Now consider a series of propositions:
> 
> 1. These two are not always the same. As packets get processed by
> calling sk_backlog_rcv, they are removed from the backlog list, so the
> actual amount of memory consumed by the backlog list drops. However,
> sk->sk_backlog.len doesn't change until the entire backlog is cleared,
> at which point it is reset to zero. So, there can be periods of time
> where sk->sk_backlog.len overstates the actual memory consumption of
> the backlog.

Yes, this is done on purpose (and documented in __release_sock()

Otherwise you could have a livelock situation, with user thread being
trapped forever in system, and never return to user land.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8eae939f1400326b06d0c9afe53d2a484a326871


> 
> 2. The gap between sk->sk_backlog.len and actual backlog size can grow
> quite large. This happens if new packets arrive while sk_backlog_rcv
> is working. The socket is locked, so these new packets will be added
> to the backlog, which will increase sk->sk_backlog_len. Under high
> load, this could continue indefinitely: packets keep arriving, so the
> backlog never empties, so sk->sk_backlog_len never gets reset.
> However, packets are actually being processed from the backlog, so
> it's possible that the actual size of the backlog isn't changing, yet
> sk->sk_backlog.len continues to grow.
> 
> 3. Eventually, the growth in sk->sk_backlog.len will be limited by the
> "limit" argument to sk_add_backlog. When this happens, packets will be
> dropped.

_Exactly_ WAI

> 
> 4. Now suppose I pass a value of 1000000 as the limit to
> sk_add_backlog. It's possible that sk_add_backlog will reject my
> request even though the backlog only contains a total of 10000 bytes.
> The other 990000 bytes were present on the backlog at one time (though
> not necessarily all at the same time), but they have been processed
> and removed; __release_sock hasn't gotten around to updating
> sk->sk_backlog.len, because it hasn't been able to completely clear
> the backlog.

WAI

> 
> 5. Bottom line: under high load, a socket can be forced to drop
> packets even though it never actually exceeded its memory budget. This
> isn't a case of a sender trying to fool us; we fooled ourselves,
> because of the delay in resetting sk->sk_backlog.len.
> 
> Does this make sense?

Yes, just increase your socket limits. setsockopt(...  SO_RCVBUF ...),
and risk user threads having bigger socket syscall latencies, obviously.

> 
> By the way, I have actually observed this phenomenon in an
> implementation of the Homa transport protocol.
> 

Maybe this transport protocol should size correctly its sockets limits :)
