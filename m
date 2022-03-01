Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99A24C9996
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiCAX6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiCAX6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:58:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7B88BF1D;
        Tue,  1 Mar 2022 15:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5EB6140C;
        Tue,  1 Mar 2022 23:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F726C340EE;
        Tue,  1 Mar 2022 23:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646179092;
        bh=KWv76Q2EMIsDVyxOr1ybYw+y0edCn8cbbmznG253gHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H5HpHnatIv4ATBKw3ik8xbQNnT+O7aCi0jUXoTrP5w8wtOxDk4mwFzvDRP+QlCODF
         i2+H+UMnhKrN4fmj0U1E/hqouxLZiFQY8j+lMRhSIYuneNUYOcFhOByzPbmWegLVAE
         opO91k8GhZNo0zkrslHs0kSe7pwCTx2No8/9Y6fEbjM0OsESDuzL2aNvmW5jrzIJDf
         aQxhlsr2fMBK+SlLH0y4jIe84eRkhK5BK9LfRK7QzUPFKSDG5q7kJtxcnlt5Bsu8vt
         ZvRgJYh+rlJIWzvBH5ta4s5fa65nRnxqrE6+4lRWz7D6mcQaUFHjo0RmaKrKcIoMFf
         fgmAcibytKFyA==
Date:   Tue, 1 Mar 2022 15:58:10 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [net-next v8 2/4] page_pool: Add recycle stats
Message-ID: <20220301235810.ywhifu27sbco67bd@sx1>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-3-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1646172610-129397-3-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Mar 14:10, Joe Damato wrote:
>Add per-cpu stats tracking page pool recycling events:
>	- cached: recycling placed page in the page pool cache
>	- cache_full: page pool cache was full
>	- ring: page placed into the ptr ring
>	- ring_full: page released from page pool because the ptr ring was full
>	- released_refcnt: page released (and not recycled) because refcnt > 1
>

Kernel documentation.

[...]

>
>@@ -410,6 +423,11 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
> 	else
> 		ret = ptr_ring_produce_bh(&pool->ring, page);
>
>+#ifdef CONFIG_PAGE_POOL_STATS
>+	if (ret == 0)
>+		recycle_stat_inc(pool, ring);
>+#endif
>+
> 	return (ret == 0) ? true : false;
> }
>

To avoid the ifdef, it makes more sense to refactor to:

if (!ret) {
	recycle_stat_inc(pool, ring);
         return true;
}

return false;   


