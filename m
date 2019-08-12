Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E538A4E1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfHLRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:50:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60062 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfHLRuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:50:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8F83D9C0076;
        Mon, 12 Aug 2019 17:50:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 12 Aug
 2019 10:50:10 -0700
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
Date:   Mon, 12 Aug 2019 18:50:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190709205550.3160-9-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24842.005
X-TM-AS-Result: No-0.993700-4.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTobF9xF7zzuNfZvT2zYoYOwC/ExpXrHizz5+tteD5RzhStN
        CiCLkU0TJftHdlOzjkcOIpipvOkpMUER5ddgnEDeEhGH3CRdKUVAFzNhpJiCT8z/SxKo9mJ4o0Y
        GraGLZ0Aa8UlmHcpg1t/4YGzn++U+zJBXac24eqA3X0+M8lqGUkcA1Ouvduu8pMQg6AVyOoPd1F
        DAxsDME+tWvgkKyZNdayY2loo5tnbQVcssd7FTbZzEHTUOuMX3j87/LK+2sqNYbPLopoBzQk8LY
        U9lieOwS+zJJVnn4eeJIG0pP8yLBr9ZdlL8eonaC24oEZ6SpSmcfuxsiY4QFB95wdV9ZjUt9uda
        0ooWZr9hagGHsao7Z/WLcUPINNeiIC4SJ9YmhCbcaWiMHkBBYh28oJMEFOA6JLiFWNslfOUeDBx
        IY75OUYfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7YDttQUGqHZU=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.993700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24842.005
X-MDID: 1565632215-XawhvHX2gFFa
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2019 21:55, Pablo Neira Ayuso wrote:
> This patch updates flow_block_cb_setup_simple() to use the flow block API.
> Several drivers are also adjusted to use it.
>
> This patch introduces the per-driver list of flow blocks to account for
> blocks that are already in use.
>
> Remove tc_block_offload alias.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: fix typo in list in nfp driver - Jakub Kicinski.
>     Move driver_list handling to the driver code, this list is transitional,
>     until drivers are updated to support multiple subsystems. No more
>     driver_list handling from core.

Pablo, can you explain (because this commit message doesn't) why these per-
 driver lists are needed, and what the information/state is that has module
 (rather than, say, netdevice) scope?

AFAICT none of these drivers otherwise interacts with TC at a module level
 (every block binding, callback etc. is associated with a single netdevice,
 usually through a cb_priv = netdev_priv(net_dev)), so this looks very out
 of place.

(More questions likely to follow as I work my way through trying to re-
 target my in-development driver to this new API.  Also if you have any
 kind of design document explaining how it all fits together, that'd be
 nice, because currently trying to figure it out is giving me a headache.)

-Ed
