Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBA8152575
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 04:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgBED6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 22:58:43 -0500
Received: from mo-csw-fb1114.securemx.jp ([210.130.202.173]:42402 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBED6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 22:58:43 -0500
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2020 22:58:42 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 0153eJCs022149; Wed, 5 Feb 2020 12:40:19 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 0153eECC026978; Wed, 5 Feb 2020 12:40:14 +0900
X-Iguazu-Qid: 2wHHCQuRTCRLI7F5IP
X-Iguazu-QSIG: v=2; s=0; t=1580874014; q=2wHHCQuRTCRLI7F5IP; m=XiSkK7PFyxkJUJlkBVO7Y24o0RpvByrLrCX98siQgmI=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 0153eDTN022533;
        Wed, 5 Feb 2020 12:40:13 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0153eDHY028744;
        Wed, 5 Feb 2020 12:40:13 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0153eDKA022581;
        Wed, 5 Feb 2020 12:40:13 +0900
Date:   Wed, 5 Feb 2020 12:40:12 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 4.4 stable 00/10] net: ip6 defrag: backport fixes
X-TSB-HOP: ON
Message-ID: <20200205034012.7wzvkyyugtjpod2h@toshiba.co.jp>
References: <20191008112309.9571-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Could you tell me about the status of this patch series?
I think you need to respond to Greg's comments.

Best regards,
  Nobuhiro

On Tue, Oct 08, 2019 at 01:22:59PM +0200, Georg Kohmann wrote:
> This is a backport of a 5.1rc patchset:
>   https://patchwork.ozlabs.org/cover/1029418/
> 
> Which was backported into 4.19:
>   https://patchwork.ozlabs.org/cover/1081619/
> 
> and into 4.14:
>   https://patchwork.ozlabs.org/cover/1089651/
> 
> and into 4.9:
>   https://www.spinics.net/lists/netdev/msg567087.html 
> 
> This patchset for 4.4 is based on Peter Oskolkov's patchsets above.
> 5 additional patches has been added to make it all apply, build
> and pass TAHI IPv6 Ready test with the IOL INTACT test tool.
> Without this patchset 2 extension header tests and 12 fragmentation
> tests fail to pass. The previous attempt to fix this seamed to end
> here: https://www.spinics.net/lists/netdev/msg567728.html
> It would be nice if someone with more netfilter
> and fragmentation knowledge than me could review it.
> 
> Florian Westphal (3):
>   netfilter: ipv6: nf_defrag: avoid/free clone operations
>   netfilter: ipv6: avoid nf_iterate recursion
>   netfilter: ipv6: nf_defrag: fix NULL deref panic
>   ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
> 
> Jason A. Donenfeld (1):
>   ipv6: do not increment mac header when it's unset
> 
> Subash Abhinov Kasiviswanathan (1):
>   netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460
> 
> Eric Dumazet (1):
>   ipv6: frags: fix a lockdep false positive
> 
> Peter Oskolkov (3):
>   net: IP defrag: encapsulate rbtree defrag code into callable functions
>   net: IP6 defrag: use rbtrees for IPv6 defrag
>   net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c
> 
>  include/net/inet_frag.h                     |  16 +-
>  include/net/ipv6.h                          |  29 ---
>  include/net/ipv6_frag.h                     | 111 +++++++++
>  include/net/netfilter/ipv6/nf_defrag_ipv6.h |   3 +-
>  net/ieee802154/6lowpan/reassembly.c         |   2 +-
>  net/ipv4/inet_fragment.c                    | 293 ++++++++++++++++++++++
>  net/ipv4/ip_fragment.c                      | 295 +++--------------------
>  net/ipv6/netfilter/nf_conntrack_reasm.c     | 344 ++++++++------------------
>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  23 +-
>  net/ipv6/reassembly.c                       | 360 +++++++---------------------
>  net/openvswitch/conntrack.c                 |  26 +-
>  11 files changed, 664 insertions(+), 838 deletions(-)
>  create mode 100644 include/net/ipv6_frag.h
> 
> -- 
> 2.10.2
> 
> 
