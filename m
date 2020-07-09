Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEAB21A89E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgGIUIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:08:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:49868 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIUIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:08:01 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtcps-0001CD-8M; Thu, 09 Jul 2020 22:08:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtcpr-000OIV-Vb; Thu, 09 Jul 2020 22:08:00 +0200
Subject: Re: [PATCH v2 bpf 1/2] bpf: net: Avoid copying sk_user_data of
 reuseport_array during sk_clone
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200709061057.4018499-1-kafai@fb.com>
 <20200709061104.4018798-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7535d0e3-e442-8611-3c35-cbc9f4cace8c@iogearbox.net>
Date:   Thu, 9 Jul 2020 22:07:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709061104.4018798-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 8:11 AM, Martin KaFai Lau wrote:
> It makes little sense for copying sk_user_data of reuseport_array during
> sk_clone_lock().  This patch reuses the SK_USER_DATA_NOCOPY bit introduced in
> commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if tagged").
> It is used to mark the sk_user_data is not supposed to be copied to its clone.
> 
> Although the cloned sk's sk_user_data will not be used/freed in
> bpf_sk_reuseport_detach(), this change can still allow the cloned
> sk's sk_user_data to be used by some other means.
> 
> Freeing the reuseport_array's sk_user_data does not require a rcu grace
> period.  Thus, the existing rcu_assign_sk_user_data_nocopy() is not
> used.

nit: Would have been nice though to add a nonrcu API for this nevertheless
instead of open coding.

> Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
