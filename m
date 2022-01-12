Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0010948BFB0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351507AbiALIRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:17:05 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33333 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237603AbiALIRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:17:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V1e7x-G_1641975418;
Received: from 30.225.24.63(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1e7x-G_1641975418)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jan 2022 16:16:59 +0800
Message-ID: <ac0a2805-c6a0-af05-adc7-780d17003897@linux.alibaba.com>
Date:   Wed, 12 Jan 2022 16:16:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
 <20220112071134.GA47613@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220112071134.GA47613@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/12 3:11 pm, dust.li wrote:
> On Mon, Jan 10, 2022 at 05:38:25PM +0800, Wen Gu wrote:
>>
>> This patch tries to fix it by holding clcsock_release_lock and
>> checking whether clcsock has already been released. In case that
>> a crash of the same reason happens in smc_getsockopt(), this patch
>> also checkes smc->clcsock in smc_getsockopt().

>> @@ -2509,13 +2515,21 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
>> 			  char __user *optval, int __user *optlen)
>> {
>> 	struct smc_sock *smc;
>> +	int rc;
>>
>> 	smc = smc_sk(sock->sk);
>> +	mutex_lock(&smc->clcsock_release_lock);
>> +	if (!smc->clcsock) {
>> +		mutex_unlock(&smc->clcsock_release_lock);
>> +		return -EBADF;
>> +	}
>> 	/* socket options apply to the CLC socket */
>> 	if (unlikely(!smc->clcsock->ops->getsockopt))
> Missed a mutex_unlock() here ?
> 
>> 		return -EOPNOTSUPP;

Thanks for pointing it out. Will add an additional mutex_unlock().

Thanks,
Wen Gu

