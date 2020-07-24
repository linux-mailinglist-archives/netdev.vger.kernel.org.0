Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB63422BE18
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXGa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:30:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51973 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGXGa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:30:57 -0400
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1jyrEM-0004iz-L5
        for netdev@vger.kernel.org; Fri, 24 Jul 2020 06:30:54 +0000
Received: by mail-ed1-f69.google.com with SMTP id w19so2534374edx.0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5Bi1N9eHmzbwm4KZS+jcd4luzKCa17r9gngXjYNYvc=;
        b=LeAJ1zmt/4MV1VVc3WOc20Ak1rqvP0MKcKo/frdx2iOqcrpD96rnyLxCVAX5bxqLfO
         r2bf0GrFzyHKOmyWV0GsNTSCQXBsyOczauGKbtfdWZ3BvM0fmcl4pY14myTar8z7/aKG
         Rr34DDeJENiv2yE0g9qKYXAGuyJoHw3Quu4I1byf2YDw/IbiA8ON396EiGQsPKVpLcRY
         DARJn2wXxsI23vHJzJ6+71yUz9n6Hvaq1UmxZ3EbDhcxYwYFGU/H7j1vaIf1iW1MuqzW
         hiKVYxzVj4TdWAnSrozh3OFphzewhXq605Yrtic9Hp3sFPgPdYDpM2JH+ul2cppf1GFU
         UKlg==
X-Gm-Message-State: AOAM531Vit2I6s+cVktxnOF9JWq8COovWRhh3IaorbI+f4SPW6Mp/Oo+
        hWIi670db9dSX7Wu1FELgcFc7OVR3ZvVLtKBgkE6TlkUDd1acPlw9O/XQG1L2tZ6TTb4IG3RnZX
        SjJGNWTVLNUzLDjR9Tst0KcuowbMtATHeaw==
X-Received: by 2002:a17:906:3bd5:: with SMTP id v21mr3756080ejf.329.1595572254322;
        Thu, 23 Jul 2020 23:30:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXO1++pFVwTCL/tYfrIs0xm/tuHNlxlyRivKJ5/9QT5Rk/9NHc5BZDVgyqSnOH54Jo7XttPw==
X-Received: by 2002:a17:906:3bd5:: with SMTP id v21mr3756053ejf.329.1595572254072;
        Thu, 23 Jul 2020 23:30:54 -0700 (PDT)
Received: from localhost (host-87-11-131-192.retail.telecomitalia.it. [87.11.131.192])
        by smtp.gmail.com with ESMTPSA id r19sm48005edi.85.2020.07.23.23.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 23:30:53 -0700 (PDT)
Date:   Fri, 24 Jul 2020 08:30:52 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     David Miller <davem@davemloft.net>
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, kuba@kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netfront: fix potential deadlock in xennet_remove()
Message-ID: <20200724063052.GG841369@xps-13>
References: <20200722065211.GA841369@xps-13>
 <20200723.145722.752878326752101646.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723.145722.752878326752101646.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 02:57:22PM -0700, David Miller wrote:
> From: Andrea Righi <andrea.righi@canonical.com>
> Date: Wed, 22 Jul 2020 08:52:11 +0200
> 
> > +static int xennet_remove(struct xenbus_device *dev)
> > +{
> > +	struct netfront_info *info = dev_get_drvdata(&dev->dev);
> > +
> > +	dev_dbg(&dev->dev, "%s\n", dev->nodename);
> 
> These kinds of debugging messages provide zero context and are so much
> less useful than simply using tracepoints which are more universally
> available than printk debugging facilities.
> 
> Please remove all of the dev_dbg() calls from this patch.

I didn't add that dev_dbg() call, it's just the old code moved around,
but I agree, I'll remove that call and send a new version of this patch.

Thanks for looking at it!
-Andrea
