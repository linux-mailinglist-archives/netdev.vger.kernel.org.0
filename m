Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD21A7F60
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389284AbgDNOQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:16:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389221AbgDNOQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586873803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XplrO7V42Fns8TALi+Ph0HTduIH/xoZXlThwYZRV910=;
        b=Tp40R3xoJJkA9ze3xko9GmE4TILKe6aA7v+4brbiUS6G9JMNL0eAjVyjphKBAgY6RCZoRR
        qdP5lLdvNEIlna2ey1yLUbaSS/NteZv5hi9piZVUaN4b+MpmgJE15w2saoTZlj+CjlEm99
        DbbjAaB7Fwbt8a0/ZcwwFQ8pS16dSW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-AKOWGE30PyWO_qCcbJ-g1Q-1; Tue, 14 Apr 2020 10:16:41 -0400
X-MC-Unique: AKOWGE30PyWO_qCcbJ-g1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A526C1B18BC5;
        Tue, 14 Apr 2020 14:16:38 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA4815C1B0;
        Tue, 14 Apr 2020 14:16:27 +0000 (UTC)
Date:   Tue, 14 Apr 2020 16:16:26 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200414161626.51e28b4b@carbon>
In-Reply-To: <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634663936.707275.3156718045905620430.stgit@firesoul>
        <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 10:53:39 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> > + * This macro reserves tailroom in the XDP buffer by limiting the
> > + * XDP/BPF data access to data_hard_end.  Notice same area (and size)
> > + * is used for XDP_PASS, when constructing the SKB via build_skb().
> > + */
> > +#define xdp_data_hard_end(xdp)				\
> > +	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> > +	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))  
> 
> I think it should be said somewhere that the drivers are expected to
> DMA map memory up to xdp_data_hard_end(xdp).

No, I don't want driver to DMA map memory up to xdp_data_hard_end(xdp).

The driver will/should map up-to the configured MTU.  Reading ahead, I
can see that you worry about XDP_TX, that doesn't do the MTU check in
xdp_ok_fwd_dev() like we do for XDP_REDIRECT.  Guess, we need to check
that before doing XDP_TX, such that we don't DMA sync for_device, for
an area that does not included the original DMA-map area.  I wonder if
that is a violation, if so, it is also problematic for adjust *head*.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

