Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA94C9B6C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbiCBCvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiCBCvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF52CAA03D;
        Tue,  1 Mar 2022 18:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E87DB81D71;
        Wed,  2 Mar 2022 02:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEECFC340EE;
        Wed,  2 Mar 2022 02:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646189423;
        bh=1Ut1LLr4Atq1Pq8gzeCGEnkTqlLWoJAo/XJ606dYG4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u2FpaszFDe2MOIYTVPe0Go/spev6D6ZnV5PuPmm8rY/F8T5/wezkRfkScVhaitzzx
         z0kwqnK2kYs8Q50/D1afpRwF7G2fqmTa/3ZC82c2TxtO38Pcpuv6IlO/8sqcGLBtuA
         rZjtKREqSQAcH1jNficJaSW2Tox58ABz32Q9PGXLQShWx7H6Z2gaS+fR2Ok8MtnceT
         NCnuuaElaN62PwaeMHdIllbvjo/Sg04vvagz4n55ToFIxqh82+wGzPjkUDSqM4WwQj
         trPMomrbfrVWqRds4bz5Udns8anCKSyCSuR2+ZhxxYSLUp3GYYtT2cVNuZqhpSQVnV
         1zM3qUhoXFJDw==
Date:   Tue, 1 Mar 2022 18:50:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220226084929.6417-5-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-5-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:
> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */

IDK if these are not too low level and therefore lacking meaning.

What are your thoughts David?

Would it be better to up level the names a little bit and call SKB_PULL
something like "HDR_TRUNC" or "HDR_INV" or "HDR_ERR" etc or maybe
"L2_HDR_ERR" since in this case we seem to be pulling off ETH_HLEN?

For SKB_TRIM the error comes from allocation failures, there may be
a whole bunch of skb helpers which will fail only under mem pressure,
would it be better to identify them and return some ENOMEM related
reason, since, most likely, those will be noise to whoever is tracking
real errors?

>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>  					 * device driver specific header
>  					 */
> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */

What is ready? link is not up? peer not connected? can we expand?
