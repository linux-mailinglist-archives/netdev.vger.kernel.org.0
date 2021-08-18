Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F63F00C4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhHRJmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:42:11 -0400
Received: from mail003.nap.gsic.titech.ac.jp ([131.112.13.103]:33790 "HELO
        mail003.nap.gsic.titech.ac.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S231229AbhHRJmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:42:11 -0400
Received: from 172.22.40.204
        by mail003.nap.gsic.titech.ac.jp with Mail2000 ESMTP Server V7.00(2590:0:AUTH_RELAY)
        (envelope-from <matsumoto.r.aa@m.titech.ac.jp>); Wed, 18 Aug 2021 18:41:11 +0900 (JST)
Received: from mail001.nap.gsic.titech.ac.jp (mail001.nap.gsic.titech.ac.jp [131.112.13.101])
        by drweb07.nap.gsic.titech.ac.jp (Postfix) with SMTP id B623C4D62;
        Wed, 18 Aug 2021 18:41:11 +0900 (JST)
Received: from 153.240.174.134
        by mail001.nap.gsic.titech.ac.jp with Mail2000 ESMTPA Server V7.00(21091:0:AUTH_LOGIN)
        (envelope-from <matsumoto.r.aa@m.titech.ac.jp>); Wed, 18 Aug 2021 18:41:11 +0900 (JST)
Date:   Wed, 18 Aug 2021 18:41:09 +0900 (JST)
Message-Id: <20210818.184109.580170563027962616.ryutaroh@ict.e.titech.ac.jp>
To:     arend.vanspriel@broadcom.com
Cc:     aspriel@gmail.com, linux-rpi-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: 5.10.58 UBSAN from brcmf_sdio_dpc+0xa50/0x128c [brcmfmac]
From:   Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
In-Reply-To: <56ea3e65-62f4-2496-edd4-e454126abc66@broadcom.com>
References: <20210817.093658.33467107987117119.ryutaroh@ict.e.titech.ac.jp>
        <17b52a1ab20.279b.9696ff82abe5fb6502268bdc3b0467d4@gmail.com>
        <56ea3e65-62f4-2496-edd4-e454126abc66@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arend, sorry for my late response, partly because compilation takes 10 hours
on RPi4B...
I did the same thing with version 5.10.59 and CLang 11 and got the same
UBSAN. 

>> If you enable CONFIG_DEBUG_INFO in your kernel .config and recompile
>> brcmfmac you can load the module in gdb:
>> gdb> add-symbol-file brcmfmac.ko [address]
>> gdb> l *brcmf_sdio_dpc+0xa50
>> The [address] is not very important so just fill in a nice value. The
>> 'l' command should provide the line number.
> 
> Hi Ryutaroh,
> 
> Meanwhile I did some digging in the brcmfmac driver and I think I
> found the location in brcmf_sdio_sendfromq() where we do a
> __skb_queue_tail(). So I looked at that and it does following:
> 
> static inline void __skb_queue_tail(struct sk_buff_head *list,
> 				   struct sk_buff *newsk)
> {
> 	__skb_queue_before(list, (struct sk_buff *)list, newsk);
> }
> 
> Your report seems to be coming from the cast that is done here, which
> is fine as long as sk_buff and sk_buff_head have the same members
> 'next' and 'prev' at the start, which is true today and hopefully
> forever ;-) I am inclined to say this is a false report.
> 
> Can you please confirm the stack trace indeed points to
> brcmf_sdio_sendfromq() in your report.

Summary: I confirm that the stack trace indeed points to
brcmf_sdio_sendfromq(). The detail follows (you don't have to read it if
you believe in me :-)
If kernel version 5.10.x or 5.13.x is compiled with gcc 10, I have never seen
UBSAN. I wonder if CLang 11/12 tends to generate falsely positive UBSAN.

(gdb) add-symbol-file  drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko 0x0
add symbol table from file "drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko" at
	.text_addr = 0x0
(y or n) y

(gdb)  l *brcmf_sdio_dpc+0xa50
warning: Could not find DWO CU drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.dwo(0x79060145b4b45807) referenced by CU at offset 0x394 [in module /usr/lib/debug/lib/modules/5.10.59-clang11debug/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko]
0x277a4 is at ./include/linux/skbuff.h:2016.
2011	./include/linux/skbuff.h: No such file or directory.

Line 2016 of skbuff.h is __skb_insert in the next inline function:
static inline void __skb_queue_before(struct sk_buff_head *list,
                                      struct sk_buff *next,
                                      struct sk_buff *newsk)
{
        __skb_insert(newsk, next->prev, next, list);
}

Then:
(gdb) l *brcmf_sdio_dpc+0xa43
0x27797 is at drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:2346.
2341	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: No such file or directory.

The line 2346 is in the function brcmf_sdio_sendfromq().

Best regards, Ryutaroh
