Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67066644904
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiLFQRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiLFQRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:17:15 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45A938E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:13:11 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 189so19170352ybe.8
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RgouVI3tenQ8faKuoi75UUOjONfcX6xOygAeSY0a3Cs=;
        b=ldEbcNEgkSANQxOTh/c24dDER8Yc0JZ+8zjUs+ZXTPNTStzUwKHrt1Ku6D5dV382dU
         rNpvVTRdfqqhBRSrRlH8fkkB0m6z6BceUjQU6zeDUKELkWgaQYTURNSBCuKRBgPJ7WQC
         sYTs/afNuTF6TtjQCXCdpG80cebedt5SK5ft30ExHKayUcc8BIoICL8EBA8MFiSpHLus
         aywtC8SO4KrHzYsQyoITZHCVB794FPCMcgr6a3iA2+B2NC7cdHwoVVjc2iGBZ9MZZsu3
         Apo2MTV4RE9HKWzl/dc559XaqrrsGt1kt4jTSfo8j0jwmwdx053uV6Fj+qIzrKHUwaaU
         xB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RgouVI3tenQ8faKuoi75UUOjONfcX6xOygAeSY0a3Cs=;
        b=o2g9dr4GCkZ7b9es01JeL1nG3pIIKEAtroOZJHF2H0UjTYZyEclFS1zHCSeMoRZY5k
         zWnLb6TZ4qpxe22F/7NKVEG7hS0SdPPhRgsgtybxJSj+OGyuU84MrU/kvBdIfhTU42RC
         fKFO11AZvcCizL4xddxv3mebCr6gnA+hvjLncM9SCwEpzXdU4L6qf7ZpTDMNGnE4AuJV
         bHowYZ4oiUA4c0XztGlzMCiXSpA3NQ126TtMly7D8yypt/nYVX1XlQcQ+EQujarnBd7T
         vHV/u+Yxa/AKHiRp4s5nhCz3CY7rSUUyuu0EPeTjn+rJ12CY5gArNefmATI5if0/Vdvd
         SR7g==
X-Gm-Message-State: ANoB5pnvdJzj8vvaTqe9U5FxlxJQ7q6PeeUZgXEHaOg+5t+eiUKTM1Rs
        MydaVQlBrAxowHzQU7NrMSRQWhSRHqYyfE2MM9/tbg==
X-Google-Smtp-Source: AA0mqf7MZPTdjUkACv9p9bWDV0NmWQhJ3SMmxqSviU0zvl/nP1mc6yJu6f4DmZzHUrSgYWZkJuFzyKUylhf8UUDf+vE=
X-Received: by 2002:a25:d655:0:b0:6fc:1c96:c9fe with SMTP id
 n82-20020a25d655000000b006fc1c96c9femr23066520ybg.36.1670343190625; Tue, 06
 Dec 2022 08:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20221206155134.2325115-1-yangyingliang@huawei.com>
In-Reply-To: <20221206155134.2325115-1-yangyingliang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 17:12:59 +0100
Message-ID: <CANn89iKxd7zoeD4GVHcwD62ZzY8bk6NZUYd9c7kdUQc9K_iTfA@mail.gmail.com>
Subject: Re: [PATCH net] ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
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

On Tue, Dec 6, 2022 at 4:53 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

You forgot a Fixes: tag
