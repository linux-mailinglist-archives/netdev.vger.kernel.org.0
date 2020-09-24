Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D2A277581
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgIXPeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:34:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:60572 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgIXPeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:34:15 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLTG9-0007Pw-K1; Thu, 24 Sep 2020 17:34:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLTG9-000Enl-DZ; Thu, 24 Sep 2020 17:34:13 +0200
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: Verifying real time helper
 function
To:     bimmy.pujari@intel.com, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        kafai@fb.com, maze@google.com, ashkan.nikravesh@intel.com
References: <20200924022557.16561-1-bimmy.pujari@intel.com>
 <20200924022557.16561-2-bimmy.pujari@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d5f8a177-836e-9e04-a68c-1a57b2e80f26@iogearbox.net>
Date:   Thu, 24 Sep 2020 17:34:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200924022557.16561-2-bimmy.pujari@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 4:25 AM, bimmy.pujari@intel.com wrote:
> From: Bimmy Pujari <bimmy.pujari@intel.com>
> 
> Test xdping measures RTT from xdp using monotonic time helper.
> Extending xdping test to use real time helper function in order
> to verify this helper function.
> 
> Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
[...]
> diff --git a/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c b/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c
> new file mode 100644
> index 000000000000..85f9d9bfc5b7
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define REALTIME
> +

Instead of moving everything into xdping_kern.h and then adding a REALTIME define just
for doing ...

   +#ifdef REALTIME
   +	recvtime = bpf_ktime_get_real_ns();
   +#else
   +	recvtime = bpf_ktime_get_ns();
   +#endif

... why not simply just provide a small inline helper with the bpf_ktime_*() implementation
instead so we can avoid the ugly ifdef altogether..

> +#include "xdping_kern.h"
> diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/selftests/bpf/test_xdping.sh
> index c2f0ddb45531..3e357755b279 100755
> --- a/tools/testing/selftests/bpf/test_xdping.sh
[...]
