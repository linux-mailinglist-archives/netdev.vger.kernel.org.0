Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DC92870A1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgJHIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:25:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:40052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgJHIZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:25:56 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQRFI-00067e-Lk; Thu, 08 Oct 2020 10:25:52 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQRFI-00063H-Bo; Thu, 08 Oct 2020 10:25:52 +0200
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208778070.798237.16265441131909465819.stgit@firesoul>
 <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
 <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
 <CANP3RGdcqmcrxWDKPsZ8A0+qK1hzD0tZvRFsVMPvSCNDk+LrHA@mail.gmail.com>
 <5f7e854b111fc_2acac2087e@john-XPS-13-9370.notmuch>
 <20201008100723.33e14dca@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <11b7e250-038d-5057-1d05-77e36c633a36@iogearbox.net>
Date:   Thu, 8 Oct 2020 10:25:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201008100723.33e14dca@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25950/Wed Oct  7 15:55:10 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 10:07 AM, Jesper Dangaard Brouer wrote:
[...]
>>> However, due to both gso and vlan offload, even this is not trivial to do...
>>> The mtu is L3, but drivers/hardware/the wire usually care about L2...
> 
> If net_device->mtu is L3 (1500) and XDP (and TC, right?) operate at L2,
> that likely means that the "strict" bpf_mtu_check (in my BPF-helper) is
> wrong, as XDP (and TC) length at this point include the 14 bytes
> Ethernet header.  I will check and fix.

Yes, both at L2 layer.

> Is this accounted for via net_device->hard_header_len ?

It is, see also ether_setup().
