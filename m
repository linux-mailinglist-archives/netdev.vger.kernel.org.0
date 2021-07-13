Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1D23C7536
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhGMQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhGMQtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:49:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C06C0613DD;
        Tue, 13 Jul 2021 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=TTJ8LwE2YLzzQbluXnCR1S6PvuqP3zGFAOpQWY9Sbpw=;
        t=1626194784; x=1627404384; b=fZN9m2J6Al1zbS6LSebaDMukWsmtgZC49sSVeRBP2yl+x2o
        U+j9D6zvlWBIeQDfr5dVSXibkmgf9DLFc/hyliQLcF1fkSnh4eQ+axdhGJJCqLxsejW8oSU/SK7+6
        XTuu03cqjbE2J15HCMiihj9YYHUaetjszfIDzWNlI19a5kENSOCOGvT//PUS48KtDuFtAS1QHQqo3
        qftp8ncqDBwA6oPuHmy5PU2nkV5BZyL0TkYpcrLnqMcQf+zcXwH3lavBMMYeA3QFrx7TKNl3JbewI
        VfYbADIN7lz+IwlltON8m7I+4ZZAGXvU2TXrmctXatLW4IBHa0LIZFWxpYVhYulA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m3LY5-001pwk-5W; Tue, 13 Jul 2021 18:46:21 +0200
Message-ID: <6d8e441da60ce29d0007c5a6cf173e0a7a1353f6.camel@sipsolutions.net>
Subject: Re: [RFC 1/7] mac80211: add support for .ndo_fill_forward_path
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Date:   Tue, 13 Jul 2021 18:46:20 +0200
In-Reply-To: <20210713160745.59707-2-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
         <20210713160745.59707-2-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-13 at 18:07 +0200, Felix Fietkau wrote:
> +
> +static int ieee80211_netdev_fill_forward_path(struct net_device_path_ctx *ctx,
> +					      struct net_device_path *path)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_local *local;
> +	struct sta_info *sta;
> +	int ret = -ENOENT;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(ctx->dev);
> +	local = sdata->local;
> +
> +	if (!local->ops->net_fill_forward_path)
> +		return -EOPNOTSUPP;
> +
> +	rcu_read_lock();
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_AP_VLAN:
> +		sta = rcu_dereference(sdata->u.vlan.sta);
> +		if (sta)
> +			break;
> +		if (!sdata->wdev.use_4addr)
> +			goto out;

Am I confusing things, or is this condition inverted? If it's not 4-addr
then you won't have a u.vlan.sta, but you might still want to look up
the station more generally, no?

> +		fallthrough;
> +	case NL80211_IFTYPE_AP:
> +		if (is_multicast_ether_addr(ctx->daddr))
> +			goto out;
> +		sta = sta_info_get_bss(sdata, ctx->daddr);

Or maybe this shouldn't use _bss() here, but then you'd need to write a
sta_info_get() also in the VLAN case, no?

Which might actually be better or even correct, because if the station
is on the VLAN you probably *don't* want to find it here if the
interface that's being passed is the AP, no?

johannes

