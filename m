Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E668C10CF7A
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfK1VRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 16:17:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfK1VRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 16:17:06 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25C87144FEC05;
        Thu, 28 Nov 2019 13:17:03 -0800 (PST)
Date:   Thu, 28 Nov 2019 13:17:00 -0800 (PST)
Message-Id: <20191128.131700.1033448847172021072.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net 1/2] openvswitch: drop unneeded BUG_ON() in
 ovs_flow_cmd_build_info()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
References: <cover.1574769406.git.pabeni@redhat.com>
        <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 13:17:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 26 Nov 2019 13:10:29 +0100

> All callers already deal with errors correctly, dump a warn instead.
> 
> Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/openvswitch/datapath.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index d8c364d637b1..e94f675794f1 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -882,7 +882,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const struct sw_flow *flow,
>  	retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
>  					info->snd_portid, info->snd_seq, 0,
>  					cmd, ufid_flags);
> -	BUG_ON(retval < 0);
> +	WARN_ON_ONCE(retval < 0);
>  	return skb;
>  }

I don't think this is right.  We should propagate the error by freeing the skb
and returning a proper error pointer based upon retval.
