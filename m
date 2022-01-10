Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A053F489AE8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiAJN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:56:09 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49142 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233369AbiAJN4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:56:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1T45S6_1641822965;
Received: from 30.225.24.19(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1T45S6_1641822965)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 21:56:06 +0800
Message-ID: <2098bb01-1aad-cb38-8b0b-a43e4c40c013@linux.alibaba.com>
Date:   Mon, 10 Jan 2022 21:56:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net 1/3] net/smc: Resolve the race between link group
 access and termination
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
 <3525a4cd-1bc7-1008-910b-fb89597cc10a@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <3525a4cd-1bc7-1008-910b-fb89597cc10a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/10 8:25 pm, Karsten Graul wrote:
> On 10/01/2022 10:26, Wen Gu wrote:
>> We encountered some crashes caused by the race between the access
>> and the termination of link groups.
>>

>> @@ -1120,8 +1122,22 @@ void smc_conn_free(struct smc_connection *conn)
>>   {
>>   	struct smc_link_group *lgr = conn->lgr;
>>   
>> -	if (!lgr)
>> +	if (!lgr || conn->freed)
>> +		/* The connection has never been registered in a
>> +		 * link group, or has already been freed.
>> +		 *
>> +		 * Check to ensure that the refcnt of link group
>> +		 * won't be put incorrectly.
> 
> I would delete the second sentence here, its obvious enough.
> 
>> +		 */
>>   		return;
>> +
>> +	conn->freed = 1;
>> +	if (!conn->alert_token_local)
>> +		/* The connection was registered in a link group
>> +		 * defore, but now it is unregistered from it.
> 
> 'before' ... But would maybe the following be more exact:
> 
> 'Connection already unregistered from link group.'
> 
> 
> We still review the patches...
> 

Thanks for your detailed and patient review. The comments will
be improved as you suggested.

Thanks,
Wen Gu
