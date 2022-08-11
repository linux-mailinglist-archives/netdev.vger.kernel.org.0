Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E77F58F8E3
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiHKIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiHKIPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:15:01 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D98B8901AB
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:14:58 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:38120.474108747
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.94 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 91B8A2800A5;
        Thu, 11 Aug 2022 16:14:50 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id dd3347cf458a4524b4b3d577cb079b83 for pabeni@redhat.com;
        Thu, 11 Aug 2022 16:14:53 CST
X-Transaction-ID: dd3347cf458a4524b4b3d577cb079b83
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH v2] tcp: adjust rcvbuff according copied rate of user
 space
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        ycheng@google.com, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
References: <1660117763-38322-1-git-send-email-liyonglong@chinatelecom.cn>
 <CADVnQym47_uqqKWkGnu7hA+vhHjvURMmTdd0Xx6z8m_mspwFJw@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <12489b98-772f-ff2a-0ac4-cb33a06f8870@chinatelecom.cn>
Date:   Thu, 11 Aug 2022 16:14:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CADVnQym47_uqqKWkGnu7hA+vhHjvURMmTdd0Xx6z8m_mspwFJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2022 8:43 PM, Neal Cardwell wrote:
> On Wed, Aug 10, 2022 at 3:49 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>
>> every time data is copied to user space tcp_rcv_space_adjust is called.
>> current It adjust rcvbuff by the length of data copied to user space.
>> If the interval of user space copy data from socket is not stable, the
>> length of data copied to user space will not exactly show the speed of
>> copying data from rcvbuff.
>> so in tcp_rcv_space_adjust it is more reasonable to adjust rcvbuff by
>> copied rate (length of copied data/interval)instead of copied data len
>>
>> I tested this patch in simulation environment by Mininet:
>> with 80~120ms RTT / 1% loss link, 100 runs
>> of (netperf -t TCP_STREAM -l 5), and got an average throughput
>> of 17715 Kbit instead of 17703 Kbit.
>> with 80~120ms RTT without loss link, 100 runs of (netperf -t
>> TCP_STREAM -l 5), and got an average throughput of 18272 Kbit
>> instead of 18248 Kbit.
> 
> So with 1% emulated loss that's a 0.06% throughput improvement and
> without emulated loss that's a 0.13% improvement. That sounds like it
> may well be statistical noise, particularly given that we would expect
> the steady-state impact of this change to be negligible.
> 
Hi neal,

Thank you for your feedback.
I don't think the improvement is statistical noise. Because I can get small
improvement after patch every time I test.


-- 
Li YongLong
