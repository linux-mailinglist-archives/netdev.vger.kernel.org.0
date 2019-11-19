Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06F5102EF2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKSWQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:16:45 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42462 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfKSWQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:16:44 -0500
Received: by mail-pg1-f194.google.com with SMTP id q17so12195016pgt.9;
        Tue, 19 Nov 2019 14:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kdSnoFs5QOPF1zFy2ec0MLYaOL4Y9PS1R5OSSbKxTXg=;
        b=NS8K30wuvVATVsDKdmgNbSU8rs9qSkJltS6TSr0KumrB05dwBoucVJ/mDx9LOzakf1
         coJUag2F2dexBoxTNFU8agvpdslhS/INK81F+8eJ5nQqvKTqqwk1dqc6HTe2z0/LuUrQ
         rOa/WRENPll2RLVGf7GhGZxVmkKN5AW5s27l7Zs3PDFT+IDPvF/oh+ZoVNblo5ncMP2o
         EAcLOVbykxJja5ARxSPvNvmO5tr1ZCiURoI8K3hLYbrRdVkLfIuLLGCuIP1hGWRxnUYZ
         gAJwqi0xsZqx+1qXAEQLsSCLiRwrtRZ8HTW11Gwaw+bzry+lmB4RnhQtuDEQsUrFVPzB
         /OQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kdSnoFs5QOPF1zFy2ec0MLYaOL4Y9PS1R5OSSbKxTXg=;
        b=psujkttycEKTKqO4GC4PGFQlhCJPHdGDPpkyhPeueG5NqeVUh2ah5vON65vbOrNAZn
         c4K6584pnQKdtkQrndOvFhjs3WSdrhGanO0DHMUCv4Mf2eed/JOQ1ZEXmi3ockTJStHD
         F+eDDJPCW3rBr62qRfH++lPfb52W8RGNifoT/R3q0FkmvNDGY0dtaZHhwf9ZtK/u9WY1
         +xTkCiLXtMPyGPGtVazWO4cFnv/sP4uxjCvSofTC/I7ayaWYWhsuhmUsKX/O0qPthRVf
         H+2Y/vJZDi8KdJexr6kiN2UG3RK8n8aP56Jk+ZJBTftnXqkigjglFuGuEalyh2elLZHv
         ZPVQ==
X-Gm-Message-State: APjAAAXnWPx1Ko7Y9a6vXOkIs/sGcx1tNN3XdOTVX5hV+BET4wFanBHC
        4wH1az7dZrymN1Qg9I0sLKA=
X-Google-Smtp-Source: APXvYqxW3frxUydGxeiIqouiCqG50A2+0ODVHlbo4pWLPB0bhqVxoJ7pyXxVaqSAbxz1FkkF642ANA==
X-Received: by 2002:a63:4415:: with SMTP id r21mr8391688pga.184.1574201803678;
        Tue, 19 Nov 2019 14:16:43 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:72f7])
        by smtp.gmail.com with ESMTPSA id k6sm24195617pfi.119.2019.11.19.14.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 14:16:42 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:16:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: fix call relocation offset calculation
 bug
Message-ID: <20191119221639.wygkmhkqp42fpana@ast-mbp.dhcp.thefacebook.com>
References: <20191119062151.777260-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119062151.777260-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 10:21:51PM -0800, Andrii Nakryiko wrote:
>  
> -static __attribute__ ((noinline))
> -int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
> +__attribute__ ((noinline))
> +int test_pkt_access_subprog2(int val, struct __sk_buff *skb)
>  {
>  	return skb->len * val;
>  }

Did you run test_progs -n 8?

Above breaks it with:
10: (61) r1 = *(u32 *)(r6 +40)
func 'test_pkt_access_subprog2' doesn't have 6-th argument
invalid bpf_context access off=40 size=4

The point of the subprog2 is to test the scenario where BTF disagress with llvm
optimizations.

