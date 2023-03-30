Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0A6D0FEB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjC3UWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjC3UWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:22:04 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638EA40D3;
        Thu, 30 Mar 2023 13:22:03 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B62095FD0B;
        Thu, 30 Mar 2023 23:22:01 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680207721;
        bh=meOX4aPLT7ua2fm3pAcRz2CPeAaR40Mrt2950POSbpg=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=qG7GNsMjtkXbQFcQ7fVw4vaA+go5me0j2pKq/X6PeOnJazC5MTLXr6oC63qaExTkv
         uzSLbsCTYnKYroneJ8IxfM0WJYPS1lhBNCEpXp+9faTSdOWf0XJGYdiD+8zwwV/Sc4
         9nDIseWtAthUDHeAVAQMAHXE36ZGHQeXuZK8ilmhgK9rSPsQmYgBr5efnGGO4L/aa5
         KR+lrAgME/LSuNM46TLhrfB1x46LwVOqJk4g0gy7OO4/jFPpwq1OKhdW2s3e+JC0ZF
         53dnZ7uRnexDPUML9OEZI/217N3i8Ph+PjX2taUT3OqvPHNZRfTo2ctDBMhbNID0RW
         gYJ3AfzIYaapQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 23:22:01 +0300 (MSK)
Message-ID: <9fd06ca5-ace9-251d-34af-aca4db9c3ee0@sberdevices.ru>
Date:   Thu, 30 Mar 2023 23:18:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 2/4] vsock/vmci: convert VMCI error code to -ENOMEM
 on receive
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <pv-drivers@vmware.com>
References: <4d34fac8-7170-5a3e-5043-42a9f7e4b5b3@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <4d34fac8-7170-5a3e-5043-42a9f7e4b5b3@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 18:07:00 #21069213
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.03.2023 23:13, Arseniy Krasnov wrote:
> This adds conversion of VMCI specific error code to general -ENOMEM. It
> is needed, because af_vsock.c passes error value returned from transport
> to the user, which does not expect to get VMCI_ERROR_* values.

@Stefano, I have some doubts about this commit message, as it says "... af_vsock.c
passes error value returned from transport to the user ...", but this
behaviour is implemented only in the next patch. Is it ok, if both patches
are in a single patchset?

For patch 1 I think it is ok, as it fixes current implementation.

Thanks, Arseniy

> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  net/vmw_vsock/vmci_transport.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index 95cc4d79ba29..b370070194fa 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
>  	size_t len,
>  	int flags)
>  {
> +	ssize_t err;
> +
>  	if (flags & MSG_PEEK)
> -		return vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
> +		err = vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
>  	else
> -		return vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
> +		err = vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
> +
> +	if (err < 0)
> +		err = -ENOMEM;
> +
> +	return err;
>  }
>  
>  static ssize_t vmci_transport_stream_enqueue(
