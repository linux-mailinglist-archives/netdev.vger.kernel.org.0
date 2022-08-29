Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D8B5A425F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiH2FhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2FhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFB919C1B;
        Sun, 28 Aug 2022 22:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD6461011;
        Mon, 29 Aug 2022 05:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1177C433D6;
        Mon, 29 Aug 2022 05:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661751431;
        bh=AQA+8MVuBm1m9fzmtwrEJo7mlb2Azsxin4LYiGaKpIk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=p/Suk4mvkxPk6oTLabA8smQe8SbKHOag2bcZg714x36x6ojtqwmjvvZb1QRS5YGXM
         6rFXIzNH9Va92lj5EOnBENdtfG1PPM9uFyTBNngnwI0eylYhpMVBZqpB5KXCUS4mvO
         nWc4O2c/dPtFehR598n/yoAIjBzHs00NFxdRLKlSUyUvE9PFeXnYl7rXUS5Y/d2/p4
         wRK8SbLdCWNbb6aLRLKNMqys88naJm4trVL9ZLvvBpYPl3bmuPEpuOme4+IhFOga2b
         mfbOKSIGGzBO+eySpnVnLhcO0hjebvwbi09AEQq4mcoDvUgmlIAZBNsSZlE9NcgHoL
         0M+ncqbY5CtNw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Alexander Potapenko <glider@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        phil@philpotter.co.uk, ath9k-devel@qca.qualcomm.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
References: <000000000000c98a7f05ac744f53@google.com>
        <000000000000734fe705acb9f3a2@google.com>
        <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
        <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
        <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
        <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
        <878rnc8ghv.fsf@toke.dk>
Date:   Mon, 29 Aug 2022 08:36:57 +0300
In-Reply-To: <878rnc8ghv.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Thu, 25 Aug 2022 17:55:40 +0200")
Message-ID: <87a67nhapy.fsf@kernel.org>
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

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Alexander Potapenko <glider@google.com> writes:
>
>> On Thu, Aug 25, 2022 at 4:34 PM Tetsuo Handa
>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>>
>>> Hello.
>> Hi Tetsuo,
>>
>>> I found that your patch was applied. But since the reproducer tested on=
ly 0 byte
>>> case, I think that rejecting only less than sizeof(struct htc_frame_hdr=
) bytes
>>> is not sufficient.
>>>
>>> More complete patch with Ack from Toke is waiting at
>>> https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.S=
AKURA.ne.jp .
>>
>> Thanks for letting me know! I just checked that your patch indeed
>> fixes the issue I am facing.
>> If it is more complete, I think we'd indeed better use yours.
>
> FWIW, that patch is just waiting for Kalle to apply it, and I just
> noticed this whole thread has used his old email address, so updating
> that now as a gentle ping :)

I was on vacation but back now, I'll start processing patches soon.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
