Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF66A5EEE2B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiI2G5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiI2G5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:57:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611D212FF1C
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664434661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhtUm5X0hNsnpOP3asXHoTnezpGseEGhfFLz5qlof/k=;
        b=Qq9xiCXuWBEawkZHfhR7+eJY5UiOiChHTUqzCR7TWi0TcOBgV0g7hiLR4aWy7MJjtt3Gk0
        eP3cwkc72Pp7OxOJ1qsMUw3THH9qRGysAFmGxcLRbFHkCT3/W8bcR8580Ygv1mHs25kTUe
        7ehe8oywspH+KKQ5zqwhVcxeNyzBMqA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-499-Xy4ZY6O_MlS3rPOnoOMcZw-1; Thu, 29 Sep 2022 02:57:39 -0400
X-MC-Unique: Xy4ZY6O_MlS3rPOnoOMcZw-1
Received: by mail-wm1-f70.google.com with SMTP id y15-20020a1c4b0f000000b003b47578405aso128873wma.5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=dhtUm5X0hNsnpOP3asXHoTnezpGseEGhfFLz5qlof/k=;
        b=YoWCjTsQJBnUOPE0NTxFlhwK76hq+3vXd/rYii6OAa8b7OTEV9v0njpXHjZu+Ft+J1
         0DDm622IO73VJ0bwLkDNyrRodBd1Vb4Uq9qhERGx0JoOBEHFAAFhgB4kG63aGZ+SQ5F/
         btnofXg+M5wWadAjZoEkTCd+CKRQDua6NF12DTgozsOT+as+3sEUH9Ay2JIP1duYe7fo
         N5b1nU+/QJHvCwk0bp3GIOM7WLFK6y5H6SaochOrtrY5n5pPzwzBXrJqX4tKVDA15NG0
         RRU9ZA8q65M2F4bDTheRs5U72ts5HIHCpKvcuk6wOtFaNW1n4GQCBPgZbbGQuavMcPjY
         TEvg==
X-Gm-Message-State: ACrzQf2E3z1TfOhJls1eRuz4hWtlqIuhpqDHX9hAk5sZK7x26XhfrJrb
        oxK2bLGtvYuWypw/kFnOxuO8QUVjptAlRUVDhCExBy3qHSz0DvcgkKx4SkgZhMXuZkiWL2bL3iu
        s1FqLzbC0mdIlqn6z
X-Received: by 2002:a05:600c:1c05:b0:3b4:c1cb:d45f with SMTP id j5-20020a05600c1c0500b003b4c1cbd45fmr1114055wms.2.1664434658251;
        Wed, 28 Sep 2022 23:57:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6/IqsuryZCjky1rMvtmRSL4OvJVDCRNROstalce48NOwn+M4AoxnM1FkONewYFElVh5zgrwA==
X-Received: by 2002:a05:600c:1c05:b0:3b4:c1cb:d45f with SMTP id j5-20020a05600c1c0500b003b4c1cbd45fmr1114041wms.2.1664434657809;
        Wed, 28 Sep 2022 23:57:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id f15-20020a05600c490f00b003a2e92edeccsm3385054wmp.46.2022.09.28.23.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 23:57:37 -0700 (PDT)
Message-ID: <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Thu, 29 Sep 2022 08:57:36 +0200
In-Reply-To: <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
         <87wn9proty.fsf@toke.dk>
         <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
         <87v8p7r1f2.fsf@toke.dk>
         <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-09-29 at 10:50 +0800, Heng Qi wrote:
