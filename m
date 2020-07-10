Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C321BB15
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgGJQew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:34:52 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:42408 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgGJQew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:34:52 -0400
Received: (qmail 72068 invoked by uid 89); 10 Jul 2020 16:34:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 10 Jul 2020 16:34:50 -0000
Date:   Fri, 10 Jul 2020 09:34:48 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, A.Zema@falconvsystems.com
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb
 path
Message-ID: <20200710163448.7bkuohez2lqkf5tt@bsd-mbp>
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 08:45:54AM +0200, Magnus Karlsson wrote:
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> routines, it returns NETDEV_TX_BUSY signifying that it was not
> possible to send the packet now, please try later. Unfortunately, the
> xsk transmit code discarded the packet, missed to free the skb, and
> returned EBUSY to the application. Fix this memory leak and
> unnecessary packet loss, by not discarding the packet in the Tx ring,
> freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
> application, it can then retry the send operation and the packet will
> finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> state anymore. So EAGAIN tells the application that the packet was not
> discarded from the Tx ring and that it needs to call send()
> again. EBUSY, on the other hand, signifies that the packet was not
> sent and discarded from the Tx ring. The application needs to put the
> packet on the Tx ring again if it wants it to be sent.
> 
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

-- 
Jonathan
