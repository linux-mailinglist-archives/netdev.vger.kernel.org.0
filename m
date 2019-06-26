Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98B257223
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFZUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:00:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZUA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 16:00:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F23EDC07F9A6;
        Wed, 26 Jun 2019 20:00:47 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D18A1001DEF;
        Wed, 26 Jun 2019 20:00:30 +0000 (UTC)
Date:   Wed, 26 Jun 2019 22:00:28 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>,
        "Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org, brouer@redhat.com
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Message-ID: <20190626220028.2bb12196@carbon>
In-Reply-To: <99AFC1EE-E27E-4D4D-B9B8-CA2215E68E1B@gmail.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
        <20190623162133.6b7f24e1@carbon>
        <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
        <20190626103829.5360ef2d@carbon>
        <87a7e4d0nj.fsf@toke.dk>
        <20190626164059.4a9511cf@carbon>
        <87h88cbdbe.fsf@toke.dk>
        <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
        <99AFC1EE-E27E-4D4D-B9B8-CA2215E68E1B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 26 Jun 2019 20:00:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 26 Jun 2019 09:42:07 -0700 "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> If all packets are collected together (like the bulk queue does), and 
> then passed to XDP, this could easily be made backwards compatible.
> If the XDP program isn't 'multi-frag' aware, then each packet is just
> passed in individually.

My proposal#1 is XDP only access first-buffer[1], as this simplifies things.

(AFAIK) What you are proposing is that all the buffers are passed to
the XDP prog (in form of a iovec).  I need some more details about your
suggestion.

Specifically:

- What is the semantic when a 3 buffer packet is input and XDP prog
choose to return XDP_DROP for packet #2 ?

- Same situation of packet #2 wants a XDP_TX or redirect?


> Of course, passing in the equivalent of a iovec requires some form of 
> loop support on the BPF side, doesn't it?

The data structure used for holding these packet buffers/segments also
needs to be discussed.  I would either use an array of bio_vec[2] or
skb_frag_t (aka skb_frag_struct).  The skb_frag_t would be most
obvious, as we already have to write this when creating an SKB, in
skb_shared_info area. (Structs listed below signature).

The problem is also that size of these structs (16 bytes) per
buffer/segment, and we likely need to support 17 segments, as this need
to be compatible with SKBs (size 272 bytes).

My idea here is that we simply use the same memory area, that we have to
store skb_shared_info into.  As this allow us to get the SKB setup for
free, when doing XDP_PASS or when doing SKB alloc after XDP_REDIRECT.


[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#proposal1-xdp-only-access-first-buffer

[2] https://lore.kernel.org/netdev/20190501041757.8647-1-willy@infradead.org/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


$ pahole -C skb_frag_struct vmlinux
struct skb_frag_struct {
	struct {
		struct page * p;                         /*     0     8 */
	} page;                                          /*     0     8 */
	__u32                      page_offset;          /*     8     4 */
	__u32                      size;                 /*    12     4 */

	/* size: 16, cachelines: 1, members: 3 */
	/* last cacheline: 16 bytes */
};

$ pahole -C bio_vec vmlinux
struct bio_vec {
	struct page        * bv_page;                    /*     0     8 */
	unsigned int               bv_len;               /*     8     4 */
	unsigned int               bv_offset;            /*    12     4 */

	/* size: 16, cachelines: 1, members: 3 */
	/* last cacheline: 16 bytes */
};

$ pahole -C skb_shared_info vmlinux
struct skb_shared_info {
	__u8                       __unused;             /*     0     1 */
	__u8                       meta_len;             /*     1     1 */
	__u8                       nr_frags;             /*     2     1 */
	__u8                       tx_flags;             /*     3     1 */
	short unsigned int         gso_size;             /*     4     2 */
	short unsigned int         gso_segs;             /*     6     2 */
	struct sk_buff     * frag_list;                  /*     8     8 */
	struct skb_shared_hwtstamps hwtstamps;           /*    16     8 */
	unsigned int               gso_type;             /*    24     4 */
	u32                        tskey;                /*    28     4 */
	atomic_t                   dataref;              /*    32     0 */

	/* XXX 8 bytes hole, try to pack */

	void *                     destructor_arg;       /*    40     8 */
	skb_frag_t                 frags[17];            /*    48   272 */

	/* size: 320, cachelines: 5, members: 13 */
	/* sum members: 312, holes: 1, sum holes: 8 */
};
