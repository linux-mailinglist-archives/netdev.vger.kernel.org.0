Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561D924E27A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHUVOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:14:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D146C061573;
        Fri, 21 Aug 2020 14:14:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFB02128A448B;
        Fri, 21 Aug 2020 13:57:14 -0700 (PDT)
Date:   Fri, 21 Aug 2020 14:14:00 -0700 (PDT)
Message-Id: <20200821.141400.594703865403700191.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, colyli@suse.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bypass ->sendpage for slab pages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820043744.GA4349@lst.de>
References: <20200819051945.1797088-1-hch@lst.de>
        <20200819.120709.1311664171016372891.davem@davemloft.net>
        <20200820043744.GA4349@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 13:57:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 20 Aug 2020 06:37:44 +0200

> If you look at who uses sendpage outside the networking layer itself
> you see that it is basically block driver and file systems.  These
> have no way to control what memory they get passed and have to deal
> with everything someone throws at them.

I see nvme doing virt_to_page() on several things when it calls into
kernel_sendpage().

This is the kind of stuff I want cleaned up, and which your patch
will not trap nor address.

In nvme it sometimes seems to check for sendpage validity:

		/* can't zcopy slab pages */
		if (unlikely(PageSlab(page))) {
			ret = sock_no_sendpage(queue->sock, page, offset, len,
					flags);
		} else {
			ret = kernel_sendpage(queue->sock, page, offset, len,
					flags);
		}

Yet elsewhere does not and just blindly calls:

	ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
			offset_in_page(pdu) + req->offset, len,  flags);

This pdu seems to come from a page frag allocation.

That's the target side.  On the host side:

		ret = kernel_sendpage(cmd->queue->sock, page, cmd->offset,
					left, flags);

No page slab check or anything like that.

I'm hesitent to put in the kernel_sendpage() patch, becuase it provides a
disincentive to fix up code like this.

