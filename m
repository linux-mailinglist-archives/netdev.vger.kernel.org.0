Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6F3239E83
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 06:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHCE6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 00:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHCE6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 00:58:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD062068F;
        Mon,  3 Aug 2020 04:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596430724;
        bh=0wWu/yJWcJHPmm8RbF95+DdUX5G1LnDQ23Z2blw/WnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6qPIEgF/UKp+AlLPVIkFocBc7mvGHOXJRP678/PMve5rmyqsVTkuz9VsKK41IZ4o
         Bgw1F9OID013tKs7dEZEy+biN9BRct6FIt/kue+lSdWTS4UVyKh/nipQlhSjMABNEi
         dj1i+iPxo6xTYI7gA/KPead6eBLVxHt72ONcZb9U=
Date:   Mon, 3 Aug 2020 07:58:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
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
Message-ID: <20200803045840.GM75549@unreal>
References: <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal>
 <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
 <20200802222843.GP24045@ziepe.ca>
 <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 03:45:40PM -0700, Joe Perches wrote:
> On Sun, 2020-08-02 at 19:28 -0300, Jason Gunthorpe wrote:
> > On Sun, Aug 02, 2020 at 03:23:58PM -0700, Joe Perches wrote:
> > > On Sun, 2020-08-02 at 19:10 -0300, Jason Gunthorpe wrote:
> > > > On Sat, Aug 01, 2020 at 08:38:33AM +0300, Leon Romanovsky wrote:
> > > >
> > > > > I'm using {} instead of {0} because of this GCC bug.
> > > > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
> > > >
> > > > This is why the {} extension exists..
> > >
> > > There is no guarantee that the gcc struct initialization {}
> > > extension also zeros padding.
> >
> > We just went over this. Yes there is, C11 requires it.
>
> c11 is not c90.  The kernel uses c90.

It is not accurate, kernel uses gnu89 dialect, which is C90 with some
C99 features [1]. In our case, we rely on GCC extension {} that doesn't
contradict standart [2] and fills holes with zeros too.

[1] Makefile:500
   496 KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
   497                    -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
   498                    -Werror=implicit-function-declaration -Werror=implicit-int \
   499                    -Wno-format-security \
   500                    -std=gnu89

[2] From GCC:
https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
"When a base standard is specified, the compiler accepts all programs
following that standard plus those using GNU extensions that do not
contradict it."

Thanks

>
>
>
