Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACB3508884
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 14:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378640AbiDTMzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 08:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiDTMzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 08:55:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F20833E1A;
        Wed, 20 Apr 2022 05:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 224DBB81EEB;
        Wed, 20 Apr 2022 12:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E3CC385A1;
        Wed, 20 Apr 2022 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650459184;
        bh=QIM/aydJjFoGCSHbzCqxueIZW063tAPoMj10MjY/4a8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=apVzFx6m4Zqgr4EyJ/a/snLw9kTCfUU1QJr7O0rTXk8GxR/FErdnnmx+LIfAkJKJO
         6N0gxtE0xKMXQYLiCeJLwu9b2GXJ6HWFSjjin7YPwscYxdU7Trp+NiZgx+IODFmrIh
         ZT1LbMCMohtADTBOgxSc7RyDZL6bBWa4JyR2O3Kfw0FB5BZF9q96ycrDW12cK8WUAZ
         fd9nkW0NiBFpyk665Hc1e1uMKbYdWH0c0bUkFMvIl1x/se6IGtr+LsSPjH/9jnt4f9
         ZeeWeluuqyRZ0weAqiRgyqKlR3PAsXBDrWUVkyIN5JhKwP6EKFB4URHClHMehRbkiq
         5u8HIV8cr/uNg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6EEF72D1C15; Wed, 20 Apr 2022 14:53:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
In-Reply-To: <20220420122307.5290-1-xiangxia.m.yue@gmail.com>
References: <20220420122307.5290-1-xiangxia.m.yue@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Apr 2022 14:53:01 +0200
Message-ID: <878rrzj4r6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xiangxia.m.yue@gmail.com writes:

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch introduce a new bpf_ktime_get_real_ns helper, which may
> help us to measure the skb latency in the ingress/forwarding path:
>
> HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_update_recv_tstamps
>
> * Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this helper.
>   Then we can inspect how long time elapsed since HW/SW.
> * If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recvmsg,
>   we can measure how much latency skb in tcp receive queue. The reason for
>   this can be application fetch the TCP messages too late.

Why not just use one of the existing ktime helpers and also add a BPF
probe to set the initial timestamp instead of relying on skb->tstamp?

-Toke
