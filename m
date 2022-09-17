Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645EA5BB7BC
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIQKZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQKZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:25:00 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0111902A;
        Sat, 17 Sep 2022 03:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=3omZ2Rg8+frEkZ+9fNsOjhga0U9rM3HhhW1pA3cCK0M=; b=iM+v5OTzosTONLQkyD3wDG42bP
        zunYhiJO4rxUxOwR7y9LzMT4e1phJbo6NoIxKJnP8TQXCm5s1sivW7JJJr1rw4pbNaDFNWkr8hl1b
        +fORtZHANGwDLTZlPEIKxl7wXdnkU4JsOY5Og49NCw4aSQikvhbgJwenb9VYlL2MJLdQmPVn6qEH8
        2eYD1VgcYR9RDGHSucZZBZ3yyPy1OMOnFjLP2+N5ALtuHl5JIpwbUzgXh8pkzx/0aC9TKfXLpfu7G
        sipjX9PJZFBWmtlEU4+eMFCqn+aOwoT0/awqCUaltEMGm0syxF99AD6utLJGebNveo1ipqiG4JG4+
        VEbZv8mQwm1zmiq/13H1ioDQ2i8eIIuCvQuUpnbgcn51GxFAYv/C+g2tncohC0xCSGnHeVOMAd40v
        EDWfLuLD2v1gnVpZcc/d2u38HJMFQO2Hc/VGXMCikMjrkzwRrF7+wHrGBwzF5dfGA6xNeaSrmKKtF
        NG7GGAXR5+dp2BG473uSzDRS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZV0K-000nuC-4A; Sat, 17 Sep 2022 10:24:56 +0000
Message-ID: <aa7d5f95-06d0-7e87-b41f-92fe07440b47@samba.org>
Date:   Sat, 17 Sep 2022 12:24:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1663363798.git.metze@samba.org>
 <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
 <5f4059ca-cec6-e44a-ac61-b9c034b1be77@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 5/5] io_uring/notif: let userspace know how effective the
 zero copy usage was
In-Reply-To: <5f4059ca-cec6-e44a-ac61-b9c034b1be77@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 17.09.22 um 11:22 schrieb Pavel Begunkov:
> On 9/16/22 22:36, Stefan Metzmacher wrote:
>> The 2nd cqe for IORING_OP_SEND_ZC has IORING_CQE_F_NOTIF set in cqe->flags
>> and it will now have the number of successful completed
>> io_uring_tx_zerocopy_callback() callbacks in the lower 31-bits
>> of cqe->res, the high bit (0x80000000) is set when
>> io_uring_tx_zerocopy_callback() was called with success=false.
> 
> It has a couple of problems, and because that "simplify uapi"
> patch is transitional it doesn't go well with what I'm queuing
> for 6.1, let's hold it for a while.

Once the current behavior gets released stable, we're no
longer able to change the meaning of cqe.res.

As cqe.res == 0 would mean zero copy wasn't used at all,
which would be the indication for userspace to avoid using SEND_ZC.

But if 6.0 would always return cqe.res = 0, there's no chance for
userspace to have a detection strategy.

And I don't think it will cause a lot of trouble for your 6.1 stuff (assuming
you mean your SENDMSG_ZC code), I was already having that on top
of my test branches, the current one is:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-6.0.0-rc5-metze.08

I plan to test SENDMSG_ZC with Samba next week.

metze
