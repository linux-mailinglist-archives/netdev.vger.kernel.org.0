Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9622D2C0A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgLHNa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:30:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729583AbgLHNay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607434168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6obt/HCD4yh4ZtzTFMC2ozOa62OxUxGtEPlnjAuR0Q=;
        b=C1TTPSyMEhowjtU7JaxBBkSMnscqPS3NhWBUfhBs3qO4RTXLb87fAIq7ecjMmwWp9MW4tQ
        APSScx4y5M6kuWkbUFsT5EUWYsjzB00P42u+0h2wyhkmYuKffKCBbTDeBfiWkIjMKZS4Mg
        +/G868OLgyGnIAWPqN8OPXfGx7NgSb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-7JQR-ToUMdutyZSg5O17eQ-1; Tue, 08 Dec 2020 08:29:24 -0500
X-MC-Unique: 7JQR-ToUMdutyZSg5O17eQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C5E1107ACE8;
        Tue,  8 Dec 2020 13:29:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93CA460BE2;
        Tue,  8 Dec 2020 13:29:11 +0000 (UTC)
Date:   Tue, 8 Dec 2020 14:29:10 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>, brouer@redhat.com
Subject: Re: [PATCH v5 bpf-next 02/14] xdp: initialize xdp_buff mb bit to 0
 in all XDP drivers
Message-ID: <20201208142910.34b7c7e5@carbon>
In-Reply-To: <20201208103103.GB36228@lore-desk>
References: <cover.1607349924.git.lorenzo@kernel.org>
        <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
        <CAKgT0UcjtERgpV9tke-HcmP7rWOns_-jmthnGiNPES+aqhScFg@mail.gmail.com>
        <20201207213711.GA27205@ranger.igk.intel.com>
        <71aa9016c087e4c8d502d835ef2cddad42b56fc1.camel@kernel.org>
        <20201208103103.GB36228@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 11:31:03 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Mon, 2020-12-07 at 22:37 +0100, Maciej Fijalkowski wrote:  
> > > On Mon, Dec 07, 2020 at 01:15:00PM -0800, Alexander Duyck wrote:  
> > > > On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org  
> > > > > wrote:
> > > > > Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> > > > > This is a preliminary patch to enable xdp multi-buffer support.
> > > > > 
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > > > 
> > > > I'm really not a fan of this design. Having to update every driver in
> > > > order to initialize a field that was fragmented is a pain. At a
> > > > minimum it seems like it might be time to consider introducing some
> > > > sort of initializer function for this so that you can update things in
> > > > one central place the next time you have to add a new field instead of
> > > > having to update every individual driver that supports XDP. Otherwise
> > > > this isn't going to scale going forward.  

+1

> > > Also, a good example of why this might be bothering for us is a fact that
> > > in the meantime the dpaa driver got XDP support and this patch hasn't been
> > > updated to include mb setting in that driver.
> > >   
> > something like
> > init_xdp_buff(hard_start, headroom, len, frame_sz, rxq);
> >
> > would work for most of the drivers.
> >   
> 
> ack, agree. I will add init_xdp_buff() in v6.

I do like the idea of an initialize helper function.
Remember this is fast-path code and likely need to be inlined.

Further more, remember that drivers can and do optimize the number of
writes they do to xdp_buff.   There are a number of fields in xdp_buff
that only need to be initialized once per NAPI.  E.g. rxq and frame_sz
(some driver do change frame_sz per packet).  Thus, you likely need two
inlined helpers for init.

Again, remember that C-compiler will generate an expensive operation
(rep stos) for clearing a struct if it is initialized like this, where
all member are not initialized (do NOT do this):

 struct xdp_buff xdp = {
   .rxq = rxq,
   .frame_sz = PAGE_SIZE,
 };

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

