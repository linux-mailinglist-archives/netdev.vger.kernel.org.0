Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DCA6459D4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLGMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLGMbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:31:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5693207B;
        Wed,  7 Dec 2022 04:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED3E61519;
        Wed,  7 Dec 2022 12:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F4FC433D7;
        Wed,  7 Dec 2022 12:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670416292;
        bh=UkMzw0tbIVX67R5rvmETsPo68VtR2uyuEugdjl+mUNI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HGN34TM2gk7sUENn8kyoRPkVtd2CEyC9d8gzaMKShcHssph0NZlBG0fBrpBNE09Ks
         WapRynOmW2jG+RrRL2v9Tdpr/CaHGE3E1SJD0G1ZlMaRbF8YWyzUfXv40jZGUX407k
         LdQ24ey/Bi2CtV4BiY9ePnVRxjDNo3jrNGN5P9QcuGKc7dgSyaqt/Jl0gj40kFF3JN
         RNj7crAa5/PK8GlM2J/F1nRj3Z+udQEjRx3RU6pn1sJ3/DgUYtpInaw1b/OwDWYRKV
         bJdwBrVYutxg0xnwCWP7llcUnZRykdGrJrh7dYwa/VGUiF4q3dC1nrf+FYqxL9H1g3
         iK+YCyXG1Jwyw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Jun ASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen\@gmail.com" <Jes.Sorensen@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "edumazet\@google.com" <edumazet@google.com>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "pabeni\@redhat.com" <pabeni@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
        <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
        <b4b65c74-792f-4df1-18bf-5c6f80845814@zzy040330.moe>
        <159ac3a296164b05b319bfb254a7901b@realtek.com>
Date:   Wed, 07 Dec 2022 14:31:28 +0200
In-Reply-To: <159ac3a296164b05b319bfb254a7901b@realtek.com> (Ping-Ke Shih's
        message of "Wed, 7 Dec 2022 03:55:16 +0000")
Message-ID: <87h6y7mm3j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

>> >> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>> >> issues for rtl8192eu chips by replacing the arguments with
>> >> the ones in the updated official driver as shown below.
>> >> 1. https://github.com/Mange/rtl8192eu-linux-driver
>> >> 2. vendor driver version: 5.6.4
>> >>
>> >> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> >> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>

The assumption is that the patch submitter tests the patches, so a
separate Tested-by tag is not needed. I'll remove it.

>> >> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
>> >> ---
>> >> v5:
>> >>   - no modification.
>> > Then, why do you need v5?
>> Well,=C2=A0 I just want to add the "Reviewed-By" line to the commit mess=
age.
>> Sorry for the noise if there is no need to do that.
>
> No need to add "Reviewed-By". Kalle will add it when this patch gets merg=
ed.

Yeah. And to be precise patchwork actually does that automatically, a
very nice feature :)

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
