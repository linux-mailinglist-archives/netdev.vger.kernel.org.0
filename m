Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB33D2FE4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhGVVzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:55:43 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:36637 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhGVVzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:55:42 -0400
Received: by mail-pj1-f49.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso6347633pjb.1;
        Thu, 22 Jul 2021 15:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wVoXeyrAZeRK2qfGjVQGLsO4VdyxuMrzVeqIO5OglUw=;
        b=mqEyuC6ZMWktzbi4VQaqT12clfewhUfjgYjhLLJWilS/BWcujWr/Tooiw+eMT6BLqh
         /ENm/SLU5phzstl8LKPdTj8pRh1NhEXo9prCYCboNm3XiWnJH9WfPd22r7CoDTPyVWa2
         YRgZBt2uqwUAjP78NVsxPgAAEIhFQapsvjQlUiYcYbl4bF/0bhdzgkWIJLfORzBZQxBg
         bUnadNs+hj5iUdke/+d3SJmYADbKjDn/T01GThJmE64eObVSWraXdtDxSARVW12+vF7D
         1jPqT4CT+VKdtsmd6EHUnmThPB9vuOilGVV1RZaeBbDPxjzE9tqgFOxo90D+R8llRBCE
         /4EQ==
X-Gm-Message-State: AOAM533HZJbmi0jZtuE3USzDYXo+y0mbQRF95vWAlO8YqTAaaheJQ5Sx
        eElfN4GbPRnQqDu0d/eGNiM=
X-Google-Smtp-Source: ABdhPJy7jpcMv/jD2qs36GnDR2A10wXz/wk2a8k4A0m6oNm6wDS10O7OF6CvUZ2cHRwmY9GgXS86CA==
X-Received: by 2002:a17:902:9a92:b029:127:8aab:6a46 with SMTP id w18-20020a1709029a92b02901278aab6a46mr1851463plp.8.1626993377124;
        Thu, 22 Jul 2021 15:36:17 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id c11sm33414756pfp.0.2021.07.22.15.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:36:16 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:36:12 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20210722223612.bdkdolndhnr4yogt@garbanzo>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-5-mcgrof@kernel.org>
 <YN/sar6nGeSCn89/@kroah.com>
 <20210703172828.jphifwobf3syirzi@garbanzo>
 <YPgGIncQxcD2frBY@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPgGIncQxcD2frBY@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 01:33:54PM +0200, Greg KH wrote:
> On Sat, Jul 03, 2021 at 10:28:28AM -0700, Luis Chamberlain wrote:
> > On Sat, Jul 03, 2021 at 06:49:46AM +0200, Greg KH wrote:
> > > On Fri, Jul 02, 2021 at 05:46:32PM -0700, Luis Chamberlain wrote:
> > > > +#define MODULE_DEVICE_ATTR_FUNC_STORE(_name) \
> > > > +static ssize_t module_ ## _name ## _store(struct device *dev, \
> > > > +				   struct device_attribute *attr, \
> > > > +				   const char *buf, size_t len) \
> > > > +{ \
> > > > +	ssize_t __ret; \
> > > > +	if (!try_module_get(THIS_MODULE)) \
> > > > +		return -ENODEV; \
> > > > +	__ret = _name ## _store(dev, attr, buf, len); \
> > > > +	module_put(THIS_MODULE); \
> > > > +	return __ret; \
> > > > +}
> > > 
> > > As I have pointed out before, doing try_module_get(THIS_MODULE) is racy
> > > and should not be added back to the kernel tree.  We got rid of many
> > > instances of this "bad pattern" over the years, please do not encourage
> > > it to be added back as others will somehow think that it correct code.
> > 
> > It is noted this is used in lieu of any agreed upon solution to
> > *demonstrate* how this at least does fix it. In this case (and in the
> > generic solution I also had suggested for kernfs a while ago), if the
> > try fails, we give up. If it succeeds, we now know we can rely on the
> > device pointer. If the refcount succeeds, can the module still not
> > be present? Is try_module_get() racy in that way? In what way is it
> > racy and where is this documented? Do we have a selftest to prove the
> > race?
> 
> As I say in the other email where you tried to add this, think about
> what happens if the module is removed _right before_ you make this call.
> 
> Or a few instructions before that.  The race is still there, this fixes
> nothing except make the window smaller.

The kernfs active reference ensures that if the file is open the module
must still exist. As such, the use within sysfs files should be safe
as the module is the one in charge of removing the files.

  Luis
