Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2A5FE7A1
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJNDfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJNDfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:35:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68059B1DDB;
        Thu, 13 Oct 2022 20:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19A7619D0;
        Fri, 14 Oct 2022 03:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE140C433D6;
        Fri, 14 Oct 2022 03:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665718546;
        bh=e8NS7e8GjJLV43eHbx04zHu5yOOzyVWxuItjDNonERs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ifB5hUO6VFr4oTdSvyyX/fyRNocEJsrYDOR6p2ZjjIYQWGwSooeTIwQffaQikBtpx
         yuLQRio8jUNWiwz/v2SVhlycdPMi1jGp8NJw5dZda41qxB8L0y4HK/fcFlo3qaGvV6
         IZqbNt++TsglJtCBfHbbY80/QHspC3a75yICoZde5PhIF2aSP2+ovB9mI1VZ/0Xu2+
         /UTI+PBAoNoIEbjgz+G2YPL4A4Difg2+8LnFnFJO9910WUFquODq4arNJKu4FyOOyD
         JFfDlAZVMUalOrjRS5umQ/aDFpVng8eayhsmtW3ZnLAJmWmOJ+3fDucRYW+PFM+fEl
         ct6wwZi7VS9YQ==
Date:   Thu, 13 Oct 2022 20:35:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     guoren@kernel.org
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <20221013203544.110a143c@kernel.org>
In-Reply-To: <20221014030459.3272206-2-guoren@kernel.org>
References: <20221014030459.3272206-1-guoren@kernel.org>
        <20221014030459.3272206-2-guoren@kernel.org>
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

On Thu, 13 Oct 2022 23:04:58 -0400 guoren@kernel.org wrote:
> -	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> -	     j < nr_ids;) {
> +	for (j = -1; j < nr_ids;
> +	     j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {

This does not look equivalent, have you tested it?

nr_ids is unsigned, doesn't it mean we'll never enter the loop?

Can we instead revert 854701ba4c and take the larger rework Yury 
has posted a week ago into net-next?
