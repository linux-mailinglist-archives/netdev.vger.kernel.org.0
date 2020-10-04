Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE05828277E
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgJDAAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgJDAAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:00:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E207C0613D0;
        Sat,  3 Oct 2020 17:00:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A4DE11E3E4CA;
        Sat,  3 Oct 2020 16:43:56 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:00:42 -0700 (PDT)
Message-Id: <20201003.170042.489590204097552946.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, tuba@ece.ufl.edu, kuba@kernel.org,
        oneukum@suse.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] net: hso: do not call unregister if not registered
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002114323.GA3296553@kroah.com>
References: <20201002114323.GA3296553@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:43:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 2 Oct 2020 13:43:23 +0200

> @@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
>  
>  	remove_net_device(hso_net->parent);
>  
> -	if (hso_net->net)
> +	if (hso_net->net &&
> +	    hso_net->net->reg_state == NETREG_REGISTERED)
>  		unregister_netdev(hso_net->net);
>  
>  	/* start freeing */

I really want to get out of the habit of drivers testing the internal
netdev registration state to make decisions.

Instead, please track this internally.  You know if you registered the
device or not, therefore use that to control whether you try to
unregister it or not.

Thank you.
