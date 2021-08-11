Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42E3E8B3D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 09:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhHKHuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 03:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbhHKHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 03:50:21 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E038C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 00:49:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so3725413wms.2
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 00:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4XY/aTjpbcQHpatCMtQsIw+yIc8wDpST7+Bco2Irgq0=;
        b=bc6PuQOK9mAqXtYdpkCkcYhzS4gheMtwu0n84WfO4YrT6H3b7thYSaZ9KSUxDakJMe
         OJdQ6idOIQCKtE6tBcOjuVFoTTbptk+tBES7LktyZ7im4GpbDwAxDIkYM/aagmLAUQV+
         knUsHtBIbI77m+tlMFWsO/vh7w/C50CDO9P6PnQdMha65kGut7QP1KntRA1ynwioQJmR
         Pv/GwvxKRZfBDD7xpAg4YabyMN707JOr4wdx8Zfxe1T2Bo9V+2T3+KvXHLcsyPk499IZ
         3qZLbw+CiDooUYmGgkjMR0lEEUXD1H1WCGP/e8qBALZaZ5sicoYuwa9dXnxaMn80quG3
         NnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XY/aTjpbcQHpatCMtQsIw+yIc8wDpST7+Bco2Irgq0=;
        b=Y/DbeOCvEpEolJHfbrwCB4swgz9SjkfvAePyYMsvlhMJG5Sj5qdpKk2dkCW3DpWjo0
         JutgwWw8d8oXyxSBN8C33RTD2NdYcwm9z/dQ+3aTUlUH08gUKgh1B4HPNeuarNWRr7OM
         vJY0kSitClsrRLpmCUWXDKEKnreOgv2vu4IH/94GxMbMoBdMYZplHzuaaioWxW2yUZUF
         KxXX1Pc6O0hSTOd3zw/p/9Mvnk7qzgIGe31XCNZB10bFJqosK/gspovR2tEIrky3FsGv
         YubdQ61Mwz8CLa7ScUw9rwVBNqvfVj3snVGi9mocTPioB9Bp5/R3Hb6EfW9pt/pF32SW
         Fofg==
X-Gm-Message-State: AOAM531T/SMTZGM81YmTQBBPVAkyGOnr8KOEiqsZQPN3F1bCWHuUmWUn
        H2ZvGxoBN/Rw1THA3PKNeP8=
X-Google-Smtp-Source: ABdhPJzr8IoP6sSupDEeSRBV/uZ3/+Sfpiv4ws/DXc06O7KGBvIoFWO376gtZgWM/nMzMvVetZL28g==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr8298671wmc.138.1628668197123;
        Wed, 11 Aug 2021 00:49:57 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.193.81])
        by smtp.gmail.com with ESMTPSA id g4sm755399wrb.18.2021.08.11.00.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 00:49:56 -0700 (PDT)
Subject: Re: [PATCH net] tcp_bbr: fix u32 wrap bug in round logic if
 bbr_init() called after 2B packets
To:     Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Kevin Yang <yyd@google.com>
References: <20210811024056.235161-1-ncardwell@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9dfee38c-1a4a-8c3c-a9ac-20763a9becc7@gmail.com>
Date:   Wed, 11 Aug 2021 09:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811024056.235161-1-ncardwell@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 4:40 AM, Neal Cardwell wrote:
> Currently if BBR congestion control is initialized after more than 2B
> packets have been delivered, depending on the phase of the
> tp->delivered counter the tracking of BBR round trips can get stuck.
> 
> The bug arises because if tp->delivered is between 2^31 and 2^32 at
> the time the BBR congestion control module is initialized, then the
> initialization of bbr->next_rtt_delivered to 0 will cause the logic to
> believe that the end of the round trip is still billions of packets in
> the future. More specifically, the following check will fail
> repeatedly:
> 
>   !before(rs->prior_delivered, bbr->next_rtt_delivered)
> 
> and thus the connection will take up to 2B packets delivered before
> that check will pass and the connection will set:
> 
>   bbr->round_start = 1;
> 
> This could cause many mechanisms in BBR to fail to trigger, for
> example bbr_check_full_bw_reached() would likely never exit STARTUP.
> 
> This bug is 5 years old and has not been observed, and as a practical
> matter this would likely rarely trigger, since it would require
> transferring at least 2B packets, or likely more than 3 terabytes of
> data, before switching congestion control algorithms to BBR.
> 
> This patch is a stable candidate for kernels as far back as v4.9,
> when tcp_bbr.c was added.
> 
> Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Reviewed-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Kevin Yang <yyd@google.com>

Nice catch :(

Reviewed-by: Eric Dumazet <edumazet@google.com>

