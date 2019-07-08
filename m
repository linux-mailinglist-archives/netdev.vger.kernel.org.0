Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1616205E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfGHOVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:21:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37065 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfGHOVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:21:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so7707340pfa.4;
        Mon, 08 Jul 2019 07:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=r0uciddUbrYB675XnBhSdwuvsW7gK3pQurz+1tUBwU0=;
        b=pDfQjIQOg6v5OIMJZjtvSI4rQ9nm+0bSXGZMDSYhrzkdw2x0TLwVcl2Ak7v2UAtStb
         63YtNfgc/puBCqx9VcKrq/y8FBxtoPvSZAdr42I3IM+3zkUdUvo62URIXyGH9J/Es2oO
         RsPKgd0L1Rr9KBGmnlHCw587RqNCYZQS6eG7/uqI8KjjZGg3BllZcvdcBkJTBvUHqcfY
         bQMUflu5lAbYvH8fYAwqG41vIIgeezU5BgQt1zN4obeGeiG4e4x8FIfgRxYfz4OnlYRG
         yampkbdJmxp8KkkiENM0+i9pNDGaWv8B8PHthcXYxDrdumwQNBkLeNk56czeAhh7CvJy
         0FYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=r0uciddUbrYB675XnBhSdwuvsW7gK3pQurz+1tUBwU0=;
        b=QC2c+TmfCd1r0ASA8pWvjgnIVC393VuQ/8C5ND9Mz3XPX/MsllikWlF9SmRjgAWg48
         l5647wGAkNyNFWAZkQEXCr4aRDN5yltJ/984Gsa1vc5dwDbMDoDXZtnG+NQbKzmEPA57
         C9XIErG6q8KpksbVr864YumRziJHsRtpa5wgApBQWhCW/WrH2PxvQPYlkwJjuaYMd/5V
         +vr/tBrU2G2bzua1D9fu4aqNf4DAbyTm+zGrlsk7n22mB9za50ZrCPp2FOnHHEdgiYnI
         50xioU8Un4ABosjpTPnWjJDPUXQCVK8SW1XZhOaYl2e0upbdEFDKH0dNpAh0cQ3UhzaC
         cwqw==
X-Gm-Message-State: APjAAAWCJg61GPuykwQBukGuo0weHX+iSjzVO8AbM0elYQPD10Oe+yT0
        nz9S05nisvjaHapeoyd3t6E=
X-Google-Smtp-Source: APXvYqxMJMh0UDniT45bAPaZb98umldlVKp/e/8Kk08/6HPtJZwnxDa7zY6Vd+3nv/5wvv7EHZADAQ==
X-Received: by 2002:a17:90a:22aa:: with SMTP id s39mr25953680pjc.39.1562595667805;
        Mon, 08 Jul 2019 07:21:07 -0700 (PDT)
Received: from [172.20.95.170] ([2620:10d:c090:180::1:c37b])
        by smtp.gmail.com with ESMTPSA id p68sm29668205pfb.80.2019.07.08.07.21.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 07:21:07 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] xdp: fix potential deadlock on socket mutex
Date:   Mon, 08 Jul 2019 07:21:05 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <0617EEA7-7883-4800-B1E2-5D59D8120C67@gmail.com>
In-Reply-To: <20190708110344.23278-1-i.maximets@samsung.com>
References: <CGME20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1@eucas1p1.samsung.com>
 <20190708110344.23278-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jul 2019, at 4:03, Ilya Maximets wrote:

> There are 2 call chains:
>
>   a) xsk_bind --> xdp_umem_assign_dev
>   b) unregister_netdevice_queue --> xsk_notifier
>
> with the following locking order:
>
>   a) xs->mutex --> rtnl_lock
>   b) rtnl_lock --> xdp.lock --> xs->mutex
>
> Different order of taking 'xs->mutex' and 'rtnl_lock' could produce a
> deadlock here. Fix that by moving the 'rtnl_lock' before 'xs->lock' in
> the bind call chain (a).
>
> Reported-by: syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com
> Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound 
> to xdp socket")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Thanks, Ilya!

I think in the long run the locking needs to be revisited,
but this should fix the deadlock for now.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>



> This patch is a fix for patch that is not yet in mainline, but
> already in 'net' tree. I'm not sure what is the correct process
> for applying such fixes.
>
>  net/xdp/xdp_umem.c | 16 ++++++----------
>  net/xdp/xsk.c      |  2 ++
>  2 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 20c91f02d3d8..83de74ca729a 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -87,21 +87,20 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, 
> struct net_device *dev,
>  	struct netdev_bpf bpf;
>  	int err = 0;
>
> +	ASSERT_RTNL();
> +
>  	force_zc = flags & XDP_ZEROCOPY;
>  	force_copy = flags & XDP_COPY;
>
>  	if (force_zc && force_copy)
>  		return -EINVAL;
>
> -	rtnl_lock();
> -	if (xdp_get_umem_from_qid(dev, queue_id)) {
> -		err = -EBUSY;
> -		goto out_rtnl_unlock;
> -	}
> +	if (xdp_get_umem_from_qid(dev, queue_id))
> +		return -EBUSY;
>
>  	err = xdp_reg_umem_at_qid(dev, umem, queue_id);
>  	if (err)
> -		goto out_rtnl_unlock;
> +		return err;
>
>  	umem->dev = dev;
>  	umem->queue_id = queue_id;
> @@ -110,7 +109,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, 
> struct net_device *dev,
>
>  	if (force_copy)
>  		/* For copy-mode, we are done. */
> -		goto out_rtnl_unlock;
> +		return 0;
>
>  	if (!dev->netdev_ops->ndo_bpf ||
>  	    !dev->netdev_ops->ndo_xsk_async_xmit) {
> @@ -125,7 +124,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, 
> struct net_device *dev,
>  	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
>  	if (err)
>  		goto err_unreg_umem;
> -	rtnl_unlock();
>
>  	umem->zc = true;
>  	return 0;
> @@ -135,8 +133,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, 
> struct net_device *dev,
>  		err = 0; /* fallback to copy mode */
>  	if (err)
>  		xdp_clear_umem_at_qid(dev, queue_id);
> -out_rtnl_unlock:
> -	rtnl_unlock();
>  	return err;
>  }
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 703cf5ea448b..2aa6072a3e55 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -416,6 +416,7 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY))
>  		return -EINVAL;
>
> +	rtnl_lock();
>  	mutex_lock(&xs->mutex);
>  	if (xs->state != XSK_READY) {
>  		err = -EBUSY;
> @@ -501,6 +502,7 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  		xs->state = XSK_BOUND;
>  out_release:
>  	mutex_unlock(&xs->mutex);
> +	rtnl_unlock();
>  	return err;
>  }
>
> -- 
> 2.17.1
