Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE3D568C68
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiGFPLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiGFPLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD3865D7;
        Wed,  6 Jul 2022 08:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C7061F97;
        Wed,  6 Jul 2022 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41565C3411C;
        Wed,  6 Jul 2022 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657120273;
        bh=0t4+0NuMhuKyhwYE96uObn+Fn7wgjaM3o2VchjRzaXs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gw8mON+xl+eQZmkqxAgwIhnso4d59umDNj6K4PGfjWW/FO0S61A6g52NhqKfboWoS
         JQUCnAHe5SqBTSHrQWH+CEkJ3yb07oIOsID5bF4XYGrdOZENOIAsUoFGf+QW9atfa9
         Y/vG3j6mnbZqtXUkIwWeLV7LHiDRJ7LNmXhVeUSbrrbR7Vqm/90nH1OgeBkDrwcNZE
         Mc6L1vNr7YJ0uNRcNaTrDhQsePdrHASKZQRhXulpN6a2b+8kWJq/KhlWIUDWwMRGzz
         VUOQaki583qvQmgazlzxIRrtsRyWB0XPo8+U6Xkv9beaG6CB1t5blrx2GfgUTa5EFO
         Fz7rZOVR3YfwA==
Message-ID: <f335b268-7334-372a-2993-03259e1b90a5@kernel.org>
Date:   Wed, 6 Jul 2022 09:11:11 -0600
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
 <ee35a179-e9a1-39c7-d054-40b10ca9a1f3@kernel.org>
 <e453322f-bf33-d7c5-26c2-06896fb1a691@gmail.com>
 <6943e4a8-0b19-c35a-d6e5-9329dc03cc3e@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <6943e4a8-0b19-c35a-d6e5-9329dc03cc3e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 4:09 PM, Pavel Begunkov wrote:
> On 7/5/22 15:03, Pavel Begunkov wrote:
>> On 7/5/22 03:28, David Ahern wrote:
>>> On 7/4/22 7:31 AM, Pavel Begunkov wrote:
>>>> If the series is going to be picked up for 5.20, how about we delay
>>>> this one for 5.21? I'll have time to think about it (maybe moving
>>>> the skb managed flag setup inside?), and will anyway need to send
>>>> some omitted patches then.
>>>>
>>>
>>> I think it reads better for io_uring and future extensions for io_uring
>>> to contain the optimized bvec iter handler and setting the managed flag.
>>> Too many disjointed assumptions the way the code is now. By pulling that
>>> into io_uring, core code does not make assumptions that "managed" means
>>> bvec and no page references - rather that is embedded in the code that
>>> cares.
>>
>> Core code would still need to know when to remove the skb's managed
>> flag, e.g. in case of mixing. Can be worked out but with assumptions,
>> which doesn't look better that it currently is. I'll post a 5.20
>> rebased version and will iron it out on the way then.

Sure. My comment was that MANAGED means something else (not core code)
manages the page references on the skb frags. That flag does not need to
be linked to a customized bvec.

> @@ -66,16 +68,13 @@ struct msghdr {
>      };
>      bool        msg_control_is_user : 1;
>      bool        msg_get_inq : 1;/* return INQ after receive */
> -    /*
> -     * The data pages are pinned and won't be released before ->msg_ubuf
> -     * is released. ->msg_iter should point to a bvec and ->msg_ubuf has
> -     * to be non-NULL.
> -     */
> -    bool        msg_managed_data : 1;
>      unsigned int    msg_flags;    /* flags on received message */
>      __kernel_size_t    msg_controllen;    /* ancillary data buffer
> length */
>      struct kiocb    *msg_iocb;    /* ptr to iocb for async requests */
>      struct ubuf_info *msg_ubuf;
> +
> +    int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
> +                struct iov_iter *from, size_t length);
>  };
>  

Putting in msghdr works too. I chose ubuf_info because it is directly
related to the ZC path, but that struct is getting tight on space.
