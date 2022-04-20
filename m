Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4726C50878F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378359AbiDTMAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376472AbiDTMAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 08:00:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6561C90B;
        Wed, 20 Apr 2022 04:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8616F61956;
        Wed, 20 Apr 2022 11:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F898C385A1;
        Wed, 20 Apr 2022 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650455885;
        bh=jIZaCR72MF416k5GIz4UoDMTlUaPThfpK+9Q+0zcmnA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NfDGpu1qdTYrgU1CsS4C493/8J8g7H83U69IwcitBhqJRfSidYmtcLEanfyNq6EbH
         /5j8jbyJHH8uyMGmM3drZuhFOOARrXoDzSm70oiHYofgNXtYaMg2/VNW2z67PhjB0I
         L4DUYj6f0hTq6Sfnz8HGZXxpjbXVHN0HJugl5dQz+9BLCt7+wJqfKUSEnpiZDs6jNx
         3gJe4Xxx/tDHdNnl+aFTdYKgEcKP2jUiI+AZRM/L6gbU9nXlrAYlFH0fGiCbef64I1
         a1ftlEy/XIt2moCYmXDBBveAANFowT7iLF7M/MrDGdBnNUpN+L6ek8sv+HVoGaPnvt
         hZN/i+uTYH5bA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jaehee Park <jhpark1013@gmail.com>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
Date:   Wed, 20 Apr 2022 14:57:57 +0300
In-Reply-To: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme> (Jaehee
        Park's message of "Sun, 17 Apr 2022 23:51:10 -0400")
Message-ID: <87y200nf0a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaehee Park <jhpark1013@gmail.com> writes:

> Currently, upon virtual interface creation, wfx_add_interface() stores
> a reference to the corresponding struct ieee80211_vif in private data,
> for later usage. This is not needed when using the container_of
> construct. This construct already has all the info it needs to retrieve
> the reference to the corresponding struct from the offset that is
> already available, inherent in container_of(), between its type and
> member inputs (struct ieee80211_vif and drv_priv, respectively).
> Remove vif (which was previously storing the reference to the struct
> ieee80211_vif) from the struct wfx_vif, define a function
> wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> the newly defined container_of construct.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>

[...]

> +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> +{
> +	return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
> +}

Why the void pointer cast? Avoid casts as much possible.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
