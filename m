Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC50C260412
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgIGSDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:03:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728897AbgIGSDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599501784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yqo1lsdLkRhOfjW7UHT4yV+lc6hHGYfKUzEMxekKbg=;
        b=fz4IwXLWeR1GwL/X5SvbZUFqGeJ9kvBLDK9oLqQn2/5tLN7M9cbMHTvP4r7jj8XHAYptqp
        w3BwaUmZQYeksRqGSwKgPpoUKwF/ukzvhgX6R+KkYPe+IocaHpKyAdozXvQhBAf+DH4Apx
        zn7XLnb1JVv473E13Fra/nmzGeaBZD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-2n510tkfOXepvjf57EsPaQ-1; Mon, 07 Sep 2020 14:03:00 -0400
X-MC-Unique: 2n510tkfOXepvjf57EsPaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D0C7801AAD;
        Mon,  7 Sep 2020 18:02:58 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61BB819C4F;
        Mon,  7 Sep 2020 18:02:47 +0000 (UTC)
Date:   Mon, 7 Sep 2020 20:02:45 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <20200907200245.0cdb63f1@carbon>
In-Reply-To: <107260d3-1fea-b582-84d3-2d092f3112b1@gmail.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
        <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
        <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
        <20200904091939.069592e4@carbon>
        <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
        <20200904175946.6be0f565@carbon>
        <107260d3-1fea-b582-84d3-2d092f3112b1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 10:30:48 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 9/4/20 9:59 AM, Jesper Dangaard Brouer wrote:
> >> dev_rx for example seems like it could just be the netdev
> >> index rather than a pointer or perhaps can be removed completely. I
> >> believe it is only used for 1 use case (redirects to CPUMAP); maybe that
> >> code can be refactored to handle the dev outside of xdp_frame.  
> > 
> > The dev_rx is needed when creating an SKB from a xdp_frame (basically
> > skb->dev = rx_dev). Yes, that is done in cpumap, but I want to
> > generalize this.  The veth also creates SKBs from xdp_frame, but use
> > itself as skb->dev.
> > 
> > And yes, we could save some space storing the index instead, and trade
> > space for cycles in a lookup.  
> 
> I think this can be managed without adding a reference to the xdp_frame.
> I'll start a separate thread on that.
> 
> >>
> >> As for frame_sz, why does it need to be larger than a u16?  
> > 
> > Because PAGE_SIZE can be 64KiB on some archs.
> >   

I also believe syzbot managed to create packets for generic-XDP with
frame_sz 128KiB, which was a bit weird (it's on my todo list to
investigate and fix).

> ok, is there any alignment requirement? can frame_sz be number of 32-bit
> words? I believe bit shifts are cheap.

No that is not possible, because some drivers and generic-XDP have a
fully dynamic frame_sz.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

