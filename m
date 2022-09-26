Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1044B5EB1DD
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiIZULR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiIZULO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:11:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5DC67167;
        Mon, 26 Sep 2022 13:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8273612CE;
        Mon, 26 Sep 2022 20:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77FAC433C1;
        Mon, 26 Sep 2022 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664223070;
        bh=L8SaIbacS6LFgsZriqiodB0sAwX120ymTq7NRQMsp+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oX0tPFr65Uez1MWu1aSwAW82Ic+VsmsJLHSq+lM2iX378qaqqzMgq84VeFfXvJOFa
         O1CToi1+toRM21wTu/bFQ/3j+D2rJW9SsviYgQM2DyOulBDSd3fpGFBjPx6apPZBRs
         xBlqK3NaN87HMgusB4Nf7ZdIdY9ac8Wy+Qb6dHC6EXoVD3Ge4U7ji1D2MK64T8VdaF
         ziwXvzIoggIFUe2Ey5Lm/ajq4oRorZMJjKvsKgNrpfyy2F8tz5sTSBuGFjGerLZBNt
         dL832GXg7BReY/c24ulKbuAJUKyUuZi6mRkYsj0wpDNaQMrtmZEv99zwOmXWPXUxlE
         rU7J1GIQysIVw==
Date:   Mon, 26 Sep 2022 13:11:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Message-ID: <20220926131109.43d51e55@kernel.org>
In-Reply-To: <20220926040524.4017-1-shaneparslow808@gmail.com>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Sep 2022 21:05:24 -0700 Shane Parslow wrote:
> This patch fixes the control channel mapping for the 7360, which was
> previously the same as the 7560.
> 
> As shown by the reverse engineering efforts of James Wah [1], the layout
> of channels on the 7360 is actually somewhat different from that of the
> 7560.
> 
> A new ipc_chnl_cfg is added specifically for the 7360. The new config
> updates channel 7 to be an AT port and removes the mbim interface, as
> it does not exist on the 7360. The config is otherwise left the same as
> the 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
> In ipc_imem, a special case for the mbim port is removed as it no longer
> exists in the 7360 ipc_chnl_cfg.
> 
> As a result of this, the second userspace AT port now functions whereas
> previously it was routed to the trace channel. Modem crashes ("confused
> phase", "msg timeout", "PORT open refused") resulting from garbage being
> sent to the modem are also fixed.

What's the Fixes: tag for this one?
