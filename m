Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9FC6EE521
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbjDYP7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbjDYP7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:59:10 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E418C17A;
        Tue, 25 Apr 2023 08:59:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 30A3960161;
        Tue, 25 Apr 2023 17:59:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682438346; bh=XJOm+PL1n+IETGdWyBevOpSz4W+XaMIM22aU7kvoNeM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cRMRm47iPs5gE2T1yfXSuIqZyaUw8wqmyJ57DrP9jTNS6MGPMCvwL2us8Z3dPbdjP
         dgAedUkUItsEQy4fkgxF4dB2MJwHOVpESemSzdRbbw0s1OCoeaHx0e0e9T8BojSWUy
         sQmzcBHcqYoq52MqC6zGLbCZw5Im9Jz1IctQcLfT3evZbCPpAC/spAEGtl+OsnCcPm
         3xb1raYTtSVe7TEiIFauSwv3MU73PuFOtakb0hiJAS5svyaF6Lfexn5OaqlQYEbUnD
         kj5GzoyrUZ0ZPsrSsg3dLAEUvigG4LlPZC/icGfzdhr0NVlQTBmsv8oQ/AUc+EtR8b
         XK5MXEESB5jKw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MGaTbJ9yX1CL; Tue, 25 Apr 2023 17:59:04 +0200 (CEST)
Received: from [10.0.1.134] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id C0E4B6015F;
        Tue, 25 Apr 2023 17:59:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682438344; bh=XJOm+PL1n+IETGdWyBevOpSz4W+XaMIM22aU7kvoNeM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fTOp9HQFcasW9JeHbWAbqzZh5xeG3/BCY3vrSJpe3gq/BVQi9uNyzmA6HsnRArbnm
         goOLewTfza7SHvXKLZkCC7qMqT4aqS872pTr9R0BiMGSPcavzFcX0LaOwzMscCLSPx
         kk6bLVQMwmxcTFXt+y6jcGmJA33W8xlp1zvEMMaXEJHVkxu8pdB2Plm1ltXKoHECPN
         t61BdbSifOHajs1M/YrGgKuYC37in5PEHX8d0RJ1ppRstfxQ3uDvqrmn4oF2sPNK5o
         49rHExYqldoWJNH+7K6PaLtZNKmlM3QePa9CQVuZQH0hqhSIH890JZICJNkDa/8m/b
         vV+hhg8KUQo0g==
Message-ID: <3f91aab6-0f50-38cb-6a88-b2553b96e8cb@alu.unizg.hr>
Date:   Tue, 25 Apr 2023 17:59:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 1/1] wifi: mac80211: fortify the spinlock against
 deadlock by interrupt
Content-Language: en-US, hr
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
References: <20230425093547.1131-1-mirsad.todorovac@alu.unizg.hr>
 <20230425153353.GB27649@unreal>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230425153353.GB27649@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.4.2023. 17:33, Leon Romanovsky wrote:
> On Tue, Apr 25, 2023 at 11:35:48AM +0200, Mirsad Goran Todorovac wrote:
>> In the function ieee80211_tx_dequeue() there is a particular locking
>> sequence:
>>
>> begin:
>> 	spin_lock(&local->queue_stop_reason_lock);
>> 	q_stopped = local->queue_stop_reasons[q];
>> 	spin_unlock(&local->queue_stop_reason_lock);
>>
>> However small the chance (increased by ftracetest), an asynchronous
>> interrupt can occur in between of spin_lock() and spin_unlock(),
>> and the interrupt routine will attempt to lock the same
>> &local->queue_stop_reason_lock again.
>>
>> This will cause a costly reset of the CPU and the wifi device or an
>> altogether hang in the single CPU and single core scenario.
>>
>> This is the probable trace of the deadlock:
>>
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking scenario:
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop_reason_lock);
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_stop_reason_lock);
>> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>>                                                   *** DEADLOCK ***
> 
> Can you please add to the commit message whole lockdep trace?
> 
> And please trim "Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: " line prefix,
> it doesn't add any value.

Sure. I will do this ASAP. I thought of it myself, but I reckoned it would
be an overkill.

Will come in PATCH v4.

Best regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

