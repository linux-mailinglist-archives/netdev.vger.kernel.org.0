Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DBA2C5F0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfE1Lz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:55:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfE1Lz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:55:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 301E760F3C; Tue, 28 May 2019 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559044555;
        bh=k813bqE5/UfBXGr5ARK+Gx4QKOpZv/nuAkDg3b3jzBQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JUZBtdgJYCs5pblKIc0RuQHtvm6TnBNEVhH8aoqE71dcShKITPGDsMnvnPPmPvHla
         LSWMrEhVGZdChMYtAZcoNU6PYY9OwM6UpZoqLKHS85MtGrrctE2H+Vl6d13GWSLfRK
         N1hVofqV4A4eBNF1OisaJKWSkL41tfN4nb7JjlSk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FD3560EA5;
        Tue, 28 May 2019 11:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559044550;
        bh=k813bqE5/UfBXGr5ARK+Gx4QKOpZv/nuAkDg3b3jzBQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WOvlO9OiVt/8dVWyeJQBAOLYO+j8JM2gLCQRAgk5U9cO7vYYd2hVBhSBDn8Yic4mP
         gLeREwi2xjWCnce+jNnmZU1EpjP7pLVFJ65dljaJ1re9TosnZampAEcLgvdHn4Tsc/
         0HF4c0DbiFI5ds0Qa6wLLVuGDWmuxq+Hh1ntp+Hk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5FD3560EA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling
 code of rtl_pci_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190514123439.10524-1-baijiaju1990@gmail.com>
References: <20190514123439.10524-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528115555.301E760F3C@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:55:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> *BUG 1:
> In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
> rtl_deinit_core() in the error handling code is executed.
> rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
> rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
> initialized. Thus a null-pointer dereference occurs.
> The reason is that rtlpriv->scan_list.list is initialized by
> INIT_LIST_HEAD() in rtl_init_core(), which has not been called.
> 
> To fix this bug, rtl_deinit_core() should not be called when
> rtlpriv->cfg->ops->init_sw_vars() fails.
> 
> *BUG 2:
> In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
> this function fails, and rtlpriv->scan_list.list has not been
> initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
> handling code of rtl_pci_probe() is executed. Finally, a null-pointer
> dereference occurs due to the same reason of the above bug.
> 
> To fix this bug, the initialization of lists in rtl_init_core() are
> performed before the call to rtl_regd_init().
> 
> These bugs are found by a runtime fuzzing tool named FIZZER written by
> us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Ping & Larry, is this ok to take?

-- 
https://patchwork.kernel.org/patch/10942971/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

