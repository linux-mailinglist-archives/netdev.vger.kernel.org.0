Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1AF672E23
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 02:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjASBb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 20:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjASB3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 20:29:51 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC5D6920C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 17:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674091566; x=1705627566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EIqjMgYwaWL/GNM1+H2CtZlNL/Pb9zfWBhJ5lhVYzQw=;
  b=Xv9Q9Z0D0hqERdtVODoxsDQBFKIcDfTe1WYb2SMbsjIeWhinGJiKU2vf
   JZcOYP3wDSDCSnryZcnvsNPcpq8Dq/JSV2/ziLhWQC7KpZt2Ar35inpM6
   7OuhS4dOSnXkSRWFRJ9JQVSKQyNAhigztB6aSmw6caGYw11QrJm3+Ym3a
   o=;
X-IronPort-AV: E=Sophos;i="5.97,226,1669075200"; 
   d="scan'208";a="172586357"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:26:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id 676CB8221E;
        Thu, 19 Jan 2023 01:26:05 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 19 Jan 2023 01:26:04 +0000
Received: from bcd0741e4041.ant.amazon.com (10.43.160.120) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Thu, 19 Jan 2023 01:26:04 +0000
From:   Apoorv Kothari <apoorvko@amazon.com>
To:     <sd@queasysnail.net>
CC:     <apoorvko@amazon.com>, <fkrenzel@redhat.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] tls: implement rekey for TLS1.3
Date:   Wed, 18 Jan 2023 17:25:46 -0800
Message-ID: <20230119012546.36951-1-apoorvko@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <Y8fMLtYmlIw2wfMM@hog>
References: <Y8fMLtYmlIw2wfMM@hog>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D44UWC004.ant.amazon.com (10.43.162.209) To
 EX19D030UWB003.ant.amazon.com (10.13.139.142)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 2023-01-17, 15:16:33 -0800, Kuniyuki Iwashima wrote:
> > Hi,
> > 
> > Thanks for posting this series!
> > We were working on the same feature.
> > CC Apoorv from s2n team.
> 
> Ah, cool. Does the behavior in those patches match what your
> implementation?

Thanks for submitting this, it looks great! We are working on testing this now.

> 
> [...]
> > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > index fb1da1780f50..9be82aecd13e 100644
> > > --- a/net/tls/tls_main.c
> > > +++ b/net/tls/tls_main.c
> > > @@ -669,9 +669,12 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
> > >  static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> > >  				  unsigned int optlen, int tx)
> > >  {
> > > +	union tls_crypto_context tmp = {};
> > > +	struct tls_crypto_info *old_crypto_info = NULL;
> > >  	struct tls_crypto_info *crypto_info;
> > >  	struct tls_crypto_info *alt_crypto_info;
> > >  	struct tls_context *ctx = tls_get_ctx(sk);
> > > +	bool update = false;
> > >  	size_t optsize;
> > >  	int rc = 0;
> > >  	int conf;
> > > @@ -687,9 +690,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> > >  		alt_crypto_info = &ctx->crypto_send.info;
> > >  	}
> > >  
> > > -	/* Currently we don't support set crypto info more than one time */
> > > -	if (TLS_CRYPTO_INFO_READY(crypto_info))
> > > -		return -EBUSY;
> > > +	if (TLS_CRYPTO_INFO_READY(crypto_info)) {
> > > +		/* Currently we only support setting crypto info more
> > > +		 * than one time for TLS 1.3
> > > +		 */
> > > +		if (crypto_info->version != TLS_1_3_VERSION)
> > > +			return -EBUSY;
> > > +
> > 
> > Should we check this ?
> > 
> >                 if (!tx && !key_update_pending)
> >                         return -EBUSY;
> > 
> > Otherwise we can set a new RX key even if the other end has not sent
> > KeyUpdateRequest.
> 
> Maybe. My thinking was "let userspace shoot itself in the foot if it
> wants".

I feel avoiding foot-guns is probably the correct thing to do. The RFC also has
a requirement that re-key(process messages with new key) should only happen after
a KeyUpdate is received so it would be nice if the kTLS implemention can help
enforce this.

Based on the RFC https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3:
   Additionally, both sides MUST enforce that a KeyUpdate
   with the old key is received before accepting any messages encrypted
   with the new key.  Failure to do so may allow message truncation
   attacks.

> 
> > > +		update = true;
> > > +		old_crypto_info = crypto_info;
> > > +		crypto_info = &tmp.info;
> > > +	}
> > >  
> > >  	rc = copy_from_sockptr(crypto_info, optval, sizeof(*crypto_info));
> > >  	if (rc) {
> > > @@ -704,6 +715,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> > >  		goto err_crypto_info;
> > >  	}
> > >  
> > > +	if (update) {
> > > +		/* Ensure that TLS version and ciphers are not modified */
> > > +		if (crypto_info->version != old_crypto_info->version ||
> > > +		    crypto_info->cipher_type != old_crypto_info->cipher_type) {
> > > +			rc = -EINVAL;
> > > +			goto err_crypto_info;
> > > +		}
> > > +	}
> > > +
> > >  	/* Ensure that TLS version and ciphers are same in both directions */
> > >  	if (TLS_CRYPTO_INFO_READY(alt_crypto_info)) {
> > 
> > We can change this to else-if.
> 
> Ok.
> 
> > >  		if (alt_crypto_info->version != crypto_info->version ||
> [...]
> > > @@ -2517,9 +2525,28 @@ int tls_set_sw_offload(struct sock *sk, int tx)
> > >  	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
> > >  	struct crypto_tfm *tfm;
> > >  	char *iv, *rec_seq, *key, *salt, *cipher_name;
> > > -	size_t keysize;
> > > +	size_t keysize, crypto_info_size;
> > >  	int rc = 0;
> > >  
> > > +	if (new_crypto_info) {
> > > +		/* non-NULL new_crypto_info means rekey */
> > > +		src_crypto_info = new_crypto_info;
> > > +		if (tx) {
> > > +			sw_ctx_tx = ctx->priv_ctx_tx;
> > > +			crypto_info = &ctx->crypto_send.info;
> > > +			cctx = &ctx->tx;
> > > +			aead = &sw_ctx_tx->aead_send;
> > > +			sw_ctx_tx = NULL;
> > 
> > sw_ctx_tx is already initialised.
> 
> No, it was NULL at the beginning of the function, but then I used it
> to set aead on the previous line, so I need to clear it again. I could
> use a temp variable instead if you think it's better.
> 
> > > +		} else {
> > > +			sw_ctx_rx = ctx->priv_ctx_rx;
> > > +			crypto_info = &ctx->crypto_recv.info;
> > > +			cctx = &ctx->rx;
> > > +			aead = &sw_ctx_rx->aead_recv;
> > > +			sw_ctx_rx = NULL;
> > 
> > Same here.
> > 
> > 
> > > +		}
> > > +		goto skip_init;
> > > +	}
> > > +
> > >  	if (tx) {
> > >  		if (!ctx->priv_ctx_tx) {
> > >  			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);
> 
> Thanks for the comments.
> 
> -- 
> Sabrina

--
Apoorv
