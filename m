Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478515B1961
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiIHJyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiIHJyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:54:33 -0400
X-Greylist: delayed 2404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Sep 2022 02:53:54 PDT
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F067E4DCE;
        Thu,  8 Sep 2022 02:53:54 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <martin.roukala@mupuf.org>)
        id 1oWCgK-0001r3-TX; Thu, 08 Sep 2022 10:14:40 +0200
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <martin.roukala@mupuf.org>)
        id 1oWCgH-00085i-L9; Thu, 08 Sep 2022 10:14:37 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1057822)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oWCg9-0000HB-VA; Thu, 08 Sep 2022 10:14:30 +0200
Message-ID: <cc9ff9ea-1f2e-16e9-a612-2ad4521440a6@mupuf.org>
Date:   Thu, 8 Sep 2022 11:14:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: RaspberryPi4 Panic in net_ns_init()
To:     Maxime Ripard <maxime@cerno.tech>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20220831144205.iirdun6bf3j5v6q4@houat>
 <20220905111832.73nqtlzpiuwpj7lx@houat>
Content-Language: en-US
From:   Martin Roukala <martin.roukala@mupuf.org>
In-Reply-To: <20220905111832.73nqtlzpiuwpj7lx@houat>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/22 14:18, Maxime Ripard wrote:
> On Wed, Aug 31, 2022 at 04:42:05PM +0200, Maxime Ripard wrote:
>> Sorry for the fairly broad list of recipients, I'm not entirely sure
>> where the issue lies exactly, and it seems like multiple areas are
>> involved.
>>
>> Martin reported me an issue discovered with the VC4 DRM driver that
>> would prevent the RaspberryPi4 from booting entirely. At boot, and
>> apparently before the console initialization, the board would just die.
>>
>> It first appeared when both DYNAMIC_DEBUG and DRM_VC4 were built-in. We
>> started to look into what configuration would trigger it.
>>
>> It looks like a good reproducer is:
>>
>> ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j18 defconfig mod2yesconfig
>> ./scripts/config -e CONFIG_DYNAMIC_DEBUG
>> ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j18 olddefconfig
> 
> Interestingly, this was making the kernel Image cross the 64MB boundary.
> I've compiled the same configuration but with -Os, and then tried to
> boot the failing configuration with U-Boot instead of the RaspberryPi
> firmware, and both of them worked. I guess that leaves us with a
> bootloader bug, and nothing related to Linux after all.
> 
> Sorry for the noise,
> Maxime

Thanks a lot for figuring this out, Maxime! The idea to use -Os is much 
nicer than what I was going for: padding a working kernel with 0s at the 
end!

I unfortunately did not try to reproduce your success with u-boot, but 
I'll get to it in the near future.

Thanks again to everyone involved for all the help and support!
Martin
