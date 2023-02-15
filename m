Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6327697833
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjBOIcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjBOIcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:32:14 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F1746AD
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:32:13 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5258f66721bso250761757b3.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MFyZbQgg8pfxI0qwAA9a8AtTHvC/vhifdeN5KHrOyZM=;
        b=R8vIkdl+3nfQ/Oho0SO5mx+z3m+22+WEn4E+Um6zxBgmz0j3dnaPyd34RyUZSwI79r
         xKbe3/G/GSHM6cUACtL20WKW9xjnuFDf8D9bFBpnPBIrZrNvwM18hMYh4IfL1udVMdbC
         +oQq9gRdSSL1lWiGX2kV8d/Oq1uu9FAAh5nFQ/DzVglbAXLeCwSQnbg+9pqaCooFMjeY
         wsZ2MFjmCeRCuZo0sqxz42DBreGP//wIxbyD6ZfIxdh85/9X6cELzcMlV9tYFO2QHf65
         aBECTghJtHKsaViZ3i3ZvwcU8a/JEUKUn9ihFnRv7U921hUwqH30ENmWvJ97KXHdkZQ2
         rvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFyZbQgg8pfxI0qwAA9a8AtTHvC/vhifdeN5KHrOyZM=;
        b=vmZ3zvExWYfhteqp2rnt7U8c+RfQBYCPCB5zVI4JkKlB+gEuiAu426SP7UO0Bj0AWT
         nHb3LQpSRsd5hFBV7USoODWo4i07D/7eyQ8bYqxiVZxO8+vqtiKRQE8/WK7ft0qdNPKM
         Z+G4jdVSZJWIbv+WMHJPxr9ugzLEzX4BECdzjVlqBjjxJxbaZgYq+3lfFXhCA35co0ZA
         nzeb4PbjWy7CrU3L0Qrm80RXIliM19vccwHh0DbW6/v5zYAOHSsyDdzXcJfOA0QjP4GH
         5SNxkzjx2ACil9ZFKV/dh15cKoTUEpbuwxrJ4lQ8d9fl7vRMwCsuvS1UQlZKXe5SaCQW
         4CUw==
X-Gm-Message-State: AO0yUKVZSsi7uOl/+SNMmWr7RWrDN7v0tLPhZQbk/VnRGmtJetjwxiA6
        FYmSzSZYLmsxEJc+7s+9fvagpKcPXTUR+wj6Z65KWg==
X-Google-Smtp-Source: AK7set9aGgHs/wMr6Ia6P+bYGzFzZ2XzjzpEdAR0XBD1H5LD7PS4GKbI8TenXAa/qFgUTe15qTFZtJ2a/jyXJj65pEI=
X-Received: by 2002:a81:6555:0:b0:52e:ca4a:746b with SMTP id
 z82-20020a816555000000b0052eca4a746bmr178277ywb.436.1676449932266; Wed, 15
 Feb 2023 00:32:12 -0800 (PST)
MIME-Version: 1.0
References: <20230215072046.4000-1-quic_yingangl@quicinc.com>
In-Reply-To: <20230215072046.4000-1-quic_yingangl@quicinc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Feb 2023 09:32:00 +0100
Message-ID: <CANn89iJoYenZeBXRkRKLyDHgUW3XqDHNx3Hfg6Q5Lsj6DQ_g_A@mail.gmail.com>
Subject: Re: [PATCH] net: disable irq in napi_poll
To:     Kassey Li <quic_yingangl@quicinc.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Wed, Feb 15, 2023 at 8:20 AM Kassey Li <quic_yingangl@quicinc.com> wrote:
>
> There is list_del action in napi_poll, fix race condition by
> disable irq.
>
> similar report:
> https://syzkaller.appspot.com/bug?id=309955e7f02812d7bfb828c22b517349d9f068
> bc
>
> list_del corruption. next->prev should be ffffff88ea0bd4c0, but was
> ffffff8a787099c0
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:56!
>
> pstate: 62400005 (nZCv daif +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
> pc : __list_del_entry_valid+0xa8/0xac
> lr : __list_del_entry_valid+0xa8/0xac
> sp : ffffffc0081bbce0
> x29: ffffffc0081bbce0 x28: 0000000000000018 x27: 0000000000000059
> x26: ffffffef130c6040 x25: ffffffc0081bbcf0 x24: ffffffc0081bbd00
> x23: 000000010003d37f x22: 000000000000012c x21: ffffffef130c9000
> x20: ffffff8a786cf9c0 x19: ffffff88ea0bd4c0 x18: ffffffc00816d030
> x17: ffffffffffffffff x16: 0000000000000004 x15: 0000000000000004
> x14: ffffffef131bae30 x13: 0000000000002b84 x12: 0000000000000003
> x11: 0000000100002b84 x10: c000000100002b84 x9 : 1f2ede939758e700
> x8 : 1f2ede939758e700 x7 : 205b5d3330383232 x6 : 302e33303331205b
> x5 : ffffffef13750358 x4 : ffffffc0081bb9df x3 : 0000000000000000
> x2 : ffffff8a786be9c8 x1 : 0000000000000000 x0 : 000000000000007c
>
> Call trace:
> __list_del_entry_valid+0xa8/0xac
> net_rx_action+0xfc/0x3a0
> _stext+0x174/0x5f4
> run_ksoftirqd+0x34/0x74
> smpboot_thread_fn+0x1d8/0x464
> kthread+0x168/0x1dc
> ret_from_fork+0x10/0x20
> Code: d4210000 f000cbc0 91161000 97de537a (d4210000)
> ---[ end trace 8b3858d55ee59b7c ]---
> Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt
>
> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>

No tags ?

> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b76fb37b381e..0c677a563232 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6660,7 +6660,9 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>                 }
>
>                 n = list_first_entry(&list, struct napi_struct, poll_list);
> +               local_irq_disable();
>                 budget -= napi_poll(n, &repoll);
> +               local_irq_enable();
>
>                 /* If softirq window is exhausted then punt.
>                  * Allow this to run for 2 jiffies since which will allow
> --
> 2.17.1
>

Absolutely not.

NAPI runs in softirq mode, not hard irq.

You will have to spend more time finding the real bug.
