Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF568214
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 03:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfGOBkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 21:40:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:49194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbfGOBkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jul 2019 21:40:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E36C0AF0F;
        Mon, 15 Jul 2019 01:40:22 +0000 (UTC)
Date:   Mon, 15 Jul 2019 10:40:16 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/16] qlge: Remove irq_cnt
Message-ID: <20190715014016.GA27883@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/17 16:48, Benjamin Poirier wrote:
> qlge uses an irq enable/disable refcounting scheme that is:
> * poorly implemented
> 	Uses a spin_lock to protect accesses to the irq_cnt atomic variable
> * buggy
> 	Breaks when there is not a 1:1 sequence of irq - napi_poll, such as
> 	when using SO_BUSY_POLL.
> * unnecessary
> 	The purpose or irq_cnt is to reduce irq control writes when
> 	multiple work items result from one irq: the irq is re-enabled
> 	after all work is done.
> 	Analysis of the irq handler shows that there is only one case where
> 	there might be two workers scheduled at once, and those have
> 	separate irq masking bits.
> 
> Therefore, remove irq_cnt.
> 
> Additionally, we get a performance improvement:
> perf stat -e cycles -a -r5 super_netperf 100 -H 192.168.33.1 -t TCP_RR
> 
> Before:
> 628560
> 628056
> 622103
> 622744
> 627202
> [...]
>    268,803,947,669      cycles                 ( +-  0.09% )
> 
> After:
> 636300
> 634106
> 634984
> 638555
> 634188
> [...]
>    259,237,291,449      cycles                 ( +-  0.19% )
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>

David, Greg,

Before I send v2 of this patchset, how about moving this driver out to
staging? The hardware has been declared EOL by the vendor but what's
more relevant to the Linux kernel is that the quality of this driver is
not on par with many other mainline drivers, IMO. Over in staging, the
code might benefit from the attention of interested parties (drive-by
fixers) or fade away into obscurity.

Now that I check, the code has >500 basic checkpatch issues. While
working on the rx processing code for the current patchset, I noticed
the following more structural issues:
* commit 7c734359d350 ("qlge: Size RX buffers based on MTU.",
  v2.6.33-rc1) introduced dead code in the receive routines, which
  should be rewritten anyways by the admission of the author himself
  (see the comment above ql_build_rx_skb())
* truesize accounting is incorrect (ex: a 9000B frame has truesize 10280
  while containing two frags of order-1 allocations, ie. >16K)
* in some cases the driver allocates skbs with head room but only puts
  data in the frags
* there is an inordinate amount of disparate debugging code, most of
  which is of questionable value. In particular, qlge_dbg.c has hundreds
  of lines of code bitrotting away in ifdef land (doesn't compile since
  commit 18c49b91777c ("qlge: do vlan cleanup", v3.1-rc1), 8 years ago).
* triggering an ethtool regdump will instead hexdump a 176k struct to
  dmesg depending on some module parameters
* many structures are defined full of holes, as we found in this
  thread already; are used inefficiently (struct rx_ring is used for rx
  and tx completions, with some members relevant to one case only); are
  initialized redundantly (ex. memset 0 after alloc_etherdev). The
  driver also has a habit of using runtime checks where compile time
  checks are possible.
* in terms of namespace, the driver uses either qlge_, ql_ (used by
  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
  clashes, ex: struct ob_mac_iocb_req)

I'm guessing other parts of the driver have more issues of the same
nature. The driver also has many smaller issues like deprecated apis,
duplicate or useless comments, weird code structure (some "while" loops
that could be rewritten with simple "for", ex. ql_wait_reg_rdy()) and
weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
qlge_set_multicast_list()).

I'm aware of some precedents for code moving from mainline to staging:
1bb8155080c6 ncpfs: move net/ncpfs to drivers/staging/ncpfs (v4.16-rc1)
6c391ff758eb irda: move drivers/net/irda to drivers/staging/irda/drivers
(v4.14-rc1)

What do you think is the best course of action in this case?

Thanks,
-Benjamin
