Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8F4BB069
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiBRDyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:54:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBRDyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:54:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372B22DC84B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB9E8B82558
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328D9C340E9;
        Fri, 18 Feb 2022 03:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645156429;
        bh=fVg4hBIlM4WyhdAdVPsWuh6zoeFeFX2J5bVKWMMPGuM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nfYMv+0VTPMqUeXLkpX7PlZYxvw2OJGBX8nySS6ZaMUJ8AkgSjj2gW4zH/lPJBV5N
         u4tlpdLNCGQwekSE9uwfUnfiImLfs8ukQuBFSyqyO3Jw5MiF8bX6YfHH7yzaJrzMQT
         GBocDaXd90TuKemO/yYAYenEPIl3ZKzDrM1/QBLKwQaYLYQlosNDOqwEUU73/A31jH
         u9zuyBe+GVpOyYM0MMc0ttWLgxsbSZZuo/FGU2t4aqpz8m83AbdS7A7bW+eEXhWGu8
         l2LkVmDPoUXtZolQnZZxX7dcKYDD96oVBsUoEJ5uLjsvCQ3J/111+peQrSWvD2J+0a
         PnKFcHJYnfgYA==
Message-ID: <6beec611-6af4-7a39-7581-a0a56821698d@kernel.org>
Date:   Thu, 17 Feb 2022 20:53:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [RFC PATCH net] vrf: fix incorrect dereferencing of skb->cb
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <1644844229-54977-1-git-send-email-alibuda@linux.alibaba.com>
 <4383fcc3-f7de-8eb3-6746-2f271578a9e0@kernel.org>
 <f9cdf4a8-1e6e-007e-4ccf-9eff9573ef4f@linux.alibaba.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <f9cdf4a8-1e6e-007e-4ccf-9eff9573ef4f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 10:37 PM, D. Wythe wrote:
> Got your point, this patch is not really appropriate considering
> that. Another way to complete the test may be to modify the IP address
> of vrf blue in test script，the default local loopback address is the
> reason for this failure. What do you think ?

Someone needs to dive into the source address selection code and see why
it fails when crossing vrfs. I found a reminder note:
ipv6_chk_acast_addr needs l3mdev check. Can you take a look?
