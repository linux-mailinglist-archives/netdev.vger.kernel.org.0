Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE83199FE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 07:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBLGf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 01:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhBLGf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 01:35:26 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD27C061574;
        Thu, 11 Feb 2021 22:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6ftLOQ6D9eeTaacotfOfS301dOzMiHhQ41LAP3tXfqA=; b=hEEDrY7d68IWQPnW1CpgiF/8bp
        GIyvCqmdVEwykZ+/ZPOzyoRU5eqSljhl2vJAyoZGMQ9QC17f4X2fmyL++x5izTQNrGB/eJXp6NKMV
        gKe2t7WdIOqCT0eXoU/KN297KijKdT/QLIEEa/TkAj7ggZmbuHGXa8/JV4cg1epK9zbU=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lAS2P-0006tK-4n; Fri, 12 Feb 2021 07:34:45 +0100
Subject: Re: [PATCH] rtw88: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
To:     Shuah Khan <skhan@linuxfoundation.org>, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1613090339.git.skhan@linuxfoundation.org>
 <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
 <20210212021312.40486-2-skhan@linuxfoundation.org>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <0dfbd38e-6158-4162-cbd6-90e89728860e@nbd.name>
Date:   Fri, 12 Feb 2021 07:34:44 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212021312.40486-2-skhan@linuxfoundation.org>
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
> Fix rtw_rx_addr_match_iter() to hold RCU read lock before it calls
> ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed.
> 
> This problem was found while reviewing code to debug RCU warn from
> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
> RCU read lock.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
This one also seems unnecessary. rtw_rx_addr_match_iter is called by
ieee80211_iterate_active_interfaces_atomic, which acquires the RCU read
lock before calling it.

- Felix
