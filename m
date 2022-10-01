Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C095F1F10
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 21:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJATzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 15:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJATzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 15:55:45 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534131E3FD;
        Sat,  1 Oct 2022 12:55:44 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id c11so4519370qtw.8;
        Sat, 01 Oct 2022 12:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=EXPyziSI9XrJKR4N7tFFtj7Db6yUii4c3JcrHkEOd9c=;
        b=mAv1cQ+4HUYhaoyMyZ+fjRXKcLV4fuNofBYveEyQhVJhKcqp5eAqUyzd74jru+QwKR
         jyAhEMhJbnX7VAsjjjmuHVjTDrPu0ap9dwmGF9j5sUKevPFr8Rof/QrILAC8ycEXSTgr
         GK2PCuN65GOLov6SI4I32rYNKiKXd5eqCVmpY/fYIAvDE7//pbF/9sQp+PYC/IeLNtUF
         Ko5Gy6IzvLwOL9KfZiMbIUkC2nthB2vW8LU3ub9EEu7SMArXt1Dwvz/6Oh8pWoFTuDjo
         fgMZ09Edo941ZxFKueIyn8YZU/fhJkyw+p9QIIoPzyk6tiNRZBxsJO4UijsFBtwQ6tBV
         9qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EXPyziSI9XrJKR4N7tFFtj7Db6yUii4c3JcrHkEOd9c=;
        b=Shg4gna3CgsupsS7s+4+NBjGPdkGK/Ua8vJo5XWKiWlU7Nivakwdof1QSUCAxJgn1l
         r6DgJ9Y5hsG4nrxGzS7rJ11czGAnwUC4HhTzowCM01wpDw8tKCFIm16/mmQnHWznI8/X
         PF5XCRv0XaqocUeUrxIFKH8mXywBouHu3gPBHZrH9HRV6wDkDObORtFWhFSvsX+OZZlq
         YamkSN3fPijaVRXBAIX4z+PRbLVeV6F8mK44sLFrd6JnGAc98JwiQWPisnoQLQNwchdP
         NYLIK88XnqYZ47y/nCGpZoGQv1BmjwoZyitp6005jGztX5ZWLKjw5ty2uo7f2F7jgI8q
         afug==
X-Gm-Message-State: ACrzQf1egi16/eoSbBew9ItMfno+HZECwMgf3r/U7ec7oAz9Cmj8Ef/H
        71DMEfZu1EHalo9gfuTUJ4I=
X-Google-Smtp-Source: AMsMyM4ebDmn+qXpVGNhwbl1scUxStrJK465s8JVGsSD1p5g1xQI7PMxu4RxkHB6oQ3XrfyiEgY5Gg==
X-Received: by 2002:ac8:4e48:0:b0:35d:5831:af31 with SMTP id e8-20020ac84e48000000b0035d5831af31mr11663783qtw.188.1664654142328;
        Sat, 01 Oct 2022 12:55:42 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a570:880e:2c92:fa00])
        by smtp.gmail.com with ESMTPSA id q34-20020a05620a2a6200b006b8d1914504sm6574554qkp.22.2022.10.01.12.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 12:55:41 -0700 (PDT)
Date:   Sat, 1 Oct 2022 12:55:37 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        paulb@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: sched: act_ct: fix possible refcount leak in
 tcf_ct_init()
Message-ID: <YzibOQ2dviUNneAY@pop-os.localdomain>
References: <20220923020046.8021-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923020046.8021-1-hbh25y@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 10:00:46AM +0800, Hangyu Hua wrote:
> nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
> to avoid possible refcount leak when tcf_ct_flow_table_get fails.
> 
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> v2: use a new label to put the refcount.
> 
>  net/sched/act_ct.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index d55afb8d14be..5950974ae8f6 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1394,7 +1394,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>  
>  	err = tcf_ct_flow_table_get(net, params);
>  	if (err)
> -		goto cleanup;
> +		goto cleanup_params;
>  
>  	spin_lock_bh(&c->tcf_lock);
>  	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> @@ -1409,6 +1409,9 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>  
>  	return res;
>  
> +cleanup_params:
> +	if (params->tmpl)
> +		nf_ct_put(params->tmpl);

Nit: this NULL check is unnecessary.

Thanks.
