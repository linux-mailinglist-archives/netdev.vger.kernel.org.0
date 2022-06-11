Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E083B5476A8
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiFKQzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiFKQzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529C713DDA
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 09:55:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBCF861183
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 16:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC570C34116;
        Sat, 11 Jun 2022 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654966538;
        bh=y1eLe71GPiCRzRKaBoScWXaBsQL/zkZ9gvLyyF3yrMY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=EcF9K99YIfkYpgBvbz55lqfzgLV46mE5/9LSMcdmAnTT21TW8WyRrlzp322Y+prCQ
         Tnf0hnzvL14k2FaCOFkqv2pQt3yUgqh7A2iEs9KcAu1CQeOcSVRRVAiwXhrSU5Vwq8
         rVxazhgYja56Ep4cVIrQMbRA7MD4k2sr68AaA0wKZc7hfNAD+4BMH87O1/AuiFiX/A
         RtSEYH2MpnhcOpIzAeKcjqOnF+NOzT0+Ynry5hGVmjQ2ms2Jts4rJg+aJO7sGYqgeT
         L1/6JbqMT8itdgM8HjEk7rr2oe/fLVk08SHKm/JFro9x86riKLhmntgyY8+thdU2Rs
         9HsyI0tYBDrew==
Message-ID: <52e7f9d3-1c4b-b37c-8a02-0bab3a0c8229@kernel.org>
Date:   Sat, 11 Jun 2022 10:55:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: error on unsupported IP setsockopts in IPv6
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20220609152525.GA6504@debian>
 <20220610221656.2f08c7a8@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220610221656.2f08c7a8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 11:16 PM, Jakub Kicinski wrote:
> On Thu, 9 Jun 2022 17:26:10 +0200 Richard Gobert wrote:
>> The IP_TTL and IP_TOS sockopts are unsupported for IPv6 sockets,
>> this bug was reported previously to the kernel bugzilla [1].
>> Make the IP_TTL and IP_TOS sockopts return an error for AF_INET6 sockets.
>>
>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=212585
> 
> This is a little risky because applications may set both v4 and v6
> options and expect the correct one to "stick". Obviously it's not 
> the way we would have written this code today, but is there any harm?
> Also why just those two options?

agreed, I do not believe this can be changed. The values will not be
used for ipv6 packets, so the exposure should just be a matter of
allowing the setting on a socket.
