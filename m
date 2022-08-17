Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA16C597A34
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 01:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbiHQXYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiHQXYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 19:24:36 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B9463C0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 16:24:33 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7916940AFC
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660778671;
        bh=0ITPAdonThQpOqsHuY/v+qY6IgwF7YWH4O5viBksCYM=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=L3N84VP/9YJFOquqJj7PqzEHQsE2WJBuxiFzYZn21FP0aWxLGAR+YnxvuxmoC64Hr
         o8B3uFtnyEZ/HfYDmel5/InBdpbEopVXOFwDnWP3ceEgny9Z6xo5hkCnwickQiTPKl
         8HoxmY2PEiUcPHNpoGNfeB4FC9VXNicqZ+mQYtJTCSd6cFlus6D+Y3xoW4Qy7VWjG6
         iCbd7Jc5u/cotOFsnkLEC1SZZPOt9xf4KL3EArTR/8/2mjYueZh7W2hiKWgxL4sjsE
         JGe6ZhY056nqRyCwB1PPNeuCwDH7vg/oBNu9UaRU/s8iwE75U8Z/Q85c2ncuopm9xF
         o8eNfYMZiQckg==
Received: by mail-pl1-f198.google.com with SMTP id s18-20020a170902ea1200b0016f11bfefe4so56439plg.14
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 16:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:mime-version:comments
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc;
        bh=0ITPAdonThQpOqsHuY/v+qY6IgwF7YWH4O5viBksCYM=;
        b=5yrhlbgc7VUQjmN550orlxU7w1KRITJTwyc0IBaa/VuRHMKyt79526sp9AVO4Le8uJ
         1EQ62ldu46HI6aiwy5HGoM1A21EdNwrmEvKIkYk2gcj8uBSLFwVV536lvwEVkfvFKkJc
         jZ009zd6PYtnPfew9NUCW+NZTdJfFqIeqPkiHE7WJyo5QrqJZ1xFwskvnQu7KQXgEQXl
         EZWMtr2f3eQx1LZFZkwLX4JEuutDSvVP6DLAvCDBbpV0SMN/39HHcVNuiwrKatXrQEpn
         tdIx4+9haR86aX36dK8RBhC+36hu/xet3D0Rh3J1dgKdCw2LQWBpsae8tTyi6fTsNeg4
         AnOw==
X-Gm-Message-State: ACgBeo3oxKu3iiAjja992XEEr3KeOXJpbaieGgnns5igfJzbnqxoFxwN
        5vxxTqs973y1fhReceB1rIV9YNYugdH4dFjCMeIiMHY09yplSXocYZ91Ibj1KG/2gkB//PcuJyY
        WnFiPj8LrdcNs0O/Yq4yqeKi5w+dKMonKcw==
X-Received: by 2002:a65:60d4:0:b0:419:9871:9cf with SMTP id r20-20020a6560d4000000b00419987109cfmr432328pgv.214.1660778668785;
        Wed, 17 Aug 2022 16:24:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4hTiPVnAROAFPx2zsiqQIWUKIlMPRA9XYwYK+QRXA0+5W2GeHKnttWaDvaORUEIbOAiwgZdA==
X-Received: by 2002:a65:60d4:0:b0:419:9871:9cf with SMTP id r20-20020a6560d4000000b00419987109cfmr432307pgv.214.1660778668308;
        Wed, 17 Aug 2022 16:24:28 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902ce0500b0016d150c6c6dsm485329plg.45.2022.08.17.16.24.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Aug 2022 16:24:27 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 646E861193; Wed, 17 Aug 2022 16:24:27 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5EEBC9FA79;
        Wed, 17 Aug 2022 16:24:27 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, liuhangbin@gmail.com,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] bonding: 802.3ad: fix no transmission of LACPDUs
