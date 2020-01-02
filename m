Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1A12E15A
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 01:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgABAih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 19:38:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:61497 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgABAig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 19:38:36 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 0020cM24027929
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 Jan 2020 16:38:22 -0800 (PST)
Received: from [128.224.162.195] (128.224.162.195) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.468.0; Wed, 1 Jan 2020
 16:38:20 -0800
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>
CC:     <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
References: <20191231020302.71792-1-jiping.ma2@windriver.com>
 <57dcdaa1-feff-1134-919e-57b37e306431@cogentembedded.com>
From:   Jiping Ma <Jiping.Ma2@windriver.com>
Message-ID: <4de343a7-e47f-2f72-4f5a-17ea9c7c0e1a@windriver.com>
Date:   Thu, 2 Jan 2020 08:38:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <57dcdaa1-feff-1134-919e-57b37e306431@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/31/2019 06:12 PM, Sergei Shtylyov wrote:
> Hello!
>
> On 31.12.2019 5:03, Jiping Ma wrote:
>
>> Add one notifier for udev changes net device name.
>>
>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>> ---
>>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 38 ++++++++++++++++++-
>>   1 file changed, 37 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c 
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index b14f46a57154..c1c877bb4421 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -4038,6 +4038,40 @@ static int stmmac_dma_cap_show(struct seq_file 
>> *seq, void *v)
>>   }
>>   DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
>>   +/**
>> + * Use network device events to create/remove/rename
>> + * debugfs file entries
>> + */
>> +static int stmmac_device_event(struct notifier_block *unused,
>> +                   unsigned long event, void *ptr)
>> +{
>> +    struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +    struct stmmac_priv *priv = netdev_priv(dev);
>> +
>> +    switch (event) {
>> +    case NETDEV_CHANGENAME:
>> +        if (priv->dbgfs_dir)
>> +            priv->dbgfs_dir = debugfs_rename(stmmac_fs_dir,
>> +                             priv->dbgfs_dir,
>> +                             stmmac_fs_dir,
>> +                             dev->name);
>> +        break;
>> +
>> +    case NETDEV_GOING_DOWN:
>> +        break;
>> +
>> +    case NETDEV_UP:
>> +        break;
>
>    Why not merge the above 2 cases? Or just remove them('event' is not 
> *enum*)?
I will remove them.

Thanks,
>
>> +    }
>> +
>> +done:
>> +    return NOTIFY_DONE;
>> +}
> [...]
>
> MBR, Sergei
>

