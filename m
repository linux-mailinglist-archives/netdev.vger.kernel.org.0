Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D084F57A8
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiDFIEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 04:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376957AbiDFH6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 03:58:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7B01C2A3C;
        Tue,  5 Apr 2022 22:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6C161841;
        Wed,  6 Apr 2022 05:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9477C385A1;
        Wed,  6 Apr 2022 05:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649223841;
        bh=yC36iEkxg58Jk7HR6Fw3kJOeOrW6HPs3LGEP1J9Hxkw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aTawiqPlLmtbK7yWUuMuIqu1/TxtSQovS4CTRy4usxtr2MNVucy+iBU++5bkUcBKi
         UzV+hBTDcfP9m7Zu+pNTPItLkrc0hX52568BmmspOz5sT3SehUTaQpuXk3TZiJ0CKW
         U3rQCrrXIqsAMjLlOdjNbx9Y6L7mvqSn6yr56N5qj4aTFvuXgfIvDLOEwBnAqCJ54X
         Ag7GXdp6zipXGImE+ZZMrThcaexgYqAbiljX1uBzZjB4Kt9HYCs7nIKE2OhhUk0EIl
         pZ6E2jNcYwYzR/+dqMDDV5a5DgjMdXkuaaJ236rp7WWXdUteNlEJawdj9+Tq3GAoCW
         z4qA4agVuXDsA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/11] mt76: Fix undefined behavior due to shift overflowing the constant
References: <20220405151517.29753-1-bp@alien8.de>
        <20220405151517.29753-9-bp@alien8.de>
Date:   Wed, 06 Apr 2022 08:43:53 +0300
In-Reply-To: <20220405151517.29753-9-bp@alien8.de> (Borislav Petkov's message
        of "Tue, 5 Apr 2022 17:15:14 +0200")
Message-ID: <87fsmqrckm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> From: Borislav Petkov <bp@suse.de>
>
> Fix:
>
>   drivers/net/wireless/mediatek/mt76/mt76x2/pci.c: In function =E2=80=98m=
t76x2e_probe=E2=80=99:
>   ././include/linux/compiler_types.h:352:38: error: call to =E2=80=98__co=
mpiletime_assert_946=E2=80=99 \
> 	declared with attribute error: FIELD_PREP: mask is not constant
>     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER_=
_)
>
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>

As this fixes a compiler warning in Linus' tree, I would like to take
this to wireless tree and I assigned this to myself in patchwork.

Felix, ack?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
