Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6368B4EBC4A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244082AbiC3IGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244083AbiC3IGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:06:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A8B2E9CD;
        Wed, 30 Mar 2022 01:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99850617A1;
        Wed, 30 Mar 2022 08:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84A9C340EC;
        Wed, 30 Mar 2022 08:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648627496;
        bh=X2bDIF4+6RoRWE7V+BZ5WnKiuW2qsYmv5VPe4pG97RQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=k0NUmR6IxSwYvdeVTcqOAAdN72x6x3B6QaDWf+PPeUPMoeX2bMpcRkNgse6S9FO37
         6cgcTO8hQZ40B95bdMI5np+rp37HjpVDhpDXc8OJtiszoid04W9zR/qD5/jLt8Bo7s
         vdxxlUs5bkplk7s1q7N6UvdNksXBGsdrFFWo1OcGAHb3Y1cFMvRCFHgY3PQJCPbUiR
         N8cdPZBdijt1tPQoq3gvIkNgpnUeNDcix3M4pPVheOEvBxZ71nafAc9IM89nt/0Som
         q0YBn1+uy+MLZE/0NzUWcztqMmyGb+gKDELTArBfeTQQzBHkz9K3wgxlKHh74lYTJu
         7dhSFqRQSSEJg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] wcn36xx: Implement tx_rate reporting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220325224212.159690-1-egagnon@squareup.com>
References: <20220325224212.159690-1-egagnon@squareup.com>
To:     Edmond Gagnon <egagnon@squareup.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164862749156.10264.5966997435195917442.kvalo@kernel.org>
Date:   Wed, 30 Mar 2022 08:04:53 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edmond Gagnon <egagnon@squareup.com> wrote:

> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
> rate:
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 5200
>         RX: 4141 bytes (32 packets)
>         TX: 2082 bytes (15 packets)
>         signal: -77 dBm
>         rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>         tx bitrate: 6.0 MBit/s
> 
>         bss flags:      short-slot-time
>         dtim period:    1
>         beacon int:     100
> 
> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
> firmware message and reports it via ieee80211_ops::sta_statistics.
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 5700
>         RX: 26788094 bytes (19859 packets)
>         TX: 1101376 bytes (12119 packets)
>         signal: -75 dBm
>         rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>         tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
> 
>         bss flags:      short-slot-time
>         dtim period:    1
>         beacon int:     100
> 
> Tested on MSM8939 with WCN3680B running firmware CNSS-PR-2-0-1-2-c1-00083,
> and verified by sniffing frames over the air with Wireshark to ensure the
> MCS indices match.
> 
> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
> Reviewed-by: Benjamin Li <benl@squareup.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

1216c4d30723 wcn36xx: Implement tx_rate reporting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220325224212.159690-1-egagnon@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

