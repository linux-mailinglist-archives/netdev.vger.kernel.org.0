Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB922257F3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgGTGim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:38:42 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:4452 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgGTGil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 02:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595227122; x=1626763122;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=R4jL1jut1jCNCp3l/7tMkBB8YQEOUGJTQevNPAD7i4k=;
  b=BFCoaiX7WgbVIdrZjbbjCZpkDdsOE5t6XMwpXyoeyK4KhPXl3vXLU2ne
   pzWEQrbyZXSS5JjtjruOjNh14WJzL11UM7C0V/qAdHhV6EmHlL0yLkF7W
   40i/SMv4fSxhaeFKH8Zz08Ds23Yh933CKgUYkpHMKIAItcSjIXVKnqRHk
   g=;
IronPort-SDR: dtMT/GYKR2F/RvGS/GvaTaC9Rlgl9C1tV0iVshfCmR0b4ZErGPMvd8JgrPDiEYKKfTHGN0oYrR
 d08AxqErckiw==
X-IronPort-AV: E=Sophos;i="5.75,374,1589241600"; 
   d="scan'208";a="59738372"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Jul 2020 06:38:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 3EC20120F02;
        Mon, 20 Jul 2020 06:38:38 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 06:38:37 +0000
Received: from ua97a68a4e7db56.ant.amazon.com.amazon.com (10.43.162.221) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 06:38:32 +0000
References: <20200720025309.18597-1-wanghai38@huawei.com> <f31ec3e646c9ba73c09f821a173c20110346deab.camel@perches.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Joe Perches <joe@perches.com>
CC:     Wang Hai <wanghai38@huawei.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <zorik@amazon.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <sameehj@amazon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: ena: Fix using plain integer as NULL pointer in ena_init_napi_in_range
In-Reply-To: <f31ec3e646c9ba73c09f821a173c20110346deab.camel@perches.com>
Date:   Mon, 20 Jul 2020 09:38:26 +0300
Message-ID: <pj41zllfjebsil.fsf@ua97a68a4e7db56.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.221]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Joe Perches <joe@perches.com> writes:

> On Mon, 2020-07-20 at 10:53 +0800, Wang Hai wrote:
>> Fix sparse build warning:
>> 
>> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>>  Using plain integer as NULL pointer
> []
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> []
>> @@ -2190,11 +2190,10 @@ static void 
>> ena_del_napi_in_range(struct ena_adapter *adapter,
>>  static void ena_init_napi_in_range(struct ena_adapter 
>>  *adapter,
>>  				   int first_index, int count)
>>  {
>> -	struct ena_napi *napi = {0};
>>  	int i;
>>  
>>  	for (i = first_index; i < first_index + count; i++) {
>> -		napi = &adapter->ena_napi[i];
>> +		struct ena_napi *napi = &adapter->ena_napi[i];
>>  
>>  		netif_napi_add(adapter->netdev,
>>  			       &adapter->ena_napi[i].napi,
>
> Another possible change is to this statement:
>
>  		netif_napi_add(adapter->netdev,
> 			       &napi->napi,
> 			       etc...);

Yup, missed that myself. Wang, if you don't mind please apply 
Joe's change as well.

Thanks, Shay
