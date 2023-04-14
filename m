Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CBF6E2C67
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjDNWPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDNWPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:15:32 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635DBED;
        Fri, 14 Apr 2023 15:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=E2iqAC4e8jj18fhA4xHnrQgND6+3IG1jF/EnLuweZnE=; b=VvNwNKknwQ/cANQSPbQktMATx+
        W95E4a51x/5P2pBPz3s56Fv82enAaqO6hEAgSlwHcTV3KRy4rGrxlQ/TJ+3W3wqlC7lTXg/Zysmt8
        Yyy0YNDE1URfwbZQLv9Zpcyblb3Yc943mqvnj8lO+19r530MVorQgK2tU2NhOXBpIiefAYDxE3QgJ
        nGKJqsXB7VE2axyZLyJL2HVsIZ9VQsOqtetpVQiYuccXr7IBmJP+VQApSZbbEg2FLgy5vl4A9xO9J
        6Pr0r1FybD9OG75nft8fJN7PG+ega66tdVBYpVXJfemrKDLKKg+BvLRlRiQQ6ga2z8kjQ5iOpctAl
        c1ykpGHQ==;
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnRhZ-000HB1-Cw; Sat, 15 Apr 2023 00:15:29 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pnRhZ-000KwH-2Y; Sat, 15 Apr 2023 00:15:29 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features for
 xdp_bonding selftest
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, joamaki@gmail.com
References: <73f0028461c4f3fa577e24d8d797ddd76f1d17c6.1681507058.git.lorenzo@kernel.org>
 <dc994c7b-c8fe-df8e-7203-0d6dae8dee9f@iogearbox.net>
 <ZDnPXYvfu46i0YpE@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dc040740-6823-c524-2580-e9604e04dcb0@iogearbox.net>
Date:   Sat, 15 Apr 2023 00:15:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ZDnPXYvfu46i0YpE@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26875/Fri Apr 14 09:23:27 2023)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/23 12:10 AM, Lorenzo Bianconi wrote:
>> On 4/14/23 11:21 PM, Lorenzo Bianconi wrote:
>>> NETDEV_XDP_ACT_NDO_XMIT is not enabled by default for veth driver but it
>>> depends on the device configuration. Fix XDP_REDIRECT xdp-features in
>>> xdp_bonding selftest loading a dummy XDP program on veth2_2 device.
>>>
>>> Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
>>
>> Hm, does that mean we're changing^breaking existing user behavior iff after
>> fccca038f300 you can only make it work by loading dummy prog?
> 
> nope, even before in order to enable ndo_xdp_xmit for veth you should load a dummy
> program on the device peer or enable gro on the device peer:
> 
> https://github.com/torvalds/linux/blob/master/drivers/net/veth.c#L477
> 
> we are just reflecting this behaviour in the xdp_features flag.

Ok, I'm confused then why it passed before?

>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    tools/testing/selftests/bpf/prog_tests/xdp_bonding.c | 11 +++++++++++
>>>    1 file changed, 11 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
>>> index 5e3a26b15ec6..dcbe30c81291 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
>>> @@ -168,6 +168,17 @@ static int bonding_setup(struct skeletons *skeletons, int mode, int xmit_policy,
>>>    		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog, "veth1_2"))
>>>    			return -1;
>>> +
>>> +		if (!ASSERT_OK(setns_by_name("ns_dst"), "set netns to ns_dst"))
>>> +			return -1;
>>> +
>>> +		/* Load a dummy XDP program on veth2_2 in order to enable
>>> +		 * NETDEV_XDP_ACT_NDO_XMIT feature
>>> +		 */
>>> +		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog, "veth2_2"))
>>> +			return -1;
>>> +
>>> +		restore_root_netns();
>>>    	}
>>>    	SYS("ip -netns ns_dst link set veth2_1 master bond2");
