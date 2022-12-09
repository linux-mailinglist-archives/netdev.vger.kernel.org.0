Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C036482D2
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLINeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLINen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC1B5FBB9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 05:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670592827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHktNbh1g65n0/Qb+HD1Oq8LoL+A566CtK8m7jtZWBw=;
        b=iN0c474VhJwpyk4FKNnUstXapu9RFkruDlguatNfu8eUZq4rX9XvOWUQxKS4xXsutqa+FV
        umazpDRKJeFg/c6VaU90V/EHUd+YwJWiLiIO/bYlLMoO61HKjvqG5ouIpROLTMfdNQYx4M
        p1bzixokcL+VzNuebCDREEaIYPF1ML4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-a-W9HTY4M7aN2_MJL0YyqA-1; Fri, 09 Dec 2022 08:33:42 -0500
X-MC-Unique: a-W9HTY4M7aN2_MJL0YyqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 286FB101A528;
        Fri,  9 Dec 2022 13:33:41 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 683AC40C6EC2;
        Fri,  9 Dec 2022 13:33:40 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
References: <cover.1670518439.git.lucien.xin@gmail.com>
        <c973910b2d9741153cca02c14c6c105942d7f44a.1670518439.git.lucien.xin@gmail.com>
Date:   Fri, 09 Dec 2022 08:33:39 -0500
In-Reply-To: <c973910b2d9741153cca02c14c6c105942d7f44a.1670518439.git.lucien.xin@gmail.com>
        (Xin Long's message of "Thu, 8 Dec 2022 11:56:12 -0500")
Message-ID: <f7tmt7whfbg.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> There are two nat functions are nearly the same in both OVS and
> TC code, (ovs_)ct_nat_execute() and ovs_ct_nat/tcf_ct_act_nat().
>
> This patch creates nf_nat_ovs.c under netfilter and moves them
> there then exports nf_ct_nat() so that it can be shared by both
> OVS and TC, and keeps the nat (type) check and nat flag update
> in OVS and TC's own place, as these parts are different between
> OVS and TC.
>
> Note that in OVS nat function it was using skb->protocol to get
> the proto as it already skips vlans in key_extract(), while it
> doesn't in TC, and TC has to call skb_protocol() to get proto.
> So in nf_ct_nat_execute(), we keep using skb_protocol() which
> works for both OVS and TC contrack.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

