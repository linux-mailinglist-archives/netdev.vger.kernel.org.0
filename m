Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD94F3199BC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 06:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhBLFhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 00:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLFhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 00:37:37 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26425C061574;
        Thu, 11 Feb 2021 21:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IrIGGg1sQ0NzZ4N2HMEewDUIFN5I3hxmFeu/bsPG8go=; b=hRoL8HWatqx5zH5SPjceLEYXES
        J6w7esRc5f2yF/oZQdxX7QVK+3IgqtYpRUWhd9DHQTk0mSMklrWLNXPoDtzY8RVE5U8bk6IYRLz5i
        hnx+WQteK7BK9N5aTYOHiMA1WqqIxt+6OZElBFNwTJ0mB+h8KqAq2sqQZpyHOPEPgmMI=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lAR8N-0003rX-I8; Fri, 12 Feb 2021 06:36:51 +0100
Subject: Re: [PATCH] mt76: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
To:     Shuah Khan <skhan@linuxfoundation.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1613090339.git.skhan@linuxfoundation.org>
 <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
 <20210212021312.40486-1-skhan@linuxfoundation.org>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <3949e1fc-c050-73e0-d02f-63a25c4821ef@nbd.name>
Date:   Fri, 12 Feb 2021 06:36:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212021312.40486-1-skhan@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-02-12 03:13, Shuah Khan wrote:
> ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
> the resulting pointer is only valid under RCU lock as well.
> 
> Fix mt76_check_sta() to hold RCU read lock before it calls
> ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed.
> 
> This problem was found while reviewing code to debug RCU warn from
> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
> RCU read lock.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
If I'm not mistaken, this patch is unnecessary. mt76_check_sta is only
called from mt76_rx_poll_complete, which itself is only called under RCU
lock.

- Felix
