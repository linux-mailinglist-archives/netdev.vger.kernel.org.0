Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E303BA9D4
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 19:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhGCRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 13:31:09 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:35700 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhGCRbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 13:31:08 -0400
Received: by mail-pf1-f180.google.com with SMTP id d12so12297404pfj.2;
        Sat, 03 Jul 2021 10:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sn0DaF0wG+Fr83pUGydCXmzXu/QrmNbieyqr+LtNIk=;
        b=BCCPtNJ0r9rUm6ZIN2VuSfi7nmPHYezpyhMUnAXf6S9t3LDmvPgSqLMxq/JMRAA9F8
         p9woqOOP4p1QMur3fxX55F46f9aWK6WpjH+zzCoK19Vp0PSkep3Ov8cxHv7RFbVBVQI5
         8O2AF3C7o4eFq2T7e8+yLuYzolQNin0SKR2nQpVmusv2frVoggKKHecyZ4ooo4deUk6k
         w84nheywT8JAwTtNqBLlhIBS6OWhpaCD1ocDUyTfTMXxhEpdSqK+ZizzdMC27xuQvlrI
         jJdrVOlKNkOSIbxKx+K/atPlXMh6OFbAkhzayBKtdWHzxdqbL/q/ULZ//vLlQXgV+MLv
         AKMg==
X-Gm-Message-State: AOAM532uTAE9VTc3ipjHrCakhf4s8xBho85X9nF/m6G75Zc5ZcvhfwMh
        mFw5kWEmy8Hke+L0EKEl1AE=
X-Google-Smtp-Source: ABdhPJwpBwVgMVFUlKeUzC8YjLnXIsiJyQ7Ci+G35ZeDdoHdddvA/2DxRCxjRnoeP/CSWGkc4KpReA==
X-Received: by 2002:a65:4985:: with SMTP id r5mr6198260pgs.122.1625333313358;
        Sat, 03 Jul 2021 10:28:33 -0700 (PDT)
Received: from garbanzo ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id z9sm7321452pfa.2.2021.07.03.10.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 10:28:32 -0700 (PDT)
Date:   Sat, 3 Jul 2021 10:28:28 -0700
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
Message-ID: <20210703172828.jphifwobf3syirzi@garbanzo>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-5-mcgrof@kernel.org>
 <YN/sar6nGeSCn89/@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN/sar6nGeSCn89/@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 03, 2021 at 06:49:46AM +0200, Greg KH wrote:
> On Fri, Jul 02, 2021 at 05:46:32PM -0700, Luis Chamberlain wrote:
> > +#define MODULE_DEVICE_ATTR_FUNC_STORE(_name) \
> > +static ssize_t module_ ## _name ## _store(struct device *dev, \
> > +				   struct device_attribute *attr, \
> > +				   const char *buf, size_t len) \
> > +{ \
> > +	ssize_t __ret; \
> > +	if (!try_module_get(THIS_MODULE)) \
> > +		return -ENODEV; \
> > +	__ret = _name ## _store(dev, attr, buf, len); \
> > +	module_put(THIS_MODULE); \
> > +	return __ret; \
> > +}
> 
> As I have pointed out before, doing try_module_get(THIS_MODULE) is racy
> and should not be added back to the kernel tree.  We got rid of many
> instances of this "bad pattern" over the years, please do not encourage
> it to be added back as others will somehow think that it correct code.

It is noted this is used in lieu of any agreed upon solution to
*demonstrate* how this at least does fix it. In this case (and in the
generic solution I also had suggested for kernfs a while ago), if the
try fails, we give up. If it succeeds, we now know we can rely on the
device pointer. If the refcount succeeds, can the module still not
be present? Is try_module_get() racy in that way? In what way is it
racy and where is this documented? Do we have a selftest to prove the
race?

  Luis

