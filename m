Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2605ABC7F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiICCxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiICCxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE7A86C2A;
        Fri,  2 Sep 2022 19:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2C54B82D0E;
        Sat,  3 Sep 2022 02:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9524C433D6;
        Sat,  3 Sep 2022 02:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662173606;
        bh=OUYx9zqyVhkPwKlBXjzCx3T9nSj8tuR4ByliWLPFxNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LyWkGIYwv2Gpf20eWkMR5EpzxrZuPMrWhZ6Y8KlZzD+vLhsfN5a+A7/9k99ZGslxe
         ganDQ8ch4bBysvmjAGq831CecqiRy3GHP6u5qSGQnne7YpVH3m4A5G0VPSrqyYc6uJ
         hcxCh5zoPbJKk77ZwmYNhGOlEi5p1KR51RGjto5VG0bkwERGv8IO1hsyQ6U86lIqw1
         LBMAFUmwCNgtHpYAWBRLYaOhg3yxqsLgzOBlxZLBZy4T4F+l7Iu4qS51goF9xHNOuf
         tOJRghHz0+T43wkVhLJiQKRdtExWhwWLW3dd6yhXudD6ULme1lRIfzO3dmDQjxgCe9
         nLI2K/UQYm/6Q==
Date:   Fri, 2 Sep 2022 19:53:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] netlink: Bounds-check struct nlmsgerr creation
Message-ID: <20220902195324.15a9ae30@kernel.org>
In-Reply-To: <202209021555.9EE2FBD3A@keescook>
References: <20220901071336.1418572-1-keescook@chromium.org>
        <202209021555.9EE2FBD3A@keescook>
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

On Fri, 2 Sep 2022 16:08:01 -0700 Kees Cook wrote:
> > -	if (extack->cookie_len)
> > -		tlvlen += nla_total_size(extack->cookie_len);
> > +	if (extack->_msg &&
> > +	    check_add_overflow(*tlvlen, nla_total_size(strlen(extack->_msg) + 1), tlvlen))
> > +		return false;  
> 
> If that's not desirable, then I guess the question I want to ask is
> "what can I put in the unsafe_memcpy() comment above that proves these
> values have been sanity checked? In other words, how do we know that
> tlvlen hasn't overflowed? (I don't know what other sanity checking may
> have already happened, so I'm looking directly at the size calculations
> here.)

The netlink helpers for adding attributes check whether there is enough
space left in the skb. So if the calculation overflows, so be it. We'll
hit EMSGSIZE in the writing phase and unwind. The writing should make
no assumptions about the skb size. In fact all dumps will routinely hit
EMSGSIZE as we try to fit as many objects into a skb as possible, so we
unwind the one that would go over. Unwinding is well exercised in a lot
of netlink code (not here, MSG_DONE/MSG_ERROR ain't a dump).

The pre-calculation is just an estimate, if the message size ends up
being insane it really doesn't matter if the calculation is 0, INT_MAX
or random(). User is not gonna get a response, anyway.

... unless someone uses the unsafe helpers like __nlmsg_put() rather
than nlmsg_put(), hence my suggestion in the other email.
