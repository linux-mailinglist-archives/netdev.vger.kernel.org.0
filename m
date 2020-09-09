Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A002F263428
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgIIRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbgIIP3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:29:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FD9C0612F6
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 07:39:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so3223467wrp.8
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=11MI0KiTsfDovJmHLIZ6mGMd2aO/GNiEEd0QOHNHXg0=;
        b=Yc1/H8efLlur4NsZLckZuVxVv7eBKW+pOWMidUFk8KtU0BAoPVPXWk16J5mKnNrmIi
         oWB20T+Z2wVlAeFQT3uhLlx8nm1qKbo+/rKT870Cni1Y1rvHVkbmASg+/AfCDUB8dHFb
         TLVHSYXSJi6UFU0cTS/U9tEbHBhBLAjxYjnFM7MYgQNxIJtG4KvvC38iEKyftKrY9H+1
         HSx0E0vxEPJhDXm3VLoD5HTSk56PQ8Z3oow2H9NPpBHJXjDQQLsyXgx6lPJRPrPZoIQc
         adu/KyZfOH0QEy/Tx3fMUNsu8auumg3t/aka3gUOr2/dPsvtlMe+R4Te4NvYpDU6Qx1s
         Hzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=11MI0KiTsfDovJmHLIZ6mGMd2aO/GNiEEd0QOHNHXg0=;
        b=GcFETaE3VkwypQSLErhxPWhTNc+AXgUW6kriNKXb353S1YnFb/zL9fWe9Xzqs9Ns0O
         iRCGYmaEnvuKWOBC6R47MPZC9OXXkwyvxUYlMMMGBc8vGXA1+c/l38PgjTFa/XfzFxwQ
         UzbQ93vczBxmF+v3n4b12rqpGR8KHpznJUVwFb+Bm6EkWJUGqWTWvS2m4FABVtbe/85+
         115VJnrSuXQj6LnNaDFgpkn5JuGATh5zonz3CerpMNdOMcYtmSYNsQLO6m8U4MW8+eUP
         Xto4B0wFtqfR1EUN9q1mkYQajrIWfCE+s5QroxTnRH53PzPvWt/LJwiKJWhVm0HLwlOh
         DcYA==
X-Gm-Message-State: AOAM530bPDcw3hxtkJgwGHdAQA/aXNRR0ONSdj3l6gmrjXvAiEbaUuEQ
        M1tYWbRqLHJlI+sPSkmzsN15kg==
X-Google-Smtp-Source: ABdhPJwg4KZor8Ulp7aL3kakuSHdnlGpdMIVAnOUc1hsbL6VzzEtJVLgSQ4Wqa+k6cfbfZJG5X8vFw==
X-Received: by 2002:adf:edcc:: with SMTP id v12mr4240797wro.240.1599662396424;
        Wed, 09 Sep 2020 07:39:56 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:8ddf:bedd:580e:7a7e])
        by smtp.gmail.com with ESMTPSA id z15sm4368511wrv.94.2020.09.09.07.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 07:39:55 -0700 (PDT)
Subject: Re: [MPTCP][PATCH v2 net 2/2] mptcp: fix subflow's remote_id issues
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <cover.1599532593.git.geliangtang@gmail.com>
 <0127c08400bdf65c03438b0b6e90e4ab72ea1576.1599532593.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <4c6c23fc-f493-ce9e-953f-679109de5fc8@tessares.net>
Date:   Wed, 9 Sep 2020 16:39:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0127c08400bdf65c03438b0b6e90e4ab72ea1576.1599532593.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 08/09/2020 04:49, Geliang Tang wrote:
> This patch set the init remote_id to zero, otherwise it will be a random
> number.
> 
> Then it added the missing subflow's remote_id setting code both in
> __mptcp_subflow_connect and in subflow_ulp_clone.
> 
> Fixes: 01cacb00b35cb ("mptcp: add netlink-based PM")
> Fixes: ec3edaa7ca6ce ("mptcp: Add handling of outgoing MP_JOIN requests")
> Fixes: f296234c98a8f ("mptcp: Add handling of incoming MP_JOIN requests")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Thank you for the v2!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
