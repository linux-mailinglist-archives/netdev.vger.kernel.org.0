Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774941458CA
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAVP3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVP3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 10:29:17 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1160F2071E;
        Wed, 22 Jan 2020 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579706957;
        bh=XkqGwInSEuHlbrqD/5bGG9oHRFoSfMje7fCvTxH8xKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oyC7CsZrvgv+twcdSYBCHcUcSVl/LJwBtEw3uxIHMIg44c3o/H6SdGorBzI4QoUD2
         a6Hp/wKySozQUpj3U9+2vZo2/avubqNqcgeD0nycIbLnWBTVXMPllkQ3yg21oVTMqq
         4v/LHsyEaJY1BroX4U/e+hUepYkSy63hPaSA4mWk=
Date:   Wed, 22 Jan 2020 07:29:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v2 01/13] net: sched: support skb chain ext in
 tc classification path
Message-ID: <20200122072916.23fc3416@cakuba>
In-Reply-To: <1579701178-24624-2-git-send-email-paulb@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
        <1579701178-24624-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 15:52:46 +0200, Paul Blakey wrote:
> +int tcf_classify_ingress(struct sk_buff *skb,
> +			 const struct tcf_block *ingress_block,
> +			 const struct tcf_proto *tp, struct tcf_result *res,
> +			 bool compat_mode)
> +{
> +	const struct tcf_proto *orig_tp = tp;
> +
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +	{
> +		struct tc_skb_ext *ext = skb_ext_find(skb, TC_SKB_EXT);
> +
> +		if (ext && ext->chain && ingress_block) {
> +			struct tcf_chain *fchain;
> +
> +			fchain = tcf_chain_lookup_rcu(ingress_block,
> +						      ext->chain);
> +			if (!fchain)
> +				return TC_ACT_UNSPEC;
> +
> +			tp = rcu_dereference_bh(fchain->filter_chain);
> +		}

Doesn't this skb ext have to be somehow "consumed" by the first lookup?
What if the skb finds its way to an ingress of another device?

> +	}
> +#endif
> +
> +	return tcf_classify(skb, tp, orig_tp, res, compat_mode);
> +}
> +EXPORT_SYMBOL(tcf_classify_ingress);
