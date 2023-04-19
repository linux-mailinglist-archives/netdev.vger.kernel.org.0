Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795D66E72A1
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 07:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjDSFaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 01:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSFaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 01:30:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07954697;
        Tue, 18 Apr 2023 22:30:16 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b4bf2d74aso2443512b3a.2;
        Tue, 18 Apr 2023 22:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681882216; x=1684474216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OSQxrSfo9g2PRmFaM8khgvUPSinJ6+/aFBwzvj216c=;
        b=reV/gURgFVvnY0EcU+e/bKuk2FWHgQw7hdLeo13u0ORgheCdKGB6tX34/Mnj/9VHrp
         DnEYZIQgvmwq2zSKyc3Z3ABTJAmopgxw5jkcKWTOHSoQdh0yEnhkwn5S0JPoOOKnJxN1
         g+a7NYaePRNCBi7MDG1kk9qSYYRi2j4w9DWK/LOpY/RIS6DfJY0GuVMrsbn8F6xq3Ofc
         ucXWdYbyauvbZ3VfFY2pKEpMXSTw7OwihS5RcyNnsE89U9u9M/PlsfRaXfFkVurAbJNr
         GhhAYRrJf4eDN8vkzYytZ7d+BHALju5zYmab2lvTZCQNtD62ao8LWndELg4G+28z3qHV
         8nBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681882216; x=1684474216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OSQxrSfo9g2PRmFaM8khgvUPSinJ6+/aFBwzvj216c=;
        b=iJ6o69WwT85TCGoRbyIrS0d+6d4ZvmQwV45tpTTSan6tAWvOdDIRms10ClXMPXIWPc
         up13z+mop4pYvzKS6AAEjx80ffogFaZXCLi1gVjqCukdba5vHVuWhW4X3dbHCpglJvIK
         c8xfnubx74uYuYDUZUgp7qoLhmIq8DwNKromYr17U3eovj8LI+sUZ/alXYo+s7vHWO0D
         Gf1TliBtUdfdl9J3seZKUIxLNhahs4szAVzECDUcA5Lbe/6LFbep6REcOZTQcMpSTLML
         WGG+VHWzlPXltaZxd+fX/Y9gdsAGU5yMvY+/fw096ArWS8g3SJgGGEbiIPRNN+SvAl0s
         ZV3g==
X-Gm-Message-State: AAQBX9dNlMGdVn/QSiv0K1pykFbghya0O0SjVB5T3TDciIgiSumB7/0o
        4YwqmSZJo8Sb6Y8ECRKZ+7Ucw22SEEFz1BJwCyk=
X-Google-Smtp-Source: AKy350b5S4mPAHJk106Cu3+gvWK+Mf/tyMH7pgXtlxkOeNgW8Wa0O0oofvog8ZgsISTiZOd18rZjlRJyDWiBvcVpw/c=
X-Received: by 2002:a17:90a:51e6:b0:233:c301:32b3 with SMTP id
 u93-20020a17090a51e600b00233c30132b3mr1711226pjh.3.1681882216318; Tue, 18 Apr
 2023 22:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230417013107.360888-1-zyytlz.wz@163.com> <20230418213340.153529d7@kernel.org>
In-Reply-To: <20230418213340.153529d7@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Wed, 19 Apr 2023 13:30:05 +0800
Message-ID: <CAJedcCx3B58NaBHYZ_xurKjp=7DjmMgHvSta2axCu5ToQObwMg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        horatiu.vultur@microchip.com, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B44=E6=9C=8819=E6=97=
=A5=E5=91=A8=E4=B8=89 12:33=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 17 Apr 2023 09:31:07 +0800 Zheng Wang wrote:
> > +     netif_carrier_off(ndev);
> > +     netif_tx_disable(ndev);
> > +
> >       unregister_netdev(ndev
>
> It's not immediately obvious to me why disabling carrier and tx
> are supposed to help. Please elaborate in the commit message if
> you're confident that this is right.
>

Hi Jakub,

Thanks for your reply. I'll figure it out to see if it's really necessary.

Best regards,
Zheng

> --
> pw-bot: cr
