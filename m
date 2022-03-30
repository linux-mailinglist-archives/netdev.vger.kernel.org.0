Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3621B4ECEF8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351293AbiC3Vpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351319AbiC3Vpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:45:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECE2A9;
        Wed, 30 Mar 2022 14:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32EF961719;
        Wed, 30 Mar 2022 21:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1164CC340EE;
        Wed, 30 Mar 2022 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648676631;
        bh=YJx5Y/NaabpvP78tgzop3fS2pD2A+ms2vUy3yN75nWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=juzRQhTpRuowkzg/q/UA2D2CEuURAc5SNMW1iHgNZsCbcb/fAwN5s+K3zi8lwgP+H
         WSwVzH2DM2AvNtkZPxBjdPWj+ngVlAWGeN1FuleKmdgIpwbt40PsbjF1b2zmKGzJxB
         cGehC4kVqC3aLP2ZMoqdI3GUc2T/4q4UmlVhVEYe7NcddeFjjfFjIB/QmfQrh06neV
         IKLnRSio1UI0T6zRz7K6zNy6NP8YA6p1DZKrff9LJyCEXLibt9x9jJEhijVK0Gc3VU
         P7/LBe1S0JjV+nfb1eC7lrUFE8NVbvjULQ33mJ8xJhXkjJkyc1jMEovm6cD+4xfN1r
         wibH9xkz/02fQ==
Date:   Wed, 30 Mar 2022 14:43:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, <borisp@nvidia.com>,
        <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <vakul.garg@nxp.com>,
        <davejwatson@fb.com>, <linux-kernel@vger.kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix slab-out-of-bounds bug in
 decrypt_internal
Message-ID: <20220330144349.20fe978a@kernel.org>
In-Reply-To: <20220330132406.633c2da8@kernel.org>
References: <20220330085009.1011614-1-william.xuanziyang@huawei.com>
        <20220330093925.2d8ee6ca@kernel.org>
        <20220330132406.633c2da8@kernel.org>
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

On Wed, 30 Mar 2022 13:24:06 -0700 Jakub Kicinski wrote:
> Noob question for crypto folks, ivsize for AES CCM is reported 
> as 16, but the real nonce size is 13 for TLS (q == 2, n == 13
> using NIST's variable names AFAICT). Are we required to zero out 
> the rest of the buffer?

I guess we don't, set_msg_len() explicitly clears the tail of 
the buffer. Hopefully KASAN won't be upset about the uninit
read in format_input(), since it memcpy()s the entire 16B of iv.

> In particular I think I've seen transient crypto failures with
> SM4 CCM in the past and zeroing the tail of the iv buffer seems
> to make the tests pass reliably.
