Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1D57BC78
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiGTRSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiGTRSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:18:09 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89D73AB3B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:18:08 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id r3so33227023ybr.6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0NKwUkKhLpDJ89pFR/kJhRuG7dRvrqabdF/S9pgOpA=;
        b=iDH+CkNDY6tZ/P5Ki6ePqyML5P2DDQlRUzWDrzEQTFr4kxqxMBZCZHheojKG03L7ww
         DAv2WGW+a0FZnxa7eaAE0+FNX+l2hunK+CAQyXd9C3Uc8C6xBwHdNkts0gaMCY8Fokdo
         M0jedbAi3Smu95UEL+e+Vh4GV8COU9X0fyHcPmAkJWaqasQNWQJgvpvAAX0SDwl9pvP9
         hxtD8U6mgex0QXhaElwsUmrBnEoICdnRvStUiz220m01yusqcCoAV7UHu9m0TEk2og7J
         MIHGVk3KnzKVp9Pw3DHd3PrpAzCOJ7qOYJ2m3/wn0DNFSFiByGiDO7dbDPKHAyUU6cQZ
         Lqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0NKwUkKhLpDJ89pFR/kJhRuG7dRvrqabdF/S9pgOpA=;
        b=owUlG81aat17JhZOZRKkM6AhfETxbvMEqJCbPV0c85Ywwiu/tYHuVWS+Ebqmp3GFol
         FV4QgbKN62NM6oUDb6lcXP9hOcqACRyhyl2lFU+vJX6fvrMqHSeH5K9xG9Fxg1tEBUwJ
         8jNI90Buf4dQnkK6Yz5mWnRN0bbRMMo2yisKwx8xWHDgpBLMQMTtrONaKWYEGx4CiuhY
         wvh9cgBWfvqF9CiroCxuA3Txxt87CDsGwC3yZLapAST1U3e1xmQk9irYHeAd9UQdwbuj
         ltfBWlk0s3steEKa3bq+gGPPvXn+yD0hEfMQvGt5VyVI+Ny3GjnuU7V10a6zRfb5QnLZ
         kfTA==
X-Gm-Message-State: AJIora+XcfS2c6+7Z1LO4lMiYp4elI7AQnA2fYXykH75s+HIU3HSYvcL
        Ulbd9gDAL7cVmJ0/IqPih+xT79UranmzEoioT5pBeg==
X-Google-Smtp-Source: AGRyM1vfGKvmSxBLPOihMklPbn9jzRm2RpoGKYR04kNYCdntKhHuN43iGE3An+AC04hYdSN1LBnTuorjf5o6MxBLMxU=
X-Received: by 2002:a25:8142:0:b0:670:7a16:7b73 with SMTP id
 j2-20020a258142000000b006707a167b73mr10402178ybm.427.1658337487805; Wed, 20
 Jul 2022 10:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220720165026.59712-1-kuniyu@amazon.com>
In-Reply-To: <20220720165026.59712-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Jul 2022 19:17:56 +0200
Message-ID: <CANn89iLv=EhezXA6Yo4GXeW_kBMWKVsgkRy+-kDiSa4nsRtXcw@mail.gmail.com>
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 5).
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 6:53 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> This series fixes data-races around 15 knobs after tcp_dsack in
> ipv4_net_table.
>
> tcp_tso_win_divisor was skipped because it already uses READ_ONCE().
>
> So, the final round for ipv4_net_table will start with tcp_pacing_ss_ratio.
>
>

For the series:

Reviewed-by: Eric Dumazet <edumazet@google.com>
