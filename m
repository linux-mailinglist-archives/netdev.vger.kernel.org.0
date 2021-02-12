Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF563199F3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 07:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhBLGcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 01:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLGcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 01:32:13 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED186C061574;
        Thu, 11 Feb 2021 22:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9OSaT3qldBbKb3aoRr6FNKO3CwIGmFcwDgn3c6dYxF4=; b=fML8A+g4vRFqphMSXB8XdVSB+v
        GgcQ0AJq1jwSjS+bHZPDrhsp9E3XR+TXtphYu1dZg79DWyXa9NzuyFGBp/NxHLHqkiWPKElLVSkdH
        JCGL9Xhx4t1sHK7doW+tUqYm9/wy/tl5yNuYhCSnRu4gU92JD8eCPR1UG6aVYq5BMDlA=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lARzF-0006iz-Jt; Fri, 12 Feb 2021 07:31:29 +0100
Subject: Re: [PATCH 1/2] ath9k: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
To:     Shuah Khan <skhan@linuxfoundation.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1613090339.git.skhan@linuxfoundation.org>
 <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <00f1fb03-defc-89be-7629-69a0d9f659d4@nbd.name>
Date:   Fri, 12 Feb 2021 07:31:28 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
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
> Fix ath_tx_process_buffer() to hold RCU read lock before it calls
> ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed.
> 
> This problem was found while reviewing code to debug RCU warn from
> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
> RCU read lock.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
This patch seems unnecessary as well. All callers of
ath_tx_process_buffer seem to hold the RCU read lock already.

- Felix
