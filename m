Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EE46F2E4F
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 06:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjEAEQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 00:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjEAEQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 00:16:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D264116;
        Sun, 30 Apr 2023 21:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KYlatN3lOvUn0xnOEQguwWMLvINM1bo5DgY9EGUS/Bw=; b=j/O1b7YAti0705X9w6bDA/2IK3
        TlpZUwCZmwEkVWkw/81Nv3Z7ISgZa8KN4AZjK5nI/tS3DJ4zFtvszBzCwjg67WM4Oc/wfnDAelfyN
        UM4/oL+g6wWL8YkrEj9uCxAuO+a3KR0OtPBJtUgBBvgMt8c5vFrS2qXUstmoBMVZQkfS5jPwxP/pk
        g0iBvGi5xJ1zEpQBacQhyL4HPh4dLhjxqbot9BGMvZAOF4ZBqEnZfSmkrXiEaey0FdQZzCZ+NpLgi
        ysvS2oadw0agfWLvdq+1S/u8MHJ7nzxq6qup32RplZIhb8MpMhXyva+tkrPmJsY5HJsFHXfB8tUXk
        M8/ySh3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ptKxX-00FDkO-0z;
        Mon, 01 May 2023 04:16:19 +0000
Date:   Sun, 30 Apr 2023 21:16:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
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
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZE89E+qJgGPNUjT5@infradead.org>
References: <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org>
 <ZEDZaitjcX+egzvf@infradead.org>
 <1681981908.9700203-3-xuanzhuo@linux.alibaba.com>
 <ZEFlzdiyu2IAyX7a@infradead.org>
 <20230425035259-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425035259-mutt-send-email-mst@kernel.org>
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

On Tue, Apr 25, 2023 at 04:12:05AM -0400, Michael S. Tsirkin wrote:
> In theory, absolutely. In practice modern virtio devices are ok,
> the reason we are stuck supporting old legacy ones is because legacy
> devices are needed to run old guests. And then people turn
> around and run a new guest on the same device,
> for example because they switch back and forth e.g.
> for data recovery? Or because whoever is selling the
> host wants to opt for maximum compatibility.
> 
> Teaching all of linux to sometimes use dma and sometimes not
> is a lot of work, and for limited benefit of these legacy systems.

It's not like virtio is the only case where blindly assuming
your can use DMA operations in a higher layer is the problem..
