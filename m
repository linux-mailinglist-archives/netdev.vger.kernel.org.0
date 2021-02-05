Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471973116D7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBEXQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 18:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhBEK4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:56:43 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30D3C06178B
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:50:01 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w4so5624964wmi.4
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 02:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gxgf2pKwF5iK8gFu7zHpE8SgPOtlyGCClIx/3q4YNbg=;
        b=t1EAmBcST6DjPt3+nkyNJc3oVor2MtinKV4Ob76qYBlvHZ9R1VFxvzGPnQrSW2kVDT
         TsMo4guZfW7g2zlVYaIj9VKSnBgGvh8iFtKljpXXFmCIYqootHZsDYn4ZKJLMnhL3jA0
         txm0UG7q4Wn0cZGYl7giFwiTy5k6uxfx3piJNwXIKXZRdEXrA/wtHr02RWbzyOeT5N3M
         rS/KEBs8I3PLpTaL2iJjW6odQFOwGBnXw6WdDO+MswXhZlJjOFFc8hW6GwSlTrnCCJC3
         JrofzILLyJpnT9iipBO3kw6rd9pRNL3vki2+ZrLPkL6eJVF97trtxNBcO9Aeryr+4eGY
         GSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gxgf2pKwF5iK8gFu7zHpE8SgPOtlyGCClIx/3q4YNbg=;
        b=aQdpSE2B56kWcBxj6F0+isHadJwR5ncp4LgxK412HPMRyDftgJuzG5X7GOmGv4INFM
         3Kvdqxb0wyATLqwNk9hADrUuUL7x3weL+iFVNMOuO2/GyA1fCCcFmWEq1Ud6ZBNsdMtl
         fgP9VkCAjTr9gBBeRMAfx0nrP80WobKbxpo/srr4YL2KiWn10W55plxp/KX++ryBfqBa
         +3rRzV3c1huJaWIyo8DStgiJJ2HSz+sUvFe+1RSGjtc+ANnZjIptDGgM5Ew22+vzLg9e
         EqJAJmAD3UkC7gl0Ca+UqpBDR83EUUw3MsRc6eqhphEFQNrs2uBD2gLY+ExsksdiJeA6
         AD8A==
X-Gm-Message-State: AOAM5323Nw6BptYZhFqqilXSEjWH1YsyvWkTv2JdrgNo6Shbw9y3TgeT
        979IBDohZjWu0XSvSTrDEhk=
X-Google-Smtp-Source: ABdhPJyZooO+s5A2MEoo0sLfl+R3JArj5lj7pL6oYcGFO+0QiO7WmDgmWJV06HPWMPFKy3dzutyNuA==
X-Received: by 2002:a05:600c:2803:: with SMTP id m3mr3068469wmb.86.1612522200822;
        Fri, 05 Feb 2021 02:50:00 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id y14sm11825125wro.58.2021.02.05.02.49.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:50:00 -0800 (PST)
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in
 napi->rx_list
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>
References: <20210204213146.4192368-1-eric.dumazet@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <c09204f5-4e00-7375-2a22-e09c61b5db49@gmail.com>
Date:   Fri, 5 Feb 2021 10:49:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210204213146.4192368-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/02/2021 21:31, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
> listified RX cooperation") had the unfortunate effect of adding
> latencies in common workloads.
> 
> Before the patch, GRO packets were immediately passed to
> upper stacks.
> 
> After the patch, we can accumulate quite a lot of GRO
> packets (depdending on NAPI budget).
> 
> My fix is counting in napi->rx_count number of segments
> instead of number of logical packets.
> 
> Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and listified RX cooperation")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Bisected-by: John Sperbeck <jsperbeck@google.com>
> Tested-by: Jian Yang <jianyang@google.com>
> Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
> Cc: Alexander Lobakin <alobakin@dlink.ru>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Edward Cree <ecree@solarflare.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
