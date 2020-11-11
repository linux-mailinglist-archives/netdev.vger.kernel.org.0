Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D02AEF92
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKKL0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:26:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:50048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgKKL0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:26:38 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcoGk-0008A2-ME; Wed, 11 Nov 2020 12:26:30 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcoGk-000GRu-CT; Wed, 11 Nov 2020 12:26:30 +0100
Subject: Re: [PATCHv6 bpf] bpf: Move iterator functions into special init
 section
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20201110154017.482352-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2a71a0b4-b5de-e9fb-bacc-3636e16245c5@iogearbox.net>
Date:   Wed, 11 Nov 2020 12:26:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201110154017.482352-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25984/Tue Nov 10 14:18:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 4:40 PM, Jiri Olsa wrote:
> With upcoming changes to pahole, that change the way how and
> which kernel functions are stored in BTF data, we need a way
> to recognize iterator functions.
> 
> Iterator functions need to be in BTF data, but have no real
> body and are currently placed in .init.text section, so they
> are freed after kernel init and are filtered out of BTF data
> because of that.
> 
> The solution is to place these functions under new section:
>    .init.bpf.preserve_type
> 
> And add 2 new symbols to mark that area:
>    __init_bpf_preserve_type_begin
>    __init_bpf_preserve_type_end
> 
> The code in pahole responsible for picking up the functions will
> be able to recognize functions from this section and add them to
> the BTF data and filter out all other .init.text functions.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Suggested-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

LGTM, applied, thanks! Also added a reference to the pahole commit
to the commit log so that this info doesn't get lost in the void
plus carried over prior Acks given nothing changed logically in the
patch.

P.s.: I've been wondering whether we also need to align the begin/end
symbols via ALIGN_FUNCTION() in case ld might realign to a different
boundary on later passes but this seems neither the case for .init.text
right now, likely since it doesn't matter for kallsyms data in our
particular case.
