Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C156B276CDD
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgIXJOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgIXJOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:14:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78493C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:14:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so2533361ioj.7
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qGll8anFgabu9SgSUtRUD4y6piH7B5UjT8DgkcAWMe8=;
        b=ako3uV+A896agrotC3u/EKdpVly8oNii2OKSaaDaeRRHWTph4+NBG+8S79hqhAnZit
         JiGC4aGbTv/sP/ZZVMriWi0e9/SET1AifLf4JmPUZRFQ+87wATnCwG3tyQSUBCLHHQsm
         VlOFq/mWjgoQRhl6lfJa4n4mt4Mgm4Hn1ZAbSMnvjtEBwq3AeSWb4RBi6WowUMUj/UtO
         1iIJqLX12Eua6Fwg135GFy962y4svex8Z6/vj30cklLjl39AOjqtlbwersWsBwKHhJb7
         +sj7JajJcTU0ivS4iqWH/rTA+qE22O1YVV7T+cVnoZ1Yd7rEMwZRQ+waLOvXTP88qO2P
         RTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qGll8anFgabu9SgSUtRUD4y6piH7B5UjT8DgkcAWMe8=;
        b=UarnxLMdwXLpLbbKUyvT4EFH7t5NpZhawKSgteGxABgG7SorYR6+YQ09SwLzcjfo54
         MqDqqiXjSitzwyeVPeuUeQzHQssHOoZN1VCT2uRrbNJ4VilEgzvRms0ausu21Y5Glcgr
         SUO1oLBXWIlZwbdKr1QH8mEeP0sy5Xg+Bnqv7kZzyUIUrJ8iNBkAsjWbHkrue1UwGHg4
         y02YuquDop6F6ZVxFsMcbJqZL2e4VDd+KDyfXneOS8atSIEl29Ee46zaqR6RZNRKpmXJ
         sm9MY7mUyd0tKRPrGREsIC5et0kaCGShAcLblkX9cdpjOCT/Mnaz8hsZJkB1RIZhmsFQ
         7plg==
X-Gm-Message-State: AOAM5320Q2SD7cdYk2mFp6vlgXxAIIUEL71jHeiohMskMvkoNX/fiCsi
        w+KAuBy5XPfLoqjIYadfPsygi91dToq4yygMorYNWw==
X-Google-Smtp-Source: ABdhPJzWZH/O/TirsOHJcvn+pPOehqTDQ7mrg5HF5DaMKWQNGHOfgf+XFAhTsDaimIHLF5wt8EFRR+sWxqjReF7ZN7E=
X-Received: by 2002:a02:cd2e:: with SMTP id h14mr2873315jaq.6.1600938872437;
 Thu, 24 Sep 2020 02:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com> <20200923201815.388347-1-zenczykowski@gmail.com>
In-Reply-To: <20200923201815.388347-1-zenczykowski@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 24 Sep 2020 11:14:21 +0200
Message-ID: <CANn89iLO3ktHHX1XK1-Mqva1xoW2OjVs_gFpZoQsGN2yVM3Qag@mail.gmail.com>
Subject: Re: [PATCH v3] net/ipv4: always honour route mtu during forwarding
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:18 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Documentation/networking/ip-sysctl.txt:46 says:
>   ip_forward_use_pmtu - BOOLEAN
>     By default we don't trust protocol path MTUs while forwarding
>     because they could be easily forged and can lead to unwanted
>     fragmentation by the router.
>     You only need to enable this if you have user-space software
>     which tries to discover path mtus by itself and depends on the
>     kernel honoring this information. This is normally not the case.
>     Default: 0 (disabled)
>     Possible values:
>     0 - disabled
>     1 - enabled
>
>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
