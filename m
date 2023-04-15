Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89FF6E2E50
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDOBq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOBq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D4C3AA0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078F964664
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006B7C433EF;
        Sat, 15 Apr 2023 01:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681523215;
        bh=ZXKj+yU5bJyvfW+AcqY3QPN0Pb/N5mZFp7eVM2lu2Tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dnH2N9iOeVDR7hama+KDnnOQRfJEAc7D5SuWkR5aAWcxznUeIOLnisXnUqkvqDQAN
         dH75c04N1AqTJINc5GdLCP3mEDNnvf8l2Z4oG+j+qq0vygsp9HGyvM9a0op1xyhB6y
         yl3AQbpQUHhmFEXeIp0rC+fPBF4xo5FxgyW+CeOByRKFD0Gl6o732iAS38ktdIYXvK
         0xsyvTmnthUNiopv8zeXoT1vtHnateriwY1zY3j113XONxI32TJVAzf6x2kqNrgHch
         uETTU6jlx3gZ7/geHzz+HE6DYYbwkZAGbunlSQscCTRhyY+k+p/mS4qVc/9AvKWRhp
         AzuF6+nPBNhHg==
Date:   Fri, 14 Apr 2023 18:46:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <20230414184653.21b4303d@kernel.org>
In-Reply-To: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 23:46:03 +0200 Lorenzo Bianconi wrote:
> @@ -411,6 +417,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		pool->pages_state_hold_cnt++;
>  		trace_page_pool_state_hold(pool, page,
>  					   pool->pages_state_hold_cnt);
> +		alloc_stat_inc(pool, pages);
>  	}
>  
>  	/* Return last page */

What about high order? If we use bulk API for high order one day, 
will @slow_high_order not count calls like @slow does? So we should
bump the new counter for high order, too.

Which makes it very similar to pages_state_hold_cnt, just 64bit...
