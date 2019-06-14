Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D121045470
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfFNGAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:00:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34089 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfFNGAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 02:00:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so1238152qtu.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 23:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=efc/3pP42c2xH161hq7c5fUGxxRKvsoQSDLLv7qrpIg=;
        b=MsOpO22JA9rYr/NsSzIqUt1TdDorJgZBenNs+vpP+yfu/7OzQw8tLgnXUDIS/li6KU
         bqBsagyXqYi+B12Jor9C2+4fT5y4DftMZOLma4d1X4tegtqYdyg4dXPAOD4BGonNztqk
         ygJZfIRVyAWUGIQpNg4/SPzXlW2jnXNcyIXmNBWbDH5HpsbwFd1wHn8Z+aL6McAWks+n
         jK70YPz0rDRGPK1XEzz0r0fmIVOQiIq2n+mKolgUhPHtcLAlsFGzdYYU57oGXSs3nYI5
         WhT13YFUIQFZ9mu2JN4owyC5TFNFaRERypghKM3CnZf3BNQw9DwWot/DtlVtFWzX9IlH
         jsIA==
X-Gm-Message-State: APjAAAVbYAIlz6tO/lHYx0E+Uhg8osNMriciJawUgk1EvZ7K+yN/K2qu
        iyGsA1S6gkLjh6VSvbXmNNy0xA==
X-Google-Smtp-Source: APXvYqy9559I0zvB5EppfBoN8w2FoKErCCHBXYfdHzzqvlJUsTh3YaFRDsuB9LIl9WGPs55OJii3aA==
X-Received: by 2002:ac8:16ac:: with SMTP id r41mr79833907qtj.346.1560492013866;
        Thu, 13 Jun 2019 23:00:13 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id s35sm1196348qth.79.2019.06.13.23.00.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 23:00:12 -0700 (PDT)
Date:   Fri, 14 Jun 2019 02:00:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] virtio_net: enable napi_tx by default
Message-ID: <20190614013506-mutt-send-email-mst@kernel.org>
References: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
 <c43051c5-144a-5aa4-2387-8fb42442f455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c43051c5-144a-5aa4-2387-8fb42442f455@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 11:28:59AM +0800, Jason Wang wrote:
> 
> On 2019/6/14 上午12:24, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> > 
> > NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
> > TSQ reduces queuing ("bufferbloat") and burstiness.
> > 
> > Previous measurements have shown significant improvement for
> > TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
> > ("Merge branch 'virtio-net-tx-napi'").
> > 
> > There has been uncertainty about smaller possible regressions in
> > latency due to increased reliance on tx interrupts.
> > 
> > The above results did not show that, nor did I observe this when
> > rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
> > same rack. This may be subject to other settings, notably interrupt
> > coalescing.
> > 
> > In the unlikely case of regression, we have landed a credible runtime
> > solution. Ethtool can configure it with -C tx-frames [0|1] as of
> > commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").
> > 
> > NAPI tx mode has been the default in Google Container-Optimized OS
> > (COS) for over half a year, as of release M70 in October 2018,
> > without any negative reports.
> > 
> > Link: https://marc.info/?l=linux-netdev&m=149305618416472
> > Link: https://lwn.net/Articles/507065/
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > 
> > ---
> > 
> > now that we have ethtool support and real production deployment,
> > it seemed like a good time to revisit this discussion.
> 
> 
> I agree to enable it by default. Need inputs from Michael. One possible
> issue is we may get some regression on the old machine without APICV, but
> consider most modern CPU has this feature, it probably doesn't matter.
> 
> Thanks
> 

Right. If the issue does arise we can always add e.g. a feature flag
to control the default from the host.


> > 
> > ---
> >   drivers/net/virtio_net.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 0d4115c9e20b..4f3de0ac8b0b 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -26,7 +26,7 @@
> >   static int napi_weight = NAPI_POLL_WEIGHT;
> >   module_param(napi_weight, int, 0444);
> > -static bool csum = true, gso = true, napi_tx;
> > +static bool csum = true, gso = true, napi_tx = true;
> >   module_param(csum, bool, 0444);
> >   module_param(gso, bool, 0444);
> >   module_param(napi_tx, bool, 0644);
