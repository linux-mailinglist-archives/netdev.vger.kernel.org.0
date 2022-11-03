Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1794618B47
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiKCWU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKCWUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:20:25 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273711F2FC;
        Thu,  3 Nov 2022 15:20:25 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.90])
        by gnuweeb.org (Postfix) with ESMTPSA id 8E39F81441;
        Thu,  3 Nov 2022 22:20:22 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667514024;
        bh=guFlnGZSzsqe7pCsLfZ/Zp0Wt9wQjtFRe/CRhEP/ylg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QuA8blGpLWJy7/PT/sRjAXBkByvnfaF5Y2Yg0IAsnXc1k/CSvKLP6UUlCiLOqYpu8
         MMtY5B7yeQnuSZm9ndlMNGujVoqkHkpYu8LXT05+0mPp/wKafhC3dOXtwYt2g5O7Be
         zXXlkSQtEwaP5+rFpmVF9Pqg5vueYe5ZilrujKGhZvcmy6BfcWsdnkrs5ycSEy4Hp5
         njW+R1qMWV9LZSqnzxgPwWNfwaDeZwdZ0NGXYzfMLozmHQHxkY9mIYjRtgU/oVCp01
         IF8hcUjNlgicup8UOx9UPTdMwiksaj77M9x6hkUCWMTBE2Fo0Z1Td050tN9uUNmyQc
         W/Az2dFM8d06w==
Message-ID: <e62ff9f6-0eea-be82-c357-1081a4d0d100@gnuweeb.org>
Date:   Fri, 4 Nov 2022 05:20:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v1 3/3] liburing: add test programs for napi busy poll
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221103204017.670757-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 3:40 AM, Stefan Roesch wrote:
> +void *encodeUserData(char type, int fd)
> +{
> +	return (void *)((uint32_t)fd | ((__u64)type << 56));
> +}
This breaks 32-bit build.

   i686-linux-gnu-gcc -Werror -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -I../src/include/ -include ../config-host.h -g -O3 -Wall -Wextra -Werror -Wno-unused-parameter -Wno-sign-compare -Wstringop-overflow=0 -Warray-bounds=0 -DLIBURING_BUILD_TEST -o napi-busy-poll-client.t napi-busy-poll-client.c helpers.o -L../src/ -luring -lpthread
   napi-busy-poll-client.c: In function ‘encodeUserData’:
   napi-busy-poll-client.c:119:16: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
     119 |         return (void *)((uint32_t)fd | ((__u64)type << 56));
         |                ^
   cc1: all warnings being treated as errors

-- 
Ammar Faizi

