Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA399913
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbfHVQYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:24:25 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42376 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389867AbfHVQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:24:25 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so5656949qkm.9;
        Thu, 22 Aug 2019 09:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LYvKe5wejsC6qDJ+UX43WDzJLWa+tddnchjuNlT6Thg=;
        b=S1E6/5ihriAAmGPzQLCB11TvQvxLBG3TaqCYx881WTAFnA0NYUxSZ3JgJam/+Ww1WF
         A/72qew6cN1tcS5IcZdOo/CfqZX0yQe3Kod8GaULbE7evm8fina+eR5zncgwEIsjdg0k
         hK6I5fhJneS5ym5mhqt5eVgzaqAsnpkFQM3dqtYWbf9Dy6598B7Znj550p/0cJdP9pIJ
         B9UxgFMJFnRg4aBUxuN7zGzk/2xC+KAs15xseZQdfTvrF1raGnqTLbNqrLzrb5L8jTge
         8k9iUUkb/4LbaZIHQMzlBAccuvPNiy1gGTdXDfQPKzv3XrYAf0YIU4WLwWCpFyACNQPN
         mtGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LYvKe5wejsC6qDJ+UX43WDzJLWa+tddnchjuNlT6Thg=;
        b=Sp4a5Ko4FEmXUn4IT6lkfNHcGkzgk94y+UiNeQC64YPv0yy4xMA0EQQKpb8T4ZC+u8
         G3vfS36cvf76MryO4U/jN/maGu+tCbhNlBBaiVOtTVryi5ULN4/uq/w7MTNhVZHwdUHT
         20HY1CKRmD0oUF0d9huJ5Xx6zlKUgfku+8S643VMgN9hw9yuyz9bKJP267zvg4CQN2B0
         1Nh5+dgSPWD/35DD6bjwDprM0HE2ijBJNRSKBLYUHRaiZCGpoGKVnk+aYKAnZiS1GWhb
         UoQ8TbcuimUO/tRziMNCA+CIVXhiN73+WNHg4hQKBW4ityyBs1ihwATl8ck89Ba61SD3
         YrEA==
X-Gm-Message-State: APjAAAVjYTxnjTkjqcKJggYkyQF89zdksVcptncj8cX/UeXygJASdDzB
        njVhIAKTANSsHILJZEqLPFBbILzKbdIukxsW5fM=
X-Google-Smtp-Source: APXvYqzfp0DsFG7wg7mABKUn7qD/EylcXwWBQQXTwi17HfLBzXQgUE4I6Gny6jWqNCRdCx46/Pl5HKKKMYqXVrE4Q7U=
X-Received: by 2002:a37:e306:: with SMTP id y6mr37349543qki.174.1566491064158;
 Thu, 22 Aug 2019 09:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190822123045eucas1p125b6e106f0310bdb50e759ef41993a91@eucas1p1.samsung.com>
 <20190822123037.28068-1-i.maximets@samsung.com>
In-Reply-To: <20190822123037.28068-1-i.maximets@samsung.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 22 Aug 2019 09:23:46 -0700
Message-ID: <CALDO+SaMFHB8u3YOsrCM=MNuT=14kmBnst_RNs3qNU0OjPmfGA@mail.gmail.com>
Subject: Re: [PATCH net v2] ixgbe: fix double clean of tx descriptors with xdp
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 5:30 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Tx code doesn't clear the descriptors' status after cleaning.
> So, if the budget is larger than number of used elems in a ring, some
> descriptors will be accounted twice and xsk_umem_complete_tx will move
> prod_tail far beyond the prod_head breaking the comletion queue ring.

s/comletion/completion/

>
> Fix that by limiting the number of descriptors to clean by the number
> of used descriptors in the tx ring.
>
> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
> 'ixgbe_xsk_clean_tx_ring()' since we don't need most of the
> complications implemented in the regular 'ixgbe_clean_tx_irq()'
> and we're allowed to directly use 'next_to_clean' and 'next_to_use'
> indexes.
>
> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---

Tested-by: William Tu <u9012063@gmail.com>

Instead of measuring tx performance at the tx machine, I measured the TX
performance at the other side (the traffic generating machine).  This time it
is more consistent and showing not much difference with (5.9Mpps) and
without this patch (6.1Mpps).

>
> Version 2:
>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>     'ixgbe_xsk_clean_tx_ring()'.
>
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 34 ++++++++------------
>  1 file changed, 13 insertions(+), 21 deletions(-)
>

<snip>
