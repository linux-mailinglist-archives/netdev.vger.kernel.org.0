Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1C345EE2A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348776AbhKZMmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377352AbhKZMkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:40:46 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A1FC08EACC;
        Fri, 26 Nov 2021 04:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ao8V3KlCNyYSY9b0MKdPeXS/6+FHUFXUrD4WUegNBfE=;
        t=1637928166; x=1639137766; b=gK0E+bW+mdo1lJsmKHhqdPOkpQ8kX2uqF6heG4/xJIwIMYL
        KZW4SNn2hvwyNFHSizG5DR/ycjhcqI0gaTXEN1GKqlA0/UYYlsIvoAJsr9JVm1dntvuacewTlYHu2
        uLg+hVqjiMTo+pVCrfJ+Rs3UndNcn9QwaJpmtPBYQgd6/HoRER502S/t8yPLbnaSjj7PvlIvXemOS
        jqth6pgp1nydQEFCtUwBXUmhR9DnYkugVoGmIZBUEvv6Dtdv+i9NuokQPY8DdJR4PzTe1tfttVMbE
        JOZyExPjCFauQK4d4+ZW6w6Evn9I3zaVEj0gnDJlsq5oHKJRMDE2iueISa7fOTCQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mqZwB-003AUn-ER;
        Fri, 26 Nov 2021 13:02:43 +0100
Message-ID: <f0835218828401ed49ceacbb62c62284f4d99d95.camel@sipsolutions.net>
Subject: Re: [PATCH -next] mac80211: fix suspicious RCU usage in
 ieee80211_set_tx_power()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bixuan Cui <cuibixuan@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     davem@davemloft.ne, kuba@kernel.org
Date:   Fri, 26 Nov 2021 13:02:42 +0100
In-Reply-To: <1636956548-114723-1-git-send-email-cuibixuan@linux.alibaba.com>
References: <1636956548-114723-1-git-send-email-cuibixuan@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-15 at 14:09 +0800, Bixuan Cui wrote:
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 1ab8483..14fbe9e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2702,14 +2702,19 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
>  	enum nl80211_tx_power_setting txp_type = type;
>  	bool update_txp_type = false;
>  	bool has_monitor = false;
> +	int ret = 0;
> +
> +	rtnl_lock();
> 

This will almost certainly result in lockups, or at least lockdep
complaints, that's just wrong.

johannes
