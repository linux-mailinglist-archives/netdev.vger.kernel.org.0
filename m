Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DAB4F624D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiDFO4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbiDFO4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0092A607705;
        Wed,  6 Apr 2022 04:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41CB76179A;
        Wed,  6 Apr 2022 11:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4941CC385A3;
        Wed,  6 Apr 2022 11:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649244760;
        bh=IQBcwFj9MqsdsNJ0kqmRqwox5Bmr/ngz6SEfMkZ1JJ4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Sa4xdPObrnpMA40mL0TTMsIa4EDjSiv9e/fDS6eSD2oeV87/LFHcESGSJSklK/66y
         yFb08/DutTekWoY137FmUEIYGBRUEdkcyt2WSj7sw8UwsIEs4IoXoiwwD1Hlqb+W8d
         eyu7iE8J1dsDC64m4rR1wJZk0ys6eDdMpCS67L3Ag3y2sHjcKwVHYLwBdgWhYkJth8
         mSPBLazQCWGqMzBWA7Wq+VkkjG1uhISdV3WkXN8BCyxpt/io/4mSIrHsCYkrDpi6cy
         I3FOCsSsdh3f90Eel7B2M9Y+FIs1C4FCcSI8oIg3i1bE9M9/Vqk/X5ezwUdFVwrgc8
         UhW2DbvYUaLfA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] cw1200: fix incorrect check to determine if no element
 is
 found in list
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220320035436.11293-1-xiam0nd.tong@gmail.com>
References: <20220320035436.11293-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jakobkoschel@gmail.com,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924475461.19026.8095141212129340061.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 11:32:38 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here: "} else if (item) {".
> 
> The list iterator value will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found in list.
> 
> Use a new value 'iter' as the list iterator, while use the old value
> 'item' as a dedicated pointer to point to the found element, which
> 1. can fix this bug, due to now 'item' is NULL only if it's not found.
> 2. do not need to change all the uses of 'item' after the loop.
> 3. can also limit the scope of the list iterator 'iter' *only inside*
>    the traversal loop by simply declaring 'iter' inside the loop in the
>    future, as usage of the iterator outside of the list_for_each_entry
>    is considered harmful. https://lkml.org/lkml/2022/2/17/1032
> 
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Can someone review this, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220320035436.11293-1-xiam0nd.tong@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

