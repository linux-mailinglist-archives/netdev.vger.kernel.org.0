Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FD44303FF
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhJPRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 13:52:42 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:33634 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230071AbhJPRwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 13:52:41 -0400
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D9E2E1817352A;
        Sat, 16 Oct 2021 17:50:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id C2AD91E04D7;
        Sat, 16 Oct 2021 17:50:28 +0000 (UTC)
Message-ID: <8d16c5fa8d6dd2424cc5a136a879e88b90ec0345.camel@perches.com>
Subject: Re: [PATCH v3 1/5] mwifiex: Don't log error on suspend if
 wake-on-wlan is disabled
From:   Joe Perches <joe@perches.com>
To:     Jonas =?ISO-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tsuchiya Yuto <kitakar@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Date:   Sat, 16 Oct 2021 10:50:25 -0700
In-Reply-To: <20211016153244.24353-2-verdre@v0yd.nl>
References: <20211016153244.24353-1-verdre@v0yd.nl>
         <20211016153244.24353-2-verdre@v0yd.nl>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.91
X-Stat-Signature: 1otizh97cxkfe1cfcqkpczgjab9bxe79
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: C2AD91E04D7
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+A2kH2tKDKg0O1jm0nSW8lLql+D1gcUGs=
X-HE-Tag: 1634406628-700120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-10-16 at 17:32 +0200, Jonas Dreﬂler wrote:
> It's not an error if someone chooses to put their computer to sleep, not
> wanting it to wake up because the person next door has just discovered
> what a magic packet is. So change the loglevel of this annoying message
> from ERROR to INFO.
> 
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index ef697572a293..987558c4fc79 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -3492,7 +3492,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
>  	}
>  
>  	if (!wowlan) {
> -		mwifiex_dbg(adapter, ERROR,
> +		mwifiex_dbg(adapter, INFO,
>  			    "None of the WOWLAN triggers enabled\n");

None of these are have a loglevel of KERN_ERR,
all of these are logged at KERN_INFO.

What I don't understand is why mwifiex_dbg is using KERN_INFO at all
and not KERN_DEBUG.

[]

drivers/net/wireless/marvell/mwifiex/main.h:#define mwifiex_dbg(adapter, mask, fmt, ...)                                \
drivers/net/wireless/marvell/mwifiex/main.h-    _mwifiex_dbg(adapter, MWIFIEX_DBG_##mask, fmt, ##__VA_ARGS__)

[]

drivers/net/wireless/marvell/mwifiex/main.c:void _mwifiex_dbg(const struct mwifiex_adapter *adapter, int mask,
drivers/net/wireless/marvell/mwifiex/main.c-              const char *fmt, ...)
drivers/net/wireless/marvell/mwifiex/main.c-{
drivers/net/wireless/marvell/mwifiex/main.c-    struct va_format vaf;
drivers/net/wireless/marvell/mwifiex/main.c-    va_list args;
drivers/net/wireless/marvell/mwifiex/main.c-
drivers/net/wireless/marvell/mwifiex/main.c-    if (!(adapter->debug_mask & mask))
drivers/net/wireless/marvell/mwifiex/main.c-            return;
drivers/net/wireless/marvell/mwifiex/main.c-
drivers/net/wireless/marvell/mwifiex/main.c-    va_start(args, fmt);
drivers/net/wireless/marvell/mwifiex/main.c-
drivers/net/wireless/marvell/mwifiex/main.c-    vaf.fmt = fmt;
drivers/net/wireless/marvell/mwifiex/main.c-    vaf.va = &args;
drivers/net/wireless/marvell/mwifiex/main.c-
drivers/net/wireless/marvell/mwifiex/main.c-    if (adapter->dev)
drivers/net/wireless/marvell/mwifiex/main.c-            dev_info(adapter->dev, "%pV", &vaf);
drivers/net/wireless/marvell/mwifiex/main.c-    else
drivers/net/wireless/marvell/mwifiex/main.c-            pr_info("%pV", &vaf);
drivers/net/wireless/marvell/mwifiex/main.c-
drivers/net/wireless/marvell/mwifiex/main.c-    va_end(args);
drivers/net/wireless/marvell/mwifiex/main.c-}
drivers/net/wireless/marvell/mwifiex/main.c:EXPORT_SYMBOL_GPL(_mwifiex_dbg);


