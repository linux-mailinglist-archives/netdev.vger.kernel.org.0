Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8251A7844
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438214AbgDNKRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:17:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438198AbgDNKQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586859410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mtn8Wer36F66lv1oVM1/nLcmPFI938b9NPEjtqQ2+fs=;
        b=GgDMMZBz9+QisNECzno2+YU9WAqKqw4ukCDEkei1VWiSVip6Opfmfm9AB5RJ7Ch09HN9Pb
        z6K/S8dxaHiQwFdgeRCaT7Y2n7SP1qCPEDKVD32lftfMdwEoI41f1xNVWSw2TT+ScMqiEP
        wybk/yafH7qMCV43XnvWrOKT6vDikCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-AZfUOMCuO--X4173cUufdw-1; Tue, 14 Apr 2020 06:16:47 -0400
X-MC-Unique: AZfUOMCuO--X4173cUufdw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B3DDDBB1;
        Tue, 14 Apr 2020 10:16:45 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1C3D5C1B0;
        Tue, 14 Apr 2020 10:16:34 +0000 (UTC)
Date:   Tue, 14 Apr 2020 12:16:33 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     sameehj@amazon.com, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, toke@redhat.com,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com,
        john.fastabend@gmail.com, dsahern@gmail.com,
        willemdebruijn.kernel@gmail.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, saeedm@mellanox.com, brouer@redhat.com
Subject: Re: [PATCH RFC v2 26/33] i40e: add XDP frame size to driver
Message-ID: <20200414121633.0461ece4@carbon>
In-Reply-To: <20200408.144845.783523592365109446.davem@davemloft.net>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634676645.707275.7536684877295305696.stgit@firesoul>
        <20200408.144845.783523592365109446.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Apr 2020 14:48:45 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Wed, 08 Apr 2020 13:52:46 +0200
> 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index b8496037ef7f..1fb6b1004dcb 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -1507,6 +1507,23 @@ static inline unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
> >  	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
> >  }
> >  
> > +static inline unsigned int i40e_rx_frame_truesize(struct i40e_ring *rx_ring,
> > +						  unsigned int size)  
> 
> Please don't use inline in foo.c files.  I noticed you properly elided this in
> the ice changes so I wonder why it showed up here :-)

Yes, I know I should not do this.  It got here by copy-paste accident,
as I first had ixgbe function in a header file, and later I decided to
move this into the ixgbe C-file, but I had already copy-pasted this
into i40e driver ;-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

