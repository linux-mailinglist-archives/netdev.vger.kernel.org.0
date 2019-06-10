Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F1E3B883
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391288AbfFJPvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:51:00 -0400
Received: from mail.us.es ([193.147.175.20]:43908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390356AbfFJPvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 11:51:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53562E7B80
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:50:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43023DA70A
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:50:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38803DA703; Mon, 10 Jun 2019 17:50:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E72FDA705;
        Mon, 10 Jun 2019 17:50:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 17:50:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 08DCF4265A32;
        Mon, 10 Jun 2019 17:50:55 +0200 (CEST)
Date:   Mon, 10 Jun 2019 17:50:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190610155055.a3o7yx25j3jlwzgs@salvia>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601150429.GA16560@ubuntu>
 <20190603123006.urztqvxyxcm7w3av@salvia>
 <20190602022706.GA24477@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602022706.GA24477@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 10:27:06PM -0400, Stephen Suryaputra wrote:
> On Mon, Jun 03, 2019 at 02:30:06PM +0200, Pablo Neira Ayuso wrote:
> > > I developed this patchset to suit my employer needs and there is no plan
> > > for a follow up patchset, however I think non-zero offset might be useful
> > > in the future for tunneled packets.
> > 
> > For tunneled traffic, we can store the network offset in the
> > nft_pktinfo object. Then, add a new extension to update this network
> > offset to point to the network offset inside the tunnel header, and
> > use this pkt->network_offset everywhere.
> 
> OK. I'm changing so that offset isn't being used as input. But, it's
> still being passed as reference for output. See further response
> below...
> 
> > I think this new IPv4 options extension should use priv->offset to
> > match fields inside the IPv4 option specifically, just like in the
> > IPv6 extensions and TCP options do. If you look on how the
> > priv->offset is used in the existing code, this offset points to
> > values that the specific option field conveys.
> 
> I believe that's what I have coded:
> 
> 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
> 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
> 		*dest = (err >= 0);
> 		return;
> 	} else if (err < 0) {
> 		goto err;
> 	}
> 	offset += priv->offset;
> 
> offset is returned as the offset where it matches the sought priv->type
> then priv->offset is added to get to the right field between the offset.

I see, thanks for explaining.

I got me confused when I read this:

+ * Note that *offset is used as input/output parameter, and if it is not zero,
+ * then it must be a valid offset to an inner IPv4 header. This can be used
+ * to explore inner IPv4 header, eg. ICMP error messages.

I thought this is how the new extension for nftables is working. Not
the function.

And then, this chunk:

+       if (!offset)
+               return -EINVAL;

This never happens, right? offset is always set.

+       if (!*offset)
+               *offset = skb_network_offset(skb);

So this is not needed either.

I would remove those, you can add more code to ipv4_find_option()
later on as you get more clients in the networking tree. I'd suggest,
better remove code that is not used yet, then introduce it once
needed.

> If this is satisfactory, I can submit v2 of the kernel patch.

Please do so, so you get more feedback (if needed) and we move on :-)

Thanks!
