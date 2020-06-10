Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A31F5768
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgFJPNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:13:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729987AbgFJPNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591802024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YfhNq/fazdZ8Eyi5klTe6PYJfVDAk96bmheZ7cnvsnc=;
        b=JHaVso3xMNK+7+AfS/odc+GBJV9Zp+2wbNM33utjOn2SE1nQanj/jmhGdYqDRV+19Gvclg
        X1EtUZpcoDQgB/n6jU9cbhgTpKGG8RNXaHkHAnLiAStwC4nzUEHvFqzjFOoDHDQYKU8B1h
        vJH/eyYsY8SLeePn/cTo4nvje7IqoHU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-IclCJF7FO0C0uA-w4MhSzw-1; Wed, 10 Jun 2020 11:13:42 -0400
X-MC-Unique: IclCJF7FO0C0uA-w4MhSzw-1
Received: by mail-wr1-f71.google.com with SMTP id w4so1215964wrl.13
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YfhNq/fazdZ8Eyi5klTe6PYJfVDAk96bmheZ7cnvsnc=;
        b=qDTFmtX89ujalgKrfhIYfSbQc3Bx0IsRFYziXXWAuuhaLr9gKRd41lUCUapf56xDmO
         w4Cn1roFf7AXaRZxhpxXdwFJA9BYhpqRPBEEtvF91xRQJyXLFTK03GfDqtz6D8SVOb5V
         NEq+ajaTslxHKArwgKBBEiVIOVoleI6WSbYhNATokfUyBpG++qDAyBbn3hvOn0+856f0
         um/cuP1EuEw0V3h4kzl/ogLyjPC9gCm88YDL0+rSr/0QO++wukL+wHNNwyeHw9zAR7S5
         sz7EogFRjzSZOHlK7s8GzrxH+Gh6Z+kFzxFMCdmL+SidTqGl4HBcyLniv11UecSMRtHw
         2o/A==
X-Gm-Message-State: AOAM531bIhlyr+JdOahwdRkXzeeGLmE0G2Uyu8nUb3qeedNInPqfVMsM
        RtQ6t02qcFmzYU+3N/dQ6HtkQ6aDoTI/YZ82ArPIcQv+qc0nTCJq5zQdmu12OqyQFZRwnUUyWcC
        gklwUAHjCDW1XC5Xb
X-Received: by 2002:a1c:c3d7:: with SMTP id t206mr3730155wmf.69.1591802020738;
        Wed, 10 Jun 2020 08:13:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww1vH7zy+FsH/SZuuGBRzDcjEXQict36Ept0NkVt1LYqloJMLuBhZhh8r1NCU9jdQ8aYiDHA==
X-Received: by 2002:a1c:c3d7:: with SMTP id t206mr3730071wmf.69.1591802019527;
        Wed, 10 Jun 2020 08:13:39 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id m24sm51095wmi.14.2020.06.10.08.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 08:13:38 -0700 (PDT)
Date:   Wed, 10 Jun 2020 11:13:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
Message-ID: <20200610111147-mutt-send-email-mst@kernel.org>
References: <20200610113515.1497099-1-mst@redhat.com>
 <20200610113515.1497099-4-mst@redhat.com>
 <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrote:
> > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > + * A negative code is returned on error. */
> > +static int fetch_descs(struct vhost_virtqueue *vq)
> > +{
> > +       int ret;
> > +
> > +       if (unlikely(vq->first_desc >= vq->ndescs)) {
> > +               vq->first_desc = 0;
> > +               vq->ndescs = 0;
> > +       }
> > +
> > +       if (vq->ndescs)
> > +               return 1;
> > +
> > +       for (ret = 1;
> > +            ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > +            ret = fetch_buf(vq))
> > +               ;
> 
> (Expanding comment in V6):
> 
> We get an infinite loop this way:
> * vq->ndescs == 0, so we call fetch_buf() here
> * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descriptors. ret = 1
> * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_vq ==
> last_avail_vq), so it just return 1

That's what
	 [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
is supposed to fix.

-- 
MST

