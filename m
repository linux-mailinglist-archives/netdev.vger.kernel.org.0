Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F304BD7A0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiBUIY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:24:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiBUIY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:24:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 579AB219B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 00:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645431843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/25ftUBRVOyj6AQYUTrNXUGoMwVqPUzKkuLetYVGyPo=;
        b=OaZ582Xk3G03T0FCRNuQI4Z/nCwbRNiVnKxvtqAiWA2bI3B5ahoIzOCn2E6CNBazJyQ9Gs
        tKQ0Xn3MV6XvlYk397N5pIowiSWtQuH4lwNzqaP7EU9HvJqkltvJYFDRUsTxSkatW1UXDt
        tzXY9Cp+BMaYw/6V8OD+SYP1KA0JPc0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-yC45BAHBOkudLkTgDmC2Qw-1; Mon, 21 Feb 2022 03:24:00 -0500
X-MC-Unique: yC45BAHBOkudLkTgDmC2Qw-1
Received: by mail-wr1-f70.google.com with SMTP id g17-20020adfa591000000b001da86c91c22so7072453wrc.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 00:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/25ftUBRVOyj6AQYUTrNXUGoMwVqPUzKkuLetYVGyPo=;
        b=LiDpp5P/REZoYvndvoX4SH/y109/ZFh7Ze1mpNGRKGnLQc4wnvJWiKNlOZoAJRRdtV
         ITFnQK0QygnE1XKuBbgdRdHTd8OhvLfxJdbOeuGi62GVJWz0Ggx/XbiSetKyH8gsycaS
         bVHB+TwX9vsRrYGnHBDZQH0cD46H6GMErCrWntGqwlGgp3IeQOsTZkoU4vBHAJyQqcIP
         BmKFQaYCM/cUG1ufC0juDzkRRX8QwMGUHhNzUbzCyXPpd6e1Sp3joPiwBE7fRS6GiPO2
         OnXuzaRoZR8eqWwIv/sJUo5//b3CEJ1iI7R9/o/3YZdqYLBD20wTmVLxE9AWXjDOLndx
         2Ccg==
X-Gm-Message-State: AOAM533IoWstA+pAK9IzVdgRxXJEA2ZjkNgqVYo9BgA+nLCLfGMhsPWA
        cd3XPdW6gSeT39srHl4bmH4LEUMBMUpN1MnQhH/rfG1rjeGK+cSSPx+DuBKCX7vlEJSUNX2z6vi
        lIFKZ9+JIdxeOTyUW
X-Received: by 2002:a05:6000:110e:b0:1e3:8fb:7de6 with SMTP id z14-20020a056000110e00b001e308fb7de6mr14428729wrw.698.1645431839450;
        Mon, 21 Feb 2022 00:23:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6HGo+qBLaq6F6bKCFxjVeBk5qJxoAGbA1etMwOw5z8a2RRVTRZgkqAXpgAV5S9LLynl4/tQ==
X-Received: by 2002:a05:6000:110e:b0:1e3:8fb:7de6 with SMTP id z14-20020a056000110e00b001e308fb7de6mr14428718wrw.698.1645431839237;
        Mon, 21 Feb 2022 00:23:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-206.dyn.eolo.it. [146.241.112.206])
        by smtp.gmail.com with ESMTPSA id y16sm12865232wrp.1.2022.02.21.00.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 00:23:58 -0800 (PST)
Message-ID: <294021ae1fae426d868195be77b053bd66f31772.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] gro_cells: avoid using synchronize_rcu() in
 gro_cells_destroy()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 09:23:57 +0100
In-Reply-To: <20220220041155.607637-1-eric.dumazet@gmail.com>
References: <20220220041155.607637-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-02-19 at 20:11 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Another thing making netns dismantles potentially very slow is located
> in gro_cells_destroy(),
> whenever cleanup_net() has to remove a device using gro_cells framework.
> 
> RTNL is not held at this stage, so synchronize_net()
> is calling synchronize_rcu():
> 
> netdev_run_todo()
>  ip_tunnel_dev_free()
>   gro_cells_destroy()
>    synchronize_net()
>     synchronize_rcu() // Ouch.
> 
> This patch uses call_rcu(), and gave me a 25x performance improvement
> in my tests.
> 
> cleanup_net() is no longer blocked ~10 ms per synchronize_rcu()
> call.
> 
> In the case we could not allocate the memory needed to queue the
> deferred free, use synchronize_rcu_expedited()
> 
> v2: made percpu_free_defer_callback() static
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I'm sorry for the late feedback. I'm wondering if you considered
placing the 'defer' pointer inside 'gro_cells' and allocating it at
gro_cells_init() init time?

Thanks!

Paolo

