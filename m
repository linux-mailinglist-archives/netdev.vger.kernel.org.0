Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E96124FEF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLRR64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:58:56 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:31622 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbfLRR64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:58:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576691935; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3C6L4b2dA8aEQpFcyQGCt4S6TCBt8DWzO/OHKf/+d/Q=;
 b=sjS0HqG9ljt91DXxDWPuhJvCKcG8+ewseIy2bBGLz7Cw0vZxjK/+tqsLO9NibEMA9auj8yXq
 Z9RINFuXO7MBurF0g9cq0bZOi2DKrZLk+3fJS0H2dh4XtxRforeIUV+NrrOGGShyIkpnr5N1
 jEtnfB/mO1rqCloLkH128Xl2uls=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa68d9.7f828cb120d8-smtp-out-n02;
 Wed, 18 Dec 2019 17:58:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 79F77C447A0; Wed, 18 Dec 2019 17:58:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00DB5C433CB;
        Wed, 18 Dec 2019 17:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 00DB5C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/7] ath9k: fix storage endpoint lookup
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191210114426.4713-2-johan@kernel.org>
References: <20191210114426.4713-2-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218175847.79F77C447A0@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 17:58:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> wrote:

> Make sure to use the current alternate setting when verifying the
> storage interface descriptors to avoid submitting an URB to an invalid
> endpoint.
> 
> Failing to do so could cause the driver to misbehave or trigger a WARN()
> in usb_submit_urb() that kernels with panic_on_warn set would choke on.
> 
> Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
> Cc: stable <stable@vger.kernel.org>     # 2.6.39
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0ef332951e85 ath9k: fix storage endpoint lookup

-- 
https://patchwork.kernel.org/patch/11282013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
