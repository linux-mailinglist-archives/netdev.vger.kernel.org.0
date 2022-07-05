Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72155566134
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 04:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiGEC2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 22:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiGEC2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 22:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27CAA470;
        Mon,  4 Jul 2022 19:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8678761888;
        Tue,  5 Jul 2022 02:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F4C3411E;
        Tue,  5 Jul 2022 02:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656988087;
        bh=6B51220r8b8eGLOfgzeZnrLl5t0Rp/BupIOHW7nrbCU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uT/gJ9KK7rAc/OO4qqPEbs2IxXJr3Au6JDIavp4zn3jC2ecb4SK2OIMp2elF7h32l
         IKY8AfCG+ArUwWbSBs/w3PYDNLPT3XogQB0QeP5b3Dq0vFyS7D8N3Uc69JNut6Llyd
         XDgYENrZtSJQlWoaA9rrLiz23eCKLpQuGk7Gkneyj5PRD7aPuJ8zeSyvMpKsqzT3si
         DusdpTs2QVS1KSnR7iYrOuAhu5hUJzFgHugFLxNYUj5uJZ2W1oDH4yc9QtewM0NXaj
         vhuEPahS3lmUGGazdUTWpeyflHWwdtWyoAzmoSLVuJps3Dctbk/z37qJ/rQvDDwqXJ
         HI8eFBt1WVKBg==
Message-ID: <ee35a179-e9a1-39c7-d054-40b10ca9a1f3@kernel.org>
Date:   Mon, 4 Jul 2022 20:28:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
 <20220628225204.GA27554@u2004-local>
 <2840ec03-1d2b-f9c8-f215-61430f758925@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <2840ec03-1d2b-f9c8-f215-61430f758925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/22 7:31 AM, Pavel Begunkov wrote:
> If the series is going to be picked up for 5.20, how about we delay
> this one for 5.21? I'll have time to think about it (maybe moving
> the skb managed flag setup inside?), and will anyway need to send
> some omitted patches then.
> 

I think it reads better for io_uring and future extensions for io_uring
to contain the optimized bvec iter handler and setting the managed flag.
Too many disjointed assumptions the way the code is now. By pulling that
into io_uring, core code does not make assumptions that "managed" means
bvec and no page references - rather that is embedded in the code that
cares.
