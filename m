Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB33588FFF
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbiHCQEN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Aug 2022 12:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiHCQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:04:12 -0400
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB3C13D59;
        Wed,  3 Aug 2022 09:04:10 -0700 (PDT)
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A685415AB;
        Wed,  3 Aug 2022 16:04:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 85DAF20027;
        Wed,  3 Aug 2022 16:04:07 +0000 (UTC)
Message-ID: <04c967669e4ed8845323f1487fff86949f07a81d.camel@perches.com>
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
From:   Joe Perches <joe@perches.com>
To:     Antonio Quartulli <antonio@openvpn.net>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Wed, 03 Aug 2022 09:04:06 -0700
In-Reply-To: <20220719014704.21346-2-antonio@openvpn.net>
References: <20220719014704.21346-1-antonio@openvpn.net>
         <20220719014704.21346-2-antonio@openvpn.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 85DAF20027
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: ztcdnm9ndary5wdcrw8jjpb7yjr6ewt6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+NxlwGsrjEsOp3yX577wwnzhNPxY7WYmg=
X-HE-Tag: 1659542647-117471
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 03:47 +0200, Antonio Quartulli wrote:
> OpenVPN is a userspace software existing since around 2005 that allows
> users to create secure tunnels.
> 
> So far OpenVPN has implemented all operations in userspace, which
> implies several back and forth between kernel and user land in order to
> process packets (encapsulate/decapsulate, encrypt/decrypt, rerouting..).
> 
> With ovpn-dco, we intend to move the fast path (data channel) entirely
> in kernel space and thus improve user measured throughput over the
> tunnel.

Logging trivia:

> diff --git a/drivers/net/ovpn-dco/crypto.c b/drivers/net/ovpn-dco/crypto.c
> new file mode 100644
> index 000000000000..fcc3a351ba9d
> --- /dev/null
> +++ b/drivers/net/ovpn-dco/crypto.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  OpenVPN data channel accelerator
> + *
> + *  Copyright (C) 2020-2022 OpenVPN, Inc.
> + *
> + *  Author:	James Yonan <james@openvpn.net>
> + *		Antonio Quartulli <antonio@openvpn.net>
> + */

Please add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include when a logging message is output

[]
> +void ovpn_crypto_key_slot_delete(struct ovpn_crypto_state *cs,
> +				 enum ovpn_key_slot slot)
> +{
> +	struct ovpn_crypto_key_slot *ks = NULL;
> +
> +	mutex_lock(&cs->mutex);
> +	switch (slot) {
> +	case OVPN_KEY_SLOT_PRIMARY:
> +		ks = rcu_replace_pointer(cs->primary, NULL,
> +					 lockdep_is_held(&cs->mutex));
> +		break;
> +	case OVPN_KEY_SLOT_SECONDARY:
> +		ks = rcu_replace_pointer(cs->secondary, NULL,
> +					 lockdep_is_held(&cs->mutex));
> +		break;
> +	default:
> +		pr_warn("Invalid slot to release: %u\n", slot);

So messages like these are prefixed appropriately.

> +		break;
> +	}
> +	mutex_unlock(&cs->mutex);
> +
> +	if (!ks) {
> +		pr_debug("Key slot already released: %u\n", slot);
> +		return;
> +	}
> +	pr_debug("deleting key slot %u, key_id=%u\n", slot, ks->key_id);
> +
> +	ovpn_crypto_key_slot_put(ks);
> +}

> diff --git a/drivers/net/ovpn-dco/crypto_aead.c b/drivers/net/ovpn-dco/crypto_aead.c
[]
> +/* Initialize a struct crypto_aead object */
> +struct crypto_aead *ovpn_aead_init(const char *title, const char *alg_name,
> +				   const unsigned char *key, unsigned int keylen)
> +{
> +	struct crypto_aead *aead;
> +	int ret;
> +
> +	aead = crypto_alloc_aead(alg_name, 0, 0);
> +	if (IS_ERR(aead)) {
> +		ret = PTR_ERR(aead);
> +		pr_err("%s crypto_alloc_aead failed, err=%d\n", title, ret);
> +		aead = NULL;
> +		goto error;
> +	}
> +
> +	ret = crypto_aead_setkey(aead, key, keylen);
> +	if (ret) {
> +		pr_err("%s crypto_aead_setkey size=%u failed, err=%d\n", title,
> +		       keylen, ret);
> +		goto error;
> +	}
> +
> +	ret = crypto_aead_setauthsize(aead, AUTH_TAG_SIZE);
> +	if (ret) {
> +		pr_err("%s crypto_aead_setauthsize failed, err=%d\n", title,
> +		       ret);

Could use another #define pr_fmt(fmt) etc...

