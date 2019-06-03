Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C43033939
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFCTnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:43:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFCTnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:43:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66D8414D06342;
        Mon,  3 Jun 2019 12:43:50 -0700 (PDT)
Date:   Mon, 03 Jun 2019 12:43:48 -0700 (PDT)
Message-Id: <20190603.124348.5212561789204100.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 2/4] s390/qeth: don't use obsolete dst entry
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603150446.23351-3-jwi@linux.ibm.com>
References: <20190603150446.23351-1-jwi@linux.ibm.com>
        <20190603150446.23351-3-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 12:43:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon,  3 Jun 2019 17:04:44 +0200

> While qeth_l3 uses netif_keep_dst() to hold onto the dst, a skb's dst
> may still have been obsoleted (via dst_dev_put()) by the time that we
> end up using it. The dst then points to the loopback interface, which
> means the neighbour lookup in qeth_l3_get_cast_type() determines a bogus
> cast type of RTN_BROADCAST.
> For IQD interfaces this causes us to place such skbs on the wrong
> HW queue, resulting in TX errors.
> 
> Fix-up the various call sites to check whether the dst is obsolete, and
> fall back accordingly.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Please use "dst_check()".

Some routes have DST_OBSOLETE_FORCE_CHK set on them from the very beginning
so that uses of the route are forced through the dst->ops->check() method.

Simply use dst_check() and then you can just retain the 'rt == NULL' logic
as-is.

Thanks.
