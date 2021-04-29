Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6297236EADB
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 14:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbhD2MuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 08:50:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235908AbhD2MuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 08:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619700568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZoGTuPRO2EGwSyJiMBZSgYGCdRr0zd7f2Yezo+ph2zk=;
        b=b/AUjoFFgYUGCvJbP1ScvJKW1akjPiwJP7ytc8IDXm28YXcTaESSfxVf+8qNZGcohBKUTz
        UaZXV0XZhOxg427HYp1FMw75FYYQ2GG45BK0lEX6m0LRPzGJ3R05586XGjzDoy3A3Tz+fK
        hkqjkNicY4em/JO2eDvhjzEjpU8qswk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-62rkyqggO3aCFq06e6qTvA-1; Thu, 29 Apr 2021 08:49:22 -0400
X-MC-Unique: 62rkyqggO3aCFq06e6qTvA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30AC11051EAC;
        Thu, 29 Apr 2021 12:49:19 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B15B843EE;
        Thu, 29 Apr 2021 12:49:13 +0000 (UTC)
Date:   Thu, 29 Apr 2021 14:49:10 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>, brouer@redhat.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210429144910.27aebab2@carbon>
In-Reply-To: <CAJ8uoz3=RiTLf_MY-8=hZpib8ds8HJFraVpjJs_K0QEzjfbEhA@mail.gmail.com>
References: <cover.1617885385.git.lorenzo@kernel.org>
        <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
        <YIhXxmXdjQdrrPbT@lore-desk>
        <CAJ8uoz3=RiTLf_MY-8=hZpib8ds8HJFraVpjJs_K0QEzjfbEhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 09:41:52 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Tue, Apr 27, 2021 at 8:28 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > [...]
> >  
> > > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > > i40e card and the throughput degradation is between 2 to 6% depending
> > > on the setup and microbenchmark within xdpsock that is executed. And
> > > this is without sending any multi frame packets. Just single frame
> > > ones. Tirtha made changes to the i40e driver to support this new
> > > interface so that is being included in the measurements.
> > >
> > > What performance do you see with the mvneta card? How much are we
> > > willing to pay for this feature when it is not being used or can we in
> > > some way selectively turn it on only when needed?  
> >
> > Hi Magnus,
> >
> > Today I carried out some comparison tests between bpf-next and bpf-next +
> > xdp_multibuff series on mvneta running xdp_rxq_info sample. Results are
> > basically aligned:
> >
> > bpf-next:
> > - xdp drop ~ 665Kpps
> > - xdp_tx   ~ 291Kpps
> > - xdp_pass ~ 118Kpps
> >
> > bpf-next + xdp_multibuff:
> > - xdp drop ~ 672Kpps
> > - xdp_tx   ~ 288Kpps
> > - xdp_pass ~ 118Kpps
> >
> > I am not sure if results are affected by the low power CPU, I will run some
> > tests on ixgbe card.  
> 
> Thanks Lorenzo. I made some new runs, this time with i40e driver
> changes as a new data point. Same baseline as before but with patches
> [1] and [2] applied. Note
> that if you use net or net-next and i40e, you need patch [3] too.
> 
> The i40e multi-buffer support will be posted on the mailing list as a
> separate RFC patch so you can reproduce and review.
> 
> Note, calculations are performed on non-truncated numbers. So 2 ns
> might be 5 cycles on my 2.1 GHz machine since 2.49 ns * 2.1 GHz =
> 5.229 cycles ~ 5 cycles. xdpsock is run in zero-copy mode so it uses
> the zero-copy driver data path in contrast with xdp_rxq_info that uses
> the regular driver data path. Only ran the busy-poll 1-core case this
> time. Reported numbers are the average over 3 runs.

Yes, for i40e the xdpsock zero-copy test uses another code path, this
is something we need to keep in mind. 

Also remember that we designed the central xdp_do_redirect() call to
delay creation of xdp_frame.  This is something what AF_XDP ZC takes
advantage of.
Thus, the cost of xdp_buff to xdp_frame conversion is not covered in
below tests, and I expect this patchset to increase that cost...
(UPDATE: below XDP_TX actually does xdp_frame conversion)


> multi-buffer patches without any driver changes:

Thanks you *SO* much Magnus for these superb tests.  I absolutely love
how comprehensive your test results are.  Thanks you for catching the
performance regression in this patchset. (I for one know how time
consuming these kind of tests are, I appreciate your effort, a lot!)

> xdpsock rxdrop 1-core:
> i40e: -4.5% in throughput / +3 ns / +6 cycles
> ice: -1.5% / +1 ns / +2 cycles
> 
> xdp_rxq_info -a XDP_DROP
> i40e: -2.5% / +2 ns / +3 cycles
> ice: +6% / -3 ns / -7 cycles
> 
> xdp_rxq_info -a XDP_TX
> i40e: -10% / +15 ns / +32 cycles
> ice: -9% / +14 ns / +29 cycles

This is a clear performance regression.

Looking closer at driver i40e_xmit_xdp_tx_ring() actually performs a
xdp_frame conversion calling xdp_convert_buff_to_frame(xdp).

FYI: We have started an offlist thread on finding the root-cause and
on IRC with Lorenzo.   The current lead is that, as Alexei so wisely
pointed out in earlier patches, that struct bit access is not
efficient...

As I expect we soon need bits for HW RX checksum indication, and
indication if metadata contains BTF described area, I've asked Lorenzo
to consider this, and look into introducing a flags member. (Then we
just have to figure out how to make flags access efficient).
 

> multi-buffer patches + i40e driver changes from Tirtha:
> 
> xdpsock rxdrop 1-core:
> i40e: -3% / +2 ns / +3 cycles
> 
> xdp_rxq_info -a XDP_DROP
> i40e: -7.5% / +5 ns / +9 cycles
> 
> xdp_rxq_info -a XDP_TX
> i40e: -10% / +15 ns / +32 cycles
> 
> Would be great if someone could rerun a similar set of experiments on
> i40e or ice then
> report.
 
> [1] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210419/024106.html
> [2] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210426/024135.html
> [3] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210426/024129.html

I'm very happy that you/we all are paying attention to keep XDP
performance intact, as small 'paper-cuts' like +32 cycles does affect
XDP in the long run. Happy performance testing everybody :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

