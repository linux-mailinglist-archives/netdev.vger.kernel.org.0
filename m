Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC813786
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfEDEo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:44:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfEDEo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:44:58 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 205E314D91286;
        Fri,  3 May 2019 21:44:52 -0700 (PDT)
Date:   Sat, 04 May 2019 00:44:49 -0400 (EDT)
Message-Id: <20190504.004449.945185836330139212.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tipc: Avoid copying bytes beyond the supplied data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502031004.7125-1-chris.packham@alliedtelesis.co.nz>
References: <20190502031004.7125-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:44:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Thu,  2 May 2019 15:10:04 +1200

> TLV_SET is called with a data pointer and a len parameter that tells us
> how many bytes are pointed to by data. When invoking memcpy() we need
> to careful to only copy len bytes.
> 
> Previously we would copy TLV_LENGTH(len) bytes which would copy an extra
> 4 bytes past the end of the data pointer which newer GCC versions
> complain about.
> 
>  In file included from test.c:17:
>  In function 'TLV_SET',
>      inlined from 'test' at test.c:186:5:
>  /usr/include/linux/tipc_config.h:317:3:
>  warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]
>  of object 'bearer_name' with type 'char[32]' [-Warray-bounds]
>      memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  test.c: In function 'test':
>  test.c::161:10: note:
>  'bearer_name' declared here
>      char bearer_name[TIPC_MAX_BEARER_NAME];
>           ^~~~~~~~~~~
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

But now the pad bytes at the end are uninitialized.

The whole idea is that the encapsulating TLV object has to be rounded
up in size based upon the given 'len' for the data.
