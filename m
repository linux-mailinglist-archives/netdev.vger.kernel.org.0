Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20747459C75
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 07:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhKWG7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 01:59:15 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43545 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233096AbhKWG7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 01:59:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UxtN0kx_1637650563;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxtN0kx_1637650563)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 14:56:04 +0800
Date:   Tue, 23 Nov 2021 14:56:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net/smc: Unbind buffer size from clcsock
 and make it tunable
Message-ID: <YZyQg23Vqes4Ls5t@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211122134255.63347-1-tonylu@linux.alibaba.com>
 <f08e1793-630f-32a6-6662-19edc362b386@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f08e1793-630f-32a6-6662-19edc362b386@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 04:08:37PM +0100, Karsten Graul wrote:
> On 22/11/2021 14:42, Tony Lu wrote:
> > SMC uses smc->sk.sk_{rcv|snd}buf to create buffer for send buffer or
> > RMB. And the values of buffer size inherits from clcsock. The clcsock is
> > a TCP sock which is initiated during SMC connection startup.
> > 
> > The inherited buffer size doesn't fit SMC well. TCP provides two sysctl
> > knobs to tune r/w buffers, net.ipv4.tcp_{r|w}mem, and SMC use the default
> > value from TCP. The buffer size is tuned for TCP, but not fit SMC well
> > in some scenarios. For example, we need larger buffer of SMC for high
> > throughput applications, and smaller buffer of SMC for saving contiguous
> > memory. We need to adjust the buffer size apart from TCP and not to
> > disturb TCP.
> > 
> > This unbinds buffer size which inherits from clcsock, and provides
> > sysctl knobs to adjust buffer size independently. These knobs can be
> > tuned with different values for different net namespaces for performance
> > and flexibility.
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> > ---
> 
> To activate SMC for existing programs usually the smc_run command or the
> preload library (both from the smc-tools package) are used.
> This commit introduced support to set the send and recv window sizes
> using command line parameters or environment variables:
> 
> https://github.com/ibm-s390-linux/smc-tools/commit/59bfb99c588746f7dca1b3c97fd88f3f7cbc975f

Hi Graul,

Thanks for your advice. We are using smc-tools, it is a very useful
tool, and we also use smc_run or LD_PRELOAD to help our applications to
replace with SMC from TCP.

There are some differences to use SMC in our environment. The followings
are our scenarios to use SMC:

1. Transparent acceleration

This approach is widely used in our environment. The main idea of
transparent acceleration is not to touch the applications. The
applications are usually pre-compiled and pre-packaged containers or
ECS, which means the binary and the binary needed environments, like
glibc and other libraries are bundled as bootstrap containers. So it is
hard to inject the smc_run or LD_PRELOAD into application's containers
runtime. 

To solve this issue, we developed a set of patches to replace the
AF_INET / SOCK_STREAM with AF_SMC / SMCPROTO_SMC{6} by configuration.
So that we can control acceleration in kernel without any other changes
in user-space, and won't break our application containers and publish
workflow. These patches are still improving for upstream.

2. Use SMC explicitly

This approach is very straightforward. Applications just create sockets
using AF_SMC and SMCPROTO_SMC{6}, and SMC works fine. 

However, most of applications don't want to bind tightly to single SMC
protocol. Most of them take into account compatibility, stability and
flexibility.

> Why another way to manipulate these sizes?
> Your solution would stop applications to set these values.

I didn't understand it clearly about stopping applications to set there
values.

IMHO, this RFC introduces two knobs for snd/rcvbuf. During the following
stages, applications can set these values as expected.

1. SMC module or per-net-namespace initialized:

sysctl_{w|r}mem_default initialized in smc_net_init() when current
net namespace initialized. The default values of SMC inherit from TCP,
and clcsock use TCP's configures.

2. create SMC socket:

smc_create() is called, and smc->sk.sk_{snd|rcv}buf are initialized from
per-netns earlier. There are no different from before. Except for
changing the values of TCP after SMC initialized, users can change them
with newly added two knobs.

3. applications call setsockopt() to modify SO_SNDBUF or SO_RCVBUF:

After smc_create() creates socket, applications can use setsockopt() to
change the snd/rcvbuf, which called sock_setsockopt() directly. If
fallback happened, setsockopt() would change clcsock's values.


In the end, we hope to provide a flexibility approach to change
SMC's buffer size only and don't disturb others. Sysctl are considered
as a better way to maintain and easy to use for users.

Thanks,
Tony Lu

