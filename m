Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A984F1AC7
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379072AbiDDVSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379285AbiDDQxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E023B032;
        Mon,  4 Apr 2022 09:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E82160DBC;
        Mon,  4 Apr 2022 16:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF3AC340EE;
        Mon,  4 Apr 2022 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649091083;
        bh=0bh6tgeWrV6jjXz4an0tH+2Fm7IC79r94QHSjTTYizg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SzHqFfKCWYDzEtYwvxuBw1O026/x4UNrHPbqWBBvEqsH3XKPeaigYqDfzDfeR6y1f
         /KYDcs8Jnyu/qmti7lJGLW3C0eONEUZ1cp10t+8pzJQ9qW4bfHF8QAyEDQ0fUCp+Zq
         B7Sucg4RitfcjnrTsF0JrY1W1SJ1F2WdHFhHVBxNZJ10EX7YIGcRRfYsxZGUMG+xhO
         kxRG6LgacZEjeNY97G0Vcglq+E3XoA0SU54X6izDtzeA26Cdf9btWB8RbHod1uhdKT
         98svNsanspmPNPf3m6w2CxrEc02b2htKumn7+vzILhZkqDlB9xvyUMilKsOGVl9Mok
         ZIpI9SQsylqSA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Michael Straube <straube.linux@gmail.com>
Cc:     Robert Marko <robert.marko@sartura.hr>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath11k: do not return random value
References: <20220404105324.13810-1-straube.linux@gmail.com>
        <CA+HBbNHEK=CbyeeyPG=s=D2xofdSbk8Lxx5R9nij_cp6t7ybDA@mail.gmail.com>
        <1bd30dce-4046-721b-2207-32ace83af441@gmail.com>
Date:   Mon, 04 Apr 2022 19:51:16 +0300
In-Reply-To: <1bd30dce-4046-721b-2207-32ace83af441@gmail.com> (Michael
        Straube's message of "Mon, 4 Apr 2022 18:45:11 +0200")
Message-ID: <87ilrossfv.fsf@kernel.org>
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

Michael Straube <straube.linux@gmail.com> writes:

> On 4/4/22 18:35, Robert Marko wrote:
>> On Mon, Apr 4, 2022 at 12:54 PM Michael Straube <straube.linux@gmail.com> wrote:
>>>
>>> Function ath11k_qmi_assign_target_mem_chunk() returns a random value
>>> if of_parse_phandle() fails because the return variable ret is not
>>> initialized before calling of_parse_phandle(). Return -EINVAL to avoid
>>> possibly returning 0, which would be wrong here.
>>>
>>> Issue found by smatch.
>>>
>>> Signed-off-by: Michael Straube <straube.linux@gmail.com>
>>> ---
>>>   drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
>>> index 65d3c6ba35ae..81b2304b1fde 100644
>>> --- a/drivers/net/wireless/ath/ath11k/qmi.c
>>> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
>>> @@ -1932,7 +1932,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
>>>                          if (!hremote_node) {
>>>                                  ath11k_dbg(ab, ATH11K_DBG_QMI,
>>>                                             "qmi fail to get hremote_node\n");
>>> -                               return ret;
>>> +                               return -EINVAL;
>>>                          }
>>>
>>>                          ret = of_address_to_resource(hremote_node, 0, &res);
>>> --
>>> 2.35.1
>>
>> Hi Michael,
>> This is already solved in ath-next and 5.18-rc1:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath11k/qmi.c?h=v5.18-rc1&id=c9b41832dc080fa59bad597de94865b3ea2d5bab
>>
>
> Hi Robert,
>
> Ah ok, then I worked with the wrong tree (wireless-drivers-next).
> Sorry for the noise.

wireless-drivers[-next] and mac80211[-next] trees are not in use
anymore, we switched to using a common wireless and wireless-next trees:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
