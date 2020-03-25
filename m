Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC7192212
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCYICR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 04:02:17 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42593 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCYICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:02:17 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 63C44CECCA;
        Wed, 25 Mar 2020 09:11:47 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CALWDO_Uc6brpXmVfoUd+jgyy_F0-WSrYb1+hXtXm498dGzCOSg@mail.gmail.com>
Date:   Wed, 25 Mar 2020 09:02:15 +0100
Cc:     Joe Perches <joe@perches.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <432CCFCD-50AD-4678-A002-37D81A3B5E8F@holtmann.org>
References: <20200323072824.254495-1-mcchou@chromium.org>
 <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org>
 <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
 <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org>
 <03547be94c4944ca672c7aef2dd38b0fb1eedc84.camel@perches.com>
 <CALWDO_U5Cnt3_Ss2QQNhtuKS_8qq7oyNH4d97J68pmbmQMe=3w@mail.gmail.com>
 <643C6020-2FC5-4EEA-8F64-5D4B7F9258A4@holtmann.org>
 <CALWDO_Uc6brpXmVfoUd+jgyy_F0-WSrYb1+hXtXm498dGzCOSg@mail.gmail.com>
To:     Alain Michaud <alainmichaud@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

>>>>>>>> This adds a bit mask of driver_info for Microsoft vendor extension and
>>>>>>>> indicates the support for Intel 9460/9560 and 9160/9260. See
>>>>>>>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
>>>>>>>> microsoft-defined-bluetooth-hci-commands-and-events for more information
>>>>>>>> about the extension. This was verified with Intel ThunderPeak BT controller
>>>>>>>> where msft_vnd_ext_opcode is 0xFC1E.
>>>>>> []
>>>>>>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>>>>>> []
>>>>>>>> @@ -315,6 +315,10 @@ struct hci_dev {
>>>>>>>>       __u8            ssp_debug_mode;
>>>>>>>>       __u8            hw_error_code;
>>>>>>>>       __u32           clock;
>>>>>>>> +       __u16           msft_vnd_ext_opcode;
>>>>>>>> +       __u64           msft_vnd_ext_features;
>>>>>>>> +       __u8            msft_vnd_ext_evt_prefix_len;
>>>>>>>> +       void            *msft_vnd_ext_evt_prefix;
>>>>>> 
>>>>>> msft is just another vendor.
>>>>>> 
>>>>>> If there are to be vendor extensions, this should
>>>>>> likely use a blank line above and below and not
>>>>>> be prefixed with msft_
>>>>> 
>>>>> there are other vendors, but all of them are different. So this needs to be prefixed with msft_ actually. But I agree that having empty lines above and below makes it more readable.
>>>> 
>>>> So struct hci_dev should become a clutter
>>>> of random vendor extensions?
>>>> 
>>>> Perhaps there should instead be something like
>>>> an array of char at the end of the struct and
>>>> various vendor specific extensions could be
>>>> overlaid on that array or just add a void *
>>>> to whatever info that vendors require.
>>> I don't particularly like trailing buffers, but I agree we could
>>> possibly organize this a little better by with a struct.  something
>>> like:
>>> 
>>> struct msft_vnd_ext {
>>>   bool              supported; // <-- Clearly calls out if the
>>> extension is supported.
>>>   __u16           msft_vnd_ext_opcode; // <-- Note that this also
>>> needs to be provided by the driver.  I don't recommend we have this
>>> read from the hardware since we just cause an extra redirection that
>>> isn't necessary.  Ideally, this should come from the usb_table const.
>> 
>> Actually supported == false is the same as opcode == 0x0000. And supported == true is opcode != 0x0000.
> I was thinking of a more generic way to check if the extension is
> supported so the higher level doesn't need to understand that
> opcode==0 means it's not supported.  For the android extension for
> example, this would be a simple boolean (there isn't any opcodes).

since the extensions are not equal, I think there is no point in trying to generalize it in hci_dev. Here we have to do the heavy lifting anyway to make this fly. Then again, lets focus on the msft ones first. Keep it simple. And then we look at how we extend this to other extensions.

>> 
>>>   __u64           msft_vnd_ext_features;
>>>   __u8             msft_vnd_ext_evt_prefix_len;
>>>   void             *msft_vnd_ext_evt_prefix;
>>> };
>>> 
>>> And then simply add the struct msft_vnd_ext (and any others) to hci_dev.
>> 
>> Anyway, Lets keep these for now as hci_dev->msft_vnd_ext_*. We can fix this up later without any impact.
> I agree, this doesn't have a whole lot of long term consequences,
> although some will want to cherry-pick this to older kernels so if
> there is something we can do now, it will reduce burden on some
> products.

You end up having to pick up everything anyway. So I doubt it will make a huge difference. We can always evolve the patches before applying parts of it. Personally I like to get things that look sane and clean applied to we widen the audience of testers.

Regards

Marcel

