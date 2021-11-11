Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D4544D9B4
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhKKQEE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 11:04:04 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:29216 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhKKQED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:04:03 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-qMVe2BLbM32ATq7CSvPpIQ-1; Thu, 11 Nov 2021 11:01:10 -0500
X-MC-Unique: qMVe2BLbM32ATq7CSvPpIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD013100C660;
        Thu, 11 Nov 2021 16:01:06 +0000 (UTC)
Received: from hog (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D20485DA61;
        Thu, 11 Nov 2021 16:01:03 +0000 (UTC)
Date:   Thu, 11 Nov 2021 17:01:02 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: Re: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <YY0+PmNU4MSGfgqA@hog>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
In-Reply-To: <20211110114448.2792314-3-maciej.machnikowski@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maciej,

2021-11-10, 12:44:44 +0100, Maciej Machnikowski wrote:
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 5888492a5257..1d8662afd6bd 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -185,6 +185,9 @@ enum {
>  	RTM_GETNEXTHOPBUCKET,
>  #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
>  
> +	RTM_GETEECSTATE = 124,
> +#define RTM_GETEECSTATE	RTM_GETEECSTATE

I'm not sure about this. All the other RTM_GETxxx are such that
RTM_GETxxx % 4 == 2. Following the current pattern, 124 should be
reserved for RTM_NEWxxx, and RTM_GETEECSTATE would be 126.

Also, why are you leaving a gap (which you end up filling in patch
4/6)?

> +
>  	__RTM_MAX,
>  #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
>  };
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 2af8aeeadadf..03bc773d0e69 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -5467,6 +5467,83 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  	return skb->len;
>  }
>  
> +static int rtnl_fill_eec_state(struct sk_buff *skb, struct net_device *dev,
> +			       u32 portid, u32 seq, struct netlink_callback *cb,
> +			       int flags, struct netlink_ext_ack *extack)
> +{
[...]
> +	nlh = nlmsg_put(skb, portid, seq, RTM_GETEECSTATE, sizeof(*state_msg),
> +			flags);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	state_msg = nlmsg_data(nlh);
> +	state_msg->ifindex = dev->ifindex;

Why stuff this in a struct instead of using an attribute?

> +
> +	if (nla_put_u32(skb, IFLA_EEC_STATE, state))
> +		return -EMSGSIZE;
> +
> +	if (!ops->ndo_get_eec_src)
> +		goto end_msg;
> +
> +	err = ops->ndo_get_eec_src(dev, &src_idx, extack);
> +	if (err)
> +		return err;
> +
> +	if (nla_put_u32(skb, IFLA_EEC_SRC_IDX, src_idx))
> +		return -EMSGSIZE;
> +
> +end_msg:
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +}
> +

Thanks,

-- 
Sabrina

