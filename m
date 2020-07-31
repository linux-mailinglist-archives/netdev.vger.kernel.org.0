Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133AC2344F1
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgGaL7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 07:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732689AbgGaL7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 07:59:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5757222B40;
        Fri, 31 Jul 2020 11:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596196762;
        bh=b+H2aGZZOROnQ/51JKv6Xi/z1ePZ0oxtoEognaZJMIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGisF+djPeQZoIGyDlgzXQSa9HruHrtWGR7CV62J+NtSeFm3+xLraywyTwdWedwLu
         FtOiv0kaw5g7NAOAct73ZpIb+xgN1/fSFHo17CeZJwYihaMKUlPRcd5m+gKFyWPPqa
         Sj7DvKxXFeso1O8xUXs0QcVnvmEoZe563KFz6qx0=
Date:   Fri, 31 Jul 2020 13:59:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731115909.GA1649637@kroah.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731095943.GI5493@kadam>
 <81B40AF5-EBCA-4628-8CF6-687C12134552@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81B40AF5-EBCA-4628-8CF6-687C12134552@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 01:14:09PM +0200, Håkon Bugge wrote:
> 
> 
> > On 31 Jul 2020, at 11:59, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > 
> > On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> >> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> >>> rds_notify_queue_get() is potentially copying uninitialized kernel stack
> >>> memory to userspace since the compiler may leave a 4-byte hole at the end
> >>> of `cmsg`.
> >>> 
> >>> In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> >>> unfortunately does not always initialize that 4-byte hole. Fix it by using
> >>> memset() instead.
> >> 
> >> Of course, this is the difference between "{ 0 }" and "{}" initializations.
> >> 
> > 
> > No, there is no difference.  Even struct assignments like:
> > 
> > 	foo = *bar;
> > 
> > can leave struct holes uninitialized.  Depending on the compiler the
> > assignment can be implemented as a memset() or as a series of struct
> > member assignments.
> 
> What about:
> 
> struct rds_rdma_notify {
> 	__u64                      user_token;
> 	__s32                      status;
> } __attribute__((packed));

Why is this still a discussion at all?

Try it and see, run pahole and see if there are holes in this structure
(odds are no), you don't need us to say what is happening here...

thanks,

greg k-h
