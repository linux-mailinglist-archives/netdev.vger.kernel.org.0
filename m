Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A3410A756
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 01:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfK0AIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 19:08:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:33078 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfK0AIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 19:08:05 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZks8-0005dw-4Y; Wed, 27 Nov 2019 01:07:56 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZks7-000D2r-QY; Wed, 27 Nov 2019 01:07:55 +0100
Subject: Re: [PATCH bpf-next] bpf: fix static checker warning
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     dan.carpenter@oracle.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20191126230106.237179-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bd0bc378-5ff8-dd80-7b07-6c946f3eaedf@iogearbox.net>
Date:   Wed, 27 Nov 2019 01:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191126230106.237179-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25645/Tue Nov 26 10:51:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/19 12:01 AM, Alexei Starovoitov wrote:
> kernel/bpf/btf.c:4023 btf_distill_func_proto()
>          error: potentially dereferencing uninitialized 't'.
> 
> kernel/bpf/btf.c
>    4012          nargs = btf_type_vlen(func);
>    4013          if (nargs >= MAX_BPF_FUNC_ARGS) {
>    4014                  bpf_log(log,
>    4015                          "The function %s has %d arguments. Too many.\n",
>    4016                          tname, nargs);
>    4017                  return -EINVAL;
>    4018          }
>    4019          ret = __get_type_size(btf, func->type, &t);
>                                                         ^^
> t isn't initialized for the first -EINVAL return
> 
> This is unlikely path, since BTF should have been validated at this point.
> Fix it by returning 'void' BTF.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
