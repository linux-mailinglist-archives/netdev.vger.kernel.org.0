Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30B52E0C7F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgLVPK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:10:58 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:35191 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgLVPK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:10:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608649833; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=k4T60vC2s1dNLZaTWXiVi917FKafMfvtENzWjJYqIVo=; b=TetvwAE2lBqdxvmTEKJTMK3TDnc7ghh9GUVhlEiVjCmCodunr8JaGGTXyH3jkr7086YP9d65
 mM/7FuIc965FJklTDJHFO/+WX40YjIki25i6DzO8kQQhsVT61PAUH2Y0QvqAcNwkX+IETcn1
 SM7h3wrzysg6h3s4lIeOnIbMp9o=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fe20c58da47198188df83a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 15:10:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 89E4FC43462; Tue, 22 Dec 2020 15:10:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A212C433C6;
        Tue, 22 Dec 2020 15:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A212C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <20201104155207.128076-10-Jerome.Pouiller@silabs.com>
Date:   Tue, 22 Dec 2020 17:10:11 +0200
In-Reply-To: <20201104155207.128076-10-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Wed, 4 Nov 2020 16:51:52 +0100")
Message-ID: <87lfdp98rw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> +/*
> + * Internal helpers.
> + *
> + * About CONFIG_VMAP_STACK:
> + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA on stack
> + * allocated data. Functions below that work with registers (aka functions
> + * ending with "32") automatically reallocate buffers with kmalloc. However,
> + * functions that work with arbitrary length buffers let's caller to handle
> + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly located
> + * buffer.
> + */

This sounds very hacky to me, I have understood that you should never
use stack with DMA.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
