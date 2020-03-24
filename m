Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDF2191538
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgCXPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbgCXPoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 11:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2993C2076F;
        Tue, 24 Mar 2020 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585064693;
        bh=Xcme7gvaoaEler/5XOMTCI6mA3soOPviGtN4FCyopho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qF9LrS4kelpe748kQlZ5E8wVhuGMgtSb4SMICjdzWOLop+7bwmwbLk1wgw5XTOVJC
         G0aaPPPVVqJ9s9DLzTw1nhQynvTrJJgUgGPocEx927cPJD2fe5etKi9WJrFqxA2G3D
         /KpZY85qQteOcCtoWrWzNLXzVhPxpXNuw41LHihU=
Date:   Tue, 24 Mar 2020 16:44:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mitch.a.williams@intel.com
Subject: Re: [PATCH RESEND net 1/3] class: add class_find_and_get_file_ns()
 helper function
Message-ID: <20200324154449.GC2513347@kroah.com>
References: <20200324141722.21308-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324141722.21308-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 02:17:22PM +0000, Taehee Yoo wrote:
> The new helper function is to find and get a class file.
> This function is useful for checking whether the class file is existing
> or not. This function will be used by networking stack to
> check "/sys/class/net/*" file.
> 
> Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/base/class.c         | 12 ++++++++++++
>  include/linux/device/class.h |  4 +++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index bcd410e6d70a..dedf41f32f0d 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -105,6 +105,17 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
>  		sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
>  }
>  
> +struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
> +					       const char *name,
> +					       const void *ns)
> +{
> +	struct kernfs_node *kn = NULL;
> +
> +	if (cls)
> +		kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
> +	return kn;
> +}
> +

You can put the EXPORT_SYMBOL_GPL() under here.

And can you document what this function actually is in some kerneldoc?

But, returning a kernfs_node from a driver core is _REALLY_ odd.  Why do
you need this and who cares about kernfs here?

thanks,

greg k-h
