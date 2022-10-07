Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34EE5F79DD
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJGOm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGOmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:42:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F595FC1F1;
        Fri,  7 Oct 2022 07:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5F27B82391;
        Fri,  7 Oct 2022 14:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413D8C433C1;
        Fri,  7 Oct 2022 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665153742;
        bh=N+Dkca/1ANmKCX95FuTD8Uh0PW316buLTk1oJ1PNBus=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ONz6/ttwT2ihoBEF9GL/0QGxqYJspotmOaP6jlJwQJMjBjlO30xWYe+WMCxi4/JcY
         Edzv5gX36waLnMxjBi95c7EniYLgcu/Icox2QODkKzc3cKjXrjpB+jhmXklSQAdP2g
         6UGX5+IAUdFArVzvQUGjv2lg+Fdeg7K9x4X5yBCRqnbLsxuD8w82VKTViPD9XZjfMM
         FKiOqp9ENXQ2kaWgbNNT6um8EtwGzReKhWwxRKuzWOjujh6CWhXW9IOaIqg36Op77A
         nzL0BJkceKCpUL/m4W+JvsNSIMYOrcVpOWue1JlaRa017cymNjzAMopO4Fu7KvpZ+2
         T7yA1H5Dbc/rA==
Message-ID: <c898f060-90f7-d6a5-4f3d-8d40428b5c83@kernel.org>
Date:   Fri, 7 Oct 2022 08:42:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [REGRESSION] Unable to NAT own TCP packets from another VRF with
 tcp_l3mdev_accept = 1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Maximilien Cuony <maximilien.cuony@arcanite.ch>
Cc:     netdev@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Mike Manning <mvrmanning@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
 <20220930174237.2e89c9e1@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220930174237.2e89c9e1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/22 6:42 PM, Jakub Kicinski wrote:
> Adding netfilter and vrf experts.
> 
> On Wed, 28 Sep 2022 16:02:43 +0200 Maximilien Cuony wrote:
>> Hello,
>>
>> We're using VRF with a machine used as a router and have a specific 
>> issue where the router doesn't handle his own packets correctly during 
>> NATing if the packet is coming from a different VRF.
>>
>> We had the issue with debian buster (4.19), but the issue solved itself 
>> when we updated to debian bullseye (5.10.92).
>>
>> However, during an upgrade of debian bullseye to the latest kernel, the 
>> issue appeared again (5.10.140).
>>
>> We did a bisection and this leaded us to 
>> "b0d67ef5b43aedbb558b9def2da5b4fffeb19966 net: allow unbound socket for 
>> packets in VRF when tcp_l3mdev_accept set [ Upstream commit 
>> 944fd1aeacb627fa617f85f8e5a34f7ae8ea4d8e ]".
>>

This is the discussion that led up to that commit:

https://lore.kernel.org/netdev/940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com/

In short, users complained of the opposite problem.

Not sure how we can appease both wants.
