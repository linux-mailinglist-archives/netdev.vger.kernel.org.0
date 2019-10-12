Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1AD5276
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfJLUig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 16:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbfJLUif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 16:38:35 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 759BE81F0E
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 20:38:35 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i10so6296596wrb.20
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 13:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zmPj2OxDNyXZOWfS3El2cDjqPuAIR1jv4Mzr0dbrQms=;
        b=sg0sfIVboxMETIZ6n3GYv58kZdeyKlxBzqC77DTB1Hys+mJAw78Vre8/+MSM7oTbNU
         rj9QVlnIexsiKXsJ0+sh4HObJVWCcMH/3u4lnvPQBHbeqd1ISqoOU5P3naG33hjvsyv4
         gVfAydqOqJu+QfOYVqk6vWMyi3Enb0Ic4vy45WbISyCXCwXxOYh0WFmZAzKey3PwDzXE
         /wxBkGOyDGor9+aXrbMQJO7uH5/lx3CdkQrIcBXDlW9oil/Z2uvHKLMXNddl/ddbFeGz
         CYB3Js9TRptvmJpgQRvNPx6by86UG/E6HSwfm/mnDUmA93gphVTus4DGm0rY4E6QmHQR
         QXQg==
X-Gm-Message-State: APjAAAUo6UEHFsexWY8aqnUx7iO3RRh471/b0vQGgQE3Bal6aeenJbvC
        N9xZt3bM3ncWkvA2agXIODaPy0Cjd5HiVLmDjt4lNnRz3AMk/eahIyqtlMPmGwxAN/w4K05wKFv
        5tSaHXXwJ7vaaaZ+5
X-Received: by 2002:a7b:c049:: with SMTP id u9mr8213033wmc.12.1570912714183;
        Sat, 12 Oct 2019 13:38:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxLj0k8Cpx24uQX9iVZhXvEuBPVthfbnxlWlPHo0thYY39YAYdauQAejs0EHhOHdoLpHMtkEQ==
X-Received: by 2002:a7b:c049:: with SMTP id u9mr8213024wmc.12.1570912713950;
        Sat, 12 Oct 2019 13:38:33 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id b62sm17312605wmc.13.2019.10.12.13.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 13:38:33 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:38:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     prashantbhole.linux@gmail.com,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vhost_net: access ptr ring using tap recvmsg
Message-ID: <20191012163722-mutt-send-email-mst@kernel.org>
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
 <8f319697-34e1-fde5-65f3-7db8dc723982@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f319697-34e1-fde5-65f3-7db8dc723982@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 03:57:21PM +0800, Jason Wang wrote:
> 
> On 2019/10/12 上午9:53, prashantbhole.linux@gmail.com wrote:
> > From: Prashant Bhole <prashantbhole.linux@gmail.com>
> > 
> > vhost_net needs to peek tun packet sizes to allocate virtio buffers.
> > Currently it directly accesses tap ptr ring to do it. Jason Wang
> > suggested to achieve this using msghdr->msg_control and modifying the
> > behavior of tap recvmsg.
> 
> 
> Note this may use more indirect calls, this could be optimized in the future
> by doing XDP/skb receiving by vhost_net its own.

So it looks like this is going in the reverse direction,
moving more data path code from vhost to tun.
What's the point of the patchset then?


> 
> > 
> > This change will be useful in future in case of virtio-net XDP
> > offload. Where packets will be XDP processed in tap recvmsg and vhost
> > will see only non XDP_DROP'ed packets.
> > 
> > Patch 1: reorganizes the tun_msg_ctl so that it can be extended by
> >   the means of different commands. tap sendmsg recvmsg will behave
> >   according to commands.
> > 
> > Patch 2: modifies recvmsg implementation to produce packet pointers.
> >   vhost_net uses recvmsg API instead of ptr_ring_consume().
> > 
> > Patch 3: removes ptr ring usage in vhost and functions those export
> >   ptr ring from tun/tap.
> > 
> > Prashant Bhole (3):
> >    tuntap: reorganize tun_msg_ctl usage
> >    vhost_net: user tap recvmsg api to access ptr ring
> >    tuntap: remove usage of ptr ring in vhost_net
> > 
> >   drivers/net/tap.c      | 44 ++++++++++++++---------
> >   drivers/net/tun.c      | 45 +++++++++++++++---------
> >   drivers/vhost/net.c    | 79 ++++++++++++++++++++++--------------------
> >   include/linux/if_tun.h |  9 +++--
> >   4 files changed, 103 insertions(+), 74 deletions(-)
> 
> 
> It would be helpful that if you can share some performance numbers here.
> 
> Thanks
