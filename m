Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB30C2726A5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgIUOJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIUOJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:09:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB4EC061755;
        Mon, 21 Sep 2020 07:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5z+nT9DLNYpnZdX2p/A/Uj6Iw3m/Dm3X+A2sRHM2Sw8=; b=YCvsJ8QAivd0kiBxMhH8zI6ld2
        dxecllp2hObiTjswAkaOEPy4nIaOSt7eKX1MkZBSl/byZKc4E803ZZH5062ZYKnW+V73XhKHdxeK4
        tjrWzyJO7lVKQb+vA9iKuvghqZX912IlsuF0xxclpn7MYfFcvM47OPWuBpfbE+GNzhugw18XimuNl
        1CoNaLxpAHeH3+AKoM+75id0MvySxR2b5SDaenlEQH/kKBQZ8m3iRuHufHLZwGg4XPS3BqTDcpLjA
        p+N3BlfPxibCFwCPNRyEUWdqL+XjU96GIKxa6yTX0zjTmhY6TvsQCtPp3j3qczEIsScdy8LSoMEL/
        N9P5tkkA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMVb-0006QJ-O3; Mon, 21 Sep 2020 14:09:35 +0000
Date:   Mon, 21 Sep 2020 15:09:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/9 next] mm:process_vm_access Call import_iovec()
 instead of rw_copy_check_uvector()
Message-ID: <20200921140935.GA24515@infradead.org>
References: <e47d19f9c946423db88de10b4753ecfb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e47d19f9c946423db88de10b4753ecfb@AcuMS.aculab.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 02:55:08PM +0000, David Laight wrote:
> 
> This is the only direct call of rw_copy_check_uvector().
> Removing it lets rw_copy_check_uvector() be inlined into
> import_iovec() and the horrid calling conventions fixed.

This looks sensible, but as-is will create a warning when actually
this code.

This is the variant I picked up as a prep patch for the compat
iovec handling, which passes the relevant LTP tests:

http://git.infradead.org/users/hch/misc.git/commitdiff/9e3cf5d0f13572310354bf6c62e1feb9fb232266
