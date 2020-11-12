Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090432B005B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 08:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKLHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 02:31:24 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48350 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgKLHbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 02:31:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AC7QKw2026884;
        Wed, 11 Nov 2020 23:31:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Q5CSx4nNQG/6lho+5mk7KxoCzmyopquKcR2OAYFD2B8=;
 b=SLY8p2Or9tDCBzhq1OTVhaZVk1d7aqbZkg/18J4c2PaK6ZSkcNylN3n7HsqG6T2foHjV
 +ni8vKUtzUaqo+N7m37GAlbwAZB//wszyjTE6oFZ1PLamglWlacI0PeVqkxDjYa0ha/n
 AYS9KyAh/imiTQZxZqLjw34w3irOrhIAJoovBZoTNUNGUqaBCeBzg0MUWxYgSv1K4qxd
 Rko6YtLf52B052L+vfzugvCzc3KLHtEPxhUtLCVm9jLVHgDL9eVakkrlF1TjsZLd/Mrp
 pO1bXTJWZXIcj4FpDoAotr6UewjiVJUaurrX8seOy+jQo0YFiSC97dzYyk8z/lfna1/d Mw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34nstuayc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 23:31:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Nov
 2020 23:31:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Nov
 2020 23:31:15 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 11 Nov 2020 23:31:15 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id E68873F7040;
        Wed, 11 Nov 2020 23:31:12 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v3 net-next 07/21] net: usb: aqc111: Add support
 for getting and setting of MAC address
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
CC:     <linux-usb@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
References: <cover.1542794577.git.igor.russkikh@aquantia.com>
 <8f92711d8479a3df65849e60fd92c727e1e1f78a.1542794577.git.igor.russkikh@aquantia.com>
 <7a866553-1333-4952-5fe6-45336235ebb2@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <9ad88163-ba9a-f49d-4327-d25ad97a8041@marvell.com>
Date:   Thu, 12 Nov 2020 10:31:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
MIME-Version: 1.0
In-Reply-To: <7a866553-1333-4952-5fe6-45336235ebb2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_02:2020-11-10,2020-11-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anant,

>>
>> +static int aqc111_set_mac_addr(struct net_device *net, void *p)
>> +{
>> +	struct usbnet *dev = netdev_priv(net);
>> +	int ret = 0;
>> +
>> +	ret = eth_mac_addr(net, p);
>> +	if (ret < 0)
>> +		return ret;
>> +
> 
> When eth_mac_addr() fails, from what I can see, it returns either -EBUSY, or
> -EADDRNOTAVAIL.
> Wouldn't it be a better idea to set a random MAC address instead, when
> -EADDRNOTAVAIL is returned, so that the interface still comes up and is
> usable?
> 
> I'm only asking because this feels similar to the discussion that can be 
> found here.
>     https://urldefense.proofpoint.com/v2/url?u=https-3A__lkml.org_lkml_2020_10_2_305&d=DwIDaQ&c=nKjWec2b6R0mOyPaz7xtfQ&r=3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=aJdSTt0SmQpKGqrsMm9TQ2mCWDH1Vc7arUp0xq-v6Ac&s=n-tXDyWIR5tPvrQ4DUasDgrocxKU3e_A-mh3Nv5JC5A&e=

Here in set_mac_addr driver is being asked to SET the specified mac.
If it fails - device will most probably drop the packets designated for it.

So I think no, you can't put here some random MAC.

Regards,
  Igor
