Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B08C8FCD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfJBRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:23:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBRXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:23:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D7A36115A; Wed,  2 Oct 2019 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570037010;
        bh=GIXrIjcKew/FoSFsIMkDMdHE5gnAVoURct4BSIsXqxc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QyfFhXROIYAyipZMl6DRHkPWNaRvNu8hED+sSGCLM4u+N/POb3L0rD0ZmPSCj7LBt
         C0tJqOMORy9oMRiXFcAzjmMq64oteeSNMezh3KYKYkO51aTu75OnzYNm3vIvmvmsIq
         P1vSenro7bgxNI1zkuHGpuBuAf91W1VI+5dZ6LwA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1975E6085F;
        Wed,  2 Oct 2019 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570037009;
        bh=GIXrIjcKew/FoSFsIMkDMdHE5gnAVoURct4BSIsXqxc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=GXGifv1B22O5usx+rXwUjtUTrYLLrR+Pw1UD7AcXsz3MMOWnZzNr1cTLcJKtRzm9I
         ULmBz8oTsdWLjtAsN+zQ+FpaN1X0BO/m2SYeh1Law3u8YrDsUOs9m1JzpMdw/YEf9A
         PvnxPsasPE3Njk/1mYK0YYjzPHQRUyQa4ZO9/g+k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1975E6085F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: check len before memcpy() calls
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191001120823.29853-1-efremov@linux.com>
References: <20191001120823.29853-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-wireless@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002172330.4D7A36115A@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 17:23:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> memcpy() in wmi_set_ie() and wmi_update_ft_ies() is called with
> src == NULL and len == 0. This is an undefined behavior. Fix it
> by checking "ie_len > 0" before the memcpy() calls.
> 
> As suggested by GCC documentation:
> "The pointers passed to memmove (and similar functions in <string.h>)
> must be non-null even when nbytes==0, so GCC can use that information
> to remove the check after the memmove call." [1]
> 
> [1] https://gcc.gnu.org/gcc-4.9/porting_to.html
> 
> Cc: Maya Erez <merez@codeaurora.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2c840676be8f wil6210: check len before memcpy() calls

-- 
https://patchwork.kernel.org/patch/11168621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

