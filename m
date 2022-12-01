Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB6563EA5A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 08:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLAHdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 02:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLAHde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 02:33:34 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB231230;
        Wed, 30 Nov 2022 23:33:32 -0800 (PST)
Message-ID: <add18909-4e5c-26e7-a96d-5715aba18219@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669880010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xOWjrGJdu4hvkFdo0cPlYtYhb6xXTXgIgC4dUMR8PA=;
        b=sgUWZobPQqtJgkJ/YNfh3z1l9pB9LL5dPuAYf9iiDD1VcMUKbcKNzDaGyuRkKiCyovmHvx
        iqaBzsXBqBbXEGsF1VzHOM3btc+G44pmGWFx2L4E0v7e9OjCQpO7StzkT3bziT/WNKV4n+
        kUq49xB8wYm90LI33IkQYd+XW21kAjQ=
Date:   Wed, 30 Nov 2022 23:33:21 -0800
MIME-Version: 1.0
Subject: Re: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com>
 <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
 <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 9:34 PM, Eyal Birger wrote:
>>> +static int probe_iproute2(void)
>>> +{
>>> +     if (SYS_NOFAIL("ip link add type xfrm help 2>&1 | "
>>> +                    "grep external > /dev/null")) {
>>> +             fprintf(stdout, "%s:SKIP: iproute2 with xfrm external support needed for this test\n", __func__);
>>
>> Unfortunately, the BPF CI iproute2 does not have this support also :(
>> I am worry it will just stay SKIP for some time and rot.  Can you try to
>> directly use netlink here?
> 
> Yeah, I wasn't sure if adding a libmnl (or alternative) dependency
> was ok here, and also didn't want to copy all that nl logic here.
> So I figured it would get there eventually.
> 
> I noticed libmnl is used by the nf tests, so maybe its inclusion isn't too
> bad. Unless there's a better approach.

I wasn't thinking about including the libmnl.  I am thinking about something 
lightweight like the bpf_tc_hook_create() used in this test. 
bpf_tc_hook_create() is in libbpf's netlink.c.  Not sure if this netlink 
link-add helper belongs to libbpf though, so it will be better just stay here in 
this selftest for now.  If it is too complicated without libmnl, leave it as 
SKIP for now is an option and I will try to run it manually first with a newer 
iproute2.

will reply other comments tomorrow.
