Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A566EA4499
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 15:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfHaNOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 09:14:39 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39760 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727342AbfHaNOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 09:14:39 -0400
Received: by mail-ed1-f65.google.com with SMTP id u6so5277920edq.6
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NCveq5p6K2uyICDDPL3SYeS5aVC+SZIpfl3gFITmDIA=;
        b=voERl/Tr7RA9iDLBMC1rWto6N5p0nIA1f97VJ9EA9NVRSIG+9s772t187L4PPtiwnV
         zSC0tUuYnqk4ztJ18Y3xrWpECQCquuIqoNi1P1Bb5jW7aVP1p0j0+iuAfbZHXiuxHeGf
         H7/6y3K+WXdK2APaUSGd6DUkxr78QbGlHxsUlSLuzKt66QWto6PGCI0Op4UVGygTapHi
         muG35QJHBHK4LxZbEx4SJCbBX2Bq5JjziWuSjnQtyXB6oRe34W4sLZW2bYOcp+QLxxtB
         y6qAo5Vfc0R/iNjVRdEqk5oPnVVlzqJthHBHkZ47j5lUjDLbNCLQILmltRpE2o8X9Fh1
         s1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCveq5p6K2uyICDDPL3SYeS5aVC+SZIpfl3gFITmDIA=;
        b=QQiH+RAMJcqqHseHUq9JTLWVlkD7dwVxCpr+XAlbgOcLNI9v1+SsTNHIY805s+/tfa
         FY9N1kpM7wi6eGQCAWPAD6TPnpUNhc9XpcZsfIIY2jhSDT1sRO0dU4GzGoi6BKzFxTZ3
         U+raKh2hpE022wISGCTPlVMp1AxJ4bwSE42oua3OSdOjUCrfozgdAkaxjwLDidvCQKj2
         m0D0MoBybmT0cQUDeNRRiRRHL0zKk8xDY3X0wqZ5gq5gSwPZEMmSjk//5Ouc7b0OkWNq
         bLbXvGAtiga0E3AGatEm3ATW/oZIRMA+gi2VYNGVV/5i+a14xRl5Ni9zRMkT096NozwM
         oEMA==
X-Gm-Message-State: APjAAAWKUpHSJ3DFjjgRviVvTkQCmQ5GoR+sDthHglsVvioPVBNemZHb
        7awuyr5yyhf15Bkf1YTwlYofv6eZLb0Wug==
X-Google-Smtp-Source: APXvYqwFFVlSsrlkKhzFN5Hc257qHk42yNbJCxHLAX+Wnh8jj1OfV04odUFLdRVu2EatUok677jsxA==
X-Received: by 2002:a50:fc12:: with SMTP id i18mr21367909edr.23.1567257277392;
        Sat, 31 Aug 2019 06:14:37 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:a03f:5ad4:8c00:287d:350d:b52f:ffb2])
        by smtp.gmail.com with ESMTPSA id h58sm441101edb.43.2019.08.31.06.14.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 06:14:36 -0700 (PDT)
Subject: Re: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
To:     Sasha Levin <sashal@kernel.org>,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Cc:     aprout@ll.mit.edu, cpaasch@apple.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jonathan.lemon@gmail.com, jtl@netflix.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, stable@vger.kernel.org, ycheng@google.com,
        netdev@vger.kernel.org
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
 <20190824060351.3776-1-tim.froidcoeur@tessares.net>
 <20190831122036.GY5281@sasha-vm>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <35cd974b-2b31-4f86-d53d-8e9516d4077e@tessares.net>
Date:   Sat, 31 Aug 2019 15:14:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190831122036.GY5281@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

Thank you for your reply!

On 31/08/2019 14:20, Sasha Levin wrote:
> On Sat, Aug 24, 2019 at 08:03:51AM +0200, Tim Froidcoeur wrote:
>> Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
>> triggers following stack trace:
>>
>> [25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
>> [25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
>> [25244.888167] Call Trace:
>> [25244.889182]  <IRQ>
>> [25244.890001]  tcp_fragment+0x9c/0x2cf
>> [25244.891295]  tcp_write_xmit+0x68f/0x988
>> [25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
>> [25244.894347]  tcp_data_snd_check+0x2a/0xc8
>> [25244.895775]  tcp_rcv_established+0x2a8/0x30d
>> [25244.897282]  tcp_v4_do_rcv+0xb2/0x158
>> [25244.898666]  tcp_v4_rcv+0x692/0x956
>> [25244.899959]  ip_local_deliver_finish+0xeb/0x169
>> [25244.901547]  __netif_receive_skb_core+0x51c/0x582
>> [25244.903193]  ? inet_gro_receive+0x239/0x247
>> [25244.904756]  netif_receive_skb_internal+0xab/0xc6
>> [25244.906395]  napi_gro_receive+0x8a/0xc0
>> [25244.907760]  receive_buf+0x9a1/0x9cd
>> [25244.909160]  ? load_balance+0x17a/0x7b7
>> [25244.910536]  ? vring_unmap_one+0x18/0x61
>> [25244.911932]  ? detach_buf+0x60/0xfa
>> [25244.913234]  virtnet_poll+0x128/0x1e1
>> [25244.914607]  net_rx_action+0x12a/0x2b1
>> [25244.915953]  __do_softirq+0x11c/0x26b
>> [25244.917269]  ? handle_irq_event+0x44/0x56
>> [25244.918695]  irq_exit+0x61/0xa0
>> [25244.919947]  do_IRQ+0x9d/0xbb
>> [25244.921065]  common_interrupt+0x85/0x85
>> [25244.922479]  </IRQ>
>>
>> tcp_rtx_queue_tail() (called by tcp_fragment()) can call
>> tcp_write_queue_prev() on the first packet in the queue, which will
>> trigger
>> the BUG in tcp_write_queue_prev(), because there is no previous packet.
>>
>> This happens when the retransmit queue is empty, for example in case of a
>> zero window.
>>
>> Patch is needed for 4.4, 4.9 and 4.14 stable branches.
> 
> There needs to be a better explanation of why it's not needed
> upstream...

Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()") was not a
simple cherry-pick of the original one from master (b617158dc096)
because there is a specific TCP rtx queue only since v4.15. For more
details, please see the commit message of b617158dc096 ("tcp: be more
careful in tcp_fragment()").

The BUG() is hit due to the specific code added to versions older than
v4.15. The comment in skb_queue_prev() (include/linux/skbuff.h:1406),
just before the BUG_ON() somehow suggests to add a check before using
it, what Tim did.

In master, this code path causing the issue will not be taken because
the implementation of tcp_rtx_queue_tail() is different:

    tcp_fragment() → tcp_rtx_queue_tail() → tcp_write_queue_prev() →
skb_queue_prev() → BUG_ON()

Because this patch is specific to versions older than the two last
stable ones but still linked to the network architecture, who can review
and approve it? :)

Cheers,
Matt
-- 
Matthieu Baerts | R&D Engineer
matthieu.baerts@tessares.net
Tessares SA | Hybrid Access Solutions
www.tessares.net
1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
