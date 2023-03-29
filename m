Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632606CD890
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjC2Lg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC2Lg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:36:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4580040DC;
        Wed, 29 Mar 2023 04:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAFF9B822E4;
        Wed, 29 Mar 2023 11:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A0DC433EF;
        Wed, 29 Mar 2023 11:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680089784;
        bh=6+vy2/hB3y49UvGdSNmTWDpBgZjjMzQaTj4iQPJPGz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oOD1CPKf7kxcpdHrrYGQW8fDtLDNv7NU/d4CdfhU8WvDR+mzflcwhd2oAvC+ej3Yi
         5SiV0ygTLx2KvcQ7dJTPSRtgbfZTfYqJZRH4rvdvqZ/suKLMasAi+etIg2oW5myNZu
         gxYypg/5hBrHYR/wEeVOoEjDw7x2MhMVPFR+oOOaXJ94eg2WF2lDflW1VybIWYGWO6
         c/VKUmAG6Q1vp/sz8HVRTAn0r/Uwf4OuS/tZ46IqeysJVWLuGJ0RG2T9LEdCv/wmWR
         49UbXqs8a59E0kvkz7YNs5XaOOrQbNZ+TAXteqk+NEm5h78gUtN02jL3/tWRtz8ZV6
         3hlSwN3dQVUrg==
Date:   Wed, 29 Mar 2023 14:36:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, quic_bjorande@quicinc.com, mbloch@nvidia.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: ipa: compute DMA pool size properly
Message-ID: <20230329113620.GO831478@unreal>
References: <20230328162751.2861791-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328162751.2861791-1-elder@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 11:27:51AM -0500, Alex Elder wrote:
> In gsi_trans_pool_init_dma(), the total size of a pool of memory
> used for DMA transactions is calculated.  However the calculation is
> done incorrectly.
> 
> For 4KB pages, this total size is currently always more than one
> page, and as a result, the calculation produces a positive (though
> incorrect) total size.  The code still works in this case; we just
> end up with fewer DMA pool entries than we intended.
> 
> Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
> null pointer derereference in sg_alloc_append_table_from_pages(),
> descending from gsi_trans_pool_init_dma().  The cause of this was
> that a 16KB total size was going to be allocated, and with 16KB
> pages the order of that allocation is 0.  The total_size calculation
> yielded 0, which eventually led to the crash.
> 
> Correcting the total_size calculation fixes the problem.
> 
> Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
> Tested-by: Bjorn Andersson <quic_bjorande@quicinc.com>
> Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> Note: This was reported via private communication.
> v3: - Added Mark Bloch's reviewed-by tag.
> v2: - Added Bjorn's actual name to tags.  
> 
>  drivers/net/ipa/gsi_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
