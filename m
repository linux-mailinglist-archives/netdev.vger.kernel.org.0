Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360F1F110D
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 03:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgFHBdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 21:33:14 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55470 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727972AbgFHBdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 21:33:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0U-rYrMw_1591579990;
Received: from JosephdeMacBook-Pro.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0U-rYrMw_1591579990)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Jun 2020 09:33:10 +0800
Subject: Re: [PATCH] Fix build failure of OCFS2 when TCP/IP is disabled
To:     Tom Seewald <tseewald@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>
References: <20200606190827.23954-1-tseewald@gmail.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <731b13e0-2e7c-5a2b-658a-407318c74921@linux.alibaba.com>
Date:   Mon, 8 Jun 2020 09:33:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200606190827.23954-1-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/6/7 03:08, Tom Seewald wrote:
> After commit 12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and
> commit c488aeadcbd0 ("tcp: add tcp_sock_set_user_timeout"), building the
> kernel with OCFS2_FS=y but without INET=y causes it to fail with:
> 
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
> tcp.c:(.text+0x21b1): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x21c1): undefined reference to `tcp_sock_set_user_timeout
> '
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
> tcp.c:(.text+0x2633): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x2643): undefined reference to `tcp_sock_set_user_timeout
> '
> 
> This is due to tcp_sock_set_nodelay() and tcp_sock_set_user_timeout() being
> declared in linux/tcp.h and defined in net/ipv4/tcp.c, which depend on
> TCP/IP being enabled.
> 
> To fix this, make OCFS2_FS depend on INET=y which already requires NET=y.
> 
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index 1177c33df895..aca16624b370 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config OCFS2_FS
>  	tristate "OCFS2 file system support"
> -	depends on NET && SYSFS && CONFIGFS_FS
> +	depends on INET && SYSFS && CONFIGFS_FS
>  	select JBD2
>  	select CRC32
>  	select QUOTA
> 
