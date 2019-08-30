Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F465A2D6E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfH3DiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:38:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52001 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbfH3DiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 23:38:22 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BEAB307D88C;
        Fri, 30 Aug 2019 03:38:22 +0000 (UTC)
Received: from [10.72.12.92] (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A065A5C1D6;
        Fri, 30 Aug 2019 03:38:17 +0000 (UTC)
Subject: Re: [PATCH 2/2] vhost/test: fix build for vhost test
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190828053700.26022-1-tiwei.bie@intel.com>
 <20190828053700.26022-2-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f74bb96c-b439-7272-bb2f-d2a842dc41a2@redhat.com>
Date:   Fri, 30 Aug 2019 11:38:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828053700.26022-2-tiwei.bie@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 30 Aug 2019 03:38:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/28 下午1:37, Tiwei Bie wrote:
> Since vhost_exceeds_weight() was introduced, callers need to specify
> the packet weight and byte weight in vhost_dev_init(). Note that, the
> packet weight isn't counted in this patch to keep the original behavior
> unchanged.
>
> Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
>  drivers/vhost/test.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index ac4f762c4f65..7804869c6a31 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -22,6 +22,12 @@
>   * Using this limit prevents one virtqueue from starving others. */
>  #define VHOST_TEST_WEIGHT 0x80000
>  
> +/* Max number of packets transferred before requeueing the job.
> + * Using this limit prevents one virtqueue from starving others with
> + * pkts.
> + */
> +#define VHOST_TEST_PKT_WEIGHT 256
> +
>  enum {
>  	VHOST_TEST_VQ = 0,
>  	VHOST_TEST_VQ_MAX = 1,
> @@ -80,10 +86,8 @@ static void handle_vq(struct vhost_test *n)
>  		}
>  		vhost_add_used_and_signal(&n->dev, vq, head, 0);
>  		total_len += len;
> -		if (unlikely(total_len >= VHOST_TEST_WEIGHT)) {
> -			vhost_poll_queue(&vq->poll);
> +		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
>  			break;
> -		}
>  	}
>  
>  	mutex_unlock(&vq->mutex);
> @@ -115,7 +119,8 @@ static int vhost_test_open(struct inode *inode, struct file *f)
>  	dev = &n->dev;
>  	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
>  	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> +		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
>  
>  	f->private_data = n;
>  


Acked-by: Jason Wang <jasowang@redhat.com>


