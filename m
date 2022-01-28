Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539EE49F725
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347703AbiA1KT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347545AbiA1KTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3919AC061714;
        Fri, 28 Jan 2022 02:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BC461E4E;
        Fri, 28 Jan 2022 10:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B361C340E0;
        Fri, 28 Jan 2022 10:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643365160;
        bh=RuOMg8k6pYNpeFvgZ9DyHZq7KGCMg0MQfJg8JkE1Jvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C//4/ML1QzHsrwK90xdf1z9iQJGCmbDg+NP2/O8nSW59muLI9DBLturaBo1uldLb+
         9YjKRAjLzJIexvJ1kwi6eLBLtd3QQKF30D77is+rLQANTei7mlrNCDxpe4Qb/enaFA
         dbxxPgr3dJ4APIU4tp2PF5rFMkcfZaPU66vBKcJc=
Date:   Fri, 28 Jan 2022 11:19:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Len Baker <len.baker@gmx.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Hans deGoede <hdegoede@redhat.com>,
        Matthias Brugger <mbrugger@suse.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Fix a NULL pointer dereference in
 brcmf_of_probe()
Message-ID: <YfPDJaPJ89vTuBXA@kroah.com>
References: <20220124165048.54677-1-zhou1615@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124165048.54677-1-zhou1615@umn.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:50:46AM +0800, Zhou Qingyang wrote:
> In brcmf_of_probe(), the return value of devm_kzalloc() is assigned to
> board_type and there is a dereference of it in strcpy() right after
> that. devm_kzalloc() could return NULL on failure of allocation, which
> could lead to NULL pointer dereference.
> 
> Fix this bug by adding a NULL check of board_type.
> 
> This bug was found by a static analyzer.
> 
> Builds with 'make allyesconfig' show no new warnings,
> and our static analyzer no longer warns about this code
> 
> Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> ---
> The analysis employs differential checking to identify inconsistent 
> security operations (e.g., checks or kfrees) between two code paths 
> and confirms that the inconsistent operations are not recovered in the
> current function or the callers, so they constitute bugs. 
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index 513c7e6421b2..535e8ddeab8d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -80,6 +80,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  		/* get rid of '/' in the compatible string to be able to find the FW */
>  		len = strlen(tmp) + 1;
>  		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
> +		if (!board_type)
> +			return;
>  		strscpy(board_type, tmp, len);
>  		for (i = 0; i < board_type[i]; i++) {
>  			if (board_type[i] == '/')
> -- 
> 2.25.1
> 

As stated before, umn.edu is still not allowed to contribute to the
Linux kernel.  Please work with your administration to resolve this
issue.

