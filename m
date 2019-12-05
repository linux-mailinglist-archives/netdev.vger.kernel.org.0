Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C44114228
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 15:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfLEOBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 09:01:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbfLEOBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 09:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RJnmT508lemxn3jZi6MdCEa9v5+oeCEtGVN1/x2fxsI=; b=NfTY6uPLTCxtmjnAZ0CO2N5bAN
        +1UtQ6loR8ACDhPxgRwvAHil2EQmV9qO/dcNEdIwWgivM94RWLlV6B+o3gKJYTEfPeEql0cS4j8rp
        lT0sTUgHgepN5Eov3d+zdpuBcrSwPp/YIiM5IRS2m9CIUeM/yywtXKEIKtgEQzl5Js9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icrhE-0007fM-6f; Thu, 05 Dec 2019 15:01:32 +0100
Date:   Thu, 5 Dec 2019 15:01:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
Message-ID: <20191205140132.GD28269@lunn.ch>
References: <20191205100235.14195-1-alobakin@dlink.ru>
 <20191205125827.GA28269@lunn.ch>
 <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,
> 
> > What i'm missing here is an explanation why the flow dissector is
> > called here if the protocol is already set? It suggests there is a
> > case when the protocol is not correctly set, and we do need to look
> > into the frame?
> 
> If we have a device with multiple Tx queues, but XPS is not configured
> or system is running on uniprocessor system, then networking core code
> selects Tx queue depending on the flow to utilize as much Tx queues as
> possible but without breaking frames order.
> This selection happens in net/core/dev.c:skb_tx_hash() as:
> 
> reciprocal_scale(skb_get_hash(skb), qcount)
> 
> where 'qcount' is the total number of Tx queues on the network device.
> 
> If skb has not been hashed prior to this line, then skb_get_hash() will
> call flow dissector to generate a new hash. That's why flow dissection
> can occur on Tx path.


Hi Alexander

So it looks like you are now skipping this hash. Which in your
testing, give better results, because the protocol is already set
correctly. But are there cases when the protocol is not set correctly?
We really do need to look into the frame?

How about when an outer header has just been removed? The frame was
received on a GRE tunnel, the GRE header has just been removed, and
now the frame is on its way out? Is the protocol still GRE, and we
should look into the frame to determine if it is IPv4, ARP etc?

Your patch looks to improve things for the cases you have tested, but
i'm wondering if there are other use cases where we really do need to
look into the frame? In which case, your fix is doing the wrong thing.
Should we be extending the tagger to handle the TX case as well as the
RX case?

   Andrew
