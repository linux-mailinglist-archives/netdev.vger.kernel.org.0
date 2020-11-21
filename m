Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF722BC175
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 19:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgKUSfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgKUSfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 13:35:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15FF2221FE;
        Sat, 21 Nov 2020 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605983730;
        bh=boAeSJoQ9jKz6dTo8ibGTeBHxFvWB4OVYlHIqPg3E6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtQXm9SBGeVznh+CyW9gvs1XCnq1TnCFDi/i1c5xjRUAMLvtfbE6T8Lt2fOKBkfE4
         tVN4bYkUNGkdGJgXJFgHUziue7kvrdCKv3TfHM118oB5w/dCJzWGfXeWVAqJjSNgae
         X+xt9mSnVXA95BrfSbepzT17lu71xYxwaHXzh4GU=
Date:   Sat, 21 Nov 2020 10:35:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Florian Westphal <fw@strlen.de>, Ido Schimmel <idosch@idosch.org>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        davem@davemloft.net, edumazet@google.com, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201121103529.4b4acbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
        <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
        <20201121160941.GA485907@shredder.lan>
        <20201121165227.GT15137@breakpoint.cc>
        <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 19:12:21 +0100 Johannes Berg wrote:
> > So I'm leaning towards reverting the whole thing. You can attach
> > kretprobes and record the information you need in BPF maps.  
> 
> I'm not going to object to reverting it (and perhaps redoing it better
> later), but I will point out that kretprobe isn't going to work, you
> eventually need kcov_remote_start() to be called in strategic points
> before processing the skb after it bounced through the system.
> 
> IOW, it's not really about serving userland, it's about enabling (and
> later disabling) coverage collection for the bits of code it cares
> about, mostly because collecting it for _everything_ is going to be too
> slow and will mess up the data since for coverage guided fuzzing you
> really need the reported coverage data to be only about the injected
> fuzz data...

All you need is make kcov_remote_start_common() be BPF-able, like 
the LSM hooks are now, right? And then BPF can return whatever handle 
it pleases.

Or if you don't like BPF or what to KCOV BPF itself in the future you
can roll your own mechanism. The point is - this should be relatively
easily doable out of line...
