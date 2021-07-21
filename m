Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384A53D0E2E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbhGULNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238005AbhGUKxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 06:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28D6E60FD7;
        Wed, 21 Jul 2021 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626867236;
        bh=7HTyWj6nkF3axfBN153vLEf4PrH4qOV+zCpywxp9zmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=htZHXhbgPf1QP2E2Rzp3rRqF0Sod5ysFc38xW1gQQzlxuhDIzq5aqnExEqs53bJ0B
         Wu7soDgPaVgyw3Xzz9jsNbLpA91aOnVGBzPHXtegXNJp/jjZ5GuctnQ2/0IpmUZb4F
         POFf+6LOy8OYm0LCn73tPB+EIaUnyEXWX++pAWms=
Date:   Wed, 21 Jul 2021 13:33:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] test_sysfs: demonstrate deadlock fix
Message-ID: <YPgGIncQxcD2frBY@kroah.com>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-5-mcgrof@kernel.org>
 <YN/sar6nGeSCn89/@kroah.com>
 <20210703172828.jphifwobf3syirzi@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703172828.jphifwobf3syirzi@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 03, 2021 at 10:28:28AM -0700, Luis Chamberlain wrote:
> On Sat, Jul 03, 2021 at 06:49:46AM +0200, Greg KH wrote:
> > On Fri, Jul 02, 2021 at 05:46:32PM -0700, Luis Chamberlain wrote:
> > > +#define MODULE_DEVICE_ATTR_FUNC_STORE(_name) \
> > > +static ssize_t module_ ## _name ## _store(struct device *dev, \
> > > +				   struct device_attribute *attr, \
> > > +				   const char *buf, size_t len) \
> > > +{ \
> > > +	ssize_t __ret; \
> > > +	if (!try_module_get(THIS_MODULE)) \
> > > +		return -ENODEV; \
> > > +	__ret = _name ## _store(dev, attr, buf, len); \
> > > +	module_put(THIS_MODULE); \
> > > +	return __ret; \
> > > +}
> > 
> > As I have pointed out before, doing try_module_get(THIS_MODULE) is racy
> > and should not be added back to the kernel tree.  We got rid of many
> > instances of this "bad pattern" over the years, please do not encourage
> > it to be added back as others will somehow think that it correct code.
> 
> It is noted this is used in lieu of any agreed upon solution to
> *demonstrate* how this at least does fix it. In this case (and in the
> generic solution I also had suggested for kernfs a while ago), if the
> try fails, we give up. If it succeeds, we now know we can rely on the
> device pointer. If the refcount succeeds, can the module still not
> be present? Is try_module_get() racy in that way? In what way is it
> racy and where is this documented? Do we have a selftest to prove the
> race?

As I say in the other email where you tried to add this, think about
what happens if the module is removed _right before_ you make this call.

Or a few instructions before that.  The race is still there, this fixes
nothing except make the window smaller.

thanks,

greg k-h
