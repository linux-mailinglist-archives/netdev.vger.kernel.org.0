Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1682F66DCE4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbjAQLyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236919AbjAQLyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:54:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993C3609B;
        Tue, 17 Jan 2023 03:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F51612ED;
        Tue, 17 Jan 2023 11:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1820C433EF;
        Tue, 17 Jan 2023 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956443;
        bh=iES5WuSh2BX4eOE4bMY9bqndaB6ME85FZx8qtHTXm/Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=m4zzAj9OXqabVPimStr8Y0eqTEDSJE5iPcTipqilIyslW/mxyaCuDYcLc1P0CnE1E
         99y9IrfL8k90zxGwZc+A/34Kjms0+cIdmPFmZEj6XRefLHVhMIJAeVUpOBHcSpO96z
         IQwIXxmkQoWyselLRPyWLnEQsjXencLkriRhvw/QqFnueugN/RLY4ZhS+sQtzOiJjk
         p07EBPLMyB1MkBYIwyX7+ebSEdNcDzutpOB6LOAaHjoPV82qdCVzajzh6wWCYTsgQs
         Novkp/mFuIZbJIjCVbNBTUAW6w3xWvXxqkZWfG6S46DcpfZgIllv01s94AxwyjjSxF
         aBXeqxwyUe6oA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230104123615.51511-1-pchelkin@ispras.ru>
References: <20230104123615.51511-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167395643773.22891.16285001709469402107.kvalo@kernel.org>
Date:   Tue, 17 Jan 2023 11:53:59 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
> While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
> skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
> have an incorrect pkt_len or pkt_tag, the input skb is considered invalid
> and dropped. All the associated packets already in skb_pool should be
> dropped and freed. Added a comment describing this issue.
> 
> The patch also makes remain_skb NULL after being processed so that it
> cannot be referenced after potential free. The initialization of hif_dev
> fields which are associated with remain_skb (rx_remain_len,
> rx_transfer_len and rx_pad_len) is moved after a new remain_skb is
> allocated.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream")
> Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
> Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

0af54343a762 wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230104123615.51511-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

