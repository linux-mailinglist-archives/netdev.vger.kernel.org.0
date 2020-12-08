Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC52D26C5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgLHJCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:02:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbgLHJCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607418057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGa5H1ZvMxlMFviWO00pWzusbenqRVQjzyCUZblh5To=;
        b=IApBMOjqATNFLKj5HA6XDnqAsAjBVftZajsQIWQqGhzZWOd9Y+0yLIPYgV2TVde9FXwBhs
        +ys+9Awz9PHmLypq1oJm2Swg0YuNbga5BiVrUryY29izq9pkqdVW8pwU3wXLDl2u5WbIFy
        j92RCRRa6xjIQprntvQF9AEnZQRUCg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-7zrk8IWcOOmy3X7IBmJgew-1; Tue, 08 Dec 2020 04:00:55 -0500
X-MC-Unique: 7zrk8IWcOOmy3X7IBmJgew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A04AE1005513;
        Tue,  8 Dec 2020 09:00:52 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03A3E6E521;
        Tue,  8 Dec 2020 09:00:41 +0000 (UTC)
Date:   Tue, 8 Dec 2020 10:00:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201208100040.0d57742a@carbon>
In-Reply-To: <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204102901.109709-2-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
        <20201207135433.41172202@carbon>
        <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 12:52:22 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> > Use-case(1): Cloud-provider want to give customers (running VMs) ability
> > to load XDP program for DDoS protection (only), but don't want to allow
> > customer to use XDP_TX (that can implement LB or cheat their VM
> > isolation policy).  
> 
> Not following. What interface do they want to allow loading on? If its
> the VM interface then I don't see how it matters. From outside the
> VM there should be no way to discover if its done in VM or in tc or
> some other stack.
> 
> If its doing some onloading/offloading I would assume they need to
> ensure the isolation, etc. is still maintained because you can't
> let one VMs program work on other VMs packets safely.
> 
> So what did I miss, above doesn't make sense to me.

The Cloud-provider want to load customer provided BPF-code on the
physical Host-OS NIC (that support XDP).  The customer can get access
to a web-interface where they can write or upload their BPF-prog.

As multiple customers can upload BPF-progs, the Cloud-provider have to
write a BPF-prog dispatcher that runs these multiple program.  This
could be done via BPF tail-calls, or via Toke's libxdp[1], or via
devmap XDP-progs per egress port.

The Cloud-provider don't fully trust customers BPF-prog.   They already
pre-filtered traffic to the given VM, so they can allow customers
freedom to see traffic and do XDP_PASS and XDP_DROP.  They
administratively (via ethtool) want to disable the XDP_REDIRECT and
XDP_TX driver feature, as it can be used for violation their VM
isolation policy between customers.

Is the use-case more clear now?


[1] https://github.com/xdp-project/xdp-tools/tree/master/lib/libxdp
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

