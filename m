Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9E3326AA9
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhB0AKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:10:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:49782 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0AKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:10:10 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFnAl-0006nY-4Z; Sat, 27 Feb 2021 01:09:27 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFnAk-000LzA-T4; Sat, 27 Feb 2021 01:09:26 +0100
Subject: Re: [PATCH bpf-next] bpf: devmap: move drop error path to devmap for
 XDP_REDIRECT
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, lorenzo.bianconi@redhat.com, brouer@redhat.com,
        toke@redhat.com, freysteinn.alfredsson@kau.se
References: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c3b56d02-e415-b6e9-2c22-9c3d341e07e9@iogearbox.net>
Date:   Sat, 27 Feb 2021 01:09:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 2:56 PM, Lorenzo Bianconi wrote:
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc

I presume for a number of these drivers the refactoring changes were just compile-
tested due to lack of HW, right? If so, please also Cc related driver maintainers
aside from the few of us, so they have a chance to review & ACK the patch if it looks
good to them. I presume Ed saw it by accident, but for others it might easily get
lost in the daily mail flood.

> More details about the new ndo_xdp_xmit design can be found here [0].
> 
> [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org

I'd probably move this below the "---" if it's not essential to the commit itself or
rather take relevant parts out and move it into the commit desc so it doesn't get
lost for future ref given things could likely reschuffle inside the repo in the future,
just a nit.

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
