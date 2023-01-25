Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9EE67A871
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjAYBgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYBgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB4D4A1DE
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00F15B817AE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0BBC433EF;
        Wed, 25 Jan 2023 01:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674610558;
        bh=19WzsmzUABsMHPuBjywDRKa+i7OGrq+X/TsqWSp8npc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rOHNwBEdctd2u+1FyBDJfLSdARAb3dknLz7DUjLK1X2FyS2ZEyuWNcv6Y9ZSq29Rx
         p4tkUEc2Fd4HFnLqAGrveuUj4T8yeRuzOwWcfM/xi9dlNbj7AbyDplF60W1OX/biWj
         FU7VIKPRbjCOGi7G+I6EAektbwr5JduRRTt2WOo+UKTkY4+NwQn3oVrd+NNf/Cz0Xl
         uNx4ZOg1Ixpxt2BkFeqD+t0cRiYkK15qcNngzVzWwJ/qNZ0w0rT8B/O1BrYwZifR7u
         9SD/zpJeEYpX2FwCN7fGHBNy3bWBxhE7jZ9vwlGeo7qINY1WRTUsS4+d1uYSLnle/F
         r2Q3A8jRU5fNg==
Date:   Tue, 24 Jan 2023 17:35:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of
 it was assigned by a task on other cpu
Message-ID: <20230124173557.2b13e194@kernel.org>
In-Reply-To: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Jan 2023 01:21:20 +0300 Kirill Tkhai wrote:
> Since in this situation unix_accept() is called chronologically later, such
> behavior is not obvious and it is wrong.

Noob question, perhaps - how do we establish the ordering ?
CPU1 knows that listen() has succeed without a barrier ?
