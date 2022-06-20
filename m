Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93385523B4
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244859AbiFTSSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbiFTSSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:18:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05FCB1CD;
        Mon, 20 Jun 2022 11:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89AAD61580;
        Mon, 20 Jun 2022 18:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66895C3411B;
        Mon, 20 Jun 2022 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655749089;
        bh=o+C4cmLFoA0LK7Q7+9oFSFNy5vmRRXTVgXcNn6IXtGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ul45ysaYXH+P1XaCN88bQskxJxmB5cop3Wj900airtJXbLGDxNn+nB62oQEMz5e0O
         CZ2ZetjkBqi8zT2WOLlukSxjhp8lrOyPyELUYbSuAMSCEagqPMKFQgUspLp/wKaD/6
         saohBCBmnV+SOuml/IA2VsTIyRml+SHEG1zZnvnwLoswZsni1acDohBiN+ctTssAWZ
         x0+BVw4haIW4GBo41Wqo5pq28wncHYKTs353yUAFs6yAQoVRZl1bAE4XCL1nLL5xS2
         osQaNxI4GHdXNcb+dEnweOr7nAgmyO4m+vaJWUNNFOokZH27lTLli6m6F2PEF1WvrM
         2STEMAbxzjcnA==
Date:   Mon, 20 Jun 2022 11:18:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix tls_sk_proto_close executed repeatedly
Message-ID: <20220620111808.5b313aa6@kernel.org>
In-Reply-To: <165571681216.11783.14529855078803748152.git-patchwork-notify@kernel.org>
References: <20220620043508.3455616-1-william.xuanziyang@huawei.com>
        <165571681216.11783.14529855078803748152.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 09:20:12 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> On Mon, 20 Jun 2022 12:35:08 +0800 you wrote:
> > After setting the sock ktls, update ctx->sk_proto to sock->sk_prot by
> > tls_update(), so now ctx->sk_proto->close is tls_sk_proto_close(). When
> > close the sock, tls_sk_proto_close() is called for sock->sk_prot->close
> > is tls_sk_proto_close(). But ctx->sk_proto->close() will be executed later
> > in tls_sk_proto_close(). Thus tls_sk_proto_close() executed repeatedly
> > occurred. That will trigger the following bug.
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [net] net/tls: fix tls_sk_proto_close executed repeatedly
>     https://git.kernel.org/netdev/net/c/69135c572d1f

No, this is not the right fix. The AF_UNIX restructuring has moved the
ULP check too late. I'll send a revert and the correct fix.
