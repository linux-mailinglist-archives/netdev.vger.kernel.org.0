Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E53483BC8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 06:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiADF6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 00:58:52 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:3654 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbiADF6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 00:58:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V0sbolK_1641275927;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0V0sbolK_1641275927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 13:58:49 +0800
Subject: Re: [PATCH] vhost/test: fix memory leak of vhost virtqueues
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211228030924.3468439-1-xianting.tian@linux.alibaba.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <8a7f84b6-8d63-0005-754b-cfd158c8952e@linux.alibaba.com>
Date:   Tue, 4 Jan 2022 13:58:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211228030924.3468439-1-xianting.tian@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi

Could I get your comments for this patch?  it fixed the memleak issue.

在 2021/12/28 上午11:09, Xianting Tian 写道:
> We need free the vqs in .release(), which are allocated in .open().
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   drivers/vhost/test.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index a09dedc79..05740cba1 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -166,6 +166,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
>   	/* We do an extra flush before freeing memory,
>   	 * since jobs can re-queue themselves. */
>   	vhost_test_flush(n);
> +	kfree(n->dev.vqs);
>   	kfree(n);
>   	return 0;
>   }
