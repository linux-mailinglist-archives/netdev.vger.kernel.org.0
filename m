Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1165690C72
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBIPJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBIPJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:09:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A944835A7
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675955316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P0Xw3R774e45LtHZbHn3IRcUYqWjBD+4se/1gf+6/qo=;
        b=FkFn9M/TP80dndMG87YoPLuRPTpijOKOUnwLxY1KqXs2ZZLd5H9Tn0WVONYzqol+e6NtVx
        bcDiFOQ7DxkQJbMOu7wIIt2zXyoDwzjpr8zGTUDR0ghqecUWNgxwfoQLAlA5sbMvGi14Mc
        vdoZWXWJf1betK3HS9J6FKbLQoz8PSI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-KAek5w9gN8u1doHUtsHl9Q-1; Thu, 09 Feb 2023 10:08:30 -0500
X-MC-Unique: KAek5w9gN8u1doHUtsHl9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E21C838041E3;
        Thu,  9 Feb 2023 15:08:29 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.18.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4878C1121315;
        Thu,  9 Feb 2023 15:08:29 +0000 (UTC)
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
Subject: Re: [PATCHv2 net-next 5/5] net: extract nf_ct_handle_fragments to
 nf_conntrack_ovs
References: <cover.1675810210.git.lucien.xin@gmail.com>
        <309974b4d45064b960003cca8b47dec66a0bb540.1675810210.git.lucien.xin@gmail.com>
Date:   Thu, 09 Feb 2023 10:08:28 -0500
In-Reply-To: <309974b4d45064b960003cca8b47dec66a0bb540.1675810210.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 7 Feb 2023 17:52:10 -0500")
Message-ID: <f7tv8kag9lf.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

> Now handle_fragments() in OVS and TC have the similar code, and
> this patch removes the duplicate code by moving the function
> to nf_conntrack_ovs.
>
> Note that skb_clear_hash(skb) or skb->ignore_df = 1 should be
> done only when defrag returns 0, as it does in other places
> in kernel.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

