Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6980A52301D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiEKJ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238546AbiEKJ70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9991D5265;
        Wed, 11 May 2022 02:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAC58610A1;
        Wed, 11 May 2022 09:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A59CC340ED;
        Wed, 11 May 2022 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652263162;
        bh=vOXfSFnQKU6CvSkUUaYHX1wpKYWqy+uhhPgV4sbyp/k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VNcPKLUHpR9b6osKzjz4C/GzkZRM/gRsFZFgoZ9IWo75NenLPa6e8CEToLELCbAwD
         DiWqdZaJAkDwDbv0hW4jg2tVc1aBPtm9lpbGxvzefXx+iJf80ezjktSF1ErosZt17d
         0gG29TFLVHyjH/j0K7l7K1txRWg24PDkskJqj9BQDlvD4Q0ZCsTva6bHf+MJOYRXZF
         ZHYwy7CVYgAcwXq1emvCcHFNqaByjhqp2ayn9iRikJjKcxE+j4JHviAbV2+KvloPq/
         MZMaj/V3OW9rXXO+znzHk7p3WdWXg+SIyHzgxSKijTIDnNn33OzQtfvh+iqRvYKDJX
         XuTLqFrX8WeNg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        <87ilqc7jv9.fsf@kernel.org> <87o804wg30.fsf@toke.dk>
Date:   Wed, 11 May 2022 12:59:15 +0300
In-Reply-To: <87o804wg30.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Wed, 11 May 2022 11:53:23 +0200")
Message-ID: <87ee1075l8.fsf@kernel.org>
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

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Kalle Valo <kvalo@kernel.org> writes:
>
>> Pavel Skripkin <paskripkin@gmail.com> writes:
>>
>>> Hi Tetsuo,
>>>
>>> On 5/6/22 02:31, Tetsuo Handa wrote:
>>>> On 2022/05/06 4:09, Pavel Skripkin wrote:
>>>>>>> And we can meet NULL defer even if we leave drv_priv =3D priv initi=
alization
>>>>>>> on it's place.
>>>>>>
>>>>>> I didn't catch the location. As long as "htc_handle->drv_priv =3D pr=
iv;" is done
>>>>>> before complete_all(&hif_dev->fw_done) is done, is something wrong?
>>>>>>
>>>>>
>>>>> I don't really remember why I said that, but looks like I just
>>>>> haven't opened callbacks' code.
>>>>
>>>> OK. Then, why not accept Pavel's patch?
>>>
>>> As you might expect, I have same question. This series is under review
>>> for like 7-8 months.
>>>
>>> I have no ath9 device, so I can't test it on real hw, so somebody else
>>> should do it for me. It's requirement to get patch accepted.
>>
>> As Toke stepped up to be the ath9k maintainer the situation with ath9k
>> is now much better. I recommend resubmitting any ath9k patches you might
>> have.
>
> No need to resubmit this one, it's still in patchwork waiting for me to
> take a closer look.

Ah sorry, I thought this was something which was submitted 7-8 months
ago but I didn't check, I should have.

> I have a conference this week, but should hopefully have some time for
> this next week.

It's great to be able to start meeting people again, have a good one :)

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
