Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D86682BA3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjAaLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjAaLkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF6D59DC;
        Tue, 31 Jan 2023 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD3A614CE;
        Tue, 31 Jan 2023 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB6C433EF;
        Tue, 31 Jan 2023 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675165217;
        bh=fpVdmUsizy21lgvSqpax4jkq48QkKwIQbejaACB1vKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3ZxQFZuTN8z6yWlWMEhMJ5fx9HoxiWNCOpxTJlaGzug/OST5NPe7ynhkK2FTXIFY
         GOQfAZaeCdhvBgjVvKymAmOjH+lB/PYbcINkzl4PoaWNR1lQdgZ76373hQFxLIUr/T
         Exe6YHyRk9WzvOi/ssPSKbC2pic9/o+inpzUeEJCgEjVb/gMMkdfjD9xDlHEAQYAcz
         ktZ+nrlqnETS9t0zzme0zWfX/9BwB5RQZORl0Q3F6CaDd4IBIa+FxtJ5jtwNggTd38
         E6NK51YzqIVw4r+9SjyEu42UKh5ywrFUnSnqqh3T+iCXix+JREe6MFEaeGf+pByprJ
         m+YPvoun1VOKA==
Date:   Tue, 31 Jan 2023 13:40:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] net: ipa: remaining IPA v5.0 support
Message-ID: <Y9j+Ha5t+DSB+rRm@unreal>
References: <20230130210158.4126129-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 03:01:50PM -0600, Alex Elder wrote:
> This series includes almost all remaining IPA code changes required
> to support IPA v5.0.  IPA register definitions and configuration
> data for IPA v5.0 will be sent later (soon).  Note that the GSI
> register definitions still require work.  GSI for IPA v5.0 supports
> up to 256 (rather than 32) channels, and this changes the way GSI
> register offsets are calculated.  A few GSI register fields also
> change.
> 
> The first patch in this series increases the number of IPA endpoints
> supported by the driver, from 32 to 36.  The next updates the width
> of the destination field for the IP_PACKET_INIT immediate command so
> it can represent up to 256 endpoints rather than just 32.  The next
> adds a few definitions of some IPA registers and fields that are
> first available in IPA v5.0.
> 
> The next two patches update the code that handles router and filter
> table caches.  Previously these were referred to as "hashed" tables,
> and the IPv4 and IPv6 tables are now combined into one "unified"
> table.  The sixth and seventh patches add support for a new pulse
> generator, which allows time periods to be specified with a wider
> range of clock resolution.  And the last patch just defines two new
> memory regions that were not previously used.
> 
> 					-Alex
> 
> Alex Elder (8):
>   net: ipa: support more endpoints
>   net: ipa: extend endpoints in packet init command
>   net: ipa: define IPA v5.0+ registers
>   net: ipa: update table cache flushing
>   net: ipa: support zeroing new cache tables
>   net: ipa: greater timer granularity options
>   net: ipa: support a third pulse register
>   net: ipa: define two new memory regions
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
