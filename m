Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A087497D3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfFRDoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:44:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36540 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFRDoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:44:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so6812985pfl.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 20:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BoH6OeopVPa/ALDlBdCFpTUJ2t7OvduFfVbwi6u4IFM=;
        b=stEp9Ey9m0ykeur5JULgCYo2wd44zctNckxauDwT98+JnhhPqtp+6kH0bT8rF7l1rc
         oj9LNKZgoU5AW8C9MMirWutR+grKjoof03BVhKkh3yXh+werObMm21/109yO7VgUV/aQ
         rMRyXV4mEUMKVdTy+CCyI3rOvNPE9s32qKvZYrcLj3WXAPSE/GqKxqXGu84wSzQ/MvND
         ZwtzqNjeP3HgR5ORXJylj/5NHyhosxJvS2MVy/Rz7qwTPRlRhRfXLCmoGrxdZmBKPxbQ
         2W091qLI10BR0Bn7mr6vn9IxkouOkItdK9mzH0fgim5MvhkUGGX8wZG5+E8TbsJAGYQd
         hqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BoH6OeopVPa/ALDlBdCFpTUJ2t7OvduFfVbwi6u4IFM=;
        b=NYKgR74c6AUhtofsJevvDVeB/SNOVI2wDFNB5itoagYHvkao+6P2Gci9iBOzoRGIYy
         jiYfKoQH73YJCBYAo8NNlYh2n1zCLM0tD0ZDz1L9FGAbH87vH6e8LKN8k3iZhqrRV+uJ
         O4nR11hihv3ief0SITJqUsCpEusSy7ZyPBlTEZvn8Y06w5ruPiq6C4nq9pNqjqw/+hbf
         t6gUfWx6WjK/S51KXMFn2dcZef0MJu6MeUgYt/cIlPGGT6PH0maYmU4K3y8GgvmNrGfM
         0Tf+zDDTsFUDtbNDHsgW63fGBqM0JeeDT8gbWS1ddT+OKikFBKQBCqf98W9R6IkBMfqJ
         6Q6g==
X-Gm-Message-State: APjAAAXzvia3RWt5m4Vt40BH0mFkWow9mjdvXTUyWh/Uw6xpOTBidJVt
        4VBdYPfOZ7nQlbPuT6yOOuA=
X-Google-Smtp-Source: APXvYqzQUjdRm0vHRkTN0RHDCZJC4fG5dviX+T5o8zPcisDc8Ah4JPSXt8HRR62M0mWQP5/Kc0mUiA==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr2763074pjq.42.1560829473968;
        Mon, 17 Jun 2019 20:44:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id u4sm12625505pfu.26.2019.06.17.20.44.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 20:44:32 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aa0af451-5e7c-7d83-ef25-095a67cd23a1@gmail.com>
Date:   Mon, 17 Jun 2019 20:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/19 8:19 PM, Christoph Paasch wrote:
> 
> Yes, this does the trick for my packetdrill-test.
> 
> I wonder, is there a way we could end up in a situation where we can't
> retransmit anymore?
> For example, sk_wmem_queued has grown so much that the new test fails.
> Then, if we legitimately need to fragment in __tcp_retransmit_skb() we
> won't be able to do so. So we will never retransmit. And if no ACK
> comes back in to make some room we are stuck, no?

Well, RTO will eventually fire.

Really TCP can not work well with tiny sndbuf limits.

There is really no point trying to be nice.

There is precedent in TCP stack where we always allow one packet in RX or TX queue
even with tiny rcv/sndbuf limits (or global memory pressure)

We only need to make sure to allow having at least one packet in rtx queue as well.
