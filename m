Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25F1674A77
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjATEDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjATEDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:03:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB54AA62
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057EA61DF7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B2CC433EF;
        Fri, 20 Jan 2023 04:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674187425;
        bh=nTfMdQeDr2rqJRKAwhiBlB0m8rVV6lCzZadPcKMmd7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GsQQroC5nFI3UfP5FxM53AtB0qjyidaVlxyKaoflU+4FjJmcYyamfaSNaIZb9aAAQ
         WgetJ69nZYvOaNUdYh0S5kCfmu6YU7e26c65S8uC89cK6t+PENuJCK38eNnlcAYONd
         q8gMnw2IIG2W5jn0oKfh+jOPEyMmHvpDN/Da8qt2egOmps9ZAY6eot70TD9S9E9GvU
         QvF1FevrQr5oqkD4N2mMjVSgDuMqw1u6UQWhnxtYUnGLcEJX6KesLtg9n81EyOKxnL
         BhVmv/3SkLcYmDPRwryqd4yDoleZp012k79zJ0RVlSPFeFLTlKSReLncgM/Ahn27qv
         b7p4JmoTdySOw==
Date:   Thu, 19 Jan 2023 20:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230119200343.2eb82899@kernel.org>
In-Reply-To: <87tu0luadz.fsf@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org>
        <87tu0luadz.fsf@nvidia.com>
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

On Thu, 19 Jan 2023 19:56:24 -0800 Rahul Rameshbabu wrote:
> >> Makes sense. Once you've verified that the delta is within the accepted
> >> range you can just re-use the existing adjtime function.  
> >
> > Seems like we should add a "max_time_adj" to struct ptp_clock_info
> > and let the core call adjphase if the offset is small enough to fit.
> > Instead of having all drivers redirect the calls internally.  
> 
> With guidance from Saeed on this topic, I have a patch in the works for
> advertising the max phase adjustment supported by a driver through the
> use of the PTP_CLOCK_GETCAPS ioctl. This is how the ptp stack handles
> advertising the max frequency supported by a driver today. In linuxptp,
> this ioctl is wrapped in a function call for getting the max frequency
> adjustment supported by a device before ptp is actually run. I believe a
> similar logic should occur for phase (time) adjustments. This patch
> would introduce a "max_phase_adj" in ptp_clock_info that would be
> handled in ptp_clock_adjtime in the ptp core stack.

Nice, can we make the core also call ->adjtime automatically if driver
doesn't define ->adjphase and the abs(delta) < .max_phase_adj ?

The other question is about the exact semantics of ->adjphase
- do all timecounter based clock implementations support it
by definition?
