Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED066C40C2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCVDEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCVDEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:04:16 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7F24A1C9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:03:38 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id r7so11729892uaj.2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679454217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r923tmky+Or87URCH2ORyZ/XiYnMw/0DLU02Ha3v5Ho=;
        b=CogqSsEoSvYg15Spcoe44fXPROX+Z77cmOTrGKARvsaGdS33Us4HGO4+cEVLY8vNmt
         CqGnS54hG/6Z2y0vFe9gXLGUFt9/uodCDq97bCH4OVa41KCn5PrvH2bKFop7sY0UGrAO
         xO3c8s5BFG1fH7xvihXR1HKrJBYuGxsGLtw6g3u8OA4n7Ds8Uk/odMzuvjV03A9UkK35
         Cn50wz4UWYV9HaSPzkL9+P3vUGpCb8AvBT//btNj7qnKos4kni9QXmRBLcbiqTsL/Rb3
         tDrOjNFOUdf8Hp6TAgxBhVvswg66qGQEICs/p9qIqrECh39NbUUyGMUOtTGIqp0ZJ3PH
         Vt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679454217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r923tmky+Or87URCH2ORyZ/XiYnMw/0DLU02Ha3v5Ho=;
        b=mp4V0HUTrBwSdAcJ//uD7VgtoXXe3TZ06bhm44KYRvcnbQnSWzIJYF7TRtwWekifTX
         Z0avNvHD9TXflloWXXBZmVW+0RrQSe5DLKMpUbdxw8+N27GkgDVKaWDQ97R/h5qRaGhJ
         DTiKXAw1ytS9oVjYyG9GRP83CxVr5hbdgEb27bloSWwFgRJDuulCmk8V5v3hk4WLXsIS
         pQ2GsMZIZKYb5TsMCl5l/n3tx198w1LMBVSWaRDE0QaBP5oJbUqAsSPGRh57LPjNNYmz
         F7YMujTVYg9zD/4Excz5PFKi+nZ9SSyBLSFzlj4sZj4e742IxGPSKfVTczw06l6PLXF7
         PcHA==
X-Gm-Message-State: AO0yUKWM6T8KbieqwUccC3cipxRtBBRDrbeXnLSSmPUHeElJojaMyRj7
        ms4ycr0Y+VYhp+SQSd1MbayxJs5CRQbwJBi0rckqHQ==
X-Google-Smtp-Source: AK7set92BaTy26bgUW0vnl5gn3fxULhsoO0Sl6MyB8slxOo+g7YwR316dUa/tT9AULGa6wFFxy/JDL+OYF/GDmUv6sc=
X-Received: by 2002:a1f:aad7:0:b0:42d:7181:7c63 with SMTP id
 t206-20020a1faad7000000b0042d71817c63mr2593170vke.1.1679454216600; Tue, 21
 Mar 2023 20:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <202303212012296834902@zte.com.cn>
In-Reply-To: <202303212012296834902@zte.com.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 20:03:24 -0700
Message-ID: <CANn89iJb3k2kqZX9KQ-1tmw1L9Y0Lw4ksPRTeN97znS5Y3SJ4w@mail.gmail.com>
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
To:     yang.yang29@zte.com.cn
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        xu.xin16@zte.com.cn, jiang.xuexin@zte.com.cn,
        zhang.yunkai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 5:12=E2=80=AFAM <yang.yang29@zte.com.cn> wrote:
>
> From: xu xin <xu.xin16@zte.com.cn>
>
> In the RPS procedure of NAPI receiving, regardless of whether the
> rps-calculated CPU of the skb equals to the currently processing CPU, RPS
> will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
> which will trigger a new NET_RX softirq.
>
> Actually, it's not necessary to enqueue it to backlog when rps-calculated
> CPU id equals to the current processing CPU, and we can call
> __netif_receive_skb or __netif_receive_skb_list to process the skb direct=
ly.
> The benefit is that it can reduce the number of softirqs of NET_RX and re=
duce
> the processing delay of skb.
>
> The measured result shows the patch brings 50% reduction of NET_RX softir=
qs.
> The test was done on the QEMU environment with two-core CPU by iperf3.
> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;


Current behavior is not an accident, this was a deliberate choice.

RPS was really for non multi queue devices.

Idea was to dequeue all packets and queue them on various cpu queues,
then at the end of napi->poll(), process 'our' packets.

This is how latencies were kept small (not head of line blocking)

Reducing the number of NET_RX softirqs is probably not changing performance=
.
