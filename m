Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29962CBC9
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiKPVA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiKPVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:00:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C367F4A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668632146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPti+yxgwhQAS4coWaRzF7Rb17MYo3d8okdAXtECqoE=;
        b=hWlaTCbHL4L6lmqOFL4L+xliqZo/rk6BU6kJRJh7CPjKLIlh6EmH3OF36ZD6R0jsIWvJDy
        hovWrzPXQNDk0i/9YNOXq6snr/0d58chwokGduWbiN1MTJeg8waVJprtYURaCJvzpzQPOi
        Zi4jmxpbJepzb2roG6dn9GYOF0bm4+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97--lNYNX_EMpCNG8KENODIzA-1; Wed, 16 Nov 2022 15:55:41 -0500
X-MC-Unique: -lNYNX_EMpCNG8KENODIzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58324185A792;
        Wed, 16 Nov 2022 20:55:40 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.19.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 797982027064;
        Wed, 16 Nov 2022 20:55:38 +0000 (UTC)
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
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 1/5] openvswitch: delete the unncessary
 skb_pull_rcsum call in ovs_ct_nat_execute
References: <cover.1668527318.git.lucien.xin@gmail.com>
        <83692c116f1d5d5ee03ce8386b32cced78c9a022.1668527318.git.lucien.xin@gmail.com>
Date:   Wed, 16 Nov 2022 15:55:36 -0500
In-Reply-To: <83692c116f1d5d5ee03ce8386b32cced78c9a022.1668527318.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 15 Nov 2022 10:50:53 -0500")
Message-ID: <f7to7t64o1j.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

> The calls to ovs_ct_nat_execute() are as below:
>
>   ovs_ct_execute()
>     ovs_ct_lookup()
>       __ovs_ct_lookup()
>         ovs_ct_nat()
>           ovs_ct_nat_execute()
>     ovs_ct_commit()
>       __ovs_ct_lookup()
>         ovs_ct_nat()
>           ovs_ct_nat_execute()
>
> and since skb_pull_rcsum() and skb_push_rcsum() are already
> called in ovs_ct_execute(), there's no need to do it again
> in ovs_ct_nat_execute().
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

LGTM

Acked-by: Aaron Conole <aconole@redhat.com>

