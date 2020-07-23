Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC56122B1BA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgGWOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:45:03 -0400
Received: from verein.lst.de ([213.95.11.211]:60533 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWOpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 10:45:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7138C68AFE; Thu, 23 Jul 2020 16:44:55 +0200 (CEST)
Date:   Thu, 23 Jul 2020 16:44:55 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>
Subject: Re: [PATCH 03/26] bpfilter: reject kernel addresses
Message-ID: <20200723144455.GA12280@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-4-hch@lst.de> <c3dc5b4d84e64230bb6ca8df7bb70705@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3dc5b4d84e64230bb6ca8df7bb70705@AcuMS.aculab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 02:42:11PM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 23 July 2020 07:09
> > 
> > The bpfilter user mode helper processes the optval address using
> > process_vm_readv.  Don't send it kernel addresses fed under
> > set_fs(KERNEL_DS) as that won't work.
> 
> What sort of operations is the bpf filter doing on the sockopt buffers?
> 
> Any attempts to reject some requests can be thwarted by a second
> application thread modifying the buffer after the bpf filter has
> checked that it allowed.
> 
> You can't do security by reading a user buffer twice.

I'm not saying that I approve of the design, but the current bpfilter
design uses process_vm_readv to access the buffer, which obviously does
not work with kernel buffers.
