Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2262940F702
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 14:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbhIQMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 08:03:34 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:43545 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242369AbhIQMDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 08:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=mwDQ7yL65mWjimIO8xuhY5v9/PdKRAR76I1LgT/xIJw=; b=qoUwGluFKe+XVtLgZIF3PxKGI9
        oGLtzS3umUMVjRMoQkSplxFOxgCZ9XmD5WfergkZF6C9kjoHaghNQrutdYHU2dbkvenJKbPLFPYM0
        RPPeywCmdmTaR0IHTSa4ctWaALVo/Q5VrraUVDirI28OEhZDJ4yCiwuxC/MH8Zbm8aSXqPoVg373/
        h1YVuK7NIQPR7ubAj/6Kt9IMGFAoqK9HIr8OvQXS+xhx99HDtCc97WLO7OJd7frPEbXgY2SBVNmNr
        VTc2y3B4WCdl6+svCPwJWrmpDlsg23qZ/NjHtmRGvP+gpIRFXQwueBT8Yam1oMVi7jP2UCamoArHO
        bVAGvHyDKzT9rdSZi7GYGFKh3KI4Mzx8xsFoubE3gaCIEIckbUGnjuvHkgfZKh7nag8Mw2TzoQEKI
        JzYe893yIimytwy4Q7W4ntqax26xoI1xLiS/hC06Cm+bLBK9ZU0nhRZ7lgMS4f86aPhYNbZNxP2lO
        pZZaFlT9qhbeXqpi1sy9/toFKrS+86sb6uS4xJYX+kKMguHw0lCdJQq06NKXJGJ/61oHBXZeDus4O
        Bl19z3E4TYP5oGXJOeObBOobKaqoxs0/i0gX7I131L5uAq+H1GAunpqmDJ3u/4T3pFHixPjkliin+
        8Zv9WebbrCDEHZQ7lk6WrdMz2SYuh6esq0DYZmMzI=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 6/7] 9p/trans_virtio: support larger msize values
Date:   Fri, 17 Sep 2021 14:02:04 +0200
Message-ID: <42945636.VKLsUkgjGN@silver>
In-Reply-To: <810050b76b9b04f045e3d21b0082358ea3f21391.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com> <810050b76b9b04f045e3d21b0082358ea3f21391.1631816768.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 16. September 2021 20:25:16 CEST Christian Schoenebeck wrote:
> The virtio transport supports by default a 9p 'msize' of up to
> approximately 500 kB. This patches adds support for larger 'msize'
> values by resizing the amount of scatter/gather lists if required.
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---

s/patches/patch/

>  net/9p/trans_virtio.c | 52 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 1a45e0df2336..1f9a0283d7b8 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -195,6 +195,30 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int
> nsgl) return vq_sg;
>  }
> 
> +/**
> + * Resize passed virtqueue scatter/gather lists to the passed amount of
> + * list blocks.
> + * @_vq_sg: scatter/gather lists to be resized
> + * @nsgl: new amount of scatter/gather list blocks
> + */
> +static int vq_sg_resize(struct virtqueue_sg **_vq_sg, unsigned int nsgl)
> +{
> +	struct virtqueue_sg *vq_sg;
> +
> +	BUG_ON(!_vq_sg || !nsgl);
> +	vq_sg = *_vq_sg;
> +	if (vq_sg->nsgl == nsgl)
> +		return 0;
> +
> +	/* lazy resize implementation for now */
> +	vq_sg = vq_sg_alloc(nsgl);
> +	if (!vq_sg)
> +		return -ENOMEM;
> +

Missing

    kfree(*_vq_sg);

here, and probably also a prior memcpy() as in patch 7, i.e.:

    /* copy over old scatter gather lists */
    sz = sizeof(struct virtqueue_sg) +
        (*_vq_sg)->nsgl * sizeof(struct scatterlist *);
    memcpy(vq_sg, *_vq_sg, sz);

> +	*_vq_sg = vq_sg;
> +	return 0;
> +}
> +
>  /**
>   * p9_virtio_close - reclaim resources of a channel
>   * @client: client instance
> @@ -766,6 +790,10 @@ p9_virtio_create(struct p9_client *client, const char
> *devname, char *args) struct virtio_chan *chan;
>  	int ret = -ENOENT;
>  	int found = 0;
> +#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
> +	size_t npages;
> +	size_t nsgl;
> +#endif
> 
>  	if (devname == NULL)
>  		return -EINVAL;
> @@ -788,6 +816,30 @@ p9_virtio_create(struct p9_client *client, const char
> *devname, char *args) return ret;
>  	}
> 
> +	/*
> +	 * if user supplied an 'msize' option that's larger than what this
> +	 * transport supports by default, then try to allocate more sg lists
> +	 */
> +	if (client->msize > client->trans_maxsize) {
> +#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
> +		npages = DIV_ROUND_UP(client->msize, PAGE_SIZE);
> +		if (npages > chan->p9_max_pages)
> +			npages = chan->p9_max_pages;
> +		nsgl = DIV_ROUND_UP(npages, SG_USER_PAGES_PER_LIST);
> +		if (nsgl > chan->vq_sg->nsgl) {
> +			/*
> +			 * if resize fails, no big deal, then just
> +			 * continue with default msize instead
> +			 */
> +			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
> +				client->trans_maxsize =
> +					PAGE_SIZE *
> +					((nsgl * SG_USER_PAGES_PER_LIST) - 3);
> +			}
> +		}
> +#endif /* !defined(CONFIG_ARCH_NO_SG_CHAIN) */
> +	}

Probably an error/info message for architectures not supporting SG chains 
would be useful here, to let users on those system know why they cannot get 
beyond 500k msize.

> +
>  	client->trans = (void *)chan;
>  	client->status = Connected;
>  	chan->client = client;




