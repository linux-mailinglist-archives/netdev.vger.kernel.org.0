Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94769546C5E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiFJSah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiFJSae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:30:34 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2802C5;
        Fri, 10 Jun 2022 11:30:27 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1654885826; bh=dOSCXQzjwFZEV1hoFi4ArTidngE1DKbmjXVs1mcXVcg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=aqhRyPIiKsPK42HW/NX/UIAYh+aylE5Ic8jQgrIdJcroEywr0V6qE1ON9PQMwQ5+i
         yImQg8BfoKPHraTzMO/Jo43IGI5RgWsTBKrdRMivwArAUFb0ONMMn1mlKT1XSWj6d0
         Q2Ej7/hmrzisVeXzqdF6LUDeRBepZROZP6Fs9uyFxNKOyOlzIXlkHyrTbKImli5yCb
         kV7AB0dgqR6dSs9E46Z/f62mweqRtDdgqVe4l4ClN+a4KeBOqGBJ36Ig6amQKpmi8j
         qD4zkdSi3i4e327++AarwUq16hPnuH0iG3DhyUCOzDKDeK74FK4NCFOQugEtdo7tZs
         8m4h6PdY54c2g==
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v5 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <87bkv0vg2p.wl-tiwai@suse.de>
References: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
 <87bkv0vg2p.wl-tiwai@suse.de>
Date:   Fri, 10 Jun 2022 20:30:25 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r13w2wxq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> On Sat, 21 May 2022 23:28:01 +0200,
> Pavel Skripkin wrote:
>> 
>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
>> problem was in incorrect htc_handle->drv_priv initialization.
>> 
>> Probable call trace which can trigger use-after-free:
>> 
>> ath9k_htc_probe_device()
>>   /* htc_handle->drv_priv = priv; */
>>   ath9k_htc_wait_for_target()      <--- Failed
>>   ieee80211_free_hw()		   <--- priv pointer is freed
>> 
>> <IRQ>
>> ...
>> ath9k_hif_usb_rx_cb()
>>   ath9k_hif_usb_rx_stream()
>>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>> 
>> In order to not add fancy protection for drv_priv we can move
>> htc_handle->drv_priv initialization at the end of the
>> ath9k_htc_probe_device() and add helper macro to make
>> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
>> deref in that macros [1]
>> 
>> Link: https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60 [0]
>> Link: https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de [1]
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>
> Hi Toke, any update on this?

It's marked as "Changes Requested" in patchwork, due to the kernel test
robot comments on patch 2[0]. So it's waiting for Pavel to resubmit
fixing that. There's also a separate comment on patch 1, which I just
noticed didn't have the mailing list in Cc; will reply to that and try
to get it back on the list.

> I'm asking it because this is a fix for a security issue
> (CVE-2022-1679 [*]), and distros have been waiting for the fix getting
> merged to the upstream for weeks.
>
> [*] https://nvd.nist.gov/vuln/detail/CVE-2022-1679

In general, if a patch is marked as "changes requested", the right thing
to do is to bug the submitter to resubmit. Which I guess you just did,
so hopefully we'll get an update soon :)

-Toke

[0] https://patchwork.kernel.org/project/linux-wireless/patch/7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com/

