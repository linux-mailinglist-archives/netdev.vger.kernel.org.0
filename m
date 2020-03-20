Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B96318DA80
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCTVo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:44:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33645 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgCTVo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 17:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584740697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k69Kk/yJiTdB+wPNOXE0GF+G6akiLz5FJqSc975Xp4c=;
        b=Zte1Is7YUw/qNHDdYI0g+24Zpu4Xu7R7M8y3tZN+qJnRhC4keJGZDnOiEG1mVaCiqZtZkk
        qUq0bvjDTlsJkDXcCLj5/d6vAGB/SbgloIg2uEMzjACRdmNRZadJjIgPsCfSdiSHFS1uLp
        z1ZuNTB3NBB9hhbfbS8dTni5UyXms04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-zjsG1ZNLOr6_zNDspxWOmg-1; Fri, 20 Mar 2020 17:44:52 -0400
X-MC-Unique: zjsG1ZNLOr6_zNDspxWOmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B03718A6EC2;
        Fri, 20 Mar 2020 21:44:49 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D283A5C219;
        Fri, 20 Mar 2020 21:44:40 +0000 (UTC)
Date:   Fri, 20 Mar 2020 22:44:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@toke.dk>, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        kuba@kernel.org, brouer@redhat.com
Subject: Re: [PATCH RFC v1 05/15] ixgbe: add XDP frame size to driver
Message-ID: <20200320224437.10ef858c@carbon>
In-Reply-To: <CAKgT0UeV7OHsu=E11QVrQ-HvUe83-ZL2Mo+CKg5Bw4v8REEoew@mail.gmail.com>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446617307.702578.17057660405507953624.stgit@firesoul>
        <20200318200300.GA18295@ranger.igk.intel.com>
        <CAKgT0UeV7OHsu=E11QVrQ-HvUe83-ZL2Mo+CKg5Bw4v8REEoew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 14:23:09 -0700
Alexander Duyck <alexander.duyck@gmail.com> wrote:

> On Wed, Mar 18, 2020 at 1:04 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Tue, Mar 17, 2020 at 06:29:33PM +0100, Jesper Dangaard Brouer wrote:  
> > > The ixgbe driver uses different memory models depending on PAGE_SIZE at
> > > compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
> > > normal MTU frame size is 2048 bytes (and headroom 192 bytes).  
> >
> > To be clear the 2048 is the size of buffer given to HW and we slice it up
> > in a following way:
> > - 192 bytes dedicated for headroom
> > - 1500 is max allowed MTU for this setup
> > - 320 bytes for tailroom (skb shinfo)
> >
> > In case you go with higher MTU then 3K buffer would be used and it would
> > came from order1 page and we still do the half split. Just FYI all of this
> > is for PAGE_SIZE == 4k and L1$ size == 64.  
> 
> True, but for most people this is the most common case since these are
> the standard for x86.
> 
> > > For PAGE_SIZE larger than 4K, driver advance its rx_buffer->page_offset
> > > with the frame size "truesize".  
> >
> > Alex, couldn't we base the truesize here somehow on ixgbe_rx_bufsz() since
> > these are the sizes that we are passing to hw? I must admit I haven't been
> > in touch with systems with PAGE_SIZE > 4K.  
> 
> With a page size greater than 4K we can actually get many more uses
> out of a page by using the frame size to determine the truesize of the
> packet. The truesize is the memory footprint currently being held by
> the packet. So once the packet is filled we just have to add the
> headroom and tailroom to whatever the hardware wrote instead of having
> to use what we gave to the hardware. That gives us better efficiency,
> if we used ixgbe_rx_bufsz() we would penalize small packets and that
> in turn would likely hurt performance.
> 
> > >
> > > When driver enable XDP it uses build_skb() which provides the necessary
> > > tailroom for XDP-redirect.  
> >
> > We still allow to load XDP prog when ring is not using build_skb(). I have
> > a feeling that we should drop this case now.
> >
> > Alex/John/Bjorn WDYT?  
> 
> The comment Jesper had about using using build_skb() when XDP is in
> use is incorrect. The two are not correlated. The underlying buffer is
> the same, however we drop the headroom and tailroom if we are in
> _RX_LEGACY mode. We default to build_skb and the option of switching
> to legacy Rx is controlled via the device private flags.

Thanks for catching that.

> However with that said the change itself is mostly harmless, and
> likely helps to resolve issues that would be seen if somebody were to
> enable XDP while having the RX_LEGACY flag set.

So what is the path forward(?).  Are you/Intel okay with disallowing
XDP when the RX_LEGACY flag is set?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

