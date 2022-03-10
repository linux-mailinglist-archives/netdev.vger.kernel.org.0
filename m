Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B34D3F6F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 03:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiCJC6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 21:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiCJC6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 21:58:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D10122F4F;
        Wed,  9 Mar 2022 18:57:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FDA4610AB;
        Thu, 10 Mar 2022 02:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D6C340E8;
        Thu, 10 Mar 2022 02:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646881025;
        bh=TMsrqTzqCQLOUMzh7FRwm1+/uKdoKl9Y7nT2OfN8/OU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DJ4RP46yTKivVt/Kt+U3SyVfoLj3KMMvpA/Pk4VFoyPN8xBRwcjzVxeJRSkm2HZEB
         PUQoQCYg5gpwsHV9obERrf+A0Me5Km7Ck6oY6rCMPY61Zj0EeCjc0MERYzVrRjbYCN
         5HfHi2MCi2fC8oce8bLS1/g6iED04qCEGRMiL7P0By4DBKRcRO5HvxGxc1bucL4jMU
         sIIbeg9gzbYagWfPZQQyIHEXXqmNgvxUzOT/EmOmq0IQMWNB4HPZ3dU34IFGwe9Gqf
         gBOK8r5qjZBsA9C/VDXhtzHWcZFeTXVGRipc+7XuHUnBO2wXnov+q+T+2deDP6UUmr
         /UXzhlp++wMLQ==
Message-ID: <0f97539a-439f-d584-9ba3-f4bd5a302bc0@kernel.org>
Date:   Wed, 9 Mar 2022 19:57:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: IPv4 saddr do not match with selected output device in double
 default gateways scene
Content-Language: en-US
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, ja@ssi.bg
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
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

On 3/7/22 11:41 PM, Ziyang Xuan (William) wrote:
> Create VLAN devices and add default gateways with following commands:
> 
> # ip link add link eth2 dev eth2.71 type vlan id 71
> # ip link add link eth2 dev eth2.72 type vlan id 72
> # ip addr add 192.168.71.41/24 dev eth2.71
> # ip addr add 192.168.72.41/24 dev eth2.72
> # ip link set eth2.71 up
> # ip link set eth2.72 up
> # route add -net default gw 192.168.71.1 dev eth2.71
> # route add -net default gw 192.168.72.1 dev eth2.72
> 

...

> We can find that IPv4 saddr "192.168.72.41" do not match with selected VLAN device "eth2.71".
> 
> I tracked the related processes, and found that user space program uses connect() firstly, then sends UDP packet.
> 

...

> Deep tracking, it because fa->fa_default has changed in fib_select_default() after first __ip_route_output_key() process,
> and a new fib_nh is selected in fib_select_default() within the second __ip_route_output_key() process but not update flowi4.
> So the phenomenon described at the beginning happens.
> 
> Does it a kernel bug or a user problem? If it is a kernel bug, is there any good solution?

That is a known problem with multipath routes.
