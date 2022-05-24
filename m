Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F053264E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiEXJZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 05:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiEXJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 05:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAC627522C
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653384301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKye4Y3eUY4jNM8Su0ObfpqLlZ+PYQe1qEjXF7f5pBM=;
        b=BpDhs8oms5gytc1cQZEu/BF12KSq8ZDBS3lCFn55GrihBTsSTzJ8eiZak6sEbl6tb+HXG/
        rVKO5uEO6TurYYLyADsewUs1/EcIM16mYTva7x734S/RYqRLlEUkcBVHIsaDmDTwopC2M5
        YT1z+XJKJaBc8sAIagyDeaEckyDlkMg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-XfR0KO5MM5uNvDXgq4fyFA-1; Tue, 24 May 2022 05:24:52 -0400
X-MC-Unique: XfR0KO5MM5uNvDXgq4fyFA-1
Received: by mail-qk1-f199.google.com with SMTP id z13-20020a05620a100d00b006a3870a404bso3924398qkj.17
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 02:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AKye4Y3eUY4jNM8Su0ObfpqLlZ+PYQe1qEjXF7f5pBM=;
        b=46Zs7cxaiZFA9fx3Ff2B7kiRixLw6P3hZkwvBvvGyx9kvOaT52hxMU49OHcBS5tj/l
         2F6LeEWibwqA/GODKD71OF7rYGLXYlP+zOf/Wux8H2vFVfKSSc4HslxLmL0BL31q5Eiw
         lQklAERG9CxeOZoJ1V8eskVmsEeVQxMndQLFdLYEKB2NUf6Vnd9oOqXGlIAzGgw0iABY
         /D6qR1M6qDl4tNAFmjP8Vc733YZl4HTR30kl8GdFpbSQu6qqOTe3sFrWyA14dDbGGoBA
         YB1+8tedrLRrjCKM6AZKhA0MIeiWrS75hC5beSu1S5wb12SzpJCWGHiizOcVC3KaBRkY
         ch3Q==
X-Gm-Message-State: AOAM533S0I2ocrNc+lUbkqyunk+b2LY7wWC2GxhDvO6s8AXeU7QBph0e
        p3Z4K2QLGFg5Ao79+2od/g8SsOlLsz9CppxZLPFvC4JfEXQuK44VnOOeTqts7FcOgCz/ggceGvW
        I9SaDPcyRdIaKH2Ar
X-Received: by 2002:ad4:5e89:0:b0:45a:d9c8:e04b with SMTP id jl9-20020ad45e89000000b0045ad9c8e04bmr20036152qvb.112.1653384291584;
        Tue, 24 May 2022 02:24:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnanVKHk5zhD3YbdX8xIfj66Ig1QSy92dtdIX9SQi2i5J+TiVoHndxkSaYz0ODCPVMPQ/zeA==
X-Received: by 2002:ad4:5e89:0:b0:45a:d9c8:e04b with SMTP id jl9-20020ad45e89000000b0045ad9c8e04bmr20036140qvb.112.1653384291358;
        Tue, 24 May 2022 02:24:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id l127-20020a37a285000000b0069fc13ce1f3sm5837253qke.36.2022.05.24.02.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 02:24:50 -0700 (PDT)
Message-ID: <76f1d70068523c173670819fc9a688a1368bfa12.camel@redhat.com>
Subject: Re: [PATCH] ipv6/addrconf: fix timing bug in tempaddr regen
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sam Edwards <cfsworks@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Date:   Tue, 24 May 2022 11:24:45 +0200
In-Reply-To: <20220523202543.9019-1-CFSworks@gmail.com>
References: <20220523202543.9019-1-CFSworks@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-23 at 14:25 -0600, Sam Edwards wrote:
> The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... block
> to categorize each address by what type of attention it needs.  An
> about-to-expire (RFC 4941) temporary address is one such category, but the
> previous elseif case catches addresses that have already run out their
> prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
> the necessary time window (i.e. REGEN_ADVANCE time units before the end of
> the prefered_lft), the temporary address will never be regenerated, and no
> temporary addresses will be available until each one's valid_lft runs out
> and manage_tempaddrs() begins anew.
> 
> Fix this by moving the entire temporary address regeneration case higher
> up so that a temporary address cannot be deprecated until it has had an
> opportunity to begin regeneration.  Note that this does not fix the
> problem of addrconf_verify_rtnl() sometimes not running in time resulting
> in the race condition described in RFC 4941 section 3.4 - it only ensures
> that the address is regenerated.

I looks like with this change the tmp addresses will never hit the
DEPRECATED branch ?!?


Thanks!

Paolo

