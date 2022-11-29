Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DCF63C709
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiK2SJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiK2SJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97155B5B1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669745311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WWss6s04eYVKSIx0lJzWCZc2o/lhl7bv0cJ3FBaI44M=;
        b=ean2esNcnOVUO2RgqgE9kAKFMr5wVM97IP+uNfZ3YQAT1wP31U3STQGYjfF71FCuZwUb6m
        OPaP6nWejBnVx/qfiLCiK8YRYEaCZZSysT901CXjP+XaNf948ZRrMNK5zMlIwQWqS/wDR4
        OGCOf94uyZNgs9BcCm63RXWXSOkiJxE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-Ie2Jm-kQNGyhGMMZUjDoNQ-1; Tue, 29 Nov 2022 13:08:30 -0500
X-MC-Unique: Ie2Jm-kQNGyhGMMZUjDoNQ-1
Received: by mail-wm1-f70.google.com with SMTP id m17-20020a05600c3b1100b003cf9cc47da5so8170174wms.9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:08:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWss6s04eYVKSIx0lJzWCZc2o/lhl7bv0cJ3FBaI44M=;
        b=ZWdtT3i3s7uKRJU1DT09O1phCFbr7l9Dq/aTwIpdvuh8vq9ZXHkUCR9RgElrSzKchL
         JiMnQ+1k1wMkF0RAuvtmCr3PJ99Gz6iNyrdxbPJcd8I0eLfrczwmmD4ZKdgFLia6pWJ7
         o+jMKkKcMX61saqT0W9NxJNurnSofK/BKBt6DMVoeLQFguYe0FQ0pLOrpqPUNpiy0mE7
         SoJ+sValfngEDdeVLAwgvu/cs7mO5Od1XhWSi+7p7oOFbEb3g1Q0mRaczFXXevEjoHRl
         dCtJG2yo6WXg2uUKlwyWn1xBM7uJGAWPonCOImemFcBdtzhPYPreRwTm6F6P5bAo9daQ
         Wl/A==
X-Gm-Message-State: ANoB5pnDBaxajDxi8XpJ8VTTY+7edvuxpDO3OO1JxhWlMPZNgevqDMkh
        3/+hfruJ+4fqnFQa8da4r3EQFwZ3h23caIJSLdSMny5NJlSNSlf0BhXH6iV4mb57EeXVEOYq0Kq
        GUnZHMLrW0CZPMAcm
X-Received: by 2002:adf:f302:0:b0:242:1dbc:2d29 with SMTP id i2-20020adff302000000b002421dbc2d29mr5191486wro.609.1669745308935;
        Tue, 29 Nov 2022 10:08:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf73ePDgW+BAbPeYbRZmZcWwyiWpzxoUO6OeJPrdvj7zRNi0BAFKA5WSxF+wAlxwSUZMyyYHTQ==
X-Received: by 2002:adf:f302:0:b0:242:1dbc:2d29 with SMTP id i2-20020adff302000000b002421dbc2d29mr5191474wro.609.1669745308723;
        Tue, 29 Nov 2022 10:08:28 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c315100b003cfd64b6be1sm3952139wmo.27.2022.11.29.10.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 10:08:28 -0800 (PST)
Message-ID: <e80ea4e8f42c2113af358b971610f7341eb7494b.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests/net: add csum offload test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com
Date:   Tue, 29 Nov 2022 19:08:27 +0100
In-Reply-To: <CA+FuTScsg6b8wKc4Sz=z+M53nWaxOZh4J+A=JooJspDjysXg6Q@mail.gmail.com>
References: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com>
         <1951bd409f86287fcffce41e22026ed09605f9b2.camel@redhat.com>
         <CA+FuTScsg6b8wKc4Sz=z+M53nWaxOZh4J+A=JooJspDjysXg6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-28 at 11:14 -0500, Willem de Bruijn wrote:
> On Mon, Nov 28, 2022 at 11:08 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Mon, 2022-11-28 at 09:02 -0500, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > > 
> > > Test NIC hardware checksum offload:
> > > 
> > > - Rx + Tx
> > > - IPv4 + IPv6
> > > - TCP + UDP
> > > 
> > > Optional features:
> > > 
> > > - zero checksum 0xFFFF
> > > - checksum disable 0x0000
> > > - transport encap headers
> > > - randomization
> > > 
> > > See file header for detailed comments.
> > > 
> > > Expected results differ depending on NIC features:
> > > 
> > > - CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE
> > > - NETIF_F_HW_CSUM (csum_start/csum_off) vs NETIF_F_IP(V6)_CSUM
> > > 
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > 
> > I'm wondering if we could hook this into the self-tests list with a
> > suitable wrapper script, e.g. searching for a NIC exposing the loopback
> > feature, quering the NETIF_F_HW_CSUM/NETIF_F_IP(V6)_CSUM bit via
> > ethtool and guessing CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE via the
> > received packet.
> > 
> > If the host lacks a suitable device, the test is skipped. WDYT?
> 
> We could. Optionally with ipvlan and two netns to really emulate a two
> host setup.
> 
> I'm hesitant to include this into kselftests without warning though.
> Have too often had to debug tests that crashed and left a machine
> unreachable, because in loopback mode.

I see your point. The forwarding/loopback.sh test does nothing by
default without additional command line arguments, something similar
could work here, too.

I think it would still be valuable, because it will simplify automating
this kind of testing - compared to guessing the needed setup from the
binary alone. 

> Either way, something to do as a separate follow-up patch?

Fine by me. 

Thanks,

Paolo



