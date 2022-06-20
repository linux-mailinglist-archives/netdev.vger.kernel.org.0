Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6C551367
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbiFTIxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbiFTIxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C925C0;
        Mon, 20 Jun 2022 01:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0F3C6134C;
        Mon, 20 Jun 2022 08:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B57C3411B;
        Mon, 20 Jun 2022 08:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655715202;
        bh=Rrqd1Yeke98p15uktS2BzGKl4OkqQfza+QpFIGTBpRE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Op8zM9P/al2z9e+G1jsHtyPvmo5WIqnXNPn/l3NobkVMpcPyvbGWPDxWAWLzhyGrC
         Nf6dZ2TSGILkxo4B7YdgI3729UKmQr1rKJyf89Igq6uyhVENRBmUgEH3c5xMtdwpxD
         NgueBui4tIHcyh7v6FEEGibj/XxDcxS0a4/ar8732KL/j6tnHaSXq/Ke0scc7T8u/A
         lKK2bt0AhsDtOeGQ0W6fdnYqfwnnng4/4Qg3uYblABuLkNcy6CRtQs50sLQadcWoZz
         /jzXFfCgpPjPY31NJRSrH2nClnB3fv2TMNx5bFlaw+C6Oj+fqf766A5HZD6s+8b11F
         JaIkMrilWgYjg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
        <87o7yvzf33.fsf@toke.dk> <87k09ipfl9.fsf@kernel.org>
        <87tu8mxpnz.fsf@toke.dk> <87sfo64781.wl-tiwai@suse.de>
Date:   Mon, 20 Jun 2022 11:53:17 +0300
In-Reply-To: <87sfo64781.wl-tiwai@suse.de> (Takashi Iwai's message of "Wed, 15
        Jun 2022 11:16:30 +0200")
Message-ID: <87fsjzpvgi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> On Wed, 15 Jun 2022 11:05:20 +0200,
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>>=20
>> Kalle Valo <kvalo@kernel.org> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>> >
>> >> Pavel Skripkin <paskripkin@gmail.com> writes:
>> >>
>> >>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
>> >>> problem was in incorrect htc_handle->drv_priv initialization.
>> >>>
>> >>> Probable call trace which can trigger use-after-free:
>> >>>
>> >>> ath9k_htc_probe_device()
>> >>>   /* htc_handle->drv_priv =3D priv; */
>> >>>   ath9k_htc_wait_for_target()      <--- Failed
>> >>>   ieee80211_free_hw()		   <--- priv pointer is freed
>> >>>
>> >>> <IRQ>
>> >>> ...
>> >>> ath9k_hif_usb_rx_cb()
>> >>>   ath9k_hif_usb_rx_stream()
>> >>>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>> >>>
>> >>> In order to not add fancy protection for drv_priv we can move
>> >>> htc_handle->drv_priv initialization at the end of the
>> >>> ath9k_htc_probe_device() and add helper macro to make
>> >>> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
>> >>> deref in that macros [1]
>> >>>
>> >>> Link: https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd=
121b4ce07cb665f60 [0]
>> >>> Link: https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8=
acbbacec91e9ee8de [1]
>> >>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> >>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspo=
tmail.com
>> >>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspo=
tmail.com
>> >>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> >>
>> >> Alright, since we've heard no more objections and the status quo is
>> >> definitely broken, let's get this merged and we can follow up with any
>> >> other fixes as necessary...
>> >>
>> >> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> >
>> > I'm wondering should these go to -rc or -next? Has anyone actually
>> > tested these with real hardware? (syzbot testing does not count) With
>> > the past bad experience with syzbot fixes I'm leaning towards -next to
>> > have more time to fix any regressions.
>>=20
>> Hmm, good question. From Takashi's comment on v5, it seems like distros
>> are going to backport it anyway, so in that sense it probably doesn't
>> matter that much?
>
> Well, it does matter if it really breaks things, of course ;)
>
>> In any case I think it has a fairly low probability of breaking real
>> users' setup (how often is that error path on setup even hit?), but I'm
>> OK with it going to -next to be doubleplus-sure :)
>
> Queuing to for-next is fine for us.  Backporting immediately or not
> will be a decision by each distro, then.=20
>
> OTOH, if anyone has tested it beforehand on a real hardware and
> confirmed, at least, that it works for normal cases (no error path),
> that should suffice for -rc inclusion, too, IMO.

Ok, I'll take these to -next then. I just don't like taking untested
patches, having them -next gives us more time to fix any issues (or
revert the patches).

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
