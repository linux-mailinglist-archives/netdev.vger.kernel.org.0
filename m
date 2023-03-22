Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A86C54CE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjCVTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCVTWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:22:17 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB3864219;
        Wed, 22 Mar 2023 12:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=aSIXHVTOX5f3Eh876Sshb43MNFMvCQIWb/uCrCD1+ks=; b=T0qQ0qNqT7QEzcfpPNnIFWnejg
        rZc6UoFHlRb3slAy8QuY67k08Y4c4QLmEK+FbpDOhEXJEAPIw/5p39kvMVfZLYDdYwroR9pc7JUVY
        LgRe8qPTNhF+R7htybaNEoyp0aWbjEptC5QGTgaS/d+gH+j8lndbJS5efxl5AzzQDVZMogDDPc48N
        J2yOYAkF36jmgx37rBaIIaZbprsfO/pgwn3l/p9iz2JOky4YHu2IGa5mcTC0umKL/D7+65rxInBVd
        jXJMAAgGEMvOH6gelk/55YqvWqqCrlxmq6vVEnRI7fFEhFsdOZUSvybKh2j7hiAld3UXMQ66QH1I5
        QFkEvvqQ==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pf41s-000Ikf-7L; Wed, 22 Mar 2023 20:21:48 +0100
Received: from [81.6.34.132] (helo=localhost.localdomain)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pf41r-000XzS-2y; Wed, 22 Mar 2023 20:21:47 +0100
Subject: Re: [PATCH bpf-next V2] xsk: allow remap of fill and/or completion
 rings
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?Q?Nuno_Gon=c3=a7alves?= <nunog@fr24.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320203732.222345-1-nunog@fr24.com>
 <CAJ8uoz2N4M+FB-ijzTrVm+91yhtqfKKwmPkxjefJrmSeJOocbg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <49bb8c3d-5eb0-4593-152c-8f7ea4669b08@iogearbox.net>
Date:   Wed, 22 Mar 2023 20:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2N4M+FB-ijzTrVm+91yhtqfKKwmPkxjefJrmSeJOocbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26851/Wed Mar 22 08:22:49 2023)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 12:13 PM, Magnus Karlsson wrote:
> On Mon, 20 Mar 2023 at 21:54, Nuno Gonçalves <nunog@fr24.com> wrote:
>>
>> The remap of fill and completion rings was frowned upon as they
>> control the usage of UMEM which does not support concurrent use.
>> At the same time this would disallow the remap of these rings
>> into another process.
>>
>> A possible use case is that the user wants to transfer the socket/
>> UMEM ownership to another process (via SYS_pidfd_getfd) and so
>> would need to also remap these rings.
>>
>> This will have no impact on current usages and just relaxes the
>> remap limitation.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
>> Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
>> ---
>>   net/xdp/xsk.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index 2ac58b282b5eb..e2571ec067526 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -1301,9 +1301,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>>          loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>>          unsigned long size = vma->vm_end - vma->vm_start;
>>          struct xdp_sock *xs = xdp_sk(sock->sk);
>> +       int state = READ_ONCE(xs->state);
>>          struct xsk_queue *q = NULL;
>>
>> -       if (READ_ONCE(xs->state) != XSK_READY)
>> +       if (state != XSK_READY && state != XSK_BOUND)
>>                  return -EBUSY;
>>
>>          if (offset == XDP_PGOFF_RX_RING) {
>> @@ -1314,9 +1315,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>>                  /* Matches the smp_wmb() in XDP_UMEM_REG */
>>                  smp_rmb();
>>                  if (offset == XDP_UMEM_PGOFF_FILL_RING)
>> -                       q = READ_ONCE(xs->fq_tmp);
>> +                       q = READ_ONCE(state == XSK_READY ? xs->fq_tmp :
>> +                                                          xs->pool->fq);
>>                  else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
>> -                       q = READ_ONCE(xs->cq_tmp);
>> +                       q = READ_ONCE(state == XSK_READY ? xs->cq_tmp :
>> +                                                          xs->pool->cq);

This triggers a build error:

   [...]
     CC      drivers/acpi/fan_attr.o
     CC      net/ipv6/syncookies.o
   ../net/xdp/xsk.c:1318:8: error: cannot take the address of an rvalue of type 'struct xsk_queue *'
                           q = READ_ONCE(state == XSK_READY ? xs->fq_tmp :
                               ^         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ../include/asm-generic/rwonce.h:50:2: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
           ^           ~
   ../include/asm-generic/rwonce.h:44:70: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                         ^ ~
   ../net/xdp/xsk.c:1321:8: error: cannot take the address of an rvalue of type 'struct xsk_queue *'
                           q = READ_ONCE(state == XSK_READY ? xs->cq_tmp :
                               ^         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ../include/asm-generic/rwonce.h:50:2: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
           ^           ~
   ../include/asm-generic/rwonce.h:44:70: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                         ^ ~
   2 errors generated.
   make[4]: *** [../scripts/Makefile.build:252: net/xdp/xsk.o] Error 1
   make[4]: *** Waiting for unfinished jobs....
     CC      fs/fs_types.o
     CC      kernel/bpf/offload.o
     AR      net/mpls/built-in.a
     CC      net/mptcp/subflow.o
   make[3]: *** [../scripts/Makefile.build:494: net/xdp] Error 2
   make[3]: *** Waiting for unfinished jobs....
