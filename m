Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43083B9A60
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 03:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhGBBHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 21:07:04 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:42771 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhGBBHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 21:07:03 -0400
Received: by mail-pg1-f174.google.com with SMTP id d12so7962189pgd.9;
        Thu, 01 Jul 2021 18:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eaR++vjtiNX6DzHjutKmZUMGyUp8898EKANyRVFBEw0=;
        b=GYbRh3WRynklyYDXdXAmwJWBssd06qENgQD20dWyDBzL/0tAzswwRUmLtB3agJVFiJ
         G3a9UWTFo7hFekXc+IHvgThwgM3j69SFEizORWTV2cp3PVSppUgybJsIQcN4oH5uS3Z3
         Fy0p7XfDs0Ew4jvhnfFU3vXEIm+hxy5ESbwrCw92Yw9yUt1sJL9Qc597jpf43/CskvIV
         QgTnOOuyPsMMt8AGO0OHBZKFn+0XTobrHQWi9S6C/kT01rafjMa9wxb+Ja3QndMu7//u
         2T86ddvsiDGUtBh9pIM9tYz7dPfG3yxy054sFy2rI5KdWroGF/ruzx/j/V/hA07tjYPH
         Ostg==
X-Gm-Message-State: AOAM5318R2vDWFR3zfB2h5XqbUYBPoMum1dBhN2SFu3P5aX0OQ7XsqZ1
        71bwbfqmNft/u0nUgVZdrWE=
X-Google-Smtp-Source: ABdhPJwqfas45MGSvqIPpCYJVbZ5WEkNtXeEvDY+hBGZMizW2iqQHZEJwbh1Lk8KVFSTlbL6hSCAbg==
X-Received: by 2002:a63:c1e:: with SMTP id b30mr256447pgl.118.1625187870738;
        Thu, 01 Jul 2021 18:04:30 -0700 (PDT)
Received: from garbanzo ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id t5sm1198320pgb.58.2021.07.01.18.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 18:04:29 -0700 (PDT)
Date:   Thu, 1 Jul 2021 18:04:25 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc:     rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <20210702010425.frwcbregdyuguaak@garbanzo>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
 <20210625215558.xn4a24ts26bdyfzo@garbanzo>
 <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 03:48:22PM -0700, Luis Chamberlain wrote:
> On Fri, Jun 25, 2021 at 02:56:03PM -0700, Luis Chamberlain wrote:
> > On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> > > thanks for making this change and sticking with it!
> > > 
> > > Oh, and with this change, does your modprobe/rmmod crazy test now work?
> > 
> > It does but I wrote a test_syfs driver and I believe I see an issue with
> > this. I'll debug a bit more and see what it was, and I'll then also use
> > the driver to demo the issue more clearly, and then verification can be
> > an easy selftest test.
> 
> OK my conclusion based on a new selftest driver I wrote is we can drop
> this patch safely. The selftest will cover this corner case well now.
> 
> In short: the kernfs active reference will ensure the store operation
> still exists. The kernfs mutex is not enough, but if the driver removes
> the operation prior to getting the active reference, the write will just
> fail. The deferencing inside of the sysfs operation is abstract to
> kernfs, and while kernfs can't do anything to prevent a driver from
> doing something stupid, it at least can ensure an open file ensure the
> op is not removed until the operation completes.

OK and now its not so clear, as it would seem the refcount can indeed
get reduced after we validated it. In any case we'll have enough tools
to reproduce any possible failure soon.

  Luis
