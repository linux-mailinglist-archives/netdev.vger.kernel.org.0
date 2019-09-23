Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CF9BB122
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 11:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403959AbfIWJMm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Sep 2019 05:12:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfIWJMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 05:12:41 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 9660478361A972C7BF5D;
        Mon, 23 Sep 2019 17:12:39 +0800 (CST)
Received: from DGGEML422-HUB.china.huawei.com (10.1.199.39) by
 DGGEML403-HUB.china.huawei.com (10.3.17.33) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Sep 2019 17:12:39 +0800
Received: from DGGEML525-MBX.china.huawei.com ([169.254.1.34]) by
 dggeml422-hub.china.huawei.com ([10.1.199.39]) with mapi id 14.03.0439.000;
 Mon, 23 Sep 2019 17:12:37 +0800
From:   "wangxu (AE)" <wangxu72@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vhost: It's better to use size_t for the 3rd parameter
 of vhost_exceeds_weight()
Thread-Topic: [PATCH] vhost: It's better to use size_t for the 3rd parameter
 of vhost_exceeds_weight()
Thread-Index: AQHVceXpZDJBVC0FwEyvtYFrPdoIc6c49ACA
Date:   Mon, 23 Sep 2019 09:12:36 +0000
Message-ID: <FCFCADD62FC0CA4FAEA05F13220975B01717A091@dggeml525-mbx.china.huawei.com>
References: <1569224801-101248-1-git-send-email-wangxu72@huawei.com>
 <20190923040518-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190923040518-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.61.27.74]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

	Thanks for your fast reply.

	As the following code, the 2nd branch of iov_iter_advance() does not check if i->count < size, when this happens, i->count -= size may cause len exceed INT_MAX, and then total_len exceed INT_MAX.

	handle_tx_copy() ->
		get_tx_bufs(..., &len, ...) ->
			init_iov_iter() ->
				iov_iter_advance(iter, ...) 	// has 3 branches: 
					pipe_advance() 	 	// has checked the size: if (unlikely(i->count < size)) size = i->count;
					iov_iter_is_discard() ... 	// no check.
					iterate_and_advance() 	//has checked: if (unlikely(i->count < n)) n = i->count;
				return iov_iter_count(iter);

-----Original Message-----
From: Michael S. Tsirkin [mailto:mst@redhat.com] 
Sent: Monday, September 23, 2019 4:07 PM
To: wangxu (AE) <wangxu72@huawei.com>
Cc: jasowang@redhat.com; kvm@vger.kernel.org; virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: It's better to use size_t for the 3rd parameter of vhost_exceeds_weight()

On Mon, Sep 23, 2019 at 03:46:41PM +0800, wangxu wrote:
> From: Wang Xu <wangxu72@huawei.com>
> 
> Caller of vhost_exceeds_weight(..., total_len) in drivers/vhost/net.c 
> usually pass size_t total_len, which may be affected by rx/tx package.
> 
> Signed-off-by: Wang Xu <wangxu72@huawei.com>


Puts a bit more pressure on the register file ...
why do we care? Is there some way that it can exceed INT_MAX?

> ---
>  drivers/vhost/vhost.c | 4 ++--
>  drivers/vhost/vhost.h | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c index 
> 36ca2cf..159223a 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -412,7 +412,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev 
> *dev)  }
>  
>  bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
> -			  int pkts, int total_len)
> +			  int pkts, size_t total_len)
>  {
>  	struct vhost_dev *dev = vq->dev;
>  
> @@ -454,7 +454,7 @@ static size_t vhost_get_desc_size(struct 
> vhost_virtqueue *vq,
>  
>  void vhost_dev_init(struct vhost_dev *dev,
>  		    struct vhost_virtqueue **vqs, int nvqs,
> -		    int iov_limit, int weight, int byte_weight)
> +		    int iov_limit, int weight, size_t byte_weight)
>  {
>  	struct vhost_virtqueue *vq;
>  	int i;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h index 
> e9ed272..8d80389d 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -172,12 +172,13 @@ struct vhost_dev {
>  	wait_queue_head_t wait;
>  	int iov_limit;
>  	int weight;
> -	int byte_weight;
> +	size_t byte_weight;
>  };
>  


This just costs extra memory, and value is never large, so I don't think this matters.

> -bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int 
> total_len);
> +bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts,
> +			  size_t total_len);
>  void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
> -		    int nvqs, int iov_limit, int weight, int byte_weight);
> +		    int nvqs, int iov_limit, int weight, size_t byte_weight);
>  long vhost_dev_set_owner(struct vhost_dev *dev);  bool 
> vhost_dev_has_owner(struct vhost_dev *dev);  long 
> vhost_dev_check_owner(struct vhost_dev *);
> --
> 1.8.5.6
