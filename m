Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D6414814
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhIVLnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:43:53 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:54209 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbhIVLnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 07:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=f+TBhxT2WVtVBk+dWgN9z+Pp/Os61DB2NMLecJFKkBQ=; b=WBUjIPcMT3+rCZijgFDe+c7jxF
        0ohfU3F89VLTJvqpTlmG3MQcSKHcoWEEwoI7frYf0DD6+ZSxJ+BoNO4iu72TGO4A2aUgfdueNNkPg
        ZX7HEopP8CBr771CnmhrVdo87U1rIj5SdYjG5Xa3mZ/ItCXzn8o9UPY38PcCHuwiQSBB8tPQ4yQhV
        mSNcRmobvFd/Yyr1nvJASR/vEv7iSyn0+d5IvB3UN5ODrR9hYu+lDkcmk6aF39joFq3lg0Xmy8DDO
        rEYkmzWfvl8+XLftnueUox8p8yCBKhhXYM8XBE3u2VRaBxzhVWHGH6AbFiOPZQ8ByO6o5WSO/RdRg
        7UV5W74suT9s7MnwMqo6vWGL1x1GsbnzJNvYT0Pe87BZEjlxk4vyKxbjI6oNuiwcGsKymDxh81C/t
        /IhQ0zsoRxzfvU68eIRjacrCl+dDqJS8e2hOLcpEBq+81bP9F2bJtkmBauPtTOq36GtOXmskXjhmK
        +dcVbDc7IE7ED2Wef02O6ydfi1x0R0lXwBDIrA7HPnglTqA2mE8jvBmFB+hI5N806WYER9zavfIvP
        GnsYEBbnoTzGRATvzeGzgeATZJxFcKUHBu2XG0Wp92M/Bchqpp73MnNSZp7KQzfcr5IZeQcskx5Xq
        LRcJCdctriq+p1M8SYz905jS+aw6fbjJBl9paHgwM=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 6/7] 9p/trans_virtio: support larger msize values
Date:   Wed, 22 Sep 2021 13:42:18 +0200
Message-ID: <2845466.DzA3qLHUVI@silver>
In-Reply-To: <f31e80bc67774d08f8d3bfb7ca0a970eeb369ca5.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com> <f31e80bc67774d08f8d3bfb7ca0a970eeb369ca5.1632156835.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 20. September 2021 18:44:13 CEST Christian Schoenebeck wrote:
> The virtio transport supports by default a 9p 'msize' of up to
> approximately 500 kB. This patch adds support for larger 'msize'
> values by resizing the amount of scatter/gather lists if required.
> 
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
>  net/9p/trans_virtio.c | 57 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 0db8de84bd51..4cb75f45aa15 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -200,6 +200,31 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int
> nsgl) return vq_sg;
>  }
> 
> +/**
> + * vq_sg_resize - resize passed virtqueue scatter/gather lists to the
> passed + * amount of lists
> + * @_vq_sg: scatter/gather lists to be resized
> + * @nsgl: new amount of scatter/gather lists
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
> +	kfree(*_vq_sg);
> +	*_vq_sg = vq_sg;
> +	return 0;
> +}
> +
>  /**
>   * p9_virtio_close - reclaim resources of a channel
>   * @client: client instance
> @@ -771,6 +796,10 @@ p9_virtio_create(struct p9_client *client, const char
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
> @@ -793,6 +822,34 @@ p9_virtio_create(struct p9_client *client, const char
> *devname, char *args) return ret;
>  	}
> 
> +	/*
> +	 * if user supplied an 'msize' option that's larger than what this
> +	 * transport supports by default, then try to allocate more sg lists
> +	 */
> +	if (client->msize > client->trans_maxsize) {
> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
> +		pr_info("limiting 'msize' to %d because architecture does not "
> +			"support chained scatter gather lists\n",
> +			client->trans_maxsize);
> +#else
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

Maybe an ...

			} else {
				pr_info(...);
			}

would be useful here to explain the user why transport refrained from 
increasing its max size even though user's msize option demanded it.

> +#endif /* CONFIG_ARCH_NO_SG_CHAIN */
> +	}
> +
>  	client->trans = (void *)chan;
>  	client->status = Connected;
>  	chan->client = client;




