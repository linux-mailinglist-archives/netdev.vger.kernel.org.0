Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6246B00A9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCHIQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCHIQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:16:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DAD574D9;
        Wed,  8 Mar 2023 00:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA162616D8;
        Wed,  8 Mar 2023 08:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFC8C433EF;
        Wed,  8 Mar 2023 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678263382;
        bh=aKO92MXg2jmTbgHfLTyeOk4tkfxLeY158tdu7j5zHPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvS6BEWEyS6V4hWqdJQw8UeOjG98vvr/Swgzv0kdDiFvN2DnJjdpZqfQ5oEYV34sV
         drP2X+JLSXby/OQ74K75zJZ+KB4jyauoMy6i0tt/JtGPkhpvLyC5z55g3OLNLelG8C
         ri8SSuVG2yXvd5lR1iDSYMl8H9Ouqf/5kWotRTsT882Us14AAFyESHhPUZsatE6xxo
         DoynNZEOVeyvuA5r0yHCYwJ4DmMcukpxQizcu1kg7dSgvOsZDT9PbLId1Jnby5r+W4
         yiikXicUykjlvDnVH04IdiUlNN0USrDcRndKMy8yZMtETaghTuHgi9IzpMt99pEgag
         il1JUg96cAu8g==
Date:   Wed, 8 Mar 2023 00:16:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, memxor@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, toke@kernel.org
Subject: Re: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs
Message-ID: <20230308001621.432d9a1a@kernel.org>
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Mar 2023 07:49:43 -0800 Joanne Koong wrote:
> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> 
> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> packet parsing:
>     * allowing operations on sizes that are not statically known at
>       compile-time (eg variable-sized accesses).
>     * more ergonomic and less brittle iteration through data (eg does not need
>       manual if checking for being within bounds of data_end)
> 
> When comparing the differences in runtime for packet parsing without dynptrs
> vs. with dynptrs, there is no noticeable difference. Patch 9 contains more
> details as well as examples of how to use skb and xdp dynptrs.

Oddly I see an error trying to build net-next with clang 15.0.7,
but I'm 90% sure that it built yesterday, has anyone seen:

../kernel/bpf/verifier.c:10298:24: error: array index 16 is past the end of the array (which contains 16 elements) [-Werror,-Warray-bounds]
                                   meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
                                                   ^                  ~~~~~~~~~~~~~~~~~~~~~~~~
../kernel/bpf/verifier.c:9150:1: note: array 'special_kfunc_list' declared here
BTF_ID_LIST(special_kfunc_list)
^
../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
#define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
                          ^
1 error generated.
