Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A756986D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiGGC4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiGGC4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:56:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C02F647;
        Wed,  6 Jul 2022 19:56:21 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ldgwl36WZzcmy1;
        Thu,  7 Jul 2022 10:54:15 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 10:56:17 +0800
Message-ID: <cb0966da-c8e8-6c08-4204-327ce7f11576@huawei.com>
Date:   Thu, 7 Jul 2022 10:56:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Content-Language: en-US
To:     Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <James.Morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
 <20220705160045.GA1240@willie-the-truck> <YsWzfPUmgtRZi/ny@myrica>
 <20220706161125.GB3204@willie-the-truck>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <20220706161125.GB3204@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/2022 12:11 AM, Will Deacon wrote:
> On Wed, Jul 06, 2022 at 05:08:49PM +0100, Jean-Philippe Brucker wrote:
>> On Tue, Jul 05, 2022 at 05:00:46PM +0100, Will Deacon wrote:
>>>> Given you've been taking a look and had objections in v5, would be great if
>>> you
>>>> can find some cycles for this v6.
>>>
>>> Mark's out at the moment, so I wouldn't hold this series up pending his ack.
>>> However, I agree that it would be good if _somebody_ from the Arm side can
>>> give it the once over, so I've added Jean-Philippe to cc in case he has time
>>> for a quick review.
>>
>> I'll take a look. Sorry for not catching this earlier, all versions of the
>> series somehow ended up in my spams :/
> 
> Yeah, same here. It was only Daniel's mail that hit my inbox!
> 
> Will
> .

Sorry, there is a misconfiguration in the huawei.com mail server:

https://lore.kernel.org/all/20220523152516.7sr247i3bzwhr44w@quack3.lan/

Our IT admins are working on this issue and hopefully they'll fix it soon.
