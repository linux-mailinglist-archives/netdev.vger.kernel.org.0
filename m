Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D216D70D1
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbjDDXky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDDXkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:40:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4133C1D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCD3863AAF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA6AC433EF;
        Tue,  4 Apr 2023 23:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680651652;
        bh=01NeFZJQPOy95EwDlgxBo13fn4NQIGl2zdbXqQ+4I5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B72at+Ftb1yvdhnS2IdWNJp4HdoAVnbZ/qIsb4F7arr70dCo5n4jnw8Exg7lkIYi2
         JOVQfyfxZygMqtlyAUQiW6nb/ULexl03JoRsO1SWYxKoFd+mrtBbtSiPIrziZjeK96
         Kw2PhmrMsbzA4/+03YSNRma9r7fDMePu07x1dVbdOmY22sr1RNDpVrhYMFH3Yzdpht
         skGyVBiTR784eL3dt6YPIm3mMcKom81HJ5xQe0sKZ4TzqDN3EFszRoNwMjHh6ex+tr
         CmmQW8VkgGxcN7lVw42olji/l1G15p2FMmod6hftdS9/nW3tLLNAvSCuBm3eYzuUve
         ExKjIaoNl/5Cw==
Date:   Tue, 4 Apr 2023 16:40:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH net-next 2/6] net: ethtool: record custom RSS
 contexts in the IDR
Message-ID: <20230404164050.1a2a5952@kernel.org>
In-Reply-To: <cfaa6688-125f-9f2e-805a-ce68281d60d2@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
        <20230403144839.1dc56d3c@kernel.org>
        <cfaa6688-125f-9f2e-805a-ce68281d60d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 12:49:18 +0100 Edward Cree wrote:
> > GFP_USER? Do you mean it for accounting? GFP_KERNEL_ACCOUNT?  
> 
> It's an allocation triggerable by userland; I was under the
>  impression that those were supposed to use GFP_USER for some
>  reason; the rss_config alloc further up this function does.

That's what I thought, too, and that it implies memory accounting.
But then someone from MM told me that that's not the case, and
that GFP_USER is supposed to be mmap()able. Or maybe the latter
part I got from the kdoc in gfp_types.h.

I think we should make sure the memory is accounted.
