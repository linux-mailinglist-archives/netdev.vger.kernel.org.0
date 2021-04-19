Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3627364939
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhDSRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbhDSRwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:52:40 -0400
Received: from cx11.kasperd.dk (cx11.kasperd.dk [IPv6:2a01:4f8:c2c:2f65::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E34FC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:52:09 -0700 (PDT)
Received: from [127.0.0.1] (helo=gczfm.28.feb.2009.kasperd.net)
        by cx11.kasperd.dk with smtp (Exim 4.90_1)
        (envelope-from <kasperd@gczfm.28.feb.2009.kasperd.net>)
        id 1lYY46-0007dM-IL; Mon, 19 Apr 2021 19:52:06 +0200
Date:   Mon, 19 Apr 2021 19:52:05 +0200
From:   Kasper Dupont <kasperd@gczfm.28.feb.2009.kasperd.net>
To:     David Ahern <dsahern@gmail.com>
Cc:     Kasper Dupont <kasperd@gczfm.28.feb.2009.kasperd.net>,
        netdev@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Subject: Re: [PATCH 2/2] neighbour: allow NUD_NOARP entries to be forced GCed
Message-ID: <20210419175205.GA2375672@sniper.kasperd.net>
References: <20210317185320.1561608-1-cascardo@canonical.com>
 <20210317185320.1561608-2-cascardo@canonical.com>
 <20210419164429.GA2295190@sniper.kasperd.net>
 <0b502406-1a86-faec-ff46-c530145b90cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-7
Content-Disposition: inline
In-Reply-To: <0b502406-1a86-faec-ff46-c530145b90cf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/21 10.10, David Ahern wrote:
+AD4 On 4/19/21 9:44 AM, Kasper Dupont wrote:
+AD4 +AD4 On 17/03/21 15.53, Thadeu Lima de Souza Cascardo wrote:
+AD4 +AD4APg IFF+AF8-POINTOPOINT interfaces use NUD+AF8-NOARP entries for IPv6. It's possible to
+AD4 +AD4APg fill up the neighbour table with enough entries that it will overflow for
+AD4 +AD4APg valid connections after that.
+AD4 +AD4APg
+AD4 +AD4APg This behaviour is more prevalent after commit 58956317c8de (+ACI-neighbor:
+AD4 +AD4APg Improve garbage collection+ACI) is applied, as it prevents removal from
+AD4 +AD4APg entries that are not NUD+AF8-FAILED, unless they are more than 5s old.
+AD4 +AD4APg
+AD4 +AD4APg Fixes: 58956317c8de (neighbor: Improve garbage collection)
+AD4 +AD4APg Reported-by: Kasper Dupont +ADw-kasperd+AEA-gjkwv.06.feb.2021.kasperd.net+AD4
+AD4 +AD4APg Signed-off-by: Thadeu Lima de Souza Cascardo +ADw-cascardo+AEA-canonical.com+AD4
+AD4 +AD4APg ---
+AD4 +AD4APg  net/core/neighbour.c +AHw 1 +-
+AD4 +AD4APg  1 file changed, 1 insertion(+-)
+AD4 +AD4APg
+AD4 +AD4APg diff --git a/net/core/neighbour.c b/net/core/neighbour.c
+AD4 +AD4APg index bbc89c7ffdfd..be5ca411b149 100644
+AD4 +AD4APg --- a/net/core/neighbour.c
+AD4 +AD4APg +-+-+- b/net/core/neighbour.c
+AD4 +AD4APg +AEAAQA -256,6 +-256,7 +AEAAQA static int neigh+AF8-forced+AF8-gc(struct neigh+AF8-table +ACo-tbl)
+AD4 +AD4APg  
+AD4 +AD4APg  		write+AF8-lock(+ACY-n-+AD4-lock)+ADs
+AD4 +AD4APg  		if ((n-+AD4-nud+AF8-state +AD0APQ NUD+AF8-FAILED) +AHwAfA
+AD4 +AD4APg +-		    (n-+AD4-nud+AF8-state +AD0APQ NUD+AF8-NOARP) +AHwAfA
+AD4 +AD4APg  		    (tbl-+AD4-is+AF8-multicast +ACYAJg
+AD4 +AD4APg  		     tbl-+AD4-is+AF8-multicast(n-+AD4-primary+AF8-key)) +AHwAfA
+AD4 +AD4APg  		    time+AF8-after(tref, n-+AD4-updated))
+AD4 +AD4APg -- 
+AD4 +AD4APg 2.27.0
+AD4 +AD4APg
+AD4 +AD4 
+AD4 +AD4 Is there any update regarding this change?
+AD4 +AD4 
+AD4 +AD4 I noticed this regression when it was used in a DoS attack on one of
+AD4 +AD4 my servers which I had upgraded from Ubuntu 18.04 to 20.04.
+AD4 +AD4 
+AD4 +AD4 I have verified that Ubuntu 18.04 is not subject to this attack and
+AD4 +AD4 Ubuntu 20.04 is vulnerable. I have also verified that the one-line
+AD4 +AD4 change which Cascardo has provided fixes the vulnerability on Ubuntu
+AD4 +AD4 20.04.
+AD4 +AD4 
+AD4 
+AD4 your testing included both patches or just this one?

I applied only this one line change on top of the kernel in Ubuntu
20.04. The behavior I observed was that without the patch the kernel
was vulnerable and with that patch I was unable to reproduce the
problem.

The other longer patch is for a different issue which Cascardo
discovered while working on the one I had reported. I don't have an
environment set up where I can reproduce the issue addressed by that
larger patch.
