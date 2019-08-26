Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4659F9D29E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbfHZPZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:25:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57233 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfHZPZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:25:00 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190826152457euoutp0239627a9d66a005f5e82e43760e9e717b~_gmak00Ud1751617516euoutp02f
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:24:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190826152457euoutp0239627a9d66a005f5e82e43760e9e717b~_gmak00Ud1751617516euoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566833097;
        bh=EwDiHvSYuFXDPIALtgIl5Mu8Pp/J0q9o3l5QYy9kxT8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=W/XKlOQQl3txQwRzHN8SsWQyBmEFdYyPHhnD/4SdA5bCXacoZZTbE9wE8pVbwf9C0
         aRlvKm3Znj4auuX1TP92+kx36e6jyDuBEwj+bQ5lhBIcfeHW6fARI21PyleUEL7fth
         FsaVyAFD+20gAZDLq2dFxWr7g4CojrcWdk4CooGw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190826152456eucas1p1356062a3f133b4376b5ac11286ce1a3e~_gmZ0cLPh1540715407eucas1p1H;
        Mon, 26 Aug 2019 15:24:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id DC.CD.04374.8C9F36D5; Mon, 26
        Aug 2019 16:24:56 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190826152455eucas1p2ec110333877e4d7154bae9a04b8a3758~_gmY4Ta4Q2401024010eucas1p2o;
        Mon, 26 Aug 2019 15:24:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190826152455eusmtrp28725afcaa615081e2aa0cdf74bbbf8db~_gmYqM0gO0175601756eusmtrp2L;
        Mon, 26 Aug 2019 15:24:55 +0000 (GMT)
