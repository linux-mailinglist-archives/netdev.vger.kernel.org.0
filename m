Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3BF45CA0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfFNMUa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 08:20:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfFNMUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 08:20:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B7C52F8BFD;
        Fri, 14 Jun 2019 12:20:25 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5BF467261;
        Fri, 14 Jun 2019 12:20:11 +0000 (UTC)
Date:   Fri, 14 Jun 2019 14:20:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying
 map
Message-ID: <20190614142009.3922795a@carbon>
In-Reply-To: <877e9octre.fsf@toke.dk>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
        <20190614082015.23336-2-toshiaki.makita1@gmail.com>
        <877e9octre.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 12:20:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:04:53 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
> 
> > dev_map_free() waits for flush_needed bitmap to be empty in order to
> > ensure all flush operations have completed before freeing its entries.
> > However the corresponding clear_bit() was called before using the
> > entries, so the entries could be used after free.
> >
> > All access to the entries needs to be done before clearing the bit.
> > It seems commit a5e2da6e9787 ("bpf: netdev is never null in
> > __dev_map_flush") accidentally changed the clear_bit() and memory access
> > order.
> >
> > Note that the problem happens only in __dev_map_flush(), not in
> > dev_map_flush_old(). dev_map_flush_old() is called only after nulling
> > out the corresponding netdev_map entry, so dev_map_free() never frees
> > the entry thus no such race happens there.
> >
> > Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
> > Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>  
> 
> I recently posted a patch[0] that gets rid of the bitmap entirely, so I
> think you can drop this one...

One could argue that this is a stable tree fix... which unfortunately
will cause some pain for your patch.  Or maybe for the maintainers, as
this is for 'bpf' git-tree and your patch is for 'bpf-next' git-tree.

 
> [0] https://lore.kernel.org/netdev/156042464148.25684.11881534392137955942.stgit@alrua-x1/

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
