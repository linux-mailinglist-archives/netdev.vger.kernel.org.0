Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F0932E2F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfFCLHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:07:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38908 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfFCLHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 07:07:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so11582941wrs.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 04:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rdf+QSazMX9W42t15vMnXFExNCmmHTg2hetZgBVUhIY=;
        b=UoB+mmE0OZxNiq+Kwur+X0XEwwcgOBo/3nTmdje0MqDiR29iSOBpoD+8Li6y/J4z9m
         dWLzOM1derLSdqJOvgvvAQ2wYOHbUrw27BRnjtaWyw6erI83qvvrctLeCmSxxNpUTIHm
         FH/gphK8fy44IDslbgIK2UyGNiTrdMVqlfRjxIpIikxT19NG4hVtarWaof7gRB+tMguj
         x4S1ZUEiqm2blryYGlLFuMMUa3VFAIBvtVZX2qFd3U9XMNpo+dlHNpq99S3UWEL3mad4
         w1y2kBqY5VtIdvwdfvj8bOrHFLiz2SdjuzVY0I7Goq/Pwrym9AEaKeOei0r2EOvXARcE
         6Kqw==
X-Gm-Message-State: APjAAAUzE9sd1BvXkSPuBGUbzXDO7KB2CWXW6JxPXViNV/wXRQLlWpcX
        dhmeiBP6ke3HMJvlsPuUHh51PA==
X-Google-Smtp-Source: APXvYqzxDfQTTupgrN70BEqNhLgAiEj+6mlq4Bfy4o1lRFeVEHVZDlJsyp3DX8S5zo8Bj0v34tqjEQ==
X-Received: by 2002:adf:aa0a:: with SMTP id p10mr15815063wrd.125.1559560040922;
        Mon, 03 Jun 2019 04:07:20 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id w14sm1632043wrk.44.2019.06.03.04.07.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 04:07:20 -0700 (PDT)
Date:   Mon, 3 Jun 2019 13:07:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/5] vsock/virtio: fix locking for fwd_cnt and
 buf_alloc
Message-ID: <20190603110717.rjbwfojpdpye3yxe@steredhat.homenet.telecomitalia.it>
References: <20190531133954.122567-1-sgarzare@redhat.com>
 <20190531133954.122567-3-sgarzare@redhat.com>
 <20190602.180334.1932703293092139564.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602.180334.1932703293092139564.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 06:03:34PM -0700, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Fri, 31 May 2019 15:39:51 +0200
> 
> > @@ -434,7 +434,9 @@ void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
> >  	if (val > vvs->buf_size_max)
> >  		vvs->buf_size_max = val;
> >  	vvs->buf_size = val;
> > +	spin_lock_bh(&vvs->rx_lock);
> >  	vvs->buf_alloc = val;
> > +	spin_unlock_bh(&vvs->rx_lock);
> 
> This locking doesn't do anything other than to strongly order the
> buf_size store to occur before the buf_alloc one.

Sure, I'll remove the lock. I was confused because I moved its reading
under the rx_lock (together with other variables), but here I'm updating
only buf_alloc, so this lock is useless.

Thanks,
Stefano
