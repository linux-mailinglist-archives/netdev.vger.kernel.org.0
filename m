Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47E720F36
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfEPTZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:25:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEPTZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:25:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63421133E97B3;
        Thu, 16 May 2019 12:25:58 -0700 (PDT)
Date:   Thu, 16 May 2019 12:25:57 -0700 (PDT)
Message-Id: <20190516.122557.1330236058135894100.davem@davemloft.net>
To:     hujunwei4@huawei.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        mingfangsen@huawei.com, wangxiaogang3@huawei.com,
        wangwang2@huawei.com
Subject: Re: [PATCH] tipc: switch order of device registration to fix a
 crash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6674f2cd-53bc-bb9a-931e-d4dde6ef01e8@huawei.com>
References: <6674f2cd-53bc-bb9a-931e-d4dde6ef01e8@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:25:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hujunwei <hujunwei4@huawei.com>
Date: Thu, 16 May 2019 10:51:15 +0800

> From: Junwei Hu <hujunwei4@huawei.com>
> 
> When tipc is loaded while many processes try to create a TIPC socket,
> a crash occurs:
>  PANIC: Unable to handle kernel paging request at virtual
>  address "dfff20000000021d"
>  pc : tipc_sk_create+0x374/0x1180 [tipc]
>  lr : tipc_sk_create+0x374/0x1180 [tipc]
>    Exception class = DABT (current EL), IL = 32 bits
>  Call trace:
>   tipc_sk_create+0x374/0x1180 [tipc]
>   __sock_create+0x1cc/0x408
>   __sys_socket+0xec/0x1f0
>   __arm64_sys_socket+0x74/0xa8
>  ...
> 
> This is due to race between sock_create and unfinished
> register_pernet_device. tipc_sk_insert tries to do
> "net_generic(net, tipc_net_id)".
> but tipc_net_id is not initialized yet.
> 
> So switch the order of the two to close the race.
> 
> This can be reproduced with multiple processes doing socket(AF_TIPC, ...)
> and one process doing module removal.
> 
> Fixes: a62fbccecd62 ("tipc: make subscriber server support net namespace")
> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> Reported-by: Wang Wang <wangwang2@huawei.com>
> Reviewed-by: Xiaogang Wang <wangxiaogang3@huawei.com>

Applied and queued up for -stable.
