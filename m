Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E236E5632
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDRBIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDRBIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:08:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBDAAD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681780064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJ5eAv/wPSjHQtCSmc7/SAtq7IJeARTquIRQEcE2Hzo=;
        b=ZL2jy4bM2YNSCsVjglUHBcwg/RMWpXsDlI97VY1vjbvH/I9K5JsVVGtFq85K2o9odUn/wt
        jfqmy+iBdSUbQw/sUsgu/d4d82hRNIHptxEJg8xhr0jNiFXCib/uqliKDY1fVYxrJxzjSe
        aIxy9xV3+pfZl7uAR0ccMoK3bp+8S9M=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-V8DLwkCdOCa2f5sskdLbAQ-1; Mon, 17 Apr 2023 21:07:42 -0400
X-MC-Unique: V8DLwkCdOCa2f5sskdLbAQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-38c0db69fdfso69963b6e.1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681780062; x=1684372062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJ5eAv/wPSjHQtCSmc7/SAtq7IJeARTquIRQEcE2Hzo=;
        b=Ul6EhRb+09PlSHefEFaUM5ybkg3X8oKwVUZKkXGfX3eYlpRjOgWuMnk7VGopSLacSI
         ZvgJDmKkUHy2TPBR9LB55ZwzKQNArqR9wNmjUHcsSiUfdGTxzNXgNV3ZATzF57fRqsh/
         bEfwY4QBrmAsvDaWjG7KXEH+52fxYBcTbDD1GsEiCBoFOCRoJ9AXmHzVWmHlM7FLjg8t
         /FpLYmCWEmffsu9fZOQM4cdFH1A3T39kwPc5jPDB34DJnOUBYB8m9dfZ+UTvemv7aD+G
         pQSOo6IFXjubc33zTkmyQHUp3elxeqPiZlx9tlvzoaMjGf6Aht0Z6D1fjAeGXAvdirHi
         PnzQ==
X-Gm-Message-State: AAQBX9emgG6i+sx/CBqvnDcBWjm3jHXqrwKggZ8dZvXYPQ7Un3dwrmIO
        xDcvr2FxezbXTwxTthWaAfjcQUMN5UtIlwvfXOh7fb4pz+s5iT+x+a8PAe80/o9fQUm/pINUomR
        E7rOQil+po/L8JNHMvhUzC8DZm4TfwIum
X-Received: by 2002:aca:a90f:0:b0:38c:2e50:7ba1 with SMTP id s15-20020acaa90f000000b0038c2e507ba1mr70572oie.9.1681780062177;
        Mon, 17 Apr 2023 18:07:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZqCb2yI8XjPtu0T702ZUJh3g15tnGze7/cYh3km5B2h6oWo65vgswsQUHg5Pv5UfUHzBzjLVKg/U5tifRvxHw=
X-Received: by 2002:aca:a90f:0:b0:38c:2e50:7ba1 with SMTP id
 s15-20020acaa90f000000b0038c2e507ba1mr70553oie.9.1681780061908; Mon, 17 Apr
 2023 18:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org> <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org> <20230417115753.7fb64b68@kernel.org>
In-Reply-To: <20230417115753.7fb64b68@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 18 Apr 2023 09:07:30 +0800
Message-ID: <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 17 Apr 2023 11:56:10 -0700 Jakub Kicinski wrote:
> > > May misunderstand, here the "dma_ops" is not the "dma_ops" of DMA API=
.
> > >
> > > I mean the callbacks for xsk to do dma.
> > >
> > > Maybe, I should rename it in the next version.
> >
> > Would you mind explaining this a bit more to folks like me who are not
> > familiar with VirtIO?  DMA API is supposed to hide the DMA mapping
> > details from the stack, why is it not sufficient here.

The reason is that legacy virtio device don't use DMA(vring_use_dma_api()).

The AF_XDP assumes DMA for netdev doesn't work in this case. We need a
way to make it work.

Thanks

>
> Umm.. also it'd help to post the user of the API in the same series.
> I only see the XSK changes, maybe if the virtio changes were in
> the same series I could answer my own question.
>

