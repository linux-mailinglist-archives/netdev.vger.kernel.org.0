Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF9631EA91
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhBRNq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhBRLot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 06:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613648572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NuB6K6ftTVLCTTssWLUX9Z2fSvpvf2tL3ch0L8h5V78=;
        b=TPluUPKbvE1KG1wWSBKulLg09HM8UBo5ytzulhF1Q8f45p1MTjaYKCq8L4pRtUw147o4uA
        ZfCH3fM1RNmDxrIww5ZGsAdOzLyEajnamy5n/ev+uR3M/xohQovQ8rKEaAhxc7c6RYik1H
        l+kAXmM/fq9VHDCd+zmPRlOVgnYROZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-cv9zQN2gMuKOSpIiLnXgMw-1; Thu, 18 Feb 2021 06:42:49 -0500
X-MC-Unique: cv9zQN2gMuKOSpIiLnXgMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25F4C1020C20;
        Thu, 18 Feb 2021 11:42:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 796B918F0A;
        Thu, 18 Feb 2021 11:42:42 +0000 (UTC)
Date:   Thu, 18 Feb 2021 12:42:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH] Revert "dpaa_eth: add XDP_REDIRECT support"
Message-ID: <20210218124240.5198dcda@carbon>
In-Reply-To: <20210217151758.5622-1-s.hauer@pengutronix.de>
References: <20210217151758.5622-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 16:17:58 +0100
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> This reverts commit a1e031ffb422bb89df9ad9c018420d0deff7f2e3.
> 
> This commit introduces a:
> 
> 	np = container_of(&portal, struct dpaa_napi_portal, p);
> 
> Using container_of() on the address of a pointer doesn't make sense as
> the pointer is not embedded into the desired struct.
> 
> KASAN complains about it like this:
> 
> [   17.703277] ==================================================================
> [   17.710517] BUG: KASAN: stack-out-of-bounds in rx_default_dqrr+0x994/0x14a0
> [   17.717504] Read of size 4 at addr ffff0009336495fc by task systemd/1
> [   17.723955]
> [   17.725447] CPU: 0 PID: 1 Comm: systemd Not tainted 5.11.0-rc6-20210204-2-00033-gfd6caa9c7514-dirty #63
> [   17.734857] Hardware name: TQ TQMLS1046A SoM
> [   17.742176] Call trace:
> [   17.744621]  dump_backtrace+0x0/0x2e8
> [   17.748298]  show_stack+0x1c/0x68
> [   17.751622]  dump_stack+0xe8/0x14c
> [   17.755033]  print_address_description.constprop.0+0x68/0x304
> [   17.760794]  kasan_report+0x1d4/0x238
> [   17.764466]  __asan_load4+0x88/0xc0
> [   17.767962]  rx_default_dqrr+0x994/0x14a0
> [   17.771980]  qman_p_poll_dqrr+0x254/0x278
> [   17.776000]  dpaa_eth_poll+0x4c/0xe0
> ...
> 
> It's not clear to me how a the struct dpaa_napi_portal * should be
> derived from the struct qman_portal *, so revert the patch for now.

Can we please get a response from NXP people?

Are you saying XDP_REDIRECT feature is completely broken on dpaa driver?

(I only have access to dpaa2 hardware)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