> 在 2022/9/28 下午10:58, Toke Høiland-Jørgensen 写道:
> > Heng Qi <hengqi@linux.alibaba.com> writes:
> > 
> > > 在 2022/9/27 下午8:20, Toke Høiland-Jørgensen 写道:
> > > > Heng Qi <hengqi@linux.alibaba.com> writes:
> > > > 
> > > > > In the current processing logic, when xdp_redirect occurs, it transmits
> > > > > the xdp frame based on napi.
> > > > > 
> > > > > If napi of the peer veth is not ready, the veth will drop the packets.
> > > > > This doesn't meet our expectations.
> > > > Erm, why don't you just enable NAPI? Loading an XDP program is not
> > > > needed these days, you can just enable GRO on both peers...
> > > In general, we don't expect veth to drop packets when it doesn't mount
> > > the xdp program or otherwise, because this is not as expected.
> > Well, did you consider that maybe your expectation is wrong? ;)
> 
> For users who don't know what other conditions are required for the readiness of napi,
> all they can observe is why the packets cannot be sent to the peer veth, which is also
> the problem we encountered in the actual case scenarios.
> 
> 
> > 
> > > > > In this context, if napi is not ready, we convert the xdp frame to a skb,
> > > > > and then use veth_xmit() to deliver it to the peer veth.
> > > > > 
> > > > > Like the following case:
> > > > > Even if veth1's napi cannot be used, the packet redirected from the NIC
> > > > > will be transmitted to veth1 successfully:
> > > > > 
> > > > > NIC   ->   veth0----veth1
> > > > >    |                   |
> > > > > (XDP)             (no XDP)
> > > > > 
> > > > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >    drivers/net/veth.c | 36 +++++++++++++++++++++++++++++++++++-
> > > > >    1 file changed, 35 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > > > > index 466da01..e1f5561 100644
> > > > > --- a/drivers/net/veth.c
> > > > > +++ b/drivers/net/veth.c
> > > > > @@ -469,8 +469,42 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
> > > > >    	/* The napi pointer is set if NAPI is enabled, which ensures that
> > > > >    	 * xdp_ring is initialized on receive side and the peer device is up.
> > > > >    	 */
> > > > > -	if (!rcu_access_pointer(rq->napi))
> > > > > +	if (!rcu_access_pointer(rq->napi)) {
> > > > > +		for (i = 0; i < n; i++) {
> > > > > +			struct xdp_frame *xdpf = frames[i];
> > > > > +			struct netdev_queue *txq = NULL;
> > > > > +			struct sk_buff *skb;
> > > > > +			int queue_mapping;
> > > > > +			u16 mac_len;
> > > > > +
> > > > > +			skb = xdp_build_skb_from_frame(xdpf, dev);
> > > > > +			if (unlikely(!skb)) {
> > > > > +				ret = nxmit;
> > > > > +				goto out;
> > > > > +			}
> > > > > +
> > > > > +			/* We need to restore ETH header, because it is pulled
> > > > > +			 * in eth_type_trans.
> > > > > +			 */
> > > > > +			mac_len = skb->data - skb_mac_header(skb);
> > > > > +			skb_push(skb, mac_len);
> > > > > +
> > > > > +			nxmit++;
> > > > > +
> > > > > +			queue_mapping = skb_get_queue_mapping(skb);
> > > > > +			txq = netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, queue_mapping));
> > > > > +			__netif_tx_lock(txq, smp_processor_id());
> > > > > +			if (unlikely(veth_xmit(skb, dev) != NETDEV_TX_OK)) {
> > > > > +				__netif_tx_unlock(txq);
> > > > > +				ret = nxmit;
> > > > > +				goto out;
> > > > > +			}
> > > > > +			__netif_tx_unlock(txq);
> > > > Locking and unlocking the txq repeatedly for each packet? Yikes! Did you
> > > > measure the performance overhead of this?
> > > Yes, there are indeed some optimizations that can be done here,
> > > like putting the lock outside the loop.
> > > But in __dev_queue_xmit(), where each packet sent is also protected by a lock.
> > ...which is another reason why this is a bad idea: it's going to perform
> > terribly, which means we'll just end up with users wondering why their
> > XDP performance is terrible and we're going to have to tell them to turn
> > on GRO anyway. So why not do this from the beginning?
> > 
> > If you want to change the default, flipping GRO to be on by default is a
> > better solution IMO. I don't actually recall why we didn't do that when
> > the support was added, but maybe Paolo remembers?

I preferred to avoid changing the default behavior. Additionally, the
veth GRO stage needs some tuning to really be able to  aggregate the
packets (e.g. napi thread or gro_flush_timeout > 0)

> As I said above in the real case, the user's concern is not why the performance
> of xdp becomes bad, but why the data packets are not received.

Well, that arguably tells the end-user there is something wrong in
their setup. On the flip side, having a functionally working setup with
horrible performances would likely lead the users (perhaps not yours,
surely others) in very wrong directions (from "XDP is slow" to "the
problem is in the application")...

> The default number of veth queues is not num_possible_cpus(). When GRO is enabled
> by default, if there is only one veth queue, but multiple CPUs read and write at the
> same time, the efficiency of napi is actually very low due to the existence of
> production locks and races. On the contrary, the default veth_xmit() each cpu has
> its own unique queue, and this way of sending and receiving packets is also efficient.
> 
This patch adds a bit of complexity and it looks completely avoidable
with some configuration - you could enable GRO and set the number of
queues to num_possible_cpus().

I agree with Toke, you should explain the end-users that their
expecations are wrong, and guide them towards a better setup.

Thanks!

Paolo

