Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB804BB95B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiBRMmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:42:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiBRMmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:42:16 -0500
X-Greylist: delayed 388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 04:41:59 PST
Received: from mail-m2838.qiye.163.com (mail-m2838.qiye.163.com [103.74.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B41CC7CF;
        Fri, 18 Feb 2022 04:41:58 -0800 (PST)
Received: from localhost.localdomain (unknown [117.48.120.186])
        by mail-m2838.qiye.163.com (Hmail) with ESMTPA id DF7583C066F;
        Fri, 18 Feb 2022 20:35:27 +0800 (CST)
From:   Tao Liu <thomas.liu@ucloud.cn>
To:     willemdebruijn.kernel@gmail.com, Tao Liu <thomas.liu@ucloud.cn>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sridhar.samudrala@intel.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net v2] gso: do not skip outer ip header in case of ipip and net_failover
Date:   Fri, 18 Feb 2022 20:35:06 +0800
Message-Id: <CAF=yD-JH3uKC20eRcNGkrYHnz0Csgg_NvnGNw4k-ECz9vLpKbg@mail.gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <CAF=yD-JH3uKC20eRcNGkrYHnz0Csgg_NvnGNw4k-ECz9vLpKbg@mail.gmail.com>
References: <CAF=yD-JH3uKC20eRcNGkrYHnz0Csgg_NvnGNw4k-ECz9vLpKbg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJCHx5WGk5DGkoaTh9ISE
        lOVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6HBw4PTIrNw1WAzgiOgwf
        PxkaCxJVSlVKTU9OSkNMTElDSUhLVTMWGhIXVQ8TFBYaCFUXEg47DhgXFA4fVRgVRVlXWRILWUFZ
        SkpMVU9DVUpJS1VKQ01ZV1kIAVlBSElMSjcG
X-HM-Tid: 0a7f0cd4829f8420kuqwdf7583c066f
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

Sorry for late reply.

> 
> I think the message could be rewritten to point out that the issue is
> specific with the rare combination of SKB_GSO_DODGY and a tunnel
> device that adds an SKB_GSO_ tunnel option.
> 
Will do.

> > This patch also includes ipv6_gso_segment(), considering SIT, etc.
> >
> > Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
> > Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
> 
> This is not a net_failover issue.
> 
Will remove it.

> I'm not sure whether the issue existed at the time tunnel support was
> added, or introduced later. It's reasonable to assume that it was
> always there, but it might be worth a quick code inspection.
> 
> > Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
> > ---
> >  net/ipv4/af_inet.c     | 5 ++++-
> >  net/ipv6/ip6_offload.c | 2 ++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 9c465ba..72fde28 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1376,8 +1376,11 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
> >         }
> >
> >         ops = rcu_dereference(inet_offloads[proto]);
> > -       if (likely(ops && ops->callbacks.gso_segment))
> > +       if (likely(ops && ops->callbacks.gso_segment)) {
> >                 segs = ops->callbacks.gso_segment(skb, features);
> > +               if (!segs)
> > +                       skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
> > +       }
> >
> >         if (IS_ERR_OR_NULL(segs))
> >                 goto out;
> 
> It's unfortunate that we have to add a branch in the common path. But
> I also don't immediately see a cleaner option.
> 
Yes, it is.

Thanks.
