Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4A7FBAF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbfHBOD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:03:59 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46229 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730204AbfHBOD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:03:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so73921175qtn.13
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 07:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WV2Ae/gfauZPjPhFYOLLqagCyB4HyL2HjQauKn3bqsM=;
        b=MrprVpZ8/zlG6418pVbTyNjU4gD9gqCoagS4tUNuHucvbirS8Mt+gBjZ/DoiKArngp
         DQZ4b94KH5L70tOjZmm56Eq4+gSB1MwlJmI7z/S9leC88qPgmxekKtH/r7yZZ3t1MFVz
         6IbIEvn1Zyyb9sR3LJOkUEQqOO9z8Orb4/eAGY32+cbped2R44D+PIsDyT0IvL0sR4/S
         UHVWI3vA/xdEd1HG9+ReK+UldSQWnc1svs/nav1lARgx45IQZ3XX1hRDwUUzCCOZ4BTV
         o66Uw3+lKiCJBBJCMZ1V4LxURANdZg2vc2+iyU2rJnYDT3uSGlVDtpvesDQbXfWXaY9D
         gV9g==
X-Gm-Message-State: APjAAAUUPPvH68B2n3AwGLPHhl82v3riujMBkl15T+o99KzYWp+xmd0Q
        cbHE8GLQE/0g51ph1osWYwiimA==
X-Google-Smtp-Source: APXvYqxqWV5TMaysY1q7/YjNkaoGeUmT+T8Aja0Ppx3ngtfg+CGh7SDzsuYF2FJmZ32u93WwxfAAKw==
X-Received: by 2002:ac8:2b49:: with SMTP id 9mr99459163qtv.343.1564754637929;
        Fri, 02 Aug 2019 07:03:57 -0700 (PDT)
Received: from redhat.com ([147.234.38.1])
        by smtp.gmail.com with ESMTPSA id v4sm30651268qtq.15.2019.08.02.07.03.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 07:03:56 -0700 (PDT)
Date:   Fri, 2 Aug 2019 10:03:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190802094331-mutt-send-email-mst@kernel.org>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-8-jasowang@redhat.com>
 <20190731123935.GC3946@ziepe.ca>
 <7555c949-ae6f-f105-6e1d-df21ddae9e4e@redhat.com>
 <20190731193057.GG3946@ziepe.ca>
 <a3bde826-6329-68e4-2826-8a9de4c5bd1e@redhat.com>
 <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 05:40:07PM +0800, Jason Wang wrote:
> Btw, I come up another idea, that is to disable preemption when vhost thread
> need to access the memory. Then register preempt notifier and if vhost
> thread is preempted, we're sure no one will access the memory and can do the
> cleanup.

Great, more notifiers :(

Maybe can live with
1- disable preemption while using the cached pointer
2- teach vhost to recover from memory access failures,
   by switching to regular from/to user path

So if you want to try that, fine since it's a step in
the right direction.

But I think fundamentally it's not what we want to do long term.

It's always been a fundamental problem with this patch series that only
metadata is accessed through a direct pointer.

The difference in ways you handle metadata and data is what is
now coming and messing everything up.

So if continuing the direct map approach,
what is needed is a cache of mapped VM memory, then on a cache miss
we'd queue work along the lines of 1-2 above.

That's one direction to take. Another one is to give up on that and
write our own version of uaccess macros.  Add a "high security" flag to
the vhost module and if not active use these for userspace memory
access.


-- 
MST
