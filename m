Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85B4D280B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 06:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiCIFCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 00:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiCIFC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 00:02:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB9610BBC9;
        Tue,  8 Mar 2022 21:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDCD66189F;
        Wed,  9 Mar 2022 05:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD7EC340E8;
        Wed,  9 Mar 2022 05:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646802090;
        bh=u9AmhLjdiMXokE3skjPX/ILUo3bIn8slqzpW3UOIBlA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ru9BR2NmSn2/u7Ecwepa5h03WaDRzPvnoHxzDKws3BGyKBx19D8fsYu3cUwUeVGSU
         WFLjc5s2ikPFp2FimuYhyt3tmbdWG+yKEQC24QGJeiZA8TbZerfqKyYczV5swN3/16
         Ka1Mf3l99L4NnOlBo3M2KOk5ZLOtm70aZavnFUMdCuESwsLC/ffBeEz6p1BKBtzQCO
         NGsj2TPRb+KOA5UO5fkz5h0QPRJvW5EogZ+z41LK5HyKoGoKk5j1WoYufKaKfZDke2
         5w83RohUFDDJLuMGkI1HCmDShSJ558YDfiaBjRcD3l5Zw2lVDJnNW+8DCpOWd/r8do
         yJzLbqG1GyPCw==
Message-ID: <ff2e1007-5883-5178-6415-326d6ae69c34@kernel.org>
Date:   Tue, 8 Mar 2022 22:01:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
 <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
 <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
 <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <45522c89-a3b4-4b98-232b-9c69470124a3@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 12:46 PM, Tadeusz Struk wrote:
> That fails in the same way:
> 
> skbuff: skb_over_panic: text:ffffffff83e7b48b len:65575 put:65575
> head:ffff888101f8a000 data:ffff888101f8a088 tail:0x100af end:0x6c0
> dev:<NULL>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:113!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 1852 Comm: repro Not tainted
> 5.17.0-rc7-00020-gea4424be1688-dirty #19
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
> RIP: 0010:skb_panic+0x173/0x175
> 
> I'm not sure how it supposed to help since it doesn't change the
> alloclen at all.

alloclen is a function of fraglen and fraglen is a function of datalen.


