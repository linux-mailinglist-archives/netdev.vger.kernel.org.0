Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFE531C708
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBPHy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhBPHyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 02:54:49 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6127C061574;
        Mon, 15 Feb 2021 23:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Coy/hZCMNVQEd82cbAZp1E9jRuaBjYHERBZbVUjwjEY=; b=qoVgrsfQzp/oEa48rOzTrwyUrW
        zLaJAwQ3VfbYazue2bz6hLFoBBslfeZpIAuu4rrZ+3gcdbTLsAVg78wDK6g9ii3L86SPtQ0JTtNiO
        FjMUcAVsneZya2q5iIkOhGKIS/izZU/kPvA5KuHmt2KDY0ie51PrLZP65aUWaZCE6+rQ=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lBvBB-0002ji-MX; Tue, 16 Feb 2021 08:53:53 +0100
To:     Kalle Valo <kvalo@codeaurora.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <43ed9abb9e8d7112f3cc168c2f8c489e253635ba.1613090339.git.skhan@linuxfoundation.org>
 <20210216070336.D138BC43463@smtp.codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 2/2] ath9k: fix ath_tx_process_buffer() potential null ptr
 dereference
Message-ID: <0fd9a538-e269-e10e-a7f9-02d4c5848420@nbd.name>
Date:   Tue, 16 Feb 2021 08:53:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210216070336.D138BC43463@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-02-16 08:03, Kalle Valo wrote:
> Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> ath_tx_process_buffer() references ieee80211_find_sta_by_ifaddr()
>> return pointer (sta) outside null check. Fix it by moving the code
>> block under the null check.
>> 
>> This problem was found while reviewing code to debug RCU warn from
>> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
>> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
>> RCU read lock.
>> 
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Patch applied to ath-next branch of ath.git, thanks.
> 
> a56c14bb21b2 ath9k: fix ath_tx_process_buffer() potential null ptr dereference
I just took another look at this patch, and it is completely bogus.
Not only does the stated reason not make any sense (sta is simply passed
to other functions, not dereferenced without checks), but this also
introduces a horrible memory leak by skipping buffer completion if sta
is NULL.
Please drop it, the code is fine as-is.

- Felix
