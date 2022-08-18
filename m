Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEA0598CEB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbiHRTwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244114AbiHRTwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A4ABD082;
        Thu, 18 Aug 2022 12:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B30F61350;
        Thu, 18 Aug 2022 19:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D5DC433D6;
        Thu, 18 Aug 2022 19:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660852331;
        bh=m1qLH1khdhLgXXJ8Oum2nCd1dLUuylNG5JT3wUqtFRI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QrnBzcj5gpY87uXumC4RCuNvtSb4lwZjE4IxY3z5QesW18+AHDhuPEPWaQoX4ZqNe
         WKx/54z+tLAbUFWZDlnwuOxfEBXkMVO2wZ/b60fPo3s7cvpc/i2H/e2vdVS2s3Oi3Z
         tBiIsYJ4Cx7RLyKYJFDkCGkJ0rGMWzOXz7jOW6C7pNooe2Owq0cyrLrlvQoIYbjgFd
         Wi6F8U0gUhn8r6O+QdnFH45spaLBT6Pc1+dYs3Rhg4/tSjOw1L8/Iz8UTVKxkypDWa
         loUSuYf2ZwgX8rDG6UzLGO2+FccZSOXGJgVMGEDPgwscqrJ8O7JcFOea1Bke1eqOOb
         oLApkUI2c4lQA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8966155FAC7; Thu, 18 Aug 2022 21:52:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
In-Reply-To: <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 18 Aug 2022 21:52:08 +0200
Message-ID: <87pmgxuy6v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> writes:

> Support direct writes to nf_conn:mark from TC and XDP prog types. This
> is useful when applications want to store per-connection metadata. This
> is also particularly useful for applications that run both bpf and
> iptables/nftables because the latter can trivially access this
> metadata.

Looking closer at the nf_conn definition, the mark field (and possibly
secmark) seems to be the only field that is likely to be feasible to
support direct writes to, as everything else either requires special
handling (like status and timeout), or they are composite field that
will require helpers anyway to use correctly.

Which means we're in the process of creating an API where users have to
call helpers to fill in all fields *except* this one field that happens
to be directly writable. That seems like a really confusing and
inconsistent API, so IMO it strengthens the case for just making a
helper for this field as well, even though it adds a bit of overhead
(and then solving the overhead issue in a more generic way such as by
supporting clever inlining).

-Toke
