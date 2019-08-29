Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD11A2952
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfH2WBB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 18:01:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:50518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727969AbfH2WBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 18:01:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6404BAEFB;
        Thu, 29 Aug 2019 22:00:59 +0000 (UTC)
Date:   Fri, 30 Aug 2019 00:00:58 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 05/15] net: sgi: ioc3-eth: allocate space
 for desc rings only once
Message-Id: <20190830000058.882feb357058437cddc71315@suse.de>
In-Reply-To: <20190829140537.68abfc9f@cakuba.netronome.com>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
        <20190829155014.9229-6-tbogendoerfer@suse.de>
        <20190829140537.68abfc9f@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 14:05:37 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Thu, 29 Aug 2019 17:50:03 +0200, Thomas Bogendoerfer wrote:
> > +		if (skb)
> > +			dev_kfree_skb_any(skb);
> 
> I think dev_kfree_skb_any() accepts NULL

yes, I'll drop the if

> > +
> > +	/* Allocate and rx ring.  4kb = 512 entries  */
> > +	ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
> > +	if (!ip->rxr) {
> > +		pr_err("ioc3-eth: rx ring allocation failed\n");
> > +		err = -ENOMEM;
> > +		goto out_stop;
> > +	}
> > +
> > +	/* Allocate tx rings.  16kb = 128 bufs.  */
> > +	ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
> > +	if (!ip->txr) {
> > +		pr_err("ioc3-eth: tx ring allocation failed\n");
> > +		err = -ENOMEM;
> > +		goto out_stop;
> > +	}
> 
> Please just use kcalloc()/kmalloc_array() here,

both allocation will be replaced in patch 11 with dma_direct_alloc_pages.
So I hope I don't need to change it here.

Out of curiosity does kcalloc/kmalloc_array give me the same guarantees about
alignment ? rx ring needs to be 4KB aligned, tx ring 16KB aligned.

>, and make sure the flags
> are set to GFP_KERNEL whenever possible. Here and in ioc3_alloc_rings()
> it looks like GFP_ATOMIC is unnecessary.

yes, I'll change it

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
