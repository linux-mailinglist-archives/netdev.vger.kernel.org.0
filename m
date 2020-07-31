Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF3233EB0
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 07:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgGaFdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 01:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbgGaFdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 01:33:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76248208E4;
        Fri, 31 Jul 2020 05:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596173590;
        bh=Ey9Sbx63l35tpZRAlTqbhj39QlhEfAk6lnnRJ0GbmKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFeznJvlJLIKGU7a+xR/vPryMW1/HRaqLnnUF8/Qo9g6GwLSGNzszKYgVuTEhqbG6
         0/R1y0qxc/7LAYy7huXZwxN+Y9gTkHmcNjKtknfvJBjTzGimo7HvXBtoTBhj+Fgb1a
         vbwF4a5Fi9jQ/BLnkYOhKx9ZOxfSppQidXBY8AvU=
Date:   Fri, 31 Jul 2020 07:33:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731053306.GA466103@kroah.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731045301.GI75549@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> > rds_notify_queue_get() is potentially copying uninitialized kernel stack
> > memory to userspace since the compiler may leave a 4-byte hole at the end
> > of `cmsg`.
> >
> > In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> > unfortunately does not always initialize that 4-byte hole. Fix it by using
> > memset() instead.
> 
> Of course, this is the difference between "{ 0 }" and "{}" initializations.

Really?  Neither will handle structures with holes in it, try it and
see.

thanks,

greg k-h
