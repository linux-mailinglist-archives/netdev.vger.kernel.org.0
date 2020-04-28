Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600841BC1DA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgD1Oux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:50:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbgD1Oux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588085452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxigzlaMgu0obeYswWvhUEN5ZcN1QetQUZ5JIO9TfMk=;
        b=CUXFK3W80YpgIC2T3+s8aw8ZYN4c5QY/kG2+3Pb9Xc85fwcrjgr03eP6CZ0FtX2Hq0YgsT
        lHPinm2Nf0APsVX6w2NO8Z9i2O8uHgethBfWFJEzF+8tIKiL13WYA+IOFc1leJpy4ggG2h
        zePyZgRIAq118qKTGajiQVGNVAS6nmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-LiCURlxsOT-5l1DM3p1Izg-1; Tue, 28 Apr 2020 10:50:48 -0400
X-MC-Unique: LiCURlxsOT-5l1DM3p1Izg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5D01005510;
        Tue, 28 Apr 2020 14:50:45 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1869310013BD;
        Tue, 28 Apr 2020 14:50:33 +0000 (UTC)
Date:   Tue, 28 Apr 2020 16:50:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
Message-ID: <20200428165032.2c2dca47@carbon>
In-Reply-To: <5ea66d1ec37bc_59462aeb755845b848@john-XPS-13-9370.notmuch>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757179349.1370371.14581472372520364962.stgit@firesoul>
        <5ea66d1ec37bc_59462aeb755845b848@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Apr 2020 22:26:54 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > Clearing memory of tail when grow happens, because it is too easy
> > to write a XDP_PASS program that extend the tail, which expose
> > this memory to users that can run tcpdump.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---  
> 
> Hi Jesper, Thanks for the series any idea what the cost of doing
> this is? If you have some data I would be curious to know a
> baseline measurment, a grow with memset, then a grow with memset.
> I'm guess this can be relatively expensive?

I have a "time_bench" memset kernel module[1] that I use to understand
that is the best-case/minimum overhead with a hot-cache.  But in this
case, the memory will be in L3-cache (at least on Intel with DDIO).

For legitimate use-cases, the BPF-programmer will write her tail data
into this memory area anyhow.  Thus, I'm not convinced this will be a
performance issue for real use-cases.  When we have a real use-case that
need this tail extend and does XDP_TX, I say we can revisit this.


[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_memset.c
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

