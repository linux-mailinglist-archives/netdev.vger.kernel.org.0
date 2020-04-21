Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFC1B2DA9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDURC7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 13:02:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54228 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDURC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:02:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-eSZZRY8RNHi-d2noMcwb7w-1; Tue, 21 Apr 2020 13:02:53 -0400
X-MC-Unique: eSZZRY8RNHi-d2noMcwb7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A14188017F6;
        Tue, 21 Apr 2020 17:02:52 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-35.ams2.redhat.com [10.36.112.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AD9660BEC;
        Tue, 21 Apr 2020 17:02:50 +0000 (UTC)
Date:   Tue, 21 Apr 2020 19:02:49 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Dmitry Bogdanov <dbogdanov@marvell.com>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [EXT] Re: [PATCH net 1/2] net: macsec: update SCI upon MAC
 address change.
Message-ID: <20200421170249.GA4054840@bistromath.localdomain>
References: <20200310152225.2338-1-irusskikh@marvell.com>
 <20200310152225.2338-2-irusskikh@marvell.com>
 <20200417090547.GA3874480@bistromath.localdomain>
 <BYAPR18MB235709AA95C28FAD4C6C39C2A4D40@BYAPR18MB2357.namprd18.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BYAPR18MB235709AA95C28FAD4C6C39C2A4D40@BYAPR18MB2357.namprd18.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-20, 09:51:23 +0000, Dmitry Bogdanov wrote:
> Hi Sabrina,
> 
> Thanks for the feedback.
> But this patch  does not directly related to send_sci parameter.
>
> Any manual change of macsec interface by ip tool will break
> wpa_supplicant work. It's OK, they are not intended to be used
> together.

Are you sure?  Before this patch, if you change the MAC address on a
macsec device with "send_sci on", packets can still be encrypted and
decrypted correctly.

> Having a different MAC address on each macsec interface allows to
> make a configuration with several *offloaded* SecY.

If you need to change the MAC address on the macsec device anyway, why
not do that at creation? Then the SCI is already picked:

  ip link add link ens3 macsec0 addr 92:23:25:22:bf:bc type macsec
  ip macsec show
      13: macsec0: [...]
          [...]
          TXSC: 92232522bfbc0001 on SA 0


> That is to make
> feasible to route the ingress decrypted traffic to the right
> (macsecX /ethX) interface by DST address. And to apply a different
> SecY for the egress packets by SRC address. That is the only option
> for the macsec offload at PHY level when upper layers know nothing
> about macsec.

I see. It would have been nice to have all this information in the
commit message.

I'm concerned about the software implementation, and that patch
is changing its behavior, AFAICT without fixing a bug in it.

-- 
Sabrina

