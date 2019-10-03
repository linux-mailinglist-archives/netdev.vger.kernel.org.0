Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47085C9CE9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 13:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfJCLMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 07:12:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46286 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfJCLMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 07:12:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so1509450pfg.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 04:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+xbsVkJfa3AQnKRhG+LiubAwMs4Q0ikFes2ZWjtVOQ=;
        b=tfj4BDG+wXNlkpfikxg43syj2Ib7mpngqB2U4xHehHkDCtoPRDKQ+gHz+WUQrFR8tc
         0dtNk7BHJ5TBYm9oikXeQ2XaIq3PGencloFny1RgMfNBVYIBg+DjwIvemPZ5GCIMgjJK
         qQi5zLigO/64r9PbVQIYxFp5B3ttQIykHuudfGtWlJW84h7AGF8RLPOBiYPlHCBfzkty
         exmQkNSroiPSmxlOUwBmlUAOUc0EoA1zgWy4zrTdDS9zVRM5LUknTokL5u0HmaouMam4
         ZbO+r4pr27z+M4rTq5mM+iVkLOdhGxuS4L4iT1KkpR5K4GXG7qnCv4qRP5ggV/zPmUbJ
         bKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+xbsVkJfa3AQnKRhG+LiubAwMs4Q0ikFes2ZWjtVOQ=;
        b=pmDH19SwHlLR+ApGFcAtYDGyvQbCYNrf6dTXiw4cuC7bx0+ZhQsgkkf27B9eWQIshO
         E+Dh5hyHYXMfBHqYkoXqNawOZ0lXCdOhofT0ifbax1E/3CStPGeu1Q0TPcpd5n2NYnFM
         V9FCXf0unSJPV68PqcZIe1eFGbgEFbz49CWOrHo/pUGLYrCUTNn50zstHi9tnVn4Bi8W
         OQINwbTq+CUOr6ESXP45a82sMeEozO/hcRZ67SpksoNYIeIGKr3OuavjdII/E/sLU/kr
         GOS703FqdMma8u3rpb7/cVccJPMfoqgTJqWkhtN8JW5qTIetSxL1OJZDtZRpvLvzmqY7
         VHSQ==
X-Gm-Message-State: APjAAAWfwey/zuIFoQxK7MLKr24F1OmEJ8MByVkDbKtYK15iusySFeRj
        GSn5iyFNvEqmiLP5k5aVjmo=
X-Google-Smtp-Source: APXvYqzwAjapIF7GgjFwJi7Ccdk9k7E1KReefuVQZDeqxT98pLHxzeF9bDZB8IBa+DIqyPZU2EYATQ==
X-Received: by 2002:aa7:9f0e:: with SMTP id g14mr10561354pfr.100.1570101123765;
        Thu, 03 Oct 2019 04:12:03 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id w2sm2336841pfn.57.2019.10.03.04.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 04:12:02 -0700 (PDT)
Subject: Re: [PATCH net] tcp: fix slab-out-of-bounds in tcp_zerocopy_receive()
To:     Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20191003031959.165054-1-edumazet@google.com>
 <20191003094611.GC32665@bombadil.infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7fc8f8d2-a077-26a6-730f-46423cb8cdc7@gmail.com>
Date:   Thu, 3 Oct 2019 04:12:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003094611.GC32665@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/19 2:46 AM, Matthew Wilcox wrote:
> On Wed, Oct 02, 2019 at 08:19:59PM -0700, Eric Dumazet wrote:
>> Apparently a refactoring patch brought a bug, that was caught
>> by syzbot [1]
> 
> That wasn't refactoring.  As you know (because we talked about it at
> LSFMM), this is an enabling patch for supporting hch's work to fix
> get_user_pages().

Changing frags->size by skb_frag_size(frags) is what I call refactoring.

This was claimed in the changelog of your patch :

<quote>
    net: Use skb accessors in network core
    
    In preparation for unifying the skb_frag and bio_vec, use the fine
    accessors which already exist and use skb_frag_t instead of
    struct skb_frag_struct.
</quote>

I guess David trusted you enough and did not checked that you made other changes.

> 
>> Original code was correct, do not try to be smarter than the
>> compiler :/
> 
> That wasn't an attempt to be smarter than the compiler.  I was trying
> to keep the line length below 80 columns.  Which you probably now see
> that you haven't done.

Seriously we do not care of the 80 column rule in this particular function,
we care about code correctness first.

We do not mix fixes and cleanups in the same patch.

> 
> I must have a blind spot here.  I can't see the difference between the
> two versions.

No worries.

The major difference is that with your code, when @remaining reaches zero,
it fetches an extra "size = skb_frag_size(frags);" at line 1807
as the syzbot report correctly points.

MAX_SKB_FRAGS is 17 on x86, meaning struct skb_shared_info frags[] array
has 17 elements.

Accessing the 18th element can trigger a page fault, if struct skb_shared_info
sits exactly at the end of a page.

while (remaining && (size != PAGE_SIZE ||
		     skb_frag_off(frags))) {

	remaining -= size; // when this reaches 0

	frags++; // this points to the next fragment in the array, not initialized.

	size = skb_frag_size(frags); // Crash here if crossing a page and next  page is unmapped.
}

Original code from Soheil was correct :

while (remaining && (frags->size != PAGE_SIZE ||
		     frags->page_offset)) {
	remaining -= frags->size;
	frags++;
}

My patch simply restore this code, keeping the accessors changes which were perfectly fine,
thank you.
