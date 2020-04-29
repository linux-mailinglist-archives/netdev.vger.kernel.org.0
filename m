Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EB71BE346
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgD2QCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726519AbgD2QCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:02:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C2FC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:02:31 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A373D22ED8;
        Wed, 29 Apr 2020 18:02:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588176148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IhOc7Vh9UZMXoUyyfI2to09PrlP5vlpV5XVtuQTz2zA=;
        b=T+wKQoFbTvtKwmpEwEyqZiU01/e8zptssKzSzWP0pEoXBd5WpzECJUDJRiZdcsDv2EWO4B
        SDSrYAv8XFyrLsSuXTR3isveRYgG46mFlMrztlrEGh6mf5lKS8NCQ6BIHYMAvWgafHat4J
        B1MNLaKOYSGLhikSmGU699+uLrwc30U=
From:   Michael Walle <michael@walle.cc>
To:     andrew@lunn.ch
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Date:   Wed, 29 Apr 2020 18:02:13 +0200
Message-Id: <20200429160213.21777-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: A373D22ED8
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,davemloft.net,suse.cz,vger.kernel.org,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> Add infrastructure in ethtool and phylib support for triggering a
> cable test and reporting the results. The Marvell 1G PHY driver is
> then extended to make use of this infrastructure.

I'm currently trying this with the AR8031 PHY. With this PHY, you
have to select the pair which you want to start the test on. So
you'd have to start the test four times in a row for a normal
gigabit cable. Right now, I don't see a way how to do that
efficiently if there is no interrupt. One could start another test
in the get_status() polling if the former was completed
successfully. But then you'd have to wait at least four polling
intervals to get the final result (given a cable with four pairs).

Any other ideas?

-michael
