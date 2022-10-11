Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C335FB42B
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 16:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJKOGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJKOGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 10:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747FA95AC2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665497169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cH1ww0H+AelzkocMwAGHmagPzaIZq85kVhL0hJPUMXQ=;
        b=W1APLRGXyubwy/JSGC8iTTxxFohoXbTp8nXNF9kfB6uRyr16lVAcw/BbfrlO2bd1iI0WEo
        Ug0irVjKdjm7qOzMUGYkU64gOOEz/9GW2eUk2tJz+q7u55CNJX28ztCtia3QCDof9PzjKg
        C1K9Lc31fzMn5UzhURPugiL+U48dhmA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-AgI6P3GnOuqTwE-86-PEyQ-1; Tue, 11 Oct 2022 10:06:05 -0400
X-MC-Unique: AgI6P3GnOuqTwE-86-PEyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6529E3C02B78;
        Tue, 11 Oct 2022 14:06:04 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10A60112D412;
        Tue, 11 Oct 2022 14:06:04 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Florian Westphal <fw@strlen.de>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: add nf_ct_is_confirmed check
 before assigning the helper
References: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
        <f7tczayh47y.fsf@redhat.com>
Date:   Tue, 11 Oct 2022 10:06:03 -0400
In-Reply-To: <f7tczayh47y.fsf@redhat.com> (Aaron Conole's message of "Tue, 11
        Oct 2022 09:36:33 -0400")
Message-ID: <f7t8rlmh2us.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Conole <aconole@redhat.com> writes:

> Xin Long <lucien.xin@gmail.com> writes:
>
>> A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
>> applies on a confirmed connection:
>>
>>   WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
>>   RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
>>   Call Trace:
>>    <TASK>
>>    nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
>>    __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
>>    __ovs_ct_lookup+0x72e/0x780 [openvswitch]
>>    ovs_ct_execute+0x1d8/0x920 [openvswitch]
>>    do_execute_actions+0x4e6/0xb60 [openvswitch]
>>    ovs_execute_actions+0x60/0x140 [openvswitch]
>>    ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
>>    genl_family_rcv_msg_doit.isra.15+0x113/0x150
>>    genl_rcv_msg+0xef/0x1f0
>>
>> which can be reproduced with these OVS flows:
>>
>>   table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
>>   actions=ct(commit, table=1)
>>   table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
>>   actions=ct(commit, alg=ftp),normal
>>
>> The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
>> attaching helper in later commit") where it somehow removed the check
>> of nf_ct_is_confirmed before asigning the helper. This patch is to fix
>> it by bringing it back.
>>
>> Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
>> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>
> Hi Xin,
>
> Looking at the original commit, I think this will read like a revert.  I
> am doing some testing now, but I think we need input from Yi-Hung to
> find out what the use case is that the original fixed.

I'm also not able to reproduce the WARN_ON.  My env:

kernel: 4c86114194e6 ("Merge tag 'iomap-6.1-merge-1' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux")

Using current upstream OVS
I used your flows (adjusting the port names):

 cookie=0x0, duration=246.240s, table=0, n_packets=17, n_bytes=1130, ct_state=-trk,tcp,in_port=v0,tp_dst=2121 actions=ct(commit,table=1)
 cookie=0x0, duration=246.240s, table=1, n_packets=1, n_bytes=74, ct_state=+new+trk,tcp,in_port=v0,tp_dst=2121 actions=ct(commit,alg=ftp),NORMAL

and ran:

$ ip netns exec server python3 -m pyftpdlib -i 172.31.110.20 &
$ ip netns exec client curl ftp://172.31.110.20:2121

but no WARN_ON message got triggered.  Are there additional flows you
used that I am missing, or perhaps this should be on a different kernel
commit?

> -Aaron

