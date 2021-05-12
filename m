Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CDD37ED0C
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385057AbhELUGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:42004 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244479AbhELSWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 14:22:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620843707; h=Message-ID: Subject: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=TQGGOgj3JUABFf8IznwP+ZQFY3QR/fd0Xw3f1wk9rtI=; b=V7CSIQnB6g7RhZ81iqfwdKbKToPvgx+3O+cNrMBVQlGpG6aCe6I5t8LKGz/uWZxqXhOURYxj
 Fi/ooKREJ0gdTJRdvsfUopx55Fk7IJn4t+eKwFK2aSxAQc97TXTXry6j8nIiCcE3Nuh/Qkz9
 GZCTS1Twr9oUXcO5CyZS7+w27ik=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 609c1cac5702f8d96992d7ed (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 12 May 2021 18:21:32
 GMT
Sender: kapandey=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 17258C43145; Wed, 12 May 2021 18:21:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kapandey)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA245C4338A;
        Wed, 12 May 2021 18:21:30 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 12 May 2021 23:51:30 +0530
From:   kapandey@codeaurora.org
To:     willemb@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, sharathv@codeaurora.org,
        subashab@codeaurora.org
Subject: Panic in udp4_lib_lookup2
Message-ID: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
X-Sender: kapandey@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

We observed panic in udp_lib_lookup with below call trace:
[136523.743271]  (7) Call trace:
[136523.743275]  (7)  udp4_lib_lookup2+0x88/0x1d8
[136523.743277]  (7)  __udp4_lib_lookup+0x168/0x194
[136523.743280]  (7)  udp4_lib_lookup+0x28/0x54
[136523.743285]  (7)  nf_sk_lookup_slow_v4+0x2b4/0x384
[136523.743289]  (7)  owner_mt+0xb8/0x248
[136523.743292]  (7)  ipt_do_table+0x28c/0x6a8
[136523.743295]  (7) iptable_filter_hook+0x24/0x30
[136523.743299]  (7)  nf_hook_slow+0xa8/0x148
[136523.743303]  (7)  ip_local_deliver+0xa8/0x14c
[136523.743305]  (7)  ip_rcv+0xe0/0x134


We suspect this might happen due to below sequence:
Time                                                   CPU X             
                                                                          
                                    CPU Y
t0                                inet_release -> udp_lib_close -> 
sk_common_release -> udp_lib_unhash                            
inet_diag_handler_cmd -> udp_diag_destroy -> __udp_diag_destroy -> 
udp_lib_rehash

t1                                if(sk hashed)                          
                                                                          
                         if(sk hashed)
                                          sk_del_node_init_rcu
                                          
hlist_del_init_rcu(udp_portaddr_node)

t2                                                                       
                                                                          
                                        if(hslot2 != nhslot2)
                                                                          
                                                                          
                                                   
hlist_del_init_rcu(udp_portaddr_node)
                                                                          
                                                                          
                                                   
hlist_add_head_rcu(udp_portaddr_node)

t3                                sk is freed here

After t3 any use of that added udp_portaddr_node  will cause panic.
Same happens in udp4_lib_lookup2/udp6_lib_lookup2.

We dont have any reproducer for this, getting hit during random testing.

Pls let us know how this be resolved.

Thanks,
KP
