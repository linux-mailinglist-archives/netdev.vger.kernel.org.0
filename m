Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96D7389DE5
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhETGaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhETGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:30:11 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F92C061574;
        Wed, 19 May 2021 23:28:50 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljcAf-00GTu6-EE; Thu, 20 May 2021 06:28:37 +0000
Date:   Thu, 20 May 2021 06:28:37 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YKYBle/F8aOgHO9p@zeniv-ca.linux.org.uk>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517095513.850-12-xieyongji@bytedance.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 05:55:12PM +0800, Xie Yongji wrote:

> +	case VDUSE_IOTLB_GET_FD: {
> +		struct vduse_iotlb_entry entry;
> +		struct vhost_iotlb_map *map;
> +		struct vdpa_map_file *map_file;
> +		struct vduse_iova_domain *domain = dev->domain;
> +		struct file *f = NULL;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&entry, argp, sizeof(entry)))
> +			break;

			return -EFAULT;
surely?
> +
> +		ret = -EINVAL;
> +		if (entry.start > entry.last)
> +			break;

... and similar here, etc.

> +		spin_lock(&domain->iotlb_lock);
> +		map = vhost_iotlb_itree_first(domain->iotlb,
> +					      entry.start, entry.last);
> +		if (map) {
> +			map_file = (struct vdpa_map_file *)map->opaque;
> +			f = get_file(map_file->file);
> +			entry.offset = map_file->offset;
> +			entry.start = map->start;
> +			entry.last = map->last;
> +			entry.perm = map->perm;
> +		}
> +		spin_unlock(&domain->iotlb_lock);
> +		ret = -EINVAL;
> +		if (!f)
> +			break;
> +
> +		ret = -EFAULT;
> +		if (copy_to_user(argp, &entry, sizeof(entry))) {
> +			fput(f);
> +			break;
> +		}
> +		ret = receive_fd(f, perm_to_file_flags(entry.perm));
> +		fput(f);
> +		break;

IDGI.  The main difference between receive_fd() and plain old
get_unused_fd_flags() + fd_install() is __receive_sock() call.
Which does nothing whatsoever in case of non-sockets.  Can you
get a socket here?

IOW, why bother with that crap at all, nevermind exporting it?
