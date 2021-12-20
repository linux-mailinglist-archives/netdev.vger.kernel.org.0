Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1947A943
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhLTMNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:13:37 -0500
Received: from relay034.a.hostedemail.com ([64.99.140.34]:36372 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231173AbhLTMNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:13:37 -0500
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 796EB1D8;
        Mon, 20 Dec 2021 12:13:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 533192002C;
        Mon, 20 Dec 2021 12:13:21 +0000 (UTC)
Message-ID: <bc4a4ba7c07a4077b9790be883fb4205d401804e.camel@perches.com>
Subject: Re: [PATCH 4.19 3/6] mwifiex: Remove unnecessary braces from
 HostCmd_SET_SEQ_NO_BSS_INFO
From:   Joe Perches <joe@perches.com>
To:     Anders Roxell <anders.roxell@linaro.org>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andy Lavr <andy.lavr@gmail.com>
Date:   Mon, 20 Dec 2021 04:13:20 -0800
In-Reply-To: <20211217144119.2538175-4-anders.roxell@linaro.org>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
         <20211217144119.2538175-4-anders.roxell@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 533192002C
X-Spam-Status: No, score=-1.11
X-Stat-Signature: 5gayuqe4kzuw64zsi7w1zyzmxgih75tc
X-Rspamd-Server: rspamout07
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18u6WrSAOpDdNGkNCm15RZg1zit1HkWz44=
X-HE-Tag: 1640002401-869126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-17 at 15:41 +0100, Anders Roxell wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> 
> commit 6a953dc4dbd1c7057fb765a24f37a5e953c85fb0 upstream.
> 
> A new warning in clang points out when macro expansion might result in a
> GNU C statement expression. There is an instance of this in the mwifiex
> driver:
> 
> drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
> ')' tokens terminating statement expression appear in different macro
> expansion contexts [-Wcompound-token-split-by-macro]
>         host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
[]
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
[]
> @@ -512,10 +512,10 @@ enum mwifiex_channel_flags {
>  
>  #define RF_ANTENNA_AUTO                 0xFFFF
>  
> -#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
> -	(((seq) & 0x00ff) |                             \
> -	 (((num) & 0x000f) << 8)) |                     \
> -	(((type) & 0x000f) << 12);                  }
> +#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) \
> +	((((seq) & 0x00ff) |                        \
> +	 (((num) & 0x000f) << 8)) |                 \
> +	(((type) & 0x000f) << 12))

Perhaps this would be better as a static inline

static inline u16 HostCmd_SET_SEQ_NO_BSS_INFO(u16 seq, u8 num, u8 type)
{
	return (type & 0x000f) << 12 | (num & 0x000f) << 8 | (seq & 0x00ff);
}


