Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E7C3B9F30
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhGBKo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 06:44:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57661 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhGBKoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:44:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lzGck-00012b-9Z; Fri, 02 Jul 2021 10:42:18 +0000
To:     Jes Sorensen <jes@trained-monkey.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "open list:HIPPI" <linux-hippi@sunsite.dk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: hippi: incorrect address masking and compare operation
Message-ID: <8931251f-b24a-5043-3bdd-f6ea810759f3@canonical.com>
Date:   Fri, 2 Jul 2021 11:42:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity has detected an issue in
drivers/net/hippi/rrunner.c where a masking operation and a comparison
is always false.

The analysis is as follows:

656                /*
657                 * Sanity test to see if we conflict with the DMA
658                 * limitations of the Roadrunner.
659                 */

Operands don't affect result (CONSTANT_EXPRESSION_RESULT)
dead_error_condition: The condition ((unsigned long)skb->data & 0xfffUL)
> 18446744073709486295UL cannot be true.

660                if ((((unsigned long)skb->data) & 0xfff) > ~65320)

Logically dead code (DEADCODE)dead_error_line: Execution cannot reach
this statement: printk("skb alloc error\n");.

661                        printk("skb alloc error\n");
662

I suspect the masking 0xfff is incorrect here, I think it be ~0xfff but
I'm not 100% sure.

Colin
