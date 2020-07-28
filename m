Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23175231631
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgG1XVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:21:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:47742 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbgG1XVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 19:21:11 -0400
IronPort-SDR: 6+ZqpiGc7JJeUSN+jebGQsGo4NUNBVe3jmd44qm1ftLd2nyoG0v0tjZTvxpU7lyobErsbPGHU3
 SWFNG5bI5jWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="138859776"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="138859776"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 16:21:10 -0700
IronPort-SDR: bPhJmEziTo821vgUDF9imYyUU2tYzRq4JC4HAblVeSP4I5YxlbK1QV2p45cZOzSGxwzBozaMxr
 S7L+OcurHbFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="273709824"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jul 2020 16:21:09 -0700
Subject: Re: [PATCH net] devlink: ignore -EOPNOTSUPP errors on dumpit
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@mellanox.com,
        kernel-team@fb.com
References: <20200728231507.426387-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8f0cce83-4d0d-2230-1727-86f9c7c2ac55@intel.com>
Date:   Tue, 28 Jul 2020 16:21:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200728231507.426387-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 4:15 PM, Jakub Kicinski wrote:
> Number of .dumpit functions try to ignore -EOPNOTSUPP errors.
> Recent change missed that, and started reporting all errors
> but -EMSGSIZE back from dumps. This leads to situation like
> this:
> 
> $ devlink dev info
> devlink answers: Operation not supported
> 
> Dump should not report an error just because the last device
> to be queried could not provide an answer.
> 
> To fix this and avoid similar confusion make sure we clear
> err properly, and not leave it set to an error if we don't
> terminate the iteration.
> 

Makes sense to me.

> Fixes: c62c2cfb801b ("net: devlink: don't ignore errors during dumpit")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/devlink.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 2cafbc808b09..1d38b6651b23 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1065,7 +1065,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
>  						   devlink_sb,
>  						   NETLINK_CB(cb->skb).portid,
>  						   cb->nlh->nlmsg_seq);
> -			if (err && err != -EOPNOTSUPP) {
> +			if (err == -EOPNOTSUPP) {
> +				err = 0;
> +			} else if (err) {
>  				mutex_unlock(&devlink->lock);
>  				goto out;
>  			}
> @@ -1266,7 +1268,9 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
>  							devlink, devlink_sb,
>  							NETLINK_CB(cb->skb).portid,
>  							cb->nlh->nlmsg_seq);
> -			if (err && err != -EOPNOTSUPP) {
> +			if (err == -EOPNOTSUPP) {
> +				err = 0;
> +			} else if (err) {
>  				mutex_unlock(&devlink->lock);
>  				goto out;
>  			}
> @@ -1498,7 +1502,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
>  							   devlink_sb,
>  							   NETLINK_CB(cb->skb).portid,
>  							   cb->nlh->nlmsg_seq);
> -			if (err && err != -EOPNOTSUPP) {
> +			if (err == -EOPNOTSUPP) {
> +				err = 0;
> +			} else if (err) {
>  				mutex_unlock(&devlink->lock);
>  				goto out;
>  			}
> @@ -3299,7 +3305,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
>  						    NETLINK_CB(cb->skb).portid,
>  						    cb->nlh->nlmsg_seq,
>  						    NLM_F_MULTI);
> -			if (err && err != -EOPNOTSUPP) {
> +			if (err == -EOPNOTSUPP) {
> +				err = 0;
> +			} else if (err) {
>  				mutex_unlock(&devlink->lock);
>  				goto out;
>  			}
> @@ -3569,7 +3577,9 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
>  						NETLINK_CB(cb->skb).portid,
>  						cb->nlh->nlmsg_seq,
>  						NLM_F_MULTI);
> -				if (err && err != -EOPNOTSUPP) {
> +				if (err == -EOPNOTSUPP) {
> +					err = 0;
> +				} else if (err) {
>  					mutex_unlock(&devlink->lock);
>  					goto out;
>  				}
> @@ -4518,7 +4528,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
>  					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
>  					   cb->extack);
>  		mutex_unlock(&devlink->lock);
> -		if (err && err != -EOPNOTSUPP)
> +		if (err == -EOPNOTSUPP)
> +			err = 0;
> +		else if (err)
>  			break;
>  		idx++;
>  	}
> 
