Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174062B0BA5
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKLRv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgKLRv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 12:51:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E7842085B;
        Thu, 12 Nov 2020 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605203485;
        bh=OLDD4EslDRYUhNcaiXD8psJSW2hp6UYq3/flGuai7Ps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YoyE5rtRWnPneuzvVz828ALIOpAxLtYSNp9eFg8mw/+ZbcBEDW6BnWkKOV9Rq3cHi
         t3/QOY4u+yCCIRD3HoH6DC1MnWKpAGWUzuJqXvAq4+tYrkXNRvQJQ5mwwb9cyrCq2U
         rAf31Rg3zdJXp/POFi/+MfkV5rSUbOLeoc1f84KU=
Date:   Thu, 12 Nov 2020 09:51:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jiri@nvidia.com>, <davem@davemloft.net>, <idosch@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] devlink: Add missing genlmsg_cancel() in
 devlink_nl_sb_port_pool_fill()
Message-ID: <20201112095124.660733a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111135853.63997-1-wanghai38@huawei.com>
References: <20201111135853.63997-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 21:58:53 +0800 Wang Hai wrote:
> If sb_occ_port_pool_get() failed in devlink_nl_sb_port_pool_fill(),
> msg should be canceled by genlmsg_cancel().
> 
> Fixes: df38dafd2559 ("devlink: implement shared buffer occupancy monitoring interface")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/core/devlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index a932d95be798..83b4e7f51b35 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1447,8 +1447,10 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
>  
>  		err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
>  						pool_index, &cur, &max);
> -		if (err && err != -EOPNOTSUPP)
> +		if (err && err != -EOPNOTSUPP) {
> +			genlmsg_cancel(msg, hdr);
>  			return err;

I guess the driver would have to return -EMSGSIZE for this to matter,
which is quite unlikely but we should indeed fix.

Still, returning in the middle of the function with an epilogue is what
got use here in the first place, so please use a goto. E.g. like this:


diff --git a/net/core/devlink.c b/net/core/devlink.c
index a932d95be798..be8ee96ad188 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1448,7 +1448,7 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
                err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
                                                pool_index, &cur, &max);
                if (err && err != -EOPNOTSUPP)
-                       return err;
+                       goto sb_occ_get_failure;
                if (!err) {
                        if (nla_put_u32(msg, DEVLINK_ATTR_SB_OCC_CUR, cur))
                                goto nla_put_failure;
@@ -1461,8 +1461,10 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
        return 0;
 
 nla_put_failure:
+       err = -EMSGSIZE;
+sb_occ_get_failure:
        genlmsg_cancel(msg, hdr);
-       return -EMSGSIZE;
+       return err;
 }
 
 static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,

