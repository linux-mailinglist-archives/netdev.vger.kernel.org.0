Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22764C0455
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiBVWJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbiBVWJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:09:07 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCD7B23B8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:08:41 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2d6923bca1aso182127177b3.9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ix8P1zCQOkqH4yOfx2mWtkmJTfSxXuC1fGPUTTMshpA=;
        b=jhwwbo55zmdXKAX3aQCVNxLJGU0WsV6kulGdI5jdE58gJz6Xq7W7aAP4dnW6LrjXVZ
         20Z+kvkTlFUXgvth2hfgBpNkJczQB8qLlL2DvkqlH7fxkfYLB6NWZJ5OFDwjkhVVZIKu
         pqyWXLeY+HTxOxxnpug18DeoWxPuPN+FbYuqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ix8P1zCQOkqH4yOfx2mWtkmJTfSxXuC1fGPUTTMshpA=;
        b=2qAYOnElKlP7DxBGIecKj4RJf8SsrMjQMYlsFVZNAWbfgkERrfaZGHE/Bf2TrGNrp7
         0myjqCPXg+x348sal+sUtPi/6qkyFNbGjskDzhNfT75+LDLn+t/7khIJjnYcNfzOfMAF
         j3ohD+z5u/7MxUXm/NYMOXw1AXcQLUb+kH+t0VNaxaeUJhM2gZKXB0IQ7ZW/9Ju1UChw
         TatRroZwxF4gE9zI1mgahBpudZvquxVcxTN3eqcDwzp6+BAwj3YSEPOfu2l9QAK460W7
         zrGQNBcL/TTuL8HZVPYHcjH7i0CI3TaWZINR2tl8CQKtvCK1Z/eUbaJmvBUmKL+vVlni
         +2hw==
X-Gm-Message-State: AOAM531h75YTs+XE9EebpYgfejA3Qk9jrNPuvyvMbdVLdppz2NpsHMe4
        rGdayfQ47qSYThVEYlt4UPlnXUbmTdzWwK5m7GV2iHtxpECXYw==
X-Google-Smtp-Source: ABdhPJwVFp6EZqicUecvPkT5zgSnYXoVp3AHjfHDvP7sQSOueMlgphSFLHuI3iyqbLU7I0cDHKcvTzCIGjNp2igksuU=
X-Received: by 2002:a81:92c9:0:b0:2d2:cbb8:8aa3 with SMTP id
 j192-20020a8192c9000000b002d2cbb88aa3mr25464928ywg.494.1645567720680; Tue, 22
 Feb 2022 14:08:40 -0800 (PST)
MIME-Version: 1.0
From:   Matthew Oswalt <moswalt@cloudflare.com>
Date:   Tue, 22 Feb 2022 17:08:30 -0500
Message-ID: <CAKrN56vUv_WDHu8AK_J5mxEHq3tWpmMQ5zmN2NwPxfRtObZHnQ@mail.gmail.com>
Subject: Historical reason for differences in v4/v6 Any-IP for nonlocal binds
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'm working with binding TCP sockets to nonlocal addresses (not
configured on an interface). I noticed that both IPv4 and IPv6 sockets
will succeed using options like IP_FREEBIND, but unlike IPv6, sockets
using IPv4 can also succeed if a matching Any-IP route is present,
without configuring any options or sysctl settings.

I noticed an old email in this mailing list that also describes this behavior:
https://lore.kernel.org/netdev/CAMdqG7Wci6HD19rc9u4RK-_Wdh3pqQvQ7b3J5O=2SJs9NeyTJA@mail.gmail.com/

I'm running a somewhat recent kernel (5.10) and my testing shows
identical results using TCP as well, so I believe this is still true.
For IPv4 sockets, either the presence of a matching Any-IP route,
**or** setting IP_FREEBIND (etc), results in a successful bind() to a
nonlocal address. However, with IPv6, it doesn't appear to matter
whether or not an Any-IP route is present. For these to succeed, an
option like IP_FREEBIND **must** be set (or
ipv6.sysctl.ip_nonlocal_bind, or IP_TRANSPARENT I believe would also
work).

After looking through "net/af_inet6.c" a bit, it seems obvious that
this is intended behavior. I believe I'm able to follow that bit of
the kernel code and understand how the decision is made.

However, is there any historical reason for this discrepancy? Why does
the IPv4 implementation perform a FIB lookup and allow a bind to
proceed if an Any-IP route is found, but the IPv6 implementation
doesn't? I'm really just curious if there is a specific reason why
this aspect of the IPv4 implementation wasn't brought over to the IPv6
implementation, or if it was just left out in favor of the more
explicit approach via options like IP_FREEBIND, or any other reason I
could be missing.

Thanks,

Matt Oswalt
