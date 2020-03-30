Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD20197CE0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgC3N2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:28:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54570 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgC3N2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:28:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jIuSO-0003z9-4Y; Mon, 30 Mar 2020 15:28:00 +0200
Date:   Mon, 30 Mar 2020 15:27:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Paolo Abeni <pabeni@redhat.com>, steffen.klassert@secunet.com
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330132759.GA31510@strlen.de>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> On udp rx path udp_rcv_segment() may do segment where the frag skbs
> will get the header copied from the head skb in skb_segment_list()
> by calling __copy_skb_header(), which could overwrite the frag skbs'
> extensions by __skb_ext_copy() and cause a leak.
> 
> This issue was found after loading esp_offload where a sec path ext
> is set in the skb.
> 
> On udp tx gso path, it works well as the frag skbs' extensions are
> not set. So this issue should be fixed on udp's rx path only and
> release the frag skbs' extensions before going to do segment.
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")

Hmm, I suspect this bug came in via
3a1296a38d0cf62bffb9a03c585cbd5dbf15d596 , net: Support GRO/GSO fraglist chaining.

I suspect correct fix is:

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 621b4479fee1..7e29590482ce 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,

                skb_push(nskb, -skb_network_offset(nskb) + offset);

+               skb_release_head_state(nskb);
                 __copy_skb_header(nskb, skb);

                skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));

AFAICS we not only leak reference of extensions, but also skb->dst and skb->_nfct.
