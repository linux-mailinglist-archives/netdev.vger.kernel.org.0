Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DBF4FA96E
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbiDIQLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 12:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiDIQLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 12:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE91B79C;
        Sat,  9 Apr 2022 09:09:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234E6B80A07;
        Sat,  9 Apr 2022 16:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D1FC385A4;
        Sat,  9 Apr 2022 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649520553;
        bh=uLu0gUUFNgtqWlOFmJYmdfZ7EDjychu4S3o5iExp6ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o44hJTm3hjOjJaNLxj7oBy1KWCXHMMLCUger488QLwaRzsD9UcAMWorkCA21xGgJK
         twFaNoSaGk1eLWYhdjOhkpu6vGoeiKItkVcBf4GLC+xheOloixLIRTlcdJOzXzVZqi
         tryEHAzXprJvWxzHOxqoOaOL7I5/8ewnBV0Eh042aiV2dtMJkQQowdnK7uP/LznC28
         AMmGzLbEDTbNsyu5vQY4js12WYBWkIUuPlARq6/ZPAgcZnI8RNx47DrKtcVKd7qny9
         teh4alBJSoLmIRG30yRQKG50S4JKSda1nKfQW1PKnknad3eq8EJCF9Fy+0j1DvF3Cp
         w2UA9JshkGIaA==
Date:   Sat, 9 Apr 2022 12:09:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Message-ID: <YlGvqEM0zbDc7OpX@sashalap>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
 <20220408152929.4zd2mclusdpazclv@skbuf>
 <YlBX5lhYHIXE0oBK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YlBX5lhYHIXE0oBK@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 05:42:30PM +0200, Greg Kroah-Hartman wrote:
>On Fri, Apr 08, 2022 at 03:29:30PM +0000, Vladimir Oltean wrote:
>> Hello Greg, Sasha,
>>
>> On Wed, Apr 06, 2022 at 10:29:53PM +0300, Vladimir Oltean wrote:
>> > As discussed with Willem here:
>> > https://lore.kernel.org/netdev/CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rKMzGgcPc6A@mail.gmail.com/T/
>> >
>> > the kernel silently doesn't act upon the SOF_TIMESTAMPING_OPT_ID socket
>> > option in several cases on older kernels, yet user space has no way to
>> > find out about this, practically resulting in broken functionality.
>> >
>> > This patch set backports the support towards linux-4.14.y and linux-4.19.y,
>> > which fixes the issue described above by simply making the kernel act
>> > upon SOF_TIMESTAMPING_OPT_ID as expected.
>> >
>> > Testing was done with the most recent (not the vintage-correct one)
>> > kselftest script at:
>> > tools/testing/selftests/networking/timestamping/txtimestamp.sh
>> > with the message "OK. All tests passed".
>>
>> Could you please pick up these backports for "stable"? Thanks.
>
>You sent this 2 days ago!
>
>Please relax :)

I've queued these up.

In general, we don't pick up new patches during -rc releases, which is
when you've sent this patchset and which is why sometimes it takes a few
days for stuff to go in.

-- 
Thanks,
Sasha
