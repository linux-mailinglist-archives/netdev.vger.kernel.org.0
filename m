Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24F06E711C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 04:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjDSC2L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Apr 2023 22:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDSC2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 22:28:10 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15293A92
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 19:28:06 -0700 (PDT)
X-QQ-mid: bizesmtp82t1681871281tqn9m8x5
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 10:28:00 +0800 (CST)
X-QQ-SSF: 00400000000000N0R000000A0000000
X-QQ-FEAT: 7L1V3dHhUFNUaZR+ud9qkrY10nGqz0f1+IQc5Qhq1715UKZR7Hj7BK/Qt4pl4
        4WHaDtoTi9fW1zAm2TAvgJx3chObjLbpGOYJ3yrHjrwjwO3ox0LNmnDZusgMTnwy8rtSr76
        t044pqcDKkKLbNeWc0ItsLcpAAPyX30C5Zfo0CmVuRcW8fIzp4rgjn4Rpo9xxTwNUROgdfC
        82k1rfBXyDwX+nk22zlO/usVJoDVWJdeHmfhvLb54KSfEJJPZMs8Q5VuxOM3fwuax61v27O
        HmfXAIt+HjUumw19QJWFudul4PTn99LUnxrKfWwITvtBZkauKc7elzHb/YxghmLHfIsC6ea
        D4ML4Na1smw+65GBP6vfsAFgE53Q+c8Zw2wQYMvXz5Vc4InJ8K9F4EBHKM993Yww5z434gI
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14529649914436362192
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <82c37bb4-b2b0-037a-7f63-71324f493e1d@huawei.com>
Date:   Wed, 19 Apr 2023 10:27:49 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1996D963-EFD9-420E-BEE2-E29B83F3811B@net-swift.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
 <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
 <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
 <82c37bb4-b2b0-037a-7f63-71324f493e1d@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年4月18日 20:11，Yunsheng Lin <linyunsheng@huawei.com> 写道：
> 
> On 2023/4/18 15:00, mengyuanlou@net-swift.com wrote:
>>>> + goto exit;
>>>> + case htons(ETH_P_ARP):
>>>> + ptype = WX_PTYPE_L2_ARP;
>>>> + goto exit;
>>>> + default:
>>>> + ptype = WX_PTYPE_L2_MAC;
>>> 
>>> Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
>>> && first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
>>> about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?
>>> 
>>    • The hardware needs to parse these packets with these ptype bits.
> 
> What does hw do after parsing these packets? Updating some stats according to
> the protocol type?
> It seems really related to hw implementation, I am just curious if it is worth
> the added overhead for driver.
> 
For ETH_P_1588 hw will add timestamp for packets. 
The others are used to loopback scene, because hw can not parse l2 type.

According to chip designers, the others are not necessary.
Does it really cost a a lot for driver? 
Thanks.

