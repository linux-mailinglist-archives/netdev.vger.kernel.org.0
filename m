Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7542A40FD
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfH3XXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:23:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:58788 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfH3XXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:23:17 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qEd-0004H0-5Y; Sat, 31 Aug 2019 01:23:15 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3qEc-000KTa-Um; Sat, 31 Aug 2019 01:23:15 +0200
Subject: Re: [PATCH bpf-next 0/2] nfp: bpf: add simple map op cache
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        alexei.starovoitov@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jaco.gericke@netronome.com
References: <20190828053629.28658-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <054e3384-c36a-5338-2de2-4dd92ba9e9fc@iogearbox.net>
Date:   Sat, 31 Aug 2019 01:23:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828053629.28658-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25557/Fri Aug 30 10:30:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/19 7:36 AM, Jakub Kicinski wrote:
> Hi!
> 
> This set adds a small batching and cache mechanism to the driver.
> Map dumps require two operations per element - get next, and
> lookup. Each of those needs a round trip to the device, and on
> a loaded system scheduling out and in of the dumping process.
> This set makes the driver request a number of entries at the same
> time, and if no operation which would modify the map happens
> from the host side those entries are used to serve lookup
> requests for up to 250us, at which point they are considered
> stale.
> 
> This set has been measured to provide almost 4x dumping speed
> improvement, Jaco says:
> 
> OLD dump times
>      500 000 elements: 26.1s
>        1 000 000 elements: 54.5s
> 
> NEW dump times
>      500 000 elements: 7.6s
>        1 000 000 elements: 16.5s
> 
> Jakub Kicinski (2):
>    nfp: bpf: rework MTU checking
>    nfp: bpf: add simple map op cache
> 
>   drivers/net/ethernet/netronome/nfp/bpf/cmsg.c | 187 ++++++++++++++++--
>   drivers/net/ethernet/netronome/nfp/bpf/fw.h   |   1 +
>   drivers/net/ethernet/netronome/nfp/bpf/main.c |  33 ++++
>   drivers/net/ethernet/netronome/nfp/bpf/main.h |  24 +++
>   .../net/ethernet/netronome/nfp/bpf/offload.c  |   3 +
>   drivers/net/ethernet/netronome/nfp/nfp_net.h  |   2 +-
>   .../ethernet/netronome/nfp/nfp_net_common.c   |   9 +-
>   7 files changed, 239 insertions(+), 20 deletions(-)

Applied, thanks!
