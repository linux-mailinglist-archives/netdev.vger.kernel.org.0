Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A02342FD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 11:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfFDJQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 05:16:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfFDJQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 05:16:01 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D27393091D73;
        Tue,  4 Jun 2019 09:15:59 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26750105B202;
        Tue,  4 Jun 2019 09:15:55 +0000 (UTC)
Date:   Tue, 4 Jun 2019 11:15:54 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tom Barbette <barbette@kth.se>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Bad XDP performance with mlx5
Message-ID: <20190604111554.749ddd87@carbon>
In-Reply-To: <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
        <20190529191602.71eb6c87@carbon>
        <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
        <20190530094053.364b1147@carbon>
        <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
        <20190531181817.34039c9f@carbon>
        <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
        <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 04 Jun 2019 09:16:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 09:28:22 +0200
Tom Barbette <barbette@kth.se> wrote:

> Thanks Jesper for looking into this!
> 
> I don't think I will be of much help further on this matter. My take
> out would be: as a first-time user looking into XDP after watching a
> dozen of XDP talks, I would have expected XDP default settings to be
> identical to SKB, so I don't have to watch out for a set of
> per-driver parameter checklist to avoid increasing my CPU consumption
> by 15% when inserting "a super efficient and light BPF program". But
> I understand it's not that easy...

The gap should not be this large, but as I demonstrated it was primarily
because you hit an unfortunate interaction with TCP and how the mlx5
driver does page-caching (p.s. we are working on removing this driver
local recycle-cache).
  When loading an XDP/eBPF-prog then the driver change the underlying RX
memory model, which waste memory to gain packets-per-sec speed, but TCP
sees this memory waste and gives us a penalty.

It is important to understand, that XDP is not optimized for TCP.  XDP
is designed and optimized for L2-L3 handling of packets (TCP is L4).
Before XDP these L2-L3 use-cases were "slow", because the kernel
netstack assumes a L4/socket use-case (full SKB), when less was really
needed.

This is actually another good example of why XDP programs per RX-queue,
will be useful (notice: which is not implemented upstream, yet...).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
