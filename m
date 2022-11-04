Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16B66192FD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiKDIzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDIzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D527911
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 01:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667552055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gr1wY6sSt1hoS3mYpommqdVuyVTPiwyA2H0wzIyKK8M=;
        b=NP9JpIuX+i9pu5EXpTpCIzsoF/1n5l3C8GBlfNjXl3UJiXxn9A0L1TVddeFmQyGhb2Izji
        bXEuZ0CKCHpZoUEYU9taghQLvKGzVH2E+NSt2nzptlOGWhnInnP+fd8c6xIqoZUevE4Svs
        5L3pV4xqJMptU6Pz8WlwY0M5mUjAzvQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-d9ndw2-vPrqn_pmo6xN-Qg-1; Fri, 04 Nov 2022 04:54:14 -0400
X-MC-Unique: d9ndw2-vPrqn_pmo6xN-Qg-1
Received: by mail-wm1-f70.google.com with SMTP id 187-20020a1c02c4000000b003cf6fce8005so2016506wmc.9
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 01:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gr1wY6sSt1hoS3mYpommqdVuyVTPiwyA2H0wzIyKK8M=;
        b=SoipQEW2157XCGe98GRLlHVGuB4PeqOQyxyc9+FRZSzwuJz/9Qe2hGnv+SmdokRHpx
         QP+ml9uUK+03MutF36WFG9VWSopeCkCuMcoo1IbXFJVR/o+Jxa1XM5gb/x3swWzHE5qH
         9NFqEqAmtTpocNDvELniT8igjD0moUAfDOB3O5NZfWaeHoOKsgKwCV8hvfM4JOUYicOI
         x+U7kMVlRHRhtD47Hcmono5KxKTrZxXeTQ3XdXWDqT+kd0klOGrYiP9hhrhWbPzU5XYS
         tBkkcdXEuz9al+5mU6X0VmCXFThdnp/hAgK8x/Wa95RkQi39OPUQAZmZuGmN6IDNLb+X
         vjXA==
X-Gm-Message-State: ACrzQf2HSuQB+epRwCAbUNjegFUWXclWp/q26EaoDSK5zY1luf+Honsl
        aS4HlevOJQbFOGL7u7euQql8OYn+pLcoMJc+I5L5uOr35R9T3PBuOKcYCseBeA3OI2KenvGR82W
        EEXanh+Xl6iSeUrgz
X-Received: by 2002:a05:6000:118c:b0:236:bc26:7e0d with SMTP id g12-20020a056000118c00b00236bc267e0dmr19218590wrx.662.1667552052685;
        Fri, 04 Nov 2022 01:54:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7yXnIGxikq2vzqVFl87h+g1TzaFa9UX/NPHekL+f5fGRz5+gG0TPEkydfQE8mAAeCzMDGaCg==
X-Received: by 2002:a05:6000:118c:b0:236:bc26:7e0d with SMTP id g12-20020a056000118c00b00236bc267e0dmr19218581wrx.662.1667552052425;
        Fri, 04 Nov 2022 01:54:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-124-216.dyn.eolo.it. [146.241.124.216])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c351300b003b4ff30e566sm10543308wmq.3.2022.11.04.01.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 01:54:11 -0700 (PDT)
Message-ID: <da8cb23e4b0909a3bdde8e267b4df7df4c1575f7.camel@redhat.com>
Subject: Re: [PATCH] selftests/net: give more time to udpgro bg processes to
 complete startup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Adrien Thierry <athierry@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Date:   Fri, 04 Nov 2022 09:54:10 +0100
In-Reply-To: <20221103204607.520b36ac@kernel.org>
References: <20221101184809.50013-1-athierry@redhat.com>
         <20221103204607.520b36ac@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-03 at 20:46 -0700, Jakub Kicinski wrote:
> On Tue,  1 Nov 2022 14:48:08 -0400 Adrien Thierry wrote:
> > In some conditions, background processes in udpgro don't have enough
> > time to set up the sockets. When foreground processes start, this
> > results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
> > refused". For instance, this happens from time to time on a Qualcomm
> > SA8540P SoC running CentOS Stream 9.
> > 
> > To fix this, increase the time given to background processes to
> > complete the startup before foreground processes start.
> > 
> > Signed-off-by: Adrien Thierry <athierry@redhat.com>
> > ---
> > This is a continuation of the hack that's present in those tests. Other
> > ideas are welcome to fix this in a more permanent way.
> 
> Perhaps we can add an option to the Rx side to daemonize itself after
> setting up the socket, that way the bash script will be locked until 
> Rx is ready?

Then it will be less straigh-forward for the running shell waiting for
all the running processes. 

Another option would be replacing the sleep with a loop waiting for 
the rx UDP socket to appear in the procfs or diag interface, alike what
mptcp self-tests (random example;) are doing:

https://elixir.bootlin.com/linux/v6.1-rc3/source/tools/testing/selftests/net/mptcp/mptcp_join.sh#L424

Cheers,

Paolo

