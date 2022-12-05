Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB36437F6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiLEWWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLEWWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:22:04 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B192A14D1B;
        Mon,  5 Dec 2022 14:22:03 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p2JqR-000OjL-Ty; Mon, 05 Dec 2022 23:21:51 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p2JqR-000VX3-Nb; Mon, 05 Dec 2022 23:21:51 +0100
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <20221205181534.612702-1-Jason@zx2c4.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
Date:   Mon, 5 Dec 2022 23:21:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221205181534.612702-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26741/Mon Dec  5 09:16:09 2022)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 7:15 PM, Jason A. Donenfeld wrote:
> Since BPF's bpf_user_rnd_u32() was introduced, there have been three
> significant developments in the RNG: 1) get_random_u32() returns the
> same types of bytes as /dev/urandom, eliminating the distinction between
> "kernel random bytes" and "userspace random bytes", 2) get_random_u32()
> operates mostly locklessly over percpu state, 3) get_random_u32() has
> become quite fast.

Wrt "quite fast", do you have a comparison between the two? Asking as its
often used in networking worst case on per packet basis (e.g. via XDP), would
be useful to state concrete numbers for the two on a given machine.

> So rather than using the old clunky Tausworthe prandom code, just call
> get_random_u32(), which should fit BPF uses perfectly.
