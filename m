Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994CC69842B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBOTJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBOTJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:09:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151142A158
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676488127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CmMW58hPjNRugMO0eZMcg0tpwApl/XjW1YHRRxg4oMQ=;
        b=AsvQBpPEzEG2JsoZ+2wch5W2eAuyJHYSxgpjWU5E6GNDJa/brNhHC4W3AYYYmHR0jRbwqT
        WF65ema8ab8msh7qAKx4ONwkXi96TaFJS4G5Q+gHxDj12ve/QECP1RMg1k1HsWSBQynliE
        I1O2vNG25xybGcbcRTILHt9lRrD8rlA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-fj_UtSnhM_SYn618jDS5oQ-1; Wed, 15 Feb 2023 14:08:45 -0500
X-MC-Unique: fj_UtSnhM_SYn618jDS5oQ-1
Received: by mail-qt1-f197.google.com with SMTP id c14-20020ac87d8e000000b003ba2d72f98aso11685413qtd.10
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676488125;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmMW58hPjNRugMO0eZMcg0tpwApl/XjW1YHRRxg4oMQ=;
        b=qF1r6NhKIGBDcquXyTIqNjXMqiOoPVmdkLSEnGLMWfntZ9Z6+wHDvZI1B2vXV6VyIY
         hVqMDKxtDXQHI4204ZZibT+MzLj4N3oNcItCt8ISojjnXGlgb318b/tTQPj54kAqZXm2
         PrMUV/9lF2RqDDXdVmJJ3djfhlC+Bz9LFG5NDwCOuXrr839BtuqCxdridqUZfYDi9ffi
         TazY429c2OtB2cWfb18Ybc/er8tMxFU7AvNfPS/zT3wbHse5N1TFV1P/t/69s0yPcAum
         sTLmhOUe4jBc29PZvyLcyZ3PON0sEk9d0IJt9ut2vcGFI7MMRj6gT9VL08Oec/qfuyxo
         9Njw==
X-Gm-Message-State: AO0yUKXiA1GNIaXBagwh465vqIqKa6QM9xvhtjM9W9w/ceeJ+386T3vN
        NCNt7RoMcJtF+1sCfe2OJFPUZAX8XQMMUJhzGnY7I4h3kuLWkLQ2YQRFk028JYmLaxnqpON8DHL
        dnI/pIIWtHZ4CYPSu
X-Received: by 2002:ac8:5a16:0:b0:3b6:35cb:b944 with SMTP id n22-20020ac85a16000000b003b635cbb944mr5644397qta.2.1676488124924;
        Wed, 15 Feb 2023 11:08:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+fQrJecFDe4sUx/0s9kjlvr5hudOC3T48neX50d+cDZzfe44cjpSwJQt6RnfOysY8vuJ/Bew==
X-Received: by 2002:ac8:5a16:0:b0:3b6:35cb:b944 with SMTP id n22-20020ac85a16000000b003b635cbb944mr5644362qta.2.1676488124656;
        Wed, 15 Feb 2023 11:08:44 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id f187-20020a37d2c4000000b0073980414888sm10469592qkj.42.2023.02.15.11.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:08:44 -0800 (PST)
Message-ID: <559d2f60eb97033ad4ddd2963232e49962a2efe2.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, fw@strlen.de
Date:   Wed, 15 Feb 2023 20:08:40 +0100
In-Reply-To: <904992ba-650c-8810-b0e1-6c8acf5aab77@intel.com>
References: <20230215034355.481925-1-kuba@kernel.org>
         <20230215034355.481925-3-kuba@kernel.org>
         <ef9ab8960763289e990b0010ee2aa761c3ee80a3.camel@redhat.com>
         <20230215094542.7dc0ded6@kernel.org>
         <904992ba-650c-8810-b0e1-6c8acf5aab77@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-15 at 19:08 +0100, Alexander Lobakin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 15 Feb 2023 09:45:42 -0800
>=20
> > On Wed, 15 Feb 2023 09:41:13 +0100 Paolo Abeni wrote:
> > > I'm wondering if napi_reuse_skb() should be touched, too? Even it's n=
ot
> > > directly used by the following patch...
> >=20
> > I didn't touch it because I (sadly) don't have access to any driver
> > using GRO frags to test :(  But I certainly can.
> >=20
> > What about __kfree_skb_defer() and napi_consume_skb() (basically=20
> > the other two napi_skb_cache_put() callers) ?
> >=20
>=20
> Sounds good. Basically any caller of napi_skb_cache_put() can be
> switched to recycle extensions.
> But you certainly need to have a pool instead of just one pointer then,
> since napi_consume_skb() will return a lot if exts are actively used :)

This could be also a point to (initially) exclude napi_consume_skb()
and keep the (initial) implementation as simple as possible.

If the expected use-case more related to forwarded traffic, local
traffic or independent from such consideration?

Cheers,

Paolo

