Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386B16C923A
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 05:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCZDbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 23:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCZDbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 23:31:24 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61129B45D;
        Sat, 25 Mar 2023 20:31:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ek18so22948096edb.6;
        Sat, 25 Mar 2023 20:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679801482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0Kwh5fxBC4ipgA40ilFC5EKoY4YfOokMirrUUulMoM=;
        b=nEFrUpvmBRyeYYKHuZeN2UECrBCKxeAQjaYkfU+0nu7rZdgq2zGTnwIm/ZsuernFMO
         LprB99mIrjUYCS9r2xQikCCJQBeBHPwe7lmOtDYExf7s47IseVJLU7AfP8gA5pA47ML4
         w5ZJvXSlEstuyahjjQ9IdzfbO7h7wB5wIuQJCZAqHudYxvLJJrmOoUB56WlhOxBpdk8t
         jchgyiNMZQYKNNw9A8yV6gsXCu4dTSJcRzNsCnLqCjve6KWrnWUc8TJTlZwjHTQ+ydhD
         yWCEgy6YppcvOW9MtCgh7RVFilmUMDnEJg99jwxuk5EzAge/wYE39JdBozbZdPrue7qG
         4U7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679801482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0Kwh5fxBC4ipgA40ilFC5EKoY4YfOokMirrUUulMoM=;
        b=NedoD9ou3AAx6xQTn+fQUI4bNnoT7/xfa/565dyZTV+IWaMd5vXm7i98I95Gd6CdfD
         WCqKrUSGuLFpU+enFrscCQwGfDOO/fS8waNpF7SGVkAtIahTczZie4p5CkT3Y0b3qgOY
         7uvVnK+wh6lT/BVM/JL+XEYmvR7IsohJVf36tNRl5Q8GEHdS9KTDLSTsL7kJ2i/zSQVw
         rjR/becrk9VtF1a3Tqn8Lqx17WxKMN/sycDN8VT6RVcq3P9yrLgckHi+huBuhtB2Exe7
         Jx6rvhDF/i9z14IT85IUWqxD5kJgROpf8KP/cky3pErkxKypUNazCE3xgx7edF6kO7F1
         XAKw==
X-Gm-Message-State: AAQBX9dh4/CmXehny8Ovvs2GtHpavxaYneC9tspwalqEaVRIEGU3VXXp
        AENtM9afnRIfivN1QbEoHK/D+1IrFqfHT0pf6BA=
X-Google-Smtp-Source: AKy350Yl8s63Q5AU2TKK4wYWkF1r6KBECysquHmzZMOBVSmN6I8Us3TXxiMlOAHibw3xRjzzYdFKWaSNi+nxe/FHnOE=
X-Received: by 2002:a17:907:c78f:b0:92a:a75e:6b9 with SMTP id
 tz15-20020a170907c78f00b0092aa75e06b9mr3599238ejc.11.1679801481768; Sat, 25
 Mar 2023 20:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com> <20230326013845.2110-1-hdanton@sina.com>
In-Reply-To: <20230326013845.2110-1-hdanton@sina.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 26 Mar 2023 11:30:45 +0800
Message-ID: <CAL+tcoCO47mgZeKM=h8OZWcebB-hKzyC9FiTgs2cPR25bE18UQ@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Hillf Danton <hdanton@sina.com>
Cc:     pabeni@redhat.com, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 9:39=E2=80=AFAM Hillf Danton <hdanton@sina.com> wro=
te:
>
> On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com>
> >
> > @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_data =
*sd)
> >         if (sd !=3D3D mysd) {
> >                 sd->rps_ipi_next =3D3D mysd->rps_ipi_list;
> >                 mysd->rps_ipi_list =3D3D sd;
> > -
> > -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >                 return 1;
> >         }
>
> Nope, ipi should be sent. But no ipi can go without irq enabled.
>

Sorry, I didn't get it. IPI is sent in net_rx_action() and apparently
I didn't touch this part in this patch. Here is only about whether we
should raise an IRQ even if the skb will be enqueued into another cpu.

> So feel free to work out what sense made by disabling irq at the call sit=
e
> then directly send ipi instead.
