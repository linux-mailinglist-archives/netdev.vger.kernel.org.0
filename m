Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1DE1796DC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgCDRiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:38:06 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44822 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgCDRiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 12:38:05 -0500
Received: by mail-pf1-f196.google.com with SMTP id y26so1291263pfn.11
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 09:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=7z8mrgcAquNS36QuTXNYPnThv7wL6jNo8L7ZfL6q1mU=;
        b=iZw4KKYW6ar7Cj8P+qADFZdD+QyahQpdpr7MdOYVbhfN/jsQdVADf4fSiS/ToQ+Q20
         plguRicPZsO2mpxQv6CoIy2Jpi0tlSt5ioKAC638KdkxwXnl2aPOVcaUbV/UeqSXrkR3
         8V21LWJZcJ72KfV5/s8353TNPOkpdDM/ZUZBV7s/x5Tpq/POBSkjbbTt1V4hetFBBmLi
         TMjt3bXsFoHX/fZaAvKbub+/I4a/FQEASVnZNwjEj+XKu4Jt8A3pY2Wv0ecN4Fyp5RRs
         SEe3KJzno0yeVq9Ha2ZcZKEb9tEVY6378wvs8loRhA5WBtN4qmYHvV9AS0AQclAoUHXU
         2a1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7z8mrgcAquNS36QuTXNYPnThv7wL6jNo8L7ZfL6q1mU=;
        b=UtBcXoR+JiWaAqJxYNjFMfym+FUuwhQkMs2nuF9AXz/nLiSx71jYFNmpWGHSXu4dbG
         mwVdW3ubaTIsS0Q2zAaTe7EeWggcGNVUZbvHT03McAbh86phZBoK1Gb8ahYe30Q4e/js
         //ylCYeoSgV35HXN4ny5l/FGlyJqb4UhAQYU1sd2Lyu0ve/YIPvh4W9yLvsZy+FOoIbK
         Aii2JaNZIxvvrZ8WXEMTJUB0P984I9S9sWdWFTTA0Qut9mEn+Lyx2r/ioq5O6CNc9i82
         pJz9JeeMUzkjfEmDDSewakfxiQkjtk24sFcOoScIEnksScCVwUND+U2EYA7DYnwwa10s
         sEjA==
X-Gm-Message-State: ANhLgQ3w8HBxEOnGn3Z3f9zYmfwWUeRx+qm6sSU4jyQbcerDg1RDHKfk
        SMaZfFsLO9QwGw+743o+bAramMi49WI=
X-Google-Smtp-Source: ADFU+vth34B6WYhcbE372CnNBEt53H5RoJDrFcHGCgvp4LdW6+dlXpG2AIMAx6KlxXQaudu3EXJNJQ==
X-Received: by 2002:a63:c304:: with SMTP id c4mr3597674pgd.85.1583343484464;
        Wed, 04 Mar 2020 09:38:04 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id t19sm28303429pgg.23.2020.03.04.09.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 09:38:04 -0800 (PST)
Subject: Re: [PATCH net] ionic: fix vf op lock usage
To:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200304172148.63593-1-snelson@pensando.io>
 <AM0PR05MB48665FBFDB99A8BEEBC5182CD1E50@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3d69152f-2a5c-b578-f5af-12dc057ee3a0@pensando.io>
Date:   Wed, 4 Mar 2020 09:38:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB48665FBFDB99A8BEEBC5182CD1E50@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 9:31 AM, Parav Pandit wrote:
>> Sent: Wednesday, March 4, 2020 11:22 AM
>> To: davem@davemloft.net; netdev@vger.kernel.org
>> These are a couple of read locks that should be write locks.
>>
>> Fixes: commit fbb39807e9ae ("ionic: support sr-iov operations")
> It should be,
>
> Fixes: fbb39807e9ae ("ionic: support sr-iov operations")

Thanks, I'll fix that.
sln

>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 191271f6260d..c2f5b691e0fa 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1688,7 +1688,7 @@ static int ionic_set_vf_mac(struct net_device
>> *netdev, int vf, u8 *mac)
>>   	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
>>   		return -EINVAL;
>>
>> -	down_read(&ionic->vf_op_lock);
>> +	down_write(&ionic->vf_op_lock);
>>
>>   	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
>>   		ret = -EINVAL;
>> @@ -1698,7 +1698,7 @@ static int ionic_set_vf_mac(struct net_device
>> *netdev, int vf, u8 *mac)
>>   			ether_addr_copy(ionic->vfs[vf].macaddr, mac);
>>   	}
>>
>> -	up_read(&ionic->vf_op_lock);
>> +	up_write(&ionic->vf_op_lock);
>>   	return ret;
>>   }
>>
>> @@ -1719,7 +1719,7 @@ static int ionic_set_vf_vlan(struct net_device
>> *netdev, int vf, u16 vlan,
>>   	if (proto != htons(ETH_P_8021Q))
>>   		return -EPROTONOSUPPORT;
>>
>> -	down_read(&ionic->vf_op_lock);
>> +	down_write(&ionic->vf_op_lock);
>>
>>   	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
>>   		ret = -EINVAL;
>> @@ -1730,7 +1730,7 @@ static int ionic_set_vf_vlan(struct net_device
>> *netdev, int vf, u16 vlan,
>>   			ionic->vfs[vf].vlanid = vlan;
>>   	}
>>
>> -	up_read(&ionic->vf_op_lock);
>> +	up_write(&ionic->vf_op_lock);
>>   	return ret;
>>   }
>>
>> --
>> 2.17.1
> I missed to review this after Christmas break.
>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
>

