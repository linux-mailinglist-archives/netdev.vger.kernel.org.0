Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C33B6415
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfIRNI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:08:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbfIRNI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 09:08:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1ABCD6155D; Wed, 18 Sep 2019 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568812137;
        bh=Xlm9buTwkjGMeOAaB1iCCifyWmGXMZvazAeI3ceUL+U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FZQShb2KcdByFxaca4AVvz7XWHjldvgGlJlQzoh8flyuU74TrUd7yCsv6eR3teZR8
         Wjze0C+teQYY8fqNlMRPIvgnaJJhLDuMlx1fLgyZwIgVJ+el2clRsdkz3yC3tC2JpA
         OyaRaQMaqitXo5SJcCUjS9+dXoUxFkeHi+zy/KOY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F129F614DC;
        Wed, 18 Sep 2019 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568812136;
        bh=Xlm9buTwkjGMeOAaB1iCCifyWmGXMZvazAeI3ceUL+U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ET8E4D+xHsJ5/aDa1J5+s0ESTYpL0JpbVSbrOQsbAvaQihdaGD18ntRHyCmOq6y29
         UyK39hb8V64zMYu05Nx8wF+P20TxsoGiavH3XA7lr83pJ2/8egpH1RtSaEjlJ5t0R0
         jVbwPwSgzIlRRPeD+hjQSSW81/J7ASldW4mD/6LM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F129F614DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] iwlwifi: add dependency of THERMAL with IWLMVM
References: <20190918122815.155657-1-maowenan@huawei.com>
Date:   Wed, 18 Sep 2019 16:08:51 +0300
In-Reply-To: <20190918122815.155657-1-maowenan@huawei.com> (Mao Wenan's
        message of "Wed, 18 Sep 2019 20:28:15 +0800")
Message-ID: <875zlpbvks.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mao Wenan <maowenan@huawei.com> writes:

> If CONFIG_IWLMVM=y, CONFIG_THERMAL=n, below error can be found:
> drivers/net/wireless/intel/iwlwifi/mvm/fw.o: In function `iwl_mvm_up':
> fw.c:(.text+0x2c26): undefined reference to `iwl_mvm_send_temp_report_ths_cmd'
> make: *** [vmlinux] Error 1
>
> After commit 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal
> monitoring regardless of CONFIG_THERMAL"), iwl_mvm_up()
> calls iwl_mvm_send_temp_report_ths_cmd(), but this function
> is under CONFIG_THERMAL, which is depended on CONFIG_THERMAL.
>
> Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Luca, should I apply this directly to wireless-drivers?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