X-AuditID: cbfec7f5-4f7ff70000001116-ce-5d63f9c8b0cd
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9E.76.04117.7C9F36D5; Mon, 26
        Aug 2019 16:24:55 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190826152454eusmtip21dfd7593c285e9140c3b266d977a314a~_gmXyUbxe2608326083eusmtip2y;
        Mon, 26 Aug 2019 15:24:54 +0000 (GMT)
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <14576fd3-69ce-6493-5a38-c47566851d4e@samsung.com>
Date:   Mon, 26 Aug 2019 18:24:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826061053.15996-3-bjorn.topel@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzHfe93Dz/m7OtHfFJLu6X1IJJav0roYetW//RPrZjVxW/HOkd3
        iLTiMomSqZEzYTKPE0K5VFzmKXObEcLSYlwiT+GWyN2P5b/X5+H9+Xze24ckKB3PgQyShzEK
        uUQm4ltwa5oMun0tBn+//bo6ET1n6BfQurQ2Pr0UX47o2cZmPp2XO0/Q9YZRLt113yCgNWUZ
        BF0aF8uhC7UtAropx46e18m9LcW16kGBOK9OzxEn9nYS4sriB3xxclUxEqeOnRFnTOwUz1Zu
        O0/6WHgEMLKgCEbh6nnVIjC/R8UL7dsVOb7ymohBDY6JyJwEfBBeZcbyEpEFSeFCBBmF1QQb
        zCFYbCtHbDCL4Gn/CLEuScpqNzGFCxD0LUaxTdMIvkwVcI0FGyyDvlEN38i2+DY8VPWYJhF4
        CsFKRbJJzcfO0FbSiIwsxJ6g6qgXGJmLnaCzaswk3oQvwczQRx7bYw2tGcOmBeb4GFT/1ZuY
        wPagmivisewI96ozTR4A6wWQNMwOAnwaUt4+WbNgAz+aqwQsb4WV2mwOy3fha5weseIEBOna
        5bWCF1SNd6wKyNUNu+GlxpVNn4C4Ui1hTAO2gt4Ja/YGK0itSV9LCyEhnmK7d8CfhoK1Cxyg
        b3JWkIJE6g3O1BvcqDe4Uf/fm4O4xcieCVcGSxmlu5y56aKUBCvD5VIX/5DgSrT6Zp+Wm3+/
        Qe+XrmkRJpHIUgjt/n4UTxKhjArWIiAJka1Q5irxo4QBkqhbjCLkiiJcxii1aAvJFdkLo82G
        fCkslYQx1xkmlFGsVzmkuUMMUufryy47wruIqQ8Uys0iPe/4ftO2TpZ/djo0UzKCo3yiZ3py
        2xe8S92pw6dSuvYmNJzrzfLqXPh+8sBc7sWBG5sJ/mOFx4u47nHN8YFH2udtlmZnZ5yjf0l5
        FX4TDaoVYv7Cs7DFoC5NZNrPo3ZD3dn67YYjZUWcsCVptdv0YKCIqwyUuO0hFErJP6lauali
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t/xe7rHfybHGvQuU7H48vM2u8X5aafY
        LP60bWC0+HzkOJvF4oXfmC0O/HzOYnGl/Se7xa51M5kt1rQ0MlmsOHSC3eLYAjGLb+fzHHg8
        ds66y+6xeM9LJo+uG5eYPTat6mTz6NuyitFj0gt3j5lv1Tw+b5IL4IjSsynKLy1JVcjILy6x
        VYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy1h6vYm14KZGxev/25kbGA/K
        dzFyckgImEh0zz3D3MXIxSEksJRR4lLrBRaIhJTEj18XWCFsYYk/17rYIIreM0p8nzGLDSQh
        LJAjcfP5LjBbRKBGYu7On0wgNrPAB0aJjZ+4IRr2M0rsvvcBbCqbgI7EqdVHGEFsXgE7iaZz
        B9hBbBYBVYlLW16ADRIViJA4vGMWVI2gxMmZT8B6OQWsJbb+fckCsUBd4s+8S8wQtrhE05eV
        rBC2vETz1tnMExiFZiFpn4WkZRaSlllIWhYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQI
        jN9tx35u2cHY9S74EKMAB6MSD6/EmeRYIdbEsuLK3EOMEhzMSiK8OfqJsUK8KYmVValF+fFF
        pTmpxYcYTYGem8gsJZqcD0wteSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg
        +pg4OKUaGCtmtvYLhpXMmHd0abTNokm3W9bdsSiWfSrMM+VhnPJ/U7VLcX5CG/P+SWRbT3B5
        8yBH7MaGjW82CNf9q6nZ+v0767tZW6J2zpy71yC/YEL5WTUp5etPZNdYL5+qKLnX8oCLkcq+
        l0oMV26xPk9qkdcIXJjRVLzH63LUWyeFeP67V00MFqdmVSmxFGckGmoxFxUnAgAdTHO99QIA
        AA==
X-CMS-MailID: 20190826152455eucas1p2ec110333877e4d7154bae9a04b8a3758
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190826061127epcas5p21bb790365a436ff234d77786f03729f8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190826061127epcas5p21bb790365a436ff234d77786f03729f8
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
        <CGME20190826061127epcas5p21bb790365a436ff234d77786f03729f8@epcas5p2.samsung.com>
        <20190826061053.15996-3-bjorn.topel@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.08.2019 9:10, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The state variable was read, and written outside the control mutex
