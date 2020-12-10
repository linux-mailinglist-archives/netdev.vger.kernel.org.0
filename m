Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AF2D5BDE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389381AbgLJNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:34:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389373AbgLJNeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:34:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607607167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7R+Qr15dnQkjiaPOVVgqK5mXQ5YRoH0BKswrwklypNY=;
        b=hADCjV6NceLZkiSw+OofKFhgznUAiCy0w1oFhYk6cPgBO/ZELfTumgan7vbvSnCVcobTDc
        guSdifVf/msvOZwp16TbZP/FEtyHRDwVptjtEGXKsyJfr7SxZS+562/4F9Vy9rs8VyH4hg
        gpW6ZknyVzEEyaCSqGNbFIdHzkQpL94=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-XlvZ-sIZNDS17PtQY2FIlA-1; Thu, 10 Dec 2020 08:32:42 -0500
X-MC-Unique: XlvZ-sIZNDS17PtQY2FIlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82F49DF8DD;
        Thu, 10 Dec 2020 13:32:25 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86C2E7770D;
        Thu, 10 Dec 2020 13:32:13 +0000 (UTC)
Date:   Thu, 10 Dec 2020 14:32:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Frey Alfredsson <freysteinn@freysteinn.com>
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Explaining XDP redirect bulk size design (Was: [PATCH v2 bpf 1/5]
 net: ethtool: add xdp properties flag set)
Message-ID: <20201210143211.2490f7f4@carbon>
In-Reply-To: <6913010d-2fd6-6713-94e9-8f5b8ad4b708@gmail.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204102901.109709-2-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
        <20201207135433.41172202@carbon>
        <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
        <20201207230755.GB27205@ranger.igk.intel.com>
        <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
        <20201209095454.GA36812@ranger.igk.intel.com>
        <20201209125223.49096d50@carbon>
        <6913010d-2fd6-6713-94e9-8f5b8ad4b708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 08:44:33 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 12/9/20 4:52 AM, Jesper Dangaard Brouer wrote:
> > But I have redesigned the ndo_xdp_xmit call to take a bulk of packets
> > (up-to 16) so it should not be a problem to solve this by sharing
> > TX-queue and talking a lock per 16 packets.  I still recommend that,
> > for fallback case,  you allocated a number a TX-queue and distribute
> > this across CPUs to avoid hitting a congested lock (above measurements
> > are the optimal non-congested atomic lock operation)  
> 
> I have been meaning to ask you why 16 for the XDP batching? If the
> netdev budget is 64, why not something higher like 32 or 64?

Thanks you for asking as there are multiple good reasons and
consideration for this 16 batch size.  Notice cpumap have batch size 8,
which is also an explicit choice.  And AF_XDP went in the wrong
direction IMHO and I think have 256.  I designed this to be a choice in
the map code, for the level of bulking it needs/wants.

The low level explanation is that these 8 and 16 batch sizes are
optimized towards cache sizes and Intel's Line-Fill-Buffer (prefetcher
with 10 elements).  I'm betting on that memory backing these 8 or 16
packets have higher chance to remain/being in cache, and I can prefetch
them without evicting them from cache again.  In some cases the pointer
to these packets are queued into a ptr_ring, and it is more optimal to
write cacheline sizes 1 (8 pointers) or 2 (16 pointers) into the ptr_ring.

The general explanation is my goal to do bulking without adding latency.
This is explicitly stated in my presentation[1] as of Feb 2016, slide 20.
Sure, you/we can likely make the micro-benchmarks look better by using
64 batch size, but that will introduce added latency and likely shoot
our-selves in the foot for real workloads.  With experience from
bufferbloat and real networks, we know that massive TX bulking have bad
effects.  Still XDP-redirect does massive bulking (NIC flush is after
full 64 budget) and we don't have pushback or a queue mechanism (so I
know we are already shooting ourselves in the foot) ...  Fortunately we
now have a PhD student working on queuing for XDP.

It is also important to understand that this is an adaptive bulking
scheme, which comes from NAPI.  We don't wait for packets arriving
shortly, we pickup what NIC have available, but by only taking 8 or 16
packets (instead of emptying the entire RX-queue), and then spending
some time to send them along, I'm hoping that NIC could have gotten
some more frame.  For cpumap and veth (in-some-cases) they can start to
consume packets from these batches, but NIC drivers gets XDP_XMIT_FLUSH
signal at NAPI-end (xdp_do_flush). Still design allows NIC drivers to
update their internal queue state (and BQL), and if it gets close to
full they can choose to flush/doorbell the NIC earlier.  When doing
queuing for XDP we need to expose these NIC queue states, and having 4
calls with 16 packets (64 budget) also gives us more chances to get NIC
queue state info which the NIC already touch.


[1] https://people.netfilter.org/hawk/presentations/devconf2016/net_stack_challenges_100G_Feb2016.pdf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

