Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766A73908FE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhEYScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 14:32:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:50460 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbhEYScn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 14:32:43 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1llbpd-000GLy-Gy; Tue, 25 May 2021 20:31:09 +0200
Received: from [85.7.101.30] (helo=linux-2.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1llbpd-000Gni-B9; Tue, 25 May 2021 20:31:09 +0200
Subject: Re: linux-next: Tree for May 18 (kernel/bpf/bpf_lsm.o)
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <f816246b-1136-cf00-ff47-554d40ecfb38@infradead.org>
 <7955d9e2-a584-1693-749a-5983187e0306@infradead.org>
 <166d8da3-1f1f-c245-cc46-c40e12fb71ab@iogearbox.net>
Message-ID: <bd4198d8-f8d3-f2bb-0fcf-ecfb7ef41ca2@iogearbox.net>
Date:   Tue, 25 May 2021 20:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <166d8da3-1f1f-c245-cc46-c40e12fb71ab@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26181/Tue May 25 13:17:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On 5/25/21 8:26 PM, Daniel Borkmann wrote:
> On 5/25/21 7:30 PM, Randy Dunlap wrote:
>> On 5/18/21 10:02 AM, Randy Dunlap wrote:
>>> On 5/18/21 2:27 AM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20210514:
>>>>
>>>
>>> on i386:
>>> # CONFIG_NET is not set
>>>
>>> ld: kernel/bpf/bpf_lsm.o: in function `bpf_lsm_func_proto':
>>> bpf_lsm.c:(.text+0x1a0): undefined reference to `bpf_sk_storage_get_proto'
>>> ld: bpf_lsm.c:(.text+0x1b8): undefined reference to `bpf_sk_storage_delete_proto'
>>>
>>>
>>> Full randconfig file is attached.
>>>
>>
>> Hi,
>> I am still seeing this build error in linux-next-20210525.
> 
> Will take a look and get back.

This should resolve it:

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 5efb2b24012c..da471bf01b97 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -107,10 +107,12 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
  		return &bpf_inode_storage_get_proto;
  	case BPF_FUNC_inode_storage_delete:
  		return &bpf_inode_storage_delete_proto;
+#ifdef CONFIG_NET
  	case BPF_FUNC_sk_storage_get:
  		return &bpf_sk_storage_get_proto;
  	case BPF_FUNC_sk_storage_delete:
  		return &bpf_sk_storage_delete_proto;
+#endif /* CONFIG_NET */
  	case BPF_FUNC_spin_lock:
  		return &bpf_spin_lock_proto;
  	case BPF_FUNC_spin_unlock:
