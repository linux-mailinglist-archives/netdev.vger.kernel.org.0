Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228686E8A32
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjDTGMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDTGMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:12:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F02D46A6;
        Wed, 19 Apr 2023 23:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VvxWfujovCtVXzYeAUJjYQFMS4G5zuDe6AKlUF+GOvw=; b=m/zx+gYM4jCsPrOJXtRSMp8Tl3
        8LwvrQXASzU57ZHaKfOYUz4Rnao8JdUBNUUu2fMcIIStr3JjVVdiJ1/k+SxT55vpZMI52Y4cgeL8f
        44aw0qOTlRwHMVkGOoDsZCZs7Pu8BaZHAFf0PqQbJcsqj3h+yEPIqTt2E4UOPKzU4VdXdpDCTYWYV
        FqqU3qoKiUW+U92jT5mpKDvIM/zoNSOYUMzsvL/C48LK2TgJ169an9S8YFjgvyYa/vU9tiv7GtV0z
        Ht0pTOgDzlRUDr65HTe6a84uwyRs3CisaPMZwsqWNRRAJHcOJfBjdA6olWm9/AcpwvlN+3GCDElRn
        TGA5FZdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ppNWu-007A2p-2v;
        Thu, 20 Apr 2023 06:12:28 +0000
Date:   Wed, 19 Apr 2023 23:12:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZEDXzGqvSiQ3036r@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <88d5a2f6-af43-c3f9-615d-701ef01d923d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88d5a2f6-af43-c3f9-615d-701ef01d923d@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:22:39PM +0200, Alexander Lobakin wrote:
> If DMA syncs are not needed on your x86_64 DMA-coherent system, it
> doesn't mean we all don't need it.

If the DMA isn't actually a DMA (as in the virtio case, or other
cases that instead have to do their own dma mapping at much lower
layers) syncs generally don't make sense.

> Instead of filling pointers with
> "default" callbacks, you could instead avoid indirect calls at all when
> no custom DMA ops are specified. Pls see how for example Christoph did
> that for direct DMA. It would cost only one if-else for case without
> custom DMA ops here instead of an indirect call each time.

So yes, I think the abstraction here should not be another layer of
DMA ops, but the option to DMA map or not at all.
