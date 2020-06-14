Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A2E1F875A
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgFNHDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:03:42 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:35680 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgFNHDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 03:03:41 -0400
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2020 03:03:40 EDT
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1jkMI9-0000V4-Ik; Sun, 14 Jun 2020 06:38:53 +0000
Received: from sleer.kot-begemot.co.uk ([192.168.3.72])
        by jain.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1jkMI7-0007NR-F6; Sun, 14 Jun 2020 07:38:53 +0100
Subject: Re: [PATCH] Fix null pointer dereference in vector_user_bpf
To:     Gaurav Singh <gaurav1086@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alex Dewar <alex.dewar@gmx.co.uk>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        "open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <20200614012001.18468-1-gaurav1086@gmail.com>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
Message-ID: <39158d22-9997-32ef-c599-7e6a98988a38@cambridgegreys.com>
Date:   Sun, 14 Jun 2020 07:38:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200614012001.18468-1-gaurav1086@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2020 02:19, Gaurav Singh wrote:
> The bpf_prog is being checked for !NULL after uml_kmalloc
> but later its used directly for example:
> bpf_prog->filter = bpf and is also later returned upon
> success. Fix this, do a NULL check and return right away.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>   arch/um/drivers/vector_user.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/um/drivers/vector_user.c b/arch/um/drivers/vector_user.c
> index c4a0f26b2824..0e6d6717bf73 100644
> --- a/arch/um/drivers/vector_user.c
> +++ b/arch/um/drivers/vector_user.c
> @@ -789,10 +789,12 @@ void *uml_vector_user_bpf(char *filename)
>   		return false;
>   	}
>   	bpf_prog = uml_kmalloc(sizeof(struct sock_fprog), UM_GFP_KERNEL);
> -	if (bpf_prog != NULL) {
> -		bpf_prog->len = statbuf.st_size / sizeof(struct sock_filter);
> -		bpf_prog->filter = NULL;
> +	if (bpf_prog == NULL) {
> +		printk(KERN_ERR "Failed to allocate bpf prog buffer");
> +		return NULL;
>   	}
> +	bpf_prog->len = statbuf.st_size / sizeof(struct sock_filter);
> +	bpf_prog->filter = NULL;
>   	ffd = os_open_file(filename, of_read(OPENFLAGS()), 0);
>   	if (ffd < 0) {
>   		printk(KERN_ERR "Error %d opening bpf file", -errno);
> 

Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
