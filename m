Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456E810AD03
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfK0J6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:58:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:44617 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfK0J6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:58:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 01:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,249,1571727600"; 
   d="scan'208";a="206849762"
Received: from slehanex-mobl1.ger.corp.intel.com ([10.252.10.177])
  by fmsmga007.fm.intel.com with ESMTP; 27 Nov 2019 01:58:34 -0800
Message-ID: <7a9332bf645fbb8c9fff634a3640c092fb9b4b79.camel@intel.com>
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL
 packet stalling
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "Kenneth R. Crudup" <kenny@panix.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Nov 2019 11:58:33 +0200
In-Reply-To: <20191127094123.18161-1-alobakin@dlink.ru>
References: <20191127094123.18161-1-alobakin@dlink.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-11-27 at 12:41 +0300, Alexander Lobakin wrote:
> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") has applied batched GRO_NORMAL packets processing
> to all napi_gro_receive() users, including mac80211-based drivers.
> 
> However, this change has led to a regression in iwlwifi driver [1][2] as
> it is required for NAPI users to call napi_complete_done() or
> napi_complete() and the end of every polling iteration, whilst iwlwifi
> doesn't use NAPI scheduling at all and just calls napi_gro_flush().
> In that particular case, packets which have not been already flushed
> from napi->rx_list stall in it until at least next Rx cycle.
> 
> Fix this by adding a manual flushing of the list to iwlwifi driver right
> before napi_gro_flush() call to mimic napi_complete() logics.
> 
> I prefer to open-code gro_normal_list() rather than exporting it for 2
> reasons:
> * to prevent from using it and napi_gro_flush() in any new drivers,
>   as it is the *really* bad way to use NAPI that should be avoided;
> * to keep gro_normal_list() static and don't lose any CC optimizations.
> 
> I also don't add the "Fixes:" tag as the mentioned commit was only a
> trigger that only exposed an improper usage of NAPI in this particular
> driver.
> 
> [1] https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=205647
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> ---

We don't usually use "net: wireless: intel:" in the commit message, we
would use "iwlwifi: pcie:", but I don't care much.

Otherwise:

Acked-by: Luca Coelho <luciano.coelho@intel.com>

Thanks a lot for the fix!

Dave, I'm assuming you'll take this directly into your tree, right?

--
Cheers,
Luca.

