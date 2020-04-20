Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEB31B0466
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDTI3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgDTI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 04:29:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7033C061A0C;
        Mon, 20 Apr 2020 01:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IqO0rH/XwB4jj2Xbm/MnV+bQAuc82OBA3N+hT9MUMh0=; b=d2qXA6v+SNk5E4HWTuJcwW6zBn
        DB1oSYdGQF1W4KKLZf9Ds+4wUNsRVg365/r3rjS/0JSpP8Vsh4xWwpOBUjf1/vp3uslgkQN80gG6h
        yMBJFQ1pwH9iKLSriw3RG73+stuI6syQo8t9T0BIp4KRaBcmjYmKuwg4LqryDDL2X2fYVyXIRkUl0
        7WaB1Z+4BzMMXn3uzsNjSpRav6VqCOwDAi5ZAjUAwF/5JAuEDpOqmS86f2gPR940LS5e+0fOlAnMS
        Ml+O+FzmAu+Pqptaid6xzcjqQEpgnjNFfs9zpfvZ/LME9fc+V1v+1WJZLxJk1eX42+EGk5JwdGlGe
        /iRiWEhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQRnh-0002G7-Jz; Mon, 20 Apr 2020 08:29:09 +0000
Date:   Mon, 20 Apr 2020 01:29:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vhost: disable for OABI
Message-ID: <20200420082909.GA28749@infradead.org>
References: <20200416221902.5801-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416221902.5801-1-mst@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 06:20:20PM -0400, Michael S. Tsirkin wrote:
> vhost is currently broken on the some ARM configs.
> 
> The reason is that that uses apcs-gnu which is the ancient OABI that is been
> deprecated for a long time.
> 
> Given that virtio support on such ancient systems is not needed in the
> first place, let's just add something along the lines of
> 
> 	depends on !ARM || AEABI
> 
> to the virtio Kconfig declaration, and add a comment that it has to do
> with struct member alignment.
> 
> Note: we can't make VHOST and VHOST_RING themselves have
> a dependency since these are selected. Add a new symbol for that.

This description is horrible.  The only interesting thing for ARM OABI
is that it has some strange padding rules, but that isn't something
that can't be handled.   Please spend some time looking into the issue
and add te proper __padded annotations, we've done that elsewhere in
the kernel and it isn't too bad - in fact it helps understanding issues
with implicit alignment.

And even if you have a good reason not to fix vhost (which I think you
don't have) this changelog is just utter crap, as it fails to mention
what the problem with ARM OABI even is.
