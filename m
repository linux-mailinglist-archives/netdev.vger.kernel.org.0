Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF05189610
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgCRG6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:58:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39565 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbgCRG6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 02:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584514718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFYgEdySk4OkG4HI20uZ5gFQT14gEWeLEgskvxgu5Dg=;
        b=WhC8mOoXKAXlMwlcBAEatI4rrGDZ2mULaxfjW5Eng6Oc26t/alcKH1PDt5UcqbZtqbTMUz
        PcJ4BebIQ2Djnx6yf74c9t5GaO4K9jS/SA8jZQuKBmvNtFXsaKDQqmjI+JU9O5HXvWPotY
        +aF2GfOZ3LNm4i5lTIIJyrHJfK1ARrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-7NxgLDcQN3qSUTIWabwwsw-1; Wed, 18 Mar 2020 02:58:34 -0400
X-MC-Unique: 7NxgLDcQN3qSUTIWabwwsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 007BE107B7D9;
        Wed, 18 Mar 2020 06:58:32 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 503FF19C58;
        Wed, 18 Mar 2020 06:58:23 +0000 (UTC)
Date:   Wed, 18 Mar 2020 07:58:22 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@toke.dk>, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v1 01/15] xdp: add frame size to xdp_buff
Message-ID: <20200318075822.51211286@carbon>
In-Reply-To: <20200317134243.3c29a324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446615272.702578.2884467013936153419.stgit@firesoul>
        <20200317134243.3c29a324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 13:42:43 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 17 Mar 2020 18:29:12 +0100 Jesper Dangaard Brouer wrote:
> > XDP have evolved to support several frame sizes, but xdp_buff was not
> > updated with this information. The frame size (frame_sz) member of
> > xdp_buff is introduced to know the real size of the memory the frame is
> > delivered in.
> > 
> > When introducing this also make it clear that some tailroom is
> > reserved/required when creating SKBs using build_skb().
> > 
> > It would also have been an option to introduce a pointer to
> > data_hard_end (with reserved offset). The advantage with frame_sz is
> > that (like rxq) drivers only need to setup/assign this value once per
> > NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
> > store frame_sz inside xdp_rxq_info, because it's varies per packet as it
> > can be based/depend on packet length.  
> 
> Do you reckon it would be too ugly to make xdp-generic suffer and have
> it set the length in rxq per packet? We shouldn't handle multiple
> packets from the same rxq in parallel, no?

It's not only xdp-generic, but also xdp-native drivers like ixgbe and
i40e, that have modes (>4K page) where they have per packet frame size.
As this kind of mode, have in-practice been "allowed" (with out me
realizing it) I expect that other drivers will likely also use this.

Regarding the parallel argument, then Intel at LPC had done experiments
with "RX-bulking" that required multiple xdp_buff's.  It's not exactly
parallel, but I see progress in that direction.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

