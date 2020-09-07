Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6962260364
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgIGRs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:48:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729186AbgIGMpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 08:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599482726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=roaevUwoEk/ZQMYrEJKVf+IX4sE5Ce77Mkr/rtN0U/Y=;
        b=Bu+XmXReMas0afJ/voqmydQS7aQx5NtX1/s0BQiG99FW8wTl5S9dLWJkS8bF/IoNqrBEge
        bxoaG+XjXgiC6oW2IBXeZXBFTf3xFnq1nITMU7sYEmIHiX3BNYaCFIhJFR1raohHv4Pv4v
        OLIrnO/vRxwrKB00MlAYODOz7F6WgPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-etlBzSY0Mw-JCDu5_rnuvA-1; Mon, 07 Sep 2020 08:45:23 -0400
X-MC-Unique: etlBzSY0Mw-JCDu5_rnuvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29494107465A;
        Mon,  7 Sep 2020 12:45:21 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79DE227C29;
        Mon,  7 Sep 2020 12:45:11 +0000 (UTC)
Date:   Mon, 7 Sep 2020 14:45:08 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        brouer@redhat.com,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH bpf-next 3/6] xsk: introduce xsk_do_redirect_rx_full()
 helper
Message-ID: <20200907144508.3ddda938@carbon>
In-Reply-To: <dfa75afc-ceb7-76ce-6ba3-3b89c53f92f3@intel.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904135332.60259-4-bjorn.topel@gmail.com>
        <20200904171143.5868999a@carbon>
        <dfa75afc-ceb7-76ce-6ba3-3b89c53f92f3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 17:39:17 +0200
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:

> On 2020-09-04 17:11, Jesper Dangaard Brouer wrote:
> > On Fri,  4 Sep 2020 15:53:28 +0200 Bj=C3=B6rn T=C3=B6pel
> > <bjorn.topel@gmail.com> wrote:
> >  =20
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>=20
> >> The xsk_do_redirect_rx_full() helper can be used to check if a
> >> failure of xdp_do_redirect() was due to the AF_XDP socket had a
> >> full Rx ring. =20
> >=20
> > This is very AF_XDP specific.  I think that the cpumap could likely=20
> > benefit from similar approach? e.g. if the cpumap kthread is
> > scheduled on the same CPU.
> >  =20
>=20
> At least I thought this was *very* AF_XDP specific, since the kernel is
> dependent of that userland runs. Allocation (source) and Rx ring (sink).
> Maybe I was wrong! :-)
>=20
> The thing with AF_XDP zero-copy, is that we sort of assume that if a
> user enabled that most packets will have XDP_REDIRECT to an AF_XDP socket.
>=20
>=20
> > But for cpumap we only want this behavior if sched on the same CPU
> > as RX-NAPI.  This could be "seen" by the cpumap code itself in the
> > case bq_flush_to_queue() drops packets, check if rcpu->cpu equal=20
> > smp_processor_id().  Maybe I'm taking this too far?
> >  =20
>=20
> Interesting. So, if you're running on the same core, and redirect fail
> for CPUMAP, you'd like to yield the NAPI loop? Is that really OK from a
> fairness perspective? I mean, with AF_XDP zero-copy we pretty much know
> that all actions will be redirect to socket. For CPUMAP type of
> applications, can that assumption be made?

Yes, you are right.  The RX NAPI loop could be doing something else,
and yielding the NAPI loop due to detecting same-CPU is stalling on
cpumap delivery might not be correct action.

I just tested the same-CPU processing case for cpumap (result below
signature), and it doesn't exhibit the bad 'dropping-off-edge'
performance slowdown.  The cpumap code also already tries to mitigate
this, by calling wake_up_process() for every 8 packets (CPU_MAP_BULK_SIZE).

I find your patchset very interesting, as I believe we do need some
kind of general push-back "flow-control" mechanism for XDP. Maybe I
should solve this differently in our XDP-TX-QoS pipe dream ;-)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

Quick benchmark of cpumap.


Same CPU RX and cpumap processing:
----------------------------------

(Doing XDP_DROP on CPU)
Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          4       9,189,700      0           0         =20
XDP-RX          total   9,189,700      0         =20
cpumap-enqueue    4:4   9,189,696      0           8.00       bulk-average
cpumap-enqueue  sum:4   9,189,696      0           8.00       bulk-average
cpumap_kthread  4       9,189,702      0           143,582    sched
cpumap_kthread  total   9,189,702      0           143,582    sched-sum
redirect_err    total   0              0         =20
xdp_exception   total   0              0         =20

2nd remote XDP/eBPF prog_name: xdp1
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  4       0              9,189,702   0        =20
xdp-in-kthread  total   0              9,189,702   0        =20

 %CPU
 51,8 ksoftirqd/4                      =20
 48,2 cpumap/4/map:17                  =20


(Doing XDP_PASS on CPU)
Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          4       8,593,822      0           0         =20
XDP-RX          total   8,593,822      0         =20
cpumap-enqueue    4:4   8,593,888      7,714,949   8.00       bulk-average
cpumap-enqueue  sum:4   8,593,888      7,714,949   8.00       bulk-average
cpumap_kthread  4       878,930        0           13,732     sched
cpumap_kthread  total   878,930        0           13,732     sched-sum
redirect_err    total   0              0         =20
xdp_exception   total   0              0         =20

2nd remote XDP/eBPF prog_name: xdp_redirect_dummy
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  4       878,931        0           0        =20
xdp-in-kthread  total   878,931        0           0        =20



Another CPU getting cpumap redirected packets:
----------------------------------------------

(Doing XDP_DROP on CPU)
Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          4       17,526,797     0           0         =20
XDP-RX          total   17,526,797     0         =20
cpumap-enqueue    4:0   17,526,796     245,811     8.00       bulk-average
cpumap-enqueue  sum:0   17,526,796     245,811     8.00       bulk-average
cpumap_kthread  0       17,281,001     0           16,351     sched
cpumap_kthread  total   17,281,001     0           16,351     sched-sum
redirect_err    total   0              0         =20
xdp_exception   total   0              0         =20

2nd remote XDP/eBPF prog_name: xdp1
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  0       0              17,281,001  0        =20
xdp-in-kthread  total   0              17,281,001  0        =20


(Doing XDP_PASS on CPU)
Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          4       14,603,587     0           0         =20
XDP-RX          total   14,603,587     0         =20
cpumap-enqueue    4:0   14,603,582     12,999,248  8.00       bulk-average
cpumap-enqueue  sum:0   14,603,582     12,999,248  8.00       bulk-average
cpumap_kthread  0       1,604,338      0           0         =20
cpumap_kthread  total   1,604,338      0           0         =20
redirect_err    total   0              0         =20
xdp_exception   total   0              0         =20

2nd remote XDP/eBPF prog_name: xdp_redirect_dummy
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  0       1,604,338      0           0        =20
xdp-in-kthread  total   1,604,338      0           0        =20






