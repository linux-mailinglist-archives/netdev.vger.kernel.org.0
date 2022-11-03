Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0036173E2
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 02:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiKCBwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 21:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKCBwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 21:52:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFFC11458
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 18:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98744B82586
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 01:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA4BC433D6;
        Thu,  3 Nov 2022 01:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667440352;
        bh=WKXxUe9qQ+vrdwmNcy2do1LmKl6Fzx67RJ/Z0/8eGr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISeB0ySStJuKg4pNr/mV6NKkcNHH102qXWkd61qt6efcA4iH7C+KHRUBYUheTOjjc
         5WZE537uvlCp1jr7drm75/GDVlXfdLZzzk2ZdiS26d04UakY/nJ/fYFRhlnOipy4EC
         wpDjgUyF9+RM8dmxSJSZIm/HiVmuRgpIKMpctMfW7h+PRe022t/2eF4MwpSxfKLgTO
         FoN6VdBzMSERGNBr7HvRcMupdfH0gihq6jpDKlK5/OfmGm3CiuFxwECbqPCFRrOlUq
         7xQG1NWhu5YXYtjx6GMBs73Su9y+ADxCJCcMkrwYMQKomQPaLVh1GXsUcST2ObYHCk
         lWwyekKONrrIw==
Date:   Wed, 2 Nov 2022 18:52:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <razor@blackwall.org>, <nicolas.dichtel@6wind.com>,
        <gnault@redhat.com>, <fw@strlen.de>
Subject: Re: [PATCH net-next v2 01/13] genetlink: refactor the cmd <> policy
 mapping dump
Message-ID: <20221102185230.27ce05b1@kernel.org>
In-Reply-To: <83cb45fe-1ae5-4963-55e8-6d1ee6751aa1@intel.com>
References: <20221102213338.194672-1-kuba@kernel.org>
        <20221102213338.194672-2-kuba@kernel.org>
        <83cb45fe-1ae5-4963-55e8-6d1ee6751aa1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 16:52:21 -0700 Jacob Keller wrote:
> Does the change to ctx->opidx have any other side effects we care about? 
> if not it might be more legible to write this as:
> 
> /* don't modify ctx->opidx */
> }
> 
> while (!ctx->single_op && ctx->opidx < genl_get_cmd_cnt(ctx->r)) {
> 
> 
> That makes the intent a bit more clear and shouldn't need a comment 
> about entering the loop. It also means we don't need to modify 
> ctx->opidx, though I'm not sure if those other side effects matter or 
> not.. we were modifying it before..
> 
> I don't know what else depends on the opidx.

I was just trying to make the patches slightly easier to read.
This chunk gets rewritten again in patch 10, and the opidx thing 
is gone completely. I maintain a "keep dumping" boolean called
dump_map (because this code is dumping a mapping rather than 
the policies which come later)

LMK if I should try harder to improve this patch or what patch 10 
does makes this moot.
