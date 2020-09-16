Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA326CE81
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIPWR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgIPWR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:17:56 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE86C0611C2
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:41:11 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIfAm-0001Xn-Pz; Wed, 16 Sep 2020 23:41:04 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kIfAm-000FEK-Ji; Wed, 16 Sep 2020 23:41:04 +0200
Subject: Re: [PATCH bpf v5] xsk: do not discard packet when NETDEV_TX_BUSY
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     A.Zema@falconvsystems.com
References: <1600257625-2353-1-git-send-email-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <99ef1ffd-d6c4-d2fc-3883-ec5e1f2746d7@iogearbox.net>
Date:   Wed, 16 Sep 2020 23:41:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1600257625-2353-1-git-send-email-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25930/Tue Sep 15 15:55:28 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 2:00 PM, Magnus Karlsson wrote:
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

Hopefully patchwork/vger recovers soon, but looks good & I've applied
this one in meantime (also kept Jesse's prior Reviewed-by given there
were no fundamental changes). Thanks!
