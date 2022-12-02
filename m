Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF2663FCF0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiLBAYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiLBAYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:24:09 -0500
Received: from pv50p00im-tydg10011801.me.com (pv50p00im-tydg10011801.me.com [17.58.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA13D49F4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669940400;
        bh=/w9TPf3NSlEwGn40lxKF4FT1gfTJedo6HFbvr7MYF64=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=GTlfj7VmIx0UJ793HT9AXvGwH31UcMAYs0EaDlknb+h+4S1YbjajjzoqauelwiBMs
         PINq0kGd8OL1gVaewn4llwFIuYGLwv961ul3aByYTMxTtpjVC99ia50AzGejB+UZkF
         SWHjv0fLCElwtyMPCM+Jk+Cm+1YQuxyrctMYseooAS+wq03f4mNoBOyhGbsk0cTTS0
         ZnKUCmZGgx3MinZX1tEzFWO8NTtymjtygJA95QN2TPBr7tD8cu1iFqw3eNqV41lP0s
         49hYXLDPbo5ESfOf+JYTXutiSuiReahtFIPzNb7/ghPcTP2C/fxSkANpDQG3P04Khp
         REhtVWF+kU3/g==
Received: from [10.8.0.2] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10011801.me.com (Postfix) with ESMTPSA id 9DF238008D0;
        Fri,  2 Dec 2022 00:19:56 +0000 (UTC)
Message-ID: <d647052f-47d2-55f7-ed75-15323c820b5e@zzy040330.moe>
Date:   Fri, 2 Dec 2022 08:19:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221201161453.16800-1-JunASAKA@zzy040330.moe>
 <48d5141e5b2f4309bde78cacb67341a3@realtek.com>
Content-Language: en-GB
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <48d5141e5b2f4309bde78cacb67341a3@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: QtRiEshMkjg48dELrj5FgmqmYgRcNqQi
X-Proofpoint-ORIG-GUID: QtRiEshMkjg48dELrj5FgmqmYgRcNqQi
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 clxscore=1030 phishscore=0 mlxlogscore=460 bulkscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212020000
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 8:14 am, Ping-Ke Shih wrote:

>
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Friday, December 2, 2022 12:15 AM
>> To: Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>> <JunASAKA@zzy040330.moe>
>> Subject: [PATCH v4] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>
>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>> issues for rtl8192eu chips by replacing the arguments with
>> the ones in the updated official driver as shown below.
>> 1. https://github.com/Mange/rtl8192eu-linux-driver
>> 2. vendor driver version: 5.6.4
>>
>> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
>
>> ---
>> v4:
>>   - fixed some mistakes.
>> v3:
>>   - add detailed info about the newer version this patch used.
>>   - no functional update.
>> ---
>>   .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 73 +++++++++++++------
>>   1 file changed, 51 insertions(+), 22 deletions(-)
>>
> [...]
>
Thanks for your review!


Jun ASAKA.

