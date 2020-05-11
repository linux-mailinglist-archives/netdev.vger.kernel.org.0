Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF31CD942
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgEKMDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:03:39 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:55562 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729782AbgEKMDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:03:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589198616; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=HLhZMaOCv1O1jz47tTVuggCyPQt8joEJFRzbgN2Z4oQ=; b=a1ddVnkixIKd0atXBdYrEEE3wZ4wSTXL2FzOy58Iqe5CIRfDxEN0iuq7J9UMUmfv8zW7Z+ra
 3C4dEDez8kepnFLZZhbxT25wlqob5eBP8yXM6Cl610W/TAjnesCRGbSmRyZa47A72Qqvunfe
 5zUMf6c8ITQrhf/VVcz8avkEDk8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6E2EC433BA; Mon, 11 May 2020 12:02:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 642A5C433F2;
        Mon, 11 May 2020 12:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 642A5C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds warnings
References: <20200509120707.188595-1-arnd@arndb.de>
        <20200509154818.GB27779@embeddedor>
Date:   Mon, 11 May 2020 15:02:38 +0300
In-Reply-To: <20200509154818.GB27779@embeddedor> (Gustavo A. R. Silva's
        message of "Sat, 9 May 2020 10:48:18 -0500")
Message-ID: <87zhae4r35.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> Arnd,
>
> On Sat, May 09, 2020 at 02:06:32PM +0200, Arnd Bergmann wrote:
>> gcc-10 started warning about out-of-bounds access for zero-length
>> arrays:
>> 
>> In file included from drivers/net/wireless/ath/ath10k/core.h:18,
>>                  from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
>> drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
>> drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
>>  1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
>>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
>>  1676 |  struct htt_tx_fetch_record records[0];
>>       |                             ^~~~~~~
>> 
>> Make records[] a flexible array member to allow this, moving it behind
>> the other zero-length member that is not accessed in a way that gcc
>> warns about.
>> 
>> Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with
>> flexible-array member")
>
> This treewide patch no longer contains changes for ath10k. I removed them
> since Monday (05/04/2020). So, this "Fixes" tag does not apply.

Ok, I'll remove it. Also I'll take these to my ath.git tree, not to
net-next.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
