Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FDD6452AE
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLGDvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLGDvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:51:05 -0500
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6D355CA5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1670385060;
        bh=71uvVBupzBmhVolaLTaYiI0Q+gs7E/uZmUCOc93n0ds=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=btxlYPgQDKIbbDMBWBe3w40hLfCMEw/fx6yn/ZldxumpVJaWhjwz9HCfxcYvE9JO4
         uU/2Li1j7GV5p4O5ZpBy9X7ZSAw87pePAsJML2mUChq5pOGhggIycitskVbSgpoOrn
         jHD2O1Tp4wdY4SCr18obi0O+8aiIt68spKkw7TSrsxSiTlSPr1mbPBQUhYBaayxqOp
         d1+OTCg9tIAvtsUFbVq1F9X8I/PuDOKII12HMxWhZ09xNQbBMU3cFSRkMmO9QFHpSA
         68VK3wlqnjUHs/3bazPKyBpE8HTP7aBCoRiwYXjhV6Z74RL93Kz5gv6avXne26BUYo
         RBvOxUEE7BnfA==
Received: from [192.168.1.28] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 4105A3A1608;
        Wed,  7 Dec 2022 03:50:56 +0000 (UTC)
Message-ID: <b4b65c74-792f-4df1-18bf-5c6f80845814@zzy040330.moe>
Date:   Wed, 7 Dec 2022 11:50:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Content-Language: en-US
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
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
 <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 3Fi4maIF69Wve_KeGqvRrpZLKDZ8-2oh
X-Proofpoint-ORIG-GUID: 3Fi4maIF69Wve_KeGqvRrpZLKDZ8-2oh
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 clxscore=1030 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=422 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212070027
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/12/2022 11:43, Ping-Ke Shih wrote:
>
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Wednesday, December 7, 2022 11:39 AM
>> To: Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>> <JunASAKA@zzy040330.moe>; Ping-Ke Shih <pkshih@realtek.com>
>> Subject: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>
>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>> issues for rtl8192eu chips by replacing the arguments with
>> the ones in the updated official driver as shown below.
>> 1. https://github.com/Mange/rtl8192eu-linux-driver
>> 2. vendor driver version: 5.6.4
>>
>> Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
>> ---
>> v5:
>>   - no modification.
> Then, why do you need v5?
Well,  I just want to add the "Reviewed-By" line to the commit message. 
Sorry for the noise if there is no need to do that.
