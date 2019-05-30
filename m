Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FEE302D2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE3TdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:33:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3TdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:33:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A9DC14DA817B;
        Thu, 30 May 2019 12:33:06 -0700 (PDT)
Date:   Thu, 30 May 2019 12:33:05 -0700 (PDT)
Message-Id: <20190530.123305.679690617064301115.davem@davemloft.net>
To:     92siuyang@gmail.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: tcp_input: fix stack out of bounds when parsing
 TCP options.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559117459-27353-1-git-send-email-92siuyang@gmail.com>
References: <1559117459-27353-1-git-send-email-92siuyang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:33:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>
Date: Wed, 29 May 2019 16:10:59 +0800

> The TCP option parsing routines in tcp_parse_options function could
> read one byte out of the buffer of the TCP options.
> 
> 1         while (length > 0) {
> 2                 int opcode = *ptr++;
> 3                 int opsize;
> 4
> 5                 switch (opcode) {
> 6                 case TCPOPT_EOL:
> 7                         return;
> 8                 case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
> 9                         length--;
> 10                        continue;
> 11                default:
> 12                        opsize = *ptr++; //out of bound access
> 
> If length = 1, then there is an access in line2.
> And another access is occurred in line 12.
> This would lead to out-of-bound access.
> 
> Therefore, in the patch we check that the available data length is
> larger enough to pase both TCP option code and size.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>

Applied.
