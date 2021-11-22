Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636C8458F2F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhKVNPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhKVNPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 08:15:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E287C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 05:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=pd3ku2EsZwytjxQy3CTDRoL9cusJNqDhOaOS8v5owp0=; b=fC40NZOL4tpudq27IHkrsRtVZH
        thiQi0g5m+73lVjxChggtp1J3EJmLOHORNYihGa0+oNesNXXa6C+7x2kR4bcYKXvysTYDLH5SQwek
        ++ItgdapyP+qydtLTJDSEWVsEmkJBzC70tb9MqsX48880k7pJZ+7hdSGZV5jw6E5wfodHr6Az0bvv
        YppyexYKZWGtVX4p5jaME/LKKhywv+FAzaU6vU3S4fkG+/BSupMBK/O3euxHq9TUqYPohHgt4wFMG
        gAAXY+fvEyiz310GK/VGxQNjC+XN09E64BY1gH7IMQ2fD34p8w4Mn8M8bPs+udilXhYJDmF6OJZQk
        METXFsVA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp96u-00Cs5v-BS; Mon, 22 Nov 2021 13:11:52 +0000
Date:   Mon, 22 Nov 2021 13:11:52 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
Message-ID: <YZuXGBdRpAXTfONP@casper.infradead.org>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
 <YZs1p+lkKO+194zN@kroah.com>
 <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
 <YZtHOfdn4HQdF3LD@kroah.com>
 <9652c9dd6b6238922f45ee71cf341cac88449b98.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9652c9dd6b6238922f45ee71cf341cac88449b98.camel@codeconstruct.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 04:23:10PM +0800, Jeremy Kerr wrote:
> Hi Greg,
> 
> > ida_destroy() will not be a no-op if you have allocated some things
> > in the past.  It should always be called when your module is removed.
> > 
> > Or at least that is how it used to be, if this has changed in the
> > past year, then I am mistaken here.

I think Greg is remembering how the IDA behaved before it was converted
to use the radix tree back in 2016 (0a835c4f090a).  About two-thirds
of the users of the IDA and IDR forgot to call ida_destroy/idr_destroy,
so rather than fix those places, I decided to make those data structures
no longer require a destructor.

> I was going by this bit of the comment on ida_destroy:
> 
>    * Calling this function frees all IDs and releases all resources used
>    * by an IDA.  When this call returns, the IDA is empty and can be reused
>    * or freed.  If the IDA is already empty, there is no need to call this
>    * function.
> 
> [From a documentation improvement in 50d97d50715]
> 
> Looking at ida_destroy, it's iterating the xarray and freeing all !value
> entries. ida_free will free a (allocated) value entry once all bits are
> clear, so the comment looks correct to me - there's nothing left to free
> if the ida is empty.
> 
> However, I'm definitely no ida/idr/xarray expert! Happy to be corrected
> here - and I'll send a patch to clarify that comment too, if so.
> 
> Cheers,
> 
> 
> Jeremy
> 
