Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BFD3E1E12
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 23:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhHEVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 17:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhHEVo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 17:44:56 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C09C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 14:44:36 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:ac9b:633a:b39c:8292] (unknown [IPv6:2600:8801:8800:12e8:ac9b:633a:b39c:8292])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 8E69F20814;
        Thu,  5 Aug 2021 14:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628199873;
        bh=SG8y+wGmnrw+h4//dHrug1zjlujLQ0fPwKI+rot+ESw=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=a5+rZ7OIKqA1eul1rkYfDm2gVofzw6dDZ1L+Z6enwMiVXnwq7z6FanenxYUweW8Cl
         0strXWCNfU6ebSRwejrlAJFfdEoe5GuW+TKC386hG6z7TfiW8GEANCVcxj0LlaR5sf
         lLO+dJ2lfxZFL6wg7O/j/Ld/ihRRHnzjsWy87TuI=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
Message-ID: <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
Date:   Thu, 5 Aug 2021 14:44:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 12:37 PM, Dario Alcocer wrote:
> On 7/28/21 12:24 PM, Andrew Lunn wrote:
>> Take a look at:
>>
>> https://github.com/lunn/mv88e6xxx_dump/blob/master/mv88e6xxx_dump.c
>>
> 
> Many thanks for the link; I will build and install it on the target. 
> Hope it will work with the older kernel (5.4.114) we're using.

I've got a dumb question: is mv88e6xxx_dump intended to be built on the 
target, or do I use a cross compiler?

Unfortunately, the storage available on the target is too limited to 
entertain installing autotools, gcc and glibc headers.

On the other hand, the Yocto environment I'm using to cross-compile 
target binaries doesn't play nice with respect to kernel-source headers. 
In particular, the generic 5.2 uapi/linux/devlink.h provided by the 
build environment is missing various DEVLINK_CMD_* and DEVLINK_ATTR_* 
enums that prevent compilation of mv88e6xxx_dump.c.

One alternative I investigated was applying the debugfs patch to 5.13.6, 
but this resulted in many patch conflicts. Given this situation, it 
seems using mv88e6xxx_dump would be the easier path.

Regarding the original problem, using 5.13.6 no longer results in 
LOWERLAYERDOWN being reported; after a 5-6 second delay when bringing up 
the port interface, the switch port comes up. The RJ45 LED on the link 
peer turns on. However, pings do not make it to the link peer.

I will need to continue troubleshooting the switch configuration, so 
building a working mv88e6xxx_dump seems like the next task for me to tackle.

Thanks in advance for any suggestions you may have.
