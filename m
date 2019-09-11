Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FB3AFE19
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfIKNv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:51:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbfIKNv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 09:51:28 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F8F3C059B7A
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 13:51:27 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id f19so23861490qtq.1
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 06:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=152d67FF4RV7HTf/TX16nav3+dbWDhuM37ZTXxyyvyE=;
        b=EwX++S79uOa4j1Xus28qBDabNxTizSDfISfbSwWfhaxo15XR7CVRO7iXY55Mnvre2q
         Xsa0qYZFEKVBwOFCjudiS4QchJ38sFcW7AUI3srZiKdbgv8mJiqRwLAtTcBiFdPq1TMy
         pw2Gh/KYPIAZbRdflr2ZVH9kK7uWp3nP/uefzXXOuv1LvDtvfa63gr9WuswtgQcoPZho
         vInsxcI5rWownnEZyy5b9XA51/AaS9SvKVkpReyoYgqMEf85hNoS2f5SvQfqlkkTOCzc
         5IqCtppcduUR1viGIUHn+WEkXdZJ/PqrXlBMgcFa+/twNObQpQ5jVM2ggx5gGx6Lnr7B
         TWKA==
X-Gm-Message-State: APjAAAVhKvPd4TXKHp4t0cu3EPOAAMwPyvx/PqPkisUkuN9BN6/NEr8L
        ky7eu8ybj7RFeDmeDPz/bT8k/svFMBOKJ1St0PjZFZMurbwtBp3tzAtFGFXiCRx1ap2dqnARwft
        FN3xnz0usSUI7UKt1
X-Received: by 2002:ac8:6706:: with SMTP id e6mr2563896qtp.143.1568209886591;
        Wed, 11 Sep 2019 06:51:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwaO6d0va5B79pj+BVvjOJY7I7L3GALGaTfXtlaBYWZSZUc9ffvRmXeRRX5Y4F/HwVRR5aQWQ==
X-Received: by 2002:ac8:6706:: with SMTP id e6mr2563882qtp.143.1568209886370;
        Wed, 11 Sep 2019 06:51:26 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id y58sm5426960qta.1.2019.09.11.06.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 06:51:25 -0700 (PDT)
Date:   Wed, 11 Sep 2019 09:51:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911092544-mutt-send-email-mst@kernel.org>
References: <20190911120908.28410-1-mst@redhat.com>
 <20190911121628.GT4023@dhcp22.suse.cz>
 <20190911082236-mutt-send-email-mst@kernel.org>
 <20190911123316.GX4023@dhcp22.suse.cz>
 <20190911085807-mutt-send-email-mst@kernel.org>
 <20190911131235.GZ4023@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911131235.GZ4023@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 03:12:35PM +0200, Michal Hocko wrote:
> On Wed 11-09-19 09:03:10, Michael S. Tsirkin wrote:
> > On Wed, Sep 11, 2019 at 02:33:16PM +0200, Michal Hocko wrote:
> > > On Wed 11-09-19 08:25:03, Michael S. Tsirkin wrote:
> > > > On Wed, Sep 11, 2019 at 02:16:28PM +0200, Michal Hocko wrote:
> > > > > On Wed 11-09-19 08:10:00, Michael S. Tsirkin wrote:
> > > > > > iovec addresses coming from vhost are assumed to be
> > > > > > pre-validated, but in fact can be speculated to a value
> > > > > > out of range.
> > > > > > 
> > > > > > Userspace address are later validated with array_index_nospec so we can
> > > > > > be sure kernel info does not leak through these addresses, but vhost
> > > > > > must also not leak userspace info outside the allowed memory table to
> > > > > > guests.
> > > > > > 
> > > > > > Following the defence in depth principle, make sure
> > > > > > the address is not validated out of node range.
> > > > > > 
> > > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > Tested-by: Jason Wang <jasowang@redhat.com>
> > > > > 
> > > > > no need to mark fo stable? Other spectre fixes tend to be backported
> > > > > even when the security implications are not really clear. The risk
> > > > > should be low and better to be covered in case.
> > > > 
> > > > This is not really a fix - more a defence in depth thing,
> > > > quite similar to e.g.  commit b3bbfb3fb5d25776b8e3f361d2eedaabb0b496cd
> > > > x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec
> > > > in scope.
> > > >
> > > > That one doesn't seem to be tagged for stable. Was it queued
> > > > there in practice?
> > > 
> > > not marked for stable but it went in. At least to 4.4.
> > 
> > So I guess the answer is I don't know. If you feel it's
> > justified, then sure, feel free to forward.
> 
> Well, that obviously depends on you as a maintainer but the point is
> that spectre gatgets are quite hard to find. There is a smack check
> AFAIK but that generates quite some false possitives and it is PITA to
> crawl through those. If you want an interesting (I am not saying
> vulnerable on purpose) gatget then it would be great to mark it for
> stable so all stable consumers (disclaimer: I am not one of those) and
> add that really great feeling of safety ;)
> 
> So take this as my 2c

OK it seems security@kernel.org is the way to handle these things.
I'll try that.

> -- 
> Michal Hocko
> SUSE Labs
