Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAC830186
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3SIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:08:43 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42698 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:08:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id go2so2865122plb.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YNPTvz4BB+El8+FfCuqPjz+lxh9rxe3Q6i3SW+1sDzg=;
        b=1wrWpUmGV1LaPM63sUzAhYnbuyOykbV6I1uE+02IYK5FZORkA2zeoD0KaDTmwLMx8m
         ZmSv2HcBBnVX+y4CMlNMd7FUxrg/tok++ZHoAek5LebH6LhFuGWB1DHItvvGppK2uoCP
         d4WT8c59T7L1aX8g/+QtHMwlu7jscwfuZ5OL25cG5xqpLzqOctlEVSE6HclaxEoKzqFn
         xT4SRWkruvRTxj4TWanPIkosF+0zzkcSxQsFGc3aQnEjiv7GuWEtDvLpzldQr6FyrfNo
         H2vcp4bjfXhPeM73bQgwte8RkMEuUJhLb0hR55dN8hak0DRXDgbAmlsjhoPpZbHS3HPD
         lHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YNPTvz4BB+El8+FfCuqPjz+lxh9rxe3Q6i3SW+1sDzg=;
        b=IMUxiXg4rPgbIiKYe75HEQR/emc4c7VdUJ3c6sN0RGLF5a6MMJy037rdCul7jGHUwt
         bymseA/EuB/JwY/QNUhuiu3ufEtM04YpmOO+SqKqnUAJsiRjffKeNLhdXeShTRkBSkAY
         R/pPYC+91/B9CsCNtWLirZSrk5PXo0asiHIIQQ+KQTipuwqiqTedmC7GP8aFcVPZTKGF
         SSlVz6Cfq2gJhyeBzx3h5ynyk4+UKWK8Vs0O5zEUkdpgU9qSH2TnACRAbrlnKeW0/LIK
         YXPoIws4N+3fVgTYMTpHZSKmg6gjrZnWgTbqlxbjZXuR9WKJ2zLtvJf1U7dX5Y6wCD4X
         ctvA==
X-Gm-Message-State: APjAAAXUy7cWEgkpKgjLlm740WTOZAHnsXilRkgyrYMYkDvr4qZcMZ8B
        WFhJ8fAWdGuX2cLIJCD9B0WPdQ==
X-Google-Smtp-Source: APXvYqynwN5fl+ov9fSgyBAYYlk5vTvMgyM2xsE8i+bK6tEWfCa7XxGZLjmgc3MJl9UgC1R0n3n19w==
X-Received: by 2002:a17:902:7581:: with SMTP id j1mr4868812pll.23.1559239722398;
        Thu, 30 May 2019 11:08:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x66sm3699704pfx.139.2019.05.30.11.08.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 11:08:42 -0700 (PDT)
Date:   Thu, 30 May 2019 11:08:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH net v2 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
Message-ID: <20190530110840.794ba98b@hermes.lan>
In-Reply-To: <655b6508443c52f04be2b2fe9a6a7f2470b47ad1.1559237173.git.dcaratti@redhat.com>
References: <cover.1559237173.git.dcaratti@redhat.com>
        <655b6508443c52f04be2b2fe9a6a7f2470b47ad1.1559237173.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 20:03:41 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

>  
> +static inline int tc_skb_pull_vlans(struct sk_buff *skb,
> +				    unsigned int *hdr_count,
> +				    __be16 *proto)
> +{
> +	if (skb_vlan_tag_present(skb))
> +		*proto = skb->protocol;
> +
> +	while (eth_type_vlan(*proto)) {
> +		struct vlan_hdr *vlan;
> +
> +		if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
> +			return -ENOMEM;
> +
> +		vlan = (struct vlan_hdr *)skb->data;
> +		*proto = vlan->h_vlan_encapsulated_proto;
> +		skb_pull(skb, VLAN_HLEN);
> +		skb_reset_network_header(skb);
> +		(*hdr_count)++;
> +	}
> +	return 0;
> +}

Does this really need to be an inline, or could it just be
part of the sched_api?
