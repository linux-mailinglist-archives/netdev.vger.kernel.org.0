Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7912D52290
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFYFIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:08:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFYFIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:08:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 55F3160117; Tue, 25 Jun 2019 05:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561439314;
        bh=Etw/gzrvxnAmkHMqOUnEH9bAj7d2LTwoXEaqXn/6fiI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Th9zCbu/hRTPOK4A1qzS7CNacwXS9wy+7AorOPFz3K353brv78BETC+/nko+azbG5
         17rx5QfDxzSSnaXk364aJBfXMFIMb0B5uJidQGnf0TJn0ZUkU8y3lmRpmN1A6Auh/X
         hjoXZowGeVrjlTRYTByWteYLld3gnAJQzjFvrPu8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12FDF60117;
        Tue, 25 Jun 2019 05:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561439313;
        bh=Etw/gzrvxnAmkHMqOUnEH9bAj7d2LTwoXEaqXn/6fiI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=I+eaKgkiLn1L+7D47P/Kqysb5BSL6vP/xod/Z6EPT219sT/+HGWlCAXPbt3HEajkC
         jf/5tE6lMcIWncPAkjTBcOo7HzaaU/lzE5zs3rP38bl5pPBfCdHykGqE0Lxb8o1zu2
         ciZiPWDaZLC2ZRwBewHp7SWHAkdhcxtCZ76BNyq0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12FDF60117
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] iwlegacy: 3945: no need to check return value of
 debugfs_create functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190612142658.12792-1-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625050834.55F3160117@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 05:08:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  This driver was saving the debugfs file away to be
> removed at a later time.  However, the 80211 core would delete the whole
> directory that the debugfs files are created in, after it asks the
> driver to do the deletion, so just rely on the 80211 core to do all of
> the cleanup for us, making us not need to keep a pointer to the dentries
> around at all.
> 
> This cleans up the structure of the driver data a bit and makes the code
> a tiny bit smaller.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

2 patches applied to wireless-drivers-next.git, thanks.

f503c7695343 iwlegacy: 3945: no need to check return value of debugfs_create functions
ffb92649f4d9 iwlegacy: 4965: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10990125/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

