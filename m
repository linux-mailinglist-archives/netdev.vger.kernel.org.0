Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F4657F66C
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 20:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiGXS2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 14:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGXS2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 14:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C6610559;
        Sun, 24 Jul 2022 11:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017C3611AF;
        Sun, 24 Jul 2022 18:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82D1C3411E;
        Sun, 24 Jul 2022 18:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658687328;
        bh=xjkjAJfFUzF+WA1oEacBMK6l7NtnI2Vp89y2dB4ruD4=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=bnlSBQVBtUuAS7qzZy/ew8oEYMacSmwObKzPqaN0I2Myn+lvPr6jivb+XDeWErVKv
         Eo/ITI4SeJAaz2vbUp0rcpWitiGTJbbQilSKDov8NRBAHkxcJHP2w5NJGQfslfcwgS
         A7J+Mse7iG0nRfa8vHcmA9HzQhuN5EeZRiG2CQLjnIQTXCJd6l+1fsCRG5lqEkEDYm
         HHFG9HL3TGkQiEcYWb46eJnuq9FuhN++I6WtXqqhVF0uR9sZfUCnzWDOrV2y8cydvy
         tQi5AQCHqDdN7KwznBnIvvWl/MAipi5ZLbWAn7wAs7eJ83nyv5++y94CBx5QMOgzJZ
         6CctKvlFEDgCg==
Message-ID: <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
Date:   Sun, 24 Jul 2022 12:28:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
 <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
In-Reply-To: <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/22 8:19 PM, David Ahern wrote:
>>
>> Haven't seen it back then. In general io_uring doesn't stop submitting
>> requests if one request fails, at least because we're trying to execute
>> requests asynchronously. And in general, requests can get executed
>> out of order, so most probably submitting a bunch of requests to a single
>> TCP sock without any ordering on io_uring side is likely a bug.
> 
> TCP socket buffer fills resulting in a partial send (i.e, for a given
> sqe submission only part of the write/send succeeded). io_uring was not
> handling that case.
> 
> I'll try to find some time to resurrect the iperf3 patch and try top of
> tree kernel.

With your zc_v5 branch (plus the init fix on using msg->sg_from_iter),
iperf3 with io_uring support (non-ZC case) no longer shows completions
with incomplete sends. So that is good improvement over the last time I
tried it.

However, adding in the ZC support and that problem resurfaces - a lot of
completions are for an incomplete size.

liburing comes from your tree, zc_v4 branch. Upstream does not have
support for notifications yet, so I can not move to it.

Changes to iperf3 are here:
   https://github.com/dsahern/iperf mods-3.10-io_uring
