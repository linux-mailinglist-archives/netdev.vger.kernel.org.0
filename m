Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2E699503
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBPM70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBPM7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:59:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A406E6E84
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hha3rfLLUrFuDmJLhNdnJBwZ2C0jlNAA5kOLBlbdqPk=; b=HMUqMFKiP+x39Xe1Yt9KoMNbN9
        K1ifd4ogS5fZt/XgDVFDOwpCHzMKp8L1+gnjJEQhTqN/zGaCtXHs3MCT8Mcti5PuayT1JFw2NPa6w
        J8pe637gU6vD1QyRcZmHzviPG1KYkaPVDB+xyQXuaxYCm4fLvuKH4llWmj4tc6cJvSPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSdr8-005B95-IP; Thu, 16 Feb 2023 13:59:22 +0100
Date:   Thu, 16 Feb 2023 13:59:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Angelo Dureghello <angelo@kernel-space.org>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y+4oqivlA/VcTuO6@lunn.ch>
References: <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216125040.76ynskyrpvjz34op@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:50:40PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 12:20:24PM +0100, Angelo Dureghello wrote:
> > Still data passes all trough port6, even when i ping from
> > host PC to port4. I was expecting instead to see port5
> > statistics increasing.
> 
> > # configure the bridge
> > ip addr add 192.0.2.1/25 dev br0
> > ip addr add 192.0.2.129/25 dev br1
> 
> In this configuration you're supposed to put an IP address on the fec2
> interface (eth1), not on br1.
> 
> br1 will handle offloaded forwarding between port5 and the external
> ports (port3, port4). It doesn't need an IP address. In fact, if you
> give it an IP address, you will make the sent packets go through the br1
> interface, which does dev_queue_xmit() to the bridge ports (port3, port4,
> port5), ports which are DSA, so they do dev_queue_xmit() through their
> DSA master - eth0. So the system behaves as instructed.

Yep. As i said in another email, consider eth1 being connected to an
external managed switch. br1 is how you manage that switch, but that
is all you use br1 for. eth1 is where you do networking.

   Andrew
