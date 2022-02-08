Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1ED44AD01F
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiBHEHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiBHEHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:07:16 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDECC0401E8
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:07:16 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso1388437pjm.4
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qTDLiPbzU1xKerCjUYOwfyrsWHG+Y1FFgo+5qRgapmw=;
        b=KGjJ4neCb27UwezYpTR54BIZmsygztWQv2iOuVBIwssLUiYVJ4A2MFjvWCSC3/Y6xH
         Xv7qT59Urnr7PAruFukF2U5zkf29koJVj7q/yrdzZQmQz1lyrp0IvBM6ogcS2Dwv3Ibj
         j3i6Og/aYcJbDJs8yU8Vgwkw31SnjmBSOf43UeuoEPUcaerGwbPMXRWw7sxdfFPh4BOU
         D9moH9S3XieJxhuByigbaE8W4QI93BEEroSrPmdKpLl8WOA0ChojqOnJGsQTYX9BKDdV
         3Rqtpdjfz+SJ53MIrWOuWyiiroEGchdR0oyUcfzFPyogKreAlGecj4yibPzRpwnVP4L/
         heCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qTDLiPbzU1xKerCjUYOwfyrsWHG+Y1FFgo+5qRgapmw=;
        b=p/iV5lthq6US/0jHtnFDQ9KrAtFiZ/m28KIOjIzvjnpGI5BL5CE7Dj0py54vw7gNba
         giCwjs2zsNvxQREcEpin+mFI4BnlrkWK+PvAQuX1++yzWEZuqvmNuJCgpL85MgCcCMPH
         5IdJGppJjZvzkUXOBsVARos7ExtJancs1HCIipIwKTYQC6btm2x4iM7sQ6cN7UAfJn9s
         DZ8hpiYbwmBHLHCb/dOdl5Zevryr9b1Wzs7L4Uy2+yp8J2JxLytql59871UHz3uV/43E
         gGKWqSQCYy5ieGGZZ243NRbUgKyTwOZN8BsRnu26tEnCVlxb6USIgkf+cxk8ugzRxEWu
         Ff7A==
X-Gm-Message-State: AOAM533Vbsx90WvR6C2gTAW5yBw331hVVlVMBOaFvzdbu5i9W2N0pD7x
        ZBwlPw7JFNtlFNlwe/wPrCo=
X-Google-Smtp-Source: ABdhPJwXtwO/E7HedqLjChybtWRIYmwLVD74GSFS+05y8Z0V+KWa5Og6LYPCmdGbshp9F7WSSbHAlw==
X-Received: by 2002:a17:90a:2f01:: with SMTP id s1mr2386627pjd.8.1644293235768;
        Mon, 07 Feb 2022 20:07:15 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id j14sm14031295pfj.218.2022.02.07.20.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:07:15 -0800 (PST)
Message-ID: <20c1daa9-faa9-56c7-7dd0-5cd060dcc000@gmail.com>
Date:   Mon, 7 Feb 2022 20:07:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 02/11] ipv6/addrconf: use one delayed work per
 netns
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Next step for using per netns inet6_addr_lst
> is to have per netns work item to ultimately
> call addrconf_verify_rtnl() and addrconf_verify()
> with a new 'struct net*' argument.
> 
> Everything is still using the global inet6_addr_lst[] table.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/netns/ipv6.h |  1 +
>  net/ipv6/addrconf.c      | 44 ++++++++++++++++++++++------------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

