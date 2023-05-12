Return-Path: <netdev+bounces-2131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC6C700703
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881A81C211CD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39627D514;
	Fri, 12 May 2023 11:41:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282AFBE54
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:41:10 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD9270F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:41:05 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QHmv53CC0z18KL3;
	Fri, 12 May 2023 19:36:49 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 12 May
 2023 19:41:02 +0800
Subject: Re: [PATCH net-next v4 2/7] net: wangxun: libwx add rx offload
 functions
To: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
CC: <netdev@vger.kernel.org>, Jiawen Wu <jiawenwu@trustnetic.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-3-mengyuanlou@net-swift.com>
 <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
 <25FF2886-3FE3-4B20-9A77-217ADE6502B8@net-swift.com>
 <06898ce3-3995-2e83-3b2b-97f92fa46d7c@huawei.com>
 <4AB10E12-CFA2-4879-9346-8C73E926B706@net-swift.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <070f4c8b-c208-9701-7d17-6a2bd2c470f0@huawei.com>
Date: Fri, 12 May 2023 19:41:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4AB10E12-CFA2-4879-9346-8C73E926B706@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/12 14:00, mengyuanlou@net-swift.com wrote:
>> 2023年5月11日 19:48，Yunsheng Lin <linyunsheng@huawei.com> 写道：
>>
>> On 2023/5/11 16:34, mengyuanlou@net-swift.com wrote:
>>>>> @@ -321,8 +321,31 @@
>>>>
>>>> ...
>>>>
>>>>> +
>>>>> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 ptype)
>>>>
>>>> If the above is only used in one .c file, maybe it does not need
>>>> to be in the .h file?
>>>
>>> If I put it to .c file which use it, when compiling the other .c files will say
>>> "warning: ‘wx_ptype_lookup’ defined but not used”.
>>
>> Is 'wx_ptype_lookup' used in other .c file? if not, why not move
>> it to .c file too?
>>
> I mean how to you fix this compile warning.

Doesn't moving wx_decode_ptype() and wx_ptype_lookup to the
same C file solve the problem?

> 
>>>>
>>>>> +{
>>>>> + return wx_ptype_lookup[ptype];
>>>>> +}
>>>>> +
>>
> 
> 
> .
> 

