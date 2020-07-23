Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063A422B59A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgGWSZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:25:16 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64088 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgGWSZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 14:25:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595528715; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=yAfJG1ZM4LmfNVZaxnZ0GMv0GxwURX4mJ3TXKqKYdGE=; b=AngoQR5+YzZ6kKQP/BCWEF1Sh0Xd3egoAphORlihddjojj92/d+oNHfTX3OVBt0eLiZUbotC
 JQuKmdQvV8GENSf1fQHNGbznOy+hUn0iXE5FWylMLiehGX4mhTXK73WoJTIg/7n1rPliepwE
 pj/DZCSYx/Tgsv9XijJE3/I/m5A=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f19d60a5b75bcda60cbde6b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 18:25:14
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EFAAC433CA; Thu, 23 Jul 2020 18:25:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B12BFC433C6;
        Thu, 23 Jul 2020 18:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B12BFC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Rajkumar Manoharan'" <rmanohar@codeaurora.org>
Cc:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <dianders@chromium.org>, <evgreen@chromium.org>,
        <linux-wireless-owner@vger.kernel.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org> <1595351666-28193-3-git-send-email-pillair@codeaurora.org> <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
In-Reply-To: <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
Subject: RE: [RFC 2/7] ath10k: Add support to process rx packet in thread
Date:   Thu, 23 Jul 2020 23:55:06 +0530
Message-ID: <003001d6611e$9afa0cc0$d0ee2640$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwH2O/GCAtCmWRqpMfdhsA==
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rajkumar Manoharan <rmanohar@codeaurora.org>
> Sent: Wednesday, July 22, 2020 3:23 AM
> To: Rakesh Pillai <pillair@codeaurora.org>
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> kernel@vger.kernel.org; kvalo@codeaurora.org; johannes@sipsolutions.net;
> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> dianders@chromium.org; evgreen@chromium.org; linux-wireless-
> owner@vger.kernel.org
> Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
> 
> On 2020-07-21 10:14, Rakesh Pillai wrote:
> > NAPI instance gets scheduled on a CPU core on which
> > the IRQ was triggered. The processing of rx packets
> > can be CPU intensive and since NAPI cannot be moved
> > to a different CPU core, to get better performance,
> > its better to move the gist of rx packet processing
> > in a high priority thread.
> >
> > Add the init/deinit part for a thread to process the
> > receive packets.
> >
> IMHO this defeat the whole purpose of NAPI. Originally in ath10k
> irq processing happened in tasklet (high priority) context which in
> turn push more data to net core even though net is unable to process
> driver data as both happen in different context (fast producer - slow
> consumer)
> issue. Why can't CPU governor schedule the interrupts in less loaded CPU
> core?
> Otherwise you can play with different RPS and affinity settings to meet
> your
> requirement.
> 
> IMO introducing high priority tasklets/threads is not viable solution.

Hi Rajkumar,
In linux, the IRQs are directed to the first core which is booted.
I see that all the IRQs are getting routed to CORE0 even if its heavily
loaded.

IRQ and NAPI are not under the scheduler's control, since it cannot be
moved.
NAPI is scheduled only on the same core as IRQ. But a thread can be moved
around by the scheduler based on the CPU load.
This is the reason I went ahead with using thread.

Affinity settings are static, and cannot be done runtime without any
downstream userspace entity.


> 
> -Rajkumar

