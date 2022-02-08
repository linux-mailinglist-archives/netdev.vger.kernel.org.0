Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEB4ADBA0
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378494AbiBHOyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378492AbiBHOy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:54:29 -0500
X-Greylist: delayed 422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 06:54:27 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2002::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65B4C061576;
        Tue,  8 Feb 2022 06:54:27 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1644331641; bh=8Tibnb0HPy/7mdHJBFIbL6WT6EKCaNnLV6FVMpD0DPA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BJLE3F6jy5fODGAPjKKNfRmbANEnR0XP6yo9kopb13WZwtQ7LkA/HEwCKjuhQxOiP
         34wnF4UNA82IshvjpJdHQppx0uo0fse3Rhbw8WbcJLUc/yqgUcGRxSZ0NAXzKO8VvM
         0A+rSOtOjaxssX9WCa+brWeYpX8Jvj440lVirFIl1YAkIFtn+HgoUSwtPUMnvOUz+n
         2TzqSm1arCnaB8rqqq7c2rcihL9rympSVmx/zKSGZ/6ekb6kihrjd9Np8ne0uvcypc
         gewk13AhxBMeHTnsiQxnEzsuG5HZWnL6WN+kyvvZVVAAT2/SYgQSPKAvoU4no4cps5
         C3OnaIk2snLDw==
To:     Pavel Skripkin <paskripkin@gmail.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
Date:   Tue, 08 Feb 2022 15:47:20 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h799a007.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv = priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()		   <--- priv pointer is freed
>
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.

I'm not too familiar with how the initialisation flow of an ath9k_htc
device works. Looking at htc_handle->drv_priv there seems to
be three other functions apart from the stat counters that dereference
it:

ath9k_htc_suspend()
ath9k_htc_resume()
ath9k_hif_usb_disconnect()

What guarantees that none of these will be called midway through
ath9k_htc_probe_device() (which would lead to a NULL deref after this
change)?

-Toke
