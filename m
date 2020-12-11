Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713BB2D6C6A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393893AbgLKAPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:15:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:41344 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393878AbgLKAPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:15:48 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knW5S-0008M2-J5; Fri, 11 Dec 2020 01:15:06 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knW5S-000Bs4-Cq; Fri, 11 Dec 2020 01:15:06 +0100
Subject: Re: [PATCHv4 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201208081856.1627657-1-liuhangbin@gmail.com>
 <20201208120159.2278277-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fea564b7-8c6f-fa61-48e5-76eaaf9cbe91@iogearbox.net>
Date:   Fri, 11 Dec 2020 01:15:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201208120159.2278277-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 1:01 PM, Hangbin Liu wrote:
[...]
>   
> +static int get_mac_addr(unsigned int ifindex_out, void *mac_addr)
> +{
> +	struct ifreq ifr;
> +	char ifname[IF_NAMESIZE];
> +	int fd = socket(AF_INET, SOCK_DGRAM, 0);
> +
> +	if (fd < 0)
> +		return -1;
> +
> +	if (!if_indextoname(ifindex_out, ifname))
> +		return -1;
> +
> +	strcpy(ifr.ifr_name, ifname);
> +
> +	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
> +		return -1;
> +
> +	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
> +	close(fd);

Given we do bother to close the socket fd here, we should also close it in above
error cases..

> +	return 0;
> +}
> +
