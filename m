Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363AD2D1E3E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgLGXUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLGXUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:20:46 -0500
Message-ID: <71aa9016c087e4c8d502d835ef2cddad42b56fc1.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607383205;
        bh=jyoTsKCqpLGWIMANYP5sAJ9u26qlqSc314V7xV0WlXc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ItNKpjB93vQF3Qo+YkbVih5a6KqatwJaI8Y0+9g7lV2MgFNWJq2pcDIehjBvqfSWb
         Vdu9fLqkV8tJ/Rw9bGlvlWDHvxqtW2CBe+0DKREZij50UkbVXKi3rfYNb07rRoEhw2
         ZSOyqAsKfWDN+ZdWh2tO4kNnOL8Gd0jgNalYnDYspkBS2A2fkwUQ5ueJpLgDU4XoKn
         WCbufBgEIFkMreRe/uZbEI5um1kLBl2XWi9QFUp7TTudhapGKaGXpDVhIpO9Pbxae4
         HbTpLnBBVzX3EX5EcdnyuDnIO+Dia9d+cMwTSslCynQ2m1gH7NqEkXpAf/AT5ZQVqQ
         BjwODzXCv+3iQ==
Subject: Re: [PATCH v5 bpf-next 02/14] xdp: initialize xdp_buff mb bit to 0
 in all XDP drivers
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Date:   Mon, 07 Dec 2020 15:20:03 -0800
In-Reply-To: <20201207213711.GA27205@ranger.igk.intel.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
         <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
         <CAKgT0UcjtERgpV9tke-HcmP7rWOns_-jmthnGiNPES+aqhScFg@mail.gmail.com>
         <20201207213711.GA27205@ranger.igk.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 22:37 +0100, Maciej Fijalkowski wrote:
> On Mon, Dec 07, 2020 at 01:15:00PM -0800, Alexander Duyck wrote:
> > On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org
> > > wrote:
> > > Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> > > This is a preliminary patch to enable xdp multi-buffer support.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > 
> > I'm really not a fan of this design. Having to update every driver
> > in
> > order to initialize a field that was fragmented is a pain. At a
> > minimum it seems like it might be time to consider introducing some
> > sort of initializer function for this so that you can update things
> > in
> > one central place the next time you have to add a new field instead
> > of
> > having to update every individual driver that supports XDP.
> > Otherwise
> > this isn't going to scale going forward.
> 
> Also, a good example of why this might be bothering for us is a fact
> that
> in the meantime the dpaa driver got XDP support and this patch hasn't
> been
> updated to include mb setting in that driver.
> 
something like
init_xdp_buff(hard_start, headroom, len, frame_sz, rxq);

would work for most of the drivers.

