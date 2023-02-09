Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D82690C54
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjBIPA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBIPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:00:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B632918148
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675954783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7LLDy2FZTjCrBjAsl2GvQAzDvSCeQe3+R/PFO2PwAto=;
        b=GbPzzYuMQ5Qx+Sle1ZakLBfiE9MlYEiKuH8e1zGSEaA/KY3a6HrqATw8Oo+sEMwZJzj3It
        pkDuVWjoIXqRfG/pyP7t9884lxSkX3r7rfBWaKXyyud595ijmpdGGPj7Vm8zW5X3LHOtmy
        7VulXGaR8Pj+MRkMfIlTnInyHeEEY+s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-f43Z3V3ZO2yZflrjpaTEfA-1; Thu, 09 Feb 2023 09:59:37 -0500
X-MC-Unique: f43Z3V3ZO2yZflrjpaTEfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B40793C025D7;
        Thu,  9 Feb 2023 14:59:36 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.18.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 335C8440BC;
        Thu,  9 Feb 2023 14:59:35 +0000 (UTC)
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
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCHv2 net-next 1/5] net: create nf_conntrack_ovs for ovs and
 tc use
References: <cover.1675810210.git.lucien.xin@gmail.com>
        <40147ea76fbcedaa477a68e4ef12399dd36782bc.1675810210.git.lucien.xin@gmail.com>
Date:   Thu, 09 Feb 2023 09:59:34 -0500
In-Reply-To: <40147ea76fbcedaa477a68e4ef12399dd36782bc.1675810210.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 7 Feb 2023 17:52:06 -0500")
Message-ID: <f7t8rh6hokp.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

> Similar to nf_nat_ovs created by Commit ebddb1404900 ("net: move the
> nat function to nf_nat_ovs for ovs and tc"), this patch is to create
> nf_conntrack_ovs to get these functions shared by OVS and TC only.
>
> There are nf_ct_helper() and nf_ct_add_helper() from nf_conntrak_helper
> in this patch, and will be more in the following patches.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

