Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6794068D030
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjBGHKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjBGHKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF1C2278C;
        Mon,  6 Feb 2023 23:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B2E2B81716;
        Tue,  7 Feb 2023 07:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B308DC433D2;
        Tue,  7 Feb 2023 07:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675753810;
        bh=VvGaQpQYZUpL7fyQlSvZZVk0dw3V7tJuaCipJTwS3LE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gwRQHVQZXXLf3IlUyHa5iYI2x/L5N7XSGYnPzfWftS3FkFJWWNX+ramJHM7xTarTG
         Fgushcdoy4VOIDfg3VQQQP4kIog7p+H4L7o0VDY8qDErtqPifDnrXgsxt9OHBq+iXU
         I+S2kZQxITWQawon3Y5XMWeCmkTMQeQWFEXIZexhWPhnRKWfoHqhVjcICME87wNn1j
         rrdd7K9B89hrQH7I8AO1EhiPCvkz74PSxs/U3JkKrspeJ77s1MWJpgxWFSz/e7yKmh
         MgLTIhjDdW1JgOzu4Id1uQgkVRk19vXWNxZfbgtxWkE9czEOtwQfd002OTaqr5Gg4s
         N82CH80wcAS1g==
Date:   Mon, 6 Feb 2023 23:10:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 0/17] crypto: api - Change completion callback argument
 to void star
Message-ID: <20230206231008.64c822c1@kernel.org>
In-Reply-To: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Feb 2023 18:21:06 +0800 Herbert Xu wrote:
> The crypto completion function currently takes a pointer to a
> struct crypto_async_request object.  However, in reality the API
> does not allow the use of any part of the object apart from the
> data field.  For example, ahash/shash will create a fake object
> on the stack to pass along a different data field.

"different data field" == copy the value to a different structure?
A bit hard to parse TBH.

> This leads to potential bugs where the user may try to dereference
> or otherwise use the crypto_async_request object.
> 
> This series changes the completion function to take a void *
> argument instead of crypto_async_request.
> 
> This series touches code in a number of different subsystems.
> Most of them are trivial except for tls which was actually buggy
> as it did exactly what was described above.

Buggy means bug could be hit in real light or buggy == did not use 
the API right?

> I'd like to pull all the changes through the crypto tree.  But
> feel free to object if you'd like the relevant patches to go
> through your trees instead and I'll split this up.
