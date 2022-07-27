Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558A582410
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiG0KUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiG0KUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA1A468;
        Wed, 27 Jul 2022 03:20:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D467661839;
        Wed, 27 Jul 2022 10:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1269C433D6;
        Wed, 27 Jul 2022 10:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658917246;
        bh=zInUtRDkP0CInDHQOs4hPEp3ldGko/tXOIpnWeY7TuQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JaGgQ2Zg1rB1DBHAmio7/LzXyQ5VbRV/63eZoEv2bBrCkHxhOiKb225WuOHJsaGuG
         1wxx8zpuJ/NQrGYTCbRMl1nWDM2WcV5kKsrkf9CnLQZ3c2hjA30R2nVIA2wpihs9/l
         nfAfDmkfVW4rZdVVgg+vOd0tJeXyr5rIx6qfB85rs35fHNKVeb10qin856M1AjEsJ7
         D5V7f79hBT7SFeLLVVOz8ex++C0H9n8RS1e/10CThBm2IXjmpTmSAUJXPgtVKSnT8X
         vqPFXtah9axurwYZJVxM5TFOFOOpy68/UylL2Sj+RseuD/AuvyKN2p81F8BWAnRcwt
         MzU8FfmSL+siw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wil6210: debugfs: fix uninitialized variable use in
 `wil_write_file_wmi()`
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220724202452.61846-1-ammar.faizi@intel.com>
References: <20220724202452.61846-1-ammar.faizi@intel.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        kernel test robot <lkp@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891724082.18387.16489160205660897757.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:20:42 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:

> Commit 7a4836560a61 changes simple_write_to_buffer() with memdup_user()
> but it forgets to change the value to be returned that came from
> simple_write_to_buffer() call. It results in the following warning:
> 
>   warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
>            return rc;
>                   ^~
> 
> Remove rc variable and just return the passed in length if the
> memdup_user() succeeds.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 7a4836560a6198d245d5732e26f94898b12eb760 ("wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()")
> Fixes: ff974e4083341383d3dd4079e52ed30f57f376f0 ("wil6210: debugfs interface to send raw WMI command")
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d578e0af3a00 wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220724202452.61846-1-ammar.faizi@intel.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

