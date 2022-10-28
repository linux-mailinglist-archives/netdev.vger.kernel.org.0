Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8A611442
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiJ1OPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiJ1OPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:15:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5442716E;
        Fri, 28 Oct 2022 07:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20DF9CE2B01;
        Fri, 28 Oct 2022 14:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62F0C433C1;
        Fri, 28 Oct 2022 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666966510;
        bh=lRa8EVy3KZ8s5pA5g5Deb1kR2JxJc31YvYEIftIUe7c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h8RDOkCpHl/EcssQNRtAJdtI4ocN4nSdYRb/9YAHYH5qzF8lxsENrQcaWxke3jxgq
         mte0pVpGipVqWtYF5fX2BuGdK3SYoI2rLvHs0l+en12qc3VIHEwFbT0kzkVcsWeWfn
         pLOfs9y2Wq2G8n70TdwPNMaEJXSXJD0egY0rWoLJxB4GbfcghVvEhd8dpXXNtE9Ewz
         zkJS8tQTloD5QC4THtDXQ8XqAPac6sN2H8PlkPDRENa0gJ5nDluOf2+Q3rdfpszASn
         cVecFaKemUv8EqJakq/lY6lxpU+tVxV5U+chePMBQmsGIY/w378w4uYCVjIXsyecvW
         U9+LbVEvWqYKQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-10-28
References: <20221028132943.304ECC433B5@smtp.kernel.org>
Date:   Fri, 28 Oct 2022 17:15:04 +0300
In-Reply-To: <20221028132943.304ECC433B5@smtp.kernel.org> (Kalle Valo's
        message of "Fri, 28 Oct 2022 13:29:43 +0000 (UTC)")
Message-ID: <8735b8vxuf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Note: wireless tree was merged[1] to wireless-next to avoid some
> conflicts with mac80211 patches between the trees. Unfortunately there
> are still two smaller conflicts in net/mac80211/util.c which Stephen
> also reported[2]. In the first conflict initialise scratch_len to
> "params->scratch_len ?: 3 * params->len" (note number 3, not 2!) and
> in the second conflict take the version which uses elems->scratch_pos.
>
> Git diff output should like this:
>
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@@ -1506,7 -1648,7 +1650,7 @@@ ieee802_11_parse_elems_full(struct ieee
>         const struct element *non_inherit = NULL;
>         u8 *nontransmitted_profile;
>         int nontransmitted_profile_len = 0;
> -       size_t scratch_len = params->len;
>  -      size_t scratch_len = params->scratch_len ?: 2 * params->len;
> ++      size_t scratch_len = params->scratch_len ?: 3 * params->len;
>
>         elems = kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
>         if (!elems)

And in case want to see the final result, here's an example merge I
pushed to our pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/tree/net/mac80211/util.c?h=pending&id=0879f594289e36546974c17f10bf587d9303e724#n1646

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
