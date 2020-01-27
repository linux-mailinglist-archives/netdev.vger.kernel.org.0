Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEFB14A57E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgA0Nzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:55:45 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:35555 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgA0Nzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 08:55:44 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id db128c43;
        Mon, 27 Jan 2020 12:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=subject:to
        :references:cc:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=mail; bh=ArqOCsDWLo86
        RSROZ1yr2u8pHqI=; b=niY/iiq1tyvHv886WS4cNYRfd5uWQgnr6Ol5xSaEN14i
        g/qGZ+nzx4jabJCxm1cb0VikeKLn7lAgWKEdld/RpRodCjsCVUdcKuEenmRXT9UR
        8wfPrflekaBUgRzj9fvnI9/cK8gaN/j82SwIZJWbmcbwjEW08AXeJXWqIkk7A/+s
        Q6F4RDK6jBiwqu+1oOTbB+84Q9bHFF4kk/pQhq3mwceNG8KasR1mcI9CdWX9EwLp
        CdlDROMIAlS8i7Kkb8/t9zETwKRQIlMK7vrhAl0BHjjyO0weHaDcBfNJ+e1gk5Ju
        0E10Y7gPFy3ayC/KGc6Q6LxyNCrLHRfVt9iK4s+3PQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3220f807 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 27 Jan 2020 12:53:58 +0000 (UTC)
Subject: Re: [PATCH] Revert "pktgen: Allow configuration of IPv6 source
 address range"
To:     niu_xilei@163.com
References: <20200127.135104.544840622177386473.davem@davemloft.net>
Cc:     netdev@vger.kernel.org
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Message-ID: <e64d45cb-62e8-70e3-2231-0138b3b7b740@zx2c4.com>
Date:   Mon, 27 Jan 2020 14:55:40 +0100
MIME-Version: 1.0
In-Reply-To: <20200127.135104.544840622177386473.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 1:51 PM, David Miller wrote:
>>> pktgen.c:(.text.mod_cur_headers+0xba0): undefined reference to `__umoddi3'

I assume this is caused by:

> -			prandom_bytes(&rand, sizeof(rand));
> -			rand = rand % (max6 - min6) + min6;

Rather than open coding the prandom range selection, it might be useful 
to grep the tree and see if there's a general use for prandom_range_u32 
and prandom_range_u64 or the like. If there's not, you can probably 
replace the % with a call to div64_u64_rem.
