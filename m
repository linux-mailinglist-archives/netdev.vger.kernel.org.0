Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC31DC85F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgEUIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgEUISZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 04:18:25 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9349EC061A0F
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:18:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so4798916wmb.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bqOLOWJcEnmegQMbnR/7WAD5Ory2NkimcCLFj6PkXT4=;
        b=MNKVdqYIQu1sZpEEWrjFHTTAgUy+R5a9ibTbTktvHRxg5WU3UwsT+DYDhAfDTZ1ZVN
         WUkF2IPbZmlF4VcwHRt2g+0rwVYfAWsxUMpNDxOZKs9mfmROSBdrBuvxcGKRLC1byQ50
         gtHo3VrT/HT9vEGVkBYTSpJJxyNB1z1PPj1jQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bqOLOWJcEnmegQMbnR/7WAD5Ory2NkimcCLFj6PkXT4=;
        b=rqkHA57ZLvmuJ9SOxhk8tOPwzKJ2SecfhXP5ruILqNjqv0HW5s0iYJ2y+1607QUy67
         t6PC36244b9buVD0yndAvShWtC7Rjv8jZSKU4w58s94XHTYxkrCczQAEslnWsW8a8g+k
         /mdseaNrAtbpuqTTM1GW+e3sEJ7vK7ENLXN0mQko1rA5ki0lZmMeCBcLplJbBB5tO+rV
         aOXApTemCg63e1LPw19Nkj46itwFA89xBcFRQ37fL+KKM8cJjz2ug8CrRgvR9HBqbZEL
         Bh3lGaypjI4TSFXNtdcuWYncBw9Dx+GsxuJjDv68lYEuaeeieQRBsMd4jPomW7DVLQdy
         2+lg==
X-Gm-Message-State: AOAM5308n/A20TIg1uz3MlPzzdYgEeQMxXeG8CiENOBuB8cr243tDT2s
        4GzFwo9laZnLVeBqTXEB1abJSg==
X-Google-Smtp-Source: ABdhPJwnoCs1FS19UI5zCtlLZR/jxDVg7B/c15iE+aCCyvnmoKKyxYyfj6nzMcAhOF8kUgyhShWwQg==
X-Received: by 2002:a1c:2186:: with SMTP id h128mr7558309wmh.108.1590049104333;
        Thu, 21 May 2020 01:18:24 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v2sm5840676wrn.21.2020.05.21.01.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 01:18:23 -0700 (PDT)
Subject: Re: [PATCH 3/3] bridge: mrp: Restore port state when deleting MRP
 instance
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, kuba@kernel.org,
        roopa@cumulusnetworks.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
 <20200520130923.3196432-4-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <05ddf496-9f6d-ae23-1bdb-40f0fe0e3b3c@cumulusnetworks.com>
Date:   Thu, 21 May 2020 11:18:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520130923.3196432-4-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 16:09, Horatiu Vultur wrote:
> When a MRP instance is deleted, then restore the port according to the
> bridge state. If the bridge is up then the ports will be in forwarding
> state otherwise will be in disabled state.
> 
> Fixes: 9a9f26e8f7ea ("bridge: mrp: Connect MRP API with the switchdev API")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index a5a3fa59c078a..bdd8920c15053 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -229,6 +229,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
>  static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
>  {
>  	struct net_bridge_port *p;
> +	u8 state;
>  
>  	/* Stop sending MRP_Test frames */
>  	cancel_delayed_work_sync(&mrp->test_work);
> @@ -240,20 +241,24 @@ static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
>  	p = rtnl_dereference(mrp->p_port);
>  	if (p) {
>  		spin_lock_bh(&br->lock);
> -		p->state = BR_STATE_FORWARDING;
> +		state = netif_running(br->dev) ?
> +				BR_STATE_FORWARDING : BR_STATE_DISABLED;
> +		p->state = state;
>  		p->flags &= ~BR_MRP_AWARE;
>  		spin_unlock_bh(&br->lock);
> -		br_mrp_port_switchdev_set_state(p, BR_STATE_FORWARDING);
> +		br_mrp_port_switchdev_set_state(p, state);
>  		rcu_assign_pointer(mrp->p_port, NULL);
>  	}
>  
>  	p = rtnl_dereference(mrp->s_port);
>  	if (p) {
>  		spin_lock_bh(&br->lock);
> -		p->state = BR_STATE_FORWARDING;
> +		state = netif_running(br->dev) ?
> +				BR_STATE_FORWARDING : BR_STATE_DISABLED;
> +		p->state = state;
>  		p->flags &= ~BR_MRP_AWARE;
>  		spin_unlock_bh(&br->lock);
> -		br_mrp_port_switchdev_set_state(p, BR_STATE_FORWARDING);
> +		br_mrp_port_switchdev_set_state(p, state);
>  		rcu_assign_pointer(mrp->s_port, NULL);
>  	}
>  
> 

