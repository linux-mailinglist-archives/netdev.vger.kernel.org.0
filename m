Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD511272C4
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLTB01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:26:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727006AbfLTB01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:26:27 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBK1MnTM100900;
        Thu, 19 Dec 2019 20:26:19 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x0kuj9dkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 20:26:18 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBK1Mngs100929;
        Thu, 19 Dec 2019 20:26:18 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2x0kuj9dk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 20:26:18 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBK1M0YO031841;
        Fri, 20 Dec 2019 01:26:17 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 2wvqc73dr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 01:26:17 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBK1QGao52036060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 01:26:16 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 979E16A04D;
        Fri, 20 Dec 2019 01:26:16 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 624FA6A047;
        Fri, 20 Dec 2019 01:26:15 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.206.139])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Dec 2019 01:26:15 +0000 (GMT)
Subject: Re: [PATCH, net-next, v3, 1/2] Three virtual devices (ibmveth,
 virtio_net, and netvsc) all have similar code to set/get link settings and
 validate ethtool command. To eliminate duplication of code, it is factored
 out into core/ethtool.c.
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
 <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
 <20191219223603.GC21614@unicorn.suse.cz>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <bac064bd-fba1-e453-7754-022ea6a191f2@linux.ibm.com>
Date:   Thu, 19 Dec 2019 19:26:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191219223603.GC21614@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_08:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912200008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 4:36 PM, Michal Kubecek wrote:
> On Thu, Dec 19, 2019 at 01:40:56PM -0600, Cris Forno wrote:
>> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>

Hi Michal, thanks for your comments.  I have a question on your 
suggestions for the ethtool_virtdev_validate_cmd below.

>> ---
>>   include/linux/ethtool.h |  2 ++
>>   net/core/ethtool.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 60 insertions(+)
>>
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 95991e43..1b0417b 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -394,6 +394,8 @@ struct ethtool_ops {
>>   					  struct ethtool_coalesce *);
>>   	int	(*set_per_queue_coalesce)(struct net_device *, u32,
>>   					  struct ethtool_coalesce *);
>> +	bool    (*virtdev_validate_link_ksettings)(const struct
>> +						   ethtool_link_ksettings *);
>>   	int	(*get_link_ksettings)(struct net_device *,
>>   				      struct ethtool_link_ksettings *);
>>   	int	(*set_link_ksettings)(struct net_device *,
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index cd9bc67..4091a94 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
> You should probably rebase on top of current net-next; this file has
> been moved to net/ethtool/ioctl.c recently.
>
>> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>>   	return 0;
>>   }
>>   
>> +/* Check if the user is trying to change anything besides speed/duplex */
>> +static bool
>> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
>> +{
>> +	struct ethtool_link_ksettings diff1 = *cmd;
>> +	struct ethtool_link_ksettings diff2 = {};
>> +
>> +	/* cmd is always set so we need to clear it, validate the port type
>> +	 * and also without autonegotiation we can ignore advertising
>> +	 */
>> +	diff1.base.speed = 0;
>> +	diff2.base.port = PORT_OTHER;
>> +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
>> +	diff1.base.duplex = 0;
>> +	diff1.base.cmd = 0;
>> +	diff1.base.link_mode_masks_nwords = 0;
>> +
>> +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
>> +		bitmap_empty(diff1.link_modes.supported,
>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>> +		bitmap_empty(diff1.link_modes.advertising,
>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> Isn't this condition always true? You zeroed the advertising bitmap
> above. Could you just omit this part and clearing of advertising above?
>
>> +		bitmap_empty(diff1.link_modes.lp_advertising,
>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
>> +}
> Another idea: instead of zeroing parts of diff1, you could copy these
> members from *cmd to diff2 and compare cmd->base with diff2.base. You
> could then drop diff1. And you wouldn't even need whole struct
> ethtool_link_ksettings for diff2 as you only compare embedded struct
> ethtool_link_settings (and check two bitmaps in cmd->link_modes).

If I understand your suggestion correctly, then the validate function 
might look something like this?

/* Check if the user is trying to change anything besides speed/duplex */
static bool
ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
{
     struct ethtool_link_settings base2 = {};

     base2.speed = cmd->base.speed;
     base2.port = PORT_OTHER;
     base2.duplex = cmd->base.duplex;
     base2.cmd = cmd->base.cmd;
     base2.link_mode_masks_nwords = cmd->base.link_mode_masks_nwords;

     return !memcmp(&base2, cmd->base, sizeof(base2)) &&
         bitmap_empty(cmd->link_modes.supported,
                  __ETHTOOL_LINK_MODE_MASK_NBITS) &&
         bitmap_empty(cmd->link_modes.lp_advertising,
                  __ETHTOOL_LINK_MODE_MASK_NBITS);
}

Thanks again,

Tom

>
>> +
>>   /* convert a kernel internal ethtool_link_ksettings to
>>    * ethtool_link_usettings in user space. return 0 on success, errno on
>>    * error.
>> @@ -660,6 +686,17 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
>>   	return store_link_ksettings_for_user(useraddr, &link_ksettings);
>>   }
>>   
>> +static int
>> +ethtool_virtdev_get_link_ksettings(struct net_device *dev,
>> +				   struct ethtool_link_ksettings *cmd,
>> +				   u32 *speed, u8 *duplex)
>> +{
>> +	cmd->base.speed = *speed;
>> +	cmd->base.duplex = *duplex;
>> +	cmd->base.port = PORT_OTHER;
>> +	return 0;
>> +}
> speed and duplex can be passed by value here; if you prefer pointers,
> please make them const.
>
> Michal Kubecek
