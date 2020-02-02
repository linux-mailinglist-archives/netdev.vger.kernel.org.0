Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FD514FDA7
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgBBOtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 09:49:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41574 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgBBOtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 09:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580654979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2rJT8sYm23GHVPjmKznu9CgGpfeyjrkAT9zswgdaHPE=;
        b=fLPor8aHktQDfE6PkaKjif3lh2QemYD+1qkvqF2e1XiqPUB4ONtI6ufAfZ1VBysUgwFIRK
        YwwyluUuilVqVCyk5KD0xQIaTGB4mHLXVVYjSmm5wInQueKReUAsVeOyA5WY10LXrHU64B
        6Tf8/3ME6Svzl5C4Fr3PHgsDOntKlv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-n9E6uup_Miqrszb3FKqtug-1; Sun, 02 Feb 2020 09:49:38 -0500
X-MC-Unique: n9E6uup_Miqrszb3FKqtug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F89A107ACC7;
        Sun,  2 Feb 2020 14:49:37 +0000 (UTC)
Received: from ceranb (ovpn-205-193.brq.redhat.com [10.40.205.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22B7119C6A;
        Sun,  2 Feb 2020 14:49:29 +0000 (UTC)
Date:   Sun, 2 Feb 2020 15:49:24 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     poros@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
Message-ID: <20200202154924.06a0d208@ceranb>
In-Reply-To: <74acc406-00b2-0e1e-1390-d30d380815aa@gmail.com>
References: <20200129101308.74185-1-poros@redhat.com>
        <20200129121955.168731-1-poros@redhat.com>
        <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
        <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
        <414b2dc1-2421-e4c8-ea81-1177545fb327@gmail.com>
        <20200201112554.6d2b3a53@ceranb>
        <74acc406-00b2-0e1e-1390-d30d380815aa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 21:26:54 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 01.02.2020 11:25, Ivan Vecera wrote:
> > On Fri, 31 Jan 2020 21:50:48 +0100
> > Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >   
> >>> 0x7949
> >>> [   24.154174] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
> >>>
> >>> . supressed 3 same messages in T0+1,2,3s
> >>>
> >>> [   28.609822] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
> >>> [   28.629906] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
> >>> 0x7969
> >>> ^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
> >>> [   28.644590] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
> >>> 0x796d
> >>> ^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
> >>> [   28.658681] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1
> >>>     
> >>
> >> I see, thanks. Strange behavior of the PHY. Did you test also with other PHY's
> >> whether they behave the same?  
> > 
> > Yeah, it's strange... we could try different PHYs but anyway the double read was
> > removed for polling mode to detect momentary link drops but it make sense only
> > when phy->link is not 0. Thoughts?
> > 
> > Ivan
> >   
> I checked with the internal PHY of a Realtek NIC and it showed the same behavior.
> So it seems that Realtek PHY's behave like this in general. Therefore I'm fine
> with the patch. Just two things:
> - Add details about this quirky behavior to the commit description.
> - Resubmit annotated as net-next once net-next is open again. It's an improvement,
>   not a fix.

LGTM. Thanks for confirmation.

Ivan

