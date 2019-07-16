Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2396A667
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 12:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbfGPKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 06:22:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38676 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGPKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 06:22:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so20316430wrr.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 03:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=smhcNCF3QZCjfbSBTphGFkxRSXnqQ2w3E9AxAE5LvCI=;
        b=rMXjsxIMHFmxvXCV6OdVhI2xP0JwmYympXGOytQAZrd7vc8O8ivVR0N6KRjcqxSYo5
         v39cc9kKbGkm3X20ZCkCqfxOPuyOa/72Iy+ewQSavpBSW74/WJjP/TCYX8lbgNtP/LkH
         r8vaTWJGOEm48Uf+FihJvDEDBGcUIbhokfdPFcWrrJNY+4pRz10nlCURkonmg58jI4Mr
         N98TulAdT/xzkK32gn9EWiP8FD54b7CoG731Bn4LOyshtnA8RRc74lkotsLlf1xTpq2A
         Z+UTp/R340dJKgXCOAZ3CYHF6IDEh/BRgsPNsW2GjztF1UaLC5Bx9a+XL6I0C/23nqUG
         Y3wA==
X-Gm-Message-State: APjAAAWQm0ZAUZJlb3/KoGDwVBJiXHDi2sSLp0qfBWzY/+aRYg0IETvR
        ak6vG2Ja2Kc4CpJproqfUMwKgw==
X-Google-Smtp-Source: APXvYqyg2hrBQwkYKUpfFSVJBuo0b7N0PorjCPKDNYNI7q3PPk8rrBkrfyejKvxdyaYxyU+U5gDF7Q==
X-Received: by 2002:adf:d08e:: with SMTP id y14mr7969596wrh.309.1563272535581;
        Tue, 16 Jul 2019 03:22:15 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id s12sm18227457wmh.34.2019.07.16.03.22.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 03:22:15 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:22:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190716102213.b6lerchbwm7rwz54@steredhat>
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
 <20190711114134.xhmpciyglb2angl6@steredhat>
 <20190711152855-mutt-send-email-mst@kernel.org>
 <20190712100033.xs3xesz2plfwj3ag@steredhat>
 <a514d8a4-3a12-feeb-4467-af7a9fbf5183@redhat.com>
 <20190715074416.a3s2i5ausognotbn@steredhat>
 <20190715134115-mutt-send-email-mst@kernel.org>
 <20190716094024.ob43g5lxga5uwb7z@steredhat>
 <20190716055837-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716055837-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 06:01:33AM -0400, Michael S. Tsirkin wrote:
> On Tue, Jul 16, 2019 at 11:40:24AM +0200, Stefano Garzarella wrote:
> > On Mon, Jul 15, 2019 at 01:50:28PM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Jul 15, 2019 at 09:44:16AM +0200, Stefano Garzarella wrote:
> > > > On Fri, Jul 12, 2019 at 06:14:39PM +0800, Jason Wang wrote:
> > 
> > [...]
> > 
> > > > > 
> > > > > 
> > > > > I think it's just a branch, for ethernet, go for networking stack. otherwise
> > > > > go for vsock core?
> > > > > 
> > > > 
> > > > Yes, that should work.
> > > > 
> > > > So, I should refactor the functions that can be called also from the vsock
> > > > core, in order to remove "struct net_device *dev" parameter.
> > > > Maybe creating some wrappers for the network stack.
> > > > 
> > > > Otherwise I should create a fake net_device for vsock_core.
> > > > 
> > > > What do you suggest?
> > > 
> > > Neither.
> > > 
> > > I think what Jason was saying all along is this:
> > > 
> > > virtio net doesn't actually lose packets, at least most
> > > of the time. And it actually most of the time
> > > passes all packets to host. So it's possible to use a virtio net
> > > device (possibly with a feature flag that says "does not lose packets,
> > > all packets go to host") and build vsock on top.
> > 
> > Yes, I got it after the latest Jason's reply.
> > 
> > > 
> > > and all of this is nice, but don't expect anything easy,
> > > or any quick results.
> > 
> > I expected this... :-(
> > 
> > > 
> > > Also, in a sense it's a missed opportunity: we could cut out a lot
> > > of fat and see just how fast can a protocol that is completely
> > > new and separate from networking stack go.
> > 
> > In this case, if we will try to do a PoC, what do you think is better?
> >     1. new AF_VSOCK + network-stack + virtio-net modified
> >         Maybe it is allow us to reuse a lot of stuff already written,
> >         but we will go through the network stack
> > 
> >     2. new AF_VSOCK + glue + virtio-net modified
> >         Intermediate approach, similar to Jason's proposal
> > 
> >     3, new AF_VSOCK + new virtio-vsock
> >         Can be the thinnest, but we have to rewrite many things, with the risk
> >         of making the same mistakes as the current implementation.
> > 
> 
> 1 or 3 imho. I wouldn't expect a lot from 2.  I slightly favor 3 and
> Jason 1. So take your pick :)
> 

Yes, I agree :)

Maybe "Jason 1" could be the short term (and an opportunity to study better the
code and sources of overhead) and "new AF_VSOCK + new virtio-vsock" the long
term goal with the multi-transport support in mind.

Thank you so much for your guidance and useful advice,
Stefano