> (struct xdp_sock, mutex), without proper barriers and {READ,
> WRITE}_ONCE correctness.
> 
> In this commit this issue is addressed, and the state member is now
> used a point of synchronization whether the socket is setup correctly
> or not.
> 
> This also fixes a race, found by syzcaller, in xsk_poll() where umem
> could be accessed when stale.
> 
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c | 57 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f3351013c2a5..8fafa3ce3ae6 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>  	return err;
>  }
>  
> +static bool xsk_is_bound(struct xdp_sock *xs)
> +{
> +	if (READ_ONCE(xs->state) == XSK_BOUND) {
> +		/* Matches smp_wmb() in bind(). */
> +		smp_rmb();
> +		return true;
> +	}
> +	return false;
> +}
> +
>  int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
>  	u32 len;
>  
> +	if (!xsk_is_bound(xs))
> +		return -EINVAL;
> +
>  	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>  		return -EINVAL;
>  
> @@ -362,7 +375,7 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  	struct sock *sk = sock->sk;
>  	struct xdp_sock *xs = xdp_sk(sk);
>  
> -	if (unlikely(!xs->dev))
> +	if (unlikely(!xsk_is_bound(xs)))
>  		return -ENXIO;
>  	if (unlikely(!(xs->dev->flags & IFF_UP)))
>  		return -ENETDOWN;
> @@ -378,10 +391,15 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
>  			     struct poll_table_struct *wait)
>  {
>  	unsigned int mask = datagram_poll(file, sock, wait);
> -	struct sock *sk = sock->sk;
> -	struct xdp_sock *xs = xdp_sk(sk);
> -	struct net_device *dev = xs->dev;
> -	struct xdp_umem *umem = xs->umem;
> +	struct xdp_sock *xs = xdp_sk(sock->sk);
> +	struct net_device *dev;
> +	struct xdp_umem *umem;
> +
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return mask;
> +
> +	dev = xs->dev;
> +	umem = xs->umem;
>  
>  	if (umem->need_wakeup)
>  		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> @@ -417,10 +435,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>  {
>  	struct net_device *dev = xs->dev;
>  
> -	if (!dev || xs->state != XSK_BOUND)
> +	if (xs->state != XSK_BOUND)
>  		return;
> -
> -	xs->state = XSK_UNBOUND;
> +	WRITE_ONCE(xs->state, XSK_UNBOUND);
>  
>  	/* Wait for driver to stop using the xdp socket. */
>  	xdp_del_sk_umem(xs->umem, xs);
> @@ -495,7 +512,9 @@ static int xsk_release(struct socket *sock)
>  	local_bh_enable();
>  
>  	xsk_delete_from_maps(xs);
> +	mutex_lock(&xs->mutex);
>  	xsk_unbind_dev(xs);
> +	mutex_unlock(&xs->mutex);
>  
>  	xskq_destroy(xs->rx);
>  	xskq_destroy(xs->tx);
> @@ -589,19 +608,18 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>  		}
>  
>  		umem_xs = xdp_sk(sock->sk);
> -		if (!umem_xs->umem) {
> -			/* No umem to inherit. */
> +		if (!xsk_is_bound(umem_xs)) {

This changes the error code a bit.
Previously:
   umem exists + xs unbound    --> EINVAL
   no umem     + xs unbound    --> EBADF
   xs bound to different dev/q --> EINVAL

With this change:
   umem exists + xs unbound    --> EBADF
   no umem     + xs unbound    --> EBADF
   xs bound to different dev/q --> EINVAL

Just a note. Not sure if this is important.


>  			err = -EBADF;
>  			sockfd_put(sock);
>  			goto out_unlock;
> -		} else if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
> +		}
> +		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
>  			err = -EINVAL;
>  			sockfd_put(sock);
>  			goto out_unlock;
>  		}
> -
>  		xdp_get_umem(umem_xs->umem);
> -		xs->umem = umem_xs->umem;
> +		WRITE_ONCE(xs->umem, umem_xs->umem);
>  		sockfd_put(sock);
>  	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
>  		err = -EINVAL;
> @@ -626,10 +644,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>  	xdp_add_sk_umem(xs->umem, xs);
>  
>  out_unlock:
> -	if (err)
> +	if (err) {
>  		dev_put(dev);
> -	else
> -		xs->state = XSK_BOUND;
> +	} else {
> +		/* Matches smp_rmb() in bind() for shared umem
> +		 * sockets, and xsk_is_bound().
> +		 */
> +		smp_wmb();
> +		WRITE_ONCE(xs->state, XSK_BOUND);
> +	}
>  out_release:
>  	mutex_unlock(&xs->mutex);
>  	rtnl_unlock();
> @@ -869,7 +892,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>  	unsigned long pfn;
>  	struct page *qpg;
>  
> -	if (xs->state != XSK_READY)
> +	if (READ_ONCE(xs->state) != XSK_READY)
>  		return -EBUSY;
>  
>  	if (offset == XDP_PGOFF_RX_RING) {
> 
