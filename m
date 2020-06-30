Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1580720FB26
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390508AbgF3R5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:57:09 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51244 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3R5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:57:08 -0400
Received: by mail-pj1-f65.google.com with SMTP id l6so6700263pjq.1;
        Tue, 30 Jun 2020 10:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IxDMdmHFz25rQeZrQw7NFOS8gOPg1n8YJ7nCrO0iZow=;
        b=ZEtUAicIZGWU1FmyjUHcQCzCryxfBOMljIaX4ll2uWalbkSolzS0ztAwmsQDM6Iof7
         0zNTjUrFpcX/4UZLI0ErB0aVvsGGbP/oc5qQIye/HGMby5SpN4z2QyWG3un5Q6t3oecg
         l4VhoGxQJiPs15WTmiltavGA8+DOpgatw8cszTfUN+LbIovR3SiZQkhLX0gik90Yvi0p
         Ghn98X+LkaR2xUc66VcoeQeJHv/f8x6ty+MWRsV++4rVLJ8JQ//db1nLeLGynptIMZcD
         chyikJBR5vkVOzGL8CVilxwHJ8QTjGly4iQQcaia9Vf55uiC6ryggJFb5tOf8CG6MPTy
         ZnLw==
X-Gm-Message-State: AOAM531QtJ3D4LIIKPUuhfPGbsODewxTQ40Fmqfw9vQ2hAe50Gp5gYf6
        V55WnoFIeuCD+2zsMcg54U8=
X-Google-Smtp-Source: ABdhPJyO4r2+2U3N9gJ5+4QVVzssPbq2nonngepycpeUVR0nzxS79dBaptYeC8a26mlqfwKjmxeziQ==
X-Received: by 2002:a17:90a:668f:: with SMTP id m15mr23597845pjj.32.1593539826969;
        Tue, 30 Jun 2020 10:57:06 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id j16sm3304413pfr.100.2020.06.30.10.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 10:57:05 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 720B9403DC; Tue, 30 Jun 2020 17:57:04 +0000 (UTC)
Date:   Tue, 30 Jun 2020 17:57:04 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200630175704.GO13911@42.do-not-panic.com>
References: <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
 <20200624144311.GA5839@infradead.org>
 <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
 <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626025410.GJ4332@42.do-not-panic.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:54:10AM +0000, Luis Chamberlain wrote:
> On Wed, Jun 24, 2020 at 08:37:55PM +0200, Christian Borntraeger wrote:
> > 
> > 
> > On 24.06.20 20:32, Christian Borntraeger wrote:
> > [...]> 
> > > So the translations look correct. But your change is actually a sematic change
> > > if(ret) will only trigger if there is an error
> > > if (KWIFEXITED(ret)) will always trigger when the process ends. So we will always overwrite -ECHILD
> > > and we did not do it before. 
> > > 
> > 
> > So the right fix is
> > 
> > diff --git a/kernel/umh.c b/kernel/umh.c
> > index f81e8698e36e..a3a3196e84d1 100644
> > --- a/kernel/umh.c
> > +++ b/kernel/umh.c
> > @@ -154,7 +154,7 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
> >                  * the real error code is already in sub_info->retval or
> >                  * sub_info->retval is 0 anyway, so don't mess with it then.
> >                  */
> > -               if (KWIFEXITED(ret))
> > +               if (KWEXITSTATUS(ret))
> >                         sub_info->retval = KWEXITSTATUS(ret);
> >         }
> >  
> > I think.
> 
> Nope, the right form is to check for WIFEXITED() before using WEXITSTATUS().
> I'm not able to reproduce this on x86 with a bridge. What type of bridge
> are you using on a guest, or did you mean using KVM so that the *host*
> can spawn kvm guests?
> 
> It would be good if you can try to add a bridge manually and see where
> things fail. Can you do something like this:
> 
> brctl addbr br0
> brctl addif br0 ens6 
> ip link set dev br0 up
> 
> Note that most callers are for modprobe. I'd be curious to see which
> umh is failing which breaks bridge for you. Can you trut this so we can
> see which umh call is failing?

Christian, any luck getting to test the code below to see what this
reveals?

  Luis

> 
> diff --git a/kernel/umh.c b/kernel/umh.c
> index f81e8698e36e..5ad74bc301d8 100644
> --- a/kernel/umh.c
> +++ b/kernel/umh.c
> @@ -2,6 +2,9 @@
>  /*
>   * umh - the kernel usermode helper
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/sched/task.h>
> @@ -154,8 +157,12 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
>  		 * the real error code is already in sub_info->retval or
>  		 * sub_info->retval is 0 anyway, so don't mess with it then.
>  		 */
> -		if (KWIFEXITED(ret))
> +		printk("== ret: %02x\n", ret);
> +		printk("== KWIFEXITED(ret): %02x\n", KWIFEXITED(ret));
> +		if (KWIFEXITED(ret)) {
> +			printk("KWEXITSTATUS(ret): %d\n", KWEXITSTATUS(ret));
>  			sub_info->retval = KWEXITSTATUS(ret);
> +		}
>  	}
>  
>  	/* Restore default kernel sig handler */
> @@ -383,6 +390,7 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
>  		void *data)
>  {
>  	struct subprocess_info *sub_info;
> +	unsigned int i = 0;
>  	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
>  	if (!sub_info)
>  		goto out;
> @@ -394,6 +402,11 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
>  #else
>  	sub_info->path = path;
>  #endif
> +	pr_info("sub_info->path: %s\n", sub_info->path);
> +	while (argv[i])
> +		printk(KERN_INFO "%s ", argv[i++]);
> +	printk(KERN_INFO  "\n");
> +
>  	sub_info->argv = argv;
>  	sub_info->envp = envp;
>  
> 
