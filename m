Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2B522FF6
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbiEKJyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbiEKJyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:54:00 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388528CCCD;
        Wed, 11 May 2022 02:53:25 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652262803; bh=+1U3flpqWJAv5df7SW1MN/dDT5tlFWQa/zIqHpVu/94=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pQ4WE1MiEekSRpCqyLnNMJUfVxyA1jwmuXHXtesfricLrC9TjnPKYNsu5d2h+VyR9
         eZl9AJWS12FQUnBC9g6O/kcq9wwh0KlLGd1Y4ZJTTIuaUyDeA7IMRGotSrZPbWb8ZP
         F9EmvtYZK7UUfH0OZqvzjFlPoiLVrgrTn5f8wkTH7UzEZhlDYRyhDEzDDUvkhhlNVN
         1jrz2yiKw1fDXrOPiOo8k/U2cOYgsL4yMMqwZmzIO2T/LbcjdIiSJqTkWEU75mjtbx
         IlfELp6+Gv75kMPpo2rbLAoQrGPCZP3MJ5RPr+PMU9vqSd55xl/1UfXvZl3zH6phDZ
         bvOCm1vlX2xcQ==
To:     Kalle Valo <kvalo@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <87ilqc7jv9.fsf@kernel.org>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk> <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
 <5fd22dda-01d6-cfae-3458-cb3fa23eb84d@I-love.SAKURA.ne.jp>
 <3cb712d9-c6be-94b7-6135-10b0eabba341@gmail.com>
 <d9e6cf88-4f19-bd50-3d73-e2aee1caefa4@I-love.SAKURA.ne.jp>
 <426f6965-152c-6d59-90e0-34fe3cd208ee@gmail.com>
 <87ilqc7jv9.fsf@kernel.org>
Date:   Wed, 11 May 2022 11:53:23 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o804wg30.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Pavel Skripkin <paskripkin@gmail.com> writes:
>
>> Hi Tetsuo,
>>
>> On 5/6/22 02:31, Tetsuo Handa wrote:
>>> On 2022/05/06 4:09, Pavel Skripkin wrote:
>>>>>> And we can meet NULL defer even if we leave drv_priv = priv initialization
>>>>>> on it's place.
>>>>>
>>>>> I didn't catch the location. As long as "htc_handle->drv_priv = priv;" is done
>>>>> before complete_all(&hif_dev->fw_done) is done, is something wrong?
>>>>>
>>>>
>>>> I don't really remember why I said that, but looks like I just haven't opened callbacks' code.
>>>
>>> OK. Then, why not accept Pavel's patch?
>>
>> As you might expect, I have same question. This series is under review
>> for like 7-8 months.
>>
>> I have no ath9 device, so I can't test it on real hw, so somebody else
>> should do it for me. It's requirement to get patch accepted.
>
> As Toke stepped up to be the ath9k maintainer the situation with ath9k
> is now much better. I recommend resubmitting any ath9k patches you might
> have.

No need to resubmit this one, it's still in patchwork waiting for me to
take a closer look. I have a conference this week, but should hopefully
have some time for this next week.

-Toke
