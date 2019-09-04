Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE09A7ABF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 07:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfIDFcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 01:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfIDFcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 01:32:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5D7810277E2;
        Wed,  4 Sep 2019 05:32:09 +0000 (UTC)
Received: from astarta.redhat.com (ovpn-116-92.ams2.redhat.com [10.36.116.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C6A31001DC0;
        Wed,  4 Sep 2019 05:32:08 +0000 (UTC)
From:   Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf 2/2] libbpf: remove dependency on barrier.h in xsk.h
References: <1554792253-27081-1-git-send-email-magnus.karlsson@intel.com>
        <1554792253-27081-3-git-send-email-magnus.karlsson@intel.com>
Date:   Wed, 04 Sep 2019 08:32:06 +0300
In-Reply-To: <1554792253-27081-3-git-send-email-magnus.karlsson@intel.com>
        (Magnus Karlsson's message of "Tue, 9 Apr 2019 08:44:13 +0200")
Message-ID: <xunyo9007hk9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 04 Sep 2019 05:32:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Magnus!

>>>>> On Tue,  9 Apr 2019 08:44:13 +0200, Magnus Karlsson  wrote:

 > The use of smp_rmb() and smp_wmb() creates a Linux header dependency
 > on barrier.h that is uneccessary in most parts. This patch implements
 > the two small defines that are needed from barrier.h. As a bonus, the
 > new implementations are faster than the default ones as they default
 > to sfence and lfence for x86, while we only need a compiler barrier in
 > our case. Just as it is when the same ring access code is compiled in
 > the kernel.

 > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
 > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
 > ---
 >  tools/lib/bpf/xsk.h | 19 +++++++++++++++++--
 >  1 file changed, 17 insertions(+), 2 deletions(-)

 > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
 > index 3638147..317b44f 100644
 > --- a/tools/lib/bpf/xsk.h
 > +++ b/tools/lib/bpf/xsk.h
 > @@ -39,6 +39,21 @@ DEFINE_XSK_RING(xsk_ring_cons);
 >  struct xsk_umem;
 >  struct xsk_socket;
 
 > +#if !defined bpf_smp_rmb && !defined bpf_smp_wmb
 > +# if defined(__i386__) || defined(__x86_64__)
 > +#  define bpf_smp_rmb() asm volatile("" : : : "memory")
 > +#  define bpf_smp_wmb() asm volatile("" : : : "memory")
 > +# elif defined(__aarch64__)
 > +#  define bpf_smp_rmb() asm volatile("dmb ishld" : : : "memory")
 > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
 > +# elif defined(__arm__)
 > +#  define bpf_smp_rmb() asm volatile("dmb ish" : : : "memory")
 > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
 > +# else
 > +#  error Architecture not supported by the XDP socket code in libbpf.
 > +# endif
 > +#endif
 > +

What about other architectures then?


 >  static inline __u64 *xsk_ring_prod__fill_addr(struct xsk_ring_prod *fill,
 >  					      __u32 idx)
 >  {
 > @@ -119,7 +134,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
 >  	/* Make sure everything has been written to the ring before signalling
 >  	 * this to the kernel.
 >  	 */
 > -	smp_wmb();
 > +	bpf_smp_wmb();
 
 >  	*prod->producer += nb;
 >  }
 > @@ -133,7 +148,7 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
 >  		/* Make sure we do not speculatively read the data before
 >  		 * we have received the packet buffers from the ring.
 >  		 */
 > -		smp_rmb();
 > +		bpf_smp_rmb();
 
 >  		*idx = cons->cached_cons;
 cons-> cached_cons += entries;
 > -- 
 > 2.7.4


-- 
WBR,
Yauheni Kaliuta
