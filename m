Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64D1B65AD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgDWUnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 16:43:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57096 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDWUnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 16:43:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jRigX-0006ED-7I; Thu, 23 Apr 2020 22:43:01 +0200
Date:   Thu, 23 Apr 2020 22:43:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nat: never update the UDP checksum when
 it's 0
Message-ID: <20200423204301.GF32392@breakpoint.cc>
References: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:
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

Indeed, we're mangling udphdr->csum unconditionally for CSUM_PARTIAL
case. Doesn't make sense to me, so:

Reviewed-by: Florian Westphal <fw@strlen.de>
