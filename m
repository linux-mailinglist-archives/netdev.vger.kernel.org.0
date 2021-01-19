Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D22FB8CF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394759AbhASNsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389223AbhASJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 04:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611050226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNRyaZttxpEG7FVOt6WsLq1WRbO39WhYVs3QVq8r02I=;
        b=YXQOAT1Wnl5jp60sqzAdwr/GQYjfFIewzeuTOgzftiz8VTOT8+ap5c0mpmFFSSYfKYQUX7
        h6AmmDXrrRgVkthEBMFQPUvkSWd+2Gr+XaOcoGeWp6nEaElj7lGwb0hEXOJeH1Uz1NilZf
        Ul/9CDPazlz0y0sr6TXjbnA8GgelORk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-XSUWKM7nNsK7zVi3Wt2o1g-1; Tue, 19 Jan 2021 04:57:04 -0500
X-MC-Unique: XSUWKM7nNsK7zVi3Wt2o1g-1
Received: by mail-wm1-f71.google.com with SMTP id u67so582225wmb.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 01:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bNRyaZttxpEG7FVOt6WsLq1WRbO39WhYVs3QVq8r02I=;
        b=Q52QPuKySqYb6pFa93XqU5QEwFSzTW+v43ZD/fUhsxfv9do94a8+svMHp9evlbDaPb
         OYCNUyRu/2/Qq0f0UA5wZHLveluOzQ1ykRB6SRx3pPS5zAOQInfxPRj6AM8tvtd0G9z9
         TUNzUM30z4WJIH4Lt/Cz0tvAordqZfDs9vR+NVPo4VfQ/a8luQarWDOdtClUX3p/94H9
         dzvIyim5Z9qMA/2vFXldGZgpfhQb36xmE37HO04uMNQkGB3T8m6y6clioC6ubeIhVHqj
         qyfJBieDR2o40CoAAACtllDs5bx5J/npnu7lqvTOXEyiAkNyzHlWcS9k3igTUK8x5851
         TlqQ==
X-Gm-Message-State: AOAM531O/wXprWy/s+hCAxxsOcRxyJiqddEvwGD5/4uV0QN2KumLkwWe
        dBCFd6fvc0kuppzYTQ50xWo7dwQCfqi2bs3THqIBP7QBVZQNzfp3VS2fhiW7vrv8vhvV+z2etBN
        dqX6KSaHTOZcrYB+b
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr3227475wme.101.1611050223182;
        Tue, 19 Jan 2021 01:57:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzljllNLi4pZd/bZsm2jwBEfi1V9esgxcyPjjC987+7SFdyACV8fewUuKTnkYXx3B7S3wBZVw==
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr3227459wme.101.1611050223061;
        Tue, 19 Jan 2021 01:57:03 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id q7sm2918408wrx.18.2021.01.19.01.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 01:57:02 -0800 (PST)
Date:   Tue, 19 Jan 2021 04:56:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        jasowang@redhat.com, willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when sendmsg
 fails
Message-ID: <20210119045607-mutt-send-email-mst@kernel.org>
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
 <20210118143329.08cc14a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118143329.08cc14a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 02:33:29PM -0800, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 12:46:20 +0800 wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> > 
> > Currently the driver doesn't drop a packet which can't be sent by tun
> > (e.g bad packet). In this case, the driver will always process the
> > same packet lead to the tx queue stuck.
> > 
> > To fix this issue:
> > 1. in the case of persistent failure (e.g bad packet), the driver
> >    can skip this descriptor by ignoring the error.
> > 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
> >    the driver schedules the worker to try again.
> > 
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> 
> Michael, LMK if you want to have a closer look otherwise I'll apply
> tomorrow.

Thanks for the reminder. Acked.

-- 
MST

