Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111E05AA060
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbiIATtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiIATtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57399C21D;
        Thu,  1 Sep 2022 12:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 492C261E58;
        Thu,  1 Sep 2022 19:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD8C433C1;
        Thu,  1 Sep 2022 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662061757;
        bh=DtcurkmNbe3mZsUd1jvvBGlCULoNGj3rYq35TfQpP1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dxNzcJKVGgwLiqhieRIUxxlMR/sJQ1gBJbYk0YgNiiFDg0RH9Qg+jr1SB/801Ai37
         tpea3dZ4Ff9fnnhbW7NSnp0zobEJmnW/fd6j0spU2DgzJqnVbmqeICfLWil/YsHReT
         96hax3xvTsZyoVQzRFrG+n2/1lvOZmkqzFpHjgHAVIRIaOqM9U/AsjVthwrfuA8aTL
         jWieYQsv2PCVBvOkvDxNfpsvSeiAZNstWucyEiQS4UD1UfMWwcVogwrGfVBHap6q8j
         jbox5XDnEVlHSeYyQUaJAwe+t8BEi851KFLdxVIBCGnBOKnr+7O8asEIWfvA/OX0Nk
         XwV6r0dkacKtw==
Date:   Thu, 1 Sep 2022 12:49:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzkaller@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] netlink: Bounds-check nlmsg_len()
Message-ID: <20220901124915.24ebc067@kernel.org>
In-Reply-To: <202208312324.F2F8B28CA@keescook>
References: <20220901030610.1121299-1-keescook@chromium.org>
        <20220901030610.1121299-2-keescook@chromium.org>
        <20220831201825.378d748d@kernel.org>
        <202208312324.F2F8B28CA@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 23:27:08 -0700 Kees Cook wrote:
> This would catch corrupted values...
> 
> Is the concern the growth in image size? The check_sub_overflow() isn't
> large at all -- it's just adding a single overflow bit test. The WARNs
> are heavier, but they're all out-of-line.

It turns the most obvious function into a noodle bar :(

Looking at this function in particular is quite useful, because 
it clearly indicates that the nlmsg_len includes the header.

How about we throw in a

	WARN_ON_ONCE(nlh->nlmsg_len < NLMSG_HDRLEN ||
		     nlh->nlmsg_len > INT_MAX);

but leave the actual calculation human readable C?
