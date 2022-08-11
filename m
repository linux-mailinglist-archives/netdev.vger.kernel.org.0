Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCEB590037
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbiHKPjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiHKPjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AF398A40;
        Thu, 11 Aug 2022 08:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ABACB82128;
        Thu, 11 Aug 2022 15:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5759EC433C1;
        Thu, 11 Aug 2022 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232085;
        bh=Ge0ao3IlkYaEA/oggyEUXZM/khav/xX3ShWmPj2mtkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tlebtIg4GNKrYmMIHeZXVwR7iAEHmVAaCwu2+1YJMU7yVEROrcj7B9EEp6GIA4LVf
         d39ZbIMdAKJsNYxqyhTvVH6GONPThihtszeuVyrv8v335SBugtWoyOEzt16ks0IxUM
         Ke53oJzYvPc2+6SH16zOSW6oGLIzK1AFiQWUbPi/7sU4Qe1V+QQRFh2tGMdxg3ibvn
         JXNTWU2TjYTyj8JPs3DwswPZQQNy6Iotr+z4RLuuVUzO+fAy0S80mjMx9/1r0v4Emo
         5KwNm7+9KDrwZLmQTZ2YuDhaKWzRFdfCrYgrRwsrxohDlTk2qMFSJ4bKr/p3AC7+LU
         e4HJYz5IIZTLw==
Date:   Thu, 11 Aug 2022 08:34:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Message-ID: <20220811083435.1b271c7f@kernel.org>
In-Reply-To: <20220811080152.2dbd82c2@hermes.local>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220810211534.0e529a06@hermes.local>
        <20220810214701.46565016@kernel.org>
        <20220811080152.2dbd82c2@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randomly adding Michal to CC since I just realized I forgot
to CC him on the series.

On Thu, 11 Aug 2022 08:01:52 -0700 Stephen Hemminger wrote:
> > On Wed, 10 Aug 2022 21:15:34 -0700 Stephen Hemminger wrote:  
> > > Would rather this be part of iproute2 rather than requiring it
> > > to be maintained separately and part of the kernel tree.    
> > 
> > I don't understand what you're trying to say. What is "this", 
> > what is "separate" from what?  
> 
> I am saying that ynl could live as a standalone project or as
> part of the iproute2 tools collection.

It's a bit of a strange beast, because the YNL C library ends up being
relatively small:

 tools/net/ynl/lib/ynl.c                  | 528 +++++++++++++++++++++++++
 tools/net/ynl/lib/ynl.h                  | 112 ++++++

The logic is mostly in the codegen:

 gen.py                                   | 1601 +++++++++++++++++++++++++

but that part we need for kernel C code as well.

The generated code is largish:

 tools/net/ynl/generated/dpll-user.c      | 371 ++++++++++++++++++
 tools/net/ynl/generated/dpll-user.h      | 204 ++++++++++
 tools/net/ynl/generated/ethtool-user.c   | 367 ++++++++++++++++++
 tools/net/ynl/generated/ethtool-user.h   | 190 +++++++++
 tools/net/ynl/generated/fou-user.c       | 322 ++++++++++++++++
 tools/net/ynl/generated/fou-user.h       | 287 ++++++++++++++
 tools/net/ynl/generated/genetlink-user.c | 635 +++++++++++++++++++++++++++++++
 tools/net/ynl/generated/genetlink-user.h | 201 ++++++++++

but we don't have to commit it, it can be created on the fly 
(for instance when a selftest wants to make use of YNL).

Then again it would feel a lot cleaner for the user space library
to be a separate project. I've been putting off thinking about the
distribution until I'm done coding, TBH. Dunno.
