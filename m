Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC32160883
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgBQDM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:12:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46466 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgBQDM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:12:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so6112767pll.13
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 19:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F5LnLcPOk+Sd1f4c3K5GJLZZoLUo6ZsYymTpx/x0YB0=;
        b=LWMJJMoJed6njRvZsSyEv8YPIgeOrPWF/BBQDxinntkfk5Dd6wcwPnTzMaX+3+uVHC
         31S4B+jfL7ciPpTZIO19n9GOUjtJrkjpSQN7PPjoMj7eRfwkcxAg61b+fSJI5tYYUuq0
         epqEC78DwCWP/Oi3WZ9lwD7HkBnlWllJkXKco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F5LnLcPOk+Sd1f4c3K5GJLZZoLUo6ZsYymTpx/x0YB0=;
        b=p0Fq/uLU9MHnuGfj27hLJUH1Pjty/fMEI1sicb50OuLfMaNWHiZCCi/HaHHcoXqDWk
         fSMKl0qnnY0k8u4BZ6l5D4BhbQNGrkeo4oNYtqxGZzyvDtpS1BhgBV3I+xE2psSFR/3j
         hb94rzdFa7DygNDzN4h9V8dGc5fWb9y5PgoB5QsnzOw4eCtSKsyXozcSsAR/ArId5iZ1
         CSVi/fnPs2EpknePTSTY+NB74NUK99lcWyp9IDsVePLDHNwDRRU9a1YTk3ijdoCLyUsF
         QyUmOXT1JruysJ2pehIyKdHEC78ZzrEbWsgDWO34m2+icfxaG1erl3YG8wNTity/MC9H
         HnSw==
X-Gm-Message-State: APjAAAXYqcZU6XJTRO8W2An3GiHWYffJnLLLCF9hfITbb9nk1fr3bpYf
        PhVWWsbldGXgaKWETdmbMj+0fA==
X-Google-Smtp-Source: APXvYqzFUvbif2GXv9f+LGbhc6gDB6TMC3/yhqshk1HuigTQvSGAKgYK6HQnInMhrfMHQm+ZPBFfzA==
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr14494750plm.83.1581909148354;
        Sun, 16 Feb 2020 19:12:28 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id t66sm14746569pgb.91.2020.02.16.19.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 19:12:27 -0800 (PST)
Date:   Mon, 17 Feb 2020 12:12:23 +0900
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     David Ahern <dsahern@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        Michal =?utf-8?Q?Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
Message-ID: <20200217031223.GA35587@f3>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
 <46537e63-1ba9-5e76-fad3-03cae4d0d60f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46537e63-1ba9-5e76-fad3-03cae4d0d60f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/02/15 11:00 -0700, David Ahern wrote:
[...]
> 
> Thanks for adding a test case. I take this to mean that all existing
> tests pass with this change. We have found this code to be extremely
> sensitive to seemingly obvious changes.

I saw two failures from that test suite, regardless of this change:

IPv4 rp_filter tests
    TEST: rp_filter passes local packets                                [FAIL]
    TEST: rp_filter passes loopback packets                             [FAIL]

The other tests, including the ipv6_rt group of tests, are OK.


The rp_filter tests fail for me even if I build a kernel from commit
adb701d6cfa4 ("selftests: add a test case for rp_filter")

Running the first ping manually, tcpdump shows:
root@vsid:~# tcpdump -nepi lo
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on lo, link-type EN10MB (Ethernet), capture size 262144 bytes
12:01:12.618623 52:54:00:6a:c7:5e > 52:54:00:6a:c7:5e, ethertype IPv4 (0x0800), length 98: 198.51.100.1 > 198.51.100.1: ICMP echo request, id 616, seq 435, length 64
12:01:12.618650 52:54:00:6a:c7:5e > 52:54:00:6a:c7:5e, ethertype IPv4 (0x0800), length 98: 198.51.100.1 > 198.51.100.1: ICMP echo reply, id 616, seq 435, length 64

`ping` doesn't show any replies (since it's bound to dummy1...?).

Cong?
