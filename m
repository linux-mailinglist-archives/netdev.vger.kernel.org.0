Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28822628BA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIIHaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:30:55 -0400
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:49414
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgIIHay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599636653;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=Mvz/rO34Eoh3cCV+99ueXvEtc9mS9uQzQUDgN9Kfy3o=;
        b=PfOl9cByqMReLMwla7goq+0Zsea78A9/994rhGQgsgm/fm/h+bOCzkthpT7xgu36
        XIN9/ILUaD6jtKAA5y0f5NemL7nRztukE3DlNieLUJ4KWP5cQ1DCZB7nWwP4tnZKewO
        QxyTMlEfi6XEXYqbhehJRhvqCJBzE9KVSTtHH8cE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599636653;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=Mvz/rO34Eoh3cCV+99ueXvEtc9mS9uQzQUDgN9Kfy3o=;
        b=m+WLbCW3X54fXDp9w8GIOpnTLWl43nmq6auQiAsvj+tSMEsxxgjacxLUVONy69x8
        I8AbRddJuEzOQVbAKfuTjolY1Xt3546NcrZ4Q2JxKUQOFZ/KZPztuC7mVH1dwnhfY7s
        9hIOzagIUHxBc0XT5u9CLFhAEMdAYnqe29w9PXnY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D53E3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: remove function pointer check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200906200548.18053-1-trix@redhat.com>
References: <20200906200548.18053-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        bzhao@marvell.com, dkiran@marvell.com, frankh@marvell.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017471c64568-a07c955e-1b2d-43db-a3b3-900114b1b095-000000@us-west-2.amazonses.com>
Date:   Wed, 9 Sep 2020 07:30:53 +0000
X-SES-Outgoing: 2020.09.09-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> clang static analyzer reports this problem
> 
> init.c:739:8: warning: Called function pointer
>   is null (null dereference)
>         ret = adapter->if_ops.check_fw_status( ...
>               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> In mwifiex_dnld_fw, there is an earlier check for check_fw_status(),
> The check was introduced for usb support at the same time this
> check in _mwifiex_fw_dpc() was made
> 
> 	if (adapter->if_ops.dnld_fw) {
> 		ret = adapter->if_ops.dnld_fw(adapter, &fw);
> 	} else {
> 		ret = mwifiex_dnld_fw(adapter, &fw);
> 	}
> 
> And a dnld_fw function initialized as part the usb's
> mwifiex_if_ops.
> 
> The other instances of mwifiex_if_ops for pci and sdio
> both set check_fw_status.
> 
> So the first check is not needed and can be removed.
> 
> Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

eb2c6ca2db8c mwifiex: remove function pointer check

-- 
https://patchwork.kernel.org/patch/11759719/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

