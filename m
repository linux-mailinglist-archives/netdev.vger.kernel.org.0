Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF3D5E84F7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiIWVeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiIWVeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:34:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA70E8169C;
        Fri, 23 Sep 2022 14:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50BE5B826A7;
        Fri, 23 Sep 2022 21:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E61C433D6;
        Fri, 23 Sep 2022 21:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663968857;
        bh=1bf394/ntfNf6tOullEYpHvqkLYxnSWWQADvxMCcEgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SP0hK8o8uULWrJgRoZ2lc3QXuzSBf0ejqXSyhgXvt5cM8Z6RdXWCRy32GcEU6Fva/
         +76aIWTaiD539yqt3Va0I8NGmowDO1K75bGDGfMsWy3NFBaqdNjBe1pitQOZmZm7dN
         INFo4Fxx14nT8yyOo5puYmAJlqx5VXIL+tZx6yA4l0qeW+6gstM0hfBUA5tMa3mVp6
         dNTpv4S8Q69xjAnCAZsIjrfobPXGkZD+BLnwocNt5S8A4cnPu3OFTDkEm/Xa/L0Spq
         MkyqqW9SseyDfpQueGC8uFArYMdvmt7veh3Lkoat/wNH868PuC+34mO0XXgsjc8z/Q
         4bkgO2bqVrqxg==
Date:   Fri, 23 Sep 2022 14:34:14 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 2/3] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
Message-ID: <Yy4mVv+4X/Tm3TK4@dev-arch.thelio-3990X>
References: <cover.1663778601.git.lorenzo@kernel.org>
 <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Wed, Sep 21, 2022 at 06:48:26PM +0200, Lorenzo Bianconi wrote:
> Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> destination nat addresses/ports in a new allocated ct entry not inserted
> in the connection tracking table yet.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

This commit is now in -next as commit 0fabd2aa199f ("net: netfilter: add
bpf_ct_set_nat_info kfunc helper"). Unfortunately, it introduces a
circular dependency when I build with my distribution's (Arch Linux)
configuration:

$ curl -LSso .config https://github.com/archlinux/svntogit-packages/raw/packages/linux/trunk/config

$ make -skj"$(nproc)" INSTALL_MOD_PATH=rootfs INSTALL_MOD_STRIP=1 olddefconfig all modules_install
...
WARN: multiple IDs found for 'nf_conn': 99333, 114119 - using 99333
WARN: multiple IDs found for 'nf_conn': 99333, 115663 - using 99333
WARN: multiple IDs found for 'nf_conn': 99333, 117330 - using 99333
WARN: multiple IDs found for 'nf_conn': 99333, 119583 - using 99333
depmod: ERROR: Cycle detected: nf_conntrack -> nf_nat -> nf_conntrack
depmod: ERROR: Found 2 modules in dependency cycles!
...

The WARN lines are there before this change but I figured they were
worth including anyways, in case they factor in here.

If there is any more information I can provide or patches I can test,
please let me know!

Cheers,
Nathan
