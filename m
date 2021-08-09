Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4414B3E4EAF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhHIVl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:41:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:45990 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhHIVlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:41:55 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDD1Y-0000tj-Ff; Mon, 09 Aug 2021 23:41:32 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDD1Y-0007xF-7W; Mon, 09 Aug 2021 23:41:32 +0200
Subject: Re: [PATCH bpf-next v6 7/7] selftests/bpf: Add tests for XDP bonding
To:     Jussi Maki <joamaki@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        j.vosburgh@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        vfalico@gmail.com, Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-8-joamaki@gmail.com>
 <CAEf4BzZvojbuHseDbnqRUMAAfn-j4J+_3omWJw8=W6cTPmf0dw@mail.gmail.com>
 <CAHn8xcnBQhO_=YEO2cd_uCRYQDZkfQjW2r8aExu8=FYTi_=X5A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0bb57862-c8aa-0279-84ae-77f9cbdc47c2@iogearbox.net>
Date:   Mon, 9 Aug 2021 23:41:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHn8xcnBQhO_=YEO2cd_uCRYQDZkfQjW2r8aExu8=FYTi_=X5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26258/Mon Aug  9 10:18:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 4:24 PM, Jussi Maki wrote:
[...]
>>> +       if (!test__start_subtest("xdp_bonding_redirect_multi"))
>>> +               test_xdp_bonding_redirect_multi(&skeletons);
>>> +
>>> +out:
>>> +       xdp_dummy__destroy(skeletons.xdp_dummy);
>>> +       xdp_tx__destroy(skeletons.xdp_tx);
>>> +       xdp_redirect_multi_kern__destroy(skeletons.xdp_redirect_multi_kern);
>>> +
>>> +       libbpf_set_print(old_print_fn);
>>> +       if (root_netns_fd)
>>
>> technically, fd could be 0, so for fds we have if (fd >= 0)
>> everywhere. Also, if open() above fails, root_netns_fd will be -1 and
>> you'll still attempt to close it.
> 
> Good catch. Daniel, could you fix this when applying to be "if
> (root_netns_fd >= 0)"?

Yep, done now, I had to rebase due to 220ade77452c ("bonding: 3ad: fix the concurrency
between __bond_release_one() and bond_3ad_state_machine_handler()") which this series
here didn't take into account. Please double check.

Thanks everyone,
Daniel
