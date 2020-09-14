Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704B226922B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgINQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:53:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:1674 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgINQwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:52:42 -0400
IronPort-SDR: a45oKmwDeLqaPP/HHTHd1Afy1//r0sPpju0+iCB/p50wc149VO+Ku1zacOVRoOADpuz7ZUkiB5
 oPS73/UTaGHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="243944276"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="243944276"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:52:40 -0700
IronPort-SDR: mem3XDgKAwvDj8FehdUopqpxZXCPCEN5iV7jynpbaIPtpVLo33GmO366ucEInTg/KekFpH3cQm
 4cdOnLxMz+cQ==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="450952497"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.55.36])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:52:40 -0700
Date:   Mon, 14 Sep 2020 09:52:39 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, A.Zema@falconvsystems.com
Subject: Re: [PATCH bpf v4] xsk: do not discard packet when NETDEV_TX_BUSY
Message-ID: <20200914095239.0000254b@intel.com>
In-Reply-To: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com>
References: <1599828221-19364-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> In the skb Tx path, transmission of a packet is performed with
> dev_direct_xmit(). When NETDEV_TX_BUSY is set in the drivers, it
> signifies that it was not possible to send the packet right now,
> please try later. Unfortunately, the xsk transmit code discarded the
> packet and returned EBUSY to the application. Fix this unnecessary
> packet loss, by not discarding the packet in the Tx ring and return
> EAGAIN. As EAGAIN is returned to the application, it can then retry
> the send operation later and the packet will then likely be sent as
> the driver will then likely have space/resources to send the packet.
> 
> In summary, EAGAIN tells the application that the packet was not
> discarded from the Tx ring and that it needs to call send()
> again. EBUSY, on the other hand, signifies that the packet was not
> sent and discarded from the Tx ring. The application needs to put the
> packet on the Tx ring again if it wants it to be sent.
> 
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>

Patch seems to make sense to me, better matches the expectations/path
of the stack.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
