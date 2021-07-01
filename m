Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC13B98AA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 00:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhGAWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 18:50:54 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:53165 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhGAWux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 18:50:53 -0400
Received: by mail-pj1-f43.google.com with SMTP id kt19so5247368pjb.2;
        Thu, 01 Jul 2021 15:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KfsC1NU2036YELOEEz9l1d7vjRPdhLZ2pXf4rmwWMGc=;
        b=ju34z1ax1MVfsx1dBGDdlPHjbntOmpU4VJpHBh3qT8F/79BzhbyBJqb9o66eNzGqLp
         C4lzc2RLC4ufOv/IxN4C8JFlYoSHPv0+0fwBBLJXV04KLQSsmigMgM0xZKGGufxeAp0S
         zAbsneS58b+eMSfas7iaT7ajxOAQshvGTM+9PZEIpnxRr+/RglH6aOUUK8SYzRUJ4BiH
         Q21V4+9xwohJYQy7yuhx5YfGFFrnUEaSSczDA+SbIBz0B9jGoH1f8N0epbvOL+FbsgJd
         DMR62ls2hR6FsFxme6m1vGwH8gnKMQSJ7yJzSByliR2IrSYmfpy40h7oSXAN0ZoZKvzu
         EZKQ==
X-Gm-Message-State: AOAM533CLOtOThIfc+LlLA8sTlA5TweVg1N8g81eqD/4V1AyYYPsqhi7
        Uj8CX7A5KrS0ihpS0qGrd4U=
X-Google-Smtp-Source: ABdhPJw+5Arm1W2DC+mHR7nPQwt4B+3mrKeoGQWdNxrTsdoVlDywocfkBdG8pdPxj8BOTNwFcjhojg==
X-Received: by 2002:a17:902:c245:b029:128:e566:111d with SMTP id 5-20020a170902c245b0290128e566111dmr1810667plg.77.1625179701819;
        Thu, 01 Jul 2021 15:48:21 -0700 (PDT)
Received: from garbanzo ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id j205sm1136597pfd.4.2021.07.01.15.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 15:48:20 -0700 (PDT)
Date:   Thu, 1 Jul 2021 15:48:16 -0700
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
Message-ID: <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
 <20210625215558.xn4a24ts26bdyfzo@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625215558.xn4a24ts26bdyfzo@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 02:56:03PM -0700, Luis Chamberlain wrote:
> On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> > thanks for making this change and sticking with it!
> > 
> > Oh, and with this change, does your modprobe/rmmod crazy test now work?
> 
> It does but I wrote a test_syfs driver and I believe I see an issue with
> this. I'll debug a bit more and see what it was, and I'll then also use
> the driver to demo the issue more clearly, and then verification can be
> an easy selftest test.

OK my conclusion based on a new selftest driver I wrote is we can drop
this patch safely. The selftest will cover this corner case well now.

In short: the kernfs active reference will ensure the store operation
still exists. The kernfs mutex is not enough, but if the driver removes
the operation prior to getting the active reference, the write will just
fail. The deferencing inside of the sysfs operation is abstract to
kernfs, and while kernfs can't do anything to prevent a driver from
doing something stupid, it at least can ensure an open file ensure the
op is not removed until the operation completes.

  Luis
