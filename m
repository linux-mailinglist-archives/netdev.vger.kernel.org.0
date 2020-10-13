Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9028D576
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgJMUkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 16:40:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbgJMUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 16:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602621622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8e8/TTaBr62mel/l61VFZGKbO6FD7uZR4UyKWEd9sso=;
        b=QrS9v2jKgqRtLjaDCsVQgKzBXc0e0mKrybon4IEk3p/NZ+6resWiyEnGfV+RsW99zRQJv8
        ZGyyWn6cUu09GJl1sCua1GEOx74fjEW4nQ0IhXEKHfE/sTCh/FwYnoIAvX49LE0N0HniGO
        RIw8qpoz2Ozt7/n6oyg79/SuOm63TVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-IAY-WSGiMpWc5EZeKug3uQ-1; Tue, 13 Oct 2020 16:40:20 -0400
X-MC-Unique: IAY-WSGiMpWc5EZeKug3uQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C23C57083;
        Tue, 13 Oct 2020 20:40:18 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6713019D6C;
        Tue, 13 Oct 2020 20:40:11 +0000 (UTC)
Date:   Tue, 13 Oct 2020 22:40:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201013224009.77d6f746@carbon>
In-Reply-To: <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
        <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201010124402.606f2d37@carbon>
        <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 09:32:12 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat, 10 Oct 2020 12:44:02 +0200 Jesper Dangaard Brouer wrote:
> > > > > We will not be sprinkling validation checks across the drivers because
> > > > > some reconfiguration path may occasionally yield a bad packet, or it's
> > > > > hard to do something right with BPF.        
> > > > 
> > > > This is a driver bug then. As it stands today drivers may get hit with
> > > > skb with MTU greater than set MTU as best I can tell.      
> > > 
> > > You're talking about taking it from "maybe this can happen, but will
> > > still be at most jumbo" to "it's going to be very easy to trigger and
> > > length may be > MAX_U16".    
> > 
> > It is interesting that a misbehaving BPF program can easily trigger this.
> > Next week, I will looking writing such a BPF-prog and then test it on
> > the hardware I have avail in my testlab.  

I've tested sending different packet sizes that exceed the MTU on
different hardware. They all silently drop the transmitted packet. mlx5
and i40e configured to (L3) MTU 1500, will lets through upto 1504, while
ixgbe will drop size 1504.

Packets can be observed locally with tcpdump, but the other end doesn't
receive the packet. I didn't find any counters (including ethtool -S)
indicating these packets were dropped at hardware/firmware level, which
were a little concerning for later troubleshooting.

Another observation is that size increases (with bpf_skb_adjust_room)
above 4096 + e.g 128 will likely fail, even-though I have the 64K limit in
this kernel.
 
> FWIW I took a quick swing at testing it with the HW I have and it did
> exactly what hardware should do. The TX unit entered an error state 
> and then the driver detected that and reset it a few seconds later.

The drivers (i40e, mlx5, ixgbe) I tested with didn't entered an error
state, when getting packets exceeding the MTU.  I didn't go much above
4K, so maybe I didn't trigger those cases.
 
> Hardware is almost always designed to behave like that. If some NIC
> actually cleanly drops over sized TX frames, I'd bet it's done in FW,
> or some other software piece.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

