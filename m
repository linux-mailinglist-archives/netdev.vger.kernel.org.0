Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05AE641DE5
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 17:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiLDQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 11:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLDQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 11:27:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B412D22
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 08:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA71B8075D
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 16:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8419FC433D6;
        Sun,  4 Dec 2022 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670171223;
        bh=TdrB0iap48NOndrDtDvIYRIyKoFpzZrd+RWGWDQ+3qQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=D84G/yWdY1r6JucKyX/z9bv3//jgi4/Kt4jYlUKjVV3WZ2Gu/IQbFmglQ7OLje/sy
         x0J2mmCqV4tbRTl167Ys383ngg21oqDj6DDnfS2XMVIkDOCdU3OepsszkPKtaJz95V
         XmDnP8B4CsWtypVS4vtn0XDFaYbbVBpPbTtjdCZbi5cN/+6jskqAZvbbIIvDtgeLv0
         ZN0i4VpMK+7zS/2fbR81am2C3CIk2KpvjOp+nfcFjvxAKtO7cKHeRN2CH9oX6KRFrg
         eMxq0aVj9a5O0Bacdp7HcUma+WpKD4Opn6VIUX9zWz47lFOzu5i1xNeheiCYu5OgSS
         O5m4be4o5nozA==
Message-ID: <31b1b29b-432b-f628-af3e-c5fd03973148@kernel.org>
Date:   Sun, 4 Dec 2022 09:27:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net 2/2] ipv4: Fix incorrect route flushing when table ID
 0 is used
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mark.tomlinson@alliedtelesis.co.nz,
        sharpd@nvidia.com, mlxsw@nvidia.com
References: <20221204075045.3780097-1-idosch@nvidia.com>
 <20221204075045.3780097-3-idosch@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221204075045.3780097-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 12:50 AM, Ido Schimmel wrote:
> Cited commit added the table ID to the FIB info structure, but did not
> properly initialize it when table ID 0 is used. This can lead to a route
> in the default VRF with a preferred source address not being flushed
> when the address is deleted.
> 
> Consider the following example:
> 
>  # ip address add dev dummy1 192.0.2.1/28
>  # ip address add dev dummy1 192.0.2.17/28
>  # ip route add 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 100
>  # ip route add table 0 198.51.100.0/24 via 192.0.2.2 src 192.0.2.17 metric 200
>  # ip route show 198.51.100.0/24
>  198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 100
>  198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200
> 
> Both routes are installed in the default VRF, but they are using two
> different FIB info structures. One with a metric of 100 and table ID of
> 254 (main) and one with a metric of 200 and table ID of 0. Therefore,
> when the preferred source address is deleted from the default VRF,
> the second route is not flushed:
> 
>  # ip address del dev dummy1 192.0.2.17/28
>  # ip route show 198.51.100.0/24
>  198.51.100.0/24 via 192.0.2.2 dev dummy1 src 192.0.2.17 metric 200
> 
> Fix by storing a table ID of 254 instead of 0 in the route configuration
> structure.
> 
> Add a test case that fails before the fix:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Table ID 0
>      TEST: Route removed in default VRF when source address deleted      [FAIL]
> 
>  Tests passed:   8
>  Tests failed:   1
> 
> And passes after:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Table ID 0
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
> 
>  Tests passed:   9
>  Tests failed:   0
> 
> Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> Reported-by: Donald Sharp <sharpd@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_frontend.c                  |  3 +++
>  tools/testing/selftests/net/fib_tests.sh | 10 ++++++++++
>  2 files changed, 13 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


