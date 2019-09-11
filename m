Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0071AFC52
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfIKMQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 08:16:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:55232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726911AbfIKMQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 08:16:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6F95B620;
        Wed, 11 Sep 2019 12:16:28 +0000 (UTC)
Date:   Wed, 11 Sep 2019 14:16:28 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911121628.GT4023@dhcp22.suse.cz>
References: <20190911120908.28410-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911120908.28410-1-mst@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 11-09-19 08:10:00, Michael S. Tsirkin wrote:
> iovec addresses coming from vhost are assumed to be
> pre-validated, but in fact can be speculated to a value
> out of range.
> 
> Userspace address are later validated with array_index_nospec so we can
> be sure kernel info does not leak through these addresses, but vhost
> must also not leak userspace info outside the allowed memory table to
> guests.
> 
> Following the defence in depth principle, make sure
> the address is not validated out of node range.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Tested-by: Jason Wang <jasowang@redhat.com>

no need to mark fo stable? Other spectre fixes tend to be backported
even when the security implications are not really clear. The risk
should be low and better to be covered in case.

> ---
> 
> changes from v1: fix build on 32 bit
> 
>  drivers/vhost/vhost.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5dc174ac8cac..34ea219936e3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2071,8 +2071,10 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>  		_iov = iov + ret;
>  		size = node->size - addr + node->start;
>  		_iov->iov_len = min((u64)len - s, size);
> -		_iov->iov_base = (void __user *)(unsigned long)
> -			(node->userspace_addr + addr - node->start);
> +		_iov->iov_base = (void __user *)
> +			((unsigned long)node->userspace_addr +
> +			 array_index_nospec((unsigned long)(addr - node->start),
> +					    node->size));
>  		s += size;
>  		addr += size;
>  		++ret;
> -- 
> MST

-- 
Michal Hocko
SUSE Labs
