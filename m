Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D222C1BC9
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 03:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgKXC63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 21:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgKXC60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 21:58:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FB8206FA;
        Tue, 24 Nov 2020 02:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606186706;
        bh=D88RoA3yna6KC8S15hel0H49TPaGQF8wOE/3vR14YlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O84cUwRQUnVifMzdRwAN6xWDZGSfiYAk7/JTVJ2737Zh7EvW59vc1KaHIEYm2Kh/m
         A1nROVW6lv3LInIVpGLVasHlEwAdOBPOLsPo34GtGX23/NBe+UfpurnihrFBDndjCE
         9TycJNw9MecgUIuj5cfDw8/UbRPNvO0DSs1w9/Eg=
Date:   Mon, 23 Nov 2020 18:58:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Xie He <xie.he.0141@gmail.com>
Subject: Re: [net,v2] net/packet: fix packet receive on L3 devices without
 visible hard header
Message-ID: <20201123185825.7fc734a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSfcHW=+8=okyU9XuM7=pRnKjjqHdS0q_5ybP7xAUNXHQA@mail.gmail.com>
References: <20201121062817.3178900-1-eyal.birger@gmail.com>
        <CAHmME9rYRrWOs247vFJX-MAY+Zn3yUudOxVhqL13mWp8E+i0-A@mail.gmail.com>
        <CA+FuTSfcHW=+8=okyU9XuM7=pRnKjjqHdS0q_5ybP7xAUNXHQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 08:23:30 -0500 Willem de Bruijn wrote:
> On Sat, Nov 21, 2020 at 2:56 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On 11/21/20, Eyal Birger <eyal.birger@gmail.com> wrote:  
> > > In the patchset merged by commit b9fcf0a0d826
> > > ("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
> > > did not have header_ops were given one for the purpose of protocol parsing
> > > on af_packet transmit path.
> > >
> > > That change made af_packet receive path regard these devices as having a
> > > visible L3 header and therefore aligned incoming skb->data to point to the
> > > skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
> > > reset their mac_header prior to ingress and therefore their incoming
> > > packets became malformed.
> > >
> > > Ideally these devices would reset their mac headers, or af_packet would be
> > > able to rely on dev->hard_header_len being 0 for such cases, but it seems
> > > this is not the case.
> > >
> > > Fix by changing af_packet RX ll visibility criteria to include the
> > > existence of a '.create()' header operation, which is used when creating
> > > a device hard header - via dev_hard_header() - by upper layers, and does
> > > not exist in these L3 devices.
> > >
> > > As this predicate may be useful in other situations, add it as a common
> > > dev_has_header() helper in netdevice.h.
> > >
> > > Fixes: b9fcf0a0d826 ("Merge branch
> > > 'support-AF_PACKET-for-layer-3-devices'")
> > > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>  
> 
> > Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>  
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks!
