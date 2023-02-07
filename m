Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713E968E08B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjBGSul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjBGSuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:50:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B316103;
        Tue,  7 Feb 2023 10:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFD760F98;
        Tue,  7 Feb 2023 18:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34E9C433D2;
        Tue,  7 Feb 2023 18:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675795838;
        bh=ODzdhcFGiquws7826KpX34sqDv+PisvGBzStMDRRjKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cNUixezJ+SvECnDWIb0o+0ZGpKA6jtC9wof+gC/BVeo/ol+r7bfxNHk1F2Ix+MJDx
         hK4gApF9EDiramc3YenC0mrcepi+C9HK4XfsTQG3cOpUQfbrk5D1IlNIIDBWBR9O01
         wbatX0e0R0rhUfmR/i8dP7sKVxD+QpZlKBijrAWnifidRRQ6DOO0uCc70tAP9aSBVJ
         XmbqC4s7swInfITIY2nLOlx20L+yEevCnwcFQK2hNlIKOlNoR8iX8W0Xvxyks9/em1
         j8I1KovQ1AhmcdBi4eUrb0WmyKAUt0yP97XI/M7Wu6jWju4KG2r6aYaDnHgwqTdJKH
         PZAniAEs/+NxA==
Date:   Tue, 7 Feb 2023 10:50:36 -0800
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
Subject: Re: [PATCH] tls: Pass rec instead of aead_req into tls_encrypt_done
Message-ID: <20230207105036.76b30090@kernel.org>
In-Reply-To: <Y+IJXEYPuaQWjfR5@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
        <E1pOydn-007zi3-LG@formenos.hmeau.com>
        <20230206231521.712f53e5@kernel.org>
        <Y+IJXEYPuaQWjfR5@gondor.apana.org.au>
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

On Tue, 7 Feb 2023 16:18:36 +0800 Herbert Xu wrote:
> > >  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > > -				  tls_encrypt_done, sk);
> > > +				  tls_encrypt_done, aead_req);  
> > 
> > ... let's just pass rec instead of aead_req here, then?  
> 
> Good point.  Could we do this as a follow-up patch? Reposting
> the whole series would disturb a lot of people.  Of course if
> other major issues crop up I can fold this into the existing
> patch.

Whatever works best!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
