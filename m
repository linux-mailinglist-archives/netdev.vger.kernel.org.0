Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7132F6E9DAE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjDTVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTVJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:09:58 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C3D1;
        Thu, 20 Apr 2023 14:09:56 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682024993; bh=e/+N2oFyRcFf1leQm0okZY38id+c7Uk4APOwA1A79GA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZpN9C5TDA5nNRpPvLpb0I6VQyKze6wtjkuje/bvI+vCVIqOMWRn8uLWtE4cdsbNkh
         9uJ+QdRCbzTdpymslBNXH8tOuEh47CQuU3MIRfj6Amk/5M3T9ZAvkobSiqp1SjO1a8
         APtEdFA76SZXsXp4SdOJam2tJiTxEcjcqsOvY5VSagqtk0wH33Y/rMzME++2vuFIqW
         UbbkGakiUuu6ZND877pnCmwHpKhSjoYKFF0mLwa18/Rw/4CrR056jLHs061Rlrn5nM
         kaObEyR7xXowlWj5vmHTOFSH+Lh8gfSMvP+2XHsYYcY/cVwXBAWFVTgo5bQ68fuLhM
         J6tYADf61+F7Q==
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: One-off regression fix for 6.3 [was: Re: [PATCH] wifi: ath9k: Don't
 mark channelmap stack variable read-only in
 ath9k_mci_update_wlan_channels()]
In-Reply-To: <20230413214118.153781-1-toke@toke.dk>
References: <20230413214118.153781-1-toke@toke.dk>
Date:   Thu, 20 Apr 2023 23:09:52 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zg72s1jz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.
>
> Turns out the channelmap variable is not actually read-only, it's modified
> through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
> so making it read-only causes page faults when that code is hit.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217183
> Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap s=
tatic const")
> Cc: stable@vger.kernel.org
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

Hi Linus

Thorsten already pulled you into the thread further down, but I figured
I'd do this writeup anyway so you have the full context:

The patch quoted above[0] fixes a regression in the ath9k driver that was
introduced in 6.2, which causes a kernel BUG() whenever the "Bluetooth
co-existence" feature in the driver is enabled (which seems to be the
default on at least some systems).

Because of unfortunate timing (caused by an impedance mismatch between
the wireless tree and the -net tree, and my failure to realise this and
push it directly to -net), this patch did not make it into this week's
network tree pull request to you. Which means that unless you decide to
do an -rc8, this regression will also be in the 6.3 release, and it may
take several more weeks before the fix makes it into a stable release.

So, with a bit of prodding from Thorsten, I'm writing this to ask you if
you'd be willing to pull this patch directly from the mailing list as a
one-off? It's a fairly small patch, and since it's a (partial) revert
the risk of it being the cause of new regressions should be fairly
small. One of the reporters on the Bugzilla (linked above) confirmed
that the patch does indeed fix the regression.

In case you *don't* want to take this patch directly, Jakub has agreed
to pull it directly into -net, in which case it'll land in your tree via
the next networking pull request. Either way, as indicated by the
sibling thread Thorsten Cc'ed you on, we'll take your opinion on the
best way to handle this into account in the future. Just let us know :)

Thanks,
-Toke


[0] Direct Lore link: https://lore.kernel.org/r/20230413214118.153781-1-tok=
e@toke.dk
