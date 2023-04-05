Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381B16D79A6
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbjDEK1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDEK1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC0D30CD;
        Wed,  5 Apr 2023 03:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03197638AB;
        Wed,  5 Apr 2023 10:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9A6C433EF;
        Wed,  5 Apr 2023 10:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680690449;
        bh=mJHD/VmsgZklSSL4AaouJi3AwiQtaNWYzxCEFaUka70=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mbRsBO9aff5Hb6WL19C4UI9wRlNWvVrXtTCfn/L992N0BzD+Pgeq6B9jIL8rYkYG2
         YLxV1zanFLuvnp4m597gFkPh5sOuoDDj/eBCz9Ege0AXIfuyv4+dPqAPL0t0ApFR3u
         EeUvzEiDQez5SI6ymVhtQXWqv9ax0ZzD2pRmg+9KRxGJygNhB4JBZR2XhIOntBxqr9
         qoWiLSMS4Jxww/BadE1sHi5I7Z7pP2oGZyd6lov9oNB4POv4Ki9YpgSh+To+RZqgub
         RLqdmRNqv8xSxWyoLqDfSKpI02lL11NWHctOzgEY3QN7B9ZcillipIp1Oj1uDzcyLe
         EbtOn4NDM5qiQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: Add a warning for wcn6855 spurious wakeup events
References: <20230220213807.28523-1-mario.limonciello@amd.com>
        <87r0ubqo81.fsf@kernel.org>
        <980959ea-b72f-4cc0-7662-4dd64932d005@amd.com>
        <87mt4zqmgh.fsf@kernel.org>
        <805fe9f0-7dbf-4483-9281-072db3765ff6@amd.com>
Date:   Wed, 05 Apr 2023 13:27:22 +0300
In-Reply-To: <805fe9f0-7dbf-4483-9281-072db3765ff6@amd.com> (Mario
        Limonciello's message of "Mon, 27 Feb 2023 07:19:10 -0600")
Message-ID: <87lej6aak5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mario Limonciello <mario.limonciello@amd.com> writes:

> On 2/27/23 07:14, Kalle Valo wrote:
>
>> Mario Limonciello <mario.limonciello@amd.com> writes:
>>
>>> On 2/27/23 06:36, Kalle Valo wrote:
>>>
>>>> Mario Limonciello <mario.limonciello@amd.com> writes:
>>>>
>>>>> +static void ath11k_check_s2idle_bug(struct ath11k_base *ab)
>>>>> +{
>>>>> +	struct pci_dev *rdev;
>>>>> +
>>>>> +	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE)
>>>>> +		return;
>>>>> +
>>>>> +	if (ab->id.device != WCN6855_DEVICE_ID)
>>>>> +		return;
>>>>> +
>>>>> +	if (ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER)
>>>>> +		return;
>>>>> +
>>>>> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>>>>> +	if (rdev->vendor == PCI_VENDOR_ID_AMD)
>>>>> + ath11k_warn(ab, "fw_version 0x%x may cause spurious wakeups.
>>>>> Upgrade to 0x%x or later.",
>>>>> +			    ab->qmi.target.fw_version, WCN6855_S2IDLE_VER);
>>>>
>>>> I understand the reasons for this warning but I don't really trust the
>>>> check 'ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER'. I don't know
>>>> how the firmware team populates the fw_version so I'm worried that if we
>>>> ever switch to a different firmware branch (or similar) this warning
>>>> might all of sudden start triggering for the users.
>>>>
>>>
>>> In that case, maybe would it be better to just have a list of the
>>> public firmware with issue and ensure it doesn't match one of those?
>>
>> You mean ath11k checking for known broken versions and reporting that?
>> We have so many different firmwares to support in ath11k, I'm not really
>> keen on adding tests for a specific version.
>
> I checked and only found a total of 7 firmware versions published for
> WCN6855 at your ath11k-firmware repo.  I'm not sure how many went to
> linux-firmware.  But it seems like a relatively small list to have.

ath11k supports also other hardware families than just WCN6855, so there
are a lot of different firmware versions and branches.

>> We have a list of known important bugs in the wiki:
>>
>> https://wireless.wiki.kernel.org/en/users/drivers/ath11k#known_bugslimitations
>>
>> What about adding the issue there, would that get more exposure to the
>> bug and hopefully the users would upgrade the firmware?
>>
>
> The problem is when this happens users have no way to know it's even
> caused by wireless.  So why would they go looking at the wireless
> wiki?
>
> The GPIO used for WLAN is different from design to design so we can't
> put it in the GPIO driver.  There are plenty of designs that have
> valid reasons to wakeup from other GPIOs as well so it can't just be
> the GPIO driver IRQ.

I understand your problem but my problem is that I have three Qualcomm
drivers to support and that's a major challenge itself. So I try to keep
the drivers as simple as possible and avoid any hacks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
