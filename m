Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBC598F2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfF1LC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:02:28 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47254 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfF1LC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 07:02:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgoe7-0007P4-VS; Fri, 28 Jun 2019 13:02:24 +0200
Message-ID: <411e7717a68243fc775910ee01fa110c45ce0630.camel@sipsolutions.net>
Subject: Re: [Bridge] VLAN tags in mac_len
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Jiri Pirko <jiri@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Zahari Doychev <zahari.doychev@linux.com>, jhs@mojatatu.com,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 28 Jun 2019 13:02:22 +0200
In-Reply-To: <828a23fe-8466-ae65-7829-620f32aacead@gmail.com> (sfid-20190617_131539_212442_3AC98020)
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
         <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
         <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
         <828a23fe-8466-ae65-7829-620f32aacead@gmail.com>
         (sfid-20190617_131539_212442_3AC98020)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 20:15 +0900, Toshiaki Makita wrote:

> I'll try to explain the problem I see, which cannot be fixed by option 1...
> The bug is in tcf_vlan_act(), and mainly in skb->data, not in mac_len.
> 
> Consider about vlan packets from NIC, but non-hw-accelerated, where
> vlan devices are configured to receive them.
> 
> When __netif_receive_skb_core() is called, skb is like this.
> 
> +-----+------+--------
> > eth | vlan | TCP/IP
> 
> +-----+------+--------
>        ^
>       data
> 
> skb->data is at the beginning of the vlan header.

Right.

> This is reasonable because we did not process the vlan tag at this point.

I think with this simple sentence you just threw a whole new semantic
issue into the mix, one that I at least hadn't considered.

However, it's not clear to me whether we should consider a tag as
processed or not when we push it.

In a sense, this means we should have two different VLAN tag push
options - considering it processed or unprocessed. Or maybe it should
always be considered unprocessed, but that's not what we do today.

> Then after vlan_do_receive() (receive the skb on a vlan device), the skb is like this.
> 
> +-----+--------
> > eth | TCP/IP
> 
> +-----+--------
>        ^
>       data
> 
> Or if reorder_hdr is off (which does not remove vlan tags when receiving on vlan devices),
> 
> +-----+------+--------
> > eth | vlan | TCP/IP
> 
> +-----+------+--------
>               ^
>              data
> 
> Relying on this mechanism, we are currently able to handle multiple vlan tags.
> 
> For example if we have 2 tags,
> 
> - On __netif_receive_skb_core() invocation
> 
> +-----+------+------+--------
> > eth | vlan | vlan | TCP/IP
> 
> +-----+------+------+--------
>        ^
>       data
> 
> - After first vlan_do_receive()
> 
> +-----+------+--------
> > eth | vlan | TCP/IP
> 
> +-----+------+--------
>        ^
>       data
> 
> Or if reorder_hdr is off,
> 
> +-----+------+------+--------
> > eth | vlan | vlan | TCP/IP
> 
> +-----+------+------+--------
>               ^
>              data
> 
> When we process one tag, the data goes forward by one tag.

Right, that's a very good point.

> Now looking at TC vlan case...
> 
> After it inserts two tags, the skb looks like:
> 
> (The first tag is in vlan_tci)
> +-----+------+--------
> > eth | vlan | TCP/IP
> 
> +-----+------+--------
>               ^
>              data
> 
> The data pointer went forward before we process it.
> This is apparently wrong. I think we don't want to (or cannot?) handle cases like this
> after tcf_vlan_act(). This is why I said we should remember mac_len there.

Right, makes a lot of sense.

If you consider a tc VLAN pop, you'd argue that it should pop the next
unprocessed tag I guess, since if it was processed then it doesn't
really exist any more (semantically, you still see it if reorder_hdr is
off), right?

> So, my opinion is:
> On ingress, data pointer can be at the end of vlan header and mac_len probably should
> include vlan tag length, but only after the vlan tag is processed.

You're basically arguing for option (3), I think, making VLAN push/pop
not manipulate mac_len since they can just push/pop *unprocessed* tags,
right?

I fear this will cause all kinds of trouble in other code. Perhaps we
need to make this processed/unprocessed state more explicit.

> Bridge may need to handle mac_len that is not equal to ETH_HLEN but to me it's a
> different problem.

Yes. Like I just said to Daniel, I think we should make bridge handle
mac_len so that we can just exclude it from this whole discussion.
Regardless of the mac_len and processed/unprocessed tags, it would just
work as expected.

johannes

