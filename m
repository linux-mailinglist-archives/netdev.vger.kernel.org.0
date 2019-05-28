Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B752C6D9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfE1Mn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:43:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53366 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfE1Mn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:43:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5D9D960F38; Tue, 28 May 2019 12:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047435;
        bh=w9bX69ME/NHLXTgt9b0N8rt7z+QC2MaVUpAM+dM7Ouw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LUcrB9ExAFl/5ON0ivYboIdJ7k3xs/M5eFubgMsmdDSWg95T8w9HrJz7wrIw33rvX
         +2bbxr3NmUZ4500+t3phxt4muXTip54tKHqO4zSBHnV0DEzqGvPIWLycxhjSfwdJSQ
         bDU0iJN9Obuq+ul1DFUBFAbMTPCGPV/CCHiZw3DY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 629DD6087F;
        Tue, 28 May 2019 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047433;
        bh=w9bX69ME/NHLXTgt9b0N8rt7z+QC2MaVUpAM+dM7Ouw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UYmTy8UhwZkN7O99jfdWUYBHNErNjiu/uGhzGUI+X7HnvCH2DrEZsCb9iNlWLkYcW
         GEBkqN0yCRNk+ox4yLNTkqhnwtIdCIJzydFf+e8EjEe3EEqKeBx9+4o5gh9zGI1s/b
         D37PYu0TLm/S+hFazSqPbFk38YNSGdn9+CRay3ME=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 629DD6087F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: Avoid possible double calls to b43_one_core_detach()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190504091000.18665-1-baijiaju1990@gmail.com>
References: <20190504091000.18665-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, colin.king@canonical.com,
        yuehaibing@huawei.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528124355.5D9D960F38@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:43:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> In b43_request_firmware(), when ieee80211_register_hw() fails,
> b43_one_core_detach() is called. In b43_bcma_remove() and
> b43_ssb_remove(), b43_one_core_detach() is called again. In this case, 
> null-pointer dereferences and double-free problems can occur when 
> the driver is removed.
> 
> To fix this bug, the call to b43_one_core_detach() in
> b43_request_firmware() is deleted.
> 
> This bug is found by a runtime fuzzing tool named FIZZER written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

ec2e93cf1910 b43: Avoid possible double calls to b43_one_core_detach()

-- 
https://patchwork.kernel.org/patch/10929623/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

