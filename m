Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE4359A9D8
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244298AbiHTAEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbiHTAEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AD365565
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 17:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F25661899
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 00:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4417FC433B5;
        Sat, 20 Aug 2022 00:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660953887;
        bh=P9wsHjcl/2sRHasQrnLb0oyvcPBaGWkQzo6IvbncTnk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NWW5VORNOBBdExr8ySvtRA3bJ4+yTO9jo4VOhEcgiuCpEM/ktrTcVrKv2U89DhIuT
         wrRo3C7/K5+7Ycnpv4aGnzRZByhkb6F829Pyd3AbtPqAgJzWmEi1P6JqSQi1/dhBQb
         4om2V/8N0x4x9e2+GxbImEoGqOyhZjlsASKC5sDTVK9tOza0nEfaeVDS6Jg0N11clU
         ytUMC0897bj9OCkHGT0bSOeZg8oWCbVaFKzsPEiq8KIuoKe57eBG2e8oFtjf/7sQA9
         zpFZiKOAjNLyZ3BBjpq/ZV6ZndFnChGCF4wfEbOXKk93VT1DHezjmFIgD8NxJvfgnB
         kqk7f4GMJ9XOw==
Date:   Fri, 19 Aug 2022 17:04:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in
 ___ratelimit().
Message-ID: <20220819170446.77eeb642@kernel.org>
In-Reply-To: <20220818182653.38940-6-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
        <20220818182653.38940-6-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 11:26:41 -0700 Kuniyuki Iwashima wrote:
> +	int interval = READ_ONCE(rs->interval);
> +	int burst = READ_ONCE(rs->burst);

Also feels a little bit like papering over an issue if we read 
two values separately.
