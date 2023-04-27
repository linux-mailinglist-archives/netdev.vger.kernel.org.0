Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35B6F0DD7
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344175AbjD0Vye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 17:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344148AbjD0Vy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 17:54:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529882D69;
        Thu, 27 Apr 2023 14:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4FEA63FA2;
        Thu, 27 Apr 2023 21:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C9C433D2;
        Thu, 27 Apr 2023 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682632461;
        bh=5jyq9pCiWcfs3d6AHx9K4T1jjd8/Liwe3W5FVncTTcY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WD563Sc/B5aCQDh6w4nraFRJhPwMDKHFvw05UZKotrhnaa1Gv+vRQCzI57YMon1lN
         nGHlqCd2L20afda2t6w2aMD63Ua/pXHdnRN6qj3++OK81r7ogAbxHn0uaYg95sgucf
         dYiiG6GQ+dcjZhCA1h3nKmaImDg1ofFulA/8D8wO+0CZV1FWmtuBIOuswsoI8ILYR2
         wVyiJzzDO5EqXaUHNKWCFJ2lRgIfciZz5qpSzGMYY+eQDJ9VqONHtkmJA2Vd2lqAql
         z0UDUaGoa0J+f5fmxr6hLUVz5gRHEPWpilyQUPqkbaqARIuap9BCZQQ1VhpdAL9Lsl
         q0oIZFzOrja/A==
Message-ID: <46a3adcb-856c-9f62-b31e-053ff92f9673@kernel.org>
Date:   Thu, 27 Apr 2023 15:54:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [net] selftests: srv6: make srv6_end_dt46_l3vpn_test more robust
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20230427094923.20432-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230427094923.20432-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/23 3:49 AM, Andrea Mayer wrote:
> On some distributions, the rp_filter is automatically set (=1) by
> default on a netdev basis (also on VRFs).
> In an SRv6 End.DT46 behavior, decapsulated IPv4 packets are routed using
> the table associated with the VRF bound to that tunnel. During lookup
> operations, the rp_filter can lead to packet loss when activated on the
> VRF.
> Therefore, we chose to make this selftest more robust by explicitly
> disabling the rp_filter during tests (as it is automatically set by some
> Linux distributions).
> 
> Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Tested-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../testing/selftests/net/srv6_end_dt46_l3vpn_test.sh  | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


