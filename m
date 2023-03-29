Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0FF6CD888
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjC2LeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC2LeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A793D420A;
        Wed, 29 Mar 2023 04:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CF161C83;
        Wed, 29 Mar 2023 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BC4C433EF;
        Wed, 29 Mar 2023 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680089660;
        bh=9ZZzD37dF+nf1PMk+V/UeGWfRgF2Ay/6Vk5uI3Z+uus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SHG9d0IdcjApM40F9CCBw8FOh+hjsWc2y3ZPJJj9uQnQ6KqsqbqAX1KXQItIKzB6j
         38x6K7kFdE2HK/GJEtPTzP5BT/zhjBCCnB+g0LLdtHDKlzJptQjNoRXOkSufk7cLZY
         rgjxfAxkmijS33dMumOGQNzfVDQtIzSQknoBkkuRlv7VIkSgGC2y2aDp/RE89IUaJ5
         nexmzJb0a3dNqUe0YJXEKJi+dbclug5yn3pNyL7mp5D25G+PjmwyywSw8vFNuSm6z9
         sA/tE4P+0Xg89pnbQDAH7HtecfvLzQjSJYS6ruAeXv+ZaG5KtV/le8TVJOjmlUZIAh
         SF6JkhJVJiSOw==
Date:   Wed, 29 Mar 2023 14:34:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, quic_bjorande@quicinc.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ipa: compute DMA pool size properly
Message-ID: <20230329113416.GM831478@unreal>
References: <20230328160833.2861095-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328160833.2861095-1-elder@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 11:08:33AM -0500, Alex Elder wrote:
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
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> Note: This was reported via private communication.
> v2: - Added Bjorn's actual name to tags.  

You discarded Mark's Reviewed-by tag.

> 
>  drivers/net/ipa/gsi_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
