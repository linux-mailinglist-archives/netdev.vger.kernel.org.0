Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF33517122
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385469AbiEBOE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385467AbiEBOEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:04:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335825F75;
        Mon,  2 May 2022 07:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7677B81147;
        Mon,  2 May 2022 14:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B8FC385AC;
        Mon,  2 May 2022 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651500054;
        bh=LnW2rQnd7IzWF/OG/CrCr2IFtLGxNBoAByjw1ptUJik=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rhtgqWpNJlQBCsFtXzZdQrzg0yOi0tjVjo8Xf5ZM9gFaOA6ZjnQk9fJCLRrnsutg2
         3IQlsb6crkR/t1Deg0j2n9X30V4gCVTcovaDGU3QKyJPp2YmbRYcX4MlnmCaApJ5yL
         k3VfWEgY/dgkrK7lN1Y21D7NuO/YyGAzN22FxLeoghU1qw4L6UJ6M13+aFIBwXUaBK
         j5vTDbMo2sioPxPOhqmDXMQBv0dKZNEL6TnrzGzl7/jqfFGhnKGQzWy5wFMdyWAs+b
         5qPX39TjwPkjjK3n8deSOFo6jNPP1QKpm+8LjLKSOLIO/7TEeDeAN4v8hlwCtmQDZh
         lOqeZ1NDTnHCQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] carl9170: tx: fix an incorrect use of list iterator
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
References: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165150005048.16977.15575451697134497197.kvalo@kernel.org>
Date:   Mon,  2 May 2022 14:00:52 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> If the previous list_for_each_entry_continue_rcu() don't exit early
> (no goto hit inside the loop), the iterator 'cvif' after the loop
> will be a bogus pointer to an invalid structure object containing
> the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
> will lead to a invalid memory access (i.e., 'cvif->id': the invalid
> pointer dereference when return back to/after the callsite in the
> carl9170_update_beacon()).
> 
> The original intention should have been to return the valid 'cvif'
> when found in list, NULL otherwise. So just return NULL when no
> entry found, to fix this bug.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

54a6f29522da carl9170: tx: fix an incorrect use of list iterator

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220328122820.1004-1-xiam0nd.tong@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

