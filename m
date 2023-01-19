Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFF673D4A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjASPS2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Jan 2023 10:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjASPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:18:26 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEDD8299E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:18:23 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-4mu8vjFnOuik8VxQwTywnA-1; Thu, 19 Jan 2023 10:18:19 -0500
X-MC-Unique: 4mu8vjFnOuik8VxQwTywnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60EF61C05AF8;
        Thu, 19 Jan 2023 15:18:19 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 086481121315;
        Thu, 19 Jan 2023 15:18:17 +0000 (UTC)
Date:   Thu, 19 Jan 2023 16:16:47 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Apoorv Kothari <apoorvko@amazon.com>
Cc:     fkrenzel@redhat.com, kuniyu@amazon.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] tls: implement rekey for TLS1.3
Message-ID: <Y8le3yLjpEGSm5gH@hog>
References: <Y8fMLtYmlIw2wfMM@hog>
 <20230119012546.36951-1-apoorvko@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20230119012546.36951-1-apoorvko@amazon.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-18, 17:25:46 -0800, Apoorv Kothari wrote:
> > 2023-01-17, 15:16:33 -0800, Kuniyuki Iwashima wrote:
> > > Hi,
> > > 
> > > Thanks for posting this series!
> > > We were working on the same feature.
> > > CC Apoorv from s2n team.
> > 
> > Ah, cool. Does the behavior in those patches match what your
> > implementation?
> 
> Thanks for submitting this, it looks great! We are working on testing this now.
> 
> > 
> > [...]
> > > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > > index fb1da1780f50..9be82aecd13e 100644
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -669,9 +669,12 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
> > > >  static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> > > >  				  unsigned int optlen, int tx)
> > > >  {
> > > > +	union tls_crypto_context tmp = {};
> > > > +	struct tls_crypto_info *old_crypto_info = NULL;
> > > >  	struct tls_crypto_info *crypto_info;
> > > >  	struct tls_crypto_info *alt_crypto_info;
> > > >  	struct tls_context *ctx = tls_get_ctx(sk);
> > > > +	bool update = false;
> > > >  	size_t optsize;
> > > >  	int rc = 0;
> > > >  	int conf;
> > > > @@ -687,9 +690,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> > > >  		alt_crypto_info = &ctx->crypto_send.info;
> > > >  	}
> > > >  
> > > > -	/* Currently we don't support set crypto info more than one time */
> > > > -	if (TLS_CRYPTO_INFO_READY(crypto_info))
> > > > -		return -EBUSY;
> > > > +	if (TLS_CRYPTO_INFO_READY(crypto_info)) {
> > > > +		/* Currently we only support setting crypto info more
> > > > +		 * than one time for TLS 1.3
> > > > +		 */
> > > > +		if (crypto_info->version != TLS_1_3_VERSION)
> > > > +			return -EBUSY;
> > > > +
> > > 
> > > Should we check this ?
> > > 
> > >                 if (!tx && !key_update_pending)
> > >                         return -EBUSY;
> > > 
> > > Otherwise we can set a new RX key even if the other end has not sent
> > > KeyUpdateRequest.
> > 
> > Maybe. My thinking was "let userspace shoot itself in the foot if it
> > wants".
> 
> I feel avoiding foot-guns is probably the correct thing to do. The RFC also has
> a requirement that re-key(process messages with new key) should only happen after
> a KeyUpdate is received so it would be nice if the kTLS implemention can help
> enforce this.
> 
> Based on the RFC https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3:
>    Additionally, both sides MUST enforce that a KeyUpdate
>    with the old key is received before accepting any messages encrypted
>    with the new key.  Failure to do so may allow message truncation
>    attacks.

Ok. I'll add that in v2, unless someone is strongly against it.

Thanks.

-- 
Sabrina

