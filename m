Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F002726BD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgIUOO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUOO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:14:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15997C061755;
        Mon, 21 Sep 2020 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RzCz3Hermh11g+4+9HQSN0gxkYmQOxNMb82UklyV/D8=; b=X89tFZkHHutrGPYkvoSk4Kz0qQ
        JG3bqlwLSyVOUUOFD6UwejdupLufHuJ/xtx/A40S0C4pNjTOLNS5jXvC4mrkf1kPkI7EzrRsnubVI
        fcUzwGJLcwQeWGkv22/a9BnaNabrfu/scT8kDCKo5YelvVeXuRl69Z/AiyVPmUm/pilBqL/zAckf1
        l2w498wY3BO+wodQnnjK4f5/HAOs03CBtty2vmAUsO9vl0DTK7gXxyHJfZabZlik0IZuXL2v7D7nf
        Wd9k2lEO+AZYlfiz4AEfiphuf5irVMEl+kaHH2bxnli4ylDdATpeksPU/K1UFUn4c0FFUIfUrYuoe
        mgxxYk3g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMam-0006jJ-IF; Mon, 21 Sep 2020 14:14:56 +0000
Date:   Mon, 21 Sep 2020 15:14:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Message-ID: <20200921141456.GD24515@infradead.org>
References: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 02:55:20PM +0000, David Laight wrote:
> 
> This is the only code that relies on import_iovec() returning
> iter.count on success.
> This allows a better interface to import_iovec().

This looks generall sane, but a comment below:

> @@ -3123,7 +3123,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  	if (ret < 0)
>  		return ret;
>  	iov_count = iov_iter_count(iter);
> -	io_size = ret;
> +	io_size = iov_count;
>  	req->result = io_size;
>  	ret = 0;
>  
> @@ -3246,7 +3246,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  	if (ret < 0)
>  		return ret;
>  	iov_count = iov_iter_count(iter);
> -	io_size = ret;
> +	io_size = iov_count;
>  	req->result = io_size;

I tink the local iov_count variable can go away in both functions,
as io_size only changes after the last use of iov_count (io_read) or
not at all (io_write).
