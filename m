Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99446EB961
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 15:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDVNdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 09:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVNdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 09:33:49 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECB1718;
        Sat, 22 Apr 2023 06:33:46 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682170424; bh=YMRSn3zcYiCKxTTR1o2KV2jlgcDlQdjVd/13bW5LgQA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RcXC+ETEUIGozX7+QoCnMyT+ri10p8t3j9bLfACZPUmojlylrMyOTROQuG69TJuC7
         5+DD9Th/jkOHiL3Ca5M9uUdUNGayD+rJC43YlQ3wUXTGdZ2+H8xUn+v5uPiKoSdcqF
         aj5neObcyiagLWzuoO/DTiTDMdEpyEI+iffnjpbAcimzvjnz8DTg6zg5qGbQhpPZqB
         A/csK3Wg+K47y7IP3sAN0COeexzN4YJYcjINez8da6STJ20PDCp6visLW9y21GquVb
         572mLm2qvg/N+/gq//OXYZWCbdZXcIEh42OhbALqrRmvzGPHcjdzLkjqYI8TS3tvzt
         YAv4dQDpSX/4A==
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
In-Reply-To: <20230422152234.639fc98e@gmx.net>
References: <20230420204316.30475-1-ps.report@gmx.net>
 <ZEOf7LXAkdLR0yFI@corigine.com> <87bkjgmd9g.fsf@toke.dk>
 <20230422152234.639fc98e@gmx.net>
Date:   Sat, 22 Apr 2023 15:33:43 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zg70kpmw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> On Sat, 22 Apr 2023 12:18:03 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@toke.dk> wrote:
>
>> Simon Horman <simon.horman@corigine.com> writes:
>>=20
>> > On Thu, Apr 20, 2023 at 10:43:16PM +0200, Peter Seiderer wrote:=20=20
>> >> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
>> >> calculation (do not overflow the shift for the second register/queues
>> >> above five, use the register layout described in the comments above
>> >> ath9k_hw_verify_hang() instead).
>> >>=20
>> >> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
>> >>=20
>> >> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
>> >> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-=
F0177FB722F4@seqtechllc.com/
>> >> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
>> >> ---
>> >> Notes:
>> >>   - tested with MikroTik R11e-5HnD/Atheros AR9300 Rev:4 (lspci: 168c:=
0033
>> >>     Qualcomm Atheros AR958x 802.11abgn Wireless Network Adapter (rev =
01))
>> >>     card
>> >> ---
>> >>  drivers/net/wireless/ath/ath9k/ar9003_hw.c | 27 ++++++++++++++------=
--
>> >>  1 file changed, 18 insertions(+), 9 deletions(-)
>> >>=20
>> >> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net=
/wireless/ath/ath9k/ar9003_hw.c
>> >> index 4f27a9fb1482..0ccf13a35fb4 100644
>> >> --- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
>> >> +++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
>> >> @@ -1099,17 +1099,22 @@ static bool ath9k_hw_verify_hang(struct ath_h=
w *ah, unsigned int queue)
>> >>  {
>> >>  	u32 dma_dbg_chain, dma_dbg_complete;
>> >>  	u8 dcu_chain_state, dcu_complete_state;
>> >> +	unsigned int dbg_reg, reg_offset;
>> >>  	int i;
>> >>=20=20
>> >> -	for (i =3D 0; i < NUM_STATUS_READS; i++) {
>> >> -		if (queue < 6)
>> >> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_4);
>> >> -		else
>> >> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_5);
>> >> +	if (queue < 6) {
>> >> +		dbg_reg =3D AR_DMADBG_4;
>> >> +		reg_offset =3D i * 5;=20=20
>> >
>> > Hi Peter,
>> >
>> > unless my eyes are deceiving me, i is not initialised here.=20=20
>>=20
>> Nice catch! Hmm, I wonder why my test compile didn't complain about
>> that? Or maybe it did and I overlooked it? Anyway, Kalle, I already
>> delegated this patch to you in patchwork, so please drop it and I'll try
>> to do better on reviewing the next one :)
>
> No warning reported because of Makefile:
>
>   1038 # Enabled with W=3D2, disabled by default as noisy
>   1039 ifdef CONFIG_CC_IS_GCC
>   1040 KBUILD_CFLAGS +=3D -Wno-maybe-uninitialized
>   1041 endif

Ah, I see! Right then, that explains it :)

-Toke
