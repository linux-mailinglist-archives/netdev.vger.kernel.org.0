Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFF68885B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjBBUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBBUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:42:45 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBF1719B6;
        Thu,  2 Feb 2023 12:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675370565; x=1706906565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ty5vQCMykoiLZQVo22E5dC7bQL+JDmT4dIwBXa/PWZY=;
  b=iyTvNi5DpTAJNiaMYVq9RJ8JuNGt3YXAihqQc6XcxVQKnhoFyz018j0R
   u4QUwk+qQy0gSFTXqU17UJeQ8ljlyNC3xoCGpfnfHkfb7quuJO20zg/8I
   r0MOaiN3Nitx85kpuRG+lo3VT9WNL2ZnRB2iINfXoXT00CwF2WFq9WXlj
   0=;
X-IronPort-AV: E=Sophos;i="5.97,268,1669075200"; 
   d="scan'208";a="306998494"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 20:42:38 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 724E681DE4;
        Thu,  2 Feb 2023 20:42:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 2 Feb 2023 20:42:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.198) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Thu, 2 Feb 2023 20:42:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <whzhao@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH] net/socket: set socket inode times to current_time
Date:   Thu, 2 Feb 2023 12:42:24 -0800
Message-ID: <20230202204224.9668-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201043019.592994-1-whzhao@gmail.com>
References: <20230201043019.592994-1-whzhao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D32UWB003.ant.amazon.com (10.43.161.220) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Wenhua Zhao <whzhao@gmail.com>
Date:   Tue, 31 Jan 2023 20:30:19 -0800
> Socket creation time are sometimes useful but not available becasue the
> socket inode times are not set when initializing the inode.  This patch
> sets the socket inode times to current_time().
> 
> Before the fix, the socket inode times are at epoch, for example:
> 
>     $ stat -L /proc/383/fd/3
>       File: /proc/383/fd/3
>       Size: 0               Blocks: 0          IO Block: 4096   socket
>     Device: 0,8     Inode: 15996       Links: 1
>     Access: (0777/srwxrwxrwx)  Uid: ( 1000/    arch)   Gid: ( 1000/    arch)
>     Access: 1970-01-01 00:00:00.000000000 +0000
>     Modify: 1970-01-01 00:00:00.000000000 +0000
>     Change: 1970-01-01 00:00:00.000000000 +0000
> 
> After the fix, the inode times are the socket creation time:
> 
>     $ stat -L /proc/254/fd/3
>       File: /proc/254/fd/3
>       Size: 0               Blocks: 0          IO Block: 4096   socket
>     Device: 0,7     Inode: 13170       Links: 1
>     Access: (0777/srwxrwxrwx)  Uid: ( 1000/    arch)   Gid: ( 1000/    arch)
>     Access: 2023-02-01 03:27:50.094731201 +0000
>     Modify: 2023-02-01 03:27:50.094731201 +0000
>     Change: 2023-02-01 03:27:50.094731201 +0000
> 
> Signed-off-by: Wenhua Zhao <whzhao@gmail.com>

Looks good, but we may want to use another example in changelog
because you can get almost the same time without the -L option
and the use case is bit confusing at least for me.

I guess you will use it in your application, not from the outside
world by stat.

  $ python3
  >>> from socket import socket
  >>> from os import fstat
  >>> 
  >>> sk = socket()
  >>> fstat(sk.fileno())
  os.stat_result(..., st_atime=0, st_mtime=0, st_ctime=0)


> ---
>  net/socket.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 888cd618a968..c656c9599a92 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -635,6 +635,7 @@ struct socket *sock_alloc(void)
>  	inode->i_uid = current_fsuid();
>  	inode->i_gid = current_fsgid();
>  	inode->i_op = &sockfs_inode_ops;
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
>  
>  	return sock;
>  }
> -- 
> 2.39.1
