Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221205F81AC
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJHA4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 20:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJHA4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 20:56:52 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77527AC3D;
        Fri,  7 Oct 2022 17:56:50 -0700 (PDT)
X-UUID: 2ebf0370a34f46b4abc3e11987af5c9e-20220930
X-Spam-Fingerprint: 0
X-GW-Reason: 11105
X-Policy-Incident: 5pS25Lu25Lq66LaF6L+HMTDkurrpnIDopoHlrqHmoLg=
X-Content-Feature: ica/max.line-size 73
        audit/email.address 1
        dict/adv 1
        dict/prolog 2
        dict/software 1
X-CPASD-INFO: de9937b40a214caa8fcf90116348478d@rbVzWWBqkGRcgXR9g6asm1iXk5ZpXFG
        AeG1UaGJnZISVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3s6dzWWNlkg==
X-CLOUD-ID: de9937b40a214caa8fcf90116348478d
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:155.
        0,ESV:1.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:108.0,IP:-3.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:-5.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-5,
        AUF:6,DUF:6086,ACD:96,DCD:96,SL:0,EISP:0,AG:0,CFC:0.439,CFSR:0.08,UAT:0,RAF:2
        ,IMG:-5.0,DFA:0,DTA:0,IBL:-5,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EAF:0,
        CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 2ebf0370a34f46b4abc3e11987af5c9e-20220930
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 2ebf0370a34f46b4abc3e11987af5c9e-20220930
X-User: jianghaoran@kylinos.cn
Received: from [192.168.11.89] [(223.70.160.245)] by mailgw
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1221825997; Fri, 30 Sep 2022 19:24:42 +0800
Subject: Re: [PATCH] taprio: Set the value of picos_per_byte before fill
 sched_entry
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.oltean@nxp.com
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
 <20220929191815.51362581@kernel.org>
From:   jianghaoran <jianghaoran@kylinos.cn>
Message-ID: <a8dc6b79-2741-d101-d9a8-4521406ef7d6@kylinos.cn>
Date:   Fri, 30 Sep 2022 19:18:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220929191815.51362581@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/9/30 ÉÏÎç10:18, Jakub Kicinski Ð´µÀ:
> On Wed, 28 Sep 2022 14:58:30 +0800 jianghaoran wrote:
>> If the value of picos_per_byte is set after fill sched_entry,
>> as a result, the min_duration calculated by length_to_duration is 0,
>> and the validity of the input interval cannot be judged,
>> too small intervals couldn't allow any packet to be transmitted.
> 
> Meaning an invalid configuration is accepted but no packets
> can ever be transmitted?  Could you make the user-visible
> issue clearer?
   Yes, It's possible that the user specifies an too small interval that 
couldn't allow any packet to be transmitted.According to the following 
example, the interval is set to 9, and the network port enp5s0f0 cannot 
send any data
> 
>> It will appear like commit b5b73b26b3ca ("taprio:
>> Fix allowing too small intervals") described problem.
>> Here is a further modification of this problem.
>>
>> example:
> 
> Here as well it seems worthwhile to mention what this is an example of.
> e.g. "example configuration which will not be able to transmit packets"
> 
>> tc qdisc replace dev enp5s0f0 parent root handle 100 taprio \
>>                num_tc 3 \
>>                map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>                queues 1@0 1@1 2@2 \
>>                base-time  1528743495910289987 \
>>                sched-entry S 01 9 \
>> 	      sched-entry S 02 9 \
>> 	      sched-entry S 04 9 \
>>                clockid CLOCK_TAI
> 
> Please add a Fixes tag pointing to the first commit where the issue was
> present, and CC Vladimir Oltean <vladimir.oltean@nxp.com> on the next
> version.
> 
Thank you for your suggestion. I will modify it as suggested
