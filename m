Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0B746BDFE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhLGOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:45:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:33340 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhLGOp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:45:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237394146"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237394146"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 06:41:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="542817050"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2021 06:41:53 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B7Efpn0027212;
        Tue, 7 Dec 2021 14:41:51 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] net: gro: use IS_ERR before PTR_ERR
Date:   Tue,  7 Dec 2021 15:41:37 +0100
Message-Id: <20211207144137.22454-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211207073116.3856-1-guozhengkui@vivo.com>
References: <20211207073116.3856-1-guozhengkui@vivo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo Zhengkui <guozhengkui@vivo.com>
Date: Tue,  7 Dec 2021 15:31:09 +0800

Hi, thanks for your patch.

> fix following cocci warning:
> ./net/core/gro.c:493:5-12: ERROR: PTR_ERR applied after initialization to constant on line 441
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  net/core/gro.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index 8ec8b44596da..ee08f7b23793 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -490,9 +490,11 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>  	if (&ptype->list == head)
>  		goto normal;
>  
> -	if (PTR_ERR(pp) == -EINPROGRESS) {
> -		ret = GRO_CONSUMED;
> -		goto ok;
> +	if (IS_ERR(pp)) {
> +		if (PTR_ERR(pp) == -EINPROGRESS) {
> +			ret = GRO_CONSUMED;
> +			goto ok;
> +		}
>  	}

`if (PTR_ERR(ptr) == -ERRNO)` itself is correct without a check for
IS_ERR(). The former basically is a more precise test comparing to
the latter.
Not sure if compilers can get it well, but in ideal case the first
will be omitted from the object code at all, and so do we.

In case I'm wrong and this is a correct fix, it at least shouldn't
increase the indentation by one, these two conditions can be placed
into one `if` statement.

NAK.

>  
>  	same_flow = NAPI_GRO_CB(skb)->same_flow;
> -- 
> 2.20.1

Al
