Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F444D523B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiCJS2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241941AbiCJS2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:28:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00F2F15879D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646936822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CSczryzj031VVnO8eJpye9yxAEBMNM6MicTo8SxTACA=;
        b=eqSDXM8Hx65BCVou3DN/eFTTUxIkXmMeD+PmRYGaB7RYxfJggsxNjuAMi8rdZFb/dBKuXO
        yDhHFq4c0wD5/6bQxOv5Z3T9etkp8bYP38dVs58Fx6w9+Ej70sni2zmAD/sKeeDZCvhATf
        S6ztl9I8UBWzD3V+v83TUxtvQUMeA6I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-yGtkZ8M1OMS76ibIAKjx6A-1; Thu, 10 Mar 2022 13:27:01 -0500
X-MC-Unique: yGtkZ8M1OMS76ibIAKjx6A-1
Received: by mail-wm1-f69.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so2615772wmc.3
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:27:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CSczryzj031VVnO8eJpye9yxAEBMNM6MicTo8SxTACA=;
        b=XRJmEJc0fzJArp/7cRA30IVv/dRJ3Wbrp7dy0t3L7MOQbJgsSLLNp8ACpgA0IGc93i
         mvy+cSuKrcViWR1mdB+0tOrmxUqB1/NcatYoIdxgsU+jKhR2xzNQG7blyLMMNphzE3PV
         +zbFz2Pqetnuc2AkCShduT5F1oRNCz11MENmZVFy0h4pIRzuJTTyAzmeq/3AcXZSsIsu
         h0q9HEWAQlUvflVS2JL7sOLfHmGl2eweEoo+qbwGhQeAkkLzJqNZl7ezKu79HcWhKlhg
         2qJZDPnojKLYq2aI67AzDAtDp9rCHhaeXE86L7nYy5DW0to+bQk6vj2kYrlpHrjfdmhw
         OobQ==
X-Gm-Message-State: AOAM531woFxha15Ud+AG211nVm0WyzYGYfl77VViAsVUBgjfsK44oSH8
        f+ywaBs4h6c2+2k2OgFFFty54t39JVuf/4mBLdgJoJJsl4yLpnOwEBUE67S0kvBtKsLRO0bOxAC
        T13euAQJZ2ufRQSzf
X-Received: by 2002:a05:600c:694:b0:389:9c6e:c265 with SMTP id a20-20020a05600c069400b003899c6ec265mr4674822wmn.5.1646936819342;
        Thu, 10 Mar 2022 10:26:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzxyk/WYa3lWrgxd8M4yVHOBS8nqD6V5EkGQy/tg851C+baCex/bodG+xR2uUh2NI2oewSow==
X-Received: by 2002:a05:600c:694:b0:389:9c6e:c265 with SMTP id a20-20020a05600c069400b003899c6ec265mr4674811wmn.5.1646936819132;
        Thu, 10 Mar 2022 10:26:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id f13-20020adff8cd000000b001f03439743fsm4796930wrq.75.2022.03.10.10.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 10:26:58 -0800 (PST)
Message-ID: <1542f5746c3b03a735f407d789cf28dd71b02500.camel@redhat.com>
Subject: Re: [PATCH v3 net-next] net: add per-cpu storage and net->core_stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Date:   Thu, 10 Mar 2022 19:26:57 +0100
In-Reply-To: <20220310165243.981383-1-eric.dumazet@gmail.com>
References: <20220310165243.981383-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-10 at 08:52 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before adding yet another possibly contended atomic_long_t,
> it is time to add per-cpu storage for existing ones:
>  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> 
> Because many devices do not have to increment such counters,
> allocate the per-cpu storage on demand, so that dev_get_stats()
> does not have to spend considerable time folding zero counters.
> 
> Note that some drivers have abused these counters which
> were supposed to be only used by core networking stack.
> 
> v3: added a READ_ONCE() in netdev_core_stats_alloc() (Paolo)
> 
> v2: add a missing include (reported by kernel test robot <lkp@intel.com>)
>     Change in netdev_core_stats_alloc() (Jakub)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: jeffreyji <jeffreyji@google.com>
> Reviewed-by: Brian Vazquez <brianvv@google.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Thanks for quick turnaround, LGTM!

Acked-by: Paolo Abeni <pabeni@redhat.com>

