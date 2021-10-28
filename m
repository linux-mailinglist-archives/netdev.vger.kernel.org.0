Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C7443D951
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJ1Cb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:31:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhJ1Cb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 22:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635388139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ai5EJYH+XM1xHPGl2sOT1f/06ywkQNnnLxzitLQLLRk=;
        b=Elm1cvxtX1bhGNqColxrA88KBRYpj3ywaIIwqshyAKSkG3teJTcTZC8Xq3wbY4KdZAA71n
        KFUz38s1yZf+xILxk8i44gz9Em8E3wPgFaIsk+CcQE5k/8VqlpW/U9O1SGPiYXhV/Lq2Bk
        GBQHLIBglvJWxNL5lHSdSx78nGClhKc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-Iuca1VMZPNCH-AF69Xy4aw-1; Wed, 27 Oct 2021 22:28:58 -0400
X-MC-Unique: Iuca1VMZPNCH-AF69Xy4aw-1
Received: by mail-lf1-f72.google.com with SMTP id i1-20020a056512340100b003fdd5b951e0so2149262lfr.22
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 19:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ai5EJYH+XM1xHPGl2sOT1f/06ywkQNnnLxzitLQLLRk=;
        b=KI7nEhdr4YoTgqE/dUj7UgGtiD3sbgZIOBjqqtO1oXC5LRjjCSQFE1PfC3kj+haNNR
         d/TkVxjvfaad6gpEUQVWCzYAbLFhq9pMPIJHYYp2wJJJ7ScnW1aek7w7LrpmE0iHzCQk
         zA14bmvyTrNt6qXZQUFQeUF1Yko/sTPJZzj4ea3NymDENIgoEo38RAVlmhLNBPnPLVHd
         zOLw5/ouMJA5LKGyvAFuLVEEd4fsiWMjH9xdQMeeo95sNXt1/xy3o57HKNGWw5kA6yWI
         M1wyleZnnaT1G4FQrDGMn9oGGau7KRWpEaZREIibvauoIxqURZ9XkvN6XJCJ3GATsBbV
         GUvg==
X-Gm-Message-State: AOAM5300iaUWK9V1al0V/w7e3lvP74uvhFCVV6V61QfaQ+J88Cu8vHl9
        HjZl6E1Ru+NrzVrs9V1IqkVyaDU6dmx2piQeHAMZPUIN+WXOj1rZcBPG5VceinuIc8yUXAzYjrJ
        s4ILe/Ta1dE+vPOlhStL9zxZuXhjEc9Hf
X-Received: by 2002:a05:6512:3d11:: with SMTP id d17mr1379155lfv.481.1635388136829;
        Wed, 27 Oct 2021 19:28:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyck4H1QE2hfPhL/QuSTnQR+n77jAyInsCjKIN0wFVzlktEE7qGyKmte6qKTmyTlDp9jCcZ9l+EVMHzWfMgyZg=
X-Received: by 2002:a05:6512:3d11:: with SMTP id d17mr1379143lfv.481.1635388136683;
 Wed, 27 Oct 2021 19:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211027085528.01c4b313@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1635386220.8124611-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1635386220.8124611-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Oct 2021 10:28:45 +0800
Message-ID: <CACGkMEs0V7Hy2mkQymCyVBYAaM7tM=Wj7d+tfxTOg8zJdr4YDA@mail.gmail.com>
Subject: Re: [PATCH 3/3] virtio-net: enable virtio indirect cache
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 9:59 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Wed, 27 Oct 2021 08:55:28 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 27 Oct 2021 14:19:13 +0800 Xuan Zhuo wrote:
> > > +static bool virtio_desc_cache = true;
> > >  module_param(csum, bool, 0444);
> > >  module_param(gso, bool, 0444);
> > >  module_param(napi_tx, bool, 0644);
> > > +module_param(virtio_desc_cache, bool, 0644);
> >
> > Can this be an ethtool priv flag? module params are discouraged because
> > they can't be controlled per-netdev.
>
>
> The current design can only be set when the device is initialized. So using
> ethtool to modify it will not work.

Anyhow you can add things like synchronization to make it work. But I
think what we want is to make it work unconditionally, so having a
module parameter seems useless. If you want to use it for
benchmarking?

Thanks

>
> Thanks.
>

