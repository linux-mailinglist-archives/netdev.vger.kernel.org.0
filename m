Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7B146D48
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWPs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:48:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:35474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWPs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:48:57 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iueiu-0001kT-QX; Thu, 23 Jan 2020 16:48:48 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iueiu-0008pC-I4; Thu, 23 Jan 2020 16:48:48 +0100
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb
 linearization
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
References: <20200122203253.20652-1-lrizzo@google.com>
 <875zh2bis0.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net>
Date:   Thu, 23 Jan 2020 16:48:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <875zh2bis0.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 10:53 AM, Toke Høiland-Jørgensen wrote:
> Luigi Rizzo <lrizzo@google.com> writes:
> 
>> Add a netdevice flag to control skb linearization in generic xdp mode.
>> Among the various mechanism to control the flag, the sysfs
>> interface seems sufficiently simple and self-contained.
>> The attribute can be modified through
>> 	/sys/class/net/<DEVICE>/xdp_linearize
>> The default is 1 (on)

Needs documentation in Documentation/ABI/testing/sysfs-class-net.

> Erm, won't turning off linearization break the XDP program's ability to
> do direct packet access?

Yes, in the worst case you only have eth header pulled into linear section. :/
In tc/BPF for direct packet access we have bpf_skb_pull_data() helper which can
pull in up to X bytes into linear section on demand. I guess something like this
could be done for XDP context as well, e.g. generic XDP would pull when non-linear
and native XDP would have nothing todo (though in this case you end up writing the
prog specifically for generic XDP with slowdown when you'd load it on native XDP
where it's linear anyway, but that could/should be documented if so).

Thanks,
Daniel
