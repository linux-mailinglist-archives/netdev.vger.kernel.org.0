Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E667D522A
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbfJLT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbfJLT0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 15:26:16 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BE41C054C58
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 19:26:16 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id h4so455972wrx.15
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NER+WYNjIiTuYyELfX6XGxRMHyIeb8bjpkbmjz8T8Lw=;
        b=tbMlfZ8v8v5XPy7qLfWl3OyPOJjYSyVqH5juRUE2VmX/dxBsRDrpB3TyLP+K3nBIRX
         5o8woO5mOYFVTFt5Gr5e0ZM9GgubXctpOIHz3d1pCUZ5K6rlkrY7NOJ0HHreJoQQFNpV
         wbypPtMcIyhPA82OtiLpIU/ZLBDUsfVbMxtPBmhEzvr4EgiacnepCMZDN7W9ip43q1Kx
         jeoTSIpcAtHgekjr5/koIeP65rE8ASj4Nl/l5N/pl5rL1kM3DrCV8Tyg0xXK/wsKC7c9
         ynz3nmo9iHDHTXb5zOqIrJmqxlIyxQSUS4vCHgieHjJzpdUEdJRvwjcGF8bN84va3OXi
         c7gA==
X-Gm-Message-State: APjAAAVhxZAjq6frdvSrA3dTiUcsQwwbC2Th1qmoVQi4bFjECRjuQM10
        9h+SoSIPMoLOdcZUI4b7ww6SRx9CSy+xmJsKQlGOKWBSaEBcd2U8Ddhs+YwmDdU+CzohzkRwgTB
        4VPhgIFmZpHQMMG3t
X-Received: by 2002:adf:e90d:: with SMTP id f13mr18704544wrm.104.1570908374717;
        Sat, 12 Oct 2019 12:26:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwzVc4L36wZsuw/yIheWC3DcZ/4dWluqHH2rLuU6KbnjXtc/R53950cBJ1bTedee2IPkXIj5Q==
X-Received: by 2002:adf:e90d:: with SMTP id f13mr18704533wrm.104.1570908374478;
        Sat, 12 Oct 2019 12:26:14 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id r6sm14770346wmh.38.2019.10.12.12.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:26:13 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:26:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/2] vhost: ring format independence
Message-ID: <20191012152332-mutt-send-email-mst@kernel.org>
References: <20191011134358.16912-1-mst@redhat.com>
 <f650ac1a-6e2a-9215-6e4f-a1095f4a89cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f650ac1a-6e2a-9215-6e4f-a1095f4a89cd@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 04:15:42PM +0800, Jason Wang wrote:
> 
> On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
> > So the idea is as follows: we convert descriptors to an
> > independent format first, and process that converting to
> > iov later.
> > 
> > The point is that we have a tight loop that fetches
> > descriptors, which is good for cache utilization.
> > This will also allow all kind of batching tricks -
> > e.g. it seems possible to keep SMAP disabled while
> > we are fetching multiple descriptors.
> 
> 
> I wonder this may help for performance:

Could you try it out and report please?
Would be very much appreciated.

> - another indirection layer, increased footprint

Seems to be offset off by improved batching.
For sure will be even better if we can move stac/clac out,
or replace some get/put user with bigger copy to/from.

> - won't help or even degrade when there's no batch

I couldn't measure a difference. I'm guessing

> - an extra overhead in the case of in order where we should already had
> tight loop

it's not so tight with translation in there.
this exactly makes the loop tight.

> - need carefully deal with indirect and chain or make it only work for
> packet sit just in a single descriptor
> 
> Thanks

I don't understand this last comment.

> 
> > 
> > And perhaps more importantly, this is a very good fit for the packed
> > ring layout, where we get and put descriptors in order.
> > 
> > This patchset seems to already perform exactly the same as the original
> > code already based on a microbenchmark.  More testing would be very much
> > appreciated.
> > 
> > Biggest TODO before this first step is ready to go in is to
> > batch indirect descriptors as well.
> > 
> > Integrating into vhost-net is basically
> > s/vhost_get_vq_desc/vhost_get_vq_desc_batch/ -
> > or add a module parameter like I did in the test module.
> > 
> > 
> > 
> > Michael S. Tsirkin (2):
> >    vhost: option to fetch descriptors through an independent struct
> >    vhost: batching fetches
> > 
> >   drivers/vhost/test.c  |  19 ++-
> >   drivers/vhost/vhost.c | 333 +++++++++++++++++++++++++++++++++++++++++-
> >   drivers/vhost/vhost.h |  20 ++-
> >   3 files changed, 365 insertions(+), 7 deletions(-)
> > 
