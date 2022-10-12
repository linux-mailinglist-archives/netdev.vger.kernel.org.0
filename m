Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D815FC311
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJLJ3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJLJ3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:29:22 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42326DFA4;
        Wed, 12 Oct 2022 02:29:20 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oiY2r-00DtAP-6F; Wed, 12 Oct 2022 20:28:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Oct 2022 17:28:57 +0800
Date:   Wed, 12 Oct 2022 17:28:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH ipsec v6] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <Y0aI2bGb24M5vA7B@gondor.apana.org.au>
References: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 04:50:15PM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
> Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> ---
> Changes in v6:
>  - move overflow check to offloading path to avoid locking issues
> 
> Changes in v5:
>  - Fix build
> 
> Changes in v4:
>  - move changelog within comment
>  - add reviewer
> 
> Changes in v3:
> - fix build
> - remove wrapper function
> 
> Changes in v2:
> - switch to bool as return value
> - remove switch case in wrapper function
> ---
>  net/ipv4/esp4_offload.c |  3 +++
>  net/ipv6/esp6_offload.c |  3 +++
>  net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
>  net/xfrm/xfrm_replay.c  |  2 +-
>  4 files changed, 21 insertions(+), 2 deletions(-)

Could you please explain how this code restructure makes it safe
with respect to multiple users of the same xfrm_state?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
