Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A49D2870B9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgJHIaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728818AbgJHIav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602145850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9/f5s+wAMUDBHNK2s/ajMrq33GrAKbQrX3IMSK9ziUU=;
        b=DC3drF17dOoGz0HVmaEjL2+kRDkej3r66XEFsFC3HS1V2qk/4annc+K2l/Vo1v/sIfyL/o
        pH3SLt4A3DpsaTOlKGnFjnQabcHNqm7N4EmQVLnkiNrqI2EAPq3X9y3Pim1roB8BNpNMZW
        LNGJlGvNiZSPVcCe2o5Qc8Jz1TGcE4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-AfpjLmSKMbuxo7CHm3l-zg-1; Thu, 08 Oct 2020 04:30:45 -0400
X-MC-Unique: AfpjLmSKMbuxo7CHm3l-zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C686910866AC;
        Thu,  8 Oct 2020 08:30:42 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEDA36EF5D;
        Thu,  8 Oct 2020 08:30:35 +0000 (UTC)
Date:   Thu, 8 Oct 2020 10:30:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
Message-ID: <20201008103034.55c1b8bb@carbon>
In-Reply-To: <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
        <160208778070.798237.16265441131909465819.stgit@firesoul>
        <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 23:37:00 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
> [...]
> >   net/core/dev.c |   24 ++++++++++++++++++++++--
> >   1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b433098896b2..19406013f93e 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3870,6 +3870,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >   	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
> >   	case TC_ACT_OK:
> >   	case TC_ACT_RECLASSIFY:
> > +		*ret = NET_XMIT_SUCCESS;
> >   		skb->tc_index = TC_H_MIN(cl_res.classid);
> >   		break;
> >   	case TC_ACT_SHOT:
> > @@ -4064,9 +4065,12 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   {
> >   	struct net_device *dev = skb->dev;
> >   	struct netdev_queue *txq;
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	bool mtu_check = false;
> > +#endif
> > +	bool again = false;
> >   	struct Qdisc *q;
> >   	int rc = -ENOMEM;
> > -	bool again = false;
> >   
> >   	skb_reset_mac_header(skb);
> >   
> > @@ -4082,14 +4086,28 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   
> >   	qdisc_pkt_len_init(skb);
> >   #ifdef CONFIG_NET_CLS_ACT
> > +	mtu_check = skb_is_redirected(skb);
> >   	skb->tc_at_ingress = 0;
> >   # ifdef CONFIG_NET_EGRESS
> >   	if (static_branch_unlikely(&egress_needed_key)) {
> > +		unsigned int len_orig = skb->len;
> > +
> >   		skb = sch_handle_egress(skb, &rc, dev);
> >   		if (!skb)
> >   			goto out;
> > +		/* BPF-prog ran and could have changed packet size beyond MTU */
> > +		if (rc == NET_XMIT_SUCCESS && skb->len > len_orig)
> > +			mtu_check = true;
> >   	}
> >   # endif
> > +	/* MTU-check only happens on "last" net_device in a redirect sequence
> > +	 * (e.g. above sch_handle_egress can steal SKB and skb_do_redirect it
> > +	 * either ingress or egress to another device).
> > +	 */  
> 
> Hmm, quite some overhead in fast path. 

Not really, normal fast-path already call is_skb_forwardable(). And it
already happens in existing code, ingress redirect code, which I remove
calling in patch 6.

(I have considered inlining is_skb_forwardable as a optimization for
general netstack dev_forward_skb)

> Also, won't this be checked multiple times on stacked devices? :(

I don't think it will be checked multiple times, because we have a
skb_reset_redirect() in ingress path (just after sch_handle_ingress()).

> Moreover, this missed the fact that 'real' qdiscs can have
> filters attached too, this would come after this check. Can't this instead be in
> driver layer for those that really need it? I would probably only drop the check
> as done in 1/6 and allow the BPF prog to do the validation if needed.

See other reply, this is likely what we will end-up with.

> > +	if (mtu_check && !is_skb_forwardable(dev, skb)) {
> > +		rc = -EMSGSIZE;
> > +		goto drop;
> > +	}
> >   #endif
> >   	/* If device/qdisc don't need skb->dst, release it right now while
> >   	 * its hot in this cpu cache.
> > @@ -4157,7 +4175,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   
> >   	rc = -ENETDOWN;
> >   	rcu_read_unlock_bh();
> > -
> > +#ifdef CONFIG_NET_CLS_ACT
> > +drop:
> > +#endif
> >   	atomic_long_inc(&dev->tx_dropped);
> >   	kfree_skb_list(skb);
> >   	return rc;
> >   
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

