Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2CE65206C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiLTMgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiLTMgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:36:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB7C9FFF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671539727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXeVxc3rVhMfVXUF0r47fjYxAxtcLJDnYTEiZwRT4dc=;
        b=JZap14iqNpSzzPAYGgkyr3tbM4SqjnfzLI5uiUiAV0EezVf17sXcwrPUlM1OOqLo9P00zZ
        bp8EEgXp+TOXnwwoJH/0+ZsS2ZCPvzYjhFL55g2p+yfXeNqzfjg2Ylnv0pylbcm3hyVMxa
        ndQakBnZ8J3tZEu0uXEBeHA6gd+qw5Y=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-636-wWioGrbpOaWJ5laF6lhcBA-1; Tue, 20 Dec 2022 07:35:25 -0500
X-MC-Unique: wWioGrbpOaWJ5laF6lhcBA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-3ceb4c331faso140363957b3.2
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXeVxc3rVhMfVXUF0r47fjYxAxtcLJDnYTEiZwRT4dc=;
        b=VNcvP+aEUYsGbN3IFLq3IVmltTAEo/bD+6WIPmBAl62/T8uMcpSOC+XENz4LeFikpb
         VpGbYM8kmCWxWgO4xNMXzVNYcLevNR5XA7I9Dyuv4Yp8R3zOXexW3Mo/ptGJgPctO1Xe
         1ESktNkwgD2U0AtyhZngSkzKPyoDYN0aQDcGp0AJg3lKP+Ih42fH4yQlFoIce/Vzu4xQ
         /L+LOK60DL5q2xz1IolANSI7XTBRctkl9v3vnCJWGJJ0kcIQHP32iSskFrzI/DS30wrR
         yRpPvKYoDziaKpOtD3WBNj4GNPKJ4E8UW+2UMzK3KCH1rnzlZQwoLxjBYjyK+f1C59ZH
         FOOA==
X-Gm-Message-State: ANoB5pkwr6drhSbpMAyuExFGpkOW48bPiL7/2pWWYO5bpX2GJHg50oNt
        OEjYu/bLnPsdjAdgME7rFfRK4Mu8QJsZsYzml0nbe384QZYFG6Z73nK5EaJBEkJ5lrIL+0J6eMK
        xrYqGfz25vrc3hRtY
X-Received: by 2002:a05:690c:d8f:b0:3b1:4224:bbeb with SMTP id da15-20020a05690c0d8f00b003b14224bbebmr57324899ywb.39.1671539725346;
        Tue, 20 Dec 2022 04:35:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7i5nIaolVKaHr0wu9mLwWaBDKfWp+bmCIrSLSxQzdn4BnSmRjgi8rNZW6TJIL6+9Qy9/Zbsw==
X-Received: by 2002:a05:690c:d8f:b0:3b1:4224:bbeb with SMTP id da15-20020a05690c0d8f00b003b14224bbebmr57324869ywb.39.1671539725034;
        Tue, 20 Dec 2022 04:35:25 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id l10-20020a37f90a000000b006fcab4da037sm8718367qkj.39.2022.12.20.04.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 04:35:24 -0800 (PST)
Message-ID: <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 20 Dec 2022 13:35:21 +0100
In-Reply-To: <20221218234801.579114-1-jmaxwell37@gmail.com>
References: <20221218234801.579114-1-jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
> these warnings:
> 
> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> .
> .
> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.

If I read correctly, the maximum number of dst that the raw socket can
use this way is limited by the number of packets it allows via the
sndbuf limit, right?

Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
ipvs, seg6?

@DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?

Thanks,

Paolo

