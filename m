Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF21D4313
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfJKOjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfJKOje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:39:34 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78036CD4CD
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:39:34 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id s19so2875273wmj.0
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=liQbAgHSmXMDz2MwPXfH9RoWMwZsEiL9QVC3TV8t25k=;
        b=CZj9+8bXYUi/YQbXnR7y21e5fxHq98Jv3uOmtRCL4S0w7vercjirq8U1xTjj5dRQrW
         hukLc95MMekiU6Aim4ZmsRT4wmmAthltIokNaW93PAi+3XZ6oP2kJc4P2iWN3if1pGmX
         IU+WlmJLAT6HZ3pz+JkbwdjB6jqJoYI5sjvSCzXDJkp1Her52q9ogQxB2vJJqHW2GS/x
         vUVOYxOKkMFo6GBPP01G/4XqHJ9F6yTcT4Dvy/PvSzisvmnsPuaNYThc3hFVB9v0vcLp
         Yitsyqeuqn5Dh17NQQGHz7NxGDMRwoIToQ9wALzTUps92f9uDEd+x92Nz5gDa77tcpuh
         mBZg==
X-Gm-Message-State: APjAAAVvb3ttEF0uqBci4dGS/nYprswFuQpJffLV0Y4ws+293lcUeqPb
        4QN1cyiwBBn8AHFBQq26sV5D3G3WBg/86XBBGxyK/llK/qFuQSyWu5hj+qvk4lvmYGs34zwvNE4
        LfChfzGON6X/APNxq
X-Received: by 2002:a5d:6984:: with SMTP id g4mr13566584wru.43.1570804773105;
        Fri, 11 Oct 2019 07:39:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOgGfiWykQOZWxvAQCAQ5lTZZlOEdFhFzDrlVB3KHciz9JN8beokYLGpmV6a5f51pd2LT9pQ==
X-Received: by 2002:a5d:6984:: with SMTP id g4mr13566561wru.43.1570804772906;
        Fri, 11 Oct 2019 07:39:32 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id u25sm9661696wml.4.2019.10.11.07.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:39:32 -0700 (PDT)
Date:   Fri, 11 Oct 2019 16:39:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost/vsock: don't allow half-closed socket in
 the host
Message-ID: <20191011143930.hs2pkz5i2bci7igs@steredhat>
References: <20191011130758.22134-1-sgarzare@redhat.com>
 <20191011130758.22134-3-sgarzare@redhat.com>
 <20191011102246-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011102246-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:26:34AM -0400, Michael S. Tsirkin wrote:
> On Fri, Oct 11, 2019 at 03:07:58PM +0200, Stefano Garzarella wrote:
> > vmci_transport never allowed half-closed socket on the host side.
> > In order to provide the same behaviour, we changed the
> > vhost_transport_stream_has_data() to return 0 (no data available)
> > if the peer (guest) closed the connection.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> I don't think we should copy bugs like this.
> Applications don't actually depend on this VMCI limitation, in fact
> it looks like a working application can get broken by this.
> 
> So this looks like a userspace visible ABI change
> which we can't really do.
> 
> If it turns out some application cares, it can always
> fully close the connection. Or add an ioctl so the application
> can find out whether half close works.
> 

I got your point.
Discard this patch.

Thanks,
Stefano
