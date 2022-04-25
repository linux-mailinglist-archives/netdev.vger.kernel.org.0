Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C508650E3C3
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbiDYO56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiDYO5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530FA36319
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 07:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B0261679
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F8EC385A7;
        Mon, 25 Apr 2022 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650898480;
        bh=HThhQr0vP/gSexyWx1y40fb3wNytnBaco4OsDRVr1m0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DUl3z7lwjUNwvl3adPL233PFQ9PY2/n6fPJ7p8Iaru6i6DEsJ8krLXF3tlGfUXZV2
         rkNkJe8YEDWa+sDCsVcC3ONl68L+lbdHttEpiHSWmbvazTV0hRIPlPUSSJ79QRJZsX
         iM3yVJYVaaPge/RlqFKPkV8NhUjrYRH3AZel/MCcRmGbIZNk2T6uslRAdWwQCVUtHE
         Cau+sh6Ng+9WtD8LkP4aKArCWMK9rsZcPc4itSOmrtZF+syQ21ch5YMqzllbF53BtU
         aCDonr1P+gDSbPL2Tbe4ye5WEDJ6/IMYafnPTSh0baHNMAo3b8Xi0XWj9KJtwQOZzN
         VFd6VJfkOHqnw==
Date:   Mon, 25 Apr 2022 07:54:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru
Subject: Re: [PATCH net-next 08/10] tls: rx: use async as an in-out argument
Message-ID: <20220425075438.6c87e969@kernel.org>
In-Reply-To: <01081d46-249f-a081-f130-e0a09180d4d3@nvidia.com>
References: <20220411191917.1240155-1-kuba@kernel.org>
        <20220411191917.1240155-9-kuba@kernel.org>
        <01081d46-249f-a081-f130-e0a09180d4d3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 10:19:45 +0300 Gal Pressman wrote:
> On 11/04/2022 22:19, Jakub Kicinski wrote:
> > Propagating EINPROGRESS thru multiple layers of functions is
> > error prone. Use darg->async as an in/out argument, like we
> > use darg->zc today. On input it tells the code if async is
> > allowed, on output if it took place.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> I know this is not much to go on, but this patch broke our tls workflows
> when device offload is enabled.
> I'm still looking into it, but maybe you have an idea what might have
> went wrong?

Oof right, sorry. When packet is already decrypted by HW we'll skip 
the decrypt completely and leave async to whatever it was at input.

Something like this?

--->8---------

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ddbe05ec5489..80094528eadb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1562,6 +1562,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 
 	if (tlm->decrypted) {
 		darg->zc = false;
+		darg->async = false;
 		return 0;
 	}
 
@@ -1572,6 +1573,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		if (err > 0) {
 			tlm->decrypted = 1;
 			darg->zc = false;
+			darg->async = false;
 			goto decrypt_done;
 		}
 	}
