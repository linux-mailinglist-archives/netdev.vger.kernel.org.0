Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A711CD4D
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfLLMgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:36:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729157AbfLLMgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 07:36:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576154190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vx9zJGf1oMGJUZXazsjSWnZ1RqAwmrURKhXjqCuTSZw=;
        b=hTmtLE3R+BlTeyJOH581i/0AVRT5Z4l3O0dz89qP//BI7ncyqS+uOdXWxttP80hECqlJRC
        nX3EuXek0LwHbl/nbxBNKW4diEOAbHYn86p7RjiYgVvpKlHcljP8PjvhBpoj1qFwcuWDVD
        6disNfMURYWiokmBX7+nXhperAH2U7Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-NHH4jUObMgOtoc-tGE42jg-1; Thu, 12 Dec 2019 07:36:29 -0500
X-MC-Unique: NHH4jUObMgOtoc-tGE42jg-1
Received: by mail-wr1-f71.google.com with SMTP id u12so970555wrt.15
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 04:36:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vx9zJGf1oMGJUZXazsjSWnZ1RqAwmrURKhXjqCuTSZw=;
        b=Ejw3Iot9lEvhv2RPt3W2vKkXezG3a8h/toecdgniok1KfAGKXmVlCEvqZfU3VPmiqL
         rngD0hBMio6neMcZJ5Ibglr/wo93mKvW1Op6xmluLcj9tMPypvndnjsdeUT/oMPVDB0h
         RIj4zC30hgkwPfwqpwboOL+2Eb7XUgZn+1I3bO3Cm9JengCijBfMk+dFJssHewu1Y7WG
         Tbwjh/uAoGOqhpjcmS56vJQYPRSYVVzppXT1HArHAPSQixf6pGcbC+YPm/V+1ryGvqzv
         1nAyacXqjEJwo3BFGElyXynX+Aqx4e5aaDuGhkVZXPP+Q75JpDglESLL1EGL4GoRzddV
         f4GQ==
X-Gm-Message-State: APjAAAWrWLr+7ZDgckJykiJrb2TvLZv+Tn1dFGSJuwm3Go8o5NWXQayp
        elTT4BF1VndqpKFyx7UWJV6DSHbauh9KFjIquq1Jn11OUk2/bEAfvqR9iwKCG74F5kAxlMoMBVM
        fX4ht9BsmPX9IjIo6
X-Received: by 2002:a1c:9893:: with SMTP id a141mr6328753wme.131.1576154187822;
        Thu, 12 Dec 2019 04:36:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqw8OuvK7uQUGPj2YPMKShfitWnCo2iXv2VXIudtkzMfeAvfFAzJUBd43fFj7MHbtZkQxZXP5g==
X-Received: by 2002:a1c:9893:: with SMTP id a141mr6328729wme.131.1576154187582;
        Thu, 12 Dec 2019 04:36:27 -0800 (PST)
Received: from steredhat ([95.235.120.92])
        by smtp.gmail.com with ESMTPSA id x10sm5861395wrp.58.2019.12.12.04.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 04:36:27 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:36:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191212123624.ahyhrny7u6ntn3xt@steredhat>
References: <20191206143912.153583-1-sgarzare@redhat.com>
 <20191211110235-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211110235-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:03:07AM -0500, Michael S. Tsirkin wrote:
> On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> > When we receive a new packet from the guest, we check if the
> > src_cid is correct, but we forgot to check the dst_cid.
> > 
> > The host should accept only packets where dst_cid is
> > equal to the host CID.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Stefano can you clarify the impact pls?

Sure, I'm sorry I didn't do it earlier.

> E.g. is this needed on stable? Etc.

This is a better analysis (I hope) when there is a malformed guest
that sends a packet with a wrong dst_cid:
- before v5.4 we supported only one transport at runtime, so the sockets
  in the host can only receive packets from guests. In this case, if
  the dst_cid is wrong, maybe the only issue is that the getsockname()
  returns an inconsistent address (the cid returned is the one received
  from the guest)

- from v5.4 we support multi-transport, so the L1 VM (e.g. L0 assigned
  cid 5 to this VM) can have both Guest2Host and Host2Guest transports.
  In this case, we have these possible issues:
  - L2 (or L1) guest can use cid 0, 1, and 2 to reach L1 (or L0),
    instead we should allow only CID_HOST (2) to reach the level below.
    Note: this happens also with not malformed guest that runs Linux v5.4

  - if a malformed L2 guest sends a packet with the wrong dst_cid, for example
    instead of CID_HOST, it uses the cid assigned by L0 to L1 (5 in this
    example), this packets can wrongly queued to a socket on L1 bound to cid 5,
    that only expects connections from L0.

Maybe we really need this only on stable v5.4, but the patch is very simple
and should apply cleanly to all stable branches.

What do you think?

Thanks,
Stefano

