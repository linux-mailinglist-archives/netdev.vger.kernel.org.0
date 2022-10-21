Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD662607BE3
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJUQOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJUQOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:14:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96E6241B3D;
        Fri, 21 Oct 2022 09:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE34561F12;
        Fri, 21 Oct 2022 16:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBF0C433D6;
        Fri, 21 Oct 2022 16:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368846;
        bh=6zODJgk3U5sDNQcyGcXymrrq6lpdYZddx+xy+2tEaag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SwcRFRtj6aRiWtxAjlJp221jrEQDCSnDnbEipFJAFrcFqpqeGdUIFoHPHvnM3kf/V
         MU8vpe4Vcw2s63dWITVv5/mggPTNK0odxcKANmm2++txMePKzwpP5Yv6laJqbh0AiD
         E3odfFiw3RvHs3MB4I39jwmaeNm0Is7zXl9vpFAvYuNm/iJ0cP6LnBsY6qinuJKhtv
         1DPeg3T75LfzrlwDCstKbonFC9qHEo3jPJtL5qhUJFrgpg998QPsVKueyZXQmFS6L9
         GYbFy7Ki0BTFahC2Lbyoine2KTmWGe1l3Rjta+3HnE2spBBkj3Tjfv7ftsvwMfmMQs
         n11pbfW4Xfzpw==
Date:   Fri, 21 Oct 2022 09:14:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
Message-ID: <20221021091404.58d244af@kernel.org>
In-Reply-To: <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
References: <cover.1666346426.git.asml.silence@gmail.com>
        <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
> We need an efficient way in io_uring to check whether a socket supports
> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
> socket flags fields.
> 
> Cc: <stable@vger.kernel.org> # 6.0
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/net.h | 1 +
>  net/ipv4/tcp.c      | 1 +
>  net/ipv4/udp.c      | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 711c3593c3b8..18d942bbdf6e 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -41,6 +41,7 @@ struct net;
>  #define SOCK_NOSPACE		2
>  #define SOCK_PASSCRED		3
>  #define SOCK_PASSSEC		4
> +#define SOCK_SUPPORT_ZC		5

Acked-by: Jakub Kicinski <kuba@kernel.org>

Any idea on when this will make it to Linus? If within a week we can
probably delay:
https://lore.kernel.org/all/dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com/
and avoid the conflict.
