Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CF8596CEE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHQKmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHQKl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:41:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2715924A;
        Wed, 17 Aug 2022 03:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3098AB81CC7;
        Wed, 17 Aug 2022 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD8CC433C1;
        Wed, 17 Aug 2022 10:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660732914;
        bh=jSwzVf5c/jELVgW/bVGmMIh+NBm1nJk4nPTUCH5zvMk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Zg9RFhuBsHJI2Q3BgJr0bMTVCwbXLiAkpq2Ndm8f6D6KyXcA55Uf0SJ1gabl6iEXQ
         Oa+K0Q5eNAVaJqmc1sswqwpkPGlhMULEfBgXURVZnp+KnShfJgo8GfFPCmEpuAjpJf
         WqGTLS/1BPyNPqEyAQQHY2Bz4PFHhMDZPLbd6Mee6ZPtNSfrrfMQARROxhXoaBdNkn
         8GioXlPDA0Jh1xGV3OEPPI04Q7SRrgRiwKaTaH1IVj7mWJ5hAxemKENCcP0Ame0e2P
         5LmtApRvnF4IHjPCpwjzx1KrC7Bg8J9tXfBXJ0esdyKjk/N5w0O3Nb/ZIG3tzPorbd
         f1wnpQgIkRSQw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] wifi: brcmfmac: fix continuous 802.1x tx pending timeout error
In-Reply-To: <20220817083432.wgkhhtihtv7wdwoq@bang-olufsen.dk> ("Alvin
        \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\= message of "Wed, 17 Aug 2022 08:34:32 +0000")
References: <20220722115632.620681-2-alvin@pqrs.dk>
        <166011047689.24475.5790257380580454361.kvalo@kernel.org>
        <20220817083432.wgkhhtihtv7wdwoq@bang-olufsen.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 17 Aug 2022 13:41:47 +0300
Message-ID: <871qtfm9sk.fsf@kernel.org>
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

Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> writes:

> Hi Kalle,
>
> On Wed, Aug 10, 2022 at 05:48:01AM +0000, Kalle Valo wrote:
>> Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:
>>=20
>> > From: Wright Feng <wright.feng@cypress.com>
>> >=20
>> > The race condition in brcmf_msgbuf_txflow and brcmf_msgbuf_delete_flow=
ring
>> > makes tx_msghdr writing after brcmf_msgbuf_remove_flowring. Host
>> > driver should delete flowring after txflow complete and all txstatus b=
ack,
>> > or pend_8021x_cnt will never be zero and cause every connection 950
>> > milliseconds(MAX_WAIT_FOR_8021X_TX) delay.
>> >=20
>> > Signed-off-by: Wright Feng <wright.feng@cypress.com>
>> > Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
>> > Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> > Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>>=20
>> 5 patches applied to wireless-next.git, thanks.
>>=20
>> 0fa24196e425 wifi: brcmfmac: fix continuous 802.1x tx pending timeout er=
ror
>> 09be7546a602 wifi: brcmfmac: fix scheduling while atomic issue when
>> deleting flowring
>> aa666b68e73f wifi: brcmfmac: fix invalid address access when enabling SC=
AN log level
>> 5606aeaad01e wifi: brcmfmac: Fix to add brcmf_clear_assoc_ies when rmmod
>> 2eee3db784a0 wifi: brcmfmac: Fix to add skb free for TIM update info
>> when tx is completed
>
> Thanks. Do you mind elaborating on why the 6th patch:
>
>     brcmfmac: Update SSID of hidden AP while informing its bss to cfg8021=
1 layer
>
> was not applied?

Because of mismatch between From and s-o-b. I will look at that in
detail after my vacation.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
