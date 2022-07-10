Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B1156CD90
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 08:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGJGpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 02:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGJGpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 02:45:10 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C9413DC1
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 23:45:09 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AQgjoJcy1Zfs8AQgjo80s7; Sun, 10 Jul 2022 08:45:07 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 10 Jul 2022 08:45:07 +0200
X-ME-IP: 90.11.190.129
Message-ID: <311190f4-3eba-b2d2-1a5e-a00aad8d64dc@wanadoo.fr>
Date:   Sun, 10 Jul 2022 08:45:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net/9p: Initialize the iounit field during fid creation
Content-Language: en-US
To:     Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/07/2022 à 22:00, Tyler Hicks a écrit :
> Ensure that the fid's iounit field is set to zero when a new fid is
> created. Certain 9P operations, such as OPEN and CREATE, allow the
> server to reply with an iounit size which the client code assigns to the
> fid struct shortly after the fid is created in p9_fid_create(). Other
> operations that follow a call to p9_fid_create(), such as an XATTRWALK,
> don't include an iounit value in the reply message from the server. In
> the latter case, the iounit field remained uninitialized. Depending on
> allocation patterns, the iounit value could have been something
> reasonable that was carried over from previously freed fids or, in the
> worst case, could have been arbitrary values from non-fid related usages
> of the memory location.
> 
> The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> after the uninitialized iounit field resulted in the typical sequence of
> two getxattr(2) syscalls, one to get the size of an xattr and another
> after allocating a sufficiently sized buffer to fit the xattr value, to
> hit an unexpected ERANGE error in the second call to getxattr(2). An
> uninitialized iounit field would sometimes force rsize to be smaller
> than the xattr value size in p9_client_read_once() and the 9P server in
> WSL refused to chunk up the READ on the attr_fid and, instead, returned
> ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> the READ and this problem goes undetected there. However, there are
> likely other non-xattr implications of this bug that could cause
> inefficient communication between the client and server.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
> 
> Note that I haven't had a chance to identify when this bug was
> introduced so I don't yet have a proper Fixes tag. The history looked a
> little tricky to me but I'll have another look in the coming days. We
> started hitting this bug after trying to move from linux-5.10.y to
> linux-5.15.y but I didn't see any obvious changes between those two
> series. I'm not confident of this theory but perhaps the fid refcounting
> changes impacted the fid allocation patterns enough to uncover the
> latent bug?
> 
>   net/9p/client.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 8bba0d9cf975..1dfceb9154f7 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -899,6 +899,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
>   	fid->clnt = clnt;
>   	fid->rdir = NULL;
>   	fid->fid = 0;
> +	fid->iounit = 0;
>   	refcount_set(&fid->count, 1);
>   
>   	idr_preload(GFP_KERNEL);

Hi,
you could also kzalloc 'fid' and remove the memset, "= NULL" and "= 0".
This would be even more future proof and would save some LoC.

Just my 2c,

CJ
