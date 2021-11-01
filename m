Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9727A441CC8
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhKAOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:44:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:34526 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhKAOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:44:05 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhYV2-0008yP-Ky; Mon, 01 Nov 2021 15:41:24 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhYV2-000Mkz-Eq; Mon, 01 Nov 2021 15:41:24 +0100
Subject: Re: bpf redirect will loop the packets
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, ast@kernel.org,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <CAMDZJNUNdGNh6TQchcGbfC6ur9C7KZ4Ci8Yj4_=gj7OAvZCytg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2ff91572-443c-dea6-ebed-10bc99d080bc@iogearbox.net>
Date:   Mon, 1 Nov 2021 15:41:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMDZJNUNdGNh6TQchcGbfC6ur9C7KZ4Ci8Yj4_=gj7OAvZCytg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 7:32 AM, Tonghao Zhang wrote:
> Hi
> I found the issue,
> if we use the bpf_redirect to the same netdevice in the ingress path.
> the packet loop.
> and now linux doesn't check that. In tx path,
> softnet_data.xmit.recursion will limit the recursion.
> I think we should check that in ingress. any thoughts?

Nope, since this is xmit, not receive. This goes through a rescheduling
point and could end up on a different CPU potentially. This is not any
different in than how other infra handles this case. Point here is that
it's not freezing the box, so admin can react to misconfig and then undo
it again.
