Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD4C5A4733
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiH2KcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiH2KcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:32:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C54858B7D;
        Mon, 29 Aug 2022 03:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB1BF6108B;
        Mon, 29 Aug 2022 10:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60AAC433D6;
        Mon, 29 Aug 2022 10:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661769132;
        bh=TR5k2Yh8gwGWFbzhitEfL7Rh1/zEpiSLk+TrzVaWXOI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HTMjuFBy6+vGraHsxJBXt61FOrZE16rCSuDIX7J9zsNP2dAfbVPhBN2fCuk+cUc6p
         XzIGM35vwf3hugYZM/x+xlkdAOEEgAQQymtIi+eiuEszD0cssDnMZ6EBKOJpy64nyw
         VZocptAW0fki4n5/eIVIPYhc+LchLbDuMu7IXvxjqfi2PHHHbFreCrgxkZesagAzqD
         02vg4VIaL/JIfX8D+TgaSN/MQmVD1CpDflxZSBDbXeGX5/S7Tvi39cnVClOUyeiAvH
         RCfc3377H6dALCZXOiswrcwKSUxQZffetMqzbCnn4umcysouB99Bq7hc5i6FfBwqt4
         bQ5uw3PFBmo8w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Mazin Al Haddad <mazinalhaddad05@gmail.com>
Cc:     pontus.fuchs@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] ar5523: check endpoints type and direction in probe()
References: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
Date:   Mon, 29 Aug 2022 13:32:06 +0300
In-Reply-To: <20220827110148.203104-1-mazinalhaddad05@gmail.com> (Mazin Al
        Haddad's message of "Sat, 27 Aug 2022 14:01:49 +0300")
Message-ID: <871qszibmh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mazin Al Haddad <mazinalhaddad05@gmail.com> writes:

> Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
> due to the wrong endpoint type. There is no check for both the number
> of endpoints and the type.
>
> Fix it by adding a check for the number of endpoints and the
> direction/type of the endpoints. If the endpoints do not match -ENODEV is
> returned.
>
> usb 1-1: BOGUS urb xfer, pipe 3 != type 1
> WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
> Modules linked in:
> CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150-g32f02a211b0a #0
> Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  <TASK>
>  ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
>  ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
>  ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
>  ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1655
>
> Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
> Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
> Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>

Has this been tested on a real ar5523 hardware?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
