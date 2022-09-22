Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF995E5A1A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiIVETL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiIVETG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:19:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35995A221B;
        Wed, 21 Sep 2022 21:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F2D62FAD;
        Thu, 22 Sep 2022 04:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3BEC433D6;
        Thu, 22 Sep 2022 04:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663820344;
        bh=8xodEWMTndBecZO1JG0sANGtdcIZJhdCKz1ZoOkxjMk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uW+exXsXSGrew87ZojaTnnu2Pv1UtGXzQqjjLX2b7oGph4+PQelJUJX11FgjpqatQ
         ELoqv5pR8bSV3/7535PDpBw6BVY4bi59s4BaKlJSIYVXzNRY6aDLmLKhJLPFtzieTO
         iB7297vU052/FKz0Dc21FYTixE1ykO1VrtaDUUK3SkYuK3biSXS0J7OKhhQjo/eWra
         7mj2sPUPAmfSHWCc1MV6VYkGtcRnMWzr/LNBb6lPibVdaMWLqUzHsztksp0W4hjZYv
         zIN6846mujkb0CwMdnKoomN+OWU5pYCeMqp4QWw7CJvtecSieKja+ya7GWiRyAj90B
         2nqT/vaz2aB1w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 10/12] iwlwifi: Track scan_cmd allocation size explicitly
References: <20220922031013.2150682-1-keescook@chromium.org>
        <20220922031013.2150682-11-keescook@chromium.org>
Date:   Thu, 22 Sep 2022 07:18:51 +0300
In-Reply-To: <20220922031013.2150682-11-keescook@chromium.org> (Kees Cook's
        message of "Wed, 21 Sep 2022 20:10:11 -0700")
Message-ID: <87fsgk6nys.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> In preparation for reducing the use of ksize(), explicitly track the
> size of scan_cmd allocations. This also allows for noticing if the scan
> size changes unexpectedly. Note that using ksize() was already incorrect
> here, in the sense that ksize() would not match the actual allocation
> size, which would trigger future run-time allocation bounds checking.
> (In other words, memset() may know how large scan_cmd was allocated for,
> but ksize() will return the upper bounds of the actually allocated memory,
> causing a run-time warning about an overflow.)
>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Via which tree is this iwlwifi patch going? Normally via wireless-next
or something else?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
