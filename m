Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24D818A95F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCRXmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:42:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRXmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:42:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8937155371F0;
        Wed, 18 Mar 2020 16:42:34 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:42:34 -0700 (PDT)
Message-Id: <20200318.164234.1141226942122598740.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: vlan: include stats in dumps if
 requested
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318130325.100508-1-nikolay@cumulusnetworks.com>
References: <20200318130325.100508-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:42:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Wed, 18 Mar 2020 15:03:25 +0200

> @@ -170,11 +170,13 @@ struct bridge_stp_xstats {
>  /* Bridge vlan RTM header */
>  struct br_vlan_msg {
>  	__u8 family;
> -	__u8 reserved1;
> +	__u8 flags;
>  	__u16 reserved2;
>  	__u32 ifindex;
>  };

I can't allow this for two reasons:

1) Userspace explicitly initializing all members will now get a compile
   failure on the reference to ->reserved1

2) Userspace not initiailizing reserved fields, which worked previously,
   might send in flags that trigger the new behavior.

Sorry, this is UAPI breakage.
