Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C4B66664F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjAKWiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjAKWiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:38:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449F2395EB
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 14:38:16 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n12so17306598pjp.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 14:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S5GtI2XGqlZV4Z9aa/j4pvBnD1r66HT7DUgcKSON4QQ=;
        b=DUM7AIT0O2uYxdjAMi/PUe4HKaHoJrLqSxgV1NZP97BgZ1D60Yer167mN141zB7668
         CC/gUjhwc5Cs6/MgWq/806V7bxI+SLJT3yZduC57fWqIRNo3Y2phbA1A8XTu6k38DHmm
         sPRSSlDe+0rzwk6+K64n/KU9ihzKTiWaKditYLkF8B1YLO1DZQMyb+UTsvwBuu1U1afW
         BCslfw7A9CVzIpO41vEsppkRNNn1VrbR/PXevEiEOoZcw9hAJStxWAF50zreolECMPey
         VOf/MRnrTUUDyN35YCYncNJ33lGsTgVe0fbXp1RxeOkmQik+hi5p0EfB/1ubOUUikslS
         CaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5GtI2XGqlZV4Z9aa/j4pvBnD1r66HT7DUgcKSON4QQ=;
        b=ffqIBSG5RfQiIwrkm0eLoANs2t+55o3RD2Wn4uHa3COHN7MWI8AeoGVRhePzi79ROG
         jUYacUOSa236LgTw96QQYrWtvVZgbY/AsiJylqMk1U7m12QjFpWOz69QZRNw7QnSf6xK
         ESx4OyyFDUcdK2/RhHgQidIU63OjEdCDUVi1SQKAvdic3vwnxtB5J3eC5XOfSwqEWxj1
         X6BUba1UWDu5iOJM9zz2WC6MIo37wt1SAodXg0fAFPiWpm8wi07Ny5CHv1O2lMzKfo6y
         JxnnbpZBLdgI3l251E/ic6QgiuLYYwqZD6QYHqQXMhJJX4P95Ukzq8pvO/5hgaeUiP3L
         TNkA==
X-Gm-Message-State: AFqh2kr6+h679F8JXP4xBjz2vRGx2gvypMFTyw+BX5bZU3VCCfrJNIfa
        Twm4+eUMovPxf8QkR/n4hoTjUaNnk9qctiX/fCA=
X-Google-Smtp-Source: AMrXdXtx9SPRrrJkWxjuxrCCCdJutxSQOsmB49C9onJ0RAxMxDL3N9UO4jI0ZDOcvJ+6j8GRpYvMATCo9y0VBmcuQH4=
X-Received: by 2002:a17:902:8a8f:b0:190:fc28:8cb6 with SMTP id
 p15-20020a1709028a8f00b00190fc288cb6mr4279563plo.144.1673476695493; Wed, 11
 Jan 2023 14:38:15 -0800 (PST)
MIME-Version: 1.0
References: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
 <a709b727f117fbcad7bdd5abccfaa891775dbc65.camel@gmail.com> <fc80b42a-e488-e8a2-9669-d33a5150ac9b@gmail.com>
In-Reply-To: <fc80b42a-e488-e8a2-9669-d33a5150ac9b@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Jan 2023 14:38:04 -0800
Message-ID: <CAKgT0UewG-nfgd3mz6GPy=KLk8gkerToyapg4R+=g4wUo5fMWQ@mail.gmail.com>
Subject: Re: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx timeout
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
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

On Wed, Jan 11, 2023 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 11.01.2023 17:16, Alexander H Duyck wrote:
> > On Tue, 2023-01-10 at 23:03 +0100, Heiner Kallweit wrote:
> >> There are still single reports of systems where ASPM incompatibilities
> >> cause tx timeouts. It's not clear whom to blame, so let's disable
> >> ASPM in case of a tx timeout.
> >>
> >> v2:
> >> - add one-time warning for informing the user
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >
> >>From past experience I have seen ASPM issues cause the device to
> > disappear from the bus after failing to come out of L1. If that occurs
> > this won't be able to recover after the timeout without resetting the
> > bus itself. As such it may be necessary to disable the link states
> > prior to using the device rather than waiting until after the error.
> > That can be addressed in a follow-on patch if this doesn't resolve the
> > issue.
> >
>
> Interesting, reports about disappearing devices I haven't seen yet.
> Symptoms I've seen differ, based on combination of more or less faulty
> NIC chipset version, BIOS bugs, PCIe mainboard chipset.
> Typically users experienced missed rx packets, tx timeouts or NIC lockups.
> Disabling ASPM resulted in complaints of notebook users about reduced
> system runtime on battery.
> Meanwhile we found a good balance and reports about ASPM issues
> became quite rare.
> Just L1.2 still causes issues under load even with newer chipset versions,
> therefore L1.2 is disabled per default.

Does your driver do any checking for MMIO failures on reads? Basically
when the device disappears it should start returning ~0 on mmio reads.
The device itself doesn't disappear, but it doesn't respond to
requests anymore so it might be the "NIC lockups" case you mentioned.
The Intel parts would disappear as they would trigger their "surprise
removal" logic which would detach the netdevice. I have seen that
issue on some platforms. It is kind of interesting when you can
actually watch it happen as the issue was essentially a marginal PCIe
connection so it would start out at x4, then renegotiate down with
each ASPM L1 link bounce, and eventually it would end up at x1 before
just dropping off the bus.

I agree pro-actively disabling ASPM is bad for power savings. So if
this approach can resolve it then I am more than willing to give it a
try. My main concern is if MMIO is already borked, updating the ASPM
settings may not be enough to bring it back and it may require a
secondary bus reset.
