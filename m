Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E577F25479D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgH0NWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 09:22:40 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50636 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgH0NWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:22:23 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07RD0oGN084176;
        Thu, 27 Aug 2020 08:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598533250;
        bh=bNdiejgmrP6UyoxidBCnn4mIur5XympzIClUiV4GOpI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=b8mxLPPuz/qNstwFOEFuw9TyyfpFBYHln26sR0eUm3txSf4jqoADDhNjCPwN+SUYk
         eHTbW63h9keDDONxlm20Pv3iQBclhrGa26WkupSWOb3jcFTsXE+3xGjKPifbeQ0jln
         iKuYBWCNJl3LrEg3yaNW0JAlXSMuf+LjXouH1hLU=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07RD0o70124320;
        Thu, 27 Aug 2020 08:00:50 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 27
 Aug 2020 08:00:49 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 27 Aug 2020 08:00:49 -0500
Received: from [10.250.227.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07RD0mS7108067;
        Thu, 27 Aug 2020 08:00:48 -0500
Subject: Re: [net v3 PATCH] net: ethernet: ti: cpsw_new: fix error handling in
 cpsw_ndo_vlan_rx_kill_vid()
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200824170100.21319-1-m-karicheri2@ti.com>
 <20200825.093603.2026695844604591106.davem@davemloft.net>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <5be2b575-238c-247f-db9a-95680984e26d@ti.com>
Date:   Thu, 27 Aug 2020 09:00:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825.093603.2026695844604591106.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On 8/25/20 12:36 PM, David Miller wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> Date: Mon, 24 Aug 2020 13:01:00 -0400
> 
>> +	ret = cpsw_ale_del_vlan(cpsw->ale, vid, 0);
>> +	if (ret)
>> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
>> +			__func__, __LINE__, ret);
>> +	ret = cpsw_ale_del_ucast(cpsw->ale, priv->mac_addr,
>> +				 HOST_PORT_NUM, ALE_VLAN, vid);
>> +	if (ret)
>> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
>> +			__func__, __LINE__, ret);
>> +	ret = cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
>> +				 0, ALE_VLAN, vid);
>> +	if (ret)
>> +		dev_err(priv->dev, "%s: failed %d: ret %d\n",
>> +			__func__, __LINE__, ret);
>>   	cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
> 
> These error messages are extremely unhelpful.  You're calling three
> different functions, yet emitting basically the same __func__ for
> each of those cases.  No user can send you a useful bug report
> immediately if they just have func and line.
> 
> Please get rid of the "__func__" and "__line__" stuff completely, it's
> never advisable to ever use that in my opinion.  Instead, describe
> which delete operation failed, optionally with the error return.
> 
OK. I had considered your suggestion, but thought having a line number
would be handy for a developer. Function name would be better. Will
re-send with changes as you have suggested.

-- 
Murali Karicheri
Texas Instruments
