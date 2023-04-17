Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA14C6E483A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjDQMsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjDQMs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:48:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961BA9023;
        Mon, 17 Apr 2023 05:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C5FA61943;
        Mon, 17 Apr 2023 12:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60708C4339B;
        Mon, 17 Apr 2023 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681735690;
        bh=ymO97Aj1BROKbgIqWrbAJ92afJ5pSqiQ6//laZMowAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TmYdTvq1LLLHHdM0flTSPwHd4wyIIkC2JLcI8mLDjHRIbPYon+zCWc5fnkYm7xAV0
         Y1jBjSn9BEKTHe7WOktlS1fN+d1TM6lBQxqcZfSFP+m1kpxbRzAJRLLMaC/YDZJ+UV
         zw8uJE+zv+0uXuLw1iCl32kcOnmmHr206/hBFFydFgsZu+9BBFGH49QOrpq7kEf57i
         CE8mXBDl/8X32hux5NROGyrWiOYa/zD0PuwFz3OCKzinXc5r7aWuFtSDeOZYuyiIw5
         gFjkyFDW+/BGeYE2cJrtRNO5R9PHz3cB5cRWjmRiekN5K5iYPiGcT2fvhkO/uPKBJf
         gESkuQ+z5Zvxg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath12k: fix missing unwind goto in
 `ath12k_pci_probe`
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230417115921.176229-1-lnk_01@hust.edu.cn>
References: <20230417115921.176229-1-lnk_01@hust.edu.cn>
To:     Li Ningke <lnk_01@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        hust-os-kernel-patches@googlegroups.com,
        Li Ningke <lnk_01@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168173568189.28224.5440053310426162831.kvalo@kernel.org>
Date:   Mon, 17 Apr 2023 12:48:06 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Ningke <lnk_01@hust.edu.cn> wrote:

> Smatch complains that
> drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe() warn: 
> missing unwind goto?
> 
> In order to release the allocated resources before returning an
> error, the statement that directly returns the error is changed
> to a goto statement that first releases the resources in the error
> handling section.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Li Ningke <lnk_01@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>

Already fixed with an identical patch:

https://git.kernel.org/kvalo/ath/c/488d9a484f96

error: patch failed: drivers/net/wireless/ath/ath12k/pci.c:1195
error: drivers/net/wireless/ath/ath12k/pci.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230417115921.176229-1-lnk_01@hust.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

