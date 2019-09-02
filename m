Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82975A55BD
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 14:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfIBMSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 08:18:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730493AbfIBMSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 08:18:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BB1796013C; Mon,  2 Sep 2019 12:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567426725;
        bh=y6MOPZNbdbsIKE5xMmrunzT5yG/1NCmehpMObitEB84=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FZQXrQGFNjBudozbjsIDfMWIUBBa1KVSEpSixXN1uEuzOzfW2vMk/AkW15+o6+1Sf
         Zi3X66wweKmQG8DCj2uejJPLwt4RlgzWRhYjU+0gFJxecz+acbzLdNwKTDgrLqiKnf
         kLNR50T7I1cLKuhtzZycvVRqm180NLuHz2oTGT5w=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6970260159;
        Mon,  2 Sep 2019 12:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567426725;
        bh=y6MOPZNbdbsIKE5xMmrunzT5yG/1NCmehpMObitEB84=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FZQXrQGFNjBudozbjsIDfMWIUBBa1KVSEpSixXN1uEuzOzfW2vMk/AkW15+o6+1Sf
         Zi3X66wweKmQG8DCj2uejJPLwt4RlgzWRhYjU+0gFJxecz+acbzLdNwKTDgrLqiKnf
         kLNR50T7I1cLKuhtzZycvVRqm180NLuHz2oTGT5w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6970260159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux\@endlessm.com" <linux@endlessm.com>
Subject: Re: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
References: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
        <20190826070827.1436-1-jian-hong@endlessm.com>
        <F7CD281DE3E379468C6D07993EA72F84D18AE2DA@RTITMBSVM04.realtek.com.tw>
Date:   Mon, 02 Sep 2019 15:18:40 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18AE2DA@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Tue, 27 Aug 2019 09:20:32 +0000")
Message-ID: <875zmarivz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> From: Jian-Hong Pan 
>> Subject: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
>> 
>> There is a mass of jobs between spin lock and unlock in the hardware
>> IRQ which will occupy much time originally. To make system work more
>> efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
>> reduce the time in hardware IRQ.
>> 
>> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
>
> Now it works fine with MSI interrupt enabled.
>
> But this patch is conflicting with MSI interrupt patch.
> Is there a better way we can make Kalle apply them more smoothly?
> I can rebase them and submit both if you're OK.

Yeah, submitting all the MSI patches in the same patchset is the easiest
approach. That way they apply cleanly to wireless-drivers-next.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
