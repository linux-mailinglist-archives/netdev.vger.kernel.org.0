Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578EF1184D9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfLJKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:20:07 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:50886
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbfLJKUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575973206;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=0Kb+E+8ZdD4D68+aCTRlNTqRFi3yA4uuBGG8Rr2pQgY=;
        b=NeYakiUCjcRoxcFOZnt6eDM0Jw6DgF/tnZftTAXzQSXZCBTLtVUHjodLxZvTXBDH
        Hq9okvn8vJADB+4lLhu1iExlQjDCa2avyXGPQiQ2N28sL2jhNW2J3eUnPftbCBE0sjS
        8zvVlxy4TRDsGNGGSfBhTwmNwz1AXdSkjIZLROms=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575973206;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=0Kb+E+8ZdD4D68+aCTRlNTqRFi3yA4uuBGG8Rr2pQgY=;
        b=VuITrJj+QGHSbjoRYgHcNgD5stmzkqoubp1qS/rPYXMmGRDKHEZ+1XFtF503+RoY
        vZEjZl3cu1aydYOch0/P/dlSIWprQbnvW3xoRg52LTx6/OAKq52uqvIJOIT+pqxMXjJ
        +VfRIbeZnjfCG+yBJSf+s9Lz9Vf5FAcJAaECBda8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B3419C447AA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11 cores
References: <20191209223822.27236-1-smoch@web.de>
        <0101016eef117d24-d6de85e6-6356-4c73-bff4-f787e8c982bc-000000@us-west-2.amazonses.com>
        <d72831ab-902e-0b69-3008-6eb915784c4d@web.de>
Date:   Tue, 10 Dec 2019 10:20:06 +0000
In-Reply-To: <d72831ab-902e-0b69-3008-6eb915784c4d@web.de> (Soeren Moch's
        message of "Tue, 10 Dec 2019 11:14:22 +0100")
Message-ID: <0101016eef52b82d-f791d0d8-d317-4050-9e8a-07a3fa7dafd8-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.10-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> writes:

> On 10.12.19 10:08, Kalle Valo wrote:
>> Soeren Moch <smoch@web.de> writes:
>>
>>> From: Wright Feng <wright.feng@cypress.com>
>>>
>>> There are two D11 cores in RSDB chips like 4359. We have to reset two
>>> D11 cores simutaneously before firmware download, or the firmware may
>>> not be initialized correctly and cause "fw initialized failed" error.
>>>
>>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>> Soeren's s-o-b missing at least in patches 1, 6 and 7. Please read:
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing
>>
>
> OK, also for unmodified patches another s-o-b is required.

Yes, every patch you submit needs to have your s-o-b to mark that you
agree with Developer's Certificate of Origin.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
