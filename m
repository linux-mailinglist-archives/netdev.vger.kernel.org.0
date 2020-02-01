Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2459814F784
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgBAK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 05:26:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726297AbgBAK0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 05:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580552760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMeug/hwNISFpVV5kKy40pWGKDUATSyVV2ckUodASDs=;
        b=eddIYFm8RNO/k7biXszFZCj4oN4FMA3UB+/ZHvBqLw+hpxtB7EnowxvNRdjF6hiMw52TlE
        hmdV1cfoyNXhlaIM17ZgFoIVN7mBFPWB11MhyzXnVm2KzvkgWFGi2O63qKrryYYk7P+DhE
        riHQtRN7eSwC62R+5TVkV5R+miP/bCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-Kvrd3JvvNjGP10iHN9SJSg-1; Sat, 01 Feb 2020 05:25:59 -0500
X-MC-Unique: Kvrd3JvvNjGP10iHN9SJSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C61A8017CC;
        Sat,  1 Feb 2020 10:25:56 +0000 (UTC)
Received: from ceranb (ovpn-205-193.brq.redhat.com [10.40.205.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A9365DC18;
        Sat,  1 Feb 2020 10:25:54 +0000 (UTC)
Date:   Sat, 1 Feb 2020 11:25:54 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     poros@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
Message-ID: <20200201112554.6d2b3a53@ceranb>
In-Reply-To: <414b2dc1-2421-e4c8-ea81-1177545fb327@gmail.com>
References: <20200129101308.74185-1-poros@redhat.com>
        <20200129121955.168731-1-poros@redhat.com>
        <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
        <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
        <414b2dc1-2421-e4c8-ea81-1177545fb327@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 21:50:48 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> > 0x7949
> > [   24.154174] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
> > 
> > . supressed 3 same messages in T0+1,2,3s
> > 
> > [   28.609822] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> > [   28.629906] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
> > 0x7969
> > ^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
> > [   28.644590] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> > 0x796d
> > ^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
> > [   28.658681] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1
> >   
> 
> I see, thanks. Strange behavior of the PHY. Did you test also with other PHY's
> whether they behave the same?

Yeah, it's strange... we could try different PHYs but anyway the double read was
removed for polling mode to detect momentary link drops but it make sense only
when phy->link is not 0. Thoughts?

Ivan

