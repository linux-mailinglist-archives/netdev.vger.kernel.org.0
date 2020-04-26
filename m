Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF451B945E
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgDZV5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:57:39 -0400
Received: from correo.us.es ([193.147.175.20]:54762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgDZV5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 17:57:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22DD11022A2
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 23:57:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15DDDBAAA3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 23:57:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AFC6BAAA1; Sun, 26 Apr 2020 23:57:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C1D3BAAA3;
        Sun, 26 Apr 2020 23:57:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 23:57:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F36BE42EF4E0;
        Sun, 26 Apr 2020 23:57:34 +0200 (CEST)
Date:   Sun, 26 Apr 2020 23:57:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nat: never update the UDP checksum when
 it's 0
Message-ID: <20200426215734.GA7662@salvia>
References: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 02:42:19AM +0200, Guillaume Nault wrote:
> If the UDP header of a local VXLAN endpoint is NAT-ed, and the VXLAN
> device has disabled UDP checksums and enabled Tx checksum offloading,
> then the skb passed to udp_manip_pkt() has hdr->check == 0 (outer
> checksum disabled) and skb->ip_summed == CHECKSUM_PARTIAL (inner packet
> checksum offloaded).
> 
> Because of the ->ip_summed value, udp_manip_pkt() tries to update the
> outer checksum with the new address and port, leading to an invalid
> checksum sent on the wire, as the original null checksum obviously
> didn't take the old address and port into account.
> 
> So, we can't take ->ip_summed into account in udp_manip_pkt(), as it
> might not refer to the checksum we're acting on. Instead, we can base
> the decision to update the UDP checksum entirely on the value of
> hdr->check, because it's null if and only if checksum is disabled:
> 
>   * A fully computed checksum can't be 0, since a 0 checksum is
>     represented by the CSUM_MANGLED_0 value instead.
> 
>   * A partial checksum can't be 0, since the pseudo-header always adds
>     at least one non-zero value (the UDP protocol type 0x11) and adding
>     more values to the sum can't make it wrap to 0 as the carry is then
>     added to the wrapped number.
> 
>   * A disabled checksum uses the special value 0.
> 
> The problem seems to be there from day one, although it was probably
> not visible before UDP tunnels were implemented.

Applied, thanks.
