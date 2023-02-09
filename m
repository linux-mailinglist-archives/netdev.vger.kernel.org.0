Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4934A690C55
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjBIPBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBIPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:01:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927A210AA0
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675954820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HYZHooik4OQXyRfMbJLGyXUsoABF5Bexw83FNvWudbU=;
        b=fH2UY/KC3mkfH943kUL9wUmRjSYmZO84JtTTlcm0bL5YLlC0dPu0nknQ9/iDFnXym47GPu
        AU9Dl1jKVKnwXeqznHPcs1NN6Y9gK3x7Rx8t7FPWpb8CxZ4fKk4gICSiCboYt1eZL2HymP
        Q5HqMbWzuFwWvELdbvpUreKmbb+h05Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-XAphGAXJOd-28R2i1aV1Hg-1; Thu, 09 Feb 2023 10:00:19 -0500
X-MC-Unique: XAphGAXJOd-28R2i1aV1Hg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C24638012F8;
        Thu,  9 Feb 2023 15:00:16 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.18.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D8862166B29;
        Thu,  9 Feb 2023 15:00:13 +0000 (UTC)
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
Subject: Re: [PATCHv2 net-next 2/5] net: extract nf_ct_skb_network_trim
 function to nf_conntrack_ovs
References: <cover.1675810210.git.lucien.xin@gmail.com>
        <0dd0765269b3c92d3856331738bbb464537804e1.1675810210.git.lucien.xin@gmail.com>
Date:   Thu, 09 Feb 2023 10:00:11 -0500
In-Reply-To: <0dd0765269b3c92d3856331738bbb464537804e1.1675810210.git.lucien.xin@gmail.com>
        (Xin Long's message of "Tue, 7 Feb 2023 17:52:07 -0500")
Message-ID: <f7t4jruhojo.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

> There are almost the same code in ovs_skb_network_trim() and
> tcf_ct_skb_network_trim(), this patch extracts them into a function
> nf_ct_skb_network_trim() and moves the function to nf_conntrack_ovs.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

