Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28F148CE79
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiALWkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiALWkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:40:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB17C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 380D6B82141
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FB4C36AE9;
        Wed, 12 Jan 2022 22:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642027215;
        bh=1f4MsXZd08k9bCOWms6HH5H636eeHN4QOEH9lngrvGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MArTeWzqHXRSl2yd9eJkF7fq3JxQi8h7XXRMnCnijm1DNBP7SmsgiMNHSNqJrhKV8
         tR5agBGszS91BlBy3KpT4xU0a1nJ16pxFYAmU3UrA/cPDXMUf03msRjvL5vqJ8utdL
         Qbp9dOadaDFshHvyOcOLmZSlocAZqIK9slWCoh8c38L/zqE1dnzSnvwc7wEo1sZ3/x
         jbp+Cj6sqHW0Jt9KfXn+9hDaxAhg1PvakN1dHwstidErnBozrOoliKyANenbtSjPAY
         IxDVt0NEENlcUY8HKYvVrZPFZUeILuEOR5EWB6cFjIaVGQ7UGhSX3cHGBNkKytei3p
         vrHhMt7qIYBeg==
Date:   Wed, 12 Jan 2022 14:40:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 7/8] net/funeth: add kTLS TX control part
Message-ID: <20220112144013.1060a854@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112143532.3aab21e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220110015636.245666-8-dmichail@fungible.com>
        <20220112143532.3aab21e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 14:35:32 -0800 Jakub Kicinski wrote:
> > +	if (crypto_info->version == TLS_1_2_VERSION)
> > +		req.version = FUN_KTLS_TLSV2;
> > +	else if (crypto_info->version == TLS_1_3_VERSION)
> > +		req.version = FUN_KTLS_TLSV3;  

I don't think offload of TLS 1.3 is supported by the kernel.

> > +	else
> > +		return -EOPNOTSUPP;
> > +
> > +	switch (crypto_info->cipher_type) {
> > +	case TLS_CIPHER_AES_GCM_128: {
> > +		struct tls12_crypto_info_aes_gcm_128 *c = (void *)crypto_info;
> > +
> > +		req.cipher = FUN_KTLS_CIPHER_AES_GCM_128;
> > +		memcpy(req.key, c->key, sizeof(c->key));
> > +		memcpy(req.iv, c->iv, sizeof(c->iv));
> > +		memcpy(req.salt, c->salt, sizeof(c->salt));
> > +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > +		break;
> > +	}

Neither are all the algos below. Please remove dead code.

> > +	case TLS_CIPHER_AES_GCM_256: {
> > +		struct tls12_crypto_info_aes_gcm_256 *c = (void *)crypto_info;
> > +
> > +		req.cipher = FUN_KTLS_CIPHER_AES_GCM_256;
> > +		memcpy(req.key, c->key, sizeof(c->key));
> > +		memcpy(req.iv, c->iv, sizeof(c->iv));
> > +		memcpy(req.salt, c->salt, sizeof(c->salt));
> > +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > +		break;
> > +	}
> > +
> > +	case TLS_CIPHER_CHACHA20_POLY1305: {
> > +		struct tls12_crypto_info_chacha20_poly1305 *c;
> > +
> > +		c = (void *)crypto_info;
> > +		req.cipher = FUN_KTLS_CIPHER_CHACHA20_POLY1305;
> > +		memcpy(req.key, c->key, sizeof(c->key));
> > +		memcpy(req.iv, c->iv, sizeof(c->iv));
> > +		memcpy(req.salt, c->salt, sizeof(c->salt));
> > +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> > +		break;
> > +	}
