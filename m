Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0567D6602CF
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjAFPNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbjAFPNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:13:19 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C292077D29
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:13:17 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pDoPC-0008Gn-3z; Fri, 06 Jan 2023 16:13:14 +0100
Message-ID: <f0aef3a8-7cd3-efb0-715a-92bcd145715d@leemhuis.info>
Date:   Fri, 6 Jan 2023 16:13:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] gro: take care of DODGY packets
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Coco Li <lixiaoyan@google.com>
References: <20230106142523.1234476-1-edumazet@google.com>
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20230106142523.1234476-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673017997;6e12cd7e;
X-HE-SMSGID: 1pDoPC-0008Gn-3z
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.23 15:25, Eric Dumazet wrote:
> Jaroslav reported a recent throughput regression with virtio_net
> caused by blamed commit.
> 
> It is unclear if DODGY GSO packets coming from user space
> can be accepted by GRO engine in the future with minimal
> changes, and if there is any expected gain from it.
> 
> In the meantime, make sure to detect and flush DODGY packets.
> 
> Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-and-bisected-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>

Many thx for taking care of this. There is one small thing to improve,
please add the following tag here to make things easier for future code
archaeologists:

Link:
https://lore.kernel.org/r/CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com/

To explain: Linus[1] and others considered proper link tags important in
cases like this, as they allow anyone to look into the backstory of a
commit weeks or years later. That's nothing new, the documentation[2]
for some time says to place tags in cases like this. I care personally
(and made it a bit more explicit in the docs a while ago), because these
tags make my regression tracking efforts a whole lot easier, as they
allow my tracking bot 'regzbot' to automatically connect reports with
patches posted or committed to fix tracked regressions.

Apropos regzbot, let me tell regzbot to monitor this thread:

#regzbot ^backmonitor:
https://lore.kernel.org/r/CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

[1] for details, see:
https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/

[2] see Documentation/process/submitting-patches.rst
(http://docs.kernel.org/process/submitting-patches.html) and
Documentation/process/5.Posting.rst
(https://docs.kernel.org/process/5.Posting.html)

--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
