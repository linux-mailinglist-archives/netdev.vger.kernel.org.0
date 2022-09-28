Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3134B5ED542
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiI1GrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiI1Gqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:46:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12A465E3;
        Tue, 27 Sep 2022 23:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43B1BB81EF3;
        Wed, 28 Sep 2022 06:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8913C433D6;
        Wed, 28 Sep 2022 06:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664347468;
        bh=IvPHXslRQZhomYKYU67FC3SAD/LfrbtQCi7MMw3aSGk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hFuXhJFOFVZ0k02hFUtLziV8Zyn3eBvEcuaNGnTkNa287leV1uKXA+GqhZ5UdXJUD
         x/sj4bR1lB3V315XTPpTjcnM79Uky7O/+hl6mlVd/G5JYXzMUNy4JCisCAjrZM/Lkx
         j9wy8Ipyyd26ZXdC6Ta6rqxNnReO0kIGKpn36mw1SYHRvt18Tc9rAff2gVEnwr6f+T
         6q9vt46L3Iq10orv51F1S7oprpOfowbnffiYsRJ+CjCutrmealWtE66uj/e9cvgZsz
         ZVEGvb8kJxEfpCQshJUa6ZQfV29CCy+lJl3q/IXVQ7ybKenVDLHkgpZKkxuo/cBGEp
         nabe5znPeQpLw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: iwlwifi: Track scan_cmd allocation size explicitly
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220923220853.3302056-1-keescook@chromium.org>
References: <20220923220853.3302056-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kees Cook <keescook@chromium.org>,
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
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166434745921.25202.14807122782914947195.kvalo@kernel.org>
Date:   Wed, 28 Sep 2022 06:44:23 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

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

Patch applied to wireless-next.git, thanks.

72c08d9f4c72 wifi: iwlwifi: Track scan_cmd allocation size explicitly

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220923220853.3302056-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

