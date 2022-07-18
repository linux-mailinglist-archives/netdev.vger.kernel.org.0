Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35CB578D2E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiGRWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiGRWAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:00:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A3F30567;
        Mon, 18 Jul 2022 15:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Smy+K5SsBoKu7R2Ez6Wknyaqr3gfX9BPVA5fVt2P8T0=; b=leyACy2j4DACa1kT6Gpoba8VOm
        VOcEfZL3PkIZgiPs8NmLAJaBh8ucD+6kAoUEzxAXkRiJhdoKUCC9eS2BxTrWrSU3Gqy8FGHCl0+Yf
        cnoOA2e2G7FTo7OqIQ+Jms+460wxBba1ZdXNg9IsZJuJ86ignpBqHcbMW+ipI2+RdNLMHKQbtEnSK
        yUQZmHoK4wSnrk6TsdqloQ/tkKm0+6MDqgVLg+haVl7nQ2yUnqoiirjvDUaegs24clTHejTLG5Nhf
        GrMHfUZ3Mq47NEGdmLxe/Y3iaYND/IDLOH/w41NkO0UbGqm0/y7Hu229QF2xyeGt/BSMoNktdIPyL
        BQ+qyY7Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYmh-001q88-OL; Mon, 18 Jul 2022 22:00:11 +0000
Date:   Mon, 18 Jul 2022 15:00:11 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Dave Airlie <airlied@gmail.com>
Cc:     torvalds@linux-foundation.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.sf.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-block@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines.
Message-ID: <YtXX604B2X8vdH9b@bombadil.infradead.org>
References: <20220718072144.2699487-1-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718072144.2699487-1-airlied@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 05:21:44PM +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> A recent snafu where Intel ignored upstream feedback on a firmware
> change, led to a late rc6 fix being required. In order to avoid this
> in the future we should document some expectations around
> linux-firmware.
> 
> I was originally going to write this for drm, but it seems quite generic
> advice.
> 
> I'm cc'ing this quite widely to reach subsystems which use fw a lot.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Document well deserved to be written, thanks for making this happen.
Modulo all the silly spelling / bike-shedding issues folks might find,
in case you care to re-spin for a v2:

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

Now let's think about the impact of two corner cases which *do*
happen and so this poses security implications on enablement:

1) Devices which end up with a security issue which a vendor considers
   obsolete, and the only way to fix something is firmware. We're
   security-out-of-luck. For this I've previously sucessfully have put
   effort into organizations to open source the firmware. We were
   successful more than once:

     * https://github.com/qca/open-ath9k-htc-firmware
     * https://github.com/qca/ath6kl-firmware

   When these efforts fall short we have a slew of reverse engineering
   efforts which fortunately also have been sucessfull.

2) Vendor goes belly up

Both implicate the need to help persuade early on a strategy for open
source firmware, and I don't want to hear anyone tell me it is not
possible.

When that fails we can either reverse engineer and worst case, I am not
sure if we have a process for annotations or should. Perhaps a kconfig
symbol which drivers with buggy firmware can depend on, and only if you
enable that kconfig symbol would these drivers be available to be
enabled?

Are we aware of such device drivers? They must exist...

  Luis
