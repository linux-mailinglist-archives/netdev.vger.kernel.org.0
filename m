Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8D6B87F1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCNCAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjCNCAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:00:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D578485A51;
        Mon, 13 Mar 2023 18:59:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so5332985pjt.5;
        Mon, 13 Mar 2023 18:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678759162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=libK5IrunWjnmYeIrLVLzHj5IofQM+aENkO5owP/peg=;
        b=e386gMZuSFDqhUclzZJp7e9W2tbUEY5z/ahPn2yeUQcQqy1+1NxWheg3yt9thWqyDV
         MzcfYNgnW0uj0gXJ07mzYEteJNmnlvS8pi829pQ2U38MQJPr9LPltgm7+9CIQckdbvDW
         tTbT3xXvbMwE8YT/TAJHGEFSA33fUBfkpvMaT8Ul+0NkMoKs58SH1I0zm6lzhtINBgWL
         LXBA5FAPjlgqluoKxMQWMBGNwFzRJue/k4+RJa5irAL2xJ4ra2yKvGiA58JUCd1ULvZ1
         gRbY3O6LpymPUfX6jjxDV6se2b95tMRGl/OE1bBfsJ0a3TCqJttI+/Ice5OYt+dUHDf9
         cQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678759162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=libK5IrunWjnmYeIrLVLzHj5IofQM+aENkO5owP/peg=;
        b=eVcmsbytQl8g/ddDHnGnIcRY9EIs5K6DlWGVNH5cZe2tmNwUfa5GjWQdVQG2b7CFuH
         /OojMaO2FRJrKTAld+VL4EO9bc0H42mq0MQAHHFAimFr2NM3zuAw4ICn25HupuLn0gmY
         r4Rmj+h4kqw1VhPsBb2nm514JQ6MGUUM5S+nEKk1/eFC6K2NDuy/3pD4L/+U7MXV2rJm
         pmgtcPwv5FvQqlc8Enb3my8eZyOWFWQkjipa0oMrafUGqTpHZNXOH/x6PqZKG0DQtWca
         fZsHG3FzC3+0K9SQHZF0bryexsu8UaCwC/LGO4Q77p6PDEuhisHk9khF+twEhgdLOHMw
         QxQQ==
X-Gm-Message-State: AO0yUKUz6GK5VCvYfUjIpR/vjcolJ1D9mzAgCDTE4adTjgr9YaAVg+l6
        AgwFR8nSYxYVJ8elt2GS3oajr9rVA2Uz57vP1HU=
X-Google-Smtp-Source: AK7set9SVmFMqgS+k1U1tbrRdpfz6nXpADkVQVhLR4D4nrF3bWl/4e/fDNfX/BYGw7d8QDhw/Ee3gj1+vUY3m1qoqAY=
X-Received: by 2002:a17:90a:985:b0:23d:27cd:f1dd with SMTP id
 5-20020a17090a098500b0023d27cdf1ddmr1038306pjo.9.1678759162133; Mon, 13 Mar
 2023 18:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230309094231.3808770-1-zyytlz.wz@163.com> <20230313162630.225f6a86@kernel.org>
In-Reply-To: <20230313162630.225f6a86@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 09:59:09 +0800
Message-ID: <CAJedcCxBn=GE_pQ4xzpnvUmMA6rDuwn_AiE7S7d1EqGF9cHkNw@mail.gmail.com>
Subject: Re: [PATCH net] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=97=
=A5=E5=91=A8=E4=BA=8C 07:26=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu,  9 Mar 2023 17:42:31 +0800 Zheng Wang wrote:
> > +     cancel_work_sync(&dev->tq_refill);
> >       ns83820_disable_interrupts(dev); /* paranoia */
> >
> >       unregister_netdev(ndev);
>
> Canceling the work before unregister can't work.
> Please take a closer look, the work to refill a ring should be
> canceled when the ring itself is dismantled.

Hi Jakub,

Thanks for your review! After seeing code again, I found when handling
IRQ request, it will finally call ns83820_irq->ns83820_do_isr->
ns83820_rx_kick->schedule_work to start work. So I think we should
move the code after free_irq. What do you think?

Best regards,
Zheng
