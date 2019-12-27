Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0579812B57B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 16:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfL0PCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 10:02:23 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36018 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0PCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 10:02:22 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so14862678pfb.3;
        Fri, 27 Dec 2019 07:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=73+uqorZ8jaAi6XI/f6tOg8KY2/JMd0Q3CNU4xqP1XE=;
        b=MakOBPW5DCVW80P94rr1tK3tbhYsW/TpR2myRnNnGZVV3B9Rx6Upirj/IzKFJvrX+E
         W3SS+WX4TGUJjgxlKRTXVfdXV2MOZEZ1OXpbTg7acC7qkQ3Gr4IWCUh+f8sYEn/Z7LjT
         5GCaa/UmZ0G/M2/V3iwpxFE29QrywEa6tIpHy3q32TiBDZfth/i02gEfBEfQpElUaxHx
         v5VjJ35dxd5s4y873V/T2rOUti9EHiEsC0cyMiJgvWdra+13kku0PA/hWmG6qBH4G8ct
         FS+xjmuhlcLj83li08KRAoFDM5b1Bs0KXbWQPAEHstbHoUeTzUayunvGbv4Qe96PpC0G
         qx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=73+uqorZ8jaAi6XI/f6tOg8KY2/JMd0Q3CNU4xqP1XE=;
        b=ZmfJPGipjyCBguqpOjOeO6mIlALrkOGSL1Pi62aX97nqLWXDrdJzZIw7rxhmw2SGi5
         aTWtcFRUriyrs/AVIxcNVIYkNG27ukFdFSaIhr4gD7bASY12+k5kn0pERJcnhqZy+eWM
         DO1daiWIYt7zUK3F3pefYeQZjtCqsmeKMZXNB+1eGznucIzI65Fwnsvg6xk0VYowiSgw
         2jD8qm+OavsrV70C/kUbtukUy2Jy7laLf1s4XJczubFe/R0qUfTAiHuquU79xGGMMJ2f
         8Pq37TXwUa9SR2uWAfDeYzKSAQ2MnfLFYydQBFK2flUmXBrmw66q/0GYHoCq5BAyD2CU
         Ic0A==
X-Gm-Message-State: APjAAAVMT17AOxMNIR3OBc9bcMrxuisNmpewTMWSvdUQjWwNf5HYw4QD
        TUqq5Z6CkvP4yFaoF9Np15Y=
X-Google-Smtp-Source: APXvYqzaMkpqewd193uc69dXZgD1HXAMLLpVF+ih7JUB6jpryTSsWFGk4Ca6fc4IUMUbXbrw7uj7/w==
X-Received: by 2002:a62:cdcb:: with SMTP id o194mr53978760pfg.117.1577458942041;
        Fri, 27 Dec 2019 07:02:22 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u18sm38877903pgn.9.2019.12.27.07.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 07:02:21 -0800 (PST)
Date:   Fri, 27 Dec 2019 07:02:19 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Al Viro <aviro@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: fix the race between the release of ptp_clock
 and cdev
Message-ID: <20191227150218.GA1435@localhost>
References: <20191208195340.GX4203@ZenIV.linux.org.uk>
 <20191227022627.24476-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227022627.24476-1-vdronov@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 03:26:27AM +0100, Vladis Dronov wrote:
> Here cdev is embedded in posix_clock which is embedded in ptp_clock.
> The race happens because ptp_clock's lifetime is controlled by two
> refcounts: kref and cdev.kobj in posix_clock. This is wrong.
> 
> Make ptp_clock's sysfs device a parent of cdev with cdev_device_add()
> created especially for such cases. This way the parent device with its
> ptp_clock is not released until all references to the cdev are released.
> This adds a requirement that an initialized but not exposed struct
> device should be provided to posix_clock_register() by a caller instead
> of a simple dev_t.
> 
> This approach was adopted from the commit 72139dfa2464 ("watchdog: Fix
> the race between the release of watchdog_core_data and cdev"). See
> details of the implementation in the commit 233ed09d7fda ("chardev: add
> helper function to register char devs with a struct device").

Thanks for digging into this!

Acked-by: Richard Cochran <richardcochran@gmail.com>

>  /**
>   * posix_clock_register() - register a new clock
> - * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
> - * @devid: Allocated device id
> + * @clk:   Pointer to the clock. Caller must provide 'ops' field
> + * @dev:   Pointer to the initialized device. Caller must provide
> + *         'release' filed

field

Thanks,
Richard
