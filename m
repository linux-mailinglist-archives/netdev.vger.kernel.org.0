Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B2B5FB37F
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJKNgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 09:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJKNgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 09:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA6B5C96D
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665495399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eMAW77uZOD4rT0rFWgjnFFpVxcUsnK4rode4IEStoGg=;
        b=Y12XyOIYT4ZJO7o+uUeoWBRbVUaSurafYnj/JWPXW3vX/klDeHWd2rNP0FZLggQa4IRl2v
        QnAto4UIKvlh5I79wPNOLbXe+AYSEQ82Bgqd4uemv52a9Uob6/S2oj3GdmH3G3fRoLZ9JA
        T+cOBSpgEaQJFU54NDiuJtgH9FqcG5Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-eO4uFpebPAGHSLLnuindpA-1; Tue, 11 Oct 2022 09:36:36 -0400
X-MC-Unique: eO4uFpebPAGHSLLnuindpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D655C380406E;
        Tue, 11 Oct 2022 13:36:34 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F23EC8E405;
        Tue, 11 Oct 2022 13:36:34 +0000 (UTC)
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
Date:   Tue, 11 Oct 2022 09:36:33 -0400
In-Reply-To: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
        (Xin Long's message of "Thu, 6 Oct 2022 15:45:02 -0400")
Message-ID: <f7tczayh47y.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
> applies on a confirmed connection:
>
>   WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
>   RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
>   Call Trace:
>    <TASK>
>    nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
>    __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
>    __ovs_ct_lookup+0x72e/0x780 [openvswitch]
>    ovs_ct_execute+0x1d8/0x920 [openvswitch]
>    do_execute_actions+0x4e6/0xb60 [openvswitch]
>    ovs_execute_actions+0x60/0x140 [openvswitch]
>    ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
>    genl_family_rcv_msg_doit.isra.15+0x113/0x150
>    genl_rcv_msg+0xef/0x1f0
>
> which can be reproduced with these OVS flows:
>
>   table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
>   actions=ct(commit, table=1)
>   table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
>   actions=ct(commit, alg=ftp),normal
>
> The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
> attaching helper in later commit") where it somehow removed the check
> of nf_ct_is_confirmed before asigning the helper. This patch is to fix
> it by bringing it back.
>
> Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Hi Xin,

Looking at the original commit, I think this will read like a revert.  I
am doing some testing now, but I think we need input from Yi-Hung to
find out what the use case is that the original fixed.

-Aaron

