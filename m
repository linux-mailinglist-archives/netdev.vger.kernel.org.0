Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5515EDF63
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiI1O6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiI1O6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:58:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32798870A9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664377114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBw2Piu7frxU6zStczBLGlFxSalxGa3Vat3kS7jpubk=;
        b=BOuIpsm9CyUtt7sDYLkZYBcptmGq1JajQ7zLP4tPfpf7Il79Cah/6O7UQzQhN01S7ltBNk
        P85ET+a4wduPsf26C8T+rKo9iA/yY2S841nAxsvwJpSBooo0m8bI2HhfIQazLwHBubDnCk
        ckrY+Sc1mVElXQnv83XgIX4ielIwzxo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-63-STmGnFnOM9e8t2tO-EXVjA-1; Wed, 28 Sep 2022 10:58:32 -0400
X-MC-Unique: STmGnFnOM9e8t2tO-EXVjA-1
Received: by mail-ed1-f70.google.com with SMTP id c6-20020a05640227c600b004521382116dso10681543ede.22
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UBw2Piu7frxU6zStczBLGlFxSalxGa3Vat3kS7jpubk=;
        b=fty76HEa5KohYNfUWpzBX/94OgeVGrmHx+RyjsdftMf1TQt/12wP5AjB6yIOWrIpuh
         WbyiTEoQWTYKr9gNZKJZ0nnuU7xmS495+54bSEfKM5QOgCjV2kYm06neege2lVuxt/kW
         jTtWcck9vDavFxZfehhltAarrUn8IaZLsNESD+VhE4DzhUmYSORJByCfMxXqt7pAYYap
         BPdD8kb6npIBsVVjTHPsi7bEX4Hmc3sQnC2aN7P8nQRR9xT2K4EPEp/7Yc09hFbGsDJX
         c1vlBtjwZ586ksY3oVZ/nLn1bgY7bTmYOV3ZnUcSQl+oIxa9Pq7TFa1WB4hIXM6eYLXa
         gBaQ==
X-Gm-Message-State: ACrzQf0wLO7UUGUSWW0HDAI1x+lgcmMOA1dkGmfcMNEQplnmbdUtBR9i
        3PD1QZyfo8uRkmCegbJrqlgSP1KTZ1k/5iR5YxD0L07tIyvxOck7g73hT3ge5NbajGz0BIHGj6N
        spr/2T7Ij4VqGRYiq
X-Received: by 2002:a17:907:c1c:b0:782:9d80:8bbf with SMTP id ga28-20020a1709070c1c00b007829d808bbfmr23527044ejc.203.1664377109733;
        Wed, 28 Sep 2022 07:58:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6UxZZ89UIizEuVdFA6+KWHX9OjXgCI0x3lUdEcCPlgsiLKezMTVCgFWaA6R4RJ+3jXN6yEEw==
X-Received: by 2002:a17:907:c1c:b0:782:9d80:8bbf with SMTP id ga28-20020a1709070c1c00b007829d808bbfmr23526898ejc.203.1664377107274;
        Wed, 28 Sep 2022 07:58:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h15-20020a170906260f00b0077e6be40e4asm2592331ejc.175.2022.09.28.07.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:58:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E52E461D22E; Wed, 28 Sep 2022 16:58:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
In-Reply-To: <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 28 Sep 2022 16:58:25 +0200
Message-ID: <87v8p7r1f2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heng Qi <hengqi@linux.alibaba.com> writes:

> =E5=9C=A8 2022/9/27 =E4=B8=8B=E5=8D=888:20, Toke H=C3=B8iland-J=C3=B8rgen=
sen =E5=86=99=E9=81=93:
>> Heng Qi <hengqi@linux.alibaba.com> writes:
>>
>>> In the current processing logic, when xdp_redirect occurs, it transmits
>>> the xdp frame based on napi.
>>>
>>> If napi of the peer veth is not ready, the veth will drop the packets.
>>> This doesn't meet our expectations.
>> Erm, why don't you just enable NAPI? Loading an XDP program is not
>> needed these days, you can just enable GRO on both peers...
>
> In general, we don't expect veth to drop packets when it doesn't mount
> the xdp program or otherwise, because this is not as expected.

Well, did you consider that maybe your expectation is wrong? ;)

>>> In this context, if napi is not ready, we convert the xdp frame to a sk=
b,
>>> and then use veth_xmit() to deliver it to the peer veth.
>>>
>>> Like the following case:
>>> Even if veth1's napi cannot be used, the packet redirected from the NIC
>>> will be transmitted to veth1 successfully:
>>>
>>> NIC   ->   veth0----veth1
>>>   |                   |
>>> (XDP)             (no XDP)
>>>
>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>   drivers/net/veth.c | 36 +++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 35 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index 466da01..e1f5561 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -469,8 +469,42 @@ static int veth_xdp_xmit(struct net_device *dev, i=
nt n,
>>>   	/* The napi pointer is set if NAPI is enabled, which ensures that
>>>   	 * xdp_ring is initialized on receive side and the peer device is up.
>>>   	 */
>>> -	if (!rcu_access_pointer(rq->napi))
>>> +	if (!rcu_access_pointer(rq->napi)) {
>>> +		for (i =3D 0; i < n; i++) {
>>> +			struct xdp_frame *xdpf =3D frames[i];
>>> +			struct netdev_queue *txq =3D NULL;
>>> +			struct sk_buff *skb;
>>> +			int queue_mapping;
>>> +			u16 mac_len;
>>> +
>>> +			skb =3D xdp_build_skb_from_frame(xdpf, dev);
>>> +			if (unlikely(!skb)) {
>>> +				ret =3D nxmit;
>>> +				goto out;
>>> +			}
>>> +
>>> +			/* We need to restore ETH header, because it is pulled
>>> +			 * in eth_type_trans.
>>> +			 */
>>> +			mac_len =3D skb->data - skb_mac_header(skb);
>>> +			skb_push(skb, mac_len);
>>> +
>>> +			nxmit++;
>>> +
>>> +			queue_mapping =3D skb_get_queue_mapping(skb);
>>> +			txq =3D netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, queue_mapp=
ing));
>>> +			__netif_tx_lock(txq, smp_processor_id());
>>> +			if (unlikely(veth_xmit(skb, dev) !=3D NETDEV_TX_OK)) {
>>> +				__netif_tx_unlock(txq);
>>> +				ret =3D nxmit;
>>> +				goto out;
>>> +			}
>>> +			__netif_tx_unlock(txq);
>> Locking and unlocking the txq repeatedly for each packet? Yikes! Did you
>> measure the performance overhead of this?
>
> Yes, there are indeed some optimizations that can be done here,
> like putting the lock outside the loop.
> But in __dev_queue_xmit(), where each packet sent is also protected by a =
lock.

...which is another reason why this is a bad idea: it's going to perform
terribly, which means we'll just end up with users wondering why their
XDP performance is terrible and we're going to have to tell them to turn
on GRO anyway. So why not do this from the beginning?

If you want to change the default, flipping GRO to be on by default is a
better solution IMO. I don't actually recall why we didn't do that when
the support was added, but maybe Paolo remembers?

-Toke

