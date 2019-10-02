Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663C7C8FC0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfJBRWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:22:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBRWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:22:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 78D4C6115A; Wed,  2 Oct 2019 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036928;
        bh=TrWb8Fbioz6upn5xSdi+3JyfA5DvFcdH33sJ3PxDMIA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=A0eFcc4c31vZRvniV6sds8pzG5AnZnVZBiacLnbolW6/egD1aPVBxrhe51m+4W662
         pe5TEnd1U/jeCRUvHVSGxBXdTykcy1tLVHBIlWFRhEtwu+wzjN6wBElgDJgCOgFu/T
         QGnGaMD4jjg5KUlsm0ITDWAV057HU7PvnW/SFDCw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78B4360A78;
        Wed,  2 Oct 2019 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036927;
        bh=TrWb8Fbioz6upn5xSdi+3JyfA5DvFcdH33sJ3PxDMIA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ae5RY74G4FY1UPUbQGjBiYnCV8MzaVZALr1ODv/dTgZEKOgq25LfnNAvTdu4n5ZWc
         LLFkBfPQIvrF9w4YhjxzIFZFE3hz7L1dnURzrQ6a8zfoYNQW+s+67WJU4GaoSKWocQ
         gzvxsxYnr1SG/cv0MzstK28tE0jA9zdxsKY+rsi0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78B4360A78
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ar5523: check NULL before memcpy() in ar5523_cmd()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190930203147.10140-1-efremov@linux.com>
References: <20190930203147.10140-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Laight <David.Laight@ACULAB.COM>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002172208.78D4C6115A@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 17:22:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> memcpy() call with "idata == NULL && ilen == 0" results in undefined
> behavior in ar5523_cmd(). For example, NULL is passed in callchain
> "ar5523_stat_work() -> ar5523_cmd_write() -> ar5523_cmd()". This patch
> adds ilen check before memcpy() call in ar5523_cmd() to prevent an
> undefined behavior.
> 
> Cc: Pontus Fuchs <pontus.fuchs@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

315cee426f87 ar5523: check NULL before memcpy() in ar5523_cmd()

-- 
https://patchwork.kernel.org/patch/11167401/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

