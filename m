Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCAC4E8972
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 20:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiC0S7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 14:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiC0S7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 14:59:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E32011C0B;
        Sun, 27 Mar 2022 11:58:09 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j15so24505745eje.9;
        Sun, 27 Mar 2022 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kB2dOSwca7bk7/EKKWZtu1L76wh+UxbbfaUTKA78p6Y=;
        b=ksWbGKH7kiaxZP48hFJISoG79zBpeexh8ccaT1c7ynHJiV23AD51JKAQAu+ccvKKXV
         KkUkGI13NTqGnXvT/l1H6+xFTqRYkwVGpQX15HI2UOsuL23YtgCEoWZPr0endQXHzcaD
         SFNF3Ijw97JOsKHIo1ACuinv+4YjLzP2FWMRD8dPsuOHrRQ3JNAGJnq7SFJ47Ng9S2Wr
         OrWlURFr28oQJQOzV0gLYtvwPUqZ3ZPIfIVS0/SczLUu8jDxQgYumg4sX22M9o9cgNmo
         CP/gJZoUsWqyzCfLol65j2N+4wtBcxs3DWZzUJSYfX0+L20/GLDkVz7BX9RQGQBAhqx0
         fHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kB2dOSwca7bk7/EKKWZtu1L76wh+UxbbfaUTKA78p6Y=;
        b=zhRx42yc/DCGeRjeEaQUdMgVPoXxDwBv4SUCU/Y585trjEqDdi0A0LYShYCHhGbmXR
         UOD5wcVKBcsnZgUFvgZ89gtbt0Q1LF0vBKHMhbK+6AkF96CvQJpfeqyK+sBNA8ULnJTV
         7FvkOJ0kmx+fXXjtPeSshbKghZOTMT/AkQ8JZDVHJnrVI+Sgfbb2i5CueKnlz5Q30RFT
         ISv3IUEtu78Uy7YLv2ZiaUf/gJ1ICXhFl/3DgfOHR+9MuuoYcPKHpC3OURxbKkBevn9y
         oSAog0i9BH5jT6zXS1OybITaPVurYe5TpWrY3O5xxFEU5QPNg3pgILcuqSFHJpx5lRSS
         wPfw==
X-Gm-Message-State: AOAM533mwKnXsPXJO+liY0/NksPE79SIwayr7GIl2HyFo/JOk4nff30X
        LfuUXqaqJQ9Y+pZfzSzJd0E=
X-Google-Smtp-Source: ABdhPJzrVnJ+knNSeLJwI+w7wX7LgEVhuYbYbtJYsxnQ+zV8liChL9ZCGlcMUVPR4T4j6gG0jo3X2A==
X-Received: by 2002:a17:907:3f9e:b0:6da:842e:873e with SMTP id hr30-20020a1709073f9e00b006da842e873emr23359379ejc.383.1648407487434;
        Sun, 27 Mar 2022 11:58:07 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id n9-20020a05640205c900b00418d79d4a61sm6234792edx.97.2022.03.27.11.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 11:58:06 -0700 (PDT)
Date:   Sun, 27 Mar 2022 21:58:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dsa: bcm_sf2_cfp: fix an incorrect NULL check on list
 iterator
Message-ID: <20220327185805.cibcmk4rejgb7jre@skbuf>
References: <20220327055547.3938-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327055547.3938-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 27, 2022 at 01:55:47PM +0800, Xiaomeng Tong wrote:
> The bug is here:
> 	return rule;
> 
> The list iterator value 'rule' will *always* be set and non-NULL
> by list_for_each_entry(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> is found.
> 
> To fix the bug, return 'rule' when found, otherwise return NULL.
> 
> Cc: stable@vger.kernel.org
> Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---

The change looks correct, but from a process standpoint for next time
(a) you should have copied Florian, the driver's maintainer (which I did now)
    who appears on the top of the list in the output of ./get_maintainer.pl
(b) networking bugfixes that apply to the "net" tree shouldn't need
    stable@vger.kernel.org copied, instead just target the patch against
    the https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
    tree and mark the subject prefix as "[PATCH net]".

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/bcm_sf2_cfp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
> index a7e2fcf2df2c..edbe5e7f1cb6 100644
> --- a/drivers/net/dsa/bcm_sf2_cfp.c
> +++ b/drivers/net/dsa/bcm_sf2_cfp.c
> @@ -567,14 +567,14 @@ static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
>  static struct cfp_rule *bcm_sf2_cfp_rule_find(struct bcm_sf2_priv *priv,
>  					      int port, u32 location)
>  {
> -	struct cfp_rule *rule = NULL;
> +	struct cfp_rule *rule;
>  
>  	list_for_each_entry(rule, &priv->cfp.rules_list, next) {
>  		if (rule->port == port && rule->fs.location == location)
> -			break;
> +			return rule;
>  	}
>  
> -	return rule;
> +	return NULL;
>  }
>  
>  static int bcm_sf2_cfp_rule_cmp(struct bcm_sf2_priv *priv, int port,
> -- 
> 2.17.1
> 
