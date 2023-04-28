Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7DE6F1CEB
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346369AbjD1QxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346382AbjD1Qw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:52:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64BB59F7;
        Fri, 28 Apr 2023 09:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F24161117;
        Fri, 28 Apr 2023 16:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B48C433D2;
        Fri, 28 Apr 2023 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682700773;
        bh=Ezt4ZYiowbqC1PrtuI8WjsVZ4XgV3iCmsuEOLL4ouso=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G9soqrhOe89fxFNyQR51ep8n6gKTP5MZuVbZXyMHWWBRbqYSvwKHa7B6XUkzPa7gg
         AXbD2IWk9HYN1KGQoMqhZgCvKxs/qMtUezNMXvLhOjtxVCZie7hxi+hYPuY4MDVeBm
         6i15cQB0bGbDdZFQ9jayQ97Uec2zI8to2Z0vmEPg7Sp6cDqB+BNYuLtZgSYn313Dqn
         AymPtDBjpYXqLbuK8eR8wp+79P1cjV+icTqCFeFDFObAG1ZiZdgJ6g3qPTNq7NZTND
         EyldHwRslBQdKrIIUMI8RT73AtSkKTFJg40Ab/TX5U1c/DprMxwXwA8S1Z/PWf1oCm
         6TsnsGvAsLewQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] wifi: ath9k: avoid referencing uninit memory in
 ath9k_wmi_ctrl_rx
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230424183348.111355-1-pchelkin@ispras.ru>
References: <20230424183348.111355-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168270076830.13772.17120871163314648894.kvalo@kernel.org>
Date:   Fri, 28 Apr 2023 16:52:50 +0000 (UTC)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> For the reasons also described in commit b383e8abed41 ("wifi: ath9k: avoid
> uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
> validate pkt_len before accessing the SKB.
> 
> For example, the obtained SKB may have been badly constructed with
> pkt_len = 8. In this case, the SKB can only contain a valid htc_frame_hdr
> but after being processed in ath9k_htc_rx_msg() and passed to
> ath9k_wmi_ctrl_rx() endpoint RX handler, it is expected to have a WMI
> command header which should be located inside its data payload.
> 
> Implement sanity checking inside ath9k_wmi_ctrl_rx(). Otherwise, uninit
> memory can be referenced.
> 
> Tested on Qualcomm Atheros Communications AR9271 802.11n .
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

f24292e82708 wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230424183348.111355-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

