Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FF45F5FF5
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJFENu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiJFENt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:13:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2684A5D0C8;
        Wed,  5 Oct 2022 21:13:36 -0700 (PDT)
Received: from [192.168.1.9] (unknown [110.225.191.76])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6AF3320D5F2F;
        Wed,  5 Oct 2022 21:13:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6AF3320D5F2F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1665029615;
        bh=Jk9C07usSWl1hRm56nMlcSu3Q9WBPTYD2ai756CsSxw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UHRrY9K1uylzO8Fi7JWePKUrHSL1dRD7anzMPMXIeXHom/622CxHh+M5cUbWN8jIt
         4oAfg7Jb/1ipcbQAdWSaug0lo3fvKTS5lfqRzFJJN2M6Sf0+kitfW4xKboQTJrwtFD
         qiGkHqDA7hf7LwoDmAoPwto5fIwPL1uo52nu44+c=
Subject: Re: [PATCH net] hv_netvsc: Fix race between VF offering and VF
 association message from host
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1664372913-26140-1-git-send-email-gauravkohli@linux.microsoft.com>
 <20220929192620.2fa1542f@kernel.org>
 <PH7PR21MB31166EEAA957F467D953D1C1CA569@PH7PR21MB3116.namprd21.prod.outlook.com>
From:   Gaurav Kohli <gauravkohli@linux.microsoft.com>
Message-ID: <c118bbfa-7e55-333c-b8b1-91d6fb0536ac@linux.microsoft.com>
Date:   Thu, 6 Oct 2022 09:43:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <PH7PR21MB31166EEAA957F467D953D1C1CA569@PH7PR21MB3116.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-21.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/30/2022 6:33 PM, Haiyang Zhang wrote:
>
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Thursday, September 29, 2022 10:26 PM
>> To: Gaurav Kohli <gauravkohli@linux.microsoft.com>
>> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
>> <haiyangz@microsoft.com>; Stephen Hemminger
>> <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
>> <decui@microsoft.com>; linux-hyperv@vger.kernel.org;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH net] hv_netvsc: Fix race between VF offering and VF
>> association message from host
>>
>> On Wed, 28 Sep 2022 06:48:33 -0700 Gaurav Kohli wrote:
>>> During vm boot, there might be possibility that vf registration
>>> call comes before the vf association from host to vm.
>>>
>>> And this might break netvsc vf path, To prevent the same block
>>> vf registration until vf bind message comes from host.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
>>> Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
>> Is it possible to add a timeout or such? Waiting for an external
>> event while holding rtnl lock seems a little scary.
> We used to have time-out in many places of this driver. But there is
> no protocol guarantees of the host response time, so the time out value
> cannot be set. These time-outs were removed several years ago.
>
>
>> The other question is - what protects the completion and ->vf_alloc
>> from races? Is there some locking? ->vf_alloc only goes from 0 to 1
>> and never back?

Thanks for the comment, i understand your concern for vf_alloc and 
reinit completion part, I think

we can move reinit completion to unregistration part of vf code.

Let me send v2 patch.

> When Vf is removed, the vf_assoc msg will set it to 0 here:
>          net_device_ctx->vf_alloc = nvmsg->msg.v4_msg.vf_assoc.allocated;
>          net_device_ctx->vf_serial = nvmsg->msg.v4_msg.vf_assoc.serial;
>
> Also, I think this condition can be changed from:
> +	if (vf_is_up && !net_device_ctx->vf_alloc) {

Thanks for the comment.

This is needed to maintain state machine, as netvsc change event can 
comes multiple time. That's why i have put

extra check to avoid any deadlock.

> to:
> +	if (vf_is_up) {
> So when VF comes up, it always wait for the completion without depending
> on the vf_alloc.
>
> Thanks,
> - Haiyang
