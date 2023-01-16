Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1624D66C882
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjAPQj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjAPQjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:39:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B5223317;
        Mon, 16 Jan 2023 08:27:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44B0FB81060;
        Mon, 16 Jan 2023 16:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA8C433EF;
        Mon, 16 Jan 2023 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673886477;
        bh=0w8vCqO96gJep16XdgEibrduNzw1JQiyb9sYu8b5j5o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Qn30mYWPfgv8xXJH62EToF8Xw7kZRseZXICl9TPu6aQf73j/1rK5NOXRxKjgsrfpr
         aZTf1sykLTsz5vx5EtGzngCAfcMOdlkbkx/T1EntcUJ1Fcd0sgN+H1DoUbmx4oOjyh
         Z4L1DQ4luR3hAVpKn7d6mz9zM+IJvIhzBQmdZZLd7bJKMtbnyEXqoyKxGKz8h/1tDS
         YwPnkAS8tvVzSaD6niQz4sPorCJNBtoSvEpgC9c4aG+QccK5fC757mmjMK4JfoYj63
         em7Sr2o1vfibF0eT2jfQGz4SoDa4TtGkqqugmJ8g4aQyY0pxRCWWUspm1nv0lE5Krm
         wts61bBvEFClw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc()
 outside the RCU
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
References: <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        pkshih@realtek.com, s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167388647360.5321.2500717977847316279.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 16:27:55 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> USB and (upcoming) SDIO support may sleep in the read/write handlers.
> Shrink the RCU critical section so it only cover the call to
> ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
> found station. This moves the chip's BFEE configuration outside the
> rcu_read_lock section and thus prevent "scheduling while atomic" or
> "Voluntary context switch within RCU read-side critical section!"
> warnings when accessing the registers using an SDIO card (which is
> where this issue has been spotted in the real world - but it also
> affects USB cards).
> 
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

3 patches applied to wireless-next.git, thanks.

8a1e2fd8e2da wifi: rtw88: Move register access from rtw_bf_assoc() outside the RCU
313f6dc7c5ed wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
2931978cd74f wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230108211324.442823-2-martin.blumenstingl@googlemail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

