Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968E450BA57
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448783AbiDVOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448833AbiDVOm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 10:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA9A186D6;
        Fri, 22 Apr 2022 07:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC61960C48;
        Fri, 22 Apr 2022 14:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3A2C385A0;
        Fri, 22 Apr 2022 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650638403;
        bh=b7/jZiIlATjVz0SVzdTQKY1gBoE1osVlql0y6Vp4YAQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZxS3M0mahlvtX25TIoITOgMDAsdzAePR9er4CBsRP+mnusNZOSbFsNJ/XGgHBlYE7
         vgD8buziD6JIaSHyF/7Roh7zJZu9dXSor7AllEksPvvwdbGkbp4777f9Ta1YTsT/yM
         EqVJOUfwgEz1VOfQJowQPZGQy/040HCfdD3a38cTlUQewi1MhBbSS16XQJ+zpRo+3F
         Pqf0gOl4QJxbXnHk4i2oA2H3vVN0kGQYT+HvFZnZ56hwwMf5HjZ9MS8Fu/+0YWSKy9
         zW3kgneMMANKHAHnT4HeeoYIXIzImkdbVs+9BR4tIrNqwYmiK7Gc7u41enOY0g5vk2
         SQ+uZvGHwtwtQ==
Message-ID: <96b6dc1f-cf7b-73fe-d069-7ae16b3dcda2@kernel.org>
Date:   Fri, 22 Apr 2022 08:40:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 1/3] ipv4: Don't reset ->flowi4_scope in
 ip_rt_fix_tos().
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
References: <cover.1650470610.git.gnault@redhat.com>
 <c3fdfe3353158c9b9da14602619fb82db5e77f27.1650470610.git.gnault@redhat.com>
 <0d4e27ee-385c-fd5d-bd31-51e9e2382667@kernel.org>
 <20220422105345.GA15621@debian.home>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220422105345.GA15621@debian.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 4:53 AM, Guillaume Nault wrote:
> On Thu, Apr 21, 2022 at 08:30:52PM -0600, David Ahern wrote:
>> On 4/20/22 5:21 PM, Guillaume Nault wrote:
>>> All callers already initialise ->flowi4_scope with RT_SCOPE_UNIVERSE,
>>> either by manual field assignment, memset(0) of the whole structure or
>>> implicit structure initialisation of on-stack variables
>>> (RT_SCOPE_UNIVERSE actually equals 0).
>>>
>>> Therefore, we don't need to always initialise ->flowi4_scope in
>>> ip_rt_fix_tos(). We only need to reduce the scope to RT_SCOPE_LINK when
>>> the special RTO_ONLINK flag is present in the tos.
>>>
>>> This will allow some code simplification, like removing
>>> ip_rt_fix_tos(). Also, the long term idea is to remove RTO_ONLINK
>>> entirely by properly initialising ->flowi4_scope, instead of
>>> overloading ->flowi4_tos with a special flag. Eventually, this will
>>> allow to convert ->flowi4_tos to dscp_t.
>>>
>>> Signed-off-by: Guillaume Nault <gnault@redhat.com>
>>> ---
>>> It's important for the correctness of this patch that all callers
>>> initialise ->flowi4_scope to 0 (in one way or another). Auditing all of
>>> them is long, although each case is pretty trivial.
>>>
>>> If it helps, I can send a patch series that converts implicit
>>> initialisation of ->flowi4_scope with an explicit assignment to
>>> RT_SCOPE_UNIVERSE. This would also have the advantage of making it
>>> clear to future readers that ->flowi4_scope _has_ to be initialised. I
>>> haven't sent such patch series to not overwhelm reviewers with trivial
>>> and not technically-required changes (there are 40+ places to modify,
>>> scattered over 30+ different files). But if anyone prefers explicit
>>> initialisation everywhere, then just let me know and I'll send such
>>> patches.
>>
>> There are a handful of places that open code the initialization of the
>> flow struct. I *think* I found all of them in 40867d74c374.
> 
> By open code, do you mean "doesn't use flowi4_init_output() nor
> ip_tunnel_init_flow()"? If so, I think there are many more.
> 

no, you made a comment about flow struct being initialized to 0 which
implicitly initializes scope. My comment is that there are only a few
places that do not use either `memset(flow, 0, sizeof())` or `struct
flowi4 fl4 = {}` to fully initialize the struct.

