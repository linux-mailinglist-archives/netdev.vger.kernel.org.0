Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F98F197D41
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgC3Npe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:45:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55682 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgC3Npe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 09:45:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C43C920512;
        Mon, 30 Mar 2020 15:45:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3DZcNMgz6QEW; Mon, 30 Mar 2020 15:45:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5AE54201A0;
        Mon, 30 Mar 2020 15:45:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 30 Mar 2020 15:45:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 30 Mar
 2020 15:45:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BB0A13180136;
 Mon, 30 Mar 2020 15:45:31 +0200 (CEST)
Date:   Mon, 30 Mar 2020 15:45:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330134531.GK13121@gauss3.secunet.de>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330132759.GA31510@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200330132759.GA31510@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 03:27:59PM +0200, Florian Westphal wrote:
> Xin Long <lucien.xin@gmail.com> wrote:
> > On udp rx path udp_rcv_segment() may do segment where the frag skbs
> > will get the header copied from the head skb in skb_segment_list()
> > by calling __copy_skb_header(), which could overwrite the frag skbs'
> > extensions by __skb_ext_copy() and cause a leak.
> > 
> > This issue was found after loading esp_offload where a sec path ext
> > is set in the skb.
> > 
> > On udp tx gso path, it works well as the frag skbs' extensions are
> > not set. So this issue should be fixed on udp's rx path only and
> > release the frag skbs' extensions before going to do segment.
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> 
> Hmm, I suspect this bug came in via
> 3a1296a38d0cf62bffb9a03c585cbd5dbf15d596 , net: Support GRO/GSO fraglist chaining.

I overlooked the explicit mentioning of skb_segment_list()
in the commit message. Fraglist GRO is disabled by default,
this means that it was enabled explicitely. So yes, the bug
came via that commit.

> 
> I suspect correct fix is:
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 621b4479fee1..7e29590482ce 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> 
>                 skb_push(nskb, -skb_network_offset(nskb) + offset);
> 
> +               skb_release_head_state(nskb);
>                  __copy_skb_header(nskb, skb);
> 
>                 skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> 
> AFAICS we not only leak reference of extensions, but also skb->dst and skb->_nfct.

Would be nice if we would not need to drop the resources
just to add them back again in the next line. But it is ok
as a quick fix for the bug.

