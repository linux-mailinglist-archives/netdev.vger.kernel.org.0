Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7CE69F251
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBVJ5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBVJ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A99730E3;
        Wed, 22 Feb 2023 01:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B750D612AB;
        Wed, 22 Feb 2023 09:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3A9C433EF;
        Wed, 22 Feb 2023 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677059863;
        bh=fazYg7qTznisnA7g2km7hrq93t29unz91OkcRJ7inDU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hW8g7JbgkrzHrLoFa52q1sPdU/6b8fmnOeVE5TBpQ2KyuDUP+zL+Pm5dlqjNoW3j1
         BcxaZquKk6x2pgJCBVRz4/RbyEA5m3ZI3L61yLS/V9oX/wQTBY8ZGegC0gxytf6ujz
         AYm7iwzOz7lv6j39ubMSt7obke72yxOiq1zWYZPTKgZ/lg6HI+1EOvjvG1jylKBqgr
         t4t1Q0jOspKQjKEFK11RZ9nrMzZU44+Jif3OMrxd9zBHt9FbEyBO2S4P/IE4B1z8Kv
         OssPClXWs5HpfYvrpJ8V/H+Zf2CPTFRQV2KDuT5N2ukPtahT+5F60rRX8jmPVM+BNq
         pwagfsZnqVGvw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: snoc: enable threaded napi on WCN3990
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid>
References: <20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kuabhs@chromium.org, davem@davemloft.net,
        ath10k@lists.infradead.org, quic_mpubbise@quicinc.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-wireless@vger.kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167705985871.5928.5239693232532337781.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 09:57:40 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> wrote:

> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
> 
> Based on testing, it was observed that on WCN3990, the CPU0 reaches
> 100% utilization when napi runs in softirq context. At the same
> time the other CPUs are at low consumption percentage. This
> does not allow device to reach its maximum throughput potential.
> After enabling threaded napi, CPU load is balanced across all CPUs
> and following improvments were observed:
> - UDP_RX increase by ~22-25%
> - TCP_RX increase by ~15%
> 
> Here are some of the additional raw data with and without threaded napi:
> ==================================================
> udp_rx(Without threaded NAPI)
> 435.98+-5.16 : Channel 44
> 439.06+-0.66 : Channel 157
> 
> udp_rx(With threaded NAPI)
> 509.73+-41.03 : Channel 44
> 549.97+-7.62 : Channel 157
> ===================================================
> udp_tx(Without threaded NAPI)
> 461.31+-0.69  : Channel 44
> 461.46+-0.78 : Channel 157
> 
> udp_tx(With threaded NAPI)
> 459.20+-0.77 : Channel 44
> 459.78+-1.08 : Channel 157
> ===================================================
> tcp_rx(Without threaded NAPI)
> 472.63+-2.35 : Channel 44
> 469.29+-6.31 : Channel 157
> 
> tcp_rx(With threaded NAPI)
> 498.49+-2.44 : Channel 44
> 541.14+-40.65 : Channel 157
> ===================================================
> tcp_tx(Without threaded NAPI)
> 317.34+-2.37 : Channel 44
> 317.01+-2.56 : Channel 157
> 
> tcp_tx(With threaded NAPI)
> 371.34+-2.36 : Channel 44
> 376.95+-9.40 : Channel 157
> ===================================================
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

8c68fe00344c wifi: ath10k: snoc: enable threaded napi on WCN3990

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

