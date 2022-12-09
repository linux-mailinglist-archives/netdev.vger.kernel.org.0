Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5456482CF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLINeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLINeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:34:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFCE1C925
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 05:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670592796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qchRr+UtQnUzl9KXS1A+Z0YT74fM53B1Tjweo9Qk/fY=;
        b=OBDgeD4B00pL8jHm6tIV9dl9QdvqW+H6Wv5GPtMIZO8Bc5T6ItomwZG/a5XPtP2vnG9u3L
        b+0VSnDM71FcgbJSMsPOQYA/qG5L81XDj93pWetWSznj8fsDtSHzoVNguSDRaOMbfKsNv6
        o5/eeV7oavK2dD+IXyK1OQJ4S9S8Hw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-WKLOQkUhNzG6MW1ooLeJPA-1; Fri, 09 Dec 2022 08:33:12 -0500
X-MC-Unique: WKLOQkUhNzG6MW1ooLeJPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36FC0101A58E;
        Fri,  9 Dec 2022 13:33:11 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5543B2024CC0;
        Fri,  9 Dec 2022 13:33:09 +0000 (UTC)
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
Subject: Re: [PATCHv4 net-next 3/5] openvswitch: return NF_DROP when fails
 to add nat ext in ovs_ct_nat
References: <cover.1670518439.git.lucien.xin@gmail.com>
        <41f1f2b95985ef29f5440d717dc9007b71495d42.1670518439.git.lucien.xin@gmail.com>
Date:   Fri, 09 Dec 2022 08:33:06 -0500
In-Reply-To: <41f1f2b95985ef29f5440d717dc9007b71495d42.1670518439.git.lucien.xin@gmail.com>
        (Xin Long's message of "Thu, 8 Dec 2022 11:56:10 -0500")
Message-ID: <f7tr0x8hfcd.fsf@redhat.com>
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

> When it fails to allocate nat ext, the packet should be dropped, like
> the memory allocation failures in other places in ovs_ct_nat().
>
> This patch changes to return NF_DROP when fails to add nat ext before
> doing NAT in ovs_ct_nat(), also it would keep consistent with tc
> action ct' processing in tcf_ct_act_nat().
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

LGTM.

Acked-by: Aaron Conole <aconole@redhat.com>

