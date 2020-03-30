Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF54197397
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgC3Eyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:54:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3Eyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:54:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F16E15C55025;
        Sun, 29 Mar 2020 21:54:48 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:54:47 -0700 (PDT)
Message-Id: <20200329.215447.1115916361616257904.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net] udp: fix a skb extensions leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:54:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Mar 2020 17:06:25 +0800

> On udp rx path udp_rcv_segment() may do segment where the frag skbs
> will get the header copied from the head skb in skb_segment_list()
> by calling __copy_skb_header(), which could overwrite the frag skbs'
> extensions by __skb_ext_copy() and cause a leak.
> 
> This issue was found after loading esp_offload where a sec path ext
> is set in the skb.
> 
> On udp tx gso path, it works well as the frag skbs' extensions are
> not set. So this issue should be fixed on udp's rx path only and
> release the frag skbs' extensions before going to do segment.
> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Steffen, please review.
