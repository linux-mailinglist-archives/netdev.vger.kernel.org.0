Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751DC666027
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjAKQRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbjAKQRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5B60E3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:16:45 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d3so17258253plr.10
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LcMCesgVS7ojDwqLsTsdUm62SIlnOArytLUVMLEl1Lo=;
        b=SX8Jk7TWST3R7J0ChlMFUs2mKzEVUzbipKuluoequulFjQ+lbABoKIdyeiHR1BcCzf
         gFD2y/T/cotooamnJ4KHc+hxXqZ0M3DIlVUXHZb6Uvf55XVgNuTR5mNiVkwwAvRuUOjq
         ZtvZR0O1dU5ZlovjTQZaKm7ODcC1rZ7/XZ2ggykvOt3mLSQEDEZOUtNZsunWfzcRV+Fb
         j0lPnqwTBsU9AxevKROsLx8aVExMtTInxW/oHM30rayZC/EwwrLpe5eVtLgRbIrOaafb
         l3p5sRl14FZQRKiW+HaAorDCUIax14Ymm49m84u1mwrL0Fmpyj2vCfk7mDCwLBLSym3N
         vdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LcMCesgVS7ojDwqLsTsdUm62SIlnOArytLUVMLEl1Lo=;
        b=bnyRIgq7W3D1iIvcM3BuHOT+gWq44o00dObzWgAglAMTzTh2WERdIJyYqwucLK0KxC
         Q/msKhRQQG3bB+4SO1AdEfg3pEiWFRTL4KEY0vrMBBDY5A8mloRwP4HvpuAvi/GMPinw
         15ZmfK4AYTv5K/L2jvCpmgVvP44nEvIgZtL/pfndzaL+IuWFxeZTNFe0f41wIDvCRylU
         QKK+V4sAqTHJ4GZ3MFWz78QmQB34qspqTovKpUva5ORAHdqu/Udi4ZnEHGosdUYBR4LC
         gf1MTNY8bYTC4BVShnLGcUZkzuHPGjbOp1+xYd63CNmKIi9iKVRIJblGnU9oQ8Lg49z2
         2AUQ==
X-Gm-Message-State: AFqh2kpdxdWEkH5JmLPINIsG7lncJMJmHRZB6EqWTS5DVzrxkLVdLk0r
        qMqboRnoovceeXhiH9tImpw=
X-Google-Smtp-Source: AMrXdXuoE9tp/uLZm7OUO5EDoJahhtsNd7o7Z4qQJDHKOeOdiNFvJBBmAbPI56H8KflKgFtWtn1LRQ==
X-Received: by 2002:a17:90a:d144:b0:227:17e:32a with SMTP id t4-20020a17090ad14400b00227017e032amr13531870pjw.18.1673453805427;
        Wed, 11 Jan 2023 08:16:45 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b001fde655225fsm6150692pjb.2.2023.01.11.08.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 08:16:44 -0800 (PST)
Message-ID: <a709b727f117fbcad7bdd5abccfaa891775dbc65.camel@gmail.com>
Subject: Re: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx
 timeout
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Date:   Wed, 11 Jan 2023 08:16:43 -0800
In-Reply-To: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
References: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-10 at 23:03 +0100, Heiner Kallweit wrote:
> There are still single reports of systems where ASPM incompatibilities
> cause tx timeouts. It's not clear whom to blame, so let's disable
> ASPM in case of a tx timeout.
>=20
> v2:
> - add one-time warning for informing the user
>=20
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

From past experience I have seen ASPM issues cause the device to
disappear from the bus after failing to come out of L1. If that occurs
this won't be able to recover after the timeout without resetting the
bus itself. As such it may be necessary to disable the link states
prior to using the device rather than waiting until after the error.
That can be addressed in a follow-on patch if this doesn't resolve the
issue.

As for the code it looks fine to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
