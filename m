Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAC62BC220
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 21:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgKUUzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 15:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgKUUzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 15:55:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E6920727;
        Sat, 21 Nov 2020 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605992110;
        bh=ye6Wd9VAdi/Z/6kuARgZpSXsPBJGk3MATkdNDg6IxkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fXHmEGofGz/HeIMSJOqBOM7tCYFsPtbAG+kxBW79jR652+IMrW7Tt97wf6yVdvfCG
         wKNQ/EJ2XSRbRDd9DVJpUVN0qX34SBblVvbsxp2CXc9FCKZkpkcw1dlnRAzcogqeD0
         z3k5GgWXR85XxDiTRipe/By5xXWVeS2uhxFAAKr0=
Date:   Sat, 21 Nov 2020 12:55:08 -0800
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
Message-ID: <20201121125508.4d526dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <106fc65f0459bc316e89beaf6bd71e823c4c01b7.camel@sipsolutions.net>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
        <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
        <20201121160941.GA485907@shredder.lan>
        <20201121165227.GT15137@breakpoint.cc>
        <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
        <20201121103529.4b4acbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <106fc65f0459bc316e89beaf6bd71e823c4c01b7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 20:30:44 +0100 Johannes Berg wrote:
> On Sat, 2020-11-21 at 10:35 -0800, Jakub Kicinski wrote:
> > On Sat, 21 Nov 2020 19:12:21 +0100 Johannes Berg wrote:  
> > > > So I'm leaning towards reverting the whole thing. You can attach
> > > > kretprobes and record the information you need in BPF maps.    
> > > 
> > > I'm not going to object to reverting it (and perhaps redoing it better
> > > later), but I will point out that kretprobe isn't going to work, you
> > > eventually need kcov_remote_start() to be called in strategic points
> > > before processing the skb after it bounced through the system.
> > > 
> > > IOW, it's not really about serving userland, it's about enabling (and
> > > later disabling) coverage collection for the bits of code it cares
> > > about, mostly because collecting it for _everything_ is going to be too
> > > slow and will mess up the data since for coverage guided fuzzing you
> > > really need the reported coverage data to be only about the injected
> > > fuzz data...  
> > 
> > All you need is make kcov_remote_start_common() be BPF-able, like 
> > the LSM hooks are now, right? And then BPF can return whatever handle 
> > it pleases.  
> 
> Not sure I understand. Are you saying something should call
> "kcov_remote_start_common()" with, say, the SKB, and leave it to a mass
> of bpf hooks to figure out where the SKB got cloned or copied or
> whatnot, track that in a map, and then ... no, wait, I don't really see
> what you mean, sorry.
> 
> IIUC, fundamentally, you have this:
> 
>  - at the beginning, a task is tagged with "please collect coverage
>    data for this handle"

Write the tag into task local storage, or map indexed by PID.

>  - this task creates an SKB, etc, and all of the code that this task
>    executes is captured and the coverage data is reported

kprobe the right places to record the skb -> handle mapping.

>  - However, the SKB traverses lots of things, gets copied, cloned, or
>    whatnot, and eventually leaves the annotated task, say for further
>    processing in softirq context or elsewhere.

Which is fine.

> Now since the whole point is to see what chaos this SKB created from
> beginning (allocation) to end (free), since it was filled with fuzzed
> data, you now have to figure out where to pick back up when the SKB is
> processed further.
> 
> This is what the infrastructure was meant to solve. But note that the
> SKB might be further cloned etc, so in order to track it you'd have to
> (out-of-band) figure out all the possible places where it could
> be reallocated, any time the skb pointer could change.

Ack, you have to figure out all the places anyway, the question is
whether you put probes there or calls in the source code.

Shifting the maintenance burden but also BPF is flexibility.

> Then, when you know you've got interesting code on your hands, like in
> mac80211 that was annotated in patch 3 here, you basically say
> 
>   "oohhh, this SKB was annotated before, let's continue capturing
>    coverage data here"
> 
> (and turn it off again later by the corresponding kcov_remote_stop().

Yup, the point is you can feed a raw skb pointer (and all other
possible context you may want) to a BPF prog in kcov_remote_start() 
and let BPF/BTF give you the handle it recorded in its maps.

> So the only way I could _possibly_ see how to do this would be to
> 
>  * capture all possible places where the skb pointer can change
>  * still call something like skb_get_kcov_handle() but let it call out
>    to a BPF program to query a map or something to figure out if this
>    SKB has a handle attached to it
> 
> > Or if you don't like BPF or what to KCOV BPF itself in the future you
> > can roll your own mechanism. The point is - this should be relatively
> > easily doable out of line...  
> 
> Seems pretty complicated to me though ...

It is more complicated. We can go back to an skb field if this work is
expected to yield results for mac80211. Would you mind sending a patch?
