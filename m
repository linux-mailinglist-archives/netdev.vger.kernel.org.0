Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F677396DA1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhFAG7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:59:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:49178 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAG7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:59:24 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lnyLK-0008hf-AT; Tue, 01 Jun 2021 08:57:38 +0200
Received: from [85.7.101.30] (helo=linux-2.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lnyLK-000OlJ-1v; Tue, 01 Jun 2021 08:57:38 +0200
Subject: Re: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     robin.murphy@arm.com, jroedel@suse.de
Cc:     Jussi Maki <joamaki@gmail.com>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, intel-wired-lan@lists.osuosl.org,
        davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, hch@lst.de,
        iommu@lists.linux-foundation.org, suravee.suthikulpanit@amd.com
References: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cc58c09e-bbb5-354a-2030-bf8ebb2adc86@iogearbox.net>
Date:   Tue, 1 Jun 2021 08:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26187/Mon May 31 13:15:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ ping Robin / Joerg, +Cc Christoph ]

On 5/28/21 10:34 AM, Jussi Maki wrote:
> Hi all,
> 
> While measuring the impact of a kernel patch on our lab machines I stumbled upon
> a performance regression affecting the 100Gbit ICE nic and bisected it
> from range v5.11.1..v5.13-rc3 to the commit:
> a250c23f15c2 iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
> 
> Both recent bpf-next (d6a6a55518) and linux-stable (c4681547bc) are
> affected by the issue.
> 
> The regression shows as a significant drop in throughput as measured
> with "super_netperf" [0],
> with measured bandwidth of ~95Gbps before and ~35Gbps after:
> 
> commit 3189713a1b84 (a250c23^):
> $ ./super_netperf 32 -H 172.18.0.2 -l 10
> 97379.8
> 
> commit a250c23f15c2:
> $ ./super_netperf 32 -H 172.18.0.2 -l 10
> 34097.5
> 
> The pair of test machines have this hardware:
> CPU: AMD Ryzen 9 3950X 16-Core Processor
> MB: X570 AORUS MASTER
> 0a:00.0 Ethernet controller [0200]: Intel Corporation Ethernet
> Controller E810-C for QSFP [8086:1592] (rev 02)
> Kernel config: https://gist.github.com/joamaki/9ee11294c78a8dd2776041f67e5620e7
> 
> [0] https://github.com/borkmann/stuff/blob/master/super_netperf
> 

