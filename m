Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90B46DC35
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhLHTbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:31:24 -0500
Received: from www62.your-server.de ([213.133.104.62]:43510 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbhLHTbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:31:24 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mv2bS-000DvI-7x; Wed, 08 Dec 2021 20:27:46 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mv2bS-000BiC-0I; Wed, 08 Dec 2021 20:27:46 +0100
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
Date:   Wed, 8 Dec 2021 20:27:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26377/Wed Dec  8 10:23:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 9:30 AM, Martin KaFai Lau wrote:
> On Wed, Dec 08, 2021 at 12:18:46AM -0800, Martin KaFai Lau wrote:
>> On Tue, Dec 07, 2021 at 10:48:53PM +0100, Daniel Borkmann wrote:
[...]
>>> One other thing I wonder, BPF progs at host-facing veth's tc ingress which
>>> are not aware of skb->tstamp will then see a tstamp from future given we
>>> intentionally bypass the net_timestamp_check() and might get confused (or
>>> would confuse higher-layer application logic)? Not quite sure yet if they
>>> would be the only affected user.
>> Considering the variety of clock used in skb->tstamp (real/mono, and also
>> tai in SO_TXTIME),  in general I am not sure if the tc-bpf can assume anything
>> in the skb->tstamp now.

But today that's either only 0 or real via __net_timestamp() if skb->tstamp is
read at bpf@ingress@veth@host, no?

>> Also, there is only mono clock bpf_ktime_get helper, the most reasonable usage
>> now for tc-bpf is to set the EDT which is in mono.  This seems to be the
>> intention when the __sk_buff->tstamp was added.

Yep, fwiw, that's also how we only use it in our code base today.

>> For ingress, it is real clock now.  Other than simply printing it out,
>> it is hard to think of a good way to use the value.  Also, although
>> it is unlikely, net_timestamp_check() does not always stamp the skb.
> For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
> may be save the tx tstamp first and then temporarily restamp with __net_timestamp()
