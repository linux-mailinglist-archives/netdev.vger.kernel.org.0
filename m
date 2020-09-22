Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E79A274C60
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgIVWoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgIVWoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:44:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13A32076E;
        Tue, 22 Sep 2020 22:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600814685;
        bh=w1l+xCZCGjc9zDLRy8mkzneUw0n1rmb/G1j0pqnnS5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zP7a2lLbDbgjdtikkb3zCJV8m62/k31ejBXtc5Xl4Dqswb+SOtaBvLffLJ5yuuSuq
         Jey08b9sFplieqChhE10OteCJAXZk8I9b+vUKogFnRMUj5BK4RI8n26+Xq7BSts2ri
         n+Mp2o70dg3lPbfPrmDC+87QyChfFpSfjf9QCoeA=
Date:   Tue, 22 Sep 2020 15:44:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net-next 1/3] ch_ktls: Issue if connection offload fails
Message-ID: <20200922154443.17ed8b94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922174501.14943-2-rohitm@chelsio.com>
References: <20200922174501.14943-1-rohitm@chelsio.com>
        <20200922174501.14943-2-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 23:14:59 +0530 Rohit Maheshwari wrote:
> Since driver first return success to tls_dev_add, if req to HW is
> successful, but later if HW returns failure, that connection traffic
> fails permanently and connection status remains unknown to stack.
> 
> Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

>  #if IS_ENABLED(CONFIG_IPV6)
>  	} else {
> -		if (!sk->sk_ipv6only &&
> -		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
> -			tx_info->ip_family = AF_INET;
> -			ret = chcr_ktls_act_open_req(sk, tx_info, atid);
> -		} else {
> -			tx_info->ip_family = AF_INET6;
> -			ret = cxgb4_clip_get(tx_info->netdev,
> -					     (const u32 *)
> -					     &sk->sk_v6_rcv_saddr.s6_addr,
> -					     1);
> -			if (ret)
> -				goto out;
> -			ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
> -		}
> +		ret = cxgb4_clip_get(tx_info->netdev, (const u32 *)
> +				     &sk->sk_v6_rcv_saddr,
> +				     1);
> +		if (ret)
> +			return ret;
> +		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);

You removed the mapped socket handling which seems unrelated to the
rest of the patch.

> +	spin_lock(&tx_info->lock);
> +	tx_info->conn_up = true;
> +	spin_unlock(&tx_info->lock);

What's the context this lock is taken in? You seem to always do only
spin_lock(), does the control path not need to be _bh() or _irq()?
