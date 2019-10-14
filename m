Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB237D5D8B
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbfJNIcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:32:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfJNIce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:32:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 20B03606CF; Mon, 14 Oct 2019 08:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571041954;
        bh=mqqICtAwQO6IrAaUIxFT7Uu3ziQTlKCLs+IOJ1bdsVE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XUUeeIZrI8TbhyfqZoP6OuDHJq13fKXFppsRTkNoM/uBjHEjc4Ov+tIAm21sNsxDg
         jXO/+c6lz8ULlJJ9/MLP91eJx7PwU2m63i8qduzGzF+VGjeFeoaT3BXZglKN83eS7F
         gptdYVI6qaLxMxc9nJtBbTpb20w39GPoACNz9lSo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2650360256;
        Mon, 14 Oct 2019 08:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571041953;
        bh=mqqICtAwQO6IrAaUIxFT7Uu3ziQTlKCLs+IOJ1bdsVE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CjTLFxp2I4Aq0r4fNj7qxXzPLOND7hKWl/kODSbPW7F6SkZC3gvr+NRkQMAL57ifH
         DQliA/kyrk+g6J3Dtgj7A4nABSPkdNfjtmeEYO4+iWFXB9dxB3H8ZFJzjxQ2hPR4k2
         /sFz3BcTnfgIJYdQ5coy+pWyYIxHHlruAFf+fb2E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2650360256
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ath10k@lists.infradead.org,
        Niklas Cassel <niklas.cassel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Correct error check of dma_map_single()
References: <20191010162653.141303-1-bjorn.andersson@linaro.org>
        <20191011115732.044BF60BE8@smtp.codeaurora.org>
        <20191011171652.GF571@minitux>
Date:   Mon, 14 Oct 2019 11:32:28 +0300
In-Reply-To: <20191011171652.GF571@minitux> (Bjorn Andersson's message of
        "Fri, 11 Oct 2019 10:16:52 -0700")
Message-ID: <87a7a3zq03.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Fri 11 Oct 04:57 PDT 2019, Kalle Valo wrote:
>
>> Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>> 
>> > The return value of dma_map_single() should be checked for errors using
>> > dma_mapping_error(), rather than testing for NULL. Correct this.
>> > 
>> > Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference
>> > support over wmi")
>> > Cc: stable@vger.kernel.org
>> > Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
>> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> 
>> Did this fix any real bug? Or is this just something found during code review?
>> 
>
> CONFIG_DMA_API_DEBUG screamed at us for calling dma_unmap_single()
> without ever having called dma_mapping_error() on the return value.

Ok, I'll add something about to the commit log in v2 so that the
background is also documented.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
