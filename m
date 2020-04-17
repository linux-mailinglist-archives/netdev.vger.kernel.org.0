Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1789A1AD96D
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgDQJF6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 05:05:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729920AbgDQJF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:05:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-yFQkhh81Ng6OLkgOpD33SA-1; Fri, 17 Apr 2020 05:05:52 -0400
X-MC-Unique: yFQkhh81Ng6OLkgOpD33SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CD22801A01;
        Fri, 17 Apr 2020 09:05:51 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-35.ams2.redhat.com [10.36.112.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DFE5D9E2;
        Fri, 17 Apr 2020 09:05:49 +0000 (UTC)
Date:   Fri, 17 Apr 2020 11:05:47 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH net 1/2] net: macsec: update SCI upon MAC address change.
Message-ID: <20200417090547.GA3874480@bistromath.localdomain>
References: <20200310152225.2338-1-irusskikh@marvell.com>
 <20200310152225.2338-2-irusskikh@marvell.com>
MIME-Version: 1.0
In-Reply-To: <20200310152225.2338-2-irusskikh@marvell.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

2020-03-10, 18:22:24 +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> SCI should be updated, because it contains MAC in its first 6 octets.

Sorry for catching this so late. I don't think this change is correct.

Changing the SCI means wpa_supplicant (or whatever MKA you're using)
will disagree as to which SCI is in use. The peer probably doesn't
have an RXSC for the new SCI either, so the packets will be dropped
anyway.

Plus, if you're using "send_sci on", there's no real reason to change
the SCI, since it's also in the packet, and may or may not have any
relationship to the MAC address of the device.

I'm guessing the issue you're trying to solve is that in the "send_sci
off" case, macsec_encrypt() will use the SCI stored in the secy, but
the receiver will construct the SCI based on the source MAC
address. Can you confirm that? If that's the real problem, I have a
couple of ideas to solve it.


Thanks, and sorry again for the delay in looking at this,

-- 
Sabrina

