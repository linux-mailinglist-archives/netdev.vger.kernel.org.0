Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08692C3F2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfE1KIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:08:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfE1KIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:08:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C213360769; Tue, 28 May 2019 10:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559038102;
        bh=Sy36uPL5uDHOvP4eZU518Q3ctz2pO1yjVuQ/nWsGUog=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ezsSCvuHNEZDkI516/Zgf7gtIiADaPsqlu9R/8za4cRiRmrPavvU9s8EsctxgGi2W
         h4tnO6m48arD4bo239S0New9uSK+FPV8G8VN5WYXDJJbPpw25imeixeMAnMqTiEUYR
         Fw7oKg5nUsyx8MSw1apCSYSAsU3woWEu4Zgd+G30=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.206.25.51] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aneela@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24904604BE;
        Tue, 28 May 2019 10:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559038102;
        bh=Sy36uPL5uDHOvP4eZU518Q3ctz2pO1yjVuQ/nWsGUog=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ezsSCvuHNEZDkI516/Zgf7gtIiADaPsqlu9R/8za4cRiRmrPavvU9s8EsctxgGi2W
         h4tnO6m48arD4bo239S0New9uSK+FPV8G8VN5WYXDJJbPpw25imeixeMAnMqTiEUYR
         Fw7oKg5nUsyx8MSw1apCSYSAsU3woWEu4Zgd+G30=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 24904604BE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aneela@codeaurora.org
Subject: Re: netdev_alloc_skb is failing for 16k length
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Chris Lew <clew@codeaurora.org>
References: <6891cd8b-a3be-91f5-39c4-7a7e7d498921@codeaurora.org>
 <20190527075956.26f869ec@hermes.lan>
From:   Arun Kumar Neelakantam <aneela@codeaurora.org>
Message-ID: <2ab84730-70ae-4f30-241d-e51bc0c61d16@codeaurora.org>
Date:   Tue, 28 May 2019 15:38:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527075956.26f869ec@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/2019 8:29 PM, Stephen Hemminger wrote:
> On Mon, 27 May 2019 12:21:51 +0530
> Arun Kumar Neelakantam <aneela@codeaurora.org> wrote:
>
>> Hi team,
>>
>> we are using "skb = netdev_alloc_skb(NULL, len);" which is getting
>> failed sometimes for len = 16k.
>>
>> I suspect mostly system memory got fragmented and hence atomic memory
>> allocation for 16k is failing, can you please suggest best way to handle
>> this failure case.
>>
>> Thanks
>>
>> Arun N
>>
> If you are handling big frames, then put the data in page size chunks
> and use build_skb.

Thank you. Now using alloc_skb_with_frags() with order 0 to allocate the 
memory fragments

and skb_store_bits() to store the data to skb from buffer.

