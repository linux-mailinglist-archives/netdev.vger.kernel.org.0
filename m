Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36255E9B85
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiIZIDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiIZICn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:02:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077C6167C2;
        Mon, 26 Sep 2022 01:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E967B8191D;
        Mon, 26 Sep 2022 08:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15004C433C1;
        Mon, 26 Sep 2022 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664179199;
        bh=BKaJB74cTuefD7ABjII+u7AOgXdfZ6IIrKwYO+YFiwA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Hyc7Yt4JMRaV93ujZXcbA6K75iKsTxLlkmSgCVt36DaZp09gGDnmN4EJbeayeQ/qN
         3jEp8KLozDsB5an81OOeR7jhTN01D7/6umcHN2nNtowRyX35dtCAQ1JDHTjuEn9ULL
         oV6buTY/Pjh1znzJxLvS71sf46j3L57ogNSxUesw9iGcpVHQsL42CAtv1Z3RnZbW/b
         wtR6XNhWhaxNVau5wCZto1o8qodSKDM+Z7JI7nMB1jSI9rSqql3wOZYycygUYlXKZH
         GQNLjqJ66xRAjmjKK8LN9zfpa2pje/YYTyfFmuy955aTcDQUZ9Q9L5IscH5qYVfdnj
         yWy6pOoZhiNcw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nathan Errera <nathan.errera@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Mike Golant <michael.golant@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] iwlwifi: Track scan_cmd allocation size explicitly
References: <20220923220853.3302056-1-keescook@chromium.org>
Date:   Mon, 26 Sep 2022 10:59:52 +0300
In-Reply-To: <20220923220853.3302056-1-keescook@chromium.org> (Kees Cook's
        message of "Fri, 23 Sep 2022 15:08:53 -0700")
Message-ID: <874jwu4lc7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> In preparation for reducing the use of ksize(), explicitly track the
> size of scan_cmd allocations. This also allows for noticing if the scan
> size changes unexpectedly. Note that using ksize() was already incorrect
> here, in the sense that ksize() would not match the actual allocation
> size, which would trigger future run-time allocation bounds checking.
> (In other words, memset() may know how large scan_cmd was allocated for,
> but ksize() will return the upper bounds of the actually allocated memory,
> causing a run-time warning about an overflow.)
>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> Cc: Ilan Peer <ilan.peer@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Gregory, can I take this directly to wireless-next?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
