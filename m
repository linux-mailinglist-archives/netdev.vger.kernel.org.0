Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517BA2C88A5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgK3Pya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgK3Pya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:54:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0292DC0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 07:53:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kjlUk-00026K-Ha; Mon, 30 Nov 2020 16:53:42 +0100
Date:   Mon, 30 Nov 2020 16:53:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Race] data race between eth_heder_cache_update() and
 neigh_hh_output()
Message-ID: <20201130155342.GK2730@breakpoint.cc>
References: <8B318E86-EED9-4EFE-A921-678532F36BBD@purdue.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B318E86-EED9-4EFE-A921-678532F36BBD@purdue.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gong, Sishuai <sishuai@purdue.edu> wrote:
> Hi,
> 
> We found a data race in linux kernel 5.3.11 that we are able to reproduce in x86 under specific interleavings. We are not sure about the consequence of this race now but it seems that the two memcpy() can lead to some inconsistency. We also noticed that both the writer and reader are protected by locks, but the writer is protected using seqlock while the reader is protected by rculock.

AFAICS reader uses same seqlock as the writer.

> ------------------------------------------
> Write site
> 
>  /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/ethernet/eth.c:264
>         252  /**
>         253   * eth_header_cache_update - update cache entry
>         254   * @hh: destination cache entry
>         255   * @dev: network device
>         256   * @haddr: new hardware address
>         257   *
>         258   * Called by Address Resolution module to notify changes in address.
>         259   */
>         260  void eth_header_cache_update(struct hh_cache *hh,
>         261                   const struct net_device *dev,
>         262                   const unsigned char *haddr)
>         263  {
>  ==>    264      memcpy(((u8 *) hh->hh_data) + HH_DATA_OFF(sizeof(struct ethhdr)),
>         265             haddr, ETH_ALEN);

This is called under write_seqlock_bh(hh->hh_lock)

> /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/include/net/neighbour.h:481
>         463  static inline int neigh_hh_output(const struct hh_cache *hh, struct sk_buff *skb)
>         464  {
>         465      unsigned int hh_alen = 0;
>         466      unsigned int seq;
>         467      unsigned int hh_len;
>         468
>         469      do {
>         470          seq = read_seqbegin(&hh->hh_lock); 

This samples the seqcount.

>         471          hh_len = hh->hh_len;
>         472          if (likely(hh_len <= HH_DATA_MOD)) {
>         473              hh_alen = HH_DATA_MOD;
>         474
>         475              /* skb_push() would proceed silently if we have room for
>         476               * the unaligned size but not for the aligned size:
>         477               * check headroom explicitly.
>         478               */
>         479              if (likely(skb_headroom(skb) >= HH_DATA_MOD)) {
>         480                  /* this is inlined by gcc */
>  ==>    481                  memcpy(skb->data - HH_DATA_MOD, hh->hh_data,
>         482                         HH_DATA_MOD);

[..]

>         492      } while (read_seqretry(&hh->hh_lock, seq));

... so this retries unless seqcount was stable.
