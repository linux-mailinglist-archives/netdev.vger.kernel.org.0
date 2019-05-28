Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E292C76D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfE1NJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:09:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfE1NJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:09:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BAAE46087F; Tue, 28 May 2019 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559048988;
        bh=LwktVprX+okLjofcVDA3KhlIJIxmhxsXuCyjGZ1pF8Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FzVjXmWJ0ItkDT6ygp9ShWa3YpFC0xSFTAxG15f6ot1HIA3kj1hJMrB7WR4w7HDBZ
         oEUVKgtj2CxzWfO8xeO50VJpj7CFqL9KjjhSU7rfd6a7Nd3EUvWoAhx2TTD9K0PYQe
         qyvHaVfipHEmIURuwtnZPuPCVpUTLvRoaZSfXjRA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4724060271;
        Tue, 28 May 2019 13:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559048988;
        bh=LwktVprX+okLjofcVDA3KhlIJIxmhxsXuCyjGZ1pF8Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FzVjXmWJ0ItkDT6ygp9ShWa3YpFC0xSFTAxG15f6ot1HIA3kj1hJMrB7WR4w7HDBZ
         oEUVKgtj2CxzWfO8xeO50VJpj7CFqL9KjjhSU7rfd6a7Nd3EUvWoAhx2TTD9K0PYQe
         qyvHaVfipHEmIURuwtnZPuPCVpUTLvRoaZSfXjRA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4724060271
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, pkshih@realtek.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix null-pointer dereferences in error handling code of rtl_pci_probe()
References: <20190514123439.10524-1-baijiaju1990@gmail.com>
        <20190528115555.301E760F3C@smtp.codeaurora.org>
        <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net>
Date:   Tue, 28 May 2019 16:09:44 +0300
In-Reply-To: <2658b691-b992-b773-c6cf-85801adc479f@lwfinger.net> (Larry
        Finger's message of "Tue, 28 May 2019 08:00:24 -0500")
Message-ID: <87pno24tev.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 5/28/19 6:55 AM, Kalle Valo wrote:
>> Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>
>>> *BUG 1:
>>> In rtl_pci_probe(), when rtlpriv->cfg->ops->init_sw_vars() fails,
>>> rtl_deinit_core() in the error handling code is executed.
>>> rtl_deinit_core() calls rtl_free_entries_from_scan_list(), which uses
>>> rtlpriv->scan_list.list in list_for_each_entry_safe(), but it has been
>>> initialized. Thus a null-pointer dereference occurs.
>>> The reason is that rtlpriv->scan_list.list is initialized by
>>> INIT_LIST_HEAD() in rtl_init_core(), which has not been called.
>>>
>>> To fix this bug, rtl_deinit_core() should not be called when
>>> rtlpriv->cfg->ops->init_sw_vars() fails.
>>>
>>> *BUG 2:
>>> In rtl_pci_probe(), rtl_init_core() can fail when rtl_regd_init() in
>>> this function fails, and rtlpriv->scan_list.list has not been
>>> initialized by INIT_LIST_HEAD(). Then, rtl_deinit_core() in the error
>>> handling code of rtl_pci_probe() is executed. Finally, a null-pointer
>>> dereference occurs due to the same reason of the above bug.
>>>
>>> To fix this bug, the initialization of lists in rtl_init_core() are
>>> performed before the call to rtl_regd_init().
>>>
>>> These bugs are found by a runtime fuzzing tool named FIZZER written by
>>> us.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> Ping & Larry, is this ok to take?
>>
>
> Kalle,
>
> Not at the moment. In reviewing the code, I was unable to see how this
> situation could develop, and his backtrace did not mention any rtlwifi
> code. For that reason, I asked him to add printk stat4ements to show
> the last part of rtl_pci that executed correctly. In
> https://marc.info/?l=linux-wireless&m=155788322631134&w=2, he promised
> to do that, but I have not seen the result.

Ok, thanks. I'll then drop this, please resubmit once everything is
understood and the patch is ready to be applied.

-- 
Kalle Valo
