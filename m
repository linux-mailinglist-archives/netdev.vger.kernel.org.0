Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EA711A4C0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfLKHAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:00:05 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60780 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfLKHAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 02:00:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0TkbY04C_1576047596;
Received: from JosephdeMacBook-Pro.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0TkbY04C_1576047596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Dec 2019 14:59:57 +0800
Subject: Re: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190827163717.44101-1-andriy.shevchenko@linux.intel.com>
 <20191209164338.GO32742@smile.fi.intel.com>
 <MN2PR18MB25282DFB28BB92626C6C8C37D35A0@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <f3fbe9bc-9ef7-6639-a21a-58fb4f0ca55c@linux.alibaba.com>
Date:   Wed, 11 Dec 2019 14:59:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <MN2PR18MB25282DFB28BB92626C6C8C37D35A0@MN2PR18MB2528.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add akpm as well.

On 19/12/11 11:32, Sudarsana Reddy Kalluru wrote:
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
>> Behalf Of Andy Shevchenko
>> Sent: Monday, December 9, 2019 10:14 PM
>> To: Mark Fasheh <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>;
>> Joseph Qi <joseph.qi@linux.alibaba.com>; ocfs2-devel@oss.oracle.com; Ariel
>> Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru
>> <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-linux-
>> l2@marvell.com>; David S. Miller <davem@davemloft.net>;
>> netdev@vger.kernel.org; Colin Ian King <colin.king@canonical.com>
>> Subject: Re: [PATCH v2] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for
>> wider use
>>
>> On Tue, Aug 27, 2019 at 07:37:17PM +0300, Andy Shevchenko wrote:
>>> There are users already and will be more of BITS_TO_BYTES() macro.
>>> Move it to bitops.h for wider use.
>>>
>>> In the case of ocfs2 the replacement is identical.
>>>
>>> As for bnx2x, there are two places where floor version is used.
>>> In the first case to calculate the amount of structures that can fit
>>> one memory page. In this case obviously the ceiling variant is correct
>>> and original code might have a potential bug, if amount of bits % 8 is not 0.
>>> In the second case the macro is used to calculate bytes transmitted in
>>> one microsecond. This will work for all speeds which is multiply of
>>> 1Gbps without any change, for the rest new code will give ceiling
>>> value, for instance 100Mbps will give 13 bytes, while old code gives
>>> 12 bytes and the arithmetically correct one is 12.5 bytes. Further the
>>> value is used to setup timer threshold which in any case has its own
>>> margins due to certain resolution. I don't see here an issue with
>>> slightly shifting thresholds for low speed connections, the card is supposed
>> to utilize highest available rate, which is usually 10Gbps.
>>
>> Anybody to comment on bnx2 change?
>> Can we survive with this applied?
>>
>>>
>>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>> ---
>>> - described bnx2x cases in the commit message
>>> - appended Rb (for ocfs2)
>>>
>>>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
>>>  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
>>>  include/linux/bitops.h                           | 1 +
>>>  3 files changed, 1 insertion(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
>>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
>>> index 066765fbef06..0a59a09ef82f 100644
>>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
>>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
>>> @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x
>> *bp, enum cos_mode mode,
>>>   *    possible, the driver should only write the valid vnics into the internal
>>>   *    ram according to the appropriate port mode.
>>>   */
>>> -#define BITS_TO_BYTES(x) ((x)/8)
>>>
>>>  /* CMNG constants, as derived from system spec calculations */
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h index
>>> aaf24548b02a..0463dce65bb2 100644
>>> --- a/fs/ocfs2/dlm/dlmcommon.h
>>> +++ b/fs/ocfs2/dlm/dlmcommon.h
>>> @@ -688,10 +688,6 @@ struct dlm_begin_reco
>>>  	__be32 pad2;
>>>  };
>>>
>>> -
>>> -#define BITS_PER_BYTE 8
>>> -#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
>>> -
>>>  struct dlm_query_join_request
>>>  {
>>>  	u8 node_idx;
>>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h index
>>> cf074bce3eb3..79d80f5ddf7b 100644
>>> --- a/include/linux/bitops.h
>>> +++ b/include/linux/bitops.h
>>> @@ -5,6 +5,7 @@
>>>  #include <linux/bits.h>
>>>
>>>  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
>>> +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
>>>  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
>>>
>>>  extern unsigned int __sw_hweight8(unsigned int w);
>>> --
>>> 2.23.0.rc1
>>>
>>
>> --
>> With Best Regards,
>> Andy Shevchenko
>>
> 
> Thanks for the changes.
> 
> Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> 
