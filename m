Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8875623A902
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHCO4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:56:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:47790 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgHCO4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:56:41 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2btE-0001Go-5d; Mon, 03 Aug 2020 16:56:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2btD-0006D4-Us; Mon, 03 Aug 2020 16:56:35 +0200
Subject: Re: [PATCH net] net/bpfilter: initialize pos in
 __bpfilter_process_sockopt
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Christoph Hellwig <hch@lst.de>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Rodrigo Madera <rodrigo.madera@gmail.com>
References: <20200730160900.187157-1-hch@lst.de>
 <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
 <03954b8f-0db7-427b-cfd6-7146da9b5466@iogearbox.net>
 <20200801194846.dxmvg5fmg67nuhwy@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c166831a-d506-3a4e-80ed-f0474079770d@iogearbox.net>
Date:   Mon, 3 Aug 2020 16:56:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200801194846.dxmvg5fmg67nuhwy@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25892/Sun Aug  2 17:01:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/20 9:48 PM, Alexei Starovoitov wrote:
> On Fri, Jul 31, 2020 at 02:07:42AM +0200, Daniel Borkmann wrote:
>> On 7/30/20 6:13 PM, Christian Brauner wrote:
>>> On Thu, Jul 30, 2020 at 06:09:00PM +0200, Christoph Hellwig wrote:
>>>> __bpfilter_process_sockopt never initialized the pos variable passed to
>>>> the pipe write.  This has been mostly harmless in the past as pipes
>>>> ignore the offset, but the switch to kernel_write no verified the
>>>
>>> s/no/now/
>>>
>>>> position, which can lead to a failure depending on the exact stack
>>>> initialization patter.  Initialize the variable to zero to make
>>>
>>> s/patter/pattern/
>>>
>>>> rw_verify_area happy.
>>>>
>>>> Fixes: 6955a76fbcd5 ("bpfilter: switch to kernel_write")
>>>> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
>>>> Reported-by: Rodrigo Madera <rodrigo.madera@gmail.com>
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>> Tested-by: Rodrigo Madera <rodrigo.madera@gmail.com>
>>>> ---
>>>
>>> Thanks for tracking this down, Christoph! This fixes the logging issue
>>> for me.
>>> Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
>>> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
>>
>> Applied to bpf & fixed up the typos in the commit msg, thanks everyone!
> 
> Daniel,
> why is it necessary in bpf tree?
> 
> I fixed it already in bpf-next in commit a4fa458950b4 ("bpfilter: Initialize pos variable")
> two weeks ago...

Several folks reported that with v5.8-rc kernels their console is spammed with
'bpfilter: write fail' messages [0]. Given this affected the 5.8 release and
the fix was a one-line change, it felt appropriate to route it there. Why was
a4fa458950b4 not pushed into bpf tree given it was affected there too? Either
way, we can undo the double pos assignment upon tree sync..

   [0] https://lore.kernel.org/lkml/20200727104636.nuz3u4xb7ba7ue5a@wittgenstein/
