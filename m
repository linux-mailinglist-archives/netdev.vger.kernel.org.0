Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670AA19E643
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 17:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgDDPuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 11:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgDDPuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 11:50:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36704206E6;
        Sat,  4 Apr 2020 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586015445;
        bh=0Nn+EFUzUjFBB+9yzouXCkUYoa5BAhVneCkFnDND6d4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qJ2Npy7plxKmyeQJZrczC3n26CVBnACKU6IgjVyrjMQ1IyiyGSLHX4Wvw0u56uA91
         k0vX8QHI1fzvN6NQBb2jxEmq+8UTfS9N8ZO+Ouecx69XxZ690RY+XApmQIR4JZ9pOd
         SdLiVERAxzZbwO/61tuXlG56flA5KGrBJurbt6hY=
Date:   Sat, 4 Apr 2020 17:50:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mitch.a.williams@intel.com
Subject: Re: [PATCH net v2 1/3] class: add class_has_file_ns() helper function
Message-ID: <20200404155040.GC1476305@kroah.com>
References: <20200404141827.26255-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404141827.26255-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 04, 2020 at 02:18:27PM +0000, Taehee Yoo wrote:
> The new helper function is to check whether the class file is existing
> or not. This function will be used by networking stack to
> check "/sys/class/net/*" file.
> 
> Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v1 -> v2:
>  - Implement class_has_file_ns() instead of class_find_and_get_file_ns().
>  - Change headline.
>  - Add kernel documentation comment.
> 
>  drivers/base/class.c         | 22 ++++++++++++++++++++++
>  include/linux/device/class.h |  3 ++-
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index bcd410e6d70a..a2f2787f6aa7 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -105,6 +105,28 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
>  		sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
>  }
>  
> +/**
> + * class_has_file_ns - check whether file is existing or not
> + * @cls: the compatibility class
> + * @name: name to look for
> + * @ns: the namespace tag to use
> + */
> +bool class_has_file_ns(struct class *cls, const char *name,
> +		       const void *ns)

Why would you use this?  And what happens if the file shows up, or goes
away, instantly after this call is made?

This feels very broken.

greg k-h
