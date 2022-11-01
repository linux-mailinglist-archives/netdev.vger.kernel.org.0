Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4677614328
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKACWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:22:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951F3E5B;
        Mon, 31 Oct 2022 19:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38201B81A5E;
        Tue,  1 Nov 2022 02:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E8C433D6;
        Tue,  1 Nov 2022 02:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667269364;
        bh=iXkoHfA0E8gCJGSPDExlBGC7wVy3zs193btcw19ae4U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Y197eQae4Xg+JY+k03j4a6S2vWBlxlVeMS9acol6LDSZfj4mgDQ0IbouzcJLrX8xl
         AqrGRQ4wIE+bI88OVIwIZk7ryFHpA54+anJxRTGMieVd+19ce5H4OkzOCgxSdEw/CN
         TFz/JTzrxNADHz3GKfpn7chlIvwWR/jHXLR+oSgtO95qNndwZrxBmZ74d0Yr8aNbDb
         DasDtmY0kyC55aPxTR0f9oIXyyklu/MnGiqD2oKgPeXYwaiG8cCcEE8HRb51O83Tl3
         Zqv6e59M12bc4KjNIkvRGEGPdnVtGqCyg3jEe/idty/sBHn7JorxSVQFybCaocMwHD
         Cr98iZrknPXNw==
Message-ID: <c0b6c5f1-9b4f-2d3d-69fd-533daa023e09@kernel.org>
Date:   Mon, 31 Oct 2022 20:22:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v3 00/36] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20221027204347.529913-1-dima@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thinking about how to move the TCP-AO intent forward: clearly a 36-patch
set is a bit much. The first 6 patches are prep work, and we know there
is a use case for those.

We could handle patches 3 and 4 as a stand alone set first.

Once merged, deal with the crypto API and users until those maintainers
are good. That would be patches 1, 2, 5 and 6.

Once those are merged it drops down to just networking patches with
selftests. Those can be split into AO (19) and selftests (11) making it
4 total sets of manageable size.

The AO patches can be reviewed until convergence on a good starting point.

Sound reasonable?
