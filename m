Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE873EA71F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhHLPIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbhHLPIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:08:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4E5C061756;
        Thu, 12 Aug 2021 08:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=eN3wS4NPQ+0ZFBEIpVI8O9zoIsAy3xS+n1CvARmrDc8=; b=VJEkOV8eMr1/51GuHzFxyEqWiz
        cb5PQMya3BV23rJGt2LaWdNA1ufn+A3mad0g/E6Dxiqd/jvHDKXTHLHOHwlgZVYBL9d17n9L41OOv
        qkSQh61wCsCCfi+898+DR4Z8oswNbL4jMm5bocq5t3qaq9lagsBW8zis+yp3KOteGg2l0wS8yDovw
        tqawTusMHpMfghKQhcYc5Q08eT8kK/w10fhptq8lVyqhPp4SEgRg9Fleg9MpkclaTGjS4BuLbvGEy
        OA1cP9Z3n3qtKSOsG16VG9r2u8apdvHjyP48JB2x1Cm1x7VjAMwUEzCfCrrmBXsrmuq8LFFhfeZRA
        Op78CPAQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mECJ6-00AWKV-Om; Thu, 12 Aug 2021 15:07:44 +0000
Subject: Re: signed integer overflow in atomic.h
To:     Steve French <smfrench@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <CAH2r5msrRdGmFGht+rN7_UgkmrpT8eaAoQ46EyLvxhm7M-fKmg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <69c2a565-c3e4-3127-9203-1179609a07d7@infradead.org>
Date:   Thu, 12 Aug 2021 08:07:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5msrRdGmFGht+rN7_UgkmrpT8eaAoQ46EyLvxhm7M-fKmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 10:41 PM, Steve French wrote:
> ===============
> [   28.345189] UBSAN: signed-integer-overflow in
> ./arch/x86/include/asm/atomic.h:165:11
> [   28.345196] 484501395 + 2024361625 cannot be represented in type 'int'
> [   28.345202] CPU: 6 PID: 987 Comm: nmbd Not tainted 5.11.22 #1
> [   28.345208] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   28.345212] Call Trace:
> [   28.345218]  dump_stack+0x8d/0xb5
> [   28.345233]  ubsan_epilogue+0x5/0x50
> [   28.345242]  handle_overflow+0xa3/0xb0
> [   28.345257]  ? rcu_read_lock_sched_held+0x39/0x80
> [   28.345270]  ip_idents_reserve+0x8d/0xb0
> [   28.345283]  __ip_select_ident+0x3f/0x70
> [   28.345292]  __ip_make_skb+0x279/0x450
> [   28.345302]  ? ip_reply_glue_bits+0x40/0x40
> [   28.345314]  ip_make_skb+0x10d/0x130
> [   28.345326]  ? ip_route_output_key_hash+0xee/0x190
> [   28.345344]  udp_sendmsg+0x79b/0x13b0
> [   28.345365]  ? ip_reply_glue_bits+0x40/0x40
> [   28.345403]  ? find_held_lock+0x29/0xb0
> [   28.345420]  ? sock_sendmsg+0x54/0x60
> [   28.345426]  sock_sendmsg+0x54/0x60

from net/ipv4/route.c:

	/* If UBSAN reports an error there, please make sure your compiler
	 * supports -fno-strict-overflow before reporting it that was a bug
	 * in UBSAN, and it has been fixed in GCC-8.
	 */
	return atomic_add_return(segs + delta, p_id) - segs;


-- 
~Randy

