Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB86A0124
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 03:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjBWCW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 21:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWCW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 21:22:56 -0500
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A523A87;
        Wed, 22 Feb 2023 18:22:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VcIeAl-_1677118968;
Received: from 30.221.131.223(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VcIeAl-_1677118968)
          by smtp.aliyun-inc.com;
          Thu, 23 Feb 2023 10:22:48 +0800
Message-ID: <3f0b140f-5ee1-0ee1-6984-aed9de3d241a@linux.alibaba.com>
Date:   Thu, 23 Feb 2023 10:22:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next v3 9/9] net/smc: Add interface implementation
 of loopback device
To:     Hillf Danton <hdanton@sina.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230222140931.2716-1-hdanton@sina.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20230222140931.2716-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/22 22:09, Hillf Danton wrote:

> On Thu, 16 Feb 2023 00:18:25 +0800 Wen Gu <guwen@linux.alibaba.com>
>> @@ -124,12 +126,76 @@ static int smc_lo_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
>>   	write_unlock(&ldev->dmb_ht_lock);
>>   
>>   	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
>> +
>> +	/* wait for dmb refcnt to be 0 */
>> +	if (!refcount_dec_and_test(&dmb_node->refcnt))
>> +		wait_event(ldev->dmbs_release, !refcount_read(&dmb_node->refcnt));
> 
> Wait for zero refcnt with dmb node deleted from hash table.
> 
>>   	kfree(dmb_node->cpu_addr);
>>   	kfree(dmb_node);
>>   
>> +	if (atomic_dec_and_test(&ldev->dmb_cnt))
>> +		wake_up(&ldev->ldev_release);
>> +	return 0;
>> +}
> 
> [...]
> 
>> +static int smc_lo_detach_dmb(struct smcd_dev *smcd, u64 token)
>> +{
>> +	struct smc_lo_dmb_node *dmb_node = NULL, *tmp_node;
>> +	struct smc_lo_dev *ldev = smcd->priv;
>> +
>> +	/* find dmb_node according to dmb->dmb_tok */
>> +	read_lock(&ldev->dmb_ht_lock);
>> +	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, token) {
>> +		if (tmp_node->token == token) {
>> +			dmb_node = tmp_node;
>> +			break;
>> +		}
>> +	}
>> +	if (!dmb_node) {
>> +		read_unlock(&ldev->dmb_ht_lock);
>> +		return -EINVAL;
>> +	}
>> +	read_unlock(&ldev->dmb_ht_lock);
>> +
>> +	if (refcount_dec_and_test(&dmb_node->refcnt))
>> +		wake_up_all(&ldev->dmbs_release);
>>   	return 0;
>>   }
> 
> Given no wakeup without finding dmb node in hash table, the chance for
> missing wakeup is not zero.

Good catch! Will fix it.

Thanks,
Wen Gu
