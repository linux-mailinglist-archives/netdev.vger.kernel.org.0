Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AED11CDA4
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfLLM4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:56:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33534 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729302AbfLLM4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 07:56:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576155395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQ/OeprMEEQbDYMzEQzXy36w02TkBbbXNkwJyG1iOw4=;
        b=NG0B5axReVWy8EKhw0y/n1xkmsDj3eGaqcaqk4NgkXUofXU/szFHC2dBvpG+2WZKjri+5q
        vMCNjxI1MC/+xK/gRZLIgPHFBdWEaLwS+dvCMzx76DR9szCPIkJdLyQFDI/48NUder+6XN
        LrQuhYMeq50hgZjhfedEoFfKiNJjt8o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-9j6f3yojPCyfb5Dm21lbFg-1; Thu, 12 Dec 2019 07:56:32 -0500
X-MC-Unique: 9j6f3yojPCyfb5Dm21lbFg-1
Received: by mail-qv1-f70.google.com with SMTP id d7so1412955qvq.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 04:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQ/OeprMEEQbDYMzEQzXy36w02TkBbbXNkwJyG1iOw4=;
        b=SpSrGbqhSp/lISvW37dlIwdOH94GSirve5Akrl6Jx84GuilpxausrAqBdzhwCpSl0H
         e63ayFoPRDibNNDwz4rPZqbdElw2DdXN68+WXvWjjnxCwi/Rf7Nw1x0Bzstdetxn/NNF
         NZFvZLWExTl+7lFh37cboBJerPAT2aO8WRTPdEA4HRAnD5upj18aHQziqkAZ8kK5LpyI
         x0U6rZLg5YET/0MEbGR2d0pcDDx4pXindHcSdrKRkWcuye3I8c9XgoCGhYgAfMCFzYj7
         OZuhKYOY/Pg7zbtSHPk+HRBzDYQMbx17VjUyvXSaRwawFHsCTYIVVKLgi9VY0yqusRNB
         xVQw==
X-Gm-Message-State: APjAAAXF6BoWJRAnSvf/CBoNx+k1wzCQCG1N9/toCZAbeKD+IKzEdE0p
        o7rGLiuqOMJGo2XTFefldW8XR9RdD0nNDrUUiVDmn+CxJog3AcBhMh21zSf6al0ePA53joMSY3B
        k0TT0c2STAGlVycGP
X-Received: by 2002:ac8:1196:: with SMTP id d22mr7374523qtj.344.1576155392076;
        Thu, 12 Dec 2019 04:56:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGAOqNeoXt3nIrQGWq7m2hfYKhqzgGGgHCw70gSt6fz7ekSW8rLr9/hwp3tuH2X5BB5yIhKQ==
X-Received: by 2002:ac8:1196:: with SMTP id d22mr7374504qtj.344.1576155391867;
        Thu, 12 Dec 2019 04:56:31 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id d23sm2191968qte.32.2019.12.12.04.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 04:56:30 -0800 (PST)
Date:   Thu, 12 Dec 2019 07:56:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191212075356-mutt-send-email-mst@kernel.org>
References: <20191206143912.153583-1-sgarzare@redhat.com>
 <20191211110235-mutt-send-email-mst@kernel.org>
 <20191212123624.ahyhrny7u6ntn3xt@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212123624.ahyhrny7u6ntn3xt@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:36:24PM +0100, Stefano Garzarella wrote:
> On Wed, Dec 11, 2019 at 11:03:07AM -0500, Michael S. Tsirkin wrote:
> > On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> > > When we receive a new packet from the guest, we check if the
> > > src_cid is correct, but we forgot to check the dst_cid.
> > > 
> > > The host should accept only packets where dst_cid is
> > > equal to the host CID.
> > > 
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > Stefano can you clarify the impact pls?
> 
> Sure, I'm sorry I didn't do it earlier.
> 
> > E.g. is this needed on stable? Etc.
> 
> This is a better analysis (I hope) when there is a malformed guest
> that sends a packet with a wrong dst_cid:
> - before v5.4 we supported only one transport at runtime, so the sockets
>   in the host can only receive packets from guests. In this case, if
>   the dst_cid is wrong, maybe the only issue is that the getsockname()
>   returns an inconsistent address (the cid returned is the one received
>   from the guest)
> 
> - from v5.4 we support multi-transport, so the L1 VM (e.g. L0 assigned
>   cid 5 to this VM) can have both Guest2Host and Host2Guest transports.
>   In this case, we have these possible issues:
>   - L2 (or L1) guest can use cid 0, 1, and 2 to reach L1 (or L0),
>     instead we should allow only CID_HOST (2) to reach the level below.
>     Note: this happens also with not malformed guest that runs Linux v5.4
>   - if a malformed L2 guest sends a packet with the wrong dst_cid, for example
>     instead of CID_HOST, it uses the cid assigned by L0 to L1 (5 in this
>     example), this packets can wrongly queued to a socket on L1 bound to cid 5,
>     that only expects connections from L0.

Oh so a security issue?

> 
> Maybe we really need this only on stable v5.4, but the patch is very simple
> and should apply cleanly to all stable branches.
> 
> What do you think?
> 
> Thanks,
> Stefano

I'd say it's better to backport to all stable releases where it applies,
but yes it's only a security issue in 5.4.  Dave could you forward pls?

-- 
MST

