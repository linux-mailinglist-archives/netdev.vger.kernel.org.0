Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7163156D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfEaTfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:35:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49250 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbfEaTfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:35:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1C28150047EF;
        Fri, 31 May 2019 12:35:01 -0700 (PDT)
Date:   Fri, 31 May 2019 12:35:01 -0700 (PDT)
Message-Id: <20190531.123501.1735974141603189601.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, tom@quantonium.net
Subject: Re: [PATCH net-next] ipv6: Send ICMP errors for exceeding
 extension header limits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559086362-2470-1-git-send-email-tom@quantonium.net>
References: <1559086362-2470-1-git-send-email-tom@quantonium.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 12:35:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Tue, 28 May 2019 16:32:42 -0700

> @@ -156,8 +159,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  			 * See also RFC 4942, Section 2.1.9.5.
>  			 */
>  			padlen += optlen;
> -			if (padlen > 7)
> +			if (padlen > 7) {
> +				icmpv6_send(skb, ICMPV6_PARAMPROB,
> +					    ICMPV6_TOOBIG_OPTION, off);
>  				goto bad;
> +			}

So much inconsistency.  You're sending the parameter problem here
but you're not for the following code that verifies that the padding
contains only zeros.

Either emit the parameter problem for all bad TLV padding or for none.
