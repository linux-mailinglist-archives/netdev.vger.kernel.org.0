Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A169522B68
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 06:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiEKEvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 00:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiEKEvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 00:51:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E237A94;
        Tue, 10 May 2022 21:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B3BB8211A;
        Wed, 11 May 2022 04:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB600C385DB;
        Wed, 11 May 2022 04:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652244657;
        bh=LpwTYJ2bTlah3a8a15V9HoQ1uA7dwyzrw3H6Zhd1XFI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kU0waMTx5CInPR+QO0yRUXu1lPiXK6kQDtSkcO4BqoRl1y1/7bg16R1yAJrAJ8zmy
         fZn6snHY7mrGvBtNjI5/RMeYHvYbSQN/gDhR5atJtubwWTlizd/0z4b6QnJjGITdc2
         XOtPjUOkdPc0IJTthAHoOzXE3cMSD2wAd2Yw1iCqiPROGVPE2UhJ+v14kyBsX+jjuR
         ZgyHPYS9GaP/1JlNJyPNvZpsxmwP+j/fi4TGfZSy3Nzp9q9MZmS40TU6QQoNMyTPT+
         3OgRxwdXJFXpqBmgpMvoft1DSI/Ua6BHg5It2YWT1paynftZOvBI+bjY0F7bwZ+rd8
         /HmUgDdn98GYg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Toke =?utf-8?Q?H?= =?utf-8?Q?=C3=B8iland-J=C3=B8rgensen?= 
        <toke@toke.dk>, ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kuba@kernel.org, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
        <87h799a007.fsf@toke.dk>
        <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
        <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
        <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
        <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
        <426f6965-152c-6d59-90e0-34fe3cd208ee@gmail.com>
Date:   Wed, 11 May 2022 07:50:50 +0300
In-Reply-To: <426f6965-152c-6d59-90e0-34fe3cd208ee@gmail.com> (Pavel
        Skripkin's message of "Tue, 10 May 2022 22:26:38 +0300")
Message-ID: <87ilqc7jv9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Hi Tetsuo,
>
> On 5/6/22 02:31, Tetsuo Handa wrote:
>> On 2022/05/06 4:09, Pavel Skripkin wrote:
>>>>> And we can meet NULL defer even if we leave drv_priv = priv initialization
>>>>> on it's place.
>>>>
>>>> I didn't catch the location. As long as "htc_handle->drv_priv = priv;" is done
>>>> before complete_all(&hif_dev->fw_done) is done, is something wrong?
>>>>
>>>
>>> I don't really remember why I said that, but looks like I just haven't opened callbacks' code.
>>
>> OK. Then, why not accept Pavel's patch?
>
> As you might expect, I have same question. This series is under review
> for like 7-8 months.
>
> I have no ath9 device, so I can't test it on real hw, so somebody else
> should do it for me. It's requirement to get patch accepted.

As Toke stepped up to be the ath9k maintainer the situation with ath9k
is now much better. I recommend resubmitting any ath9k patches you might
have.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