In-reply-to: <3d76f4c3-916a-9abe-745f-e2781fad1b24@redhat.com>
References: <cover.1660572700.git.jtoppins@redhat.com> <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com> <17000.1660655501@famine> <3d55690a-8932-4560-4267-ab28816fdb47@redhat.com> <3d76f4c3-916a-9abe-745f-e2781fad1b24@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 16 Aug 2022 13:47:07 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 17 Aug 2022 16:24:27 -0700
Message-ID: <7721.1660778667@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On 8/16/22 09:41, Jonathan Toppins wrote:
>> On 8/16/22 09:11, Jay Vosburgh wrote:
>>> Jonathan Toppins <jtoppins@redhat.com> wrote:
>>>
>>>> This is caused by the global variable ad_ticks_per_sec being zero as
>>>> demonstrated by the reproducer script discussed below. This causes
>>>> all timer values in __ad_timer_to_ticks to be zero, resulting
>>>> in the periodic timer to never fire.
>>>>
>>>> To reproduce:
>>>> Run the script in
>>>> `tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh`
>>>> which
>>>> puts bonding into a state where it never transmits LACPDUs.
>>>>
>>>> line 44: ip link add fbond type bond mode 4 miimon 200 \
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xmi=
t_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
>>>> setting bond param: ad_actor_sys_prio
>>>> given:
>>>> =C2=A0=C2=A0=C2=A0 params.ad_actor_system =3D 0
>>>> call stack:
>>>> =C2=A0=C2=A0=C2=A0 bond_option_ad_actor_sys_prio()
>>>> =C2=A0=C2=A0=C2=A0 -> bond_3ad_update_ad_actor_settings()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> set ad.system.sys_priority =3D=
 bond->params.ad_actor_sys_prio
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> ad.system.sys_mac_addr =3D bon=
d->dev->dev_addr; because
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 par=
ams.ad_actor_system =3D=3D 0
>>>> results:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ad.system.sys_mac_addr =3D bond->dev->dev_addr
>>>>
>>>> line 48: ip link set fbond address 52:54:00:3B:7C:A6
>>>> setting bond MAC addr
>>>> call stack:
>>>> =C2=A0=C2=A0=C2=A0 bond->dev->dev_addr =3D new_mac
>>>>
>>>> line 52: ip link set fbond type bond ad_actor_sys_prio 65535
>>>> setting bond param: ad_actor_sys_prio
>>>> given:
>>>> =C2=A0=C2=A0=C2=A0 params.ad_actor_system =3D 0
>>>> call stack:
>>>> =C2=A0=C2=A0=C2=A0 bond_option_ad_actor_sys_prio()
>>>> =C2=A0=C2=A0=C2=A0 -> bond_3ad_update_ad_actor_settings()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> set ad.system.sys_priority =3D=
 bond->params.ad_actor_sys_prio
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> ad.system.sys_mac_addr =3D bon=
d->dev->dev_addr; because
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 par=
ams.ad_actor_system =3D=3D 0
>>>> results:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ad.system.sys_mac_addr =3D bond->dev->dev_addr
>>>>
>>>> line 60: ip link set veth1-bond down master fbond
>>>> given:
>>>> =C2=A0=C2=A0=C2=A0 params.ad_actor_system =3D 0
>>>> =C2=A0=C2=A0=C2=A0 params.mode =3D BOND_MODE_8023AD
>>>> =C2=A0=C2=A0=C2=A0 ad.system.sys_mac_addr =3D=3D bond->dev->dev_addr
>>>> call stack:
>>>> =C2=A0=C2=A0=C2=A0 bond_enslave
>>>> =C2=A0=C2=A0=C2=A0 -> bond_3ad_initialize(); because first slave
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> if ad.system.sys_mac_addr !=3D=
 bond->dev->dev_addr
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return
>>>> results:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Nothing is run in bond_3ad_initialize() becau=
se dev_add equals
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 sys_mac_addr leaving the global ad_ticks_per_=
sec zero as it is
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 never initialized anywhere else.
>>>>
>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>> ---
>>>>
>>>> Notes:
>>>> =C2=A0=C2=A0=C2=A0 v2:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 * split this fix from the reproducer
>>>> =C2=A0=C2=A0=C2=A0 v3:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 * rebased to latest net/master
>>>>
>>>> drivers/net/bonding/bond_3ad.c | 3 ++-
>>>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/bonding/bond_3ad.c
>>>> b/drivers/net/bonding/bond_3ad.c
>>>> index d7fb33c078e8..957d30db6f95 100644
>>>> --- a/drivers/net/bonding/bond_3ad.c
>>>> +++ b/drivers/net/bonding/bond_3ad.c
>>>> @@ -84,7 +84,8 @@ enum ad_link_speed_type {
>>>> static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned =3D {
>>>> =C2=A0=C2=A0=C2=A0=C2=A00, 0, 0, 0, 0, 0
>>>> };
>>>> -static u16 ad_ticks_per_sec;
>>>> +
>>>> +static u16 ad_ticks_per_sec =3D 1000 / AD_TIMER_INTERVAL;
>>>> static const int ad_delta_in_ticks =3D (AD_TIMER_INTERVAL * HZ) / 1000;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0I still feel like this is kind of a hack, as it=
's not really
>>> fixing bond_3ad_initialize to actually work (which is the real problem
>>> as I understand it).=C2=A0 If it's ok to skip all that for this case, t=
hen
>>> why do we ever need to call bond_3ad_initialize?
>>>
>> The way it is currently written you still need to call
>> bond_3ad_initialize() just not for setting the tick resolution. The
>> issue here is ad_ticks_per_sec is used in several places to calculate
>> timer periods, __ad_timer_to_ticks(), for various timers in the 802.3ad
>> protocol. And if this variable, ad_ticks_per_sec, is left uninitialized
>> all of these timer periods go to zero. Since the value passed in
>> bond_3ad_initialize() is an immediate value I simply moved it off of the
>> call stack and set the static global variable instead.
>> To fix bond_3ad_initialize(), probably something like the below is
>> needed, but I do not understand why the guard if check was placed in
>> bond_3ad_initialize().
>
>I looked at the history of the if guard in bond_3ad_initialize and it has
>existed since the creation of the git tree. It appears since commit
>5ee14e6d336f ("bonding: 3ad: apply ad_actor settings changes immediately")
>the if guard is no longer needed and removing the if guard would also fix
>the problem, I have not tested yet.

	The logic in bond_3ad_initialize probably came that way when the
code was contributed sometime during 2.4.x.

	Curiosity got the better of me, and I looked at the 2.4.35 code.
I'm not sure what the point of the test was even then, since
bond_3ad_initialize is only called when adding a first interface to the
bond, and there wasn't a way to tweak the sys_mac_addr then.

	In the current code, I think the if test could fail if
sys_mac_addr is set manually to be equal to the bond's MAC prior to
adding the first interface to the bond.  As far as I can tell, the only
result of failing the MAC test would be that the agg selection timer
wouldn't be started, which is an optimization to reduce LACP aggregator
flailing when multiple interfaces are added at the same time (IEEE
802.1AX-2000 6.4.9 and 6.4.12.1.n).

>I think this patch series can be accepted as-is because, it does fix the
>issue as demonstrated by the kselftest accompanying the series and is the
>smallest change to fix the issue.
>
>Further, I don't see why we want to set the file-scoped variable,
>ad_ticks_per_sec, inside bond_3ad_initialize() as ad_ticks_per_sec is
>utilized across all bonds. It seems like ad_ticks_per_sec should be
>changed to a const and set at the top of the file. I see no value in
>passing the value as an unnamed constant on the stack when
>bond_3ad_initialize is called. These changes however could be done in the
>net-next tree as follow-on cleanup patches.
>
>Jay, how would you like to proceed?

	I don't have issue with moving ad_ticks_per_sec to a file scope
constant.  The minimal change here, though, is effectively making the
tick_resolution parameter to bond_3ad_initialize be ignored, even though
the compiler won't complain about it.

	Given that there is already mystery in how some of this works,
I'd prefer the patches to make the code clearer, so my vote is for the
"fix it right" method, i.e., make ad_ticks_per_sec a real constant,
remove the tick_resolution parameter from bond_3ad_initialize and drop
the "if MAC_ADDRESS_COMPARE" test therein.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
