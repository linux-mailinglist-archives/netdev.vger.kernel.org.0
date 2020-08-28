Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1132554EF
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 09:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgH1HON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 03:14:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:44910 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgH1HOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 03:14:12 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBYaH-0007Cj-BL; Fri, 28 Aug 2020 09:14:01 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBYaH-000QBW-2T; Fri, 28 Aug 2020 09:14:01 +0200
Subject: Re: [PATCH nf-next v3 0/3] Netfilter egress hook
To:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <cover.1598517739.git.lukas@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <454130d7-7256-838d-515e-c7340892278c@iogearbox.net>
Date:   Fri, 28 Aug 2020 09:14:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1598517739.git.lukas@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25912/Thu Aug 27 15:16:21 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 8/27/20 10:55 AM, Lukas Wunner wrote:
> Introduce a netfilter egress hook to allow filtering outbound AF_PACKETs
> such as DHCP and to prepare for in-kernel NAT64/NAT46.

Thinking more about this, how will this allow to sufficiently filter AF_PACKET?
It won't. Any AF_PACKET application can freely set PACKET_QDISC_BYPASS without
additional privileges and then dev_queue_xmit() is being bypassed in the host ns.
This is therefore ineffective and not sufficient. (From container side these can
be caught w/ host veth on ingress, but not in host ns, of course, so hook won't
be invoked.)

Thanks,
Daniel
