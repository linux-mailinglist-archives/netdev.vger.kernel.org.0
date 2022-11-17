Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94D62D05C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 02:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiKQBFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 20:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiKQBFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 20:05:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67B862391;
        Wed, 16 Nov 2022 17:05:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FEFB62056;
        Thu, 17 Nov 2022 01:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1175AC433D6;
        Thu, 17 Nov 2022 01:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668647128;
        bh=wmyFGpkOFgVZYxJ5sPZ2ImF0xsR11q1JqnNT+TKuPPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fs6VwLYpiRRPUUQ55sMjWKKfOC9u0YVq7fSyAbQBDierVZjRD6tfsIzelXbgLUxug
         nvHZlLq5/HBRK39IEa2THXwx86NBXl/A+SBjbNkI29TNlnlTznGSIz7HHPXapd+TIq
         UH+71ocF8mYrGspg3lGrULk1zIshDYGL2B4BHVXTCSYcdVl98HiGzd021pm9EfX9bk
         bKz2MUf+yWJe9EBeJVg5bfriagqFqJu6KzJFc3FvAG96lgz7n2hpzYJPNYk3i0sJzJ
         HdkEO6BKgc1liw3PL0eMzgNiVSc8gdulHFr4cIZvnUMTv38aD1lI/IHup0W+Lk5Y5Z
         LvbrM9eSWvFLA==
Date:   Wed, 16 Nov 2022 17:05:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Kees Cook <keescook@chromium.org>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221116170526.752c304b@kernel.org>
In-Reply-To: <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
References: <20221027212553.2640042-1-kuba@kernel.org>
        <20221114023927.GA685@u2004-local>
        <20221114090614.2bfeb81c@kernel.org>
        <202211161444.04F3EDEB@keescook>
        <202211161454.D5FA4ED44@keescook>
        <202211161502.142D146@keescook>
        <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 18:55:36 -0600 Gustavo A. R. Silva wrote:
> > @@ -56,7 +55,6 @@ struct nlmsghdr {
> >   	__u16		nlmsg_flags;
> >   	__u32		nlmsg_seq;
> >   	__u32		nlmsg_pid;
> > -	__u8		nlmsg_data[];
> >   };  
> 
> This seems to be a sensible change. In general, it's not a good idea
> to have variable length objects (flex-array members) in structures used
> as headers, and that we know will ultimately be followed by more objects
> when embedded inside other structures.

Meaning we should go back to zero-length arrays instead?
Will this not bring back out-of-bound warnings that Kees 
has been fixing?

Is there something in the standard that makes flexible array
at the end of an embedded struct a problem?
Or it's just unlikely compiler people will budge?

AFAICT this is just one of 3 such structs which iproute2 build hits.
