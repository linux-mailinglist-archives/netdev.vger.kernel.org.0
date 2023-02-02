Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E0F6874D8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBBFBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjBBFB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:01:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FB266FB3;
        Wed,  1 Feb 2023 21:01:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 335A1B82434;
        Thu,  2 Feb 2023 05:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D65CC433EF;
        Thu,  2 Feb 2023 05:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675314068;
        bh=wlUk4lCrRKRpv/r/2OPUUZJLiXS8pGOC4TItEyb/wwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+qHA+JAJT5vxw+vV9DJ4mYYdXTzsyHocXXlAoQUq/S2bDVfyFN1ESafSLWL1x2Qi
         AGWvDg9YO4AkA83Cx4M1V0hu7MkW3PSWMlU65DIKxjNroEfh6Tx1XxpT3hECeo1J9H
         BXKZcBLsVMfAiibK5ld9s032R3u6XuNlAFvArzYDsUP4fB8ufX3Xt8KcUwZh0bIKIc
         daT5fe0QAm4eishftAWK6AtHwbIxh3nFEc+o3kj0zRZdJZ3QLv3lSjYVtqbAFHmhyH
         12oa2TiYo1ZKi0DzVLxmRh9HQIHl7H/1Pju2ZBwgY/1JL9UCjHFnAEotvJ836aagHy
         2btagHzcmT6og==
Date:   Wed, 1 Feb 2023 21:01:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Message-ID: <20230201210107.450ff5d3@kernel.org>
In-Reply-To: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 19:33:06 -0800 Michael Kelley wrote:
> @@ -990,9 +987,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
>  			  struct hv_netvsc_packet *packet,
>  			  struct hv_page_buffer *pb)
>  {
> -	u32 page_count =  packet->cp_partial ?
> -		packet->page_buf_cnt - packet->rmsg_pgcnt :
> -		packet->page_buf_cnt;
> +	u32 page_count = packet->page_buf_cnt;
>  	dma_addr_t dma;
>  	int i;

Suspiciously, the caller still does:

                if (packet->cp_partial)
                        pb += packet->rmsg_pgcnt;

                ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);

Shouldn't that if () pb +=... also go away?
