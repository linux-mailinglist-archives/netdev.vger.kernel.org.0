Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0681CA6DD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 11:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHJPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 05:15:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10866 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbgEHJPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 05:15:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0489BF1O019505;
        Fri, 8 May 2020 02:14:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=1L90Gc+DWQleXmICGoQWGaCmHdd3iDcuRzUKNFsLzuE=;
 b=aWdHIbtwf8xyPzlbcHGCYQ7BzZgLHk74Pa+1HHHoXJ6asDIs6isHg/w26iqrjn+l93MU
 NbA2a1W+TEhfJP4kXGQiVAUombt9Bz0GgxvOTlX/MQzvxLIfI88zv/n5vkhayEIWq/iO
 6laIROpRh7GZyH1yX5cyqWMRhj06GqUDPF5bW0ty46dQJxsXfSj/bfypq0O45v1+t6Yz
 zdvx8Nu9q7ek+NGJ7SCkV2H2V48jjPjNPEPM2gtI3wGSpP96s19CzQ1B+rLSJZlKA678
 y4r/NF73sjFL4D5JaIeTxu3DRK9sl02PltTZlSkIYFL2DYxrPQtHCWoO0R2Tb6ioPia5 Ew== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30vtdva4gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 02:14:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 02:14:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 02:14:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 02:14:54 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id DC9153F703F;
        Fri,  8 May 2020 02:14:52 -0700 (PDT)
Subject: Re: [PATCH net-next 7/7] net: atlantic: unify get_mac_permanent
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
 <20200507081510.2120-8-irusskikh@marvell.com>
 <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
Date:   Fri, 8 May 2020 12:14:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_08:2020-05-07,2020-05-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,


>> This patch moves MAC generation into a separate function, which is
> called
>> from both places to reduce the amount of copy/paste.
> 
> Right, but why do you have your own mac generation rather than using
> eth_hw_addr_random(). You need to set NET_ADDR_RANDOM for example,
> just use standard helpers, please.

We want this still be an Aquantia vendor id MAC, not a fully random mac.
Thats why the logic below randomizes only low three octets.


>>  }
>> +
>> +static inline bool aq_hw_is_zero_ether_addr(const u8 *addr)
> 
> No static inlines in C files, please. Let compiler decide inlineing &
> generate a warning when function becomes unused.

Ok, will fix.

>> +	get_random_bytes(&rnd, sizeof(unsigned int));
>> +	l = 0xE300 0000U | (0xFFFFU & rnd) | (0x00 << 16);
>> +	h = 0x8001300EU;
>> +
>> +	mac[5] = (u8)(0xFFU & l);
>> +	l >>= 8;
>> +	mac[4] = (u8)(0xFFU & l);
>> +	l >>= 8;
>> +	mac[3] = (u8)(0xFFU & l);
>> +	l >>= 8;
>> +	mac[2] = (u8)(0xFFU & l);
>> +	mac[1] = (u8)(0xFFU & h);
>> +	h >>= 8;
>> +	mac[0] = (u8)(0xFFU & h);
> 
> This can be greatly simplified using helpers from etherdevice.h, if
> it's really needed.

This is the exact place where we put Aquantia vendor id, even if mac is random.

eth_hw_addr_random is more suitable for software devices like bridges, which
are not related to any vendor.

Regards,
  Igor
