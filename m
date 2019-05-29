Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918192E364
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfE2RiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:38:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:40684 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfE2Rh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:37:59 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hW2WS-0006Jy-Su; Wed, 29 May 2019 19:37:56 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hW2WS-0007q8-Ff; Wed, 29 May 2019 19:37:56 +0200
Subject: Re: [PATCH bpf-next v2] libbpf: prevent overwriting of log_level in
 bpf_object__load_progs()
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190529142641.888-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f0fce994-176f-2778-5511-1d8992a1abaa@iogearbox.net>
Date:   Wed, 29 May 2019 19:37:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190529142641.888-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29/2019 04:26 PM, Quentin Monnet wrote:
> There are two functions in libbpf that support passing a log_level
> parameter for the verifier for loading programs:
> bpf_object__load_xattr() and bpf_prog_load_xattr(). Both accept an
> attribute object containing the log_level, and apply it to the programs
> to load.
> 
> It turns out that to effectively load the programs, the latter function
> eventually relies on the former. This was not taken into account when
> adding support for log_level in bpf_object__load_xattr(), and the
> log_level passed to bpf_prog_load_xattr() later gets overwritten with a
> zero value, thus disabling verifier logs for the program in all cases:
> 
> bpf_prog_load_xattr()             // prog->log_level = attr1->log_level;
> -> bpf_object__load()             // attr2->log_level = 0;
>    -> bpf_object__load_xattr()    // <pass prog and attr2>
>       -> bpf_object__load_progs() // prog->log_level = attr2->log_level;
> 
> Fix this by OR-ing the log_level in bpf_object__load_progs(), instead of
> overwriting it.
> 
> v2: Fix commit log description (confusion on function names in v1).
> 
> Fixes: 60276f984998 ("libbpf: add bpf_object__load_xattr() API function to pass log_level")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>

That's better, applied, thanks!
