Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B801F6D9299
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjDFJX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjDFJX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:23:57 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD6F3A9E;
        Thu,  6 Apr 2023 02:23:54 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:19a8:0:640:4e87:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 68E5F602AF;
        Thu,  6 Apr 2023 12:23:52 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b504::1:9] (unknown [2a02:6b8:b081:b504::1:9])
        by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id nNM3QE0OluQ0-KY8768Iu;
        Thu, 06 Apr 2023 12:23:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680773031; bh=KJfF7t9AjiWjMeD41d7nPe3pA8fTgHIR4sqnkzECg9o=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=hidYdy4UwRZAkB2iKVLtbbjtOaWj6ZaRLd7fvMPdGGXjExlX282wW7wtZ5A5d/JTk
         cbW2ioNuakg6AT/5/ZfIWdqE5jVg3yEtZ5ZDC9IdZ7a/MMzgwpaI+j3z69jErUgWgK
         sPcU44l1fN/8hci82M7e/WL0ZkyRN553vzB/P4gk=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <32f18da1-eeb9-3cd6-398d-77f76596b7c3@yandex-team.ru>
Date:   Thu, 6 Apr 2023 12:23:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
To:     Simon Horman <simon.horman@corigine.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
References: <ZC1x57v1JdUyK7aG@corigine.com>
 <20230405193708.GA3632282@bhelgaas> <ZC5uyOt7mevNyS6f@corigine.com>
Content-Language: en-US
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <ZC5uyOt7mevNyS6f@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06.04.2023 10:03, Simon Horman wrote:
> On Wed, Apr 05, 2023 at 02:37:08PM -0500, Bjorn Helgaas wrote:
>> On Wed, Apr 05, 2023 at 03:04:39PM +0200, Simon Horman wrote:
>>> On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
>>>> On 31.03.2023 20:52, Simon Horman wrote:
>>>>> On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
>>>>>> Static code analyzer complains to unchecked return value.
>>>>>> It seems that pci_reset_function return something meaningful
>>>>>> only if "reset_methods" is set.
>>>>>> Even if reset_methods isn't used check the return value to avoid
>>>>>> possible bugs leading to undefined behavior in the future.
>>>>>>
>>>>>> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
>>>>> nit: The tree this patch is targeted at should be designated, probably
>>>>>        net-next, so the '[PATCH net-next]' in the subject.
>>>>>
>>>>>> ---
>>>>>>    drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
>>>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>>>>>> index 87f76bac2e463..39ecfc1a1dbd0 100644
>>>>>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>>>>>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>>>>>> @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
>>>>>>    	int i, err, ring;
>>>>>>    	if (dev->flags & QLCNIC_NEED_FLR) {
>>>>>> -		pci_reset_function(dev->pdev);
>>>>>> +		err = pci_reset_function(dev->pdev);
>>>>>> +		if (err && err != -ENOTTY)
>>>>> Are you sure about the -ENOTTY part?
>>>>>
>>>>> It seems odd to me that an FLR would be required but reset is not supported.
>>>> No, I'm not sure. My logic is: if the reset method isn't set than
>>>> pci_reset_function() returns -ENOTTY so treat that result as ok.
>>>> pci_reset_function may return something different than -ENOTTY only if
>>>> pci_reset_fn_methods[m].reset_fn is set.
>>> I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
>>> I think my main question is if that can ever happen.
>>> If that is unknown, then I think this conservative approach makes sense.
>> The commit log mentions "reset_methods", which I don't think is really
>> relevant here because reset_methods is an internal implementation
>> detail.  The point is that pci_reset_function() returns 0 if it was
>> successful and a negative value if it failed.
>>
>> If the driver thinks the device needs to be reset, ignoring any
>> negative return value seems like a mistake because the device was not
>> reset.
>>
>> If the reset is required for a firmware update to take effect, maybe a
>> diagnostic would be helpful if it fails, e.g., the other "Adapter
>> initialization failed.  Please reboot" messages.
>>
>> "QLCNIC_NEED_FLR" suggests that the driver expects an FLR (as opposed
>> to other kinds of reset).  If the driver knows that all qlcnic devices
>> support FLR, it could use pcie_flr() directly.
>>
>> pci_reset_function() does have the possibility that the reset works on
>> some devices but not all.  Secondary Bus Reset fails if there are
>> other functions on the same bus, e.g., a multi-function device.  And
>> there's some value in doing the reset the same way in all cases.
>>
>> So I would suggest something like:
>>
>>    if (dev->flags & QLCNIC_NEED_FLR) {
>>      err = pcie_flr(dev->pdev);
>>      if (err) {
>>        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
>>        return err;
>>      }
>>      dev->flags &= ~QLCNIC_NEED_FLR;
>>    }
>>
>> Or, if there are qlcnic devices that don't support FLR:
>>
>>    if (dev->flags & QLCNIC_NEED_FLR) {
>>      err = pci_reset_function(dev->pdev);
>>      if (err) {
>>        dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
>>        return err;
>>      }
>>      dev->flags &= ~QLCNIC_NEED_FLR;
>>    }
> Thanks Bjorn,
>
> that is very helpful.
>
> I think that in order to move to option #1 some information would be needed
> from those familiar with the device(s). As it is a more invasive change -
> pci_reset_function -> pcie_flr.
>
> So my feeling is that, in lieu of such feedback, option #2 is a good
> improvement on the current code.
>
> OTOH, this driver is 'Supported' as opposed to 'Maintained'.
> So perhaps we can just use our best judgement and go for option #1.

So, it looks like option #2 is the safest choice as we do reset only if 
FLR is needed (when pci_reset_function() makes sense)

If all agree with that I'll re-send the path


