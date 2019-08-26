Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2329D7D5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfHZUzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:55:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHZUzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:55:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D3F014FC802C;
        Mon, 26 Aug 2019 13:55:52 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:55:49 -0700 (PDT)
Message-Id: <20190826.135549.1075785443210666224.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     jslaby@suse.cz, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] Revert "r8152: napi hangup fix after
 disconnect"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D6733@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-318-Taiwan-albertk@realtek.com>
        <1f707377-7b61-4ba1-62bf-f275d0360749@suse.cz>
        <0835B3720019904CB8F7AA43166CEEB2F18D6733@RTITMBSVM03.realtek.com.tw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 13:55:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 26 Aug 2019 09:43:32 +0000

> Jiri Slaby [mailto:jslaby@suse.cz]
>> Sent: Monday, August 26, 2019 4:55 PM
> [...]
>> Could you clarify *why* it conflicts? And how is the problem fixed by
>> 0ee1f473496 avoided now?
> 
> In rtl8152_disconnect(), the flow would be as following.
> 
> static void rtl8152_disconnect(struct usb_interface *intf)
> {
> 	...
> 	- netif_napi_del(&tp->napi);
> 	- unregister_netdev(tp->netdev);
> 	   - rtl8152_close
> 	      - napi_disable
> 
> Therefore you add a checking of RTL8152_UNPLUG to avoid
> calling napi_disable() after netif_napi_del(). However,
> after commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG
> only for real disconnection"), RTL8152_UNPLUG is not
> always set when calling rtl8152_disconnect(). That is,
> napi_disable() would be called after netif_napi_del(),
> if RTL8152_UNPLUG is not set.
> 
> The best way is to avoid calling netif_napi_del() before
> calling unregister_netdev(). And I has submitted such
> patch following this one.

These details belong in the commit message, always.
