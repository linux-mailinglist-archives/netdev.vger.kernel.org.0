Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D794B8D0C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiBPP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:58:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiBPP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:58:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0AE2722C3;
        Wed, 16 Feb 2022 07:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAB5A61A5A;
        Wed, 16 Feb 2022 15:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0764BC340EC;
        Wed, 16 Feb 2022 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645027103;
        bh=DWjFTIOayBawynWs+tf5zyrCvJcGObtREzTRWe6rd3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OjqRP1auFsX8Hbjr2QUZt1jmjTqjMiVT41fdtRQR6plyGaD7x3sQW8oiIYqdh/DNK
         ch+eRKUJgYSc/94n5OlKcYGpTAwtW4E/nGvBqqp63XcIlORRNvDW0ubBW2WdE8EHJn
         RaqhVtXI8ShrPYwSB3WC5puTTVSiXPtDR7H4TbNQBiXzA2zAz2gz9nqzDK/WDpwGqs
         0x2dALLWOT4xDVKwfxEJPxmqUmI78XY3A4N8Puchu1gmEEyR/uFdw3/F0FruLwWUqO
         WFoB1OdYErXv4rVrKpMm6SNSkwdzcs+u82AFJo2lfJ06jpQh/chjeSpvAMB/SvrDgm
         Zo53i/I0XoJJQ==
Date:   Wed, 16 Feb 2022 07:58:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, edumazet@google.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: Re: [PATCH net-next 1/9] net: tcp: introduce tcp_drop_reason()
Message-ID: <20220216075821.219b911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216035426.2233808-2-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
        <20220216035426.2233808-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 11:54:18 +0800 menglong8.dong@gmail.com wrote:
> +static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
> +{
> +	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
>  }

Please make this non-inline. The compiler will inline it anyway, and 
if it's a static inline compiler will not warn us that it should be
removed once all callers are gone.
