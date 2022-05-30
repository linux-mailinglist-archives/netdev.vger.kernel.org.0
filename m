Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD8538606
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiE3QWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiE3QWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:22:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5955157B33;
        Mon, 30 May 2022 09:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3103B80C9C;
        Mon, 30 May 2022 16:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0965C3411C;
        Mon, 30 May 2022 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653927734;
        bh=w9uR6p19zt4t9FNAbykaSG3eVIwVY8qsIWAZ+DGrWEY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HWlpm46fgkL+OJIQu9JPKhtCaNloJDLGQKnezPzJ6FuZjk1go2Deynmxs7YUssobU
         zCEwP/FrZDXU6X6VQ9Y42sH/fGoUGh+7ma4dtTL3yuqTaFVviIynWsr6Va8N6q1NwF
         NU1cjFQBQVaRsCLlAhYzuPyluZkmmkp5pGs0VNGWe8Tu4mkuwX4gbwJY2ERehGeAvn
         RugO6ik7vQwB+geoXpee+C0lIj8x1IB5Hw/XcK/UVVeBx++lm1cnuGrvd5TK9dkK9t
         2buffm38wmHGOmHbL4h/fuXR4Faf4wzT0qJQHweCgC9tLSSWoJV5BNUsJuJhHxi1m1
         Z0cyfmpixiV8A==
Message-ID: <f79c9fc6-9635-50a6-8b71-f280bf2a192b@kernel.org>
Date:   Mon, 30 May 2022 10:22:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net v3] net/ipv6: Expand and rename accept_unsolicited_na
 to accept_untracked_na
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bagasdotme@gmail.com, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, prestwoj@gmail.com, corbet@lwn.net,
        justin.iurman@uliege.be, edumazet@google.com, shuah@kernel.org,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
References: <20220530101414.65439-1-aajith@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220530101414.65439-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 4:14 AM, Arun Ajith S wrote:
> RFC 9131 changes default behaviour of handling RX of NA messages when the
> corresponding entry is absent in the neighbour cache. The current
> implementation is limited to accept just unsolicited NAs. However, the
> RFC is more generic where it also accepts solicited NAs. Both types
> should result in adding a STALE entry for this case.
> 
> Expand accept_untracked_na behaviour to also accept solicited NAs to
> be compliant with the RFC and rename the sysctl knob to
> accept_untracked_na.
> 
> Fixes: f9a2fb73318e ("net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131")
> Signed-off-by: Arun Ajith S <aajith@arista.com>
> ---
> This change updates the accept_unsolicited_na feature that merged to net-next
> for v5.19 to be better compliant with the RFC. It also involves renaming the sysctl
> knob to accept_untracked_na before shipping in a release.
> 
> Note that the behaviour table has been modifed in the code comments,
> but dropped from the Documentation. This is because the table 
> documents behaviour that is not unique to the knob, and it is more
> relevant to understanding the code. The documentation has been updated
> to be unambiguous even without the table.
> 
> v2:
>   1. Changed commit message and subject as suggested.
>   2. Added Fixes tag.
>   3. Used en-uk spellings consistently.
>   4. Added a couple of missing comments.
>   5. Refactored patch to be smaller by avoiding early return.
>   6. Made the documentation more clearer.
> 
> v3:
>   1. Fixed build issue. (Verified make defconfig && make && make htmldocs SPHINXDIRS=networking)
> 
>  Documentation/networking/ip-sysctl.rst        | 23 ++++------
>  include/linux/ipv6.h                          |  2 +-
>  include/uapi/linux/ipv6.h                     |  2 +-
>  net/ipv6/addrconf.c                           |  6 +--
>  net/ipv6/ndisc.c                              | 42 +++++++++++--------
>  .../net/ndisc_unsolicited_na_test.sh          | 23 +++++-----
>  6 files changed, 50 insertions(+), 48 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


