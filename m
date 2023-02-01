Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095426866F2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjBANbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjBANay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4B65EC0
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675258203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nxDy1Hr3yJjxMlq3cynMajtHSsgsLM5b2mNneaa0NWE=;
        b=RsZ+rfrMxvlRvUj3UXDh4TSb8pIRvwWsj30BaKW5YNSjQXeAN9g67/CaiaUt1UMh3r6dj6
        hinYKjkHpKHZfDG98J70N4EtVpRacPNw15QgdBazKJti2u0zsD9JJlInxkAzylFcGFWMd6
        nLdRTR60cCqkpHzrJ4BSYAuquKDerrM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-rrw4Lb3fNmOLeL0T1vsoJA-1; Wed, 01 Feb 2023 08:29:59 -0500
X-MC-Unique: rrw4Lb3fNmOLeL0T1vsoJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 354DB857F51;
        Wed,  1 Feb 2023 13:29:58 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.33.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EAF1401531B;
        Wed,  1 Feb 2023 13:29:56 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCHv4 net-next 03/10] openvswitch: use skb_ip_totlen in
 conntrack
References: <cover.1674921359.git.lucien.xin@gmail.com>
        <8ea56cf09856cedfa4c7a3f6e266c84723de8544.1674921359.git.lucien.xin@gmail.com>
Date:   Wed, 01 Feb 2023 08:29:55 -0500
In-Reply-To: <8ea56cf09856cedfa4c7a3f6e266c84723de8544.1674921359.git.lucien.xin@gmail.com>
        (Xin Long's message of "Sat, 28 Jan 2023 10:58:32 -0500")
Message-ID: <f7ttu05344s.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
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

> IPv4 GSO packets may get processed in ovs_skb_network_trim(),
> and we need to use skb_ip_totlen() to get iph totlen.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Aaron Conole <aconole@redhat.com>

