Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD329D894
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfHZVfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:35:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:48372 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbfHZVfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:35:01 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Mdf-0003Lz-FR; Mon, 26 Aug 2019 23:34:59 +0200
Received: from [178.197.249.36] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Mdf-000Ff8-7Q; Mon, 26 Aug 2019 23:34:59 +0200
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index
 register
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
References: <20190824020028.6242-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <82f5e6c9-7a6d-7fa8-daa7-15e37daf216a@iogearbox.net>
Date:   Mon, 26 Aug 2019 23:34:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190824020028.6242-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25553/Mon Aug 26 10:32:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/19 4:00 AM, Jakub Kicinski wrote:
> From: Jiong Wang <jiong.wang@netronome.com>
> 
> NFP is using Local Memory to model stack. LM_addr could be used as base of
> a 16 32-bit word region of Local Memory. Then, if the stack offset is
> beyond the current region, the local index needs to be updated. The update
> needs at least three cycles to take effect, therefore the sequence normally
> looks like:
> 
>    local_csr_wr[ActLMAddr3, gprB_5]
>    nop
>    nop
>    nop
> 
> If the local index switch happens on a narrow loads, then the instruction
> preparing value to zero high 32-bit of the destination register could be
> counted as one cycle, the sequence then could be something like:
> 
>    local_csr_wr[ActLMAddr3, gprB_5]
>    nop
>    nop
>    immed[gprB_5, 0]
> 
> However, we have zero extension optimization that zeroing high 32-bit could
> be eliminated, therefore above IMMED insn won't be available for which case
> the first sequence needs to be generated.
> 
> Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!
