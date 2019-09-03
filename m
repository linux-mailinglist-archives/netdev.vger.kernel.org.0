Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7845FA7145
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfICRDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 13:03:18 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44676 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfICRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 13:03:18 -0400
Received: by mail-wr1-f53.google.com with SMTP id 30so7338272wrk.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 10:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZ0aOZf1y/WdjmY6eDN/6MXurBrmKvj0PHjzfefqdrU=;
        b=e82AgbPBuoxxaiJ0nm+OZ1kRVQgVI6gr5EAQLzeSDjM1ThIn4EeHbc41YTttdfDWy4
         bEVfdRskYtZLLzCJmsv6i493n3gNtjIgfn2Do2SAWAetACuAxJdqw7jhM84B9EN8Fx/E
         OMyVO2YnH06P/3gmubnYxEKx+iqAk7EZ8Bc3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZ0aOZf1y/WdjmY6eDN/6MXurBrmKvj0PHjzfefqdrU=;
        b=Ao+4KLAqcmrY3ysGEQ1Vl7GJjaQDnklaqWhu9OdZIDJQYhKmaTkJofF6NrNfFTB8Bx
         zDx7BhKL4SzMMBwDFo6syes9x6fFuGfPUZhl4fo73gIU1V7zXtjy/OVp0IXDLw7xw4h+
         qq5KOYCXM7fLaOwNvyS0KsqUePb55wPxzOvsIE2XErjBWGOzOWATB1jO6Pbn/luujs7t
         3268yA/y7Az/foV/UeHW8mB+Y63qUt2gU8z+kLCtoDyPgd3vny1eDx7JgtPijEYrZOfo
         DUqBuoBMFb5u6Czk8rm6qaSh/d2s7j4/9wIcKf7J7K5nFh25HKLS2y4UIcY8krl9WD9L
         Cnww==
X-Gm-Message-State: APjAAAWP4+ZoJgct/h4/+wuUl1rqpHEmb2twcU7iXL78aja3gicK5Zi1
        mRCW+SZZxQaZf0BpRKK3YSuztA==
X-Google-Smtp-Source: APXvYqzqLpl3fuIm4/9kaqhutGIRGVgyXP+lmDHCG1tglICiZQyn/LP+68zoX26Mzcku5pFRCGCRhA==
X-Received: by 2002:adf:e488:: with SMTP id i8mr16175393wrm.20.1567530195750;
        Tue, 03 Sep 2019 10:03:15 -0700 (PDT)
Received: from pixies ([5.102.239.190])
        by smtp.gmail.com with ESMTPSA id y13sm16943988wrg.8.2019.09.03.10.03.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Sep 2019 10:03:14 -0700 (PDT)
Date:   Tue, 3 Sep 2019 20:03:12 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190903200312.7e0ec75e@pixies>
In-Reply-To: <CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com>
References: <20190826170724.25ff616f@pixies>
        <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
        <20190827144218.5b098eac@pixies>
        <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
        <20190829152241.73734206@pixies>
        <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
        <20190903185121.56906d31@pixies>
        <CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Sep 2019 12:23:54 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> This is a lot more code change. Especially for stable fixes that need
> to be backported, a smaller patch is preferable.

Indeed. Thanks for the feedback.

> My suggestion only tested the first frag_skb length. If a list can be
> created where the first frag_skb is head_frag but a later one is not,
> it will fail short. I kind of doubt that.
> 
> By default skb_gro_receive builds GSO skbs that can be segmented
> along the original gso_size boundaries. We have so far only observed
> this issue when messing with gso_size.

The rationale was based on inputs specified in 43170c4e0ba7, where a GRO
skb has a fraglist with different amounts of payloads.

> We can easily refine the test to fall back on to copying only if
> skb_headlen(list_skb) != mss.

I'm concerned this is too generic; innocent skbs may fall victim to our
skb copy fallback. Probably those mentioned in 43170c4e0ba7.

> Alternatively, only on SKB_GSO_DODGY is fine, too.
> 
> I suggest we stick with the two-liner.

OK.
So lets refine your original codition, testing only the first
frag_skb, but also ensuring SKB_GSO_DODGY *and* 'skb_headlen(list_skb) != mss'
(we know existing code DOES work OK for unchanged gso_size, even if frags
have linear, non head_frag, data).

This hits the known, reproducable case of the mentioned BUG_ON, and is
tightly scoped to that case.

If that's agreed, I'll submit a proper patch.

Best,
Shmulik
