Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D374E4DC498
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiCQLPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiCQLPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14387B82D9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647515628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVcqPPiLXW5cGN3IUXIR0PaHVVdLGQieih+Vbii4/G0=;
        b=FCNcVC7EwQu6vD311dmt0YckeY+xFIM+0NhkwA6yZN7ryx9JkafalTUlFHTe4vkfM3oxpa
        GDRIKHVrtznGUILjABjdborZROn6p1LUiApUGVqGp1NwINJkc4IaxJEXy2je95onoRq9xy
        aSdGDHfpbURaREO9E9+uopxUlimbY/0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-veKFyUXnNhCi1HcCsod0zw-1; Thu, 17 Mar 2022 07:13:47 -0400
X-MC-Unique: veKFyUXnNhCi1HcCsod0zw-1
Received: by mail-qv1-f72.google.com with SMTP id r2-20020a056214068200b00440e24889e6so1637746qvz.23
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LVcqPPiLXW5cGN3IUXIR0PaHVVdLGQieih+Vbii4/G0=;
        b=tskb6YisSiaasdGd4mgULva70wukOusoPQPSUo4Z8MMBvciJBqqZBY/vpiiDGPZlz7
         WiQXftzeB6exFq9UZgjvho/LKYAQ4quNZCLumHKihUs0zYVuDu2a0eSARoiy4JNeUjJY
         5YFWeE00b07YmxMWIMRdRg2IvSaymCQC9WdCDNTshrhKBUjuwyY6sT1S9oC8vImXz3PW
         vRlTfDjKWHy2Fjx1xIadMjYpSJVuIxAHJ7rl+NDCr+5BZaHgchDQ/UdvGrOpSSAKr5GJ
         Z9f73q7xBjZiE/L3/pRvhKBHV2lmcJZ9NaYg0C1Rvhx0HjD7n9mwUfzSXepQnLeasWYw
         Wp8w==
X-Gm-Message-State: AOAM533SCulPXtRYFF+meCofAJYY4Rv0wdbE59S0q8IlL4y0eb96ribv
        hal7nCR6eZqBucLX7GnzWmBgukmybuDIpqfrO/l1KXC78JhLvdjjDMlFrpNHW659CPeg6YO92yh
        TOlrnExUNF3msnbXN
X-Received: by 2002:ad4:5de3:0:b0:440:d7a9:dccc with SMTP id jn3-20020ad45de3000000b00440d7a9dcccmr2660929qvb.62.1647515626443;
        Thu, 17 Mar 2022 04:13:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3MMBjSYSRGru14m9hfeyr0VF+gnbSFp4iQzmbijekCShk/SWVj4UrOdUjYGeKCfByOpfj3Q==
X-Received: by 2002:ad4:5de3:0:b0:440:d7a9:dccc with SMTP id jn3-20020ad45de3000000b00440d7a9dcccmr2660917qvb.62.1647515626234;
        Thu, 17 Mar 2022 04:13:46 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id t28-20020a05620a005c00b00662fb1899d2sm2236271qkt.0.2022.03.17.04.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 04:13:45 -0700 (PDT)
Message-ID: <37e7909450ebd3b1abcc83119603aa75ab8fc22b.camel@redhat.com>
Subject: Re: [PATCH] ipv6: acquire write lock for addr_list in
 dev_forward_change
From:   Paolo Abeni <pabeni@redhat.com>
To:     Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Thu, 17 Mar 2022 12:13:41 +0100
In-Reply-To: <20220315230222.49793-1-dossche.niels@gmail.com>
References: <20220315230222.49793-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-16 at 00:02 +0100, Niels Dossche wrote:
> No path towards dev_forward_change (common ancestor of paths is in
> addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
> Since addrconf_{join,leave}_anycast acquire a write lock on addr_list in
> __ipv6_dev_ac_inc and __ipv6_dev_ac_dec, temporarily unlock when calling
> addrconf_{join,leave}_anycast analogous to how it's done in
> addrconf_ifdown.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
>  net/ipv6/addrconf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f908e2fd30b2..4055ded4b7bf 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -818,14 +818,18 @@ static void dev_forward_change(struct inet6_dev *idev)
>  		}
>  	}
>  
> +	write_lock_bh(&idev->lock);
>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>  		if (ifa->flags&IFA_F_TENTATIVE)
>  			continue;
> +		write_unlock_bh(&idev->lock);

This looks weird?!? if 'addr_list' integrity is guaranteed by 
idev->lock, than this patch looks incorrect. If addr_list integrity is
ensured elsewhere, why acquiring idev->lock at all?

@David: can you please comment here?

Thanks!

Paolo

