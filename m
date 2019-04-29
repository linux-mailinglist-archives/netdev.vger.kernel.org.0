Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D00E5A0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfD2PB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:01:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfD2PBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:01:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1BB9460CEC; Mon, 29 Apr 2019 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556550085;
        bh=hPzUai/4q86KkLTLbU6B01pvrdI1M63fG/ZZE74WXcs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jIG5dcAvnCNNVv5zfUJXzHNe+xigOB2MVnGakh2ANQlqb3fYnjJZ9MI8eIxVcgXdg
         grg/A66/v1jsZO+X58xdvfgjPS30g1xDYIRHJZLEzTivJUBaCRz5Ee+YXgotLn/wza
         UQkw9h+MoTxmUJ3gD74I+aei66midGbxXA8SSHRg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A252602F3;
        Mon, 29 Apr 2019 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556550084;
        bh=hPzUai/4q86KkLTLbU6B01pvrdI1M63fG/ZZE74WXcs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eho73adpVes0NTGU9X+Zasbur9XOdRw0OiEU27+FFmc4L972qgcpdZoRc92RhGRUE
         i+flnE15M0rewzG7a5xQD7gUmXaRn1jGRXxrSBnkckJGXniaeU9727IdvBY16raR7E
         NDfdmR7AbheEi2liTu+D6hfmmgsbJx6bUAN+SRZ4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A252602F3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: carl9170: fix clang build warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190325124354.1413529-1-arnd@arndb.de>
References: <20190325124354.1413529-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429150125.1BB9460CEC@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 15:01:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> clang fails to eliminate some dead code with always-taken branches
> when CONFIG_PROFILE_ANNOTATED_BRANCHES is set, leading to a false-positive
> warning:
> 
> drivers/net/wireless/ath/carl9170/mac.c:522:3: error: variable 'power' is used uninitialized whenever 'if' condition is
>       false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> 
> Change both instances of BUG_ON(1) in carl9170 to the simpler BUG()
> to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

62acdcfa8b7a wireless: carl9170: fix clang build warning

-- 
https://patchwork.kernel.org/patch/10869053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

