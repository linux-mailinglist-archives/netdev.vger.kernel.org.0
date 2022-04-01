Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197FA4EFA31
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiDAS4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiDAS4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:56:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E9416BCCF
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1B18B825D5
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 18:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B586C2BBE4;
        Fri,  1 Apr 2022 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648839291;
        bh=VNgte+812vl7YdFUvitY0k0Y1tq5XuLIRoC+WkkXoMw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cWJptmscsa31nlumG64oJ9ASOZEdQg3T/Hu2epkfSQkpC+xwXQrdzFTnO1EfIM8o8
         z8HSbk0d1ueMV4BkdT7+XtXOOM0rEVl32t/QE/v+ZnHnGvPNEqfHujIliOybKC/N8B
         RdFAU4mZanD4gJ19zDMottmoMXt0/w9Nv2WW40Tya7aPYd67y7zzn/aqi1NCoAfWQU
         3HMsG8kJsy0noeTHDaLdAA4aKbEKGB7PYGUzPA8Hr+OjYiCtfM5Ry4l1P4it3IIFo+
         JVougPvnpBWoZKu3M1T52pXsL9Lq48m2Q6lKCLLsT2fAYlPKg+E36i4z0kpwDEvz2W
         qiqaC3xum3BIg==
Message-ID: <d3e42daa-1baf-27f5-520f-ac1c8a277339@kernel.org>
Date:   Fri, 1 Apr 2022 12:54:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to
 xfrm_dst_lookup
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        oliver.sang@intel.com
References: <20220401015334.40252-1-dsahern@kernel.org>
 <20220401115005.0c104b01@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220401115005.0c104b01@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/22 12:50 PM, Jakub Kicinski wrote:
> On Thu, 31 Mar 2022 19:53:34 -0600 David Ahern wrote:
>> To: netdev@vger.kernel.org,  kuba@kernel.org,  davem@davemloft.net,  pabeni@redhat.com
>> Cc: oliver.sang@intel.com,  David Ahern <dsahern@kernel.org>
>> Subject: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
> 
> This needs Steffen and Herbert on CC. I'd just CC them in but
> patch was marked as Awaiting upstream in our PW already, so
> repost would be better. Regardless which tree it ends up getting
> applied to.

Prior l3mdev stuff went in through net/net-next, hence the cc list for
this one. I will re-send adding them.

> 
>> The commit referenced in the Fixes tag no longer changes the
>> flow oif to the l3mdev ifindex. A xfrm use case was expecting
>> the flowi_oif to be the VRF if relevant and the change broke
>> that test. Update xfrm_bundle_create to pass oif if set and any
>> potential flowi_l3mdev if oif is not set.
>>
>> Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Signed-off-by: David Ahern <dsahern@kernel.org>

