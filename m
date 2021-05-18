Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB6E388075
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244848AbhERTYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:24:17 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61813 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242872AbhERTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 15:24:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621365772; h=Message-ID: Subject: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=hLybCi/ygasfpNLeWHoitaWEbLPIEH/x3PtjDNAca8A=; b=GLE7zTfNe6mjIQ+eIKRW4H5AE3qFpqtRKDc0GMsPdyW+t2LHsO0Eom3Lq2P4aulo1rSMWmT2
 48SD7AZtejYncb95SUbsF1RPxVkt4XX3ONsiAMscr659I1FH5ZkfTld2VMnUpCNDmzSABn3I
 73GBK1ukGNP2MNcT4QsGVrxCZhU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60a413f68dd30e785f1a2c51 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 May 2021 19:22:30
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B34FC4323A; Tue, 18 May 2021 19:22:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17EC9C43217;
        Tue, 18 May 2021 19:22:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 May 2021 00:52:27 +0530
From:   sharathv@codeaurora.org
To:     tgraf@suug.ch, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Internal error: Oops  from inet_frag_find, when inserting a IP frag
 into a rhashtable
Message-ID: <997dfef63f2bd14acc2e478758bfc425@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We are observing BUG_ON from the __get_vm_area_node when processing the 
IP fragments in the context of NET_RX.

When the rehashing is in progress and an insertion is attempted, we may 
end up doing a bucket_table_alloc, which results in BUG_ON if in 
interrupt context.
Is it the case that the slow path code has to be executed only in the 
context of rht_deferred_worker and not in any other context? OR are 
these scenario's not anticipated and is a missed handling?

Please provide your suggestions on proceeding further with this issue.

  static struct vm_struct *__get_vm_area_node(unsigned long size,
            unsigned long align, unsigned long flags, unsigned long 
start,
            unsigned long end, int node, gfp_t gfp_mask, const void 
*caller)
  {
     struct vmap_area *va;
     struct vm_struct *area;

       BUG_ON(in_interrupt()); --> Point of panic.

Panic stack:

784.185010:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754253]@2 
Workqueue: events rht_deferred_worker
    784.185020:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754262]@2 
pstate: 00c00005 (nzcv daif +PAN +UAO)
    784.185032:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754274]@2 pc 
: __get_vm_area_node.llvm.17374696036975823682+0x1ac/0x1c8
    784.185041:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754283]@2 lr 
: __vmalloc_node_flags_caller+0xb4/0x170
    784.185046:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754289]@2 sp 
: ffffffc0104135a0
    784.185052:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754295]@2 
x29: ffffffc0104135a0 x28: ffffff82ccbcae50
    784.185060:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754303]@2 
x27: ffffff82eea8d3c0 x26: ffffff800ad044b0
    784.185067:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754311]@2 
x25: fffffffffffffffe x24: fffffffffffffff5
    784.185075:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754318]@2 
x23: 0000000000001000 x22: 0068000000000f13
    784.185082:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754326]@2 
x21: 00000000ffffffff x20: 0000000000008040
    784.185090:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754333]@2 
x19: 0000000000002b20 x18: ffffffc0103ad0c0
    784.185097:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754340]@2 
x17: 00000000e1ba4003 x16: d101500000cf012a
    784.185104:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754347]@2 
x15: 52d39bfeffbfebd0 x14: 3130393837363534
    784.185111:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754355]@2 
x13: 000000003b1ad624 x12: 0000000000000000
    784.185118:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754362]@2 
x11: 000000000000002e x10: 0000000000000600
    784.185126:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754369]@2 x9 
: 00000000002c022a x8 : 0000000000000101
    784.185133:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754376]@2 x7 
: f6da030000000000 x6 : ffffffe14adb3990
    784.185140:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754384]@2 x5 
: 0000000000002b20 x4 : fffffffebfff0000
    784.185148:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754391]@2 x3 
: ffffffc010000000 x2 : 0000000000000022
    784.185155:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754398]@2 x1 
: 0000000000000001 x0 : 0000000000009000
    784.185164:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754406]@2 
Call trace:
   784.185172:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754415]@2  
__get_vm_area_node.llvm.17374696036975823682+0x1ac/0x1c8
    784.185179:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754422]@2  
__vmalloc_node_flags_caller+0xb4/0x170
    784.185189:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754432]@2  
kvmalloc_node+0x40/0xa8
    784.185199:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754442]@2  
rhashtable_insert_rehash+0x84/0x264
    784.185206:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754449]@2  
rhashtable_try_insert+0x3fc/0x478
    784.185213:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754455]@2  
rhashtable_insert_slow+0x34/0x5c
    784.185223:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754466]@2  
__rhashtable_insert_fast+0x368/0x4f0
    784.185234:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754476]@2  
inet_frag_find+0x21c/0x2a8
    784.185244:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754486]@2  
nf_ct_frag6_gather+0x1f4/0x2a0
    784.185252:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754494]@2  
ipv6_defrag+0x58/0x7c
    784.185262:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754504]@2  
nf_hook_slow+0xa8/0x148
    784.185272:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754514]@2  
ipv6_rcv+0x80/0xe4
    784.185282:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754524]@2  
__netif_receive_skb+0x84/0x17c
    784.185290:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754532]@2  
process_backlog+0x15c/0x1b8
    784.185297:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754539]@2  
napi_poll+0x88/0x284
    784.185304:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754547]@2  
net_rx_action+0xbc/0x23c
    784.185314:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754557]@2  
__do_softirq+0x1e8/0x44c
    784.185325:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754567]@2  
__local_bh_enable_ip+0xb8/0xc8
    784.185333:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754576]@2  
local_bh_enable+0x1c/0x28
    784.185340:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754583]@2  
rhashtable_rehash_chain+0x12c/0x1ec
    784.185347:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754590]@2  
rht_deferred_worker+0x13c/0x200
    784.185357:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754600]@2  
process_one_work+0x2cc/0x568
    784.185365:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754607]@2  
worker_thread+0x28c/0x524
    784.185373:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754616]@2  
kthread+0x184/0x194
    784.185381:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754623]@2  
ret_from_fork+0x10/0x18


