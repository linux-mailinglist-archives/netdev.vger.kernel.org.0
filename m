Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035D2132D3F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgAGRkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:40:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728266AbgAGRkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:40:39 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007HeNsQ038483;
        Tue, 7 Jan 2020 12:40:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xb91qamrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 12:40:32 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 007HeOJ2038674;
        Tue, 7 Jan 2020 12:40:32 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xb91qamkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 12:40:31 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 007HdsoX029641;
        Tue, 7 Jan 2020 17:40:24 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2xajb6d2f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 17:40:24 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 007HeNda41025978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jan 2020 17:40:24 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4D836E04C;
        Tue,  7 Jan 2020 17:40:23 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FE6E6E04E;
        Tue,  7 Jan 2020 17:40:23 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.24.11.154])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jan 2020 17:40:22 +0000 (GMT)
Subject: Re: [PATCH, net-next, v3, 1/2] Three virtual devices (ibmveth,
 virtio_net, and netvsc) all have similar code to set/get link settings and
 validate ethtool command. To eliminate duplication of code, it is factored
 out into core/ethtool.c.
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
 <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
 <20191219223603.GC21614@unicorn.suse.cz>
 <bac064bd-fba1-e453-7754-022ea6a191f2@linux.ibm.com>
 <20191220070418.GE21614@unicorn.suse.cz>
From:   Cristobal Forno <cforno12@linux.vnet.ibm.com>
Message-ID: <27f4902c-d731-d215-14b9-d490cdd8b86d@linux.vnet.ibm.com>
Date:   Tue, 7 Jan 2020 11:40:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191220070418.GE21614@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion Micheal and Thomas. This will be included in 
the next version of the patch series.

-Cris Forno

On 20/12/2019 01:04, Michal Kubecek wrote:
> On Thu, Dec 19, 2019 at 07:26:14PM -0600, Thomas Falcon wrote:
>> On 12/19/19 4:36 PM, Michal Kubecek wrote:
>>> On Thu, Dec 19, 2019 at 01:40:56PM -0600, Cris Forno wrote:
> [...]
>>>> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>>>>    	return 0;
>>>>    }
>>>> +/* Check if the user is trying to change anything besides speed/duplex */
>>>> +static bool
>>>> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
>>>> +{
>>>> +	struct ethtool_link_ksettings diff1 = *cmd;
>>>> +	struct ethtool_link_ksettings diff2 = {};
>>>> +
>>>> +	/* cmd is always set so we need to clear it, validate the port type
>>>> +	 * and also without autonegotiation we can ignore advertising
>>>> +	 */
>>>> +	diff1.base.speed = 0;
>>>> +	diff2.base.port = PORT_OTHER;
>>>> +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
>>>> +	diff1.base.duplex = 0;
>>>> +	diff1.base.cmd = 0;
>>>> +	diff1.base.link_mode_masks_nwords = 0;
>>>> +
>>>> +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
>>>> +		bitmap_empty(diff1.link_modes.supported,
>>>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>>>> +		bitmap_empty(diff1.link_modes.advertising,
>>>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>>> Isn't this condition always true? You zeroed the advertising bitmap
>>> above. Could you just omit this part and clearing of advertising above?
>>>
>>>> +		bitmap_empty(diff1.link_modes.lp_advertising,
>>>> +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
>>>> +}
>>> Another idea: instead of zeroing parts of diff1, you could copy these
>>> members from *cmd to diff2 and compare cmd->base with diff2.base. You
>>> could then drop diff1. And you wouldn't even need whole struct
>>> ethtool_link_ksettings for diff2 as you only compare embedded struct
>>> ethtool_link_settings (and check two bitmaps in cmd->link_modes).
>> If I understand your suggestion correctly, then the validate function might
>> look something like this?
>>
>> /* Check if the user is trying to change anything besides speed/duplex */
>> static bool
>> ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
>> {
>>      struct ethtool_link_settings base2 = {};
>>
>>      base2.speed = cmd->base.speed;
>>      base2.port = PORT_OTHER;
>>      base2.duplex = cmd->base.duplex;
>>      base2.cmd = cmd->base.cmd;
>>      base2.link_mode_masks_nwords = cmd->base.link_mode_masks_nwords;
>>
>>      return !memcmp(&base2, cmd->base, sizeof(base2)) &&
>>          bitmap_empty(cmd->link_modes.supported,
>>                   __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>>          bitmap_empty(cmd->link_modes.lp_advertising,
>>                   __ETHTOOL_LINK_MODE_MASK_NBITS);
>> }
> Yes, that is what I wanted to suggest (the second argument of memcmp()
> should be "&cmd->base", I think).
>
> Michal
