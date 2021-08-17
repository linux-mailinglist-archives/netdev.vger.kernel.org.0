Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B684D3EEAE6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhHQKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234093AbhHQKY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 06:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629195834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVL6PjYSm8HZfICGVEGITUmccKxblUq/VlCKoiWTgH8=;
        b=SFPCHVeEdR6k+TFalmrFV4vYrMAJ0BqEkA6+I0bz96caSf2RtuWYS/9/UbFHURgwF4RAmg
        dKghrqcUIlM4/BnCrKA/W55FLGmVH+ikMGY8NHyk5OFs52+TbK0EYKyT3/Ag9BRI8FiIy5
        s0F0lTUZIAyuMqgG6ezqBtf6c3eiTao=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-VWnej73RP1igp-7grtt_sQ-1; Tue, 17 Aug 2021 06:23:53 -0400
X-MC-Unique: VWnej73RP1igp-7grtt_sQ-1
Received: by mail-qv1-f69.google.com with SMTP id bc19-20020ad45693000000b0035ccbd692a2so6386221qvb.13
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 03:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iVL6PjYSm8HZfICGVEGITUmccKxblUq/VlCKoiWTgH8=;
        b=PJYbU4cZ79giteEFOCFDUdC3fTQXCm5L3CqpgD651sMW062izSzwrjZczUaz1pgKcu
         1jN3+9Zl9JKQ8+8t9ppoxd8SrWDoq8hVWr/6fqvF+JcUfmVnChDnFNxR3Oym3U1TlSFu
         St9vWnU5Voxos4O3EuC4gQ81QHBmHQhTZw/KIJdNl+iZtR8+oe3O/a8aH7qZNm5XrtAD
         eI4TimVqaNIiwV7N9a3Raae763ntNtB0zRihmUDgq2N56CsjQxKr9aPOoZoi1D06sc8s
         uN0LPN9oSF0YKzhi4tJJr8rDpLk9hHjVFqSLSZVlwFYsx97JAKSSBPB74DcXaf9oHk/w
         cuSA==
X-Gm-Message-State: AOAM531M8BYI3D0ONSYEKsdvihgNJnMOxIwJsBlkzaHmZjPEolOIiEGg
        w+VVkfqU1ylcZfoTx3X1p2hjokdzLljkRQrV50OJRQdffdQqisE2QSuC0ZlCo50oOvZ8nEbqg0O
        8980kntVln0yD5xED
X-Received: by 2002:a37:a20f:: with SMTP id l15mr3011870qke.24.1629195832724;
        Tue, 17 Aug 2021 03:23:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcXGANrGGlqmnmshjEjCIVJqTEninhOSb59+o2ZHUR3NYD/Tc3U8C6JMpqxm8Zewl+ER7uBQ==
X-Received: by 2002:a37:a20f:: with SMTP id l15mr3011852qke.24.1629195832542;
        Tue, 17 Aug 2021 03:23:52 -0700 (PDT)
Received: from [192.168.1.121] ([69.73.103.33])
        by smtp.gmail.com with ESMTPSA id b21sm760035qte.38.2021.08.17.03.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 03:23:52 -0700 (PDT)
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when setting
 sriov_numvfs to zero
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "Szlosek, Marek" <marek.szlosek@intel.com>,
        "Yang, Lihong" <lihong.yang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
References: <20210812171856.1867667-1-anthony.l.nguyen@intel.com>
 <20210813172033.2c5c9101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31f33e9ced63115b66ede5ff1e385105be076f15.camel@intel.com>
From:   Ken Cox <jkc@redhat.com>
Message-ID: <3176d23e-cc51-2855-7880-ca41779746e4@redhat.com>
Date:   Tue, 17 Aug 2021 05:23:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <31f33e9ced63115b66ede5ff1e385105be076f15.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/21 12:52 PM, Nguyen, Anthony L wrote:
> On Fri, 2021-08-13 at 17:20 -0700, Jakub Kicinski wrote:
>> On Thu, 12 Aug 2021 10:18:56 -0700 Tony Nguyen wrote:
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
>>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
>>> index 214a38de3f41..0a1a8756f1fd 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
>>> @@ -206,8 +206,12 @@ int ixgbe_disable_sriov(struct ixgbe_adapter
>>> *adapter)
>>>   	unsigned int num_vfs = adapter->num_vfs, vf;
>>>   	int rss;
>>>   
>>> +	while (test_and_set_bit(__IXGBE_DISABLING_VFS, &adapter-
>>>> state))
>>> +		usleep_range(1000, 2000);
>>> +
>>>   	/* set num VFs to 0 to prevent access to vfinfo */
>>>   	adapter->num_vfs = 0;
>>> +	clear_bit(__IXGBE_DISABLING_VFS, &adapter->state);
>>>   
>>>   	/* put the reference to all of the vf devices */
>>>   	for (vf = 0; vf < num_vfs; ++vf) {
>>> @@ -1307,6 +1311,9 @@ void ixgbe_msg_task(struct ixgbe_adapter
>>> *adapter)
>>>   	struct ixgbe_hw *hw = &adapter->hw;
>>>   	u32 vf;
>>>   
>>> +	if (test_and_set_bit(__IXGBE_DISABLING_VFS, &adapter->state))
>>> +		return;
>>> +
>>>   	for (vf = 0; vf < adapter->num_vfs; vf++) {
>>>   		/* process any reset requests */
>>>   		if (!ixgbe_check_for_rst(hw, vf))
>>> @@ -1320,6 +1327,7 @@ void ixgbe_msg_task(struct ixgbe_adapter
>>> *adapter)
>>>   		if (!ixgbe_check_for_ack(hw, vf))
>>>   			ixgbe_rcv_ack_from_vf(adapter, vf);
>>>   	}
>>> +	clear_bit(__IXGBE_DISABLING_VFS, &adapter->state);
>>
>> Like I've already said two or three times. No flag based locking.
> 
> Ken,
> 
> Did you want to make this change or did you want Intel to do it?

Hi Tony,

It would be great if Intel could make the change for the locking.

Thanks,
Ken

