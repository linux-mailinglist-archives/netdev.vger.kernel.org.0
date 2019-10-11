Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B07D429C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfJKOTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbfJKOTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:19:21 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EEF9CC057E3C
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:19:20 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id 59so9577125qtc.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tOHWk3jmfyzzhm92cDghOddICmz8kRnulovjwgtaBGg=;
        b=JBUEMGHkrLplKWsJF/xn/ePbI+qy95FbmabzNrXat2uJ7/Yn3cbVdh9JVTrnsrH/EK
         vOvAHpGxHCXABnnT9Qg7J6AyfVmgipz2V+EGQahQDTvaPZsWboHq/KNgn61DA2+zzKrv
         b9R7rbiVmlsnMfpPa5lG/fvgQjDoFQsuriVg1mRgJ+lWqRnhECmYV5i+J6E8eev5dKKb
         6GS6Fxrz6NxbP1tfvpulYyI4uxKmurfDICE2znjEg9LdbcYZS+KZXQ5LR+GvBsYQModl
         qSC7/f9R5I/PPDGk9PFynpjbQr1pbkV4Wn3gPhskWj9awi4cnY/FCZEs/2yf9y0HXggO
         qxZQ==
X-Gm-Message-State: APjAAAXG8hKL4zyM3iKEVMpUoe917IuG01LiMEjrflvPnkjNla6wO2y9
        +VLuyig93VzVAbey9irERWqn8cr4hIXdAslw/+52r/6uDrHBdNEUZhoVEHTzCn487u7MjvmOywj
        0Sj5DiYFutfjU7wy8
X-Received: by 2002:a37:5d3:: with SMTP id 202mr15754098qkf.155.1570803559737;
        Fri, 11 Oct 2019 07:19:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy+WP4PnUirSsaoubHKJFArFKDsMl3YSsGut8UXfiBxoMA6BIkgeYPrju7GgkVsxDH1VHgtqQ==
X-Received: by 2002:a37:5d3:: with SMTP id 202mr15754075qkf.155.1570803559502;
        Fri, 11 Oct 2019 07:19:19 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id s16sm3621356qkg.40.2019.10.11.07.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:19:18 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:19:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] vsock: don't allow half-closed socket in the
 host transports
Message-ID: <20191011101408-mutt-send-email-mst@kernel.org>
References: <20191011130758.22134-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130758.22134-1-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:07:56PM +0200, Stefano Garzarella wrote:
> We are implementing a test suite for the VSOCK sockets and we discovered
> that vmci_transport never allowed half-closed socket on the host side.
> 
> As Jorgen explained [1] this is due to the implementation of VMCI.
> 
> Since we want to have the same behaviour across all transports, this
> series adds a section in the "Implementation notes" to exaplain this
> behaviour, and changes the vhost_transport to behave the same way.
> 
> [1] https://patchwork.ozlabs.org/cover/847998/#1831400

Half closed sockets are very useful, and lots of
applications use tricks to swap a vsock for a tcp socket,
which might as a result break.

If VMCI really cares it can implement an ioctl to
allow applications to detect that half closed sockets aren't supported.

It does not look like VMCI wants to bother (users do not read
kernel implementation notes) so it does not really care.
So why do we want to cripple other transports intentionally?



> Stefano Garzarella (2):
>   vsock: add half-closed socket details in the implementation notes
>   vhost/vsock: don't allow half-closed socket in the host
> 
>  drivers/vhost/vsock.c    | 17 ++++++++++++++++-
>  net/vmw_vsock/af_vsock.c |  4 ++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> -- 
> 2.21.0
