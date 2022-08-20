Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FCA59A9D3
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbiHTADH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbiHTADF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:03:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29798115229
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 17:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6106B81213
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 00:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFC9C433C1;
        Sat, 20 Aug 2022 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660953782;
        bh=MUHgkC0/xiP4vpd7CEWWDpUXAA47VTA2ZRvUsUuwjdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffrVuyokRufyDmefRB8wDk0WSLg9ajzUI7G1LYe2uL5tbE4xiSIOSpy3TLUbfybHF
         wovKWZgthShxG1VC4bpQVN4uDQkrtTIurJmiFYLFTPtKC1vGFJAsLMAcx6mzGf0J93
         Eh9qQLz/M1477/tG7gfu8v5NrpaF1hd9aWSYuy8nE/wgjjFoClhmk9XOw2KAQX8SDs
         m914zv2kR1Dyg4t/6eHPmZ/oTdO1oUIPsV8s62EMJ6m+YIYdKrvyNO0T9SRjC3/s7I
         ceqECcQGbzm34MmA7rydtmiTqIjJ1dZxubnCytnUGK03Os1GUh41facCD7myaXkgWZ
         icoz1p5Zljlyg==
Date:   Fri, 19 Aug 2022 17:03:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Matthias Tafelmeier <matthias.tafelmeier@gmx.net>
Subject: Re: [PATCH v3 net 02/17] net: Fix data-races around weight_p and
 dev_weight_[rt]x_bias.
Message-ID: <20220819170301.43675f1a@kernel.org>
In-Reply-To: <20220818182653.38940-3-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
        <20220818182653.38940-3-kuniyu@amazon.com>
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

On Thu, 18 Aug 2022 11:26:38 -0700 Kuniyuki Iwashima wrote:
> -	dev_rx_weight = weight_p * dev_weight_rx_bias;
> -	dev_tx_weight = weight_p * dev_weight_tx_bias;
> +	WRITE_ONCE(dev_rx_weight,
> +		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_rx_bias));
> +	WRITE_ONCE(dev_tx_weight,
> +		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_tx_bias));

Is there some locking on procfs writes? Otherwise one interrupted write
may get overtaken by another and we'll end up with inconsistent values.
OTOH if there is some locking we shouldn't have to protect weight_p
here.
