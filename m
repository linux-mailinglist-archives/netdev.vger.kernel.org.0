Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E6111CDF6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 14:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfLLNPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 08:15:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729400AbfLLNPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 08:15:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576156499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fLjEJ9DPJesgnmsDD/FbLzKF663mvixPtyFrapicoaw=;
        b=Yr6Udbc1Kth7FNdlFtMjkRKjtZyQY646zYn8Lby2VVGZg58+YEpt/cV23SOSUs8LWd3vHi
        zuidZWyqiIE4bNprXQmJFKMImBZF9oFsASSWPG1boT7IFa8Q7Qi2hTS3yRenzWn4EpD2CZ
        h7xrXEM2823LGkaFqVLJYwOI1TgBdhg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-qVUu-OclO-KTe3_EusYE9g-1; Thu, 12 Dec 2019 08:14:58 -0500
X-MC-Unique: qVUu-OclO-KTe3_EusYE9g-1
Received: by mail-wr1-f71.google.com with SMTP id y7so1027529wrm.3
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 05:14:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fLjEJ9DPJesgnmsDD/FbLzKF663mvixPtyFrapicoaw=;
        b=Rm+mdSatO8GAR+NbVDfsqM6XZ5NHVfCULtjoGbrs7fMSp9Cmh7h6tPkui9jTNaNnsZ
         3Nsn1VJ42ljAyDM3XM3wdqSIQFVxrmC7Bk5I90TZk5GHBbs6wdpU9oBbpUNPl0N8iHTk
         KU0bKbOfzD8gnlgdVDikdpnhnPxkpKBpwznoBk2rUzeEatP6vCeBEKAydM2idhJfX+00
         ftr7pLvJpLi2FPC0R+D6o3+qAtsYGtuXpwBVMPZ/aty9xHrxuk3XdqKOP/Yq4UF4MHun
         ZycP+QNEq3As121kwYGwLf0eLY5XNVq5j5OWEmgFn3lBBGWpzImtPVyHH765BZvBUEhN
         RK6A==
X-Gm-Message-State: APjAAAVXXr19kjZ7SclmfZpQIsVAKDzJ8XpL3rq2rDdUdjbZksm7xYt8
        CHJeWSIp+dh3m3cjz4xSkbNGgzhCqMmTQ6SE3zA7aSwWGcVGzTeO5/1vjKXeCs5H8rlw4pS6Nmq
        51BzegOPhp9Xy9V+L
X-Received: by 2002:a5d:6708:: with SMTP id o8mr6343827wru.296.1576156496978;
        Thu, 12 Dec 2019 05:14:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfIILiE0bsGuZKwQ+0ufP4htjxim2PfR+3JovR5iPj+PI79E6uhhtXaVikmm1YgkD8oUUC6Q==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr6343805wru.296.1576156496681;
        Thu, 12 Dec 2019 05:14:56 -0800 (PST)
Received: from steredhat ([95.235.120.92])
        by smtp.gmail.com with ESMTPSA id e18sm5965389wrr.95.2019.12.12.05.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 05:14:56 -0800 (PST)
Date:   Thu, 12 Dec 2019 14:14:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191212131453.yocx6wckoluwofbb@steredhat>
References: <20191206143912.153583-1-sgarzare@redhat.com>
 <20191211110235-mutt-send-email-mst@kernel.org>
 <20191212123624.ahyhrny7u6ntn3xt@steredhat>
 <20191212075356-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212075356-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 07:56:26AM -0500, Michael S. Tsirkin wrote:
> On Thu, Dec 12, 2019 at 01:36:24PM +0100, Stefano Garzarella wrote:
> > On Wed, Dec 11, 2019 at 11:03:07AM -0500, Michael S. Tsirkin wrote:
> > > On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> > > > When we receive a new packet from the guest, we check if the
> > > > src_cid is correct, but we forgot to check the dst_cid.
> > > > 
> > > > The host should accept only packets where dst_cid is
> > > > equal to the host CID.
> > > > 
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > 
> > > Stefano can you clarify the impact pls?
> > 
> > Sure, I'm sorry I didn't do it earlier.
> > 
> > > E.g. is this needed on stable? Etc.
> > 
> > This is a better analysis (I hope) when there is a malformed guest
> > that sends a packet with a wrong dst_cid:
> > - before v5.4 we supported only one transport at runtime, so the sockets
> >   in the host can only receive packets from guests. In this case, if
> >   the dst_cid is wrong, maybe the only issue is that the getsockname()
> >   returns an inconsistent address (the cid returned is the one received
> >   from the guest)
> > 
> > - from v5.4 we support multi-transport, so the L1 VM (e.g. L0 assigned
> >   cid 5 to this VM) can have both Guest2Host and Host2Guest transports.
> >   In this case, we have these possible issues:
> >   - L2 (or L1) guest can use cid 0, 1, and 2 to reach L1 (or L0),
> >     instead we should allow only CID_HOST (2) to reach the level below.
> >     Note: this happens also with not malformed guest that runs Linux v5.4
> >   - if a malformed L2 guest sends a packet with the wrong dst_cid, for example
> >     instead of CID_HOST, it uses the cid assigned by L0 to L1 (5 in this
> >     example), this packets can wrongly queued to a socket on L1 bound to cid 5,
> >     that only expects connections from L0.
> 
> Oh so a security issue?
> 

It seems so, I'll try to see if I can get a real example,
maybe I missed a few checks.

> > 
> > Maybe we really need this only on stable v5.4, but the patch is very simple
> > and should apply cleanly to all stable branches.
> > 
> > What do you think?
> > 
> > Thanks,
> > Stefano
> 
> I'd say it's better to backport to all stable releases where it applies,
> but yes it's only a security issue in 5.4.  Dave could you forward pls?

Yes, I agree with you.

@Dave let me know if I should do it.

Thanks,
Stefano

