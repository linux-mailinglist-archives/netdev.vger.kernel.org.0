Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD04647CB9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiLIDq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiLIDq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:46:56 -0500
Received: from pv50p00im-ztdg10011301.me.com (pv50p00im-ztdg10011301.me.com [17.58.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB557B2EDC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 19:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1670557610;
        bh=M/NG7opl2pujEn6z9UDdCBRv6DyefkxjNT4PBlqOqow=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=XF4ycNDW5H6Kq22yeIMT0Jcr8/J9AUu9e8Om+8L+oXYC7T79bnoZuesN9ZPYeD6hY
         9gK7eUCwwQLgOQqfLB96xu/FBLjr7nwsy2dNx3o2t03Ppb2SwY1J5vOiCro87A8ieo
         phnJHz+vqC7Ih+ui69Sbp3FX62rz4eFi3Hsd2X0DHUZwSxKeWxATDWVMEBxu2iPSF2
         fazzY+3a4419W1K2Lsx5AyLPTxvkvHp7Y1InNLLMh/r7JZ54MDZawOJznw+G/5na/G
         4b0z91Qc2YpDTd9fVeGA1aytj0NID+IYRUSnrwrmnxMUCHbCTcgK+IYP0l6eqwEHJ1
         Y2bxfBirPnm6Q==
Received: from [192.168.1.28] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10011301.me.com (Postfix) with ESMTPSA id 7B3331806D3;
        Fri,  9 Dec 2022 03:46:47 +0000 (UTC)
Message-ID: <08319f41-b745-23f4-a3b4-42d2bffbb471@zzy040330.moe>
Date:   Fri, 9 Dec 2022 11:46:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
 <167051122141.9839.8256110387408123706.kvalo@kernel.org>
Content-Language: en-US
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <167051122141.9839.8256110387408123706.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: q2am-jmUu2iUbxjGiqeLqVwO3UyDX8p3
X-Proofpoint-ORIG-GUID: q2am-jmUu2iUbxjGiqeLqVwO3UyDX8p3
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 clxscore=1030 malwarescore=0 adultscore=0 suspectscore=0
 mlxlogscore=420 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212090030
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/12/2022 22:53, Kalle Valo wrote:
> Jun ASAKA <JunASAKA@zzy040330.moe> wrote:
>
>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>> issues for rtl8192eu chips by replacing the arguments with
>> the ones in the updated official driver as shown below.
>> 1. https://github.com/Mange/rtl8192eu-linux-driver
>> 2. vendor driver version: 5.6.4
>>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Patch applied to wireless-next.git, thanks.
>
> 695c5d3a8055 wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>
Thanks!
