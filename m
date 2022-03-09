Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657ED4D37B5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiCIQgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbiCIQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:23 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538F7195300
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:25:46 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id b12so2406424qvk.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KhUHOxH3TVkg1oL6+sgIw9Yjx/KJiYaJ9b23Nx6yhHM=;
        b=a/KwrIQhyIY8fG4uI8xSX99420l5Iq4Usm5tw71yJcLsbaLqtS/YgpHs76UEuRCq4e
         gvBRjXTCU/vi0iOrarRBmmGtD9YlOVSApq9MJlD1TsFiyLKYP4qAntiPZWK7Cu6yH+r2
         Mlt5cUMzpIyqXz2zyUXkaILAB/Pw2JmU6tWBHNhwdjpvVzqMS3pc9ov1EZJfPz1f7szq
         dLPiv6EHz4KxtX5QcEuYfub/3M8Xsd9+fP9Z6t/+OtmZhTa5V2c3nPv3yJRUUJpeAkCp
         OtlH+KoIDvGbtVVpSwUlstl/BkodrLEtZDkrsfbU6OzfizH/QphrIcWZajQ1WG+FEZGV
         KVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KhUHOxH3TVkg1oL6+sgIw9Yjx/KJiYaJ9b23Nx6yhHM=;
        b=ySBOPo6o3QorFJ3+286CAhkIfGZX5eFbBRE5B1a+yHRNYejCeZhR2G8jtlpRq6BALp
         0NZEYz5YKy5LDT4m1qcIMr0buCIz5QE51K1WiJ+0sYnc26DfaJoyohfgQdv2b9Sbrbm0
         3f6OjPMwaQQB8EzOehalcGbRJKCkhYRrosBVR7VYJtyIbTft3R6RmCtpjk6htTGa/OIS
         yVYo0PhZ0Cx1Yxrc4cnpmcGbDotskUiC2rwOC++WyFJFTslDxBokzigScdiwpx05G3Fm
         IYI+igZrD+TW/oRfkg0CqVmDZtnYxsMJ8sWbMDuqvBgI5U7H6XdVKu+URuoioLTrOgB6
         dj8A==
X-Gm-Message-State: AOAM532QSU/FDR+0WLcz4z6UtYyglZngir5huYEF+ZKpTEPZUAhz7GNG
        8Jma7N4y2lz+zbiE8ZoIvMWEYx0UsrPd971/MCDeFw==
X-Google-Smtp-Source: ABdhPJyc0NxLElJkSpB8BUB2hM38Sdn7GgdWs+UuoKD3LfYAQD0vBycKKZc4vTXabsyTqSkxL4OCshyPI8l0LdlOAns=
X-Received: by 2002:a05:6214:2623:b0:435:a50f:7e89 with SMTP id
 gv3-20020a056214262300b00435a50f7e89mr429657qvb.62.1646843144189; Wed, 09 Mar
 2022 08:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20220309015757.2532973-1-eric.dumazet@gmail.com>
In-Reply-To: <20220309015757.2532973-1-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 9 Mar 2022 11:25:28 -0500
Message-ID: <CADVnQyngH=CW_RLXQHiLbii6-zDeCKYP05zP=cta95KVoaF4ng@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: adjust TSO packet sizes based on min_rtt
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 8:58 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Back when tcp_tso_autosize() and TCP pacing were introduced,
> our focus was really to reduce burst sizes for long distance
> flows.
>
> The simple heuristic of using sk_pacing_rate/1024 has worked
> well, but can lead to too small packets for hosts in the same
> rack/cluster, when thousands of flows compete for the bottleneck.
>
> Neal Cardwell had the idea of making the TSO burst size
> a function of both sk_pacing_rate and tcp_min_rtt()
>
> Indeed, for local flows, sending bigger bursts is better
> to reduce cpu costs, as occasional losses can be repaired
> quite fast.
>
> This patch is based on Neal Cardwell implementation
> done more than two years ago.
> bbr is adjusting max_pacing_rate based on measured bandwidth,
> while cubic would over estimate max_pacing_rate.
>
> /proc/sys/net/ipv4/tcp_tso_rtt_log can be used to tune or disable
> this new feature, in logarithmic steps.
>
> Tested:
>
> 100Gbit NIC, two hosts in the same rack, 4K MTU.
> 600 flows rate-limited to 20000000 bytes per second.
>
> Before patch: (TSO sizes would be limited to 20000000/1024/4096 -> 4 segments per TSO)
>
> ~# echo 0 >/proc/sys/net/ipv4/tcp_tso_rtt_log
> ~# nstat -n;perf stat ./super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000;nstat|egrep "TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
>   96005
>
>  Performance counter stats for './super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000':
>
>          65,945.29 msec task-clock                #    2.845 CPUs utilized
>          1,314,632      context-switches          # 19935.279 M/sec
>              5,292      cpu-migrations            #   80.249 M/sec
>            940,641      page-faults               # 14264.023 M/sec
>    201,117,030,926      cycles                    # 3049769.216 GHz                   (83.45%)
>     17,699,435,405      stalled-cycles-frontend   #    8.80% frontend cycles idle     (83.48%)
>    136,584,015,071      stalled-cycles-backend    #   67.91% backend cycles idle      (83.44%)
>     53,809,530,436      instructions              #    0.27  insn per cycle
>                                                   #    2.54  stalled cycles per insn  (83.36%)
>      9,062,315,523      branches                  # 137422329.563 M/sec               (83.22%)
>        153,008,621      branch-misses             #    1.69% of all branches          (83.32%)
>
>       23.182970846 seconds time elapsed
>
> TcpInSegs                       15648792           0.0
> TcpOutSegs                      58659110           0.0  # Average of 3.7 4K segments per TSO packet
> TcpExtTCPDelivered              58654791           0.0
> TcpExtTCPDeliveredCE            19                 0.0
>
> After patch:
>
> ~# echo 9 >/proc/sys/net/ipv4/tcp_tso_rtt_log
> ~# nstat -n;perf stat ./super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000;nstat|egrep "TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
>   96046
>
>  Performance counter stats for './super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000':
>
>          48,982.58 msec task-clock                #    2.104 CPUs utilized
>            186,014      context-switches          # 3797.599 M/sec
>              3,109      cpu-migrations            #   63.472 M/sec
>            941,180      page-faults               # 19214.814 M/sec
>    153,459,763,868      cycles                    # 3132982.807 GHz                   (83.56%)
>     12,069,861,356      stalled-cycles-frontend   #    7.87% frontend cycles idle     (83.32%)
>    120,485,917,953      stalled-cycles-backend    #   78.51% backend cycles idle      (83.24%)
>     36,803,672,106      instructions              #    0.24  insn per cycle
>                                                   #    3.27  stalled cycles per insn  (83.18%)
>      5,947,266,275      branches                  # 121417383.427 M/sec               (83.64%)
>         87,984,616      branch-misses             #    1.48% of all branches          (83.43%)
>
>       23.281200256 seconds time elapsed
>
> TcpInSegs                       1434706            0.0
> TcpOutSegs                      58883378           0.0  # Average of 41 4K segments per TSO packet
> TcpExtTCPDelivered              58878971           0.0
> TcpExtTCPDeliveredCE            9664               0.0
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Thanks, Eric!

Reviewed-by: Neal Cardwell <ncardwell@google.com>

neal
