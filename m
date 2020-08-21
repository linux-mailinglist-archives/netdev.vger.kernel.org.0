Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015E124DE96
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgHURfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgHURfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 13:35:03 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2FEC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:35:03 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id u3so2046344qkd.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=7kNLgMTk7CijN3HFgirOBJf0EnJqEBUXWPWLQcHga0I=;
        b=soJmFND1BK8RkS9fbWpRP6c+dDSmTQZRupXPJ1KxoGSAnFt2/5b3hlkoEGU3JoAyxX
         SzCq4x724QcDq3dLN5x9LNC+FzLTQXjbwMnDXu2QRxIAkrC1vhqDM5ga17TkNhkAU2Kt
         jxb67+j8cP/e7mX6fTKOtHFLjnFI5Qm60cv/FW90+LaVAPaqsjOaXgqK/oQ5ys9alHEG
         sbbqZX5ymaod6Jhv9ZuEQ3k65JjI3L5f9voqDfanOrZagNBsuDs32EBlgA420EFL7Wvg
         +4FibtDhg15VzhE2ZSIXSXv8K0nUaIomf7/4npdcBJPhy31+5StP/jt/w8uVNM8wURFR
         Aqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=7kNLgMTk7CijN3HFgirOBJf0EnJqEBUXWPWLQcHga0I=;
        b=QkwV85XvKNzkvCap8aIw/xJUv6g18CB0uZb0H3/wotUw7F4emfVFfolgkhHw/CFK0P
         WqR9t/iUm80E4qLwcbT6GNJWr6Wuat56wzAu9q4mHyk8x6KZnyhw9RXv4pZ3coEWl9ki
         zAMxNGKklTA4nr63KzRafS6HuXZG/X+gvIh5H/v0OY7AQiOYTt1x5BqrEHXRG8lPhYP6
         7pvbQrq7Lj2ilZ+FKUYQ+KP3qT2PFI98e+YB1EN+mpDB4C1Lh/Z5qSpye0BB9zZjThtQ
         eseP4BUaiN14qXGOBzOJ7cYLlm9NxU+wzQk7ldWewKUZ2vVhVb8Sm03mZU1FunnH3kxA
         JMfg==
X-Gm-Message-State: AOAM533ik3eEgZzW21Ftl+sOwiW0xuJRHN/M3kCZTbOsDJDNiyitUYef
        /nOPOhLw4C3fDChRRwaU/PI4alOQPA==
X-Google-Smtp-Source: ABdhPJxjL/72RITz4cd1Q3xVuf9JdmEWZH5/z3A7DhfXPGcWOo4V0klzhytZa+qRXh7yzUP8wnnXSg==
X-Received: by 2002:a37:a454:: with SMTP id n81mr4029336qke.11.1598031301207;
        Fri, 21 Aug 2020 10:35:01 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id t1sm2235738qkt.119.2020.08.21.10.35.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 10:35:00 -0700 (PDT)
Date:   Fri, 21 Aug 2020 13:34:54 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Subject: Security association lookup
Message-ID: <20200821173454.GA19722@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Reading the RFC 4301, it seems that security association search can hit
based on the SPI alone. But, __xfrm_state_lookup() matches the dest IP
address as well:

static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
					      const xfrm_address_t *daddr,
					      __be32 spi, u8 proto,
					      unsigned short family)
{
	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
	struct xfrm_state *x;

	hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
		if (x->props.family != family ||
		    x->id.spi       != spi ||
		    x->id.proto     != proto ||
		    !xfrm_addr_equal(&x->id.daddr, daddr, family))
			continue;

		if ((mark & x->mark.m) != x->mark.v)
			continue;
		if (!xfrm_state_hold_rcu(x))
			continue;
		return x;
	}

	return NULL;
}

The context is manual keying using iproute2 and the policy and state are
configured with dst <ip_addr>/<prefix>. Not having dealt with ipsec before,
at both code and system level, what am I missing? Do I understand the
standard and the iproute2 tool correctly?

If this, looking up based on spi alone and potentially prefixed addresses as
being stored in the selector, is allowed per specifications; is there a
work being done?

Above is a sample point on receive. Transmit seems to work the same too
except an xfrm_state is allocated and key mgr is notified. For manual
keying, is there a key mgr?

I read BSD code which seems to be doing the same with the following
comments:

/*
 * allocating a usable SA entry for a *INBOUND* packet.
 * Must call key_freesav() later.
 * OUT: positive:	pointer to a usable sav (i.e. MATURE or DYING state).
 *	NULL:		not found, or error occurred.
 *
 * According to RFC 2401 SA is uniquely identified by a triple SPI,
 * destination address, and security protocol. But according to RFC 4301,
 * SPI by itself suffices to specify an SA.
 *
 * Note that, however, we do need to keep source address in IPsec SA.
 * IKE specification and PF_KEY specification do assume that we
 * keep source address in IPsec SA.  We see a tricky situation here.
 */

Thank you,

Stephen.
