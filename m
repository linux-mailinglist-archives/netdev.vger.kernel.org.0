Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621A723DEC9
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgHFRbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgHFRbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 13:31:23 -0400
Received: from [10.20.23.223] (unknown [12.97.180.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD6A23121;
        Thu,  6 Aug 2020 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596723838;
        bh=5ZUQhH4PMrtC+SaoTpZasAo44xzwb5YxXmuircmK4VU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TNwOaSnYwAU9V4Lauj/qaS4RZbDaGYaZwK1pIRL+oDVoYUO3SCDnT7OwxQIfL7QzH
         IQ+JjjYCIZCQ2niOrELQ3+zGHVTGs7ZwYtDbldjkzlwG+Ic2ZAwe/iXAGBtlBhwEsZ
         MFx4HWl5OUywJfiPshX2MrPAXZ/NHiIm+9q8Tctg=
Subject: Re: [PATCH net] net: qcom/emac: Fix missing clk_disable_unprepare()
 in error path of emac_probe
To:     Wang Hai <wanghai38@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200806140647.43099-1-wanghai38@huawei.com>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <87f41175-689e-f198-aaf6-9b9f04449ed8@kernel.org>
Date:   Thu, 6 Aug 2020 09:23:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806140647.43099-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/20 9:06 AM, Wang Hai wrote:
> In emac_clks_phase1_init() of emac_probe(), there may be a situation
> in which some clk_prepare_enable() succeed and others fail.
> If emac_clks_phase1_init() fails, goto err_undo_clocks to clean up
> the clk that was successfully clk_prepare_enable().

Good catch, however, I think the proper fix is to fix this in 
emac_clks_phase1_init(), so that if some clocks fail, the other clocks 
are cleaned up and then an error is returned.
