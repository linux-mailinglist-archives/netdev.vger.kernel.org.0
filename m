Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB46F1371
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345445AbjD1IrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjD1Iq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:46:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9981A2728;
        Fri, 28 Apr 2023 01:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A11A61411;
        Fri, 28 Apr 2023 08:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A446EC433D2;
        Fri, 28 Apr 2023 08:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671614;
        bh=mCUVhJ/yf9+Zbv9PHEQScTzGuHyq2YKo5CQGfRfHFO4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tAsTEcSc1JhvpjJ7q2pg2Tbuj+oBgVxElnaZU/eNVxkK6Vz28K0BxFJ0bO31XlKgL
         +i2F0zVN1UneePAdwdRF4xkW5sV90huXHKjnR3MnJGTAhhgpCkfJnsGNqriD4hcR/b
         0Uded35/Yc9GVWH4/fhpO4o33E+BzoANK4NT8X9A5c2GEKy8QC3MCBQl6XWwvIC8+o
         0C44Mn8BEQ7G6HevgAlIBTxQdQ8F8LS6yg01ZiGpRvGX3A8gMxBfzf83EDS6lp4EA8
         yTbFmwZe7X0zHB1muNlh590CUEDTbWVJG1BfWzYZnDM6+CW4Mon0jSC5HnphtUcUTQ
         AkwxDH6UKkJPQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, quic_alokad@quicinc.com,
        quic_msinada@quicinc.com
Subject: Re: [PATCH net] wifi: mac80211: Fix puncturing bitmap handling in __ieee80211_csa_finalize()
References: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
        <87mt2sppgs.fsf@kernel.org>
        <a94ce60d-423a-5f8e-5f8e-9b462854db54@wanadoo.fr>
Date:   Fri, 28 Apr 2023 11:46:48 +0300
In-Reply-To: <a94ce60d-423a-5f8e-5f8e-9b462854db54@wanadoo.fr> (Christophe
        JAILLET's message of "Fri, 28 Apr 2023 10:19:56 +0200")
Message-ID: <87pm7os8av.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> Le 28/04/2023 =C3=A0 07:04, Kalle Valo a =C3=A9crit=C2=A0:
>> Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gma=
ne.org> writes:
>>
>>> 'changed' can be OR'ed with BSS_CHANGED_EHT_PUNCTURING which is larger =
than
>>> an u32.
>>> So, turn 'changed' into an u64 and update ieee80211_set_after_csa_beaco=
n()
>>> accordingly.
>>>
>>> In the commit in Fixes, only ieee80211_start_ap() was updated.
>>>
>>> Fixes: 2cc25e4b2a04 ("wifi: mac80211: configure puncturing bitmap")
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb=
5QawA@public.gmane.org>
>>
>> FWIW mac80211 patches go to wireless tree, not net.
>
> net/<something> or drivers/net/<something> goes to 'net'.
> drivers/net/wireless/<something> goes to 'wireless'.
>
> now:
> net/mac80211/ goes also to 'wireless' as well.
> ath11 and ath12 are special cases that goes to 'ath'.
>
> Based on the get_maintainer.pl, my last patch against drivers/isdn
> looks well suited to deserve a -net-next as well?
>
>
> without speaking of -next variations.
>
>
> How many other oddities are there?

Oddities? We have had separate wireless trees for something like 15
years now, so not a new thing :D

But we have also separate trees for most active wireless drivers. For
example, Felix has a tree for mt76, Intel for iwlwifi, I have for
ath9k/ath10k/ath11k/ath12k and so on.

> I try to make my best to add net or net-next.
> I could do the same with wireless. (I guess that there is also a
> wireless-next?)

Yes, there is also wireless-next.

> I can do it when rules are SIMPLE.
>
> Is there a place where ALL these "rules" are described?
> Could MAINTAINERS and scripts be instrumented for that?

The maintainers file should document what tree to use:

QUALCOMM ATHEROS ATH11K WIRELESS DRIVER
M:      Kalle Valo <kvalo@kernel.org>
L:      ath11k@lists.infradead.org
S:      Supported
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
F:      Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
F:      drivers/net/wireless/ath/ath11k/

If a wireless driver has no git tree then you can use the tree from the
top level entry:

NETWORKING DRIVERS (WIRELESS)
M:      Kalle Valo <kvalo@kernel.org>
L:      linux-wireless@vger.kernel.org
S:      Maintained
W:      https://wireless.wiki.kernel.org/
Q:      https://patchwork.kernel.org/project/linux-wireless/list/
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
F:      Documentation/devicetree/bindings/net/wireless/
F:      drivers/net/wireless/

But of course some of the entries could be out-of-date. Patches welcome
if you see those :)

> I DO understand that the easiest it is for maintainers, the better for
> them, but please stop asking for casual contributors to know that and
> follow your, not that easy to find or remember, rules.
>
> I'm tempt not to TRY to put the right branch in the subject of my
> commits anymore, because even when I try to do it right and follow
> simple rules for that, it is not enough and I'm WRONG.
>
> Most of my contributions are related to error handling paths.
> The remaining ones are mostly related to number of LoC reduction.
>
> Should my contributions be ignored because of the lack of tools to
> help me target the correct branch, then keep the bugs and keep the
> LoC.

I don't see anyone saying anything about ignoring your fixes, at least I
have always valued your fixes and I hope you can continue submitting
them.

> git log --oneline --author=3Djaillet --grep Fixes: drivers/net | wc -l
> 97
> git log --oneline --author=3Djaillet drivers/net | wc -l
> 341
>
> git log --oneline --author=3Djaillet --grep Fixes: net | wc -l
> 7
> git log --oneline --author=3Djaillet net | wc -l
> 327
>
> No hard feelings, but slightly upset.

No need to be upset really, this is just coordination between
maintainers so that we don't accidentally take wrong patches. Please
don't take it personally.

If you are not familiar with network trees, I have seen some
contributors just using '-next' without specifying the actual tree and
letting the maintainers deal with what tree to take it. I consider that
as a safe option.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
