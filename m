Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECC9646BD4
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLHJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLHJZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:25:16 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26EE5D682
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:25:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bx10so921995wrb.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 01:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T9BSpVk3FQlke26NZvWque2HNK6zy0EJYdGH2Ux31DA=;
        b=i5d5sg9qbLyzo09oRf8LtI4xkjKs1YRdBR0Gw3tOgcVlwzMCPuI6ykKbOuL4j9Yu8z
         xmsAmoTKKMQeYJsdP0qh5XcAPi637qmxboB4sKMKCFNGEEYiLG8EfD8fXmZd64M8jUR9
         6kyd28Eu54nzTKnb8iXl21tO8VPEoELspP3zK/OMc76ffkIofUwqQtadhdx2rKVSPN9y
         gl2zXZy/oKrt4Gd0ZS++yPNlGXIZGPqMjEgTdNiobWlOrnbaaBEN0juPgwxW8V2pta4O
         JPYWnh6I0ZS5LwOg4ltf50yG8+fP0O9sA4ecelWBmn9fMD4EYyjx2pkfbZ1cTa+OXaTd
         i2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9BSpVk3FQlke26NZvWque2HNK6zy0EJYdGH2Ux31DA=;
        b=EEE5rcbsdCfdJ5oFMhCbfyshDAVTDYv8lRZaPwn59tvleG9j8xov+r61XCb9gL8PwS
         dw8JgziSQpFdquGH3LjjUp5pRU7P2n+VRhxZ1JWWiTSwcJ8ZJ4Yd4R7C9akQy2K3eylr
         0zz5nJ49wAArEMvl5hVCOINOEtHWcZsEUyt7hirKD+7nPkCdIv27roXiNhAO3SDmOoVY
         sC8eN18J9XDlPOTym6LVVNHrj0g3dxUEdjHsrXAzBpwMKWh2ZrT+JgAde5hsIKHF+wct
         xvsRlPLbG8v/e3Csb8CLoLGuqNl8fSprdaaLTEMw46cLcv6/2NwbE+hglmvH9hcBnqGU
         E30A==
X-Gm-Message-State: ANoB5plvxXmjR1nBIhisDwhQLQxhF2tiqlk4ptndGa08/VyoMJpSU7W6
        17oWhJVmliWC3QyDxMYpjTXfOhuHo/Gf+in+Eb8=
X-Google-Smtp-Source: AA0mqf4wBcuEVsn/HYuqHcPJh3zSvYSWQDohAi+Oz6IGtztMtyjEcliEjynQHb7OrNeMR95QtLPvDCPYPWdbmeL+zgY=
X-Received: by 2002:adf:fa11:0:b0:242:13be:f6db with SMTP id
 m17-20020adffa11000000b0024213bef6dbmr29797865wrr.690.1670491511319; Thu, 08
 Dec 2022 01:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20221208032655.1024032-1-yangyingliang@huawei.com> <20221208032655.1024032-2-yangyingliang@huawei.com>
In-Reply-To: <20221208032655.1024032-2-yangyingliang@huawei.com>
From:   Harini Katakam <harinikatakamlinux@gmail.com>
Date:   Thu, 8 Dec 2022 14:55:00 +0530
Message-ID: <CAFcVECLB_4mCyzaDUrxLWHSjnKZZmfSJevUVptqcY+GMYCh7xw@mail.gmail.com>
Subject: Re: [PATCH v2 resend 1/4] net: emaclite: don't call dev_kfree_skb()
 under spin_lock_irqsave()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Michal Simek <michal.simek@xilinx.com>,
        John Linn <john.linn@xilinx.com>,
        Sadanand M <sadanan@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 9:04 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
>
> Fixes: bb81b2ddfa19 ("net: add Xilinx emac lite device driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Thanks for the patch Yang
Reviewed-by: Harini Katakam <harini.katakam@amd.com>

Regards,
Harini
