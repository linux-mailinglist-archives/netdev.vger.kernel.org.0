Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A174868E095
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjBGSvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjBGSvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:51:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE049EF0;
        Tue,  7 Feb 2023 10:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D586112F;
        Tue,  7 Feb 2023 18:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34265C433EF;
        Tue,  7 Feb 2023 18:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675795908;
        bh=x0UI86gVTuknlQ58qUTLvMciZe/bE/6g39HHqZCq0K4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VSh5Dyt8xASnmvTydKvQbaFJHbGaq1MUZN0wdEy/DvbasC+0O95aScLPc+6Klyn2c
         bLz6vOPlX5UKFjct+uvCLhp86OXHdlZPpVqQgrYkimu51YAHILD+cqxvyKhr7J3d/M
         nqbxe3p3Vx5295uCHBjBlp47OW4aIwk5nY1ESc6NK2c2qx5wqo2p+2hcR65kVen1IY
         FW6fJjvx/vzksgupXienOhJuoQYRPZRHbu4D0ZygWDJCwF1+YiHzvHIQiWy9Jq58LT
         1CQcYb1TQMbYcUV0R2BSzEDllmjW91t3LetazrD8asBbWcH6yyxYmJFefmk99GRAGy
         qJc4dDpNt9BjQ==
Date:   Tue, 7 Feb 2023 10:51:46 -0800
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
Message-ID: <20230207105146.267fc5e8@kernel.org>
In-Reply-To: <Y+IF6L4cb2Ijy0fN@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
        <20230206231008.64c822c1@kernel.org>
        <Y+IF6L4cb2Ijy0fN@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Feb 2023 16:03:52 +0800 Herbert Xu wrote:
> > Buggy means bug could be hit in real light or buggy == did not use 
> > the API right?  
> 
> Yes this bug is real.  If you hit a driver/algorithm that returns
> a different request object (of which there are many in the API) then
> you will be dereferencing random pointers.

Any aes-gcm or chacha-poly implementations which would do that come 
to mind? I'm asking 'cause we probably want to do stable if we know
of a combination which would be broken, or the chances of one existing
are high.

Otherwise no objections for the patches to go via the crypto tree,
there should be no conflicts AFAIK. Feel free to add my ack on the
networking changes if needed.
