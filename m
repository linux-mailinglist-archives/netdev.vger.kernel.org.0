Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945853648B7
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbhDSRFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDSRFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:05:54 -0400
X-Greylist: delayed 1247 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Apr 2021 10:05:23 PDT
Received: from cx11.kasperd.dk (cx11.kasperd.dk [IPv6:2a01:4f8:c2c:2f65::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56099C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:05:21 -0700 (PDT)
Received: from [127.0.0.1] (helo=gczfm.28.feb.2009.kasperd.net)
        by cx11.kasperd.dk with smtp (Exim 4.90_1)
        (envelope-from <kasperd@gczfm.28.feb.2009.kasperd.net>)
        id 1lYX0g-0007ZF-9z; Mon, 19 Apr 2021 18:44:30 +0200
Date:   Mon, 19 Apr 2021 18:44:29 +0200
From:   Kasper Dupont <kasperd@gczfm.28.feb.2009.kasperd.net>
To:     netdev@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Subject: Re: [PATCH 2/2] neighbour: allow NUD_NOARP entries to be forced GCed
Message-ID: <20210419164429.GA2295190@sniper.kasperd.net>
References: <20210317185320.1561608-1-cascardo@canonical.com>
 <20210317185320.1561608-2-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-7
Content-Disposition: inline
In-Reply-To: <20210317185320.1561608-2-cascardo@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/21 15.53, Thadeu Lima de Souza Cascardo wrote:
+AD4 IFF+AF8-POINTOPOINT interfaces use NUD+AF8-NOARP entries for IPv6. It's possible to
+AD4 fill up the neighbour table with enough entries that it will overflow for
+AD4 valid connections after that.
+AD4 
+AD4 This behaviour is more prevalent after commit 58956317c8de (+ACI-neighbor:
+AD4 Improve garbage collection+ACI) is applied, as it prevents removal from
+AD4 entries that are not NUD+AF8-FAILED, unless they are more than 5s old.
+AD4 
+AD4 Fixes: 58956317c8de (neighbor: Improve garbage collection)
+AD4 Reported-by: Kasper Dupont +ADw-kasperd+AEA-gjkwv.06.feb.2021.kasperd.net+AD4
+AD4 Signed-off-by: Thadeu Lima de Souza Cascardo +ADw-cascardo+AEA-canonical.com+AD4
+AD4 ---
+AD4  net/core/neighbour.c +AHw 1 +-
+AD4  1 file changed, 1 insertion(+-)
+AD4 
+AD4 diff --git a/net/core/neighbour.c b/net/core/neighbour.c
+AD4 index bbc89c7ffdfd..be5ca411b149 100644
+AD4 --- a/net/core/neighbour.c
+AD4 +-+-+- b/net/core/neighbour.c
+AD4 +AEAAQA -256,6 +-256,7 +AEAAQA static int neigh+AF8-forced+AF8-gc(struct neigh+AF8-table +ACo-tbl)
+AD4  
+AD4  		write+AF8-lock(+ACY-n-+AD4-lock)+ADs
+AD4  		if ((n-+AD4-nud+AF8-state +AD0APQ NUD+AF8-FAILED) +AHwAfA
+AD4 +-		    (n-+AD4-nud+AF8-state +AD0APQ NUD+AF8-NOARP) +AHwAfA
+AD4  		    (tbl-+AD4-is+AF8-multicast +ACYAJg
+AD4  		     tbl-+AD4-is+AF8-multicast(n-+AD4-primary+AF8-key)) +AHwAfA
+AD4  		    time+AF8-after(tref, n-+AD4-updated))
+AD4 -- 
+AD4 2.27.0
+AD4 

Is there any update regarding this change?

I noticed this regression when it was used in a DoS attack on one of
my servers which I had upgraded from Ubuntu 18.04 to 20.04.

I have verified that Ubuntu 18.04 is not subject to this attack and
Ubuntu 20.04 is vulnerable. I have also verified that the one-line
change which Cascardo has provided fixes the vulnerability on Ubuntu
20.04.

Kind regards
Kasper
