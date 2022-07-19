Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F03057A2D2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiGSPTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiGSPTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:19:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216438A2;
        Tue, 19 Jul 2022 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qmRk5WvbkJ0mS7/eJHIYpBPMUr8cLvqn7V4Y2tEmYU8=; b=hhNryw6fPgRprJfjy1mpa+07fS
        M91c4kk0LMoHqY86sg1Nno5u3U4hoeIT+UXwABYoS7ZoSMlizpMa2GOCZKJDycB2ZUIt31Ph3Pcpg
        WFc0WSrVIHN9CoT4qwi6MtmMKEsEYu5nF8XwTbXtyZm/taJziczAbvcUzlT85M6e4APg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDp07-00ApsE-CC; Tue, 19 Jul 2022 17:19:07 +0200
Date:   Tue, 19 Jul 2022 17:19:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <YtbLa54+0A4SyR9+@lunn.ch>
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719014704.21346-2-antonio@openvpn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
> +		break;
> +	}
> +	mutex_unlock(&cs->mutex);
> +
> +	if (!ks) {
> +		pr_debug("Key slot already released: %u\n", slot);
> +		return;
> +	}
> +	pr_debug("deleting key slot %u, key_id=%u\n", slot, ks->key_id);

As a general comment throughout the code, pr_ functions are not
liked. Since this is a network device, it would be better to use
netdev_debug(), netdev_warn() etc, so indicating which device is
outputting warnings or debug info.

	   Andrew
