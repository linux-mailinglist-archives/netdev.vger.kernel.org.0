Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D96741483F
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhIVL5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:57:34 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:57685 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbhIVL5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 07:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=OKfVFxrpko5QMAAtDRTPC75OYX8uz3xyIWxgAq8hnf8=; b=SR/90fyAUGmsJOYhzXLCnXiiEb
        lzZAX/eD275hpQQGTlQumLEg9MgbjYj9FiWsCem6Im0Bs18reQGbCNATCTedi9A/rpBUxMfBR2QJ0
        PuxrZ1O4njGlX1z/LSsURaIWf31Misbw7LsmrJcKvSwAXuTv3Z9FLRW5d67ynQTbarbRot7ggkKge
        NX4Xfj2CmUPsKKM4Sjqsxe7kqzYfGF3YCWCVjA/KJS9OOwXaJ1RTpKukW6Pkoy6R1i5cC1eLnCoqh
        K4seZ4R50H25J8Z0jYaRjq/L0KWZiU5KAHjaiG/s4FQdCYSNkBLohwmOWlrmfTnmzp8pRXjEymMER
        Qm02o2F9946WCWUlGD9ds23LYjGgnwvX6+3j+doQ+2E8Mf2bQ/VwOTa+pj3lnQSfGNvyAiZ5ctFQ1
        deN743UPT/Y/fvrvXmxh4kZEeJJ/qJt6OsxWEt62NxfGPAtCLPFv60yB1T3sMNHx3Nr0y5D6c+4GU
        hf2J5O7n8y8Jd0e2SFCub+i3LwhRAm7BZCu9elzhY3NUhRfJvGvpgk9wuf8ZLh//7F8m21wSq2pI+
        t3VS03fZzd3eIUoY2O4obt62u4gsUH/6QN6sNF3GcLeUWWWy89/2QlEFQ3RLQLC9YExUi7NtdMIL9
        GXaQkd8dhHifmL3VoDWuxEFCffBkBKBhQ0fod3C3Q=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 7/7] 9p/trans_virtio: resize sg lists to whatever is possible
Date:   Wed, 22 Sep 2021 13:56:01 +0200
Message-ID: <3557953.c9VYo6GAZX@silver>
In-Reply-To: <0a2c16b9acf580a679f38354b5d60a68c5fb6c99.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com> <0a2c16b9acf580a679f38354b5d60a68c5fb6c99.1632156835.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 20. September 2021 18:44:20 CEST Christian Schoenebeck wrote:
> Right now vq_sg_resize() used a lazy implementation following
> the all-or-nothing princible. So it either resized exactly to
> the requested new amount of sg lists, or it did not resize at
> all.
> 
> The problem with this is if a user supplies a very large msize
> value, resize would simply fail and the user would stick to
> the default maximum msize supported by the virtio transport.
> 
> To resolve this potential issue, change vq_sg_resize() to resize
> the passed sg list to whatever is possible on the machine.
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
>  net/9p/trans_virtio.c | 65 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 55 insertions(+), 10 deletions(-)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 4cb75f45aa15..b9bab7ed2768 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -205,24 +205,66 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int
> nsgl) * amount of lists
>   * @_vq_sg: scatter/gather lists to be resized
>   * @nsgl: new amount of scatter/gather lists
> + *
> + * Old scatter/gather lists are retained. Only growing the size is
> supported. + * If the requested amount cannot be satisfied, then lists are
> increased to + * whatever is possible.
>   */
>  static int vq_sg_resize(struct virtqueue_sg **_vq_sg, unsigned int nsgl)
>  {
>  	struct virtqueue_sg *vq_sg;
> +	unsigned int i;
> +	size_t sz;
> +	int ret = 0;
> 
>  	BUG_ON(!_vq_sg || !nsgl);
>  	vq_sg = *_vq_sg;
> +	if (nsgl > VIRTQUEUE_SG_NSGL_MAX)
> +		nsgl = VIRTQUEUE_SG_NSGL_MAX;
>  	if (vq_sg->nsgl == nsgl)
>  		return 0;
> +	if (vq_sg->nsgl > nsgl)
> +		return -ENOTSUPP;
> +
> +	vq_sg = kzalloc(sizeof(struct virtqueue_sg) +
> +			nsgl * sizeof(struct scatterlist *),
> +			GFP_KERNEL);
> 
> -	/* lazy resize implementation for now */
> -	vq_sg = vq_sg_alloc(nsgl);
>  	if (!vq_sg)
>  		return -ENOMEM;
> 
> -	kfree(*_vq_sg);
> +	/* copy over old scatter gather lists */
> +	sz = sizeof(struct virtqueue_sg) +
> +		(*_vq_sg)->nsgl * sizeof(struct scatterlist *);
> +	memcpy(vq_sg, *_vq_sg, sz);

Missing

	kfree(*_vq_sg);

here.

> +
> +	vq_sg->nsgl = nsgl;
> +
> +	for (i = (*_vq_sg)->nsgl; i < nsgl; ++i) {
> +		vq_sg->sgl[i] = kmalloc_array(
> +			SG_MAX_SINGLE_ALLOC, sizeof(struct scatterlist),
> +			GFP_KERNEL
> +		);
> +		/*
> +		 * handle failed allocation as soft error, we take whatever
> +		 * we get
> +		 */
> +		if (!vq_sg->sgl[i]) {
> +			ret = -ENOMEM;
> +			vq_sg->nsgl = nsgl = i;
> +			break;
> +		}
> +		sg_init_table(vq_sg->sgl[i], SG_MAX_SINGLE_ALLOC);
> +		if (i) {
> +			/* chain the lists */
> +			sg_chain(vq_sg->sgl[i - 1], SG_MAX_SINGLE_ALLOC,
> +				 vq_sg->sgl[i]);
> +		}
> +	}
> +	sg_mark_end(&vq_sg->sgl[nsgl - 1][SG_MAX_SINGLE_ALLOC - 1]);
> +
>  	*_vq_sg = vq_sg;
> -	return 0;
> +	return ret;
>  }
> 
>  /**
> @@ -839,13 +881,16 @@ p9_virtio_create(struct p9_client *client, const char
> *devname, char *args) if (nsgl > chan->vq_sg->nsgl) {
>  			/*
>  			 * if resize fails, no big deal, then just
> -			 * continue with default msize instead
> +			 * continue with whatever we got
>  			 */
> -			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
> -				client->trans_maxsize =
> -					PAGE_SIZE *
> -					((nsgl * SG_USER_PAGES_PER_LIST) - 3);
> -			}
> +			vq_sg_resize(&chan->vq_sg, nsgl);
> +			/*
> +			 * actual allocation size might be less than
> +			 * requested, so use vq_sg->nsgl instead of nsgl
> +			 */
> +			client->trans_maxsize =
> +				PAGE_SIZE * ((chan->vq_sg->nsgl *
> +				SG_USER_PAGES_PER_LIST) - 3);

As with patch 6, here should probably be an additional

		if (chan->vq_sg->nsgl < nsgl) {
			pr_inf(...);
		}

to explain the user that not all required sg lists could be allocated suiting 
user's requested msize option.

>  		}
>  #endif /* CONFIG_ARCH_NO_SG_CHAIN */
>  	}




