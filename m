Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D40C4FC7E6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiDKXAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiDKXAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 19:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F6D1A382
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 15:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40A3761777
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 22:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F90C385A4;
        Mon, 11 Apr 2022 22:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717866;
        bh=a/3DmNUvz8+SO6ZFsddHOOslw+E1jUtBf6lFjrPFsJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OtFGbLMQr5tthdn03lz+hSR8JVx1ccVMqBNQd2iJxZq93/l+hDtqxuev5YIxHFbcU
         hwor0Tj2r/OGlwwYWz26qvyPprjoUvOcz32b7Dk5JlHsH30tKcBxgSeC+2JI10CVuK
         Hz79TNshZ26pu1sGVCh86vtiIx2DjGR0zubwD7JIXcFlLzP6sDmpQ18hhLLwocCjYk
         VYOc5HAs0zI6VCbcSo3zraRvb1KPGilLEB5Y+R5kHllP4ABBheR8vvlR0LirqSEa+7
         HFjzng7ZtVAsN7ILNCWpgSdl24AFafaHQfvRqpXiqQ5RTop5jT7Iji9JW+CALt0oZ6
         u8s4gm+/EE2aA==
Date:   Mon, 11 Apr 2022 16:57:43 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 1/8] net: rtnetlink: add RTM_FLUSHNEIGH
Message-ID: <20220411225743.GA8838@u2004-local>
References: <20220411172934.1813604-1-razor@blackwall.org>
 <20220411172934.1813604-2-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411172934.1813604-2-razor@blackwall.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 08:29:27PM +0300, Nikolay Aleksandrov wrote:
> Add a new rtnetlink type used to flush neigh objects. It will be
> initially used to add flush with filtering support for bridge fdbs, but
> it also opens the door to add similar support to others (e.g. vxlan).
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  include/uapi/linux/rtnetlink.h | 3 +++
>  security/selinux/nlmsgtab.c    | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 83849a37db5b..06001cfd404b 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -194,6 +194,9 @@ enum {
>  	RTM_GETTUNNEL,
>  #define RTM_GETTUNNEL	RTM_GETTUNNEL
>  
> +	RTM_FLUSHNEIGH = 124,
> +#define RTM_FLUSHNEIGH	RTM_FLUSHNEIGH
> +

rtm message types are "new, del, get, set" quadruplets; making this a
flush breaks the current consistent style. Can this be done by adding
a FLUSH flag to the RTM_DELNEIGH message?

>  	__RTM_MAX,
>  #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
>  };
